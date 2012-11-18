part of system;

class Physics extends System{
    static const GROUND = 300;
    
    void tick(){
      this.entities.forEach((var E){
        if(E is Player){
           double delta = p.velocity.y;
           double deltaX = p.velocity.x;
            if(p.position.y + delta < GROUND && p.position.y + delta > 0){
              p.position.y += p.velocity.y;
              p.velocity.y += 1;
            }
            else{
              p.velocity.y = 0.0;
            }
            if(p.position.x + deltaX < 500 && p.position.x +deltaX > 0){
              p.position.x += deltaX;
            }
          }
      });
    }
}
