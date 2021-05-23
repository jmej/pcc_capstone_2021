class FrameData {
  public ArrayList<FrameInfo> data;
  private int dim;
  private Settings set;
  private String path;
  
  FrameData() {
    data = new ArrayList<FrameInfo>();
  }
  
  public void init(Settings set) {
    this.set = set;
    this.dim = (int)this.set.get("defaultDim");
    this.path = (String)this.set.get("frameDataPath");
  }
  
  public String writeToJson() {
    JSONObject frameJson = new JSONObject();
    
    for (int i = 0; i < data.size(); i++) {
      JSONArray info = new JSONArray();

      FrameInfo fi = data.get(i);
      info.setInt(0, fi.hue);
      info.setInt(1, fi.saturation);
      info.setInt(2, fi.brightness);
      info.setFloat(3, fi.low);
      info.setFloat(4, fi.lowmid);
      info.setFloat(5, fi.highmid);
      info.setFloat(6, fi.high);
      frameJson.setJSONArray(""+ i, info);
    }
     
    String jsonPath = sketchPath(this.path + "/telephone-" + day()+"-"+month()+"-"+year()+"-"+hour()+"-"+minute()+"-"+second()+".json");
    saveJSONObject(frameJson, jsonPath);

    return jsonPath;
  }
  
  public FrameInfo analyze() {
    FrameInfo fi = null;
    try {
      int pixCt = 0;
      int totalHue = 0;
      int totalBright = 0;
      int totalSat = 0;
      int cm = g.colorMode;
      
      colorMode(HSB, 100);
      for (int x = 0; x < width; x += this.dim) {
        for (int y = 0; y < height; y += this.dim) {
          int loc = x + y*width;
          color currentColor = pixels[loc];
          totalHue += hue(currentColor);
          totalSat += saturation(currentColor);
          totalBright += brightness(currentColor);
          pixCt++;
        }
      }
      
      int ha = int(totalHue / pixCt);
      int ba = int(totalBright / pixCt);
      int sa = int(totalSat / pixCt);
      
      println("Frame Info: " + ha + ", " + sa + ", " + ba);
      fi = new FrameInfo(ha, sa, ba, fftData[0], fftData[1], fftData[2], fftData[3]);
    
      this.data.add(fi);
      
      if (cm == RGB) {
        colorMode(cm, 255);
      }
    } catch (NullPointerException e) {
      println(e.getMessage());
    }
    return fi;
  }
}

class FrameInfo {
  int hue;
  int saturation;
  int brightness;
  float low;
  float lowmid;
  float highmid;
  float high;
  
  FrameInfo(int h, int s, int b, float l, float lm, float hm, float hi) {
    this.hue = h;
    this.saturation = s;
    this.brightness = b;
    this.low = l;
    this.lowmid = lm;
    this.highmid = hm;
    this.high = hi;
  }
}
