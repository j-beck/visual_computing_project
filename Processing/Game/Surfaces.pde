/**
 *	The different Drawing Surfaces, exluding the default one
 *
 *	@author Johannes Beck
 *	@author Thomas Avon
 *	@author Pierre Thévenet
 *
 *	@version 2016-04-08
 */

import java.util.List;

class Surfaces {
  /**
   		Placement :
   
   		<-----------BGWIDHT----------->
   
   		|---------|----|---- ---- ---- ---- ----|  ^  B
   		| TP      | SB |	     BC + SB        |  |  G
   		| 1/4     |1/8 |	    	5/8         |  |  Height
   		|---------|----|---- ---- ---- ---- ----|  v
   
   		TopView takes 1/4 of BGWIDTH, overflow can appear if the ration plate.getWidth()/plate.getHeight() is too high
   		Scoreboard takes 1/8 of BGWIDTH
   		Bar Chart and the scrollbar takes 5/8 of BGWIDTH
   
   		All of these PGraphics have a height of 0.9 * BGHEIGHT
   	*/

  // dimensions of the background
  private final int BGHEIGHT = WINDOW_HEIGHT/5;
  private final int BGWIDTH = WINDOW_WIDTH;

  private final int PGHEIGHT = (int)(0.9 * BGHEIGHT); // same height for every PGraphics other than the background
  private final int OFFSET = (int)(0.05 * BGHEIGHT); // the offset of the x and y pos of the PGraphics from the zones described by the drawing above

  // dimensions of the scoreboard
  private final int SBWIDTH = (int)(0.125 * BGWIDTH - 2*OFFSET);

  // length of the ball's trace in the topview
  private final int TRACE_LENGTH = 300;


  private final float plateScale; // to print the topview of the plate, we need to scale down the plate,
  // so that newWidth = plateScale * plate.getHeight() and newHeight = plateScale * plate.getDepth()

  private final int BGRedColor = 80;
  private final int BGGreenColor = 180;
  private final int BGBlueColor = 120;

  // The different PGraphics
  private final PGraphics background;

  private final PGraphics topView;

  private final PGraphics scoreboard;

  // Needed attributes
  private Plate plate;			// To display the topView of the plate
  private	BallOnPlate ball;		// To display the ball on topView and get the scores
  private List<CylinderOnPlate> cylinders;
  
  //Needed to draw trace in topView
  private PVector[] trace;
  private int traceUpdatePos = 0;


  Surfaces (Plate plate, BallOnPlate ball, List<CylinderOnPlate> cylinders) {
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
  }

  void drawBackground() {
    background.beginDraw();
    background.background(BGRedColor, BGGreenColor, BGBlueColor);
    background.endDraw();
  }

  void drawTopView() {//List<CylinderOnPlate> cylinders, Set<PVector> previousLocations){
    // TODO : dessiner la balle, les cylindres, et les "fantomes" de la balle
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

    //draw cylinders
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
    translate(BGWIDTH/4, height-BGHEIGHT);
    translate(OFFSET, OFFSET);
    this.drawScoreboard();
    image(scoreboard, 0, 0);
    popMatrix();

    // Here we draw the Barchart and the scrollbar independently
    pushMatrix();
    translate(BGWIDTH/4 + BGWIDTH/8, height-BGHEIGHT);
    translate(OFFSET, OFFSET);
    // TODO : draw the Barchart and the scrollbar
    popMatrix();

    popStyle();
  }
}