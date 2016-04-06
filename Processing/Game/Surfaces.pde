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
	private final PGraphics background;
	private final int backgroundWidth;
	private final int backgroundHeight;

	private final PGraphics topView;
	private Plate plate;
	private	BallOnPlate ball;

	private final PGraphics scoreboard;




	Surfaces (int backgroundWidth, int backgroundHeight, Plate plate, BallOnPlate ball) {
		this.background = createGraphics(backgroundWidth, backgroundHeight, P2D);
		this.backgroundWidth = backgroundWidth;
		this.backgroundHeight = backgroundHeight;

		float scale = 9*backgroundHeight/(10*plate.getHeight());

		this.topView = createGraphics( (int)(plate.getHeight() * scale), (int)(plate.getDepth() * scale), P2D);
		this.plate = plate;
		this.ball = ball;

		this.scoreboard = createGraphics( (int)(width/10), (int)(0.9*backgroundHeight), P2D);
	}

	void drawBackground() {
		background.beginDraw();
		background.background(128, 0, 0);
		background.endDraw();
	}

	void drawTopView() {//List<CylinderOnPlate> cylinders, Set<PVector> previousLocations) {
		topView.beginDraw();
		float h = 9*backgroundHeight/10;
		float scale = h/plate.getHeight();
		topView.rect(0, 0, plate.getHeight() * scale, plate.getDepth() * scale);
		topView.endDraw();
	}

	void drawScoreboard() {
		scoreboard.beginDraw();
		scoreboard.background(200);
		scoreboard.fill(250);
		scoreboard.rect(width/250, width/250, 0.1*width - width/125, 0.9*backgroundHeight - width/100); // inner rectangle
		scoreboard.fill(0);
		String s = "Total Score : \n" + ball.getTotalScore() + "\n" + "Velocity : \n" + ball.getNVelocity() + "\n" + "Last Score : \n" + ball.getLastScore();
		scoreboard.text(s, width/250, (width/50), 0);
		scoreboard.endDraw();
	}

	void draw() {
		pushStyle();
		pushMatrix();
		translate(0, height-backgroundHeight); // translation to the surfaces zone

		this.drawBackground();
		image(background, 0, 0);

		float h = 9*backgroundHeight/10;
		float scale = h/plate.getHeight();
		translate(0.01*height , 0.01*height);
		this.drawTopView();
		image(topView, 0, 0);

		translate(1.1*plate.getHeight() * scale, 0);
		this.drawScoreboard();
		image(scoreboard, 0, 0);

		popMatrix();
		popStyle();
	}
}
