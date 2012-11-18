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
  
  void update() {
    for (var entity in entities) {
        if (keyW == KEY_DOWN) {
          entity.velocity.y -= 10;
        }
        if (keyA == KEY_DOWN) {
          entity.velocity.x -= 10;
        }
        if (keyD == KEY_DOWN) {
          entity.velocity.x += 10;
        }
      }
    });
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
