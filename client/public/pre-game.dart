part of waiting_for_godart;
class PreGame extends GameScreen {
  NetworkSocket netsock;
  int id;
  String name;
  PreGame(this.netsock, this.name, this.id) {
    hideAll();
    showPreGame();
  }
  
  void showPreGame() {
    query('#pregameScreen').style
    ..display = 'inherit';
  }
}
