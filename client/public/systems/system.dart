library system;

import 'dart:html';
import '../utilities.dart';
import '../game_logic.dart';
import 'dart:math';
part 'control.dart';
part 'render.dart';
part 'physics.dart';
part 'background_render.dart';


class System {
  Set entities;
  
  System() {
    entities = new Set();
  }
  
  void addEntity(var entity) {
    entities.add(entity);
  }
  
  void removeEntity(var entity) {
    entities.remove(entity);
  }
}
