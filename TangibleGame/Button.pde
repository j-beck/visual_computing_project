/**
*	A button
*
*	@author Pierre Thévenet
*
*	@version 2016-04-28
*/

abstract class Button {
	String label;
	int x;    // top left corner x position
	int y;    // top left corner y position
	int w;    // width of button
	int h;    // height of button
	int textSize;

	public Button(String label, int x, int y, int w, int h, int textSize) {
		this.label = label;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.textSize = textSize;
	}

	public void draw() {
		pushStyle();
		fill(100);

		rect(x, y, w, h);
		fill(0);
		textSize(textSize);
		text(label, x + w/2 -(textWidth(label)/2), y + (h / 2));
		popStyle();
	}

	public boolean isClicked() {
		if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
		  if (mouseButton == LEFT) {
			  return true;
		  }
		}
		return false;
	}

	public abstract void click();


}

class fullScreenButton extends Button {
	public fullScreenButton(String label, int x, int y, int w, int h, int textSize) {
		super(label, x, y, w, h, textSize);
	}

	public void click() {
		fullScreen();
	}

}

class resButton extends Button {
	int resX;
	int resY;
	public resButton(String label, int x, int y, int w, int h, int textSize, int resX, int resY) {
		super(label, x, y, w, h, textSize);
		this.resX = resX;
		this.resY = resY;
	}
	public void click() {
		changeWindowSize(this.resX, this.resY);
	}

}
