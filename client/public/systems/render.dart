part of system;

class Render {
  List drawables;
  CanvasRenderingContext2D ctx;
  int count;
  Render(this.ctx){
    count = 0;
    drawables = new List();
    drawables.add(drawable);
  }
  void countUp(){
    count += 1;
    if(count == drawables.length){
      render();
    }
  }
  
  render(){
    for(int i = 0; i < drawables.length; i++){
      ctx.drawImage(drawables[i].image, 0, 0, 100, 100);
    }
  }
  
}
