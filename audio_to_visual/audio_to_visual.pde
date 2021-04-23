// audio features: frequency, amplitude, 
// visual features: color, speed, shape, size, opacity, "weirdness"
// mapping: amplitude to size, frequency to speed and color, weirdness to frequency density
// frequency density: the number of bands in fft that are above a certain threshold;

//have layers: background created by flocking algorithm, foreground bigger, more dominant shapes

//possible conditionals:
//if peak frequency is above a certain level
//if frequency density is above or below a certain level
//if amplitude is above or below a certain level



import processing.sound.*;

//PShape orchid;
PShape shape;

SoundFile testaudio;
FFT fft;
Amplitude rms;

int bands = 256;
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

void setup() {
  
  size(800, 800, P3D);
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
  
  //simplify later, don't need to store vertices before using them to initialize particles
  //but it might be a good idea to have them stored? depending on where it goes
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
  
  
  testaudio = new SoundFile(this, "testaudio.wav");
  testaudio.loop();
  testaudio.amp(1);
  
  fft = new FFT(this, bands);
  fft.input(testaudio);
  
  rms = new Amplitude(this);
  rms.input(testaudio);
  
  rectMode(CENTER);
  

}

void draw() {
  
  background(0);
  
  lights();
  noStroke();
  
  int freqDensity = 0;
  max = 0;
  int inLineParticles = 0;
  float lows = 0;
  float mids = 0;
  float highs = 0;
  
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
 for (int i = 0; i < 85; i++) {
   lows += fft.spectrum[i];
 }
 for (int i = 85; i < 170; i++) {
   mids += fft.spectrum[i];
 }
 for (int i = 170; i < 256; i++) {
   highs += fft.spectrum[i];
 }
   
   
  
  // amplitude stuff
  ampSum += (rms.analyze() - ampSum) * smoothingFactor;
  float rms_scaled = ampSum * 13;
  
  
  
  
  push();
  translate(width/2, height/2);
  scale(3.5);
  for (int i = 0; i < particles.length; i++) {
   particles[i].display(rms_scaled);
  }
  
  pop();
}
