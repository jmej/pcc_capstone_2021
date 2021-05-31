public class TrigModNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private boolean trigModDim = false;
  private int frameModCt = 60;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
    
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
        float amt = (sin(hue(currentColor)) + 1 )/ 2;
        float satamt = (cos(saturation(currentColor)) + 1 )/ 2;
        float briamt = (tan(brightness(currentColor)) + 1 )/ 2;
        int dimamt = this.trigModDim ? (int)map(amt, 0.0, 1.0, 0, 10) : 1;
        
        canvas.fill(color(hue(currentColor)*amt, saturation(currentColor)*satamt, brightness(currentColor)*briamt));
        canvas.square(x, y, this.dim*dimamt);
      } 
    }
    
    canvas.endDraw();

    this.curFrame++;
    
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.trigModDim = (boolean)this.set.get("trigModDim");
  }
  
  public void setColor(color c) {
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void clicked() {}
}
