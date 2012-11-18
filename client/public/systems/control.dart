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
      for (var entity in entities) {
        switch (e.keyCode) {
          case KeyCode.W:
            movementSystem.moveEntity(entity, Movement.UP);
            break;
          case KeyCode.A:
            movementSystem.moveEntity(entity, Movement.LEFT);
            break;
          case KeyCode.S:
            movementSystem.moveEntity(entity, Movement.DOWN);
            break;
          case KeyCode.D:
            movementSystem.moveEntity(entity, Movement.RIGHT);
            break;
          case KeyCode.SPACE:
            movementSystem.moveEntity(entity, Movement.JUMP);
            break;
        }
      }
    }
  }
  
  void updateEntity(KeyboardEvent e, Entity entity) {

  }
}
