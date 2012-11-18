library herp;
import 'dart:html';

class Utilities {
  static CanvasElement get canvas {
    return document.query("canvas");
  }
  
  static CanvasRenderingContext2D get context {
    var canvas = document.query('canvas');
    return canvas.getContext('2d');
  }
}
