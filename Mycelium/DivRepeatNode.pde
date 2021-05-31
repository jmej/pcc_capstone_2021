public class DivRepeatNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private boolean audioMod = false;
  private int defaultXDivs = 8;
  private int defaultYDivs = 4;
  private boolean up = true;
  private boolean yup = true;
  private boolean divRepeatYMod = false;
  private int updateRate = 4;
  private int curXDivs = 1;
  private int curYDivs = 1;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);  
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
    
    int auMod = this.audioMod ? (int)map(fftData[0], 0, .5, 1, 10) : 0;
    int xdivs = curXDivs;
    int ydivs = curYDivs;
    
    if (auMod > 0) {
      xdivs = auMod;
    } 
    if (xdivs <= 0) xdivs = 1;
    if (ydivs <= 0) ydivs = 1;
    
    for (int x = 0; x < frame.width; x += this.dim ) {
      for (int y = 0; y < frame.height; y += this.dim ) {      
        int myx = (x % (int)(frame.width/xdivs)) + (this.curFrame % frame.width);
        myx = (myx % frame.width);
       
        int myy = y;
        if (divRepeatYMod) {
          myy = (y % (int)(frame.height / ydivs)) + (this.curFrame % frame.height);
          myy = (myy % frame.height);
        }
        
        int loc = myx + myy*frame.width; 
        canvas.fill(frame.pixels[loc]);
        canvas.square(x, y, this.dim + auMod); 
      } 
    }
    
    if (this.curFrame % this.updateRate == 0) {
      if (up) {
        curXDivs++;
        if (curXDivs % this.defaultXDivs == 0) {
          up = false;
        }
      } else {
        curXDivs--;
        if (curXDivs == 0 || curXDivs % this.defaultXDivs == 0) {
          up = true;
        }
      }
      
      if (divRepeatYMod) {
        if (yup) {
          curYDivs++;
          if (curYDivs % this.defaultYDivs == 0) {
            yup = false;
          }
        } else {
          curYDivs--;
          if (curYDivs == 0 || curYDivs % this.defaultYDivs == 0) {
            yup = true;
          }
        }
      }
    }
    
    canvas.endDraw();
    this.curFrame++;
 
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.audioMod = (boolean)this.set.get("audioMod");
    this.defaultXDivs = (int)this.set.get("divRepeatXCount");
    this.defaultYDivs = (int)this.set.get("divRepeatYCount");
    this.updateRate = (int)this.set.get("divRepeatUpdateRate");
    this.divRepeatYMod = (boolean)this.set.get("divRepeatYMod");
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
