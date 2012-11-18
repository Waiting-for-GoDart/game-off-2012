part of system;

class Control extends System {
  CanvasElement canvas;
  
  Control() {
    canvas = Utilities.canvas();
  }
  
  void update() {
    canvas.on.click.add((KeyboardEvent e) {
      entities.forEach(updateEntity);
    });
  }
  
  void updateEntity(KeyboardEvent e, Entity entity) {

  }
}
