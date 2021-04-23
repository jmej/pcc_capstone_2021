
class ObjParticle {
  
  PVector initialPosition;
  PVector currentPosition;
  float r = 0.3;
  float step = 0.01;
  float currentStep = 0.0;
  boolean reachedLine = false;
  boolean line = false;
  float time = random(4000, 30000);
  PVector d;
  PVector dv;
  
  ObjParticle(float x, float y, float z) {
    initialPosition = new PVector(x, y, z);
    currentPosition = new PVector(x, y, z);
    
  }
  
  void update(PVector destination) {
    currentPosition = PVector.lerp(initialPosition, destination, currentStep);
    if (currentStep < 1.0) {
      currentStep += step;
    }
    else {
      reachedLine = true;
    }
  }
  
  void display(float size) {
    push();
    noStroke();
    fill(255);
    translate(0, 0, currentPosition.z);
    ellipse(currentPosition.x, currentPosition.y, size, size);
    pop();
  }
  
  float getTime() {
    return time;
  }
  
  boolean getStep() {
    return reachedLine;
  }
  
  boolean connected() {
    return line;
  }
  
  //PVector getDestination() {
  //  return destination;
  //}
  
}
