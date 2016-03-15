class Mover {
  PVector location;
  PVector velocity;
  final PVector GRAVITY = new PVector(0, 0.4981);
  
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(1, 1);
  }
  
  void update() {
    location.add(velocity.add(GRAVITY));
  }
  
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }
  
  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    }
    else if (location.x < 0) {
      location.x = 0;
      velocity.x *= -1;
    }
    
    if (location.y > height) {
      location.y = height;
      velocity.y *= -1;
    }
    else if (location.y < 0) {
      location.y = 0;
      velocity.y *= -1;
    }
  }
    
}