abstract class Object3D {
  PVector location;
  
  abstract void draw();
  
  public Object3D(float x, float y, float z){
    this.location = new PVector(x,y,z);
  }
  
  public float getX(){
    return this.location.x;
  }
  public float getY(){
    return this.location.y;
  }
  public float getZ(){
    return this.location.z;
  }
  
}