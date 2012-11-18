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
	players []*Player
	in      chan string
	out     chan string
}

func (g Game) AddPlayer(player *Player) {
	g.players = append(game.players, player)
}

type GameUpdate struct {
	Msg string
}

type Page struct {
	Title string
}

var game Game
var lastClientId int

func init() {
	game = Game{
		players: make([]*Player, 0),
		in:      make(chan string),
		out:     make(chan string),
	}

	lastClientId = 0
}

/*
func run() {
	for {
		// broadcast
		select {
		case msg <- in:
		}
	}
}
*/

func handlePlayer(player *Player) {
	var data string
	for {
		err := websocket.JSON.Receive(player.Socket, data)
		if err != nil {
			websocket.JSON.Send(player.Socket, data)
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
	//go run()

	// run the web server
	err := http.ListenAndServe(":9001", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}
