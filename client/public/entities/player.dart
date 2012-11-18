part of game;

class Player {
  Position position;
  Vector velocity, acceleration;
  Drawable image;
  
  Player(this.position, this.velocity, this.image);
  Player.origin(this.image){
    position = new Position.origin();
    velocity = new Vector.zero();
    acceleration = new Vector.zero();
  }
}
