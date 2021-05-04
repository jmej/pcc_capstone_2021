class AtoVNode implements ModNode {
  private int count = 0;
  private PShape shape;
  private boolean SEND = false;
  public int bands = 256;
  private float smoothingFactor = 0.2;
  private float[] sum = new float[bands];
  private float ampSum;
  private int scale = 5;
  
  private PVector[] objVertices;
  private PVector[] linePoints;
  private int numOfVertices = 0;
  private ObjParticle[] particles;
  
  private int maxFreqIndex;
  private float max;
  private PGraphics canvas;

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

    testaudio.loop();
    testaudio.amp(1);
    fft.input(testaudio);
    rms.input(testaudio);
    
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
    
    //frequency stuff
    
    fft.analyze();
    
    for (int i = 0; i < bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
    }
    for (int i = 0; i < sum.length; i++) {
       if (sum[i] > max) {
         max = sum[i];
         maxFreqIndex = i;
       }
       if (sum[i] > 0.005) {
         freqDensity++;
       }
     }
     
     //float lows = ((sum[0] + sum[1]) /2) * 13;

    // amplitude stuff
    ampSum += (rms.analyze() - ampSum) * smoothingFactor;
    float rms_scaled = ampSum * 13;
    
    canvas.pushMatrix();
    canvas.translate(width/2, height/2);
    canvas.scale(3.5);
    for (int i = 0; i < particles.length; i++) {
      particles[i].display(rms_scaled, canvas, f, this.count);
    }
    
    canvas.popMatrix();
    canvas.endDraw();
    
    this.count++;
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
    int x = (int)map(currentPosition.x, 0, c.width, 0, orig.width);
    int y = (int)map(currentPosition.y, 0, c.height, 0, orig.height);    
    int loc = abs(x + y*orig.width);
    float div = map(count % 100, 0, 100, 50, 1);
    
    if (loc >= orig.pixels.length) {
      loc = orig.pixels.length -1;
    } else if (loc <= 0) {
      loc = abs(loc);
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
