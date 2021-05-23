public class XModNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private boolean audioMod = false;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);  
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
    
    int auMod = this.audioMod ? (int)map(fftData[0], 0, .5, 0, 10) : 0;
    
    for (int x = 0; x < frame.width; x += this.dim ) {
      for (int y = 0; y < frame.height; y += this.dim ) {
        x += this.curFrame;
        x = (x % frame.width);
      //  y+= this.curFrame;
      //  y = (y % frame.height);
        
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];

        if (this.curFrame < this.frameModCt/2) {
          canvas.fill(currentColor);
          canvas.circle(x, y, this.dim + auMod);
        } else {
          canvas.fill(currentColor);
          canvas.square(x, y, this.dim + auMod);
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
