part of waiting_for_godart;
class NetworkSocket {
  WebSocket _websock;
  String _port;
  String _domain;
  EventListener _handleMessage;
  static const String GAME_PATH = '/game';
  
  // https://github.com/dart-lang/dart-html5-samples/blob/master/web/websockets/basics/websocket_sample.dart
  NetworkSocket( this._domain, this._port, this._handleMessage ) {
    _websock = new WebSocket( 'ws://${_domain}:${_port}/${GAME_PATH}' );
    
    _websock.on.open.add((e) {
      print("WebSocket connected.");
    });

    _websock.on.close.add((e) {
      print("WARNING: WebSocket has closed.");
    });

    _websock.on.error.add((e) {
      print("WARNING: WebSocket has reported an error.");
    });

    _websock.on.message.add( _handleMessage );
  }
  
  void send( Map data ) {
    _websock.send( JSON.stringify( data ) );
  }
 
}
