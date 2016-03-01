/*
My2DPoint p1 = new My2DPoint(100,100);
My2DPoint p2 = new My2DPoint(100,200);
My2DPoint p3 = new My2DPoint(200,200);
My2DPoint p4 = new My2DPoint(200,100);
My2DPoint p5 = new My2DPoint(150,75);
My2DPoint p6 = new My2DPoint(150,175);
My2DPoint p7 = new My2DPoint(250,175);
My2DPoint p8 = new My2DPoint(250,75);

My2DPoint[] s = {p1, p2, p3, p4, p5, p6, p7, p8};
My2DBox box = new My2DBox(s);
*/

void settings() {
  size(400, 400, P2D);
}

void setup() {
}

void draw() {
  My3DPoint eye = new My3DPoint(-100, -100, -5000);
  My3DPoint origin = new My3DPoint(50, 50, 50);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  projectBox(eye, input3DBox).render();
}

/**
  *      Methods
**/

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float px = p.x + p.z * (eye.x/eye.z);
  float py = p.y + p.z * (eye.y/eye.z);
  return new My2DPoint(px, py);
}

My2DBox projectBox(My3DPoint eye, My3DBox box) {
  My2DPoint[] s = new My2DPoint[8] ;
  for (int i = 0; i < 8; ++i) {
    s[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(s);
}

float[] homgeneous3DPoint(My3DPoint p) {
  float[] result = { p.x, p.y, p.z, 1};
  return result;
}

float[][] rotateXMatrix( float angle ) { 
	return ( new float[][] {
		{ 1 , 0 , 0 , 0 }, 
		{ 0 , cos( angle ), -sin( angle ) , 0 }, 
		{ 0 , sin( angle ) , cos( angle ) , 0 }, 
		{ 0 , 0 , 0 , 1 }}
		);
}
float[][] rotateYMatrix( float angle ) { 
	return ( new float[][] {
		{ cos( angle ), 0,  sin( angle ) , 0 }, 
		{ 0 , 1 , 0 , 0 }, 
		{ -sin( angle ), 0 , cos( angle ) , 0 }, 
		{ 0 , 0 , 0 , 1 }}
		);
}
float[][] rotateZMatrix( float angle ) { 
	return ( new float[][] {
		{ cos( angle ), - sin( angle ) , 0 , 0}, 
		{ sin( angle ) , cos( angle ) , 0 , 0}, 
		{ 0 , 0 , 1 , 0 }, 
		{ 0 , 0 , 0 , 1 }}
		);
}

float[][] scaleMatrix( float x , float y , float z) { 
	return ( new float[][] {
		{ x , 0 , 0 , 0 }, 
		{ 0 , y , 0 , 0 }, 
		{ 0 , 0 , z , 0 }, 
		{ 0 , 0 , 0 , 1 }}
		);
}

float[][] translationMatrix( float x , float y , float z) { 
	return ( new float[][] {
		{ 1 , 0 , 0 , x }, 
		{ 0 , 1 , 0 , y }, 
		{ 0 , 0 , 1 , z }, 
		{ 0 , 0 , 0 , 1 }}
		);
}

float matrixProduct(float[][] a, float[] b) {
	int m = a.length;
	int n = b.length
	
	if(n == 0 || m == 0){
		throw new Exception("Empty matrix is not allowed");
	if(a[0].length != n)
		throw new Exception("Not possible to multiply.");
	float result = 0.0;
	for(int i = 0; i < m; ++i) {
		for(int j = 0; j< n ; ++j){
			result += a[i][j] * b[j]
		}
	}
	return result;
}


/**
  *      Classes
**/

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

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    for (int i = 0; i < 4; i++) {
      line(s[i].x, s[i].y, s[i+4].x, s[i+4].y);
      line(s[2*i].x, s[2*i].y, s[2*i + 1].x, s[2*i + 1].y);
    }
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[1].x, s[1].y, s[2].x, s[2].y);
    line(s[4].x, s[4].y, s[7].x, s[7].y);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
  }
}

class My3DBox {
   My3DPoint[] p;
   My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
     float x = origin.x;
     float y = origin.y;
     float z = origin.z;
     this.p = new My3DPoint[] {new My3DPoint(x, y+dimY, z+dimZ),
                               new My3DPoint(x, y, z+dimZ),
                               new My3DPoint(x+dimX, y, z+dimZ),
                               new My3DPoint(x+dimX, y+dimY, z+dimZ),
                               new My3DPoint(x, y+dimY, z),
                               origin,
                               new My3DPoint(x+dimX, y, z),
                               new My3DPoint(x+dimX, y+dimY, z)
                              };
   }
   My3DBox(My3DPoint[] p) {
     this.p = p;
   }
}
