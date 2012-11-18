part of waiting_for_godart;

class Game extends GameScreen {
  static final int VELOCITY_DELTA = 3;

	CanvasRenderingContext2D ctx;
  NetworkSocket netsock;
  String name;
  int id;
  Player mainPlayer;
  List<Player> players;
  Render renderSystem;
  Physics physicsSystem;
  Control controlSystem;

  Game(this.netsock, this.name, this.id, Map playerMap) {
		var canvas = document.query("#game");
		ctx = (canvas as CanvasElement).getContext("2d");
 		physicsSystem = new Physics();
		controlSystem = new Control(canvas);
		renderSystem = new Render(ctx);
  	players = new List<Player>();
  	for (int i = 0; i < playerMap.length; i++) {
  		var player = new Player.origin(i, playerMap[i]);
  		players.add(player);
  		physicsSystem.addEntity(player);
  		renderSystem.addEntity(player);
  	}
  	mainPlayer = players[this.id];
  	controlSystem.addEntity(mainPlayer);
  	hideAll();
  	showGame();
  	run();
  }
  
  void showGame( ) {
    GAME_SCREEN_ELEMENT.style
      ..display = 'inherit';
  }
  
  void run() {
  		ctx.clearRect(0, 0, 500, 500);
			controlSystem.update(netsock);
			physicsSystem.tick();
			renderSystem.render();
			window.setTimeout(run, 10);
  }

  void recvNetworkMessage( Map m ) {
  	if (m.containsKey('keys')) {
  		handleKeysdown(m);
  	}
  }

  void handleKeysdown(Map m) {
		playerId = m['playerid'];
		player = players[playerId];
		for (var key in m['keys']) {
			if (key == 'W') {
	      player.velocity.y -= VELOCITY_DELTA;
	    } else if (key == 'A') {
	      player.velocity.x -= VELOCITY_DELTA;
	    } else if (key == 'D') {
	      player.velocity.x += VELOCITY_DELTA;
	    }
		}
  }
}
