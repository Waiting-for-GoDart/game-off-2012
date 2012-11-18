part of game_logic;

class Position {
  Point p;
  Position(this.p);
  Position.origin(){
    p = new Point.zero();
  }
  double get x => p.x;
  double get y => p.y;
  
  set x(double newX) => p.x = newX;
  set y(double newY) => p.y = newY;
  
  Point get pos => p;
  
}
