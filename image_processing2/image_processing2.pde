import processing.video.*;

Capture cam;
PImage img;

float[][] gaussianKernel = {  {9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}  };


void settings() {
  size(1000,1000);
}
void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    //cam = new Capture(this,  640, 480, 10);
    //cam.start();
  }
}

void draw() {
  //if (cam.available() == true) {
  //  cam.read();
  //}
  float a = 100;
  float b = 140;
  float c = 130;
  img = loadImage("board1.jpg");
  //img = cam.get();
  //PImage s = convolute(img, gaussianKernel, 3);
  PImage s = convolute(selectColor(img, a, b, c), gaussianKernel, 3);
  s = sobel(s);
  //s = convolute(s, gaussianKernel, 3);
  image(img, 0, 0);
  hough(s);
  //img = cam.get();	
  //image(img, 0, 0);
}

void hough(PImage edgeImg) {

  float discretizationStepsPhi = .06f;
  float discretizationStepsR = 2.5f;

  //dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) *2 +1) / discretizationStepsR);

  int[] accumulator = new int[(phiDim +2) * (rDim +2)];

  for (int y = 0; y < edgeImg.height; ++y) {
    for (int x = 0; x < edgeImg. width; ++x) {
      if (brightness(edgeImg.pixels[y * edgeImg.width +x]) != 0) {
        for (int i = 0; i < phiDim + 2; ++i) {
          float phi = i * discretizationStepsPhi;
          int r =(int) ((x * cos(phi) + y * sin(phi))/discretizationStepsR);
          int maxval = (rDim - 1) /2;
          //r = min(max(r,-maxval),maxval);
          if(-maxval <= r && r <= maxval)
            ++accumulator[i *(rDim + 2) + r + maxval];
        }
      }
    }
  }

  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > 250) {
      // first, compute back the (r, phi) polar coordinates:

      int accPhi = (int) (idx / (rDim + 2)) ;
      int accR = idx - accPhi*(rDim + 2);
      float r = (accR - (rDim -1) / 2.)* discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
    }
  }
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

PImage selectColor(PImage img, float a, float b, float minSaturation) {
  PImage result = createImage(img.width, img.height, RGB);
  if (a < b) {
    for (int i = 0; i < img.width * img.height; i++) {
      float h = hue(img.pixels[i]);
      if (h >= a && h <= b && saturation(img.pixels[i]) > minSaturation) { // On supprime les couleur trop claires
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
  float [][] k1 = {  {0, 1, 0}, 
    {0, 0, 0}, 
    {0, -1, 0}  };
  float [][] k2 = {  {0, 0, 0}, 
    {1, 0, -1}, 
    {0, 0, 0}  };
  int N = 3;

  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < result.width * result.height; i++) {
    result.pixels[i] = color(0);
  }
  float[] buffer = new float[img.  width * img.height];
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