public class AvgPixNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private color trackColor = 0;
  private boolean active = true;
  private PImage prev = null;
  private int frameModCt = 60;

  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    if (prev == null) {
      prev = frame.copy();
      return frame;
    }
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
   
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
        color prevColor = prev.pixels[loc];
        color avg = color(
          (int)(hue(currentColor) + hue(prevColor)) / 2,
          saturation(currentColor),
          brightness(currentColor)
       //   (int)(saturation(currentColor) + saturation(prevColor)) / 2,
        //  (int)(brightness(currentColor) + brightness(prevColor)) / 2
        );
        
        canvas.fill(avg);
        canvas.square(x, y, this.dim);
      } 
    }
    
    canvas.endDraw();
    
    if (curFrame % this.frameModCt == 0) {
      prev = frame.copy();
    } else {
      prev = canvas;
    }
    this.curFrame++;
    
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
  }
  
  public void setColor(color c) {
    this.trackColor = c;
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void clicked() {
    int loc = mouseX + mouseY*width;
    this.trackColor = pixels[loc];
  }
}
