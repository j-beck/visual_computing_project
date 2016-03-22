abstract class Mover extends Object3D{
  public static final float GRAVITY_CONST = .5;
    
  PVector velocity;
  
  
  public Mover(float x, float y, float z){
    super(x,y,z);
    velocity = new PVector(0,0,0);
  } 
  
  
  void update(){
    location.add(velocity);
  }
  
  Mover bounceX(float minX, float maxX){
    if(location.x < minX){
      location.x = minX;
      velocity.x *= -1;
    }else if(location.x > maxX){
      location.x = maxX;
      velocity.x *= -1;
    }
    return this;
  }
  
  Mover bounceY(float minY, float maxY){
    if(location.y < minY){
      location.y = minY;
      velocity.y *= -1;
    }else if(location.y > maxY){
      location.y = maxY;
      velocity.y *= -1;
    }
    return this;
  }
  
  Mover bounceZ(float minZ, float maxZ){
    if(location.z < minZ){
      location.z = minZ;
      velocity.z *= -1;
    }else if(location.z > maxZ){
      location.z = maxZ;
      velocity.z *= -1;
    }
    return this;
  }
  
}