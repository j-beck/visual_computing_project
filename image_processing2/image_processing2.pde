import processing.video.*;

Capture cam;
PImage img;

void settings() {
	size(1080, 720);
}
void setup() {
	String[] cameras = Capture.list();
	if (cameras.length == 0) {
		println("There are no cameras available for capture.");
		exit();
	} else {
		println("Available cameras:");
		for (int i = 0; i < cameras.length; i++) {
			println(cameras[i]);
		}
		cam = new Capture(this, cameras[0]);
		cam.start();
	}
}

void draw() {
	if (cam.available() == true) {
		cam.read();
	}
	img = cam.get();
	image(img, 0, 0);
}
