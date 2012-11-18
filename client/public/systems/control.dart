part of system;

class Control extends System {
  CanvasElement canvas;
  Movement movementSystem;
  
  Control(Movement movement) {
    canvas = Utilities.canvas();
    movementSystem = movement;
  }
  
  void update() {
    canvas.on.keyDown.add((KeyboardEvent e) {
      for (var entity in entities) {}
    });
    
    
  }
  void updateEntity(KeyboardEvent e, var entity) {

  }
}
