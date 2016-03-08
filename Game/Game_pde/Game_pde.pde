void settings() {
  size(1000, 1000, P3D);
}

void setup() {
}

float xAngle = 0.0;
float zAngle = 0.0;

float MAX_ANGLE = PI/3;
float MAX_sensitivity = 50;

float sensitivity = 10;

void draw() {  
  background(150);

  directionalLight(50,50,60,0,100,0);
  ambientLight(200, 200, 200);

  translate(width/2, height/2, 0);
  rotateX(xAngle);
  rotateZ(zAngle);
  box(200, 20, 200);
}

void mouseDragged() {
  xAngle += -(mouseY - pmouseY)*PI*sensitivity/pow(10,4);
  zAngle += (mouseX - pmouseX)*PI*sensitivity/pow(10,4);

  xAngle = max (min(xAngle, MAX_ANGLE), -MAX_ANGLE);
  zAngle = max (min(zAngle, MAX_ANGLE), -MAX_ANGLE);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  sensitivity = min( sensitivity + e, MAX_sensitivity);
  sensitivity = max(1, sensitivity);
  System.out.println(sensitivity);
}