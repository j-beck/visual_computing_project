/**
 * @file Hough.pde
 * @brief Hough algorithm implementation
 *
 * @author Pierre Thévenet
 * @author Thomas Avons
 * @author Johannes Beck
 * @date 2016-05-18
 */
ArrayList<PVector> hough(PImage img, int nLines, int minVotes)
{
    float discretizationStepsPhi = .06f;
    float discretizationStepsR = 2.5f;

    //dimensions of the accumulator
    int phiDim = (int) (Math.PI / discretizationStepsPhi);
    int rDim = (int) (((img.width + img.height) *2 +1) / discretizationStepsR);

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

    for (int y = 0; y < img.height; ++y) {
        for (int x = 0; x < img. width; ++x) {
            if (brightness(img.pixels[y * img.width +x]) != 0) {
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
