/**
*	A movable ball, placed on a Plate
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-03-25
*/
class BallOnPlate {

	public static final float GRAVITY_CONST = .5;
	public static final float MU 			= .1;

	private final float radius;
	private Plate plate;

	private PVector location;
	private PVector velocity;

	private float totalScore;
	private float lastScore;

	private float normVelocity;

	/**
	*	Builds a BallOnPlate
	*
	*	@param x
	*		the starting x position of the ball relative to the Plate
	*	@param y
	*		the starting y position of the ball relative to the Plate
	*	@param radius
	*		the radius of the ball
	*	@param plate
	*		the plate the ball is to be placed on
	*/
	public BallOnPlate(float x, float z, float radius, Plate plate) throws IllegalArgumentException {

		this.location = new PVector(x, -radius -(plate.getWidth())/2.0, z);
		this.radius = radius;
		this.plate = plate;

		this.velocity = new PVector(0, 0, 0);
		this.normVelocity = 0;
		this.totalScore = 0;
		this.lastScore = 0;

	}

	public float getTotalScore() {
		return this.totalScore;
	}
	public float getLastScore() {
		return this.lastScore;
	}
	public float getNVelocity() {
		return this.normVelocity;
	}
  public PVector getLocation(){
    return this.location.copy();
  }

  public float getRadius(){
    return this.radius;
  }

	/**
	*	Checks if the ball is out of the plate, if yes corrects the speed to go back on the plate
	*	Only consider the center of the ball
	*	Does not reduce the magnitude of the speed
	*/
	public void checkEdges() {
		boolean flag = false;
		if (location.x > plate.getHeight()/2.0) {
			location.x = plate.getHeight()/2.0;
			velocity.x *= -1;
			flag = true;
		}
		else if (location.x < -plate.getHeight()/2.0) {
			location.x = -plate.getHeight()/2.0;
			velocity.x *= -1;
			flag = true;
		}
		if (location.z > plate.getDepth()/2.0) {
			location.z = plate.getDepth()/2.0;
			velocity.z *= -1;
			flag = true;
		}
		else if (location.z < -plate.getDepth()/2.0) {
			location.z = -plate.getDepth()/2.0;
			velocity.z *= -1;
			flag = true;
		}

		if (flag == true) {
			this.totalScore -= normVelocity;
			this.lastScore = -normVelocity;
		}

	}

	/**
	*	Checks if the ball touches a cylinder, if yes makes it bounce
	*
	*	@param cylinder
	*		the cylinder the ball may collide
	*/
	public void checkCylinder(CylinderOnPlate cylinder) {
		PVector cylinder2DLocation	= new PVector(cylinder.getX(), 0, cylinder.getZ());
		PVector ball2DLocation		= new PVector(location.x, 0, location.z);


		if (ball2DLocation.dist(cylinder2DLocation) <= this.radius + cylinder.getBaseRadius()) {
			// Updates the scores
			this.totalScore += normVelocity;
			this.lastScore = normVelocity;

			// Corrects the velocity
			PVector normalVector = PVector.sub( ball2DLocation, cylinder2DLocation).normalize();
			velocity = PVector.sub(velocity, PVector.mult(normalVector, 2 * normalVector.dot(velocity)));

			// Corrects the location
			normalVector.mult(radius + cylinder.getBaseRadius());
			PVector impact = PVector.add(cylinder2DLocation, normalVector);
			location.x = impact.x;
			location.z = impact.z;
		}
	}

	/**
	*	Change the velocity of the ball accoriding to the plate edges and the cylinders (bounce)
	*
	*	@param cylinders
	*		the list of cylinders the ball may collide
	*/
	public void updateVelocity(List<CylinderOnPlate> cylinders) {
		normVelocity = (float)Math.sqrt(velocity.x*velocity.x + velocity.y*velocity.y + velocity.z*velocity.z);
		location.add(velocity);

		// gravitation
		PVector gravForce = new PVector(sin(plate.getZAngle()), 0, -sin(plate.getXAngle())).mult(GRAVITY_CONST);

		//friction
		float normalForceM = cos(plate.getXAngle() * cos(plate.getZAngle()));
		float frictionM = normalForceM * MU;
		PVector frictionForce = velocity.get();
		frictionForce.mult(-1);
		frictionForce.normalize();
		frictionForce.mult(frictionM);

		this.checkEdges();
		for (CylinderOnPlate c : cylinders) {
			this.checkCylinder(c);
		}

		velocity.add(gravForce).add(frictionForce);

	}

	public void draw(List<CylinderOnPlate> cylinders) {
		pushMatrix();
		plate.moveToPlateCoordinates();
		translate(location.x, location.y, location.z);
		updateVelocity(cylinders);
		sphere(radius);
		popMatrix();
	}

	public void drawTOP() {
	    pushMatrix();
	    plate.translateToPlateCoordinates();
	    translate(this.location.x,this.location.z,plate.getWidth()/2 + this.radius);
	    rotateX(PI/2.);
	    sphere(radius);
	    popMatrix();
	}

}
