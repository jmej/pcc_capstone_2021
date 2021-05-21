
class MolnarNode implements ModNode {
  private Settings set;
  private int dim = 4;
  private int curFrame = 0;
  private color trackColor = 0;
  private boolean active = true;
  private int frameModCt = 90;
  
    
  //int colArrayNum = 0;
  private float PHI = 1.618033988749894848204586834365638117720309179805762862135448;
  private float rotation = 0;
  private boolean pause = false;
  
  
  
  private color[] colArray = new color[7];
    
   /* color(255, 255, 255), //white
    color(200, 5, 20), //red
    color(55, 188, 25), //green
    color(15, 35, 250), //blue
    color(125, 235, 250), //light blue
    color(240, 245, 15), //yellow
    color(160, 60, 235),  //purple
    */

  
  private int grid = 15;
  private int margin = 70;
  
  PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
   
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke();
    canvas.image(frame, 0, 0);
    
    for (int i = 0; i < colArray.length; i++) {
      int x = (int)random(width);
      int y = (int)random(height);
      int loc = x + y*width;
      
      colArray[i] = frame.pixels[loc];
    }
    
    //background(15, 20, 30);
    //frames++;
    if (!pause){
      rotation += 0.0004;
        rotation = rotation%PI;
        //rotation = rotation%PI*2;
      }
    canvas.translate(width/2, height/2);
    for(int i =1; i < 500; i ++) {
     //pushMatrix();
   //  float rotation = map(mouseX, 0, width, 0, PI);
     canvas.rotate(rotation);
     canvas.stroke(255);
     molnar(canvas, 50 * (i % 10), 50);
     
     canvas.fill(255);
     //text(rotation, 50 * (i % 10), 50);
     //popMatrix();
    }
    
    canvas.endDraw();
    this.curFrame++;
    
    return canvas;
  }
  
   void molnar(PGraphics canvas, float xLoc, float yLoc){
     
      //if(frames % 2 == 0){ 
      //  colArrayNum = (int)random(7);
      //}
      int colArrayNum = (int)random(7);
        canvas.stroke(colArray[colArrayNum]);
      canvas.strokeWeight(2);
      canvas.pushMatrix();
      canvas.translate(xLoc, yLoc);
      for(int num = 0; num<8; num++){
        
        float d =grid;
          
        float x1 = -random(d);
        float y1 = -random(d);
        float x2 = random(d);
        float y2 = -random(d);
        float x3 = random(d);
        float y3 = random(d);
        float x4 = -random(d);
        float y4 = random(d);
      
      
        //pushMatrix();
        
        
        canvas.noFill();
        canvas.quad(x1, y1, x2, y2, x3, y3, x4, y4);
        
        
     } 
      canvas.popMatrix();
  
  }


  public void init(Settings set) {
    this.set = set;
    this.frameModCt = (int) this.set.get("frameModCount");
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
