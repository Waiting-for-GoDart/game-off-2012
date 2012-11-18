part of game_logic;

class BoundingBox {
  Point topLeft;
  Point bottomRight;
  
  BoundingBox(this.topLeft, this.bottomRight);
  BoundingBox.fromPosition(Position p, int width, int height){
    topLeft = new Point(p.x - (width / 2), p.y - (height / 2));
    bottomRight = new Point(p.x + (width / 2), p.y + (height / 2));
  }
  Point get topRight => new Point(bottomRight.x, topLeft.y);
  Point get bottomLeft => new Point(topLeft.x, bottomRight.y);
}
