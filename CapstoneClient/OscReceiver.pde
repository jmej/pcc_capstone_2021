class OscReceiver {
  
  public OscReceiver() {
    
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
        while(!client.newFrame()) {
        delay(100);
         ct++;
        if (ct > 10) return ret;
        }

        ret = client.getImage(ret);
    } 
  } catch (Exception e) {
    println(e.getMessage());
  }
  
  return ret;
} 
}
