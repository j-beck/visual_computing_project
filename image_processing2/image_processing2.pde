import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.Arrays;

import processing.video.*;

Capture cam;
PImage img;

void settings()
{
    size(640, 480);
}
void setup()
{
/*
    String[] cameras = Capture.list();

    if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
    } else {

        //println("Available cameras:");
        //for (int i = 0; i < cameras.length; i++) {
        //    println(i + cameras[i]);
        //}


        cam = new Capture(this, 640, 480, 30);
    	cam.start();
    }
	*/
}

void draw()
{
    float a = 90;
    float b = 140;
    float c = 70;
    img = loadImage("board2.jpg");

	/*
    if (cam.available() == true) {
        cam.read();
    }
    img = cam.get();
	*/


    image(img, 0, 0); // background
    PImage s = img;

    // HUE / BRIGHTNESS / SATURATION thresholding
    s = selectColor(s, a, b, c); // hue & saturation
    // BLURRING
    s = gaussianBlur(s);
    // INTENSITY
    s = binaryThreshold(s, 30);

    // SOBEL
    s = sobel(s);

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
        // (intersection() is a simplified version of the
        // intersections() method you wrote last week, that simply
        // return the coordinates of the intersection between 2 lines)
        PVector c12 = intersection(l1, l2);
        PVector c23 = intersection(l2, l3);
        PVector c34 = intersection(l3, l4);
        PVector c41 = intersection(l4, l1);

        // Prints rotations :
        List<PVector> inters = new ArrayList<PVector>();
        inters.add(c12);
        inters.add(c23);
        inters.add(c34);
        inters.add(c41);
        //inters = sortCorners(inters);
        TwoDThreeD tdtd = new TwoDThreeD(img.width, img.height);
        PVector drotations = tdtd.get3DRotations(inters);
		println("rx : " + (int)Math.toDegrees(drotations.x) + " ry : " + (int)Math.toDegrees(drotations.y) + " rz : " + (int)Math.toDegrees(drotations.z));


		// Prints lines and intersections
		printAsLines(Arrays.asList(l1,l2,l3,l4), img.width, img.height);
		printAsPoints(Arrays.asList(c12,c23,c34,c41));

    }

}


PVector intersection(PVector v1, PVector v2)
{
    float phi1 = v1.y;
    float phi2 = v2.y;
    float r1 = v1.x;
    float r2 = v2.x;
    float d = cos(phi2)*sin(phi1) - cos(phi1)*sin(phi2);
    float x = r2 * sin(phi1) - r1 * sin(phi2);
    x = x/ d;
    float y = r1 * cos(phi2) - r2 * cos(phi1);
    y = y / d;
    return new PVector(x, y);

}

ArrayList<PVector> getIntersections(List<PVector> lines)
{
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < lines.size() - 1; i++) {
        PVector line1 = lines.get(i);
        for (int j = i + 1; j < lines.size(); j++) {
            PVector line2 = lines.get(j);
            // compute the intersection and add it to 'intersections'
            float phi1 = line1.y;
            float phi2 = line2.y;
            float r1 = line1.x;
            float r2 = line2.x;
            float d = cos(phi2)*sin(phi1) - cos(phi1)*sin(phi2);
            float x = r2 * sin(phi1) - r1 * sin(phi2);
            x = x/ d;
            float y = r1 * cos(phi2) - r2 * cos(phi1);
            y = y / d;
            intersections.add(new PVector(x, y));
        }
    }
    return intersections;
}

static class CWComparator implements Comparator<PVector>
{
    PVector center;

    public CWComparator(PVector center) {
        this.center = center;
    }

    @Override
    public int compare(PVector b, PVector d) {
        if(Math.atan2(b.y-center.y,b.x-center.x)<Math.atan2(d.y-center.y,d.x-center.x))
            return -1;
        else return 1;
    }
}

public static List<PVector> sortCorners(List<PVector> quad)
{
    // Sort corners so that they are ordered clockwise
    PVector a = quad.get(0);
    PVector b = quad.get(2);
    PVector center = new PVector((a.x+b.x)/2,(a.y+b.y)/2);
    Collections.sort(quad, new CWComparator(center));

    // Re-orders the corners so that the first one is the closest to the origin (0,0) of the image
    int closest = 0;
    double smallestDistance= Math.sqrt(quad.get(0).x * quad.get(0).x + quad.get(0).y * quad.get(0).y);
    for (int i = 1; i < 4; i++) {
        double distance = Math.sqrt(quad.get(i).x * quad.get(i).x + quad.get(i).y * quad.get(i).y);
        if (distance < smallestDistance) {
            smallestDistance = distance;
            closest = i;
        }
    }
    Collections.rotate(quad, -closest);
    return quad;
}
