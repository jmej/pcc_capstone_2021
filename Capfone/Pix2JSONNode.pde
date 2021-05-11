public class Pix2JSONNode  implements ModNode {
  private Settings set;  
  private int dim = 5;
  private int totalbright = 0;
  private int totalpix = 0;
  private int curFrame = 0;
  private color trackColor;
  private boolean active = true;
  private String route = "/capfonePix";
  private IntList colors;
    
  public PImage mod(PImage frame) {
    if (frame.pixels == null || frame.pixels.length == 0) frame.loadPixels();
    
    colors = new IntList();
    OscMessage msg = null;
    int cm = g.colorMode;
    int totalHue = 0;
    colorMode(HSB, 100); 

    JSONObject out = new JSONObject();
    int i = 0;
    for (int x = 0; x < frame.width; x += dim ) {
      for (int y = 0; y < frame.height; y += dim ) {
        int loc = x + y*frame.width;
        color c = frame.pixels[loc];  
        JSONArray elem = new JSONArray();
        elem.setInt(0, (int)hue(c));
        elem.setInt(1, (int)saturation(c));
        elem.setInt(2, (int)brightness(c));
        out.setJSONArray("" + i, elem);
        //totalHue += hue(c);
        i++;  
      } 
    }
    
    
  /*  for (int i = 0; i < colors.size(); i++) {

      
      String m = this.route + "/" +  
      hue(c) + "/" + 
      saturation(c) + "/" + 
      brightness(c) + "/" + 
      "1";

      msg = new OscMessage(m);
      oscP5.send(msg, myRemoteLocation);
      delay(5);
      
    }
    */
    
  /*  String end = this.route + "/0/0/0/2";
    msg = new OscMessage(end);
    oscP5.send(msg, myRemoteLocation);*/
    
    saveJSONObject(out, "data/frame-" + this.curFrame + ".json");
      
    this.curFrame++;
     
    if (cm != HSB) {
      colorMode(cm, 255);
    }
    return frame;
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
