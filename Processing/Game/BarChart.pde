/**
*	A barchart
*
*	@author Johannes Beck
*	@author Thomas Avon
*	@author Pierre Thévenet
*
*	@version 2016-04-10
*/

import java.util.List;
import java.util.ArrayList;

class BarChart {

	private final PGraphics pGraph;
	private final int BCWidth;
	private final int BCHeight;

	private final int offset; // the space between two rectangles

	// Non final attributes because the sizes can change
	private int rectanglesWidth;
	private int rectanglesHeight;

	private List<Float> scores;
	private float maxScore;

	public BarChart(int BCWidth, int BCHeight, int rectanglesWidth, int rectanglesHeight, int offset) {
		this.BCWidth = BCWidth;
		this.BCHeight = BCHeight;

		this.pGraph = createGraphics(this.BCWidth, this.BCHeight, P2D);

		this.rectanglesWidth = rectanglesWidth;
		this.rectanglesHeight = rectanglesHeight;

		this.offset = offset;

		this.scores = new ArrayList<Float>();
		this.maxScore = 0.0;
	}

	// Idea : BCHeight = max(score), the rest is a fraction of it
	public void draw(float lastScore) {
		this.scores.add(lastScore);
		this.maxScore = max(maxScore, lastScore);

		int nbColumns = BCWidth / (rectanglesWidth + offset); // number of 'columns' in the drawing
		int nbLines = BCHeight / (rectanglesHeight + offset);
		int size = scores.size();

		pGraph.pushMatrix();
		pGraph.beginDraw();
		pGraph.background(245);
		pGraph.translate(0, BCHeight - offset);
		pGraph.fill(51,153,255);


		for (int i = 0; i < nbColumns; i++) {
			for (int j = 0; j < nbLines; j++) {
				pGraph.rect(offset/2 + i * (offset + rectanglesWidth), - j * (offset + rectanglesHeight), rectanglesWidth, -rectanglesHeight);
			}
		}




		/*

		if (nbC >= scores.size()) {
			// we have enough space to draw all scores
			for (int i = 0; i < scores.size(); i++) {

				float cS = scores.get(i);
				int numberOfRectangles = (int) (cS / maxScore);
				for (int j = 0; j < numberOfRectangles; j++) {
					pGraph.rect(offset/2, -offset/2 - j*(offset + rectanglesHeight), rectanglesWidth, rectanglesHeight);
				}
				pGraph.translate(offset + rectanglesWidth, 0);

			}

		}
		else {
			// we have to draw the scores from scores.size()-nbR to scores.size()-1
			for (int i = scores.size()-nbC; i < scores.size(); i++) {
				float cS = scores.get(i);
				int numberOfRectangles = (int) (cS / maxScore);
				for (int j = 0; j < numberOfRectangles; j++) {
					pGraph.rect(offset/2, -offset/2 - j*(offset + rectanglesHeight), rectanglesWidth, rectanglesHeight);
					pGraph.translate(0, -offset - rectanglesHeight);
				}
				pGraph.translate(offset + rectanglesWidth, 0);
			}
		}

		*/

		pGraph.endDraw();
		pGraph.popMatrix();

	}

	public PGraphics getPGraphics() {
		return pGraph;
	}



}
