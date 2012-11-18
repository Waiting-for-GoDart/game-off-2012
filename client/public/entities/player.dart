part of game_logic;

class Player {
  Position position;
  Vector velocity, acceleration;
  Drawable image;
  int id;
  String name;

  Player(this.id, this.name, this.position, this.velocity, this.image);
  Player.origin(this.id, this.name){
    position = new Position.origin();
    velocity = new Vector.zero();
    acceleration = new Vector.zero();
  }
}
