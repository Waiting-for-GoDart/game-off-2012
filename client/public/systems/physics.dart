part of system;

class Physics extends System{
    void tick(){
      this.entities.forEach((var E){
          if(E is Player){
            if(p.position.y < 500){
              p.position.y += p.velocity.y;
              if (p.velocity.y < 0) p.velocity.y += 1;
            }
          }
      });
    }
}
