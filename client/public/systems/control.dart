part of system;

class Control extends System {
  static final int KEY_UP = 0;
  static final int KEY_DOWN = 1;

  CanvasElement canvas;
  int keyW, keyA, keyD;

  Control(this.canvas){
    document.on.keyDown.add((KeyboardEvent e) {
      if (isKeyA(e.keyCode)) {
        keyA = KEY_DOWN;
      } else if (iskeyD(e.keyCode)) {
        keyD = KEY_DOWN;
      } else if (isKeyW(e.keyCode)) {
        keyW = KEY_DOWN;
      }
    });

    document.on.keyUp.add((KeyboardEvent e) {
      if (isKeyA(e.keyCode)) {
        keyA = KEY_UP;
      } else if (isKeyD(e.keyCode)) {
        keyD = KEY_UP;
      } else if (isKeyW(e.keyCode)) {
        keyW = KEY_UP;
      }
    });
  }
  
  void update(NetSocket netsock) {
    for (var entity in entities) {
      var keysDown = new List<String>();

      if (keyW == KEY_DOWN) {
        keysDown.add('W');
      }
      if (keyA == KEY_DOWN) {
        keysDown.add('A');
      }
      if (keyD == KEY_DOWN) {
        keysDown.add('D');
      }

      if (keysDown.length > 0) {
        netsock.send( {
          'playerid': entity.id, 
          'keys': keysDown
        });
      }
    }
  }

  bool isKeyA(int keyCode) {
    return (keyCode == KeyCode.A || keyCode == 97);
  }

  bool isKeyD(int keyCode) {
    return (keyCode == KeyCode.D || keyCode == 100);
  }

  bool isKeyW(int keyCode) {
    return (keyCode == KeyCode.W || keyCode == 119);
  }
}
