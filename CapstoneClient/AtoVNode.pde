class AtoVNode implements ModNode {
  
    private int count = 0;
      private int blend1 = ADD;
  private int blend2 = SCREEN;
  
  
  
PShape shape;
boolean SEND = false;
public int bands = 256;
float smoothingFactor = 0.2;
float[] sum = new float[bands];
float ampSum;
int scale = 5;

PVector[] objVertices;
PVector[] linePoints;
int numOfVertices = 0;
ObjParticle[] particles;

int maxFreqIndex;
float max;
SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;
PGraphics canvas;


  void init() {
    
    //size(1920, 1080, P2D);
  shape = loadShape("seastar.obj");
  
  
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
  //canvas.background(0);
  canvas.rectMode(CENTER);
  
 // canvas.lights();
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
   
   float lows = ((sum[0] + sum[1]) /2) * 13;
   
   
  
  // amplitude stuff
  ampSum += (rms.analyze() - ampSum) * smoothingFactor;
  float rms_scaled = ampSum * 13;
  

  
  canvas.push();
  canvas.translate(width/2, height/2);
  canvas.scale(3.5);
  for (int i = 0; i < particles.length; i++) {
   particles[i].display(rms_scaled, canvas, f, count, lows);
  }
  
  canvas.pop();
  canvas.endDraw();
    
    
    //int method = count % 2 == 0 ? blend1 : blend2;
  //  canvas.blend(f, 0, 0, f.width, f.height, 0, 0, canvas.width, canvas.height, method);
    //count++;
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
  
  void display(float size, PGraphics c, PImage orig, int count, float lows) {
    int x = (int)count % orig.width; //int(random(orig.width));
    int y = int(random(orig.height));
    int loc = x + y*orig.width;
    color col = orig.pixels[loc];
    
    c.push();
    c.noStroke();
    c.fill(col);
    c.translate(x, currentPosition.y);
    c.ellipse(currentPosition.x, currentPosition.y, lows, lows);
    if (millis() %1000 == 0) {
       println("LOWS: " + lows);
    }
    c.pop();
  }
}
