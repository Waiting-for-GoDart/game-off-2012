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
	Id     int
}

type Player struct {
	*Client
	Name string
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
			fmt.Printf("Broadcasting '%s' to: %s\n", packet.JSON, packet.Player.Name)
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

	fmt.Printf("Created player %d\n", player.Name)

	var data JSONPacket
	for {
		websocket.JSON.Receive(player.Socket, &data)
		fmt.Printf("Received: %s\n", data)
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
		Id:     lastClientId,
	}
	lastClientId++
	fmt.Printf("Client connected: %d\n", client.Id)

	player := &Player{
		Client: client,
		Name:   "Player " + strconv.Itoa(lastClientId),
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
