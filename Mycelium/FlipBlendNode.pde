class FlipBlendNode implements ModNode {
  private Settings set;
  private int frameModCt = 30;
  private int DEFAULTBLEND = BLEND;
  private int blendMethod;
  private boolean active = true;
  private int curFrame = 0;
  
  public PImage mod(PImage frame) {
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();
    canvas.noStroke();  
    canvas.translate((int)frame.width, 0);
    canvas.scale(-1,1);
    canvas.image(frame, 0, 0);
    canvas.translate(0, 0);
    canvas.blend(frame, 0, 0, frame.width, frame.height, 0, 0, frame.width, frame.height, blendMethod);
    
    canvas.endDraw();
   
    this.curFrame++;
   
    return canvas;
  }
  
  public void clicked() {}
  
  public void setSwitchCount(int ct) {
    this.frameModCt = ct;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.blendMethod = (int)this.set.get("flipBlendMethod");
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
}
