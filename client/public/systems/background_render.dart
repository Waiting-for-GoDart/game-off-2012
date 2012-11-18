part of system;

class BackgroundRender {
  List colorSequence;
  int shiftAmount;
  BackgroundRender(){
    shiftAmount = 0;
    colorSequence = new List();
  }
  generate(int r, int g, int b){
    colorSequence.add(new Color(r,g,b));
  }
  
  render(CanvasRenderingContext2D ctx){
    ctx.save();
    ctx.translate(0 , 0);
    for(int i = 0; i < colorSequence.length; i++){
      ctx.setFillColorRgb(colorSequence[i].r, colorSequence[i].g, colorSequence[i].b);
      ctx.fillRect(i*40-40, 0, 40, 500);
    }
    if(shiftAmount % 4== 0){
      var c = colorSequence.removeAt(0);
      colorSequence.addLast(c);
    }
    shiftAmount++;
    ctx.restore();
  }
  
}

class Color{
  int r, g, b;
  Color(this.r, this.g, this.b);
}
