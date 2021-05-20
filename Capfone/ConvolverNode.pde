public class ConvolverNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private color trackColor = 0;
  private boolean active = true;
  private int frameModCt = 60;
  private int fileIdx = 0;
  private File[] files;
  
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
 
    File imageFile;
    PImage cImg = new PImage();
    PGraphics canvas = createGraphics(frame.width, frame.height);   
    
    canvas.beginDraw();           
    canvas.noStroke();
    File file = new File(sketchPath("data/images"));
    
    try {
      if (file.isDirectory()) {
         files = file.listFiles();
         if (files.length > 0 && fileIdx < files.length) {
           imageFile = files[fileIdx]; 
           if (imageFile.getName().equals(".DS_Store")) {
             println("Deleted .DS_store");
             imageFile.delete();
             fileIdx++;
             
             if (fileIdx >= files.length) fileIdx = 0;
             imageFile = files[fileIdx];
           }
           
           cImg = loadImage(imageFile.getAbsolutePath());
           cImg.copy(cImg, 0, 0, cImg.width, cImg.height, 0, 0, frame.width, frame.height);
           if (cImg.pixels == null || cImg.pixels.length == 0) {
             cImg.loadPixels();
           }
           
           fileIdx++; 
           if (fileIdx >= files.length) fileIdx = 0;
         } else {
           println("No Image files found!");
           fileIdx = 0;
           return frame;
         }
      } 
    } catch (NullPointerException e) {
      println("Null pointer while loading " + e.getMessage());
      return frame;
    }

    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        try {
          int loc = x + y*frame.width;
          color currentColor = frame.pixels[loc];
          color convColor = cImg.pixels[loc];
          color c;
          
          if (this.curFrame % frameModCt >= (frameModCt/2)) {
            c = color(hue(convColor), saturation(currentColor), brightness(currentColor));
          } else {
            c = color(hue(currentColor), saturation(convColor), brightness(currentColor));
          }
          canvas.fill(c);
          canvas.square(x, y, this.dim);
        } catch (ArrayIndexOutOfBoundsException e) {
          println("Array out of bounds: " + x + " - " + y  + " -- " + e.getMessage());
        } catch (NullPointerException e) {
          println("Null pointer : " + e.getMessage());
        }
      } 
    }
    
    canvas.endDraw();

    this.curFrame++;
 
    return canvas;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int)this.set.get("frameModCount");
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
