library game_logic;
import 'dart:html';
import 'systems/system.dart';
part 'components/point.dart';
part 'components/position.dart';
part 'components/vector.dart';
part 'entities/player.dart';
part 'components/drawable.dart';

Render r;
Player p;
Physics physics;
Control keyboard;

CanvasRenderingContext2D ctx;
void main(){
  var canvas = document.query("#game");
  ctx = (canvas as CanvasElement).getContext("2d");
  physics = new Physics();
  keyboard = new Control(canvas);
  r = new Render(ctx);
  p = new Player.origin();
  p.position.x = 100.0;
  p.position.y = 80.0;
  r.addEntity(p);
  keyboard.addEntity(p);
  physics.addEntity(p);
  r.render();
  tick();
}

void tick(){
  ctx.clearRect(0, 0, 500, 500);
  r.render();
  window.setTimeout(tick, 10);
  keyboard.update();
}