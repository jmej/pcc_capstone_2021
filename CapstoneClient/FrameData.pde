class FrameData {
  public ArrayList<FrameInfo> data;
  private int dim;
  
  FrameData(int d) {
    this.dim = d; 
    data = new ArrayList<FrameInfo>();
  }
  
  public String writeToJson() {
    JSONObject frameJson = new JSONObject();
    JSONArray dataArray = new JSONArray();
    
    for (int i = 0; i < data.size(); i++) {
      JSONObject info = new JSONObject();
      FrameInfo fi = data.get(i);
      info.setInt("hue", fi.hue);
      info.setInt("saturation", fi.saturation);
      info.setInt("brightness", fi.brightness);
      info.setFloat("low", fi.low);
      info.setFloat("mid", fi.mid);
      info.setFloat("high", fi.high);
      dataArray.setJSONObject(i, info);
    }
    
    frameJson.setJSONArray("data", dataArray);
     
    String jsonPath = dataPath("telephone-" + day()+"-"+month()+"-"+year()+"-"+hour()+"-"+minute()+"-"+second()+".json");
    saveJSONObject(frameJson, jsonPath);

    return jsonPath;
  }
  
  public FrameInfo analyze() {
    FrameInfo fi = null;
    try {
      int cm = g.colorMode;
  
      
      colorMode(HSB, 100);
      
      int pixCt = 0;
      int totalHue = 0;
      int totalBright = 0;
      int totalSat = 0;
  
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
      fi = new FrameInfo(ha, sa, ba, 0, 0, 0);
    
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
  float mid;
  float high;
  
  FrameInfo(int h, int s, int b, float l, float m, float hi) {
    this.hue = h;
    this.saturation = s;
    this.brightness = b;
    this.low = l;
    this.mid = m;
    this.high = hi;
  }
}
