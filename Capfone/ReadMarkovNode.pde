import java.util.Comparator;

public class ReadMarkovNode  implements ModNode {
  private Settings set;  
  private int dim = 4;
  private int curFrame = 0;
  private boolean active = true;
  private int fileIdx = 0;
  private final int MAX_ATTEMPTS = 10;
  private File[] files;
  private String fromMarkovPath;
    
  public PImage mod(PImage frame) {
    if (frame.pixels.length == 0) frame.loadPixels();
    
    JSONObject main = null;
    File jsonFile = null;
    int attempts = 0;
    
    try {
      File file = new File(sketchPath(this.fromMarkovPath));
      if (file.listFiles().length == 0) {
        println("No Markov data available!");
        return frame;
      }
      
      this.files = file.listFiles();
      
      while(jsonFile == null && attempts < this.MAX_ATTEMPTS) {
        jsonFile = this.getNextFile(file);
        fileIdx++;
        if (fileIdx > files.length) {
          fileIdx = 0;
        }
        
        attempts++;
      }
      
      if (jsonFile == null) {
        println("No file json file found, idx: "+ fileIdx);
        return frame;   
      } 
      
      println("JSON file: " + jsonFile.getAbsolutePath());
  
      main = loadJSONObject(jsonFile.getAbsolutePath()); 
      
    } catch (NullPointerException e) {
      println("NULL POINTER: " + e.getMessage());
    }
    
    if (jsonFile == null || main == null) {
      return frame;
    }
    
    PGraphics canvas = createGraphics(frame.width, frame.height);
    canvas.beginDraw();
    canvas.noStroke();
    colorMode(HSB, 100);
   
    int idx = 0;

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
          canvas.endDraw();
          fileIdx++;
          if (files != null && fileIdx > files.length) fileIdx = 0;
         
          return canvas;
        }
      }
    }

    fileIdx++;
    if (files != null && fileIdx > files.length) {
      fileIdx = 0;
    }
    
    canvas.endDraw();
    return canvas;
  }
  
  private File getNextFile(File file) {
    File jsonFile = null;
    
    if (file.isDirectory()) {
       this.files = file.listFiles();
       Comparator<File> byModificationDate = new ModificationDateCompare();
       java.util.Arrays.sort(this.files, byModificationDate);
       
       if (this.files.length > 0 && this.fileIdx < this.files.length) {
         jsonFile = this.files[fileIdx]; 
         
         if (jsonFile.isDirectory()) {
           return null;
         } 
         
         if (jsonFile.getName().equals(".DS_Store")) {
           println("Deleted .DS_store");
           jsonFile.delete();
           return null;
         }
         
         if (jsonFile.getName().indexOf(".json") == -1) {
           return null;
         }
       }
    }
    
    return jsonFile;
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
    this.fromMarkovPath = (String)this.set.get("fromMarkovPath");
  }
  
  public void clicked() {}
}


class ModificationDateCompare implements Comparator<File> {
    public int compare(File f1, File f2) {
      return Long.valueOf(f1.lastModified()).compareTo(f2.lastModified());    
    }
}
