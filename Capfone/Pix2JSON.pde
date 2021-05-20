/*
 * This class is used for the generation of a json file
 * which contains hsb values for each "pixel" (of size dim)
 * of a given frame in this sketch. This is to be fed to an 
 * external markov chain, which outputs results to be fed to
 * ReadMarkovNode afterward.
 */
public class Pix2JSON {
  private Settings set;  
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private String route = "/tomarkov";
  private String toMarkovPath;
  private int port = 12002;
  private NetAddress remoteLocation;
  
  Pix2JSON() {
  }
    
  public void analyze() {
    if (!this.active) return;
    if (pixels == null || pixels.length == 0) loadPixels();
    
    OscMessage msg = null;
    int cm = g.colorMode;
    colorMode(HSB, 100); 

    JSONObject out = new JSONObject();
    int i = 0;
    for (int x = 0; x < width; x += this.dim ) {
      for (int y = 0; y < height; y += this.dim ) {
        int loc = x + y*width;
        color c = pixels[loc];  
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
    msg = new OscMessage(outPath);
    oscP5.send(msg, this.remoteLocation);
    
    if (this.curFrame == 0) {
      msg = new OscMessage("/begin");
      oscP5.send(msg, this.remoteLocation);
    }
      
    this.curFrame++;
     
    if (cm != HSB) {
      colorMode(cm, 255);
    }
  }
  
  public void sendEndMsg() {
    OscMessage msg = new OscMessage("/end/" + this.curFrame);
    oscP5.send(msg, this.remoteLocation);
  }
  
  public void setColor(color c) {
   // this.trackColor = c;
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public boolean active() {
    return this.active;
  }
  
  public void init(Settings set) {
    this.set = set;
    this.port = (int)this.set.get("markovOSCPort");
    this.remoteLocation = new NetAddress("127.0.0.1", this.port);
    this.active = (boolean)this.set.get("markovGen");
    this.dim = (int)this.set.get("defaultDim");
    this.toMarkovPath = (String)this.set.get("toMarkovPath");
  }
  
  public void clicked() {}
}
