class MolnarNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 90;
  private float PHI = 1.618033988749894848204586834365638117720309179805762862135448;
  private float rotation = 0;
  private boolean pause = false;
  private color[] colArray = new color[7];
  private int grid = 15;
  
  PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
   
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke();
    canvas.image(frame, 0, 0);
    
    for (int i = 0; i < colArray.length; i++) {
      int x = (int)random(width);
      int y = (int)random(height);
      int loc = x + y*width;
      
      colArray[i] = frame.pixels[loc];
    }
    
    if (!pause){
      rotation += 0.0004;
      rotation = random(PI);
    }
    
    canvas.translate(width/2, height/2);
    for(int i =1; i < 500; i ++) {
     canvas.rotate(rotation);
     canvas.stroke(255);
     molnar(canvas, 50 * (i % 10), 50);  
     canvas.fill(255);
    }
    
    canvas.endDraw();
    this.curFrame++;
    
    return canvas;
  }
  
  void molnar(PGraphics canvas, float xLoc, float yLoc){
      int colArrayNum = (int)random(7);
      
      canvas.stroke(colArray[colArrayNum]);
      canvas.strokeWeight(2);
      canvas.pushMatrix();
      canvas.translate(xLoc, yLoc);
      
      int mod = (int)map(fftData[0], 0.0, .5, 0, 10);
      for(int num = 0; num<8; num++){
        float d = grid + mod;
        float x1 = -random(d);
        float y1 = -random(d);
        float x2 = random(d);
        float y2 = -random(d);
        float x3 = random(d);
        float y3 = random(d);
        float x4 = -random(d);
        float y4 = random(d);
     
        canvas.noFill();
        canvas.quad(x1, y1, x2, y2, x3, y3, x4, y4);  
     } 
     
     canvas.popMatrix();
  }

  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int) this.set.get("frameModCount");
  }
  
  public void setColor(color c) {
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void clicked() {
  }
}
