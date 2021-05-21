public class HarmDistNode implements ModNode {
  private Settings set;
  private int dim = 10;
  private float magnitude = 10;
  private float rampSpeed = 20;
  private float frequency = 10;
  private int frames;
  private int curFrame = 0;
  private int frameModCt = 2;
  
  public void init(Settings set) {
    this.set = set;
  }
  
  public PImage mod(PImage f) {
    PGraphics canvas = createGraphics(f.width, f.height);
    canvas.beginDraw();
    canvas.noStroke(); 
    canvas.image(f, 0, 0, f.width, f.height);
    
    frames+= rampSpeed; 
    frames = frames % 360;
    
    if (this.curFrame % this.frameModCt == 0) {
      frequency = map(RMS_SCALED, 0.0, 1.0, 1, 100); 
      magnitude = map(fftData[0], 0.0, 0.5, 2, 50);
    }
    
    for (int x = 0; x < f.width; x += this.dim){
      for(int y = 0; y < f.height; y += this.dim){
        color pix = f.get(x, y);
        canvas.fill(pix, 128);
        float phase = map(x, 0, width, 0, frequency);
        float wave = sin(frames-phase);
        wave = wave * magnitude;
        canvas.rect(x, y+wave, this.dim, this.dim);
      }
    }
    
    canvas.endDraw();
    soundSource.pause();
    this.curFrame++;
    
    return canvas;
  }
  
  public boolean active() {
    return true;
  }
  
  public void setColor(color c) {
  }
  
  public void setDim(int d) {
    this.dim = d;
  }
  
  public void clicked() {}
}
