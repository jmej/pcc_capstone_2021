public class CircleizeNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private color trackColor = 0;
  private boolean active = true;
  
  public PImage mod(PImage frame) {
    int cm = g.colorMode;
    
    colorMode(HSB, 100);
    if (frame.pixels.length == 0) frame.loadPixels();
    
    int pdim = dim + 2;
    PGraphics canvas = createGraphics(frame.width, frame.height);
    
    canvas.beginDraw();           
    canvas.noStroke();
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int frameAmt = this.curFrame % 20;
        int amt = (int)map(frameAmt, 0, 180, 1, 100);
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
          
          if (d < 40) {
            canvas.fill(this.trackColor);
            canvas.square(x, y, dim);
            continue;
          }
        }
        
        if (brightness(frame.pixels[loc]) > 50) {   
          canvas.fill(hue(int(random(currentColor))), saturation(currentColor), brightness(currentColor));
     //     canvas.rotate((2 * PI * brightness(int(frame.pixels[loc]) / amt)));
          canvas.ellipse(x, y, pdim ,(pdim)+int(amt/2) ); 
        } else {
          colorMode(RGB, 255);
          canvas.fill(currentColor);
          canvas.ellipse(x, y, pdim + frameAmt, pdim + frameAmt);
          colorMode(HSB, 100);
        }
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
  
  public void clicked() {
    int loc = mouseX + mouseY*width;
    this.trackColor = pixels[loc];
  }
}
