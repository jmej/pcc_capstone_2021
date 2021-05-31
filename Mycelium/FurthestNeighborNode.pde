public class FurthestNeighborNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private int furthestDist = 8;

  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
   
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        color c = frame.pixels[x + y*frame.width];
        int n = (int)random(8);
        int myx = x;
        int myy = y;
        
        int furthest = 0;
        color furthestColor = c;
        
        for (int i = x - furthestDist; i <= x + furthestDist; i++) {
          for (int j = y - furthestDist; j <= y + furthestDist; j++) {
            if (i < 0 || j < 0 || i >= frame.width || j >= frame.height || (i == x && j == y)) continue;
            
            color thisColor = frame.pixels[i + j*frame.width];
            int mydist = (int)dist(
              hue(c),
              saturation(c),
              brightness(c),
              hue(thisColor),
              saturation(thisColor),
              brightness(thisColor)
            );
            
            if (mydist > furthest) {
              furthest = mydist;
              furthestColor = thisColor;
            }
          }
        }

        canvas.fill(furthestColor);
        canvas.square(x, y, this.dim);
      } 
    }
    
    canvas.endDraw();
    
    this.curFrame++;
    
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.furthestDist = (int)this.set.get("furthestDist");
  }
  
  public void setColor(color c) {
 //   this.trackColor = c;
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
