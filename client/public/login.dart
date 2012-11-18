part of waiting_for_godart;
class Login extends GameScreen {
  NetworkSocket netsock;
  int id;
  Login( this.netsock, this.id ) {
    hideAll();
    showLogin();
  }
  
  void showLogin( ) {
    LOGIN_SCREEN_ELEMENT.style
      ..display = 'inherit';
    
    query("#loginInfoForm").style
      ..display = 'inherit';
    
    query("#loginConnectingMessage").style
      ..visibility = 'hidden';
    
    query("#submitLoginName").on.click.add( nameSubmitter );
  }
  
  void nameSubmitter( e ) {
    String name = query("#loginTextBoxName").value;
    if( name.length > 0 ) {
      netsock.send(
          { 
            'playerid' : id,
            'loginREQ' : name
          }
      );
    }
  }
  
  void recvNetworkMessage( Map m ) {
    if( m.containsKey( 'loginFail' ) && m['playerid'] == id ) {
      query("#duplicateNameError").style
        ..visibility = 'inherit';
    }
  }
}
