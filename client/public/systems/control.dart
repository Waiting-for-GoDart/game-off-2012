part of system;

class Control extends System {
  CanvasElement canvas;
  
  Control(this.canvas){
    update();
  }
  
  void update() {
    document.on.keyPress.add((KeyboardEvent e) {
      for (var entity in entities) {
        if (e.keyCode == KeyCode.W || e.keyCode == 119) {
          entity.velocity.y -= 10;
        } else if (e.keyCode == KeyCode.A || e.keyCode == 97) {
          entity.velocity.x -= 10;
        } else if (e.keyCode == KeyCode.D || e.keyCode == 100) {
          entity.velocity.x += 10;
        }
      }
    });
  }
}
