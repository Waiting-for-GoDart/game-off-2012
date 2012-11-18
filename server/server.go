package main

import (
	"code.google.com/p/go.net/websocket"
	"fmt"
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

func (g *Game) AddPlayer(player *Player) {
	g.Players = append(g.Players, player)
}

type Page struct {
	Title string
}

type Packet struct {
	Player *Player
	JSON   JSONPacket
}

type JSONPacket struct {
	Message string
}

var game *Game
var lastClientId int

func init() {
	game = &Game{
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
			fmt.Printf("Sending %s\n", packet.JSON)
			websocket.JSON.Send(packet.Player.Socket, packet.JSON)
		}
	}
}

func (g *Game) Run() {
	go g.sendPackets()

	for {
		select {
		case packet := <-g.In:
			for _, player := range g.Players {
				broadcastPacket := &Packet{
					Player: player,
					JSON:   packet.JSON,
				}
				g.Out <- broadcastPacket
			}
		}
	}
}

func handlePlayer(player *Player) {
	game.AddPlayer(player)

	var data JSONPacket
	for {
		websocket.JSON.Receive(player.Socket, &data)
		packet := &Packet{
			Player: player,
			JSON:   data,
		}
		game.In <- packet
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

	http.Handle("/public/", http.StripPrefix("/public/", http.FileServer(http.Dir("client/public/"))))

	http.Handle("/game", websocket.Handler(handleClient))

	// run the main game server loop
	go game.Run()

	// run the web server
	err := http.ListenAndServe(":9001", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}
