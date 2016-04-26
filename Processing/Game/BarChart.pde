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
		int nbColumns = BCWidth / (rectanglesWidth + offset); // number of 'columns' in the drawing
		int nbLines = BCHeight / (rectanglesHeight + offset);
		int m = nbColumns;

		int size = scores.size();
		if (size > 0 && scores.get(size-1) != lastScore && ( abs(scores.get(size-1)-lastScore)/maxScore )*nbLines >= 1 ) {
			this.scores.add(lastScore);
		} else if (size <= 0) {
			this.scores.add(lastScore);
		}
		this.maxScore = max(maxScore, lastScore);



		pGraph.pushMatrix();
		pGraph.beginDraw();
		pGraph.background(245);
		pGraph.translate(0, BCHeight - offset);
		pGraph.fill(51,153,255);

		int start = max(size - m, 0);


		for (int i = 0; i < min(m, size); i++) {
			int nbRect = (int)((scores.get(start + i) / maxScore) * nbLines);
			for (int j = 0; j < nbRect; j++) {
				pGraph.rect(offset/2 + i * (offset + rectanglesWidth), - j * (offset + rectanglesHeight), rectanglesWidth, -rectanglesHeight);
			}
		}

		pGraph.endDraw();
		pGraph.popMatrix();

	}

	public PGraphics getPGraphics() {
		return pGraph;
	}

	public void setRectanglesWidth(int newWidth) {
		// TODO : arbitrary max
		if (newWidth > 0 && newWidth < 20) {
			this.rectanglesWidth = newWidth;
		}
	}

}
