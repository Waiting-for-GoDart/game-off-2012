part of waiting_for_godart;
class PreGame extends GameScreen {
  NetworkSocket netsock;
  int id;
  String name;
  var broadcastNames;
  TextAreaElement chatbox;
  PreGame(this.netsock, this.name, this.id, this.broadcastNames) {
    hideAll();
    showPreGame();
    chatbox = query( "#chatOut" );
    query( "#submitPregameChat" ).on.click.add( (e) {
      String msg = query("#inputbox").value;
      netsock.send( { 'chat': name, 'msg': msg } );
    });
  }
  
  void showPreGame() {
    query('#pregameScreen').style
    ..display = 'inherit';
    
    if( id == 0 ) {
      query("#hostStart").style
        ..visibility = 'inherit';
      
      query("#RACKCITYBITCH").on.click.add( startGame );
    }
  }
  
  void startGame( e ) {
    broadcastNames();
    print("STARTING GAME...");

    netsock.sendRaw( 'RACKRACKCITYBITCH' );
  }
  
  void recvNetworkMessage( Map m ) {
    if( m.containsKey( 'chat' ) ) {
      String msg = "${m['chat']}: ${m['msg']}\n";
      chatbox.addText( msg );
    }
  }
}
