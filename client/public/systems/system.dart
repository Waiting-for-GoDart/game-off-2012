library system;

import 'dart:html';
import '../utilities.dart';

part 'control.dart';
part 'movement.dart';
part 'network.dart';
part 'render.dart';

class System {
  Set<Entity> entities;
  
  System() {
    entities = new Set<Entity>();
  }
  
  void addEntity(Entity entity) {
    entities.add(entity);
  }
  
  void removeEntity(Entity entity) {
    entities.remove(entity);
  }
}
