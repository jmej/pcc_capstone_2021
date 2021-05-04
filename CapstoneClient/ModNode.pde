interface ModNode { 

  
  // Take in an image, mod it, return it
  public PImage mod(PImage in);
  
  // To be called during the main setup()
  public void init(Settings s);
  
  public boolean active();
  public void setColor(color c);
  public void setDim(int d);
}
