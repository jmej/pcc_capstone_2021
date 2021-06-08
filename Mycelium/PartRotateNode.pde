public class PartRotateNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private int maxSections = 12;
  private int maxW = 200;
  private int maxH = 200;
  private float rotation = 0.0;
  private boolean dir = true;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);  
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.image(frame, 0, 0);
    
    int sections = this.curFrame % this.frameModCt;
    
    if (dir) {
      sections = (int)map(sections, 0, this.frameModCt, 0, this.maxSections);
    } else {
      sections = (int)map(sections, 0, this.frameModCt, this.maxSections, 0);
    }
    
    for (int i = 0; i < sections; i++) {
      int myx = (int)random(frame.width - maxW);
      int myy = (int)random(frame.height - maxH);
      int wid = (int)random(maxW);
      int hei = (int)random(maxH);
      
      canvas.pushMatrix();
      canvas.translate(random(frame.width), random(frame.height));
      rotation = random(2*PI);
      canvas.rotate(rotation);
      
      for (int j = 0; j < wid; j+= this.dim) {
        for (int k = 0; k < hei; k+= this.dim) {
          int loc = myx+j + (myy+k)*frame.width;
          canvas.fill(frame.pixels[loc]);
          canvas.square(j, k, this.dim);
        }
      }
      
      canvas.popMatrix();  
    }
    
    canvas.endDraw();

    this.curFrame++;
    if (curFrame % this.frameModCt == 0) dir = !dir;
    
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.maxSections = (int)this.set.get("partRotMaxSections");
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
