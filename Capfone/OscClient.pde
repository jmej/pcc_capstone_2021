class OscClient {
  private String finalAudioPath = "";
  
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
      
      if(theOscMessage.checkAddrPattern("/maxaudio")!=true) {
        return ret;
      }
      
      stringVal = theOscMessage.get(0).stringValue();
      this.finalAudioPath = stringVal;
      
      println("MAX AUDIO: " + stringVal);
    } catch (Exception e) {
      println(e.getMessage());
    }
  
    return ret;
  } 
}
