part of system;

class Render extends System {
  CanvasRenderingContext2D ctx;
  bool allLoaded;
  int count;
  double rotate = 1.0;
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
    //rotate += .01;
    entities.forEach((var E){
      if(E is Player){
        ctx.save();
        ctx.translate(E.position.x, E.position.y);
       // ctx.rotate(rotate);
        ctx.drawImage(E.image.image, -75,-100, 150, 200);
        ctx.fillText(E.name, E.position.x-20, E.position.y, 4);
        ctx.restore();
      }
      else{
        ctx.fillRect(10, 10, 100, 11);
      }
    });
  }
  
}
