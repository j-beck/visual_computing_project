/**
*	The game itself
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-06-16
*/

import java.util.List;
import java.util.ArrayList;
import processing.video.*;


// MOVIE

Movie cam;

// Game Settings

Parameters P;
Menu M;

// Game Attributes
Plate 					plate;
BallOnPlate 			ball;
List<CylinderOnPlate> 	cylinders;
GameMode 				mode;
Surfaces				surfaces;

float centerX, centerY, centerZ;


ImageProcessing imgprc;
ImageProcessing2 imgprc2;


void settings() {
	P = new Parameters();
	size(P.getWindowWidth(), P.getWindowHeight(), P3D);
}

void setup() {
  
   cam = new Movie(this, "D:\\pierrethevenet\\Desktop\\visual_computing_project\\Game\\testvideo.mp4");
   cam.loop();

	String[] cameras = Capture.list();

	M = new Menu(P);

	frameRate(P.getFramerate());
	surface.setResizable(true);
	centerX = P.getWindowWidth()/2.0;
	centerY = 2.8*P.getWindowHeight()/5.0;
	centerZ = 0.5 * P.getWindowHeight();

	plate = new Plate(centerX, centerY, centerZ,
						P.getPlateHeight(), P.getPlateWidth(), P.getPlateDepth());
	ball = new BallOnPlate(0, 0, P.getBallRadius(), plate);
	mode = P.getMode();

	cylinders = new ArrayList<CylinderOnPlate>();

	surfaces = new Surfaces(P, plate, ball, cylinders);

	if (P.getMode() == GameMode.PLAYING_CAM) {
	    if (cameras.length == 0) {
	        println("There are no cameras available for capture.");
	        exit();
	    } else {
	        Capture cam = new Capture(this, 640, 480, 30);
	    	  cam.start();
			imgprc = new ImageProcessing(cam);
			//String []args = {"Image processing window"};
			//PApplet.runSketch(args, imgprc);

	    }
	} else if (P.getMode() == GameMode.TEST_VIDEO) {
        Movie cam = new Movie(this, "D:\\pierrethevenet\\Desktop\\visual_computing_project\\Game\\testvideo.mp4");
        cam.loop();
        imgprc2 = new ImageProcessing2();
  }

}

void movieEvent(Movie m) {
  m.read();
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
	mode = P.getMode();

	cylinders = new ArrayList<CylinderOnPlate>();

	surfaces = new Surfaces(P, plate, ball, cylinders);
	surface.setSize(P.getWindowWidth(), P.getWindowHeight());
}


void draw() {
	background(150);
	directionalLight(50, 50, 60, 0, 400, 0);
	ambientLight(200, 200, 200);
	char count = 0;
	switch(mode) {
		case PLAYING_MOUSE:
			camera(centerX, centerY - 10*P.getPlateWidth(), centerZ + 1*P.getWindowHeight(), centerX, centerY, 1.5 * centerZ, 0, 1, 0);
			plate.draw();
			ball.draw(cylinders);
			for (CylinderOnPlate c : cylinders) {
				c.draw();
			}
			camera();
			surfaces.draw();
			break;
		case PLAYING_CAM:
			if (count % 10 == 0) {
				this.camUpdate();
			}
			count ++;
			camera(centerX, centerY - 10*P.getPlateWidth(), centerZ + 1*P.getWindowHeight(), centerX, centerY, 1.5 * centerZ, 0, 1, 0);
			plate.draw();
			ball.draw(cylinders);
			for (CylinderOnPlate c : cylinders) {
				c.draw();
			}
			camera();
			surfaces.draw();
			break;

    case TEST_VIDEO:
      this.camUpdate2();
      camera(centerX, centerY - 10*P.getPlateWidth(), centerZ + 1*P.getWindowHeight(), centerX, centerY, 1.5 * centerZ, 0, 1, 0);
      plate.draw();
      ball.draw(cylinders);
      for (CylinderOnPlate c : cylinders) {
        c.draw();
      }
      camera();
      surfaces.draw();
      
      PImage cp = cam.copy();
      cp.resize(64 * 5, 48 * 5);
      image(cp, width - 64*5, 0);
 
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

void camUpdate() {
	if(this.mode == GameMode.PLAYING_CAM) {
		PVector angles = this.imgprc.process();
		if (angles != null) {
			plate.changeAngle(angles.x, angles.y);
		}
	}
}

void camUpdate2() {
 if(this.mode == GameMode.TEST_VIDEO) {
    PVector angles = this.imgprc2.process();
    if (angles != null) {
      plate.changeAngle(angles.x, angles.y);
    }
 }
  
}


void mouseDragged() {
	switch(mode) {
		case PLAYING_MOUSE:
			if (mouseY < P.getWindowHeight() - surfaces.getHeight()) {
				plate.updateAngle(-(mouseY - pmouseY)*PI/pow(10,4),
									(mouseX - pmouseX)*PI/pow(10,4));
			}
			break;
		default:
			break;
	}
}

void mouseWheel(MouseEvent event) {
	switch(mode) {
		case PLAYING_MOUSE:
			float e = event.getCount();
			plate.updateSensitivity(e);
			break;
    case PLAYING_CAM:
      plate.updateSensitivity(event.getCount());
      break;
    case TEST_VIDEO:
      plate.updateSensitivity(event.getCount());
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
		mode = P.getMode();
	}

}
void keyTyped() {
	if (key == 'm') {
		if (mode == GameMode.PLAYING_MOUSE || mode == GameMode.PLAYING_CAM) {
			mode = GameMode.SETTINGS;
		} else if (mode == GameMode.SETTINGS) {
			mode = P.getMode();
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