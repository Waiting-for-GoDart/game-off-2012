import 'dart:html';
import 'dart:json';

class WaitingForGodart {
  WebSocket _ws;
  TextAreaElement _textarea;
  InputElement _input;
  
  WaitingForGodart( String addr ) {
    _ws = new WebSocket( "ws://$addr" );
    _textarea = query("#output");
    _input = query("#inputbox");
    query("#submit").on.click.add( (e) {
        var outmap = {'Message': _input.value };
        var jsonreq = JSON.stringify( outmap );
        print( jsonreq );
        _ws.send( jsonreq );
      }
    );
    _ws.on.open.add( (e) => print("connected") );
    _ws.on.close.add( (e) => print("closed") );
    _ws.on.error.add( (e) => print("error") );
    _ws.on.message.add( (e) => _textarea.addText( "${JSON.parse( e.data )['Message']}\n" )  );
  }
   
}


void main() {
  WaitingForGodart wfgd = new WaitingForGodart( "${document.domain}:9001/game" );
}
