class OscClient {
  
  public OscClient() {
    
  }
  
  public void sendJsonPath(String jsonPath) {
    OscMessage myMessage = new OscMessage("/capfone");
    myMessage.add(jsonPath); 
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  public PImage event(OscMessage theOscMessage) {
    PImage ret = null;
   
    /* print the address pattern and the typetag of the received OscMessage */
    print("### SERVER received an osc message.");
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());  
  
    try {
      float floatVal = 0;
      String stringVal = "";
      
      if(theOscMessage.checkAddrPattern("/capstoneCli")!=true) {
        return ret;
      }
      
      if(theOscMessage.checkTypetag("f")) {
        floatVal = theOscMessage.get(0).floatValue(); 
      }
      
      if(theOscMessage.checkTypetag("s")) {
        stringVal = theOscMessage.get(0).stringValue();
        println("STRING: " + stringVal);
        
        int ct = 0;
      } 
    } catch (Exception e) {
      println(e.getMessage());
    }
  
    return ret;
  } 
}
