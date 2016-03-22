
class ClosedCylinder{

	private final float cylinderBaseSize;
	private final float cylinderHeight;
	private final int cylinderResolution;

	private final PShape openCylinder;
	private PShape topDisk;
	private PShape botDisk;

	ClosedCylinder (float cylinderBaseSize, float cylinderHeight, int cylinderResolution) {
		this.cylinderBaseSize = cylinderBaseSize;
		this.cylinderHeight = cylinderHeight;
		this.cylinderResolution = cylinderResolution;


		float angle;
		float[] x = new float[cylinderResolution + 1];
		float[] y = new float[cylinderResolution + 1];
		//get the x and y position on a circle for all the sides
		for(int i = 0; i < x.length; i++) {
			angle = (TWO_PI / cylinderResolution) * i;
			x[i] = sin(angle) * cylinderBaseSize;
			y[i] = cos(angle) * cylinderBaseSize;
		}
		openCylinder = createShape();
		openCylinder.beginShape(QUAD_STRIP);
		//draw the border of the cylinder
		for(int i = 0; i < x.length; i++) {
			openCylinder.vertex(x[i], y[i] , 0);
			openCylinder.vertex(x[i], y[i], cylinderHeight);
		}
		openCylinder.endShape();

		topDisk = createShape();
		topDisk.beginShape(TRIANGLES);
		for(int i = 0; i < x.length-1; i++) {
			topDisk.vertex(x[i], y[i], cylinderHeight);
			topDisk.vertex(0, 0, cylinderHeight);
			topDisk.vertex(x[i+1], y[i+1], cylinderHeight);
		}
		topDisk.endShape();

		botDisk = createShape();
		botDisk.beginShape(TRIANGLES);
		for(int i = 0; i < x.length-1; i++) {
			botDisk.vertex(x[i], y[i], 0);
			botDisk.vertex(0, 0, 0);
			botDisk.vertex(x[i+1], y[i+1], 0);
		}
		botDisk.endShape();
	}

	void draw() {
		shape(openCylinder);
		shape(topDisk);
		shape(botDisk);
	}

}
