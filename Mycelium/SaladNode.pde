public class SaladNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private int div = 100;
  private float rotation = 0.0;
  private boolean up = true;

  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);

    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int myx = abs((int)equation(x, div) % frame.width);
        int myy = abs((int)equation(y, div) % frame.height);

        int loc = myx + myy*frame.width;
        canvas.pushMatrix();
        canvas.translate(frame.width/2, frame.height/2);

        rotation += 0.0001;

        if (rotation >= 2*PI) {
          rotation = 0.0;
        } 
             
        canvas.rotate(rotation);
        canvas.fill(frame.pixels[loc]);
        canvas.square(myx, myy, this.dim);
        canvas.popMatrix();
      } 
    }
    
    canvas.endDraw();
    this.curFrame++;
    
    return canvas;
  }
  
  private float equation(float h, int div) {
    if (div == 0) return h;
    float ret = (pow(h,3) -(2*pow(h,2))-(11*h)+12) / div;
    return ret;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
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
