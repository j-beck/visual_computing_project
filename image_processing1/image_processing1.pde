PImage img;
HScrollbar thresholdBar;

HScrollbar hueBar1;
HScrollbar hueBar2;

void settings() {
	size(800, 600);
}

void setup() {
	img = loadImage("board1.jpg");
	//thresholdBar = new HScrollbar(0, 580, 800, 20);
	hueBar1 = new HScrollbar(0, 580, 800, 20);
	hueBar2 = new HScrollbar(0, 550, 800, 20);


}

void draw() {
	PImage s = sobel(img);
	image(s, 0, 0);

}

PImage binaryThreshold(PImage img, float threshold) {
	PImage result = createImage(width, height, RGB);
	for (int i = 0; i < img.width * img.height; i++) {
		if (brightness(img.pixels[i]) >= threshold) {
			result.pixels[i] = color(255, 255, 255);
		} else {
			result.pixels[i] = color(0, 0, 0);
		}
	}
	return result;
}

PImage inverseBinaryThreshold(PImage img, float threshold) {
	PImage result = createImage(img.width, img.height, RGB);
	for (int i = 0; i < img.width * img.height; i++) {
		if (brightness(img.pixels[i]) < threshold) {
			result.pixels[i] = color(255, 255, 255);
		} else {
			result.pixels[i] = color(0, 0, 0);
		}
	}
	return result;
}

PImage hueImage(PImage img) {
		PImage result = createImage(img.width, img.height, RGB);
		for (int i = 0; i < img.width * img.height; i++) {
			float h = hue(img.pixels[i]);
			result.pixels[i] = color(h);
		}
	return result;
}

PImage selectColor(PImage img, float a, float b)  {

	PImage result = createImage(img.width, img.height, RGB);
	if (a < b) {
		for (int i = 0; i < img.width * img.height; i++) {
			float h = hue(img.pixels[i]);
			if (h >= a && h <= b) {
				result.pixels[i] = img.pixels[i];
			} else {
				result.pixels[i] = color(0);
			}
		}
	}
	return result;
}

PImage convolute(PImage img, float[][] kernel, int N) {
	PImage result = createImage(img.width, img.height, RGB);
	for (int x = N/2; x < img.width - N/2; x++) {
		for (int y = N/2; y < img.height - N/2; y++) {

			float sum = 0;
			float weightsum = 0;
			for (int k = 0; k < N; k++) {
				for (int l = 0; l < N; l++) {
					int a = x - N/2 + k;
					int b = y - N/2 + l;
					sum += brightness(img.pixels[a + b * img.width]) * kernel[k][l];
					weightsum += kernel[k][l];
				}
			}

			sum /= weightsum;
			result.pixels[x + y * img.width] = color(sum);

		}
	}
	return result;
}

PImage sobel(PImage img) {
	float [][] k1 = {	{0, 1, 0},
						{0, 0, 0},
						{0, -1, 0}	};
	float [][] k2 = {	{0, 0, 0},
						{1, 0, -1},
						{0, 0, 0}	};
	int N = 3;

	PImage result = createImage(img.width, img.height, ALPHA);
	// clear the image
	for (int i = 0; i < result.width * result.height; i++) {
		result.pixels[i] = color(0);
	}
	float[] buffer = new float[img.	width * img.height];
	float maxValue = 0;

	for (int x = N/2; x < result.width - N/2; x++) {
		for (int y = N/2; y < result.height - N/2; y++) {
			float sum_h = 0;
			float sum_v = 0;
			float weightsum_h = 0;
			float weightsum_v = 0;
			for (int k = 0; k < N; k++) {
				for (int l = 0; l < N; l++) {
					int a = x - N/2 + k;
					int b = y - N/2 + l;
					sum_h += brightness(img.pixels[a + b * img.width]) * k1[k][l];
					sum_v += brightness(img.pixels[a + b * img.width]) * k2[k][l];
					weightsum_h += k1[k][l];
					weightsum_v += k2[k][l];
				}
			}
			buffer[x + y * result.width] = sqrt( pow(sum_h, 2) + pow(sum_v, 2) );
			maxValue = max(maxValue, buffer[x + y * result.width]);
		}
	}

	for (int y = 2; y < result.height - 2; y++) {
		// Skip top and bottom edges
		for (int x = 2; x < result.width - 2; x++) {
			// Skip left and right
			if (buffer[y * result.width + x] > (int)(maxValue * 0.3f)) {
				// 30% of the max
				result.pixels[y * result.width + x] = color(255);
			} else {
				result.pixels[y * result.width + x] = color(0);
			}
		}
	}
	return result;

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class HScrollbar {
  float barWidth;  //Bar's width in pixels
  float barHeight; //Bar's height in pixels
  float xPosition;  //Bar's x position in pixels
  float yPosition;  //Bar's y position in pixels

  float sliderPosition, newSliderPosition;    //Position of slider
  float sliderPositionMin, sliderPositionMax; //Max and min values of slider

  boolean mouseOver;  //Is the mouse over the slider?
  boolean locked;     //Is the mouse clicking and dragging the slider now?

  /**
   * @brief Creates a new horizontal scrollbar
   *
   * @param x The x position of the top left corner of the bar in pixels
   * @param y The y position of the top left corner of the bar in pixels
   * @param w The width of the bar in pixels
   * @param h The height of the bar in pixels
   */
  HScrollbar (float x, float y, float w, float h) {
    barWidth = w;
    barHeight = h;
    xPosition = x;
    yPosition = y;

    sliderPosition = xPosition + barWidth/2 - barHeight/2;
    newSliderPosition = sliderPosition;

    sliderPositionMin = xPosition;
    sliderPositionMax = xPosition + barWidth - barHeight;
  }

  /**
   * @brief Updates the state of the scrollbar according to the mouse movement
   */
  void update() {
    if (isMouseOver()) {
      mouseOver = true;
    }
    else {
      mouseOver = false;
    }
    if (mousePressed && mouseOver) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderPosition = constrain(mouseX - barHeight/2, sliderPositionMin, sliderPositionMax);
    }
    if (abs(newSliderPosition - sliderPosition) > 1) {
      sliderPosition = sliderPosition + (newSliderPosition - sliderPosition);
    }
  }

  /**
   * @brief Clamps the value into the interval
   *
   * @param val The value to be clamped
   * @param minVal Smallest value possible
   * @param maxVal Largest value possible
   *
   * @return val clamped into the interval [minVal, maxVal]
   */
  float constrain(float val, float minVal, float maxVal) {
    return min(max(val, minVal), maxVal);
  }

  /**
   * @brief Gets whether the mouse is hovering the scrollbar
   *
   * @return Whether the mouse is hovering the scrollbar
   */
  boolean isMouseOver() {
    if (mouseX > xPosition && mouseX < xPosition+barWidth &&
      mouseY > yPosition && mouseY < yPosition+barHeight) {
      return true;
    }
    else {
      return false;
    }
  }

  /**
   * @brief Draws the scrollbar in its current state
   */
  void display() {
    noStroke();
    fill(204);
    rect(xPosition, yPosition, barWidth, barHeight);
    if (mouseOver || locked) {
      fill(0, 0, 0);
    }
    else {
      fill(102, 102, 102);
    }
    rect(sliderPosition, yPosition, barHeight, barHeight);
  }

  /**
   * @brief Gets the slider position
   *
   * @return The slider position in the interval [0,1] corresponding to [leftmost position, rightmost position]
   */
  float getPos() {
    return (sliderPosition - xPosition)/(barWidth - barHeight);
  }
}
