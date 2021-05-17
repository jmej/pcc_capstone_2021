public class GrowPixNode  implements ModNode {
  private Settings set;  
  private int dim = 5;
  private int frameModCt = 60;
  private int curFrame = 0;
  private color trackColor;
  private boolean active = true;
    
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    int cm = g.colorMode;
    colorMode(HSB, 100);
    int noiseSeed = millis() % 100;
    float noiseScale = map (noiseSeed, 0, 100, 0.01, .11); 
    PGraphics canvas = createGraphics(frame.width, frame.height);
   
    canvas.beginDraw();
    canvas.noStroke();
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int frameAmt = this.curFrame % this.frameModCt;
        int amt = (int)map(frameAmt, 0, this.frameModCt, 1, 100);
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
        
        if (this.trackColor != 0) { 
          float d = dist(
            hue(currentColor), 
            saturation(currentColor), 
            brightness(currentColor), 
            hue(this.trackColor), 
            saturation(trackColor), 
            brightness(trackColor)
          );
          
          if (d < 30) {
            canvas.fill(this.trackColor);
            canvas.square(x, y, dim);
            continue;
          }
        }
        
        canvas.pushMatrix();
        canvas.translate(int(x+(dim/2)), int(y+(dim/2)));
        
        float noiseVal1 = noise((hue(frame.pixels[loc])+x)*noiseScale, (hue(frame.pixels[loc])+y)*noiseScale);
        float noiseVal2 = noise((saturation(frame.pixels[loc])+x)*noiseScale, (saturation(frame.pixels[loc])+y)*noiseScale);
        float noiseVal3 = noise((brightness(frame.pixels[loc])+x)*noiseScale, (brightness(frame.pixels[loc])+y)*noiseScale);
    
        canvas.noStroke();
        if (brightness(frame.pixels[loc]) > 60) {   
          canvas.fill(hue(frame.pixels[loc])*noiseVal1, saturation(frame.pixels[loc])*noiseVal2, brightness(frame.pixels[loc])*2*noiseVal3);
          canvas.rotate((2 * PI * brightness(int(frame.pixels[loc]) / amt)));
          canvas.rect(0, 0, dim ,(dim)+int(amt/2) ); 
        } else {
          colorMode(RGB, 255);
          canvas.fill(currentColor);
          canvas.rect(0, 0, dim, dim);
          colorMode(HSB, 100);
        }
        canvas.popMatrix();  
      } 
    }
    
    this.curFrame++;
    canvas.endDraw();
     
    if (cm != HSB) {
      colorMode(cm, 255);
    }
    return canvas;
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
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int) this.set.get("frameModCount");
  }
  
  public void clicked() {
    int loc = mouseX + mouseY*width;
    this.trackColor = pixels[loc];
  }

}
