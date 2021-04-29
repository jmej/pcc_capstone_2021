import processing.core.PApplet;

class Settings {

  private JSONObject settings;
  
  public Settings(PApplet p) {
    try {
      File set = new File(dataPath("settings.json"));
      /*new File(CapstoneClient.class.getProtectionDomain()
        .getCodeSource().getLocation().toURI().getPath())
        .getParentFile().getParentFile(); */
      settingsPath = set.getAbsolutePath();
      println(settingsPath);

     File settingsFile = new File(settingsPath);
      if (settingsFile.isFile()) {
        this.settings = p.loadJSONObject(settingsPath);
      } else {
        println("FUCCKCKCKCKC");
      }
    } catch (Exception e) {
      println(e.getMessage());
      exit();
    }
  }
  
  public Object get(String s) {
    println("Getting " + s);
    return this.settings.get(s);
  } 
}
