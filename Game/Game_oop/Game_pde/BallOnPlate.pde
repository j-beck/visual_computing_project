class BallOnPlate extends Mover{
  private final float r;
  private final Plate p;
  
  
  public BallOnPlate(float x, float y, float r, Plate p){
    super(x,-(p.getWidth()/2.0 + r),y);
    this.r = r;
    this.p = p;
  }
  
  void update(){
    super.update();
    //gravitational force
    PVector gravForce = (new PVector(sin(p.getZAngle()),0,-sin(p.getXAngle()))).mult(GRAVITY_CONST);
    
    //friction force
    float frictionMagnitude;
    float normalForce = cos(p.getXAngle())*cos(p.getZAngle());
    float mu = 0.1;
    frictionMagnitude = normalForce * mu;
    
    PVector fricForce = velocity.get();
    fricForce.mult(-1);
    fricForce.normalize();
    fricForce.mult(frictionMagnitude);    
    
    float minmaxX = p.getHeight()/2.0;
    float minmaxZ = p.getDepth()/2.0;
    
    //it is important that bounce comes before the velocity changement.
    bounceX(-minmaxX,minmaxX);
    bounceZ(-minmaxZ,minmaxZ);
    
    velocity.add(gravForce).add(fricForce);   
    
  }
  
  void draw(){
    translate(location.x,location.y,location.z);
    update();
    sphere(r);
    
  }
  
  
  
}