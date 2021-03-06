part of system;

class Physics extends System{
    static const GROUND = 600;
    static int RIGHT;
    void tick(){
      this.entities.forEach((var p){
        if(p is Player){
           double delta = p.velocity.y;
           double deltaX = p.velocity.x;
            if(p.position.y + delta < GROUND && p.position.y + delta > -10){
              p.position.y += p.velocity.y;
              p.velocity.y += 1;
            }
            else{
              p.velocity.y = 0.0;
            }
            if(p.position.x + deltaX < RIGHT && p.position.x +deltaX > 0){
              p.position.x += deltaX;
            } else {
              p.velocity.x = 0.0;
            }
          }
      });
    }
}
