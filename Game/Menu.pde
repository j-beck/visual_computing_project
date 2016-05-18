/**
*	The game's menu
*
*	@author Pierre Thévenet
*
*	@version 2016-04-29
*/

static final int NBBUTTONS = 6;
static final String[] LABELS = {"1080 x 720", "640 x 480"};
static final int[] TYPES = {1, 1};
static final int BUTTON_RES = 1;





class Menu {

	Button[] menuButtons;
	int buttonWidth;
	int buttonHeight;
	int buttonX;
	int buttonY;
	int offset;

	public Menu(Parameters P) {
		buttonWidth = P.getWindowWidth() / 5;
		buttonHeight = P.getWindowHeight() / 25;
		buttonX = (int)((P.getWindowWidth() - buttonWidth)/2);
		buttonY = P.getWindowHeight() / 10;
		offset = P.getWindowHeight() / 100;
		int textSize = (int)min(2 * buttonHeight / 5, 2 * buttonWidth / 5);
		menuButtons = new Button[NBBUTTONS];

		menuButtons[0] = new resButton("1920 x 1080", buttonX, buttonY + 0 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1920, 1080);
		menuButtons[1] = new resButton("1680 x 1050", buttonX, buttonY + 1 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1680, 1050);
		menuButtons[2] = new resButton("1600 x 900", buttonX, buttonY + 2 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1600, 900);
		menuButtons[3] = new resButton("1440 x 900", buttonX, buttonY + 3 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1440, 900);
		menuButtons[4] = new resButton("1280 x 720", buttonX, buttonY + 4 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1280, 720);
		menuButtons[5] = new resButton("1080 x 720", buttonX, buttonY + 5 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1080, 720);

	}

	public void click() {
		for (int i = 0; i < NBBUTTONS; i++) {
			if (menuButtons[i].isClicked() == true) {
				menuButtons[i].click();
				menuButtons[i].click();
			}
		}
	}


	public void draw() {
		pushStyle();
		pushMatrix();

		background(170);
		for (int i = 0; i < menuButtons.length; i++) {
			menuButtons[i].draw();
		}
		this.click();
		popMatrix();
		popStyle();
	}

}
