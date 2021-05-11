
public class ReadMarkovNode  implements ModNode {
  private Settings set;  
  private int dim = 5;
  private int totalbright = 0;
  private int totalpix = 0;
  private int curFrame = 0;
  private color trackColor;
  private boolean active = true;
  private String route = "/capfonePix";
  private IntList colors;
  private int id = 5;
    
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();

    JSONObject main = loadJSONObject("out" + id + ".json");    
    PGraphics canvas = createGraphics(frame.width, frame.height);

    canvas.beginDraw();
    canvas.noStroke();
    colorMode(HSB, 100);
    int idx = 0;

    for (int x = 0; x < frame.width; x+=this.dim) {
      for (int y = 0; y< frame.height; y+= this.dim) {
        try {
          int loc = x + y*frame.width;
          
  
          String index = "" + idx;
          
          JSONArray c = main.getJSONArray(index);
  
          int hue = c.getInt(0);
          int sat = c.getInt(1);
          int bri = c.getInt(2);
          
          color col = color(hue, sat, bri); 
          canvas.fill(col);
          canvas.square(x, y, this.dim);
          idx++;
        
        } catch (NullPointerException e) {
          println("NULL POINTER: id: "+ id + ", idx: " + idx + " --"  + e.getMessage());

        }
      }
    }

    id++;
    if (id >6) id = 5;
    
    canvas.endDraw();
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
  }
  
  public void clicked() {}
}
