library game;
import 'dart:html';

part 'components/point.dart';
part 'components/position.dart';
part 'components/vector.dart';
part 'entities/player.dart';


void main() {
 Point p = new Point.zero();
 Point other = new Point(10, 10);
 var canv = document.query("#game");
 CanvasRenderingContext2D ctx = (canv as CanvasElement).getContext("2d");
 ctx.fillRect(0, 0, 10, 10);
 print(other-p);
}