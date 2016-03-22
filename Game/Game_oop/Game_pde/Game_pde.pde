void settings() {
  size(1000, 750, P3D);
}

Plate p;
BallOnPlate b,b2;

void setup() {
    p = new Plate(width/2, 2*height/3, 0, 500, 20, 300);
    b = new BallOnPlate(0,0,12,p);
    b2 = new BallOnPlate(70,25,17,p);
}

void draw() {
  background(150);

  directionalLight(50,50,60,0,100,0);
  ambientLight(200, 200, 200);

  p.draw();
  pushMatrix();
  b.draw();
  popMatrix();
  b2.draw();
}

void mouseDragged() {

  p.updateAngle();
}

void mouseWheel(MouseEvent event) {

  p.changeSensitivity(event);
}