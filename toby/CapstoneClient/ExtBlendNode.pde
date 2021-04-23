
class ExtBlendNode implements ModNode {
  
  private PImage img = null;
  private int totalbright = 0;
  private int totalpix = 0;
  private int switchCt = 10;
  private int blend1 = DODGE;
  private int blend2 = DARKEST;
  private boolean active = true;
  int curFrame = 0;
  PImage prevFrame = null;
  
  public PImage mod(PImage frame) {
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();
    canvas.noStroke(); 
    if (prevFrame == null) {
      canvas.image(frame, 0, 0, frame.width, frame.height);
    } else {
      canvas.image(prevFrame, 0, 0, frame.width, frame.height);
      int method  = 0;
      if (this.curFrame % (this.switchCt*2)-1 < this.switchCt) {
        method = this.blend1;
      } else {
        method = this.blend2;
      }
      canvas.blend(frame, 0, 0, frame.width, frame.height, 0, 0, frame.width, frame.height, method);
    }
    canvas.endDraw();
    prevFrame = this.curFrame % this.switchCt*2 == 0 ? frame.copy() : canvas.copy(); 
   
    this.curFrame++;
   
    return canvas;
  }
  
  public void setImage(PImage img) {
    this.img = img;
  }
  public void setSwitchCount(int ct) {
    this.switchCt = ct;
  }
  
  public void init() {
  }
  
  public int getAvgBright() {
    return this.totalbright > 0 ?  int(this.totalbright / this.totalpix) : 0;
  }
  
  public void setDim(int d) {
  }
  
  public void setColor(color c) {
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void setBlends(int mode1, int mode2) {
    this.blend1 = mode1;
    this.blend2 = mode2;
  }
}
