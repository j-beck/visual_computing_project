/**
*	A non-movable closed cylinder, placed on a Plate
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-03-27
*/
class CylinderOnPlate {

	private final 	float 	baseRadius;
	private final 	float 	height;
	private final 	int 	resolution;

	private final 	PShape 	openCylinder;
	private final	PShape 	topDisk;
	private final	PShape 	botDisk;

	private final	PVector location;

	private			Plate	plate;


	/**
	*	Build a CylinderOnPlate
	*
	*	@param baseRadius
	*		the radius of the base
	*	@param height
	*		the height of the cylinder (the distance between the two disks)
	*	@param resolution
	*		the resolution of the cylider, i.e. the number of polygons constituing the disks or the shape
	*	@param plate
	*		the plate the cylider is to be placed on
	*	@param xCenter
	*		the relative location of the cylinder from the center of the plate on the x-axis
	*	@param zCenter
	*		the relative location of the cylinder from the center of the plate on the z-axis
	*/
	CylinderOnPlate (float baseRadius, float height, int resolution, Plate plate, float xCenter, float zCenter) {
		this.baseRadius	= baseRadius;
		this.height		= height;
		this.resolution	= resolution;
		this.location	= new PVector(xCenter, -plate.getWidth()/2.0 , zCenter);

		this.plate = plate;
		// Build of the open cylinder and the two disks

		float angle;
		float[] x = new float[resolution + 1];
		float[] z = new float[resolution + 1];
			//get the x and y position on a circle for all the sides
		for(int i = 0; i < x.length; i++) {
			angle = (TWO_PI / resolution) * i;
			x[i] = sin(angle) * baseRadius;
			z[i] = cos(angle) * baseRadius;
		}
		// Build of the open cylinder
		openCylinder = createShape();
		openCylinder.beginShape(QUAD_STRIP);
			//specifies the rectangles borders of the open cylinder
		for(int i = 0; i < x.length; i++) {
			openCylinder.vertex(x[i], 0 , z[i]);
			openCylinder.vertex(x[i], -height, z[i]);
		}
		openCylinder.endShape();

		// Build of the top disk
		topDisk = createShape();
		topDisk.beginShape(TRIANGLES);
			//specifies the triangles constituting the disk
		for(int i = 0; i < x.length-1; i++) {
			topDisk.vertex(x[i], -height, z[i]);
			topDisk.vertex(0, -height, 0);
			topDisk.vertex(x[i+1], -height, z[i+1]);
		}
		topDisk.endShape();

		// Build of the bottom disk
		botDisk = createShape();
		botDisk.beginShape(TRIANGLES);
			//specifies the triangles constituting the disk
		for(int i = 0; i < x.length-1; i++) {
			botDisk.vertex(x[i], 0, z[i]);
			botDisk.vertex(0, 0, 0);
			botDisk.vertex(x[i+1], 0, z[i+1]);
		}
		botDisk.endShape();
	}

	public float getX() {
		return location.x;
	}
	public float getZ() {
		return location.z;
	}
	public float getBaseRadius() {
		return baseRadius;
	}

	/**
	*	Draws the cylinder, relative to the Plate
	*/
	void draw() {
		pushMatrix();
		plate.moveToPlateCoordinates();
		translate(location.x, location.y, location.z);
		shape(openCylinder);
		shape(topDisk);
		shape(botDisk);
		popMatrix();
	}

	void drawTOP() {
		pushMatrix();
		plate.translateToPlateCoordinates();
		translate(location.x, location.z, plate.getWidth());
		rotateX(PI/2);
		shape(openCylinder);
		shape(topDisk);
		shape(botDisk);
		popMatrix();
	}

}
