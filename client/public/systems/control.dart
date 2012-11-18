part of system;

class Control extends System {
  CanvasElement canvas;
  
  Control() {
    canvas = Utilities.canvas();
  }
  
  void update() {
    canvas.on.keyPress.add((KeyboardEvent e) {
      for (var entity in entities) {
        if (e.keyCode == KeyCode.W) {
          entity.velocity.y = entity.velocity.y + 10
        } else if (e.keyCode == KeyCode.A) {
          entity.velocity.x = entity.velocity.x - 10
        } else if (e.keyCode == KeyCode.D) {
          entity.velocity.x = entity.velocity.x + 10
        }
      }
    });
  }
}
