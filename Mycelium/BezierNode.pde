class BezierNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private boolean up = true;
  private int frameModCt = 90;
  private float rotation = 0;
  private int grid = 15;
  private int offset = 100;
  private int scale = 2;
  private int drawCount = 250;
  private float x1,x2,x3,x4;
  private float y1,y2,y3,y4;
  private boolean noiseMode = true;
  private int updateRate = 5; 
  
  PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
   
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke();
    canvas.image(frame, 0, 0);
    
    if (this.up) {
      this.grid = (this.curFrame % this.frameModCt + offset) * this.scale;
    } else {
      this.grid = ((this.frameModCt - (this.curFrame % this.frameModCt)) + this.offset) * this.scale; 
    }
    
    rotation += 0.0004;
    
    canvas.translate(width/2, height/2);
    
    int sw = (int)map(this.grid, this.offset*this.scale, (this.frameModCt + this.offset)*this.scale, 2, 10);
    
    if (!this.noiseMode && this.curFrame % this.updateRate == 0) {
      this.generatePoints();
    }
    
    for (int i =1; i < this.drawCount; i ++) {
      color c = frame.pixels[(int)random(frame.width)];
      
      canvas.rotate(rotation);
      canvas.stroke(c);
      canvas.strokeWeight(sw);
      canvas.pushMatrix();
      canvas.translate(0, 0);
      
      for(int num = 0; num<8; num++){
        if (this.noiseMode) {
          this.generatePoints();
        }
        
        canvas.noFill();
        canvas.beginShape();
        canvas.vertex(x1, y1);
        canvas.bezierVertex(x3, y3, x4, y4,x2, y2);  
        canvas.endShape(CLOSE);
      }
      
      canvas.popMatrix();
      canvas.fill(255);
    }
    
    canvas.endDraw();
    this.curFrame++;
    
    if (this.curFrame % frameModCt == 0) {
      this.up = this.up ? false : true;
    }
    
    return canvas;
  }
  
  private void generatePoints() {
       int mod = (int)map(fftData[0], 0.0, .5, 0, 10);
       float d = this.grid + mod;
       x1 = -random(d);
       y1 = -random(d);
       x2 = -x1; //random(d);
       y2 = -y1;//-random(d);
       x3 = random(d);
       y3 = random(d);
       x4 = -x3; // -random(d);
       y4 = -y3;//random(d);
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
  
  public void clicked() {}
}
