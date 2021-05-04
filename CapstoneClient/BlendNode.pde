
class BlendNode implements ModNode {
  private Settings set;
  private int totalbright = 0;
  private int totalpix = 0;
  private int switchCt = 10;
  private int blendCount = 0;
  private final int MAXBLENDS = 4;
  private int[] blends;
  private int[] availBlends = {ADD, DARKEST, DODGE, SCREEN};  
  private boolean active = true; 
  private int curFrame = 0;
  private PImage prevFrame = null;
  private int method;
  
  public PImage mod(PImage frame) {
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();
    canvas.noStroke(); 
    if (prevFrame == null) {
      canvas.image(frame, 0, 0, frame.width, frame.height);
    } else {
      canvas.image(prevFrame, 0, 0, frame.width, frame.height);
      
       if (millis() % 2000 < 200) {
         int prevMeth = method;
         while(prevMeth == method) {
           method = (int)random(this.blendCount);
         }
         println("NEW BLEND METHOD: " + method); 
         method = this.blends[method];

      }

      canvas.blend(frame, 0, 0, frame.width, frame.height, 0, 0, frame.width, frame.height, method);
    }
    
    canvas.endDraw();
    prevFrame = this.curFrame % this.switchCt == 0 ? frame.copy() : canvas.copy(); 
   
    this.curFrame++;
   
    return canvas;
  }
  
  public void setSwitchCount(int ct) {
    this.switchCt = ct;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.blendCount = (int)this.set.get("blendCount");
    if (blendCount <= 0) blendCount = 1;
    
    this.blends = new int[this.blendCount];
    this.blends = subset(this.availBlends, 0, this.blendCount);
  }
  
  public void setColor(color c) {
   // this.trackColor = c;
  }
  
  public int getAvgBright() {
    return this.totalbright > 0 ?  int(this.totalbright / this.totalpix) : 0;
  }
  
  public void setDim(int d) {
//    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void setBlends(int mode1, int mode2) {
 //   this.blend1 = mode1;
   // this.blend2 = mode2;
  }
}
