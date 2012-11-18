part of game_logic;

class State {
  static final int AIRBORNE = 0;
  static final int GROUNDED = 1;
  static final int DEAD = 2;
  int _state;
  
  State(int s) {
    state = s;
  }
  
  operator==(State state) {
    return state == state.state;
  }
  
  int get state => _state;
  set state(int s) => _state = s;
}
