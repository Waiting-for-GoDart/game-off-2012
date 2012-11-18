part of game_logic;
class Drawable {
  Function _callback;
  ImageElement _image;
  
  Drawable(String url, Function callback){
    _image = new ImageElement();
    _image.on.load.add((event)=> callback(_image));
    _image.src = url;
  }
  ImageElement get image => _image;
}
