public class PixSizeNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int hiDim = 12;
  private int curFrame = 0;
  private color trackColor = 0;
  private boolean active = true;
  private int shift = 0;
  private int frameModCt = 90;
  private int dir = 1;    // 1 = up, 0 = down
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
   
    PGraphics canvas = createGraphics(frame.width, frame.height);
    int thisDim;
    if (dir == 1) {
      thisDim = (int)map(this.curFrame % this.frameModCt, 0, this.frameModCt, this.dim, this.hiDim);
    } else {
      thisDim = (int)map(this.curFrame % this.frameModCt, 0, this.frameModCt, this.hiDim,this.dim);
    }
    
    if (this.curFrame > 0 && this.curFrame % this.frameModCt == 0) {
      dir = dir == 1 ? 0 : 1;
    }
    
    canvas.beginDraw();           
    canvas.noStroke();

    for (int x = 0; x < frame.width; x += thisDim ) {
      for (int y = 0; y < frame.height; y += thisDim ) {
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
        canvas.fill(currentColor);
        canvas.square(x, y, thisDim);
      } 
    }
    
    canvas.endDraw();

    this.curFrame++;
 
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int) this.set.get("frameModCount");
  }
  
  public void setColor(color c) {
    this.trackColor = c;
  }
  
  public void setDim(int d) {
    this.dim = d;
    this.hiDim = (int)d*d*(d/2);
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void clicked() {
    int loc = mouseX + mouseY*width;
    this.trackColor = pixels[loc];
  }
}
