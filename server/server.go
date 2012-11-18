package main

import (
	"code.google.com/p/go.net/websocket"
	"html/template"
	"net/http"
)

type Client struct {
	ws *websocket.Conn
	id int
}

type Player struct {
	Client
	name string
}

type Game struct {
	players []*Player
	in      chan string
	out     chan string
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

func handlePlayer(player *Player) {
	for {
		select {
		case packet := <-in:
		case packet := ws.JSON.Receive(ws, )
		case 
		}
	}

	var data JSONData
	ws.JSON.Receive(ws, &data)
}

func handleClient(ws *websocket.Conn) {
	client := &Client{
		ws: ws,
		id: lastClientId
	}
	lastClientId++

	player := &Player{
		name: "Player " + lastClientId,
		client: client
	}

	game.players = append(game.players, player)

	handlePlayer(player)
}
*/

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		t, err := template.ParseFiles("client/game.html")
		if err != nil {
			panic("template: " + err.Error())
		}
		t.Execute(w, &Page{Title: "Game"})
	})
	/*
		http.Handle("/game", websocket.Handler(handleClient))

		go run()
	*/
	err := http.ListenAndServe(":9001", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}
