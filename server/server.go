package main

import (
	"code.google.com/p/go.net/websocket"
	"html/template"
	"log"
	"net/http"
	"regexp"
	"strconv"
)

const PlayerLimit = 20

type Client struct {
	Socket *websocket.Conn
	Id     int
	Dead   bool
}

type Player struct {
	*Client
	Name string
}

type GameServer struct {
	players      []*Player
	in           chan *Packet
	out          chan *Packet
	lastClientId int
	started      bool
	Closed       chan bool
}

func (g *GameServer) NewPlayer(client *Client) *Player {
	player := &Player{
		Client: client,
		Name:   "Player " + strconv.Itoa(client.Id),
	}

	log.Printf("Created player %s\n", player.Name)

	totalPlayers := len(g.players)
	if totalPlayers >= PlayerLimit || g.started {
		// notify the player that server is full
		packet := &Packet{
			Player: player,
			Data:   "FULL",
		}
		websocket.Message.Send(client.Socket, packet.Data)
		return nil
	}

	g.players = append(g.players, player)
	if len(g.players) >= PlayerLimit {
		g.Closed <- true
	}

	packet := &Packet{
		Player: player,
		Data:   strconv.Itoa(client.Id),
	}
	websocket.Message.Send(client.Socket, packet.Data)

	return player
}

type Page struct {
	Title string
}

type Packet struct {
	Player *Player
	Data   string
}

func (g *GameServer) sendPackets() {
	for {
		select {
		case packet := <-g.out:
			client := packet.Player.Client
			if !client.Dead {
				log.Printf("Broadcasting '%s' to: %s\n", packet.Data, packet.Player.Name)
				err := websocket.Message.Send(client.Socket, packet.Data)
				if err != nil {
					client.Dead = true
				}
			}
		}
	}
}

func (g *GameServer) Run() {
	go g.sendPackets()

	for {
		select {
		case packet := <-g.in:
			for _, player := range g.players {
				broadcastPacket := &Packet{
					Player: player,
					Data:   packet.Data,
				}
				g.out <- broadcastPacket
			}
		}
	}
}

func (g *GameServer) handlePlayer(client *Client) {
	player := g.NewPlayer(client)
	if player == nil {
		return
	}

	var data string
	for {
		err := websocket.Message.Receive(player.Socket, &data)
		if err != nil {
			client.Dead = true
		}
		log.Printf("Received: %s\n", data)
		match, _ := regexp.MatchString(".*RACKRACKCITYBITCH.*", data)
		if match {
			g.started = true
			g.Closed <- true
		}
		packet := &Packet{
			Player: player,
			Data:   data,
		}
		g.in <- packet
	}
}

func (g *GameServer) HandleClient(ws *websocket.Conn) {
	// TODO: begin mutex?
	id := g.lastClientId
	client := &Client{
		Socket: ws,
		Id:     id,
	}
	g.lastClientId++
	// end mutex

	log.Printf("Client connected: %d\n", id)

	g.handlePlayer(client)
}

func handleClient(farm *ServerFarm) func(*websocket.Conn) {
	return func(ws *websocket.Conn) {
		server := farm.GetOpenServer()
		server.HandleClient(ws)
	}
}

func NewGameServer() *GameServer {
	return &GameServer{
		players:      make([]*Player, 0),
		in:           make(chan *Packet),
		out:          make(chan *Packet),
		lastClientId: 0,
		started:      false,
		Closed:       make(chan bool),
	}
}

type ServerFarm struct {
	servers      []*GameServer
	lastServerId int
}

func (sf *ServerFarm) StartNewServer() int {
	server := NewGameServer()
	// TODO: begin mutex?
	sf.servers = append(sf.servers, server)
	lastServerId := len(sf.servers) - 1
	sf.lastServerId = lastServerId
	// end mutex
	// run the server
	go server.Run()
	return lastServerId
}

func (sf *ServerFarm) GetOpenServer() *GameServer {
	// TODO: is this safe?
	return sf.servers[sf.lastServerId]
}

func (sf *ServerFarm) Run() {
	// startup a game server
	sf.StartNewServer()

	for {
		select {
		case <-sf.servers[sf.lastServerId].Closed:
			// our last open server closed, so startup another
			sf.StartNewServer()
		}
	}
}

func NewServerFarm() *ServerFarm {
	return &ServerFarm{
		servers:      make([]*GameServer, 0),
		lastServerId: -1,
	}
}

func main() {
	farm := NewServerFarm()
	go farm.Run()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		t, err := template.ParseFiles("client/game.html")
		if err != nil {
			panic("template: " + err.Error())
		}
		t.Execute(w, &Page{Title: "Game"})
	})

	// serve all resources under the client's public folder
	http.Handle("/public/", http.StripPrefix("/public/", http.FileServer(http.Dir("client/public/"))))

	http.Handle("/game", websocket.Handler(handleClient(farm)))

	// run the web server
	err := http.ListenAndServe(":9001", nil)
	if err != nil {
		panic("ListenAndServe: " + err.Error())
	}
}
