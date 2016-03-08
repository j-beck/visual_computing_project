void settings() {
  size(1000, 1000, P3D);
}
    Plate p;

void setup() {
    p = new Plate(width/2, height/2, 0, 200, 20, 200);
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

class Plate {
	private final float maxAngle = PI/3;
	private final float maxSensitivity = 50;
	private float xAngle = 0f;
	private float zAngle = 0f;
	private float sensitivity = 10;
	private final int x,y,z,h,w,d;

	Plate(int x, int y, int z, int h, int w, int d){
		this.x = x;
		this.y = y;
		this.z = z;
		this.h = h;
		this.w = w;
		this.d = d;
	}

	public void draw() {
        pushMatrix();
		translate(x,y,z);
		rotateX(xAngle);
		rotateZ(zAngle);
		box(h, w, d);
        popMatrix();
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
