public class HueNode implements ModNode {
  private int dim = 2;
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

     if (this.curFrame % 10 == 0) {
       int save = minHue;
       minHue = maxHue;
       maxHue = save;  
    }

    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int hue = (int)map(x, 0, frame.width, minHue, maxHue);
        int loc = x + y*frame.width;
        color currentColor = frame.pixels[loc];
  
        if (trackColor != 0) { 
          float d = dist(
            hue(currentColor), 
            saturation(currentColor), 
            brightness(currentColor), 
            hue(trackColor), 
            saturation(trackColor), 
            brightness(trackColor)
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
  
  public void init() {
  }
  
  public void setColor(color c) {
    this.trackColor = c;
  }
  
  public int getAvgBright() {
    int ret = 0;
    return (int)ret;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
}
