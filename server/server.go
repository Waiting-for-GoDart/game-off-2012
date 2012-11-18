package main

import (
	"code.google.com/p/go.net/websocket"
	"html/template"
	"net/http"
	"strconv"
)

type Client struct {
	Socket *websocket.Conn
	id     int
}

type Player struct {
	*Client
	name string
}

type Game struct {
	Players []*Player
	In      chan *Packet
	Out     chan *Packet
}

func (g Game) AddPlayer(player *Player) {
	g.Players = append(game.Players, player)
}

type Page struct {
	Title string
}

type Packet struct {
	Player *Player
	Msg    string
	Count  int
}

var game Game
var lastClientId int

func init() {
	game = Game{
		Players: make([]*Player, 0),
		In:      make(chan *Packet),
		Out:     make(chan *Packet),
	}

	lastClientId = 0
}

func (g *Game) sendPackets() {
	for {
		select {
		case packet := <-g.Out:
			websocket.JSON.Send(packet.Player.Socket, packet.Msg)
		}
	}
}

func (g *Game) Run() {
	go g.sendPackets()

	for {
		select {
		case packet := <-g.In:
			// echo for now
			g.Out <- packet
		}
	}
}

func handlePlayer(player *Player) {
	var data string
	for {
		err := websocket.JSON.Receive(player.Socket, &data)
		if err != nil {
			packet := &Packet{
				Player: player,
				Msg:    data,
			}
			game.In <- packet
		}
	}
}

func handleClient(ws *websocket.Conn) {
	client := &Client{
		Socket: ws,
		id:     lastClientId,
	}
	lastClientId++

	player := &Player{
		Client: client,
		name:   "Player " + strconv.Itoa(lastClientId),
	}

	game.AddPlayer(player)

	handlePlayer(player)
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		t, err := template.ParseFiles("client/game.html")
		if err != nil {
			panic("template: " + err.Error())
		}
		t.Execute(w, &Page{Title: "Game"})
	})

	http.Handle("/game", websocket.Handler(handleClient))

	// run the main game server loop
	go game.Run()

	// run the web server
	err := http.ListenAndServe(":9001", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}
