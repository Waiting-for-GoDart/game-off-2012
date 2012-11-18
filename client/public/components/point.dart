part of game_logic;

class Point {
  double _x, _y;
  Point(num x, num y){
    this._x = x.toDouble();
    this._y = y.toDouble();
  }
  Point.zero(){
    this._x = 0.0;
    this._y = 0.0;
  }
  
  double get x  => this._x;
  double get y => this._y;
  set x(double newX) =>_x = newX;
  set y(double newY)=> _y = newY;
  Point operator-(Point other) => new Point(this.x-other.x, this.y-other.y);
  Point operator+(Point other) => new Point(this.x+other.x, this.y+other.y);
  Point operator*(Point other) => new Point(this.x*other.x, this.y*other.y);
  String toString() => "{${this.x} ${this.y}}";
}
