part of game_logic;

class Vector {
  double _x, _y;
  Vector(this._x, this._y);
  Vector.fromPoints(Point start, Point end){
    _x = end.x - start.x;
    _y = end.y - start.y;
  }
  Vector.zero(){
    _x = 0.0;
    _y = 0.0;
  }
  
  double get x => _x;
  double get y => _y;
  set x(double newX){
    _x = newX;
  }
  set y(double newY){
    _y = newY;
  }
  
  Vector operator+(Vector other) => new Vector(this.x + other.x, this.y + other.y);   
  Vector operator-(Vector other) => new Vector(this.x - other.x, this.y - other.y);   
  double dot(Vector other)=> this.x * other.x + this.y * other.y;
    
}
