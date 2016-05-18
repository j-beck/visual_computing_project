/**
 * @file PrintVectors.pde
 * @brief Methods for printing PVectors
 *
 * @author Pierre Thévenet
 * @author Thomas Avons
 * @author Johannes Beck
 * @date 2016-05-18
 */

void printAsPoints(List<PVector> points)
{
    pushStyle();
    for (int i = 0; i < points.size(); i ++) {
        fill(255, 128, 0);
        ellipse(points.get(i).x, points.get(i).y, 10, 10);
    }
    popStyle();
}

void printAsLines(List<PVector> lines, int width, int height)
{
    for (int i = 0; i < lines.size(); i++) {
        float r = lines.get(i).x;
        float phi = lines.get(i).y;
        int x0 = 0;
        int y0 = (int) (r / sin(phi));
        int x1 = (int) (r / cos(phi));
        int y1 = 0;
        int x2 = width;
        int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
        int y3 = width;
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
