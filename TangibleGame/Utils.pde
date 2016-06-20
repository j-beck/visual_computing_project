
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


public static PVector intersection(PVector v1, PVector v2)
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

public static ArrayList<PVector> getIntersections(List<PVector> lines)
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
