void settings() {
  size(1000, 750, P3D);
}

Plate p;
BallOnPlate b,b2;
CylinderOnPlate c1, c2, c3;

float centerX, centerY, centerZ;

void setup() {
    centerX = width/2.0;
    centerY = 2*height/3;
    centerZ = 0;
    p = new Plate(width/2, 2*height/3, 0, 500, 20, 300);
    b = new BallOnPlate(0,0,12,p);
    b2 = new BallOnPlate(70,25,17,p);
    c1 = new CylinderOnPlate(-80,30,15,20,30);
    c2 = new CylinderOnPlate(50,80,25,20,30);
    c3 = new CylinderOnPlate(200,-30,15,20,30);
}

float x = 1;

void draw() {
  
  
  background(150);

  directionalLight(50,50,60,0,100,0);
  ambientLight(200, 200, 200);
  
  
  b.bounceCylinder(c1);
  b.bounceCylinder(c2);
  b.bounceCylinder(c3);
  b2.bounceCylinder(c1);
  b2.bounceCylinder(c2);
  b2.bounceCylinder(c3);

  p.draw();

  pushMatrix();
  pushMatrix();
  pushMatrix();
  pushMatrix();
  b.draw();
  popMatrix();
  b2.draw();
  popMatrix();
  c1.draw();
  popMatrix();
  c2.draw();
  popMatrix();
  c3.draw();
}

void mouseDragged() {

  p.updateAngle();
}

void mouseWheel(MouseEvent event) {

  p.changeSensitivity(event);
}