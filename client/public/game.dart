library game;
import 'dart:html';
import 'systems/system.dart';
part 'components/point.dart';
part 'components/position.dart';
part 'components/vector.dart';
part 'entities/player.dart';
part 'components/drawable.dart';

void main() {
  var canv = document.query("#game");
  CanvasRenderingContext2D ctx = (canv as CanvasElement).getContext("2d");
   
  var renderer = new Render(ctx);
}
