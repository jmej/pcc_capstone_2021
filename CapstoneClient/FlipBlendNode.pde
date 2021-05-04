
class FlipBlendNode implements ModNode {
  private Settings set;
  private int switchCt = 10;
  private int blend1 = LIGHTEST;
  private int blend2 = DARKEST;
  private boolean active = true;
  int curFrame = 0;
  
  public PImage mod(PImage frame) {
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke(); 
    
    int method  = 0;
    if (this.curFrame % (this.switchCt*2)-1 < this.switchCt) {
      canvas.translate((int)frame.width, 0);
      method = this.blend1;
      canvas.scale(-1,1); // You had it right!
    } else {
      canvas.translate(frame.width, frame.height);
      method = this.blend2;
      canvas.scale(-1,-1); // You had it right!
    }
    
    canvas.image(frame, 0, 0);
    canvas.translate(0, 0);
    canvas.blend(frame, 0, 0, frame.width, frame.height, 0, 0, frame.width, frame.height, method);
    canvas.endDraw();
   
    this.curFrame++;
   
    return canvas;
  }
  
  public void setSwitchCount(int ct) {
    this.switchCt = ct;
  }
  
  public void init(Settings set) {
    this.set = set;
  }
  
  public void setColor(color c) {
  //  this.trackColor = c;
  }
  
  public void setDim(int d) {
  //  this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void setBlends(int mode1, int mode2) {
    this.blend1 = mode1;
    this.blend2 = mode2;
  }
}
