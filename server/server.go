package main

import (
	"code.google.com/p/go.net/websocket"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"strconv"
)

const PlayerLimit = 20

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

func (g *Game) AddPlayer(player *Player) (success bool) {
	totalPlayers := len(g.Players)
	if totalPlayers >= PlayerLimit || gameStarted {
		// notify the player that server is full
		packet := &Packet{
			Player: player,
			Data:   "FULL",
		}
		websocket.Message.Send(player.Socket, packet.Data)
		return false
	}

	g.Players = append(g.Players, player)

	if totalPlayers == 1 {
		// notify the player they are host
		packet := &Packet{
			Player: player,
			Data:   "HOST",
		}
		websocket.Message.Send(player.Socket, packet.Data)
	} else {
		// notify the player they are NOT host
		packet := &Packet{
			Player: player,
			Data:   "NOTHOST",
		}
		websocket.Message.Send(player.Socket, packet.Data)
	}
	return true
}

type Page struct {
	Title string
}

type Packet struct {
	Player *Player
	Data   string
}

var game *Game
var lastClientId int
var gameStarted bool

func init() {
	game = &Game{
		Players: make([]*Player, 0),
		In:      make(chan *Packet),
		Out:     make(chan *Packet),
	}

	lastClientId = 0
	gameStarted = false
}

func (g *Game) sendPackets() {
	for {
		select {
		case packet := <-g.Out:
			log.Printf("Broadcasting '%s' to: %s\n", packet.Data, packet.Player.Name)
			websocket.Message.Send(packet.Player.Socket, packet.Data)
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
					Data:   packet.Data,
				}
				g.Out <- broadcastPacket
			}
		}
	}
}

func handlePlayer(player *Player) {
	success := game.AddPlayer(player)
	if !success {
		return
	}

	log.Printf("Created player %d\n", player.Name)

	var data string
	for {
		websocket.Message.Receive(player.Socket, &data)
		log.Printf("Received: %s\n", data)
		if match, _ := MatchString(".*RACKRACKCITYBITCH.*") {
			gameStarted = true
		}
		packet := &Packet{
			Player: player,
			Data:   data,
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
	log.Printf("Client connected: %d\n", client.Id)

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
