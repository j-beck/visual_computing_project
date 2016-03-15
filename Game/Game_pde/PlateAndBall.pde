class PlateAndBall {


  private final float maxAngle = PI/3;
  private final float maxSensitivity = 50;

	private final float gravityConstant = 0.0981;
	private final float normalForce = 1.0;
	private final float mu = 0.05;
	private final float frictionMagnitude = normalForce * mu;


  private float xAngle = 0f;
  private float zAngle = 0f;
  private float sensitivity = 10;


  private final int x,y,z,h,w,d;
  private final int radius;

  private PVector sphereC;
  private PVector velocity;
  private PVector gravityForce;
  private PVector frictionForce;


  PlateAndBall(int x, int y, int z, int h, int w, int d, int r){
    this.x = x;
    this.y = y;
    this.z = z;
    this.h = h;
    this.w = w;
    this.d = d;
	this.radius = r;

	sphereC = new PVector(0,-( r + w/2.0 ), 0);
	velocity = new PVector(0, 0, 0);
	gravityForce = new PVector(0, 0, 0);
	frictionForce = new PVector(0, 0, 0);
  }

  public void draw() {
	  pushMatrix();
    	translate(x,y,z);
    	rotateX(xAngle);
    	rotateZ(zAngle);

    	box(h, w, d);

		translate(sphereC.x, sphereC.y, sphereC.z);
			updateSphere();
			checkEdges();
			sphere(radius);
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

	private void updateSphere() {
		gravityForce.x = sin(zAngle) * gravityConstant;
		gravityForce.z = - sin(xAngle) * gravityConstant;

		frictionForce = velocity.get();
		frictionForce.mult(-1);
		frictionForce.normalize();
		frictionForce.mult(frictionMagnitude);

		sphereC.add(velocity.add(gravityForce).add(frictionForce));
	}
	private void checkEdges() {
		if(sphereC.x > h/2.0) {
			sphereC.x = h/2.0;
			velocity.x *= -1;
		}
		else if(sphereC.x < -h/2.0) {
			sphereC.x = -h/2.0;
			velocity.x *= -1;
		}
		if (sphereC.z > d/2.0) {
			sphereC.z = d/2.0;
			velocity.z *= -1;
		}
		else if (sphereC.z < -d/2.0) {
			sphereC.z = -d/2.0;
			velocity.z *= -1;
		}
	}

}
