part of game;

class Position {
  Point p;
  Position(this.p);
  Position.origin(){
    p = new Point.zero();
  }
  double get x => p.x;
  double get y => p.y;
  Point get pos => p;
  
}
