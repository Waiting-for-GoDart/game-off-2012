part of waiting_for_godart;

class Game extends GameScreen {
  static final int VELOCITY_DELTA = 3;
  CanvasElement canv;
  TextAreaElement chatbox;
	CanvasRenderingContext2D ctx;
  NetworkSocket netsock;
  String name;
  int id;
  Obstacle ground;
  Player mainPlayer;
  List<Player> players;
  Render renderSystem;
  Physics physicsSystem;
  Control controlSystem;
  BackgroundRender bg;
  
  
    //Audio
    Uint8Array freqArray;
    AudioElement audioElement;
    AudioSourceNode audioSource;
    AudioContext audioContext;
    AnalyserNode analyzer;
    double alpha;



  Game(this.netsock, this.name, this.id, Map playerMap) {
		var canvas = document.query("#game");
		canv = canvas;
		chatbox = query('#chatOut');
		ctx = (canvas as CanvasElement).getContext("2d");
		Physics.RIGHT = canv.width;
 		physicsSystem = new Physics();
		controlSystem = new Control(canvas);
		renderSystem = new Render(ctx);
		
		               //AUDIO
		               
		               audioElement = query("#jamz");
		               audioContext = new AudioContext();
		               audioSource = audioContext.createMediaElementSource( audioElement );
		               analyzer = audioContext.createAnalyser();
		               analyzer.smoothingTimeConstant = 0.8;
		               audioSource.connect( analyzer, 0, 0 );
		               analyzer.connect( audioContext.destination, 0, 0);
		               alpha = 0.0;
		
	  bg = new BackgroundRender();
	  double size = PI * 10;
	  for(int i = 0; i < size; i++){
	    bg.generate((sin(i*PI/size)*255).toInt(), (sin(i*PI/size)*100).toInt(), (sin(i*PI/size)*155).toInt()+100);
	  }
	  int freqcount = size.toInt() + 1;
	  freqArray = new Uint8Array( freqcount );

	  loadEntities(playerMap);
  	 hideAll();
  	showGame();
  	audioElement.play();
  	run();
  }
  
  void loadEntities(Map playerMap) {
    players = new List<Player>();
    for (int i = 0; i < playerMap.length; i++) {
      var player = new Player.origin(i, playerMap[i]);
      player.image = new Drawable("public/horse.png", (var i){});
      players.add(player);
      physicsSystem.addEntity(player);
      renderSystem.addEntity(player);
    }
    mainPlayer = players[id];
    controlSystem.addEntity(mainPlayer);
    
    ground = new Obstacle.ground(canv);
    ground.image = new Drawable("public/clouds.png", (var i){});
    physicsSystem.addEntity(ground);
    //renderSystem.addEntity(ground);
  }
  
  void showGame( ) {
    GAME_SCREEN_ELEMENT.style
      ..display = 'inherit';
    PREGAME_SCREEN_ELEMENT.style
    ..display = 'inherit';
    query('#hostStart').style
    ..display = 'none';
  }
  
  void run() {
  		ctx.clearRect(0, 0, canv.width, canv.height);
  		if( audioElement.currentTime > 10 ) {
  		   if( alpha > 1 ) alpha = 1.0;
  		   analyzer.getByteFrequencyData( freqArray );
  		   bg.render(ctx, freqArray.getRange(0, freqArray.length ), audioElement.currentTime, alpha );
  	     ctx.setFillColorRgb(0, 0, 0);
  	     if( alpha < 1 ) alpha = alpha + 0.0005;
      }
  	  ctx.drawImage(ground.image.image, 0, Physics.GROUND, canv.width, canv.height-Physics.GROUND);
  	  //ctx.fillRect(0, Physics.GROUND, canv.width, canv.height);
			controlSystem.update(netsock);
			physicsSystem.tick();
			renderSystem.render();
			window.setTimeout(run, 10);
  }

  void recvNetworkMessage( Map m ) {
  	if (m.containsKey('keys')) {
  		handleKeysdown(m);
  	} else if ( m.containsKey( 'chat' ) ) {
  	  String msg = "${m['chat']}: ${m['msg']}\n";
      chatbox.addText( msg );
  	}
  }

  void handleKeysdown(Map m) {
		var playerId = m['playerid'];
		var player = players[playerId];
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
