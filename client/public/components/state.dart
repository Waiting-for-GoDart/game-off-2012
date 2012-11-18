part of game_logic;

class State {
  static final int AIRBORNE = 0;
  static final int GROUNDED = 1;
  static final int DEAD = 2;
  int state;
  
  State(int s) {
    state = s;
  }
  
  operator==(State otherState) {
    return otherState.state == this.state;
  }
}
