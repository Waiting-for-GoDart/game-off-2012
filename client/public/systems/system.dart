library system;

import 'dart:html';
import '../utilities.dart';
import '../game.dart';
part 'control.dart';
part 'movement.dart';
part 'network.dart';
part 'render.dart';

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
