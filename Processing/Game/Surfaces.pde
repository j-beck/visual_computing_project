/**
*	The different Drawing Surfaces, exluding the default one
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-04-04
*/

class Surfaces {

	// dimensions of the background
	private final int BGHEIGHT = WINDOW_HEIGHT/6;
	private final int BGWIDTH = WINDOW_WIDTH;
	// dimensions of the scoreboard
	private final int SBHEIGHT = (int)(0.9 * BGHEIGHT);
	private final int SBWIDTH = (int)(0.1 * WINDOW_WIDTH);

	private final float plateScale; // to print the topview of the plate, we need to scale down the plate


	private final PGraphics background;

	private final PGraphics topView;
	private Plate plate;
	private	BallOnPlate ball;

	private final PGraphics scoreboard;




	Surfaces (Plate plate, BallOnPlate ball) {
		this.background = createGraphics(BGWIDTH, BGHEIGHT, P2D);

		this.plateScale = 0.9*BGHEIGHT/plate.getHeight();

		this.topView = createGraphics( (int)(plate.getHeight() * plateScale), (int)(plate.getDepth() * plateScale), P2D);
		this.plate = plate;
		this.ball = ball;

		this.scoreboard = createGraphics( SBWIDTH, SBWIDTH, P2D);
	}

	void drawBackground() {
		background.beginDraw();
		background.background(128, 0, 0);
		background.endDraw();
	}

	void drawTopView() {//List<CylinderOnPlate> cylinders, Set<PVector> previousLocations) {
		topView.beginDraw();
		topView.rect(0, 0, plate.getHeight() * plateScale, plate.getDepth() * plateScale);
		topView.endDraw();
	}

	void drawScoreboard() {
		scoreboard.beginDraw();
		scoreboard.background(200);
		scoreboard.fill(250);
		scoreboard.rect(width/250, width/250, 0.1*width - width/125, 0.9*BGHEIGHT - width/100); // inner rectangle
		scoreboard.fill(0);
		String s = "Total Score : \n" + ball.getTotalScore() + "\n" + "Velocity : \n" + ball.getNVelocity() + "\n" + "Last Score : \n" + ball.getLastScore();
		scoreboard.text(s, width/250, (width/50), 0);
		scoreboard.endDraw();
	}

	void draw() {
		pushStyle();
		pushMatrix();
		translate(0, height-BGHEIGHT); // translation to the surfaces zone

		this.drawBackground();
		image(background, 0, 0);

		translate(0.01*height , 0.01*height);
		this.drawTopView();
		image(topView, 0, 0);

		translate(1.1*plate.getHeight() * plateScale, 0);
		this.drawScoreboard();
		image(scoreboard, 0, 0);

		popMatrix();
		popStyle();
	}
}
