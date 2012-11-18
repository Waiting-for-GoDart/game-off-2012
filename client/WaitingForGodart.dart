//import 'dart:html';
import 'dart:json';
import 'dart:io';

class WaitingForGodart {
  WebSocket _ws;
  
  WaitingForGodart( String addr ) {
    _ws = new WebSocket( "ws://$addr" );
    StringInputStream stdinput = new StringInputStream(stdin);
    stdinput.onLine = () => _ws.send( JSON.stringify( { 'message':stdinput.readLine() }) );
    _ws.onmessage = (e) => print( e.data );
  }
  
}


void main() {
  WaitingForGodart wfgd = new WaitingForGodart( "127.0.0.1:9001" );
}
