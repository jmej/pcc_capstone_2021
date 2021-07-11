public class OffsetNode implements ModNode {
  private Settings set;
  private int dim = 10;
  private int numBlends = 10;
  private int curFrame = 0;
  private int frameModCt = 2;
  private int offsetBlendMode = 0;
  private boolean audioMod = false;

  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.offsetBlendMode = (int)this.set.get("offsetBlendMode");
    this.audioMod = (boolean)this.set.get("audioMod");
  }
  
  public PImage mod(PImage f) {
    PGraphics canvas = createGraphics(f.width, f.height);
    canvas.beginDraw();
    canvas.noStroke(); 
    canvas.image(f, 0, 0, f.width, f.height);
    
    int offset = this.dim;
    int method;
    
    
    int add = this.audioMod ? (int)map(fftData[0], 0, .5, 1, 10) : 1;

    for (int i = 0; i < this.numBlends; i++) {
     /* int method;
      if (i % 4 == 0) {
        method = ADD;
      } else if (i % 3 == 0) {
        method = SUBTRACT;
      } else if (i % 2 == 0) {
        method = HARD_LIGHT;
      } else {
        method = SOFT_LIGHT;
      }
      */
      
      
      if (this.offsetBlendMode == 0) {
        method = i % 2 == 0 ? ADD : SUBTRACT;
      } else {
        method = i % 2 == 0 ? HARD_LIGHT : SOFT_LIGHT;
      }
      int ofs = i * add;
      canvas.blend(f, offset*-ofs, offset*-ofs, f.width, f.height, offset*ofs, offset*ofs, f.width, f.height, method);  
    }
    
    canvas.endDraw();
    this.curFrame++;
    
    return canvas;
  }
  
  public boolean active() {
    return true;
  }
  
  public void setColor(color c) {
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public void clicked() {}
}
