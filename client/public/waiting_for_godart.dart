library waiting_for_godart;
import 'dart:html';
import 'dart:json';

part 'network_socket.dart';
part 'game_screen.dart';
part 'game.dart';
part 'login.dart';
part 'pre-game.dart';

class WaitingForGodart {
  NetworkSocket netsock;
  GameScreen curScreen;
  Game game;
  Login _login;
  PreGame _pregame;
  bool _isHost;
  int playerID;
  
  WaitingForGodart() {
    playerID = -1;
    _isHost = false;
    curScreen = null;
    netsock = new NetworkSocket( document.domain, '9001', handleMessage );
  }
  
  void handleMessage( MessageEvent e ) {
    
    if( curScreen == null ) { //CONNECT
      
      
      if( e.data == 'HOST' ) {
        _isHost = true;
        curScreen = _login = new Login( netsock, goPreGame, true );
      } else if( e.data == 'NOTHOST' ) {
        curScreen = _login = new Login( netsock, goPreGame, false );
      } else if( e.data == 'FULL' ) {
        error37();
      }
      
    } else if( e.data == 'RACKRACKCITYBITCH' ) { // START GAME
      if( playerID > -1 )
        curScreen = _game = new Game( netsock, playerID );
      else {
        netsock.close();
        error37()
      }
    } else if( e.data == '' )
      curScreen.recvNetworkMessage( msg );
    }
  }
  
  void goPreGame( e ) {
    
  }
  
  void serverFull() {
    print( "Server Full!" );
  }
   
}

void main() {
  var godart = new WaitingForGodart();
}
