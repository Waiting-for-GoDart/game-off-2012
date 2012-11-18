library waiting_for_godart;
import 'dart:html';
import 'dart:json';
import 'game_logic.dart';

part 'network_socket.dart';
part 'game_screen.dart';
part 'game.dart';
part 'login.dart';
part 'pre-game.dart';

DivElement LOGIN_SCREEN_ELEMENT = query("#loginScreen");
DivElement PREGAME_SCREEN_ELEMENT = query("#pregameScreen");
DivElement GAME_SCREEN_ELEMENT = query("#gameScreen");

void hideAll() {
  LOGIN_SCREEN_ELEMENT.style
  ..display = 'none';
  PREGAME_SCREEN_ELEMENT.style
  ..display = 'none';
  GAME_SCREEN_ELEMENT.style
  ..display = 'none';
}

class WaitingForGodart {
  NetworkSocket netsock;
  GameScreen curScreen;
  bool _isHost, _firstMessage;
  int playerID;
  String name;
  RegExp _exp;
  Map playerNames;
  
  WaitingForGodart() {
    playerID = -1;
    name = null;
    _firstMessage = true;
    _isHost = false;
    curScreen = null;
    netsock = new NetworkSocket( document.domain, '9001', handleMessage );
    playerNames = new Map();
  }
  
  void handleMessage( MessageEvent e ) {
    print("in: ${e.data}");
    if( _firstMessage ) {
      if( e.data == 'FULL' ) { // GAME FULL OR GAME STARTED
        netsock.close();
        error37();
      } else {
        playerID = int.parse( e.data );
        _isHost = (playerID == 0);
        curScreen = new Login( netsock, playerID );
      }
      _firstMessage = false;
    } else if( e.data == 'RACKRACKCITYBITCH' ) { // START GAME
      if( playerID > -1 )
        curScreen = new Game( netsock, name, playerID, playerNames );
      else {
        netsock.close();
        error37();
      }
    } else { // OTHER
      Map msg = JSON.parse( e.data );
      
      if( _isHost ) {
        if( msg.containsKey( 'loginREQ' ) ) {
          if( ! playerNames.containsValue( msg['loginREQ'] ) ) {
            int playerid = msg['playerid'];
            playerNames[ playerid ] = msg['loginREQ'];
            netsock.send( { 'playerid': msg['playerid'], 
              'loginOK':true,
              'login':msg['loginREQ'] }
            );
          } else {
            netsock.send( { 'playerid': msg['playerid'], 
              'loginFail':true }
            );
          }
        }
        
      }
      
      if( msg.containsKey('PLAYER_NAME_UPDATE') ) {
        playerNames.clear();
        msg.forEach( (k,v) {
          if( k != 'PLAYER_NAME_UPDATE' ) {
            playerNames[ int.parse(k) ] = v;
          }
        });
      } else if( msg.containsKey( 'loginOK' ) && msg['playerid'] == playerID ) { // LOGIN OK
        name = msg['login'];
        curScreen = new PreGame( netsock, name, playerID, broadcastNames );
      } else { // PASS TO SCREEN
        if( curScreen != null )
          curScreen.recvNetworkMessage( msg );
        else
          print("ignoring data.");
      }
    }
  }
  
  void broadcastNames() {
    Map tmp = new Map();
    tmp['PLAYER_NAME_UPDATE'] = 'true';
    playerNames.forEach( (k,v) {
        tmp[ '$k' ] = v;
    });
    netsock.send(tmp);
  }
  
  void error37() {
    print( "error 37!" );
  }
   
}

void main() {
  hideAll();
  LOGIN_SCREEN_ELEMENT.style
  ..display = 'inherit';
  
  query("#loginInfoForm").style
  ..display = 'none';
  
  query("#loginConnectingMessage").style
  ..visibility = 'inherit';
  var godart = new WaitingForGodart();
}
