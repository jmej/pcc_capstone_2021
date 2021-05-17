
class BlendNode implements ModNode {
  private Settings set;
  private int frameModCt = 15;
  private int blendCount = 0;
  private int[] blends;
  private int[] availBlends = {BLEND, EXCLUSION, DODGE, LIGHTEST, ADD, EXCLUSION};  
  private boolean active = true; 
  private int curFrame = 0;
  private PImage prevFrame = null;
  private int method;
  private int methIdx = 0;
  
  public PImage mod(PImage frame) {
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();
    canvas.noStroke(); 
    
    if (prevFrame == null) {
      canvas.image(frame, 0, 0, frame.width, frame.height);
    } else {
      canvas.image(prevFrame, 0, 0, frame.width, frame.height);
                      
      if (this.curFrame % (int)(this.frameModCt/2) == 0) {
         method = this.blends[methIdx];
         
         methIdx++;
         if (methIdx >= this.blends.length) {
           methIdx = 0;
         }
      }

      canvas.blend(frame, 0, 0, frame.width, frame.height, 0, 0, frame.width, frame.height, method);
    }  
    
    canvas.endDraw();
    
    if (this.curFrame % (int)(this.frameModCt/2) == 0) {
      println("COPYING FRESH FRAME - " + methIdx);
       prevFrame = frame.copy();
    } else {
      println("CONTINUING BLEND - " + methIdx);
      prevFrame =  canvas.copy();
    }
    
    this.curFrame++;
   
    return canvas;
  }
  
  public void setSwitchCount(int ct) {
    this.frameModCt = ct;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.blendCount = (int)this.set.get("blendCount");
    if (blendCount <= 0) blendCount = 1;
    
    this.blends = new int[this.blendCount];
    this.blends = subset(this.availBlends, 0, this.blendCount);
    
    this.frameModCt = (int)((int)this.set.get("frameModCount")) / 3;
  }
  
  public void setColor(color c) {
 //   this.trackColor = c;
  }
  
  public void setDim(int d) {
//    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  public void clicked() {}
}
