class AtoVNode implements ModNode {
  private int curFrame = 0;
  private PShape shape;
  public int bands = 3;
  private float smoothingFactor = 1;
  private float[] sum;
  private float ampSum;
  private float scale = 4;
  private float rms_scaled = 0;
  
  private PVector[] objVertices;
  private PVector[] linePoints;
  private int numOfVertices = 0;
  private ObjParticle[] particles;
  
  private int maxFreqIndex;
  private float max;
  private PGraphics canvas;
  
  AtoVNode(int bnds) {
    this.bands = bnds;
    this.sum = new float[this.bands];
  }

  void init(Settings set) {
    shape = loadShape((String)set.get("objPath"));
  
    int indexOffset = 0;
    
    for (int i = 0; i < shape.getChildCount(); i++) {
      PShape child = shape.getChild(i);
      numOfVertices += child.getVertexCount();
    }
    
    linePoints = new PVector[numOfVertices];
    
    for (int i = 0; i < numOfVertices; i++) {
      float yVal = height/73 * floor(i/678);
      linePoints[i] = new PVector((i%678)*(width/(numOfVertices/73)) - width/2, yVal - height/2, 0); 
    }
  
    objVertices = new PVector[numOfVertices];
    
    for (int i = 0; i < shape.getChildCount(); i++) {
      PShape child = shape.getChild(i);
      for (int j = 0; j < child.getVertexCount(); j++) {
        PVector v = child.getVertex(j);
        objVertices[i + j + indexOffset] = v;
      }
      indexOffset += child.getVertexCount() - 1;
    }
     
    particles = new ObjParticle[numOfVertices];
    
    for (int i = 0; i < objVertices.length; i++) {
      particles[i] = new ObjParticle(objVertices[i].x, objVertices[i].y, objVertices[i].z);
    }

    
    soundSource.play(1, 0, 1.0, 0, curFrame);
    soundSource.amp(1);
    fft.input(soundSource);
    rms.input(soundSource);
    soundSource.pause();
    
    rectMode(CENTER);
  }
  
  PImage mod(PImage f) {
    canvas = createGraphics(width, height, P2D);
    canvas.beginDraw();
    canvas.image(f, 0, 0);
    canvas.rectMode(CENTER);
    canvas.noStroke();
    
    int freqDensity = 0;
    max = 0;
    
    soundSource.play(1, 0.0, 1.0, 0, movie.time());
    soundSource.amp(1);
    //frequency stuff
    fft.analyze();

    for (int i = 0; i < this.bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    }
    for (int i = 0; i < sum.length; i++) {
       if (sum[i] > max) {
         max = sum[i];
         this.maxFreqIndex = i;
       }
       if (sum[i] > 0.005) {
         freqDensity++;
       }
     }
     
     println("max freq: " + sum[maxFreqIndex] + ", idx: " + maxFreqIndex);

    // amplitude stuff
    ampSum += (rms.analyze() - ampSum) * smoothingFactor;
    rms_scaled = ampSum * 13;
    
    println("RMS SCALED" + rms_scaled);
    
    canvas.pushMatrix();
    canvas.translate(width/2, height/2);
    canvas.scale(this.scale);
    for (int i = 0; i < particles.length; i++) {
      particles[i].display(rms_scaled, canvas, f, this.curFrame);
    }
    
    canvas.popMatrix();
    canvas.endDraw();
    
    soundSource.pause();
    this.curFrame++;
    
    return canvas;    
  }
  
  int getAvgBright() {
    return 0;
  }
  
  public void setDim(int d) {
    
  }
  
  public void setColor(color c) {
  }
  
  public boolean active() {
    return true;
  }
}

class ObjParticle {
  
  PVector currentPosition;
  float r = 0.3;
  
  ObjParticle(float x, float y, float z) {
    currentPosition = new PVector(x, y);
  }
  
  void display(float size, PGraphics c, PImage orig, int count) {
    int r = (int)random(2);
    int x = (int)map(currentPosition.x+r, 0, c.width, 0, orig.width);
    int y = (int)map(currentPosition.y+r, 0, c.height, 0, orig.height);    
    int loc = abs(x + y*orig.width);
    float div = map(count % 100, 0, 100, 50, 1);
    
    if (loc >= orig.pixels.length) {
      loc = orig.pixels.length -1;
    } 
    color col = orig.pixels[loc];
    
    c.pushMatrix();
    c.noStroke();
    c.fill(col);
    c.translate(currentPosition.x, currentPosition.y);
    c.rotate((2 * PI) / div);
    c.ellipse(currentPosition.x, currentPosition.y, size, size);
    c.popMatrix();
  }
}
