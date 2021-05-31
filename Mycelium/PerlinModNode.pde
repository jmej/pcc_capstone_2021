public class PerlinNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private int auChangeCt = 4;
  private boolean audioMod = false;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();

    PGraphics canvas = createGraphics(frame.width, frame.height);  
    float noiseScale = (int)map(this.curFrame % this.frameModCt, 0, this.frameModCt, .01, .1);
    
    if (this.audioMod && this.curFrame % auChangeCt == 0) {
      noiseScale = (float)map(fftData[0], 0, 1., .001, .2);
    }
    
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
    
    for (int x = 0; x < frame.width; x += this.dim ) {
      for (int y = 0; y < frame.height; y += this.dim ) {
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];    
        float noiseVal1 = noise((brightness(currentColor)+x)*noiseScale, (brightness(currentColor)+y)*noiseScale);
        float noiseVal2 = noise((saturation(currentColor)+x)*noiseScale, (saturation(currentColor)+y)*noiseScale);
        float noiseVal3 = noise((brightness(currentColor)+x)*noiseScale, (brightness(currentColor)+y)*noiseScale);
            
        color c = color(
          hue(currentColor) * noiseVal1,
          saturation(currentColor) * noiseVal2,
          brightness(currentColor) * noiseVal3
        );
      
        canvas.fill(c);
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
