/**
*	A Plate, which can move around the x and z direction.
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-03-25
*/
class Plate {
	private float height, width, depth;
	private float xAngle, zAngle;
	private PVector location;

	private float sensitivity;

	private float maxAngle;
	private float maxSensitivity;

	/**
	*	Builds a Plate
	*
	*	@param x
	*		The x location of the center of the plate
	*	@param y
	*		The y location of the center of the plate
	*	@param z
	*		The z location of the center of the plate
	*	@param height
	*		The height of the plate
	*	@param width
	*		The width of the plate
	*	@param depth
	*		The depth of the plate
	*
	*/
	Plate(float x, float y, float z, float height, float width, float depth) {
		this.location	= new PVector(x, y, z);
		this.height		= height;
		this.width		= width;
		this.depth		= depth;

		this.xAngle = 0;
		this.zAngle = 0;
		this.sensitivity = 10;

		this.maxAngle = PI/3;
		this.maxSensitivity = 50;
	}

	public float getHeight() {
		return this.height;
	}
	public float getWidth() {
		return this.width;
	}
	public float getDepth() {
		return this.depth;
	}
	public float getXAngle() {
		return this.xAngle;
	}
	public float getZAngle() {
		return this.zAngle;
	}
	public PVector getLocation() {
		return this.location;
	}


	/**
	*	Update the angle position of the plate, according the its sensitivity
	*
	*	@param xAngleChange
	*		a 'small' angle change around the x axis
	*	@param zAngleChange
	*		a 'small' angle change around the z axis
	*/
	public void updateAngle(float xAngleChange, float zAngleChange) {
		this.xAngle += xAngleChange * sensitivity;
		this.zAngle += zAngleChange * sensitivity;

		this.xAngle = max ( min(xAngle, maxAngle), -maxAngle);
		this.zAngle = max ( min(zAngle, maxAngle), -maxAngle);
	}

	public void changeAngle(float xAngle, float zAngle) {

		if (xAngle < maxAngle && xAngle > -maxAngle && zAngle < maxAngle && zAngle > -maxAngle) {
			this.xAngle = xAngle;
			this.zAngle = zAngle;
		}

	}

	/**
	*	Change the coordinates relatively to the plate
	*/
	public void moveToPlateCoordinates() {
		translate(location.x, location.y, location.z);
		rotateX(xAngle);
		rotateZ(zAngle);
	}

	/**
	*	Translate to the center of the plate
	*/
	public void translateToPlateCoordinates() {
		translate(location.x, location.y, 0);
	}

	/**
	*	Update the sensitivity to a new value
	*	@param newSensitivity
	*		New sensitivity, must be stricty positive and less than maxSensitivity to update
	*/
	public void updateSensitivity(float sensitivityChange) {

		if ((sensitivity + sensitivityChange) > 1 && (sensitivityChange + sensitivity) <= maxSensitivity) {
			this.sensitivity += sensitivityChange;
		}
	}

	/**
	*	Draws the plate, absolute
	*/
	public void draw() {
		pushMatrix();
		this.moveToPlateCoordinates();
		box(height, width, depth);
		popMatrix();
	}

	/**
	*	Draws the plate from its top
	*/
	public void drawTOP() {
		pushMatrix();
		pushStyle();
		this.translateToPlateCoordinates();
		rotateX(PI/2);
		fill(240);
		box(height, width, depth);
		popStyle();
		popMatrix();
	}

}
