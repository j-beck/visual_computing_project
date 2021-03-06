import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.Arrays;

int ORIG_WIDTH;
int ORIG_HEIGHT;
float RESIZE_FACTOR;
int IMG_HEIGHT;
int IMG_WIDTH = 400; //the width of the output images.


String imgName = "board1.jpg";

float[][] gaussianKernel = {	{9, 12, 9},
    {12, 15, 12},
    {9, 12, 9}
};

void settings()
{
    PImage img = loadImage(imgName);
    ORIG_WIDTH = img.width;
    ORIG_HEIGHT = img.height;
    RESIZE_FACTOR = IMG_WIDTH/(float)ORIG_WIDTH;
    IMG_HEIGHT = IMG_WIDTH*ORIG_HEIGHT/ORIG_WIDTH;
    size(IMG_WIDTH*3, IMG_HEIGHT);
}

void draw()
{
    float minHue = 90;
    float maxHue = 140;
    float maxSat = 68;
    float brightnessThreshold = 33;

    PImage img = loadImage(imgName);

    // HUE / BRIGHTNESS / SATURATION thresholding
    PImage s = img;
    s = selectColor(s, minHue, maxHue, maxSat); // hue & saturation

    // BLURRING
    s = convolute(s, gaussianKernel, 3);
    // INTENSITY
    s = binaryThreshold(s, brightnessThreshold);

    // SOBEL
    s = sobel(s);

    // HOUGH
    PImage houghImg = createImage(1,1, ALPHA); //output image, will be resized by the houghWithDisplayfunction.
    ArrayList<PVector> hLines = houghWithDisplay(s,houghImg, 6, 100);


    // EXTRACT BEST RESULT:
    QuadGraph QG = new QuadGraph();
    QG.build(hLines, s.width, s.height);
    QG.findCycles();

    int[] quad = QG.getBiggestCycle();


    // PRINT RESULTS TO SCREEN

    // I. Four corners of the best quad detected
    img.resize(IMG_WIDTH, IMG_HEIGHT);
    image(img,0,0);
    if(quad.length > 0) {
        PVector l1 = hLines.get(quad[0]);
        PVector l2 = hLines.get(quad[1]);
        PVector l3 = hLines.get(quad[2]);
        PVector l4 = hLines.get(quad[3]);
        PVector c12 = intersection(l1, l2);
        PVector c23 = intersection(l2, l3);
        PVector c34 = intersection(l3, l4);
        PVector c41 = intersection(l4, l1);

        printLines(Arrays.asList(l1,l2,l3,l4));
        printIntersections(Arrays.asList(c12,c23,c34,c41));
    }

    // II. Hough accumulator
    houghImg.resize(IMG_WIDTH,IMG_HEIGHT);
    image(houghImg, IMG_WIDTH, 0);

    // III. Sobel edge detector
    s.resize(IMG_WIDTH, IMG_HEIGHT);
    image(s,2*IMG_WIDTH,0);
}



ArrayList<PVector> houghWithDisplay(PImage edgeImg,PImage outImg, int nLines, int minVotes)
{
    float discretizationStepsPhi = .06f;
    float discretizationStepsR = 2.5f;

    // dimensions of the accumulator
    int phiDim = (int) (Math.PI / discretizationStepsPhi);
    int rDim = (int) (((edgeImg.width + edgeImg.height) *2 +1) / discretizationStepsR);


    // pre-compute the sin and cos values
    float[] tabSin = new float[phiDim];
    float[] tabCos = new float[phiDim];
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
        // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
        tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
        tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }

    int[] accumulator = new int[(phiDim +2) * (rDim +2)];

    for (int y = 0; y < edgeImg.height; ++y) {
        for (int x = 0; x < edgeImg. width; ++x) {
            if (brightness(edgeImg.pixels[y * edgeImg.width +x]) != 0) {
                for (int i = 0; i < phiDim ; ++i) {
                    float phi = i * discretizationStepsPhi;
                    //int r =(int) ((x * cos(phi) + y * sin(phi))/discretizationStepsR);
                    int r = (int) ( x * tabCos[i] + y * tabSin[i]);
                    int maxval = (rDim - 1) /2;
                    //r = min(max(r,-maxval),maxval);
                    if (-maxval <= r && r <= maxval)
                        ++accumulator[i *(rDim + 2) + r + maxval];
                }
            }
        }
    }


    outImg.resize(rDim +2, phiDim +2);
    for (int i = 0; i < accumulator.length; i++) {
        outImg.pixels[i] = color(min(255, accumulator[i]));
    }
    outImg.updatePixels();

    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();

    // neighbourhood maxima

    // size of the region we search for a local maximum
    int neighbourhood = 10;
    // only search around lines with more that this amount of votes
    // (to be adapted to your image)
    for (int accR = 0; accR < rDim; accR++) {
        for (int accPhi = 0; accPhi < phiDim; accPhi++) {
            // compute current index in the accumulator
            int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
            if (accumulator[idx] > minVotes) {
                boolean bestCandidate=true;
                // iterate over the neighbourhood
                for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
                    // check we are not outside the image
                    if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
                    for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
                        // check we are not outside the image
                        if (accR+dR < 0 || accR+dR >= rDim) continue;
                        int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
                        if (accumulator[idx] < accumulator[neighbourIdx]) {
                            // the current idx is not a local maximum!
                            bestCandidate=false;
                            break;
                        }
                    }
                    if (!bestCandidate) break;
                }
                if (bestCandidate) {
                    // the current idx *is* a local maximum
                    bestCandidates.add(idx);
                }
            }
        }
    }

    Collections.sort(bestCandidates, new HoughComparator(accumulator));

    // Line list making
    ArrayList<PVector> lines = new ArrayList<PVector>();
    for (int i = 0; i < min(nLines, bestCandidates.size()); i++) {
        int idx = bestCandidates.get(i);
        int accPhi = (int) (idx / (rDim + 2)) ;
        int accR = idx - accPhi*(rDim + 2);
        float r = (accR - (rDim -1) / 2.)* discretizationStepsR;
        float phi = accPhi * discretizationStepsPhi;
        lines.add(new PVector(r, phi));
    }

    return lines;
}

PVector intersection(PVector v1, PVector v2)
{
    float phi1 = v1.y;
    float phi2 = v2.y;
    float r1 = v1.x;
    float r2 = v2.x;
    float d = cos(phi2)*sin(phi1) - cos(phi1)*sin(phi2);
    float x = r2 * sin(phi1) - r1 * sin(phi2);
    x = x / d;
    float y = r1 * cos(phi2) - r2 * cos(phi1);
    y = y / d;
    return new PVector(x, y);
}

void printIntersections(List<PVector> intersections)
{
    pushStyle();
    for (int i = 0; i < intersections.size(); i ++) {
        fill(255, 128, 0);
        ellipse(intersections.get(i).x*RESIZE_FACTOR, intersections.get(i).y*RESIZE_FACTOR, 10*RESIZE_FACTOR, 10*RESIZE_FACTOR);
    }
    popStyle();
}


void printLines(List<PVector> lines)
{
    for (int i = 0; i < lines.size(); i++) {
        float r = lines.get(i).x;
        float phi = lines.get(i).y;
        int x0 = 0;
        int y0 = (int) (r / sin(phi));
        int x1 = (int) (r / cos(phi));
        int y1 = 0;
        int x2 = ORIG_WIDTH;
        int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
        int y3 = ORIG_WIDTH;
        int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
        // Finally, plot the lines
        stroke(204, 102, 0);
        if (y0 > 0) {
            if (x1 > 0)
                line(x0*RESIZE_FACTOR, y0*RESIZE_FACTOR, x1*RESIZE_FACTOR, y1*RESIZE_FACTOR);
            else if (y2 > 0)
                line(x0*RESIZE_FACTOR, y0*RESIZE_FACTOR, x2*RESIZE_FACTOR, y2*RESIZE_FACTOR);
            else
                line(x0*RESIZE_FACTOR, y0*RESIZE_FACTOR, x3*RESIZE_FACTOR, y3*RESIZE_FACTOR);
        } else {
            if (x1 > 0) {
                if (y2 > 0)
                    line(x1*RESIZE_FACTOR, y1*RESIZE_FACTOR, x2*RESIZE_FACTOR, y2*RESIZE_FACTOR);
                else
                    line(x1*RESIZE_FACTOR, y1*RESIZE_FACTOR, x3*RESIZE_FACTOR, y3*RESIZE_FACTOR);
            } else
                line(x2*RESIZE_FACTOR, y2*RESIZE_FACTOR, x3*RESIZE_FACTOR, y3);
        }
    }
}


//----------------------------------------------------------------------------//
//--------------------Image Processing Methods--------------------------------//
//----------------------------------------------------------------------------//

PImage binaryThreshold(PImage img, float threshold)
{
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
        if (brightness(img.pixels[i]) >= threshold) {
            result.pixels[i] = color(255, 255, 255);
        } else {
            result.pixels[i] = color(0, 0, 0);
        }
    }
    return result;
}

PImage inverseBinaryThreshold(PImage img, float threshold)
{

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

/**
 *	@brief Returns an filtered image where every pixels is grey-scaled to the original hue of this pixel
 *	@param img Input image
*/
PImage hueImage(PImage img)
{
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
        float h = hue(img.pixels[i]);
        result.pixels[i] = color(h);
    }
    return result;
}

/**
 * @brief Returns a copy of the image containing all the pixels of color in [a,b] of saturation greater that minSaturation, and filled with black for the other pixels
 * @param img Input image
 * @param a Min hue
 * @param b Max hue
 * @param minSaturation Min saturation
*/
PImage selectColor(PImage img, float a, float b, float minSaturation)
{
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

/**
 * @brief Returns a convoluted copy of the image with the given kernel, a matrix of size N*N
 * @param img The image to convolute
 * @param kernel The convolution kernel
 * @param N The size of the kernel : kernel is of size N*N
*/
PImage convolute(PImage img, float[][] kernel, int N)
{
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

/**
 * @brief Returns the result of the Sobel algorithm
 * @param img Input image
*/
PImage sobel(PImage img)
{
    float [][] k1 = {  {0, 1, 0},
        {0, 0, 0},
        {0, -1, 0}
    };
    float [][] k2 = {  {0, 0, 0},
        {1, 0, -1},
        {0, 0, 0}
    };
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

//----------------------------------------------------------------------------//
//-------------------------Hough Comparator-----------------------------------//
//----------------------------------------------------------------------------//

class HoughComparator implements java.util.Comparator<Integer>
{
    int[] accumulator;
    public HoughComparator(int[] accumulator) {
        this.accumulator = accumulator;
    }
    @Override
    public int compare(Integer l1, Integer l2) {
        if (accumulator[l1] > accumulator[l2] || (accumulator[l1] == accumulator[l2] && l1 < l2))
            return -1;
        return 1;
    }
}
