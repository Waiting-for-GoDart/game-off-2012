library game;
import 'dart:html';

part 'Point.dart';
part 'Position.dart';
part 'Vector.dart';
part 'Player.dart';


void main() {
 Point p = new Point.zero();
 Point other = new Point(10, 10);
 var canv = document.query("#game");
 CanvasRenderingContext2D ctx = (canv as CanvasElement).getContext("2d");
 ctx.fillRect(0, 0, 10, 10);
 print(other-p);
}