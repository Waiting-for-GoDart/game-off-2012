part of game_logic;
class Obstacle {
  BoundingBox box;
  Obstacle(this.box);
  Obstacle.ground(CanvasElement canv){
    Point topLeft = new Point(0, Physics.GROUND);
    Point bottomRight = new Point(Physics.RIGHT, canv.height);
    box = new BoundingBox(topLeft, bottomRight);
  }
  Point get position => new Point((this.box.bottomRight.x - this.box.topLeft.x)~/2 + this.box.topLeft.x,
      (this.box.bottomRight.y - this.box.topLeft.y)~/2 + this.box.topLeft.y );
}
