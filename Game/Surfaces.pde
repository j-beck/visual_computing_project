/**
 *	The different Drawing Surfaces, exluding the default one
 *
 *	@author Johannes Beck
 *	@author Thomas Avon
 *	@author Pierre Thévenet
 *
 *	@version 2016-04-10
 */

import java.util.List;

class Surfaces
{
    /**
     		Placement :

    	// Previous version
     		<-----------BGWIDHT----------->

     		|---------|----|---- ---- ---- ---- ----|  ^  B
     		| TP      | SB |	     BC + SB        |  |  G
     		| 1/4     |1/8 |	    	5/8         |  |  Height
     		|---------|----|---- ---- ---- ---- ----|  v


    	// Current version
     		<-----------BGWIDHT----------->

     		|---------|----|---- ---- ---- ---- --------|  ^  B
     		| TP      | SB |	     BC + scrollbar     |  |  G
    		| Variable| 1/8| Variable (remaining space) |  |  Height
     		|---------|----|---- ---- ---- ---- --------|  v


     		TopView takes 1/4 of BGWIDTH, overflow can appear if the ration plate.getWidth()/plate.getHeight() is too high
     		Scoreboard takes 1/8 of BGWIDTH
     		Bar Chart and the scrollbar takes 5/8 of BGWIDTH

     		All of these PGraphics have a height of 0.9 * BGHEIGHT
     	*/


    // dimensions of the background
    private int BGHEIGHT;
    private int BGWIDTH;

    private int PGHEIGHT; //same height for every PGraphics other than the background (and the barchart and scrobar but the sum of their height is still PGHEIGHT)
    private int OFFSET; // the offset of the x and y pos of the PGraphics from the zones described by the drawing above

    // dimensions of the scoreboard
    private int SBWIDTH;

    // dimensions of the barchart
    private int BCHEIGHT;
    private int BCWIDTH;

    // dimensions of the scrollbar
    private int SCHEIGHT;
    private int SCWIDTH;


    private float plateScale; // to print the topview of the plate, we need to scale down the plate,
    // so that newWidth = plateScale * plate.getHeight() and newHeight = plateScale * plate.getDepth()

    private final int BGRedColor = 80;
    private final int BGGreenColor = 180;
    private final int BGBlueColor = 120;

	// length of the ball's trace in the topview
    private final int TRACE_LENGTH = 300;

    // The different PGraphics
    private final PGraphics background;

    private final PGraphics topView;

    private final PGraphics scoreboard;

    private BarChart barchart;

    private HScrollbar scrollbar;

    // Needed attributes
    private Plate plate;			// To display the topView of the plate
    private BallOnPlate ball;		// To display the ball on topView and get the scores
    private List<CylinderOnPlate> cylinders;

    //Needed to draw trace in topView
    private PVector[] trace;
    private int traceUpdatePos = 0;


    Surfaces (Parameters P, Plate plate, BallOnPlate ball, List<CylinderOnPlate> cylinders) {
		BGHEIGHT = P.getWindowHeight()/6;
		BGWIDTH = P.getWindowWidth();
		PGHEIGHT = (int)(0.9 * BGHEIGHT);
		OFFSET = (int)(0.05 * BGHEIGHT);
		SBWIDTH = (int)(0.125 * BGWIDTH - 2*OFFSET);
		BCHEIGHT = (int)(0.7 * BGHEIGHT);
		BCWIDTH = (int)(BGWIDTH - (plateScale * plate.getHeight() + 3 * OFFSET + BGWIDTH/4 ));

		// dimensions of the scrollbar
		SCHEIGHT = (int)(0.2 * BGHEIGHT);
		SCWIDTH = (int)(BGWIDTH - (plateScale * plate.getHeight() + 3 * OFFSET + BGWIDTH/4 ));
        this.plate = plate;
        this.ball = ball;
        this.plateScale = PGHEIGHT/plate.getDepth();
        this.cylinders = cylinders;
        // PGraphics
        this.background = createGraphics(BGWIDTH, BGHEIGHT, P2D);

        this.topView = createGraphics( (int)(plateScale * plate.getHeight()), (int)( plateScale * plate.getDepth()), P2D); // In fact the height is equal to PGHEIGHT

        this.scoreboard = createGraphics(SBWIDTH, PGHEIGHT, P2D);

        trace = new PVector[TRACE_LENGTH];
        for (int i = 0; i< trace.length; ++i)
            trace[i] = ball.getLocation();


        this.barchart = new BarChart(BCWIDTH, BCHEIGHT, 7, 7, 3);

        /*
        	translate((int)(plateScale * plate.getHeight()) + 2*OFFSET, height-BGHEIGHT);
        	translate(BGWIDTH/8, 0);
        	translate(OFFSET, OFFSET);
        	translate(0, OFFSET + BCHEIGHT);
        	*/
        int x = (int)( (plateScale * plate.getHeight()) + 2*OFFSET + BGWIDTH/8 + OFFSET);
        int y = height-BGHEIGHT + 2 * OFFSET + BCHEIGHT;
        this.scrollbar = new HScrollbar(x, y, SCWIDTH, SCHEIGHT);

    }

    void drawBackground() {
        background.beginDraw();
        background.background(BGRedColor, BGGreenColor, BGBlueColor);
        background.endDraw();
    }

    void drawTopView() {
        topView.beginDraw();
        topView.noStroke();
        float height = plateScale * plate.getHeight();
        float width = plateScale * plate.getDepth();
        topView.fill(0,120,255);
        topView.rect(0, 0, height, width);
        topView.translate(height/2., width/2.);
        PVector loc = ball.getLocation();
        float ballRadius = plateScale * ball.getRadius() ;


        // update trace
        trace[traceUpdatePos] = loc;
        if (traceUpdatePos < (trace.length -1))
            ++traceUpdatePos;
        else
            traceUpdatePos = 0;

        //draw trace
        topView.fill(40,40,255,30);
        for (int i = 0; i< trace.length; ++i)
            topView.ellipse(plateScale * trace[i].x, plateScale* trace[i].z,2*ballRadius, 2*ballRadius);


        // draw ball
        topView.fill(200,50,0);
        topView.ellipse(plateScale * loc.x, plateScale * loc.z, 2*ballRadius, 2*ballRadius);

        // draw cylinders
        topView.fill(230);
        for (CylinderOnPlate c : cylinders) {
            float radius = plateScale * c.getBaseRadius();
            topView.ellipse(plateScale * c.getX(), plateScale * c.getZ(), 2*radius, 2*radius);
        }
        topView.endDraw();
    }

    void drawScoreboard() {
        /*
        	<---------W---------->
        		_____________________	^
        		|  ----------------  |	|	The distance of the top and bottom side of the inner rectangle from the outer is the H/40
        		|  |              |  |	|	The distance of the left and right side of the inner rectangle from the outer is the W/40
        		|  |              |  |	|
        		|  |              |  |	H
        		|  |              |  |	|
        		|  |              |  |	|
        		|  |              |  |	|
        		|  ----------------  |	|
        		|--------------------|	v

         */

        scoreboard.beginDraw();
        scoreboard.background(250);
        scoreboard.fill(BGRedColor, BGGreenColor, BGBlueColor);
        scoreboard.noStroke();
        scoreboard.rect(0.025 * SBWIDTH, 0.025 * PGHEIGHT, 0.95 * SBWIDTH, 0.95 * PGHEIGHT); // inner rectangle
        scoreboard.fill(0);
        float textsize = 0.09*PGHEIGHT; // dont know why PGHEIGHT*0.95/6 doesnt work
        scoreboard.textSize(textsize);
        float Woffset = 0.025 * SBWIDTH; // We offset the text so it doesnt touch the rectangle
        // TODO : print the floats with less precision
        String s = "Total Score : \n" + ball.getTotalScore() + "\n" + "Velocity : \n" + ball.getNVelocity() + "\n" + "Last Score : \n" + ball.getLastScore(); // exactly 6 lines
        scoreboard.text(s, 0.05 * SBWIDTH + Woffset, 0.15 * PGHEIGHT, 0); // dont understand why with text.y pos = 0.05*PGHEIGHT it doesnt work
        scoreboard.endDraw();
    }

    void drawBarChart(float lastScore) {
        this.barchart.setRectanglesWidth((int)(scrollbar.getPos() * 20));
        this.barchart.draw(lastScore);
    }

    void draw() {
        pushStyle();

        // Here we draw the background and the topview
        pushMatrix();
        translate(0, height-BGHEIGHT); // translation to the surfaces zone (the top left corner of background)
        this.drawBackground();
        image(background, 0, 0);

        translate(OFFSET, OFFSET);
        this.drawTopView();
        image(topView, 0, 0);
        popMatrix();

        // Here we draw the scoreboard independently
        pushMatrix();
        // previous version :
        //translate(BGWIDTH/4, height-BGHEIGHT);
        // current version :
        translate((int)(plateScale * plate.getHeight()) + 2*OFFSET, height-BGHEIGHT);
        translate(OFFSET, OFFSET);
        this.drawScoreboard();
        image(scoreboard, 0, 0);
        popMatrix();

        // Here we draw the Barchart and the scrollbar independently
        pushMatrix();
        translate((int)(plateScale * plate.getHeight()) + 2*OFFSET, height-BGHEIGHT);
        translate(BGWIDTH/8, 0);
        translate(OFFSET, OFFSET);
        // TODO : draw the Barchart and the scrollbar
        this.drawBarChart(ball.getTotalScore());
        image(barchart.getPGraphics(), 0, 0);
        popMatrix();

        // Here we draw the scrollbar
        pushMatrix();

        scrollbar.update();
        scrollbar.display();
        popMatrix();

        popStyle();
    }

    public int getHeight() {
        return BGHEIGHT;
    }
}
