void settings() {
  size(1000, 750, P3D);
}
    PlateAndBall p;

void setup() {
    p = new PlateAndBall(width/2, height/2, 0, 500, 20, 300, 12);
}

void draw() {
  background(150);

  directionalLight(50,50,60,0,100,0);
  ambientLight(200, 200, 200);

  p.draw();
}

void mouseDragged() {

  p.updateAngle();
}

void mouseWheel(MouseEvent event) {

  p.changeSensitivity(event);
}