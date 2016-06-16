/**
 * @file ImageProcessing.pde
 * @brief
 *
 * @author Pierre Thévenet
 * @author Thomas Avons
 * @author Johannes Beck
 * @date 2016-05-24
 */

import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.Arrays;

import processing.video.*;

class ImageProcessing2 extends PApplet {
  private Movie cam;
  private PImage img;
  private PImage sobelI;
  private TwoDThreeD tdtd;

  float a = 90; // hue min
  float b = 140; // hue max
  float c = 100; // saturation min


  public ImageProcessing2(Movie cam) {
    this.cam = cam;
  }

  void settings() {
      size(640, 480);
  }
  void setup() {
      cam = new Movie(this, "testvideo.mp4");
      cam.loop();
  }

  PVector process() {
    // Hue & Saturation thresholding constants
    if (cam.available() == true) {
      cam.read();
      img = createImage(640, 480, RGB);
      img.copy(cam,  0,0, 640, 480,  0,0, 640, 480);

      PImage s = sobel(binaryThreshold(gaussianBlur(selectColor(img, a, b, c)) ,85));
      //image(s, 0, 0);

      // HOUGH
      ArrayList<PVector> hLines = hough(s, 6, 100);
      ArrayList<PVector> hIntersections = getIntersections(hLines);

      QuadGraph QG = new QuadGraph();
      QG.build(hLines, s.width, s.height);
      QG.findCycles();
      int[] quad = QG.getBiggestCycle();

      if(quad.length == 4) { // We found a valid quad
        tdtd = new TwoDThreeD(img.width, img.height);
        PVector l1 = hLines.get(quad[0]);
        PVector l2 = hLines.get(quad[1]);
        PVector l3 = hLines.get(quad[2]);
        PVector l4 = hLines.get(quad[3]);
        /*
        PVector c12 = intersection(l1, l2);
        PVector c23 = intersection(l2, l3);
        PVector c34 = intersection(l3, l4);
        PVector c41 = intersection(l4, l1);
        */

        List<PVector> inters = Arrays.asList(intersection(l1, l2), intersection(l2, l3), intersection(l3, l4), intersection(l4, l1));
        if (inters.size() == 4) {
          inters = sortCorners(inters);
          PVector drotations = tdtd.get3DRotations(inters);
          //println("x : " + (int)(Math.toDegrees(drotations.x)) + " y : " + (int)(Math.toDegrees(drotations.y)) + " z : " + (int)(Math.toDegrees(drotations.z)));
          return drotations;
        }
      }
    }
    return null;
  }

  void draw() {
    // Hue & Saturation thresholding constants

    if (cam.available() == true) {
      cam.read();
    }
    img = cam.get();
    image(img, 0, 0);

    PImage s = img;

    // HUE / BRIGHTNESS / SATURATION thresholding
    s = selectColor(s, a, b, c); // hue & saturation
    // BLURRING
    s = gaussianBlur(s);
    // INTENSITY
    s = binaryThreshold(s, 85);

    // SOBEL
    s = sobel(s);
    //image(s, 0, 0);

    // HOUGH
    ArrayList<PVector> hLines = hough(s, 6, 100);
    ArrayList<PVector> hIntersections = getIntersections(hLines);

    QuadGraph QG = new QuadGraph();
    QG.build(hLines, s.width, s.height);
    QG.findCycles();
    int[] quad = QG.getBiggestCycle();

    if(quad.length == 4) { // We found a valid quad
      PVector l1 = hLines.get(quad[0]);
      PVector l2 = hLines.get(quad[1]);
      PVector l3 = hLines.get(quad[2]);
      PVector l4 = hLines.get(quad[3]);
      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      List<PVector> inters = Arrays.asList(c12, c23, c34, c41);
      inters = sortCorners(inters);
      TwoDThreeD tdtd = new TwoDThreeD(img.width, img.height);
      PVector drotations = tdtd.get3DRotations(inters);

      printAsLines(Arrays.asList(l1,l2,l3,l4), img.width, img.height);
      printAsPoints(Arrays.asList(c12,c23,c34,c41));
    }

  }

}