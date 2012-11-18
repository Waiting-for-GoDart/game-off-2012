part of system;

class Control extends System {
  CanvasElement canvas;
  
  Control() {
    canvas = Utilities.canvas();
  }
  
  void update() {
    canvas.on.click.add((KeyboardEvent e) {
      entities.forEach((var element)=> updateEntity(e, element));
    });
  }
  
  void updateEntity(KeyboardEvent e, var entity) {

  }
}
