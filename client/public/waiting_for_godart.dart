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
  Login login;
  PreGame pregame;
  
  WaitingForGodart() {
    curScreen = null;
    netsock = new NetworkSocket( document.domain, '9001', handleMessage );
    login = new Login( netsock );
    curScreen = login;
  }
  
  void handleMessage( MessageEvent e ) {
    if( curScreen != null ) {
      Map msg = JSON.parse( e.data );
      curScreen.recvNetworkMessage( msg );
    }
  }
   
}

void main() {
  var godart = new WaitingForGodart();
}
