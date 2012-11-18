part of WaitingForGodart;
class NetworkSocket {
  WebSocket _websock;
  String _port;
  String _domain;
  static const String GAME_PATH = '/game';
  
  NetworkSocket( this._domain, this._port ) { }
}
