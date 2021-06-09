public class ExplodeColorNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int hiDim = 10;
  private int curFrame = 0;
  private color trackColor = 0;
  private boolean active = true;
  private int colorThresh = 30;
  private int frameModCt = 60;
  private int dir = 1;
  private boolean audioMod = false;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
  
    int thisDim;
    int auModAmt = this.audioMod ? (int)map(fftData[0], 0, .5, 0, 10) : 0;
    if (dir == 1) {
      thisDim = (int)map(this.curFrame % this.frameModCt, 0, this.frameModCt, this.dim, this.hiDim);
    } else {
      thisDim = (int)map(this.curFrame % this.frameModCt, 0, this.frameModCt,this.hiDim, this.dim);
    }
    thisDim += auModAmt;
    
    if (this.curFrame > 0 && this.curFrame % this.frameModCt == 0) {
      dir = dir == 1 ? 0 : 1;
    }
    
    PGraphics canvas = createGraphics(frame.width, frame.height);  
    float noiseScale = (int)map(this.curFrame % this.frameModCt, 0, this.frameModCt, .01, .1);
    canvas.beginDraw();           
    canvas.noStroke();
    canvas.colorMode(HSB, 100);
    
    for (int x = 0; x < frame.width; x += this.dim ) {
      for (int y = 0; y < frame.height; y += this.dim ) {
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
        
         if (this.trackColor != 0) { 
          float d = dist(
            hue(currentColor), 
            saturation(currentColor), 
            brightness(currentColor), 
            hue(this.trackColor), 
            saturation(this.trackColor), 
            brightness(this.trackColor)
          );
          
          if (d < this.colorThresh) {
            float noiseVal1 = noise((hue(currentColor)+x)*noiseScale, (hue(currentColor)+y)*noiseScale);
            color c = color(
              hue(currentColor)* noiseVal1,
              saturation(currentColor),
              brightness(currentColor)
            );
            canvas.fill(c);
            canvas.circle(x, y, thisDim);
          } else {
            canvas.fill(currentColor);
            canvas.square(x, y, this.dim);
          }
        }
      } 
    }
    
    canvas.endDraw();

    if (this.curFrame % this.frameModCt == 0 && pixels != null && pixels.length > 0) {
      int x = (int)random(width);
      int y = (int)random(height);
      this.trackColor  = pixels[x + y*frame.width];
    }

    this.curFrame++;
 
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
    this.audioMod = (boolean)this.set.get("audioMod");
  }
  
  public void setColor(color c) {
    this.trackColor = c;
  }
  
  public void setDim(int d) {
    this.dim = d;
    this.hiDim = (int)d*d*d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void clicked() {
    int loc = mouseX + mouseY*width;
    this.trackColor = pixels[loc];
  }
}
