public class ColorMixNode implements ModNode {
  private Settings set;
  private int dim = 2;
  private int curFrame = 0;
  private float totalBright = 0;
  private int totalPix = 0;
  private color trackColor = 0;
  private boolean active = true;
  
  public PImage mod(PImage frame) {
    int cm = g.colorMode;
    
    colorMode(HSB, 100);
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();         
    canvas.noStroke();
    
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
        float bright = 0;
        
        if (this.trackColor != 0) { 
          float d = dist(
            hue(currentColor), 
            saturation(currentColor), 
            brightness(currentColor), 
            hue(trackColor), 
            saturation(trackColor), 
            brightness(trackColor)
          );
          
          if (d < 20) {
            canvas.fill(this.trackColor);
            canvas.square(x, y, dim);
            continue;
          }
        }
        
        if (brightness(frame.pixels[loc]) > 50) {   
          canvas.fill(saturation(currentColor), hue(currentColor), brightness(currentColor)-25);
          canvas.square(x, y, dim);
          bright = brightness(currentColor)-25;
        } else {
          colorMode(RGB, 255);
          color c = color(blue(currentColor), red(currentColor), green(currentColor));
          canvas.fill(c);
          canvas.square(x, y, dim);
          colorMode(HSB, 100);
          bright = brightness(c);
        }
        
        this.totalPix++;
        this.totalBright += bright;
      } 
    }
    canvas.endDraw();

    this.curFrame++;
    
    if (cm != HSB) {
      colorMode(cm, 255);
    }
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
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
  
  public int getAvgBright() {
    return this.totalBright > 0 && this.totalPix > 0 ? int(this.totalBright / this.totalPix) : 0;
  }
}
