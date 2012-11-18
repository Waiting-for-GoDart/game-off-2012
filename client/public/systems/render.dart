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
    entities.forEach((var E){
      ctx.drawImage(E.image.image, E.position.x, E.position.y, E.image.width, E.image.height);
    });
  }
  
}
