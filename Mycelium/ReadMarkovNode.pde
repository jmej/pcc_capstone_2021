import java.util.Comparator;

public class ReadMarkovNode  implements ModNode {
  private Settings set;  
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int MAX_ATTEMPTS = 20;
  private String route = "/markovpath";
  private String toMarkovPath;
  private int outport = 12000;
  private NetAddress remoteLocation;
    
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    JSONObject main = null;
    File jsonFile = null;
    OscMessage msg = null;

    JSONObject out = new JSONObject();
    int i = 0;
    for (int x = 0; x < width; x += this.dim ) {
      for (int y = 0; y < height; y += this.dim ) {
        int loc = x + y*width;
        color c = frame.pixels[loc];  
        JSONArray elem = new JSONArray();
        elem.setInt(0, (int)hue(c));
        elem.setInt(1, (int)saturation(c));
        elem.setInt(2, (int)brightness(c));
        out.setJSONArray("" + i, elem);
        i++;  
      } 
    }
    
    String outPath = sketchPath(this.toMarkovPath + "/frame-" + this.curFrame + "-" + i + ".json");
    saveJSONObject(out, outPath);
    
    msg = new OscMessage(this.route);
    msg.add(outPath);
    oscP5.send(msg, this.remoteLocation);  
    println("SENT JSON to markov: " + outPath);
    
    try {
      boolean found = false;
      String markovPath = "";
      int attempts = 0;
      while(!found) {
        markovPath = oscCli.getMarkovPath();
        if (!markovPath.equals("")){
          found = true;
        }
        println("No Markov file...waiting");
        delay(2000);
        attempts++;
        
        if (attempts > MAX_ATTEMPTS) {
          println("No file returned. Breaking...");
          break;
        }
        
      }
      
      if (found) {
        jsonFile = new File(markovPath);
        main = loadJSONObject(jsonFile);
        println("JSON file: " + jsonFile.getAbsolutePath());
      }
      
    } catch (NullPointerException e) {
      println("NULL POINTER: " + e.getMessage());
    }
    
    if (jsonFile == null) {
      oscCli.clearMarkov();
      this.curFrame++;
    
      return frame;
    }
    
    int idx = 0;
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke();
    canvas.colorMode(HSB, 100);

    for (int x = 0; x < width; x+= this.dim) {
      for (int y = 0; y< height; y+= this.dim) {
        try {
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
          println("NULL POINTER: id: "+ jsonFile.getName() + ", idx: " + idx + " --"  + e.getMessage());
          oscCli.clearMarkov();
          canvas.endDraw();
          
          this.curFrame++;
         
          return canvas;
        }
      }
    }
    
    canvas.endDraw();
    this.curFrame++;
    oscCli.clearMarkov();
    
    return canvas;
  }
  
  
  public void setColor(color c) {
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.outport = (int)this.set.get("remoteOSCPort");
    this.remoteLocation = new NetAddress("127.0.0.1", outport);
    this.dim = (int)this.set.get("defaultDim");
    this.toMarkovPath = (String)this.set.get("toMarkovPath"); 
    
    this.MAX_ATTEMPTS = (int)map(this.dim, 1, 10, 40, 10);
  }
  
  public void clicked() {}
}
