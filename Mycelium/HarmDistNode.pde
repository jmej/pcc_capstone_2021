public class HarmDistNode implements ModNode {
  private Settings set;
  private int dim = 10;
  private float magnitude = 10;
  private float rampSpeed = 20;
  private float frequency = 10;
  private int frames;
  private int curFrame = 0;
  private int frameModCt = 2;
  private boolean hdHueMod = false;
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.hdHueMod = (boolean)this.set.get("harmDistHueMod");
  }
  
  public PImage mod(PImage f) {
    PGraphics canvas = createGraphics(f.width, f.height);
    canvas.beginDraw();
    canvas.noStroke(); 
    canvas.image(f, 0, 0, f.width, f.height);
    
    frames+= rampSpeed; 
    frames = frames % 360;    

    if (this.curFrame % 2 == 0) {
      frequency = (this.curFrame % 100) + 1;
      magnitude = map(fftData[0], 0.0, 0.5, 2, 50);
    }

    for (int x = 0; x < f.width; x += this.dim){
      for(int y = 0; y < f.height; y += this.dim){
        color pix = f.pixels[x+y*width];
        float phase = map(x, 0, width, 0, frequency);
        float wave = sin(frames-phase);
        float h = hue(pix);
        
        if(hdHueMod) {
          h *= wave; 
        }
 
        canvas.fill(color(h, saturation(pix), brightness(pix)));
        
        wave = wave * magnitude; 
        canvas.rect(x, y+wave, this.dim, this.dim);
      }
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
