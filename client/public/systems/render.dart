part of system;

class Render extends System {
  CanvasRenderingContext2D ctx;
  bool allLoaded;
  int count;
  Render(this.ctx){
    entities = new Set();
    count = 0;
    allLoaded = false;
  }
  
  void addResource(String resourceURL){
    allLoaded = false;
    var entity = new Drawable(resourceURL, countUp);
    entities.add(entity);
  }
  
  void countUp(){
    count += 1;
    if(count == entities.length){
      allLoaded = true;
    }
  }
  
  render(){
    ctx.save();
    entities.forEach((var E){
      if(E is Player){
        ctx.fillRect(E.position.x, E.position.y, 10, 10);
      }
      else{
        ctx.fillRect(10, 10, 100, 11);
      }
    });
    ctx.restore();
  }
  
}
