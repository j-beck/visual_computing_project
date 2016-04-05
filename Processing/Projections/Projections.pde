void settings() {
  size(1000, 1000, P2D);

}
void setup() {

}
void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0); //The first vertex of your cuboid
  My3DBox input3DBox = new My3DBox(origin, 100,150,300);
  //rotated around x
  float[][] transform1 = rotateXMatrix(PI/8);
  input3DBox = transformBox(input3DBox, transform1); projectBox(eye, input3DBox).render();

  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();




}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float px = (p.x -eye.x)/(1-(p.z/eye.z));
  float py = (p.y -eye.y)/(1-(p.z/eye.z));
  return new My2DPoint(px,py);



}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    stroke(0,255,0);
    line(s[0].x,s[0].y, s[1].x, s[1].y);
    line(s[2].x,s[2].y, s[1].x, s[1].y);
    line(s[0].x,s[0].y, s[3].x, s[3].y);
    line(s[2].x,s[2].y, s[3].x, s[3].y);

    stroke(255,0,0);
    line(s[7].x,s[7].y, s[4].x, s[4].y);
    line(s[5].x,s[5].y, s[4].x, s[4].y);
    line(s[5].x,s[5].y, s[6].x, s[6].y);
    line(s[7].x,s[7].y, s[6].x, s[6].y);

    stroke(0,0,255);
    line(s[7].x,s[7].y, s[3].x, s[3].y);
    line(s[5].x,s[5].y, s[1].x, s[1].y);
    line(s[0].x,s[0].y, s[4].x, s[4].y);
    line(s[2].x,s[2].y, s[6].x, s[6].y);



  }
  /**for (int i = 0; i < 4; i++) {
       line(s[i].x, s[i].y, s[i+4].x, s[i+4].y);
       line(s[2*i].x, s[2*i].y, s[2*i + 1].x, s[2*i + 1].y);
     }
     line(s[0].x, s[0].y, s[3].x, s[3].y);
     line(s[1].x, s[1].y, s[2].x, s[2].y);
     line(s[4].x, s[4].y, s[7].x, s[7].y);
     line(s[5].x, s[5].y, s[6].x, s[6].y);
   } */


}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x,y+dimY,z+dimZ),
                             new My3DPoint(x,y,z+dimZ),
                             new My3DPoint(x+dimX,y,z+dimZ),
                             new My3DPoint(x+dimX,y+dimY,z+dimZ),
                             new My3DPoint(x,y+dimY,z),
                             origin,
                             new My3DPoint(x+dimX,y,z),
                             new My3DPoint(x+dimX,y+dimY,z)
                           };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {

  My2DPoint[] tab = new My2DPoint[8];
  for (int i=0; i<8; ++i) {

   tab[i] = projectPoint(eye, box.p[i]);

  }

  return new My2DBox(tab);

}




float[] homogeneous3DPoint(My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;

}

float [][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0, 0, 0},
                        {0, cos(angle), -sin(angle), 0},
                        {0, sin(angle), cos(angle), 0},
                        {0, 0, 0, 1}});

}

float [][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0, sin(angle), 0},
                        {0, 1, 0, 0},
                        {-sin(angle), 0, cos(angle), 0},
                        {0, 0, 0, 1}});

}

float [][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), -sin(angle), 0, 0},
                        {sin(angle), cos(angle), 0, 0},
                        {0, 0, 1, 0},
                        {0, 0, 0, 1}});

}

float [][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0, 0, 0},
                        {0, y, 0, 0},
                        {0, 0, z, 0},
                        {0, 0, 0, 1}});

}

float [][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0, 0, x},
                        {0, 1, 0, y},
                        {0, 0, 1, z},
                        {0, 0, 0, 1}});

}

float[] matrixProduct(float[][] a, float[] b) {

  float[] result = new float[a.length];
  for (int i=0; i<a.length; ++i) {
    for (int j=0; j<b.length; ++j) {
     result[i] += a[i][j]*b[j];
    }

  }


  return result;
}


My3DBox transformBox(My3DBox box, float[][] transformMatrix) {

 float[][] tab = new float[8][4];

 for (int i =0; i<8; ++i) {
   tab[i] = matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i]));

 }

 My3DPoint [] tabBis = new My3DPoint[8];
 for (int i =0; i<8; ++i) {
   tabBis[i] = euclidean3DPoint(tab[i]);


 }

  return new My3DBox(tabBis);


  /**
  My3DPoint[] np = new My3DPoint[8];
    for(int i = 0; i < 8; i++) {
       float[] b = homogeneous3DPoint(box.p[i]);
       float[] result = matrixProduct(transformMatrix, b);
       np[i] = euclidean3DPoint(result);
    }
     return new My3DBox(np);

*/

}











My3DPoint euclidean3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}
