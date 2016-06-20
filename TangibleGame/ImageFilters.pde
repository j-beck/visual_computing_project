/**
 * @file ImageFilters.pde
 * @brief Methods to filter an image
 *
 * @author Pierre Thévenet
 * @author Thomas Avons
 * @author Johannes Beck
 * @date 2016-05-18
 */

public PImage binaryThreshold(PImage img, float threshold)
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

public PImage inverseBinaryThreshold(PImage img, float threshold)
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

public PImage hueImage(PImage img)
{
    PImage result = createImage(img.width, img.height, RGB);
    for (int i = 0; i < img.width * img.height; i++) {
        float h = hue(img.pixels[i]);
        result.pixels[i] = color(h);
    }
    return result;
}

public PImage selectColor(PImage img, float a, float b, float minSaturation)
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

public PImage convolute(PImage img, float[][] kernel, int N)
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

public PImage gaussianBlur(PImage img)
{
    float[][] gaussianKernel = {	{9, 12, 9},
        {12, 15, 12},
        {9, 12, 9}
    };

    return this.convolute(img, gaussianKernel, 3);
}

public PImage sobel(PImage img)
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
