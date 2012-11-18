library system;

import 'dart:html';
import '../utilities.dart';
import '../game_logic.dart';
part 'control.dart';
part 'movement.dart';
part 'network.dart';
part 'render.dart';
part 'physics.dart';

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
