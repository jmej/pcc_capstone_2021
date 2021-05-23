void completeInterrupt() {

  
  
}

void completeBase() {


  // for now, generate random location and random max length
  // need variables for center location, max length, current length
  // need to store color of appearing strip and colors on either side

  for(;;){

    int indices[50];

    for (int i = 0; i < 50; i++) {
      indices[i] = int(random(0, 256));  /// might get duplicates, need to figure that out
    }

  for (int i = 0; i < strip.numPixels(); i++) {
    if (arrayContains(indices, i)) {
      strip.setPixelColor(i, incompColor1);  
    }
    else {
      strip.setPixelColor(i, strip.Color(0, 0, 0, 255));  
    }
  }
  strip.show();
  delay(100);

  }

}

void complete(int num) {
  for(;;) {
    if(num != 4) return;
    completeBase();
    completeInterrupt();  
  }
}
