library game_logic;
import 'dart:html';
import 'dart:math';
import 'systems/system.dart';
part 'components/point.dart';
part 'components/position.dart';
part 'components/vector.dart';
part 'entities/player.dart';
part 'components/drawable.dart';

Random rand;
Render r;
Player p;
Physics physics;
Control keyboard;
BackgroundRender bg;
double control;

CanvasRenderingContext2D ctx;
void main(){
  control = 0.0;
  bg = new BackgroundRender();
  rand = new Random();
  double size = PI * 10;
  for(int i = 0; i < size; i++){
    bg.generate((sin(i*PI/size)*255).toInt(), (sin(i*PI/size)*100).toInt(), (sin(i*PI/size)*155).toInt()+100);
  }

  var canvas = document.query("#game");
  ctx = (canvas as CanvasElement).getContext("2d");
  physics = new Physics();
  Drawable d = new Drawable("horse.png", (var i){});
  keyboard = new Control(canvas);
  r = new Render(ctx);
  p = new Player.origin();
  p.position.x = 100.0;
  p.position.y = 80.0;
  p.image = d;
  r.addEntity(p);
  keyboard.addEntity(p);
  physics.addEntity(p);
  r.render();
  tick();
}

void tick(){
  keyboard.update();
  physics.tick();
  ctx.clearRect(0, 0, 500, 500);
  bg.render(ctx);
  r.render();
  window.setTimeout(tick, 100~/6);
}