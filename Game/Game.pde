import java.util.List;
import java.util.ArrayList;


/**
*	The game itself
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-05-04
*/


// Game Settings

Parameters P = new Parameters();
Menu M;

// Game Attributes
Plate 					plate;
BallOnPlate 			ball;
List<CylinderOnPlate> 	cylinders;
GameMode 				mode;
Surfaces				surfaces;


float centerX, centerY, centerZ;

void settings() {
  size(P.getWindowWidth(), P.getWindowHeight(), P3D);
}

void setup() {
	M = new Menu(P);


	frameRate(P.getFramerate());
	surface.setResizable(true);
	centerX = P.getWindowWidth()/2.0;
	centerY = 2.8*P.getWindowHeight()/5.0;
	centerZ = 0.5 * P.getWindowHeight();


	plate = new Plate(centerX, centerY, centerZ,
						P.getPlateHeight(), P.getPlateWidth(), P.getPlateDepth());
	ball = new BallOnPlate(0, 0, P.getBallRadius(), plate);
	mode = GameMode.PLAYING;

	cylinders = new ArrayList<CylinderOnPlate>();

	surfaces = new Surfaces(P, plate, ball, cylinders);

}


void changeWindowSize(int ww, int wh) {
	P.setWindowSize(ww, wh);
	resetParameters(P);
}

void resetParameters(Parameters P) {
	P = new Parameters(P);
	surfaces = new Surfaces(P, plate, ball, cylinders);
	M = new Menu(P);

	frameRate(P.getFramerate());
	surface.setResizable(true);
	centerX = P.getWindowWidth()/2.0;
	centerY = 2.8*P.getWindowHeight()/5.0;
	centerZ = 0;
	plate = new Plate(centerX, centerY, centerZ,
						P.getPlateHeight(), P.getPlateWidth(), P.getPlateDepth());
	ball = new BallOnPlate(0, 0, P.getBallRadius(), plate);
	mode = GameMode.PLAYING;

	cylinders = new ArrayList<CylinderOnPlate>();

	surfaces = new Surfaces(P, plate, ball, cylinders);
	surface.setSize(P.getWindowWidth(), P.getWindowHeight());

}


void draw() {
	background(150);
	directionalLight(50, 50, 60, 0, 400, 0);
	ambientLight(200, 200, 200);

	switch(mode) {
		case PLAYING:
			camera(centerX, centerY - 10*P.getPlateWidth(), centerZ + 1*P.getWindowHeight(), centerX, centerY, 1.5 * centerZ, 0, 1, 0);
			plate.draw();
			ball.draw(cylinders);
			for (CylinderOnPlate c : cylinders) {
				c.draw();
			}
			camera();
			surfaces.draw();

			break;
		case EDITING:
				//camera();
				//camera(centerX, centerY, centerZ + 0*P.getWindowHeight(), centerX, centerY, centerZ, 0, 1, 0);
				plate.drawTOP();
				ball.drawTOP();
			for (CylinderOnPlate c : cylinders) {
				c.drawTOP();
			}
			break;
		case SETTINGS:
			M.draw();
			break;
		default:

	}

}


void mouseDragged() {
	switch(mode) {
		case PLAYING:
		if (mouseY < P.getWindowHeight() - surfaces.getHeight()) {
			plate.updateAngle(-(mouseY - pmouseY)*PI/pow(10,4),
								(mouseX - pmouseX)*PI/pow(10,4));
		}
			break;
		case EDITING:
			break;
		case SETTINGS:
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
		case SETTINGS:
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
void keyTyped() {
	if (key == 'm') {
		if (mode == GameMode.PLAYING) {
			mode = GameMode.SETTINGS;
		} else if (mode == GameMode.SETTINGS) {
			mode = GameMode.PLAYING;
		}
	}
}

void mouseClicked() {
	if (mode == GameMode.EDITING) {
		PVector loc = plate.getLocation();
		float posX = mouseX - loc.x;
		float posY = mouseY - loc.y;
		// checks that the cylinder to be created is not outside the sphere
		if 														(
		(posX + P.getCylinderRadius()) < (plate.getHeight()/2.0)		&&
		(posX - P.getCylinderRadius()) > (-plate.getHeight()/2.0)		&&
		(posY + P.getCylinderRadius()) < (plate.getDepth()/2.0)		&&
		(posY - P.getCylinderRadius()) > (-plate.getDepth()/2.0)		)
		{
			CylinderOnPlate c = new CylinderOnPlate(P.getCylinderRadius(), P.getCylinderHeight(), P.getCylinderResolution(), plate, posX, posY);
			cylinders.add(c);
		}

	}
}
