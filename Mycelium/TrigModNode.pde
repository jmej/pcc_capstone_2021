public class TrigModNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private boolean trigModDim = false;
  private boolean audioMod = false;
  private int frameModCt = 60;

  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
    
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        color currentColor = frame.pixels[x + y*frame.width];
        float h = hue(currentColor);
        float sat = saturation(currentColor);
        float bri = brightness(currentColor);
        float amt = abs(sin(h));
        float dimamt;
        
        if (this.audioMod) {
          int idx = (int)map(x, 0, frame.width, 0, 2);
          dimamt = constrain(map(fftData[idx], 0.0, 0.3, 1.0, 5.0), 1.0, 5.0);
        } else {
          dimamt = this.trigModDim ? constrain(map(amt, 0.0, 1.0, 1.0, 5.0), 1.0, 5.0) : 1;
        }
        
        canvas.fill(color(
          h*amt,
          sat*abs(cos(sat)), 
          bri*abs(tan(bri))
          )
        );
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
  
  public void clicked() {}
}
