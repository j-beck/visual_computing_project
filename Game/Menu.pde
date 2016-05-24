/**
*	The game's menu
*
*	@author Pierre Thévenet
*
*	@version 2016-04-29
*/

import java.util.Arrays;

static final int NBBUTTONS = 6;
static final String[] LABELS = {"1080 x 720", "640 x 480"};
static final int[] TYPES = {1, 1};
static final int BUTTON_RES = 1;





class Menu {

	String label;
	List<Button> resButtons;
	int buttonWidth;
	int buttonHeight;
	int buttonX;
	int buttonY;
	int offset;

	public Menu(Parameters P) {
		/*
		buttonWidth = P.getWindowWidth() / 5;
		buttonHeight = P.getWindowHeight() / 25;
		buttonX = (int)((P.getWindowWidth() - buttonWidth)/2);
		buttonY = P.getWindowHeight() / 10;
		offset = P.getWindowHeight() / 100;
		int textSize = (int)min(2 * buttonHeight / 5, 2 * buttonWidth / 5);
		*/
		resButtons = P.getResButtons();
		/*
		menuButtons[0] = new resButton("1920 x 1080", buttonX, buttonY + 0 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1920, 1080);
		menuButtons[1] = new resButton("1680 x 1050", buttonX, buttonY + 1 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1680, 1050);
		menuButtons[2] = new resButton("1600 x 900", buttonX, buttonY + 2 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1600, 900);
		menuButtons[3] = new resButton("1440 x 900", buttonX, buttonY + 3 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1440, 900);
		menuButtons[4] = new resButton("1280 x 720", buttonX, buttonY + 4 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1280, 720);
		menuButtons[5] = new resButton("1080 x 720", buttonX, buttonY + 5 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1080, 720);
		*/

	}

	public void click() {
		if (resButtons != null) {
			for (int i = 0; i < resButtons.size(); i++) {
				if (resButtons.get(i).isClicked() == true) {
					resButtons.get(i).click();
					resButtons.get(i).click();
				}
			}
		}
	}


	public void draw() {
		pushStyle();
		pushMatrix();

		background(170);
		if (resButtons != null) {
			for (int i = 0; i < resButtons.size(); i++) {
				resButtons.get(i).draw();
			}
		}

		this.click();
		popMatrix();
		popStyle();
	}

}
