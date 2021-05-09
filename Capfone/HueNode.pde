public class HueNode implements ModNode {
  private Settings set;
  private int dim = 3;
  private int curFrame = 0;
  private color trackColor = 0;
  private int minHue = 0;
  private int maxHue = 100;
  private boolean active = true;
  
  public PImage mod(PImage frame) {
    int cm = g.colorMode;
    
    colorMode(HSB, 100);
    if (frame.pixels.length == 0) frame.loadPixels();
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();           
    canvas.noStroke();

     if (this.curFrame % 20 == 0) {
       int save = minHue;
       minHue = maxHue;
       maxHue = save;  
    } else if (curFrame % 30 == 0) {
       minHue = (int)random(50);
       maxHue = (int)random(50)+50;
    }

    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int hue = 0;
        if (curFrame % 20 < 10) {
          hue = (int)map(x, 0, frame.width, minHue, maxHue);
        } else {
          hue = (int)map(y, 0, frame.height, minHue, maxHue);
        }
        
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
          
          if (d < 20) {
            canvas.fill(trackColor);
            canvas.square(x, y, dim);
            continue;
          }
        }
        
        canvas.fill(hue, saturation(currentColor), brightness(currentColor));
        canvas.square(x, y, dim);
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
  
  public boolean active() {
    return this.active;
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
}