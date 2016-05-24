/**
*	The game's parameters
*
*	@author Pierre Thévenet
*
*	@version 2016-04-28
*/

class Parameters {
	private	int		window_width;
	private	int		window_height;
	private	int		framerate;

	private	int		cylinder_resolution;
	private	int		cylinder_radius;
	private	int		cylinder_height;

	private	int		plate_height;
	private	int		plate_width;
	private	int		plate_depth;
	private	int		ball_radius;

	private List<Button>	resButtons;

	private GameMode defaultMode;

	public Parameters() {
		window_width		=	1080;
		window_height		=	720;
		framerate			=	100;

		cylinder_radius		=	window_width / 50;
		cylinder_height		=	window_width / 40;
		cylinder_resolution	=	cylinder_radius * 2;

		plate_height		=	(int)(5*window_height/8);
		plate_width			=	(int)(window_width / 50);
		plate_depth			=	plate_height;
		ball_radius			=	(int)(window_width / 80);

		defaultMode = GameMode.PLAYING_CAM;

		int buttonWidth = window_width / 5;
		int buttonHeight = window_height / 25;
		int buttonX = (int)((window_width - buttonWidth)/2);
		int buttonY = window_height / 10;
		int offset = window_height / 100;
		int textSize = (int)min(2 * buttonHeight / 5, 2 * buttonWidth / 5);

		resButtons = new ArrayList<Button>(Arrays.asList(
			new resButton("1920 x 1080", buttonX, buttonY + 0 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1920, 1080),
			new resButton("1680 x 1050", buttonX, buttonY + 1 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1680, 1050),
			new resButton("1600 x 900", buttonX, buttonY + 2 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1600, 900),
			new resButton("1440 x 900", buttonX, buttonY + 3 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1440, 900),
			new resButton("1280 x 720", buttonX, buttonY + 4 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1280, 720),
			new resButton("1080 x 720", buttonX, buttonY + 5 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1080, 720)));
	}

	public Parameters(Parameters newP) {
		this.window_width = newP.getWindowWidth();
		this.window_height = newP.getWindowHeight();
		this.framerate = newP.getFramerate();

		this.cylinder_resolution = newP.getCylinderResolution();
		this.cylinder_radius = newP.getCylinderRadius();
		this.cylinder_height = newP.getCylinderHeight();

		this.plate_height = newP.getPlateHeight();
		this.plate_width = newP.getPlateWidth();
		this.plate_depth = newP.getPlateDepth();
		this.ball_radius = newP.getBallRadius();

		this.defaultMode = GameMode.PLAYING_MOUSE;

		int buttonWidth = window_width / 5;
		int buttonHeight = window_height / 25;
		int buttonX = (int)((window_width - buttonWidth)/2);
		int buttonY = window_height / 10;
		int offset = window_height / 100;
		int textSize = (int)min(2 * buttonHeight / 5, 2 * buttonWidth / 5);

		resButtons = new ArrayList<Button>(Arrays.asList(
			new resButton("1920 x 1080", buttonX, buttonY + 0 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1920, 1080),
			new resButton("1680 x 1050", buttonX, buttonY + 1 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1680, 1050),
			new resButton("1600 x 900", buttonX, buttonY + 2 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1600, 900),
			new resButton("1440 x 900", buttonX, buttonY + 3 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1440, 900),
			new resButton("1280 x 720", buttonX, buttonY + 4 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1280, 720),
			new resButton("1080 x 720", buttonX, buttonY + 5 * (buttonHeight + offset), buttonWidth, buttonHeight, textSize, 1080, 720)));

	}


	// SETTERS
	public void setWindowSize(int width, int height) {
		this.window_width = width;
		this.window_height = height;
		setDefault();
	}
	public void setFramerate(int framerate) {
		this.framerate = framerate;
	}
	public void setDefault() {
		plate_height		=	(int)(3*window_width/7);
		plate_width			=	(int)(window_width / 50);
		plate_depth			=	plate_height;

		cylinder_radius		=	25;
		cylinder_height		=	30;
		cylinder_resolution	=	cylinder_radius * 2;

		plate_height		=	(int)(5*window_height/8);
		plate_width			=	(int)(window_width / 50);
		plate_depth			=	plate_height;
		ball_radius			=	(int)(window_width / 80);
	}

	// GETTERS
	public int getWindowWidth() {
		return window_width;
	}
	public int getWindowHeight() {
		return window_height;
	}
	public int getFramerate() {
		return framerate;
	}
	public int getCylinderResolution() {
		return cylinder_resolution;
	}
	public int getCylinderRadius() {
		return cylinder_radius;
	}
	public int getCylinderHeight() {
		return cylinder_height;
	}
	public int getPlateHeight() {
		return plate_height;
	}
	public int getPlateWidth() {
		return plate_width;
	}
	public int getPlateDepth() {
		return plate_depth;
	}
	public int getBallRadius() {
		return ball_radius;
	}
	public GameMode getMode() {
		return this.defaultMode;
	}

	public List<Button> getResButtons() {
		return resButtons;
	}
}
