void completeInterrupt() {

  
  
}

void completeBase() {


  // for now, generate random location and random max length
  // need variables for center location, max length, current length
  // need to store color of appearing strip and colors on either side

  //map sensor1Val to dominance of color1, sensor2Val -> color2, sensor3Val -> color3, sensor4Val -> color4

  for(;;){

    //trackSensors();

    color1MaxLength = map(sensor1Val, 1500, 45000, 16, 1);
    color2MaxLength = map(sensor2Val, 1500, 45000, 16, 1);
    color3MaxLength = map(sensor3Val, 1500, 45000, 16, 1);
    color4MaxLength = map(sensor4Val, 1500, 45000, 16, 1);

    if (completeToIncomplete || completeToWaiting) return;

    //int indices[50];
    int color1Indices[10];
    int color2Indices[10];
    int color3Indices[10];
    int color4Indices[10];

    for (int i = 0; i < 10; i++) {
      color1Indices[i] = int(random(0, 256));  /// might get duplicates, need to figure that out
      color2Indices[i] = int(random(0, 256));
      color3Indices[i] = int(random(0, 256));
      color4Indices[i] = int(random(0, 256));
    }

  for (int i = 0; i < strip.numPixels(); i++) {
    if (arrayContains(color1Indices, i)) {
      strip.setPixelColor(i, incompColor1);  
    }
    else if (arrayContains(color2Indices, i)) {
      strip.setPixelColor(i, incompColor2);  
    }
    else if (arrayContains(color3Indices, i)) {
      strip.setPixelColor(i, incompColor3);  
    }
    else if (arrayContains(color4Indices, i)) {
      strip.setPixelColor(i, incompColor4);  
    }
    else {
      strip.setPixelColor(i, strip.Color(0, 0, 0, 255));  
    }
  }
  strip.show();
  delay(300);

  }

}

void complete() {
  for(;;) {
    completeBase();
    if (completeToIncomplete) {
      completeToIncomplete = false;
      incomplete(usedSensors);  
    }
    if (completeToWaiting) {
      completeToWaiting = false;
      waiting();  
    }
    if (interrupt) {
      completeInterrupt();
      interrupt = false;
    }  
  }
}
