class OscClient {
  private String finalAudioPath = "";
  private String markovPath = "";
  
  public OscClient() {
    
  }
  
  public void sendJsonPath(String jsonPath) {
    OscMessage myMessage = new OscMessage("/metapath");
    myMessage.add(jsonPath); 
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  public void sendAudioPath(String audioPath) {
    OscMessage myMessage = new OscMessage("/audiopath");
    myMessage.add(audioPath); 
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  public String getFinalAudio() {
    return finalAudioPath;
  }
  
  public PImage event(OscMessage theOscMessage) {
    PImage ret = null;
   
    /* print the address pattern and the typetag of the received OscMessage */
    print("### SERVER received an osc message.");
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());  
  
    try {
      String stringVal = "";
      
      if(theOscMessage.checkAddrPattern("/maxaudio")==true) {
        stringVal = theOscMessage.get(0).stringValue();
        this.finalAudioPath = stringVal;
        println("MAX AUDIO: " + stringVal);
      } else 
      if (theOscMessage.checkAddrPattern("/markovout")==true) {
        stringVal = theOscMessage.get(0).stringValue();
        println("Got Markov JSON: " + stringVal); 
        this.markovPath = stringVal;
      } else {
        stringVal = theOscMessage.get(0).stringValue();
        println("Didn't match anything, assuming markov data... - > " + stringVal);
        this.markovPath = stringVal;
      }

    } catch (Exception e) {
      println(e.getMessage());
    }
  
    return ret;
  } 
  
  public void clearMarkov() {
    this.markovPath = "";
  }
  
  public String getMarkovPath() {
    return this.markovPath;
  }
}
