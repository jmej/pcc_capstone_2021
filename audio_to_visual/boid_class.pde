
class ObjParticle {
  
  PVector currentPosition;
  float r = 0.3;
  
  ObjParticle(float x, float y, float z) {
    currentPosition = new PVector(x, y, z);
    
  }
  
  void display(float size) {
    push();
    noStroke();
    fill(255);
    translate(0, 0, currentPosition.z);
    ellipse(currentPosition.x, currentPosition.y, size, size);
    pop();
  }
}
