class Plate extends Object3D{
  private final float maxAngle = PI/3;
  private final float maxSensitivity = 50;
  private float xAngle = 0f;
  private float zAngle = 0f;
  private float sensitivity = 10;
  private final int h,w,d;

  Plate(int x, int y, int z, int h, int w, int d){
    super(x,y,z);
    this.h = h;
    this.w = w;
    this.d = d;
  }
  
  public float getHeight(){
    return h;
  }
  
  public float getDepth(){
    return d;
  }
  
  public float getWidth(){
    return w;
  }
  
  public float getXAngle(){
    return xAngle;
  }
  public float getZAngle(){
    return zAngle;
  }

  public void draw() {
        translate(location.x,location.y,location.z);
        rotateX(xAngle);
        rotateZ(zAngle);
        box(h, w, d);
  }

  public void changeSensitivity(MouseEvent event) {
    float e = event.getCount();
    sensitivity = min( sensitivity + e, maxSensitivity);
    sensitivity = max(1, sensitivity);
  }

  public void updateAngle() {
    xAngle += -(mouseY - pmouseY)*PI*sensitivity/pow(10,4);
    zAngle += (mouseX - pmouseX)*PI*sensitivity/pow(10,4);

    xAngle = max (min(xAngle, maxAngle), -maxAngle);
    zAngle = max (min(zAngle, maxAngle), -maxAngle);
    
  }
}