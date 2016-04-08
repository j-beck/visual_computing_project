import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;

/**
*	The game itself
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-03-27
*/


// Game Settings
final	static	int		WINDOW_WIDTH		=	1080;
final	static	int		WINDOW_HEIGHT		=	720;
final	static	int		FRAMERATE			=	60;
final	static	int		CYLINDER_RESOLUTION	=	30;
final	static	float	CYLINDER_RADIUS		=	25;
final	static	float	CYLINDER_HEIGHT		=	30;
final	static	float	PLATE_HEIGHT		=	3*WINDOW_WIDTH/7;
final	static	float	PLATE_WIDTH			=	20;
final	static	float	PLATE_DEPTH			=	PLATE_HEIGHT;
final	static	float	BALL_RADIUS			=	12;

void settings() {
	size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
}

// TODO : camera

// Game Parameters
Plate 					plate;
BallOnPlate 			ball;
List<CylinderOnPlate> 	cylinders;
GameMode 				mode;
Surfaces				surfaces;

float centerX, centerY, centerZ;

void setup() {

	frameRate(FRAMERATE);
	centerX = WINDOW_WIDTH/2.0;
	centerY = 2.8*WINDOW_HEIGHT/5.0;
	centerZ = 0;



	plate = new Plate(centerX, centerY, centerZ,
						PLATE_HEIGHT, PLATE_WIDTH, PLATE_DEPTH);
	ball = new BallOnPlate(0, 0, BALL_RADIUS, plate);
	mode = GameMode.PLAYING;

	cylinders = new ArrayList<CylinderOnPlate>();

	surfaces = new Surfaces(plate, ball);
}


void draw() {
	background(150);
	directionalLight(50, 50, 60, 0, 100, 0);
	ambientLight(200, 200, 200);

	switch(mode) {
		case PLAYING:
			camera(centerX, centerY - 1*PLATE_HEIGHT, centerZ + 1*WINDOW_HEIGHT, centerX, centerY, centerZ, 0, 1, 0);
			plate.draw();
			ball.draw(cylinders);
			for (CylinderOnPlate c : cylinders) {
				c.draw();
			}
			camera();
			surfaces.draw();

			break;
		case EDITING:
				camera();
				plate.drawTOP();
				ball.drawTOP();
			for (CylinderOnPlate c : cylinders) {
				c.drawTOP();
			}
			break;
		default:

	}




}

void mouseDragged() {
	switch(mode) {
		case PLAYING:
			plate.updateAngle(-(mouseY - pmouseY)*PI/pow(10,4),
								(mouseX - pmouseX)*PI/pow(10,4));
			break;
		case EDITING:
			break;
		default:

	}
}

void mouseWheel(MouseEvent event) {
	switch(mode) {
		case PLAYING:
			float e = event.getCount();
			plate.updateSensitivity(e);
			break;
		case EDITING:
			break;
		default:

	}
}


void keyPressed() {
	if (keyCode == SHIFT) {
		mode = GameMode.EDITING;
	}

}
void keyReleased() {
	if (keyCode == SHIFT) {
		mode = GameMode.PLAYING;
	}
}

void mouseClicked() {
	if (mode == GameMode.EDITING) {
		PVector loc = plate.getLocation();
		float posX = mouseX - loc.x;
		float posY = mouseY - loc.y;
		// checks that the cylinder to be created is not outside the sphere
		if 														(
		(posX + CYLINDER_RADIUS) < (plate.getHeight()/2.0)		&&
		(posX - CYLINDER_RADIUS) > (-plate.getHeight()/2.0)		&&
		(posY + CYLINDER_RADIUS) < (plate.getDepth()/2.0)		&&
		(posY - CYLINDER_RADIUS) > (-plate.getDepth()/2.0)		)
		{
			CylinderOnPlate c = new CylinderOnPlate(CYLINDER_RADIUS, CYLINDER_HEIGHT, CYLINDER_RESOLUTION, plate, posX, posY);
			cylinders.add(c);
		}

	}
}
