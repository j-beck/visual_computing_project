class BallOnPlate extends Mover{
  private final float r;
  private final Plate p;
  
  
  public BallOnPlate(float x, float z, float r, Plate p){
    super(x,-(p.getWidth()/2.0 + r),z);
    this.r = r;
    this.p = p;
  }
  
  void update(){
    super.update();
    //gravitational force
    PVector gravForce = (new PVector(sin(p.getZAngle()),0,-sin(p.getXAngle()))).mult(GRAVITY_CONST);
    
    //friction force
    float normalForce = cos(p.getXAngle())*cos(p.getZAngle());
    float mu = 0.1;
    float frictionMagnitude = normalForce * mu;
    
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
  
  void bounceCylinder(CylinderOnPlate c){
    PVector cylinderLoc2D = new PVector(c.location.x,0,c.location.z);
    PVector ballLoc2D = new PVector(this.location.x,0,this.location.z);
    if(ballLoc2D.dist(cylinderLoc2D) <= r + c.cylinderBaseSize){
      PVector normal = PVector.sub(ballLoc2D, cylinderLoc2D).normalize();
      velocity = PVector.sub(velocity, PVector.mult(normal, 2 * normal.dot(velocity)));
      
      //make sure that ball never enters cylinder.
      normal.mult(r + c.cylinderBaseSize);
      PVector help = PVector.add(cylinderLoc2D,normal);
      location.x = help.x;
      location.z = help.z;
    }
  }
  
  void draw(){
    translate(location.x,location.y,location.z);
    update();
    sphere(r);
    
  }
  
  
  
}