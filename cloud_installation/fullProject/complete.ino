void completeInterrupt() {

  
  
}

void completeBase() {


  // for now, generate random location and random max length
  // need variables for center location, max length, current length
  // need to store color of appearing strip and colors on either side

  //map sensor1Val to dominance of color1, sensor2Val -> color2, sensor3Val -> color3, sensor4Val -> color4


//  int center = 20;
//  int maxLength = 19;
//
//  for (int i = 0; i < strip.numPixels(); i++) {
//
//    if(i <= center + growth && i >= center-growth) {
//      strip.setPixelColor(i, blue);  
//    }
//    else {
//      strip.setPixelColor(i, strip.Color(255, 0, 0));
//    }  
//  }
//  strip.show();
//
//  if (growth < maxLength) {
//    growth++;  
//  }
//  

  for(;;){

    if (completeToIncomplete || completeToWaiting) return;

    int centerArrayLength = 10;

    int growthVals[] = {0, 0, 0, 0};

    int color1Centers[centerArrayLength];
    int color2Centers[centerArrayLength];
    int color3Centers[centerArrayLength];
    int color4Centers[centerArrayLength];

    for (int i = 0; i < 10; i++) {
      color1Centers[i] = int(random(0, 256));  /// might get duplicates, need to figure that out
      color2Centers[i] = int(random(0, 256));
      color3Centers[i] = int(random(0, 256));
      color4Centers[i] = int(random(0, 256));
    }

    for(;;) {

      //trackSensors();

      if (completeToIncomplete || completeToWaiting) return;

      int numDone = 0;

      bool doneGrowing[] = {false, false, false, false};

      int color1MaxLength = map(sensor1Val, 1500, 45000, 16, 1);
      int color2MaxLength = map(sensor2Val, 1500, 45000, 16, 1);
      int color3MaxLength = map(sensor3Val, 1500, 45000, 16, 1);
      int color4MaxLength = map(sensor4Val, 1500, 45000, 16, 1);

      int maxLengths[] = {color1MaxLength, color2MaxLength, color3MaxLength, color4MaxLength};

  
      for (int i = 0; i < strip.numPixels(); i++) {
        for (int j = 0; j < centerArrayLength; j++) {
          if (i <= color1Centers[j] + growthVals[0] && i >= color1Centers[j] - growthVals[0]) {
            strip.setPixelColor(i, incompColor1);  
          }
          else if (i <= color2Centers[j] + growthVals[1] && i >= color2Centers[j] - growthVals[1]) {
            strip.setPixelColor(i, incompColor2);  
          }
          else if (i <= color3Centers[j] + growthVals[2] && i >= color3Centers[j] - growthVals[2]) {
            strip.setPixelColor(i, incompColor3);  
          }
          else if (i <= color4Centers[j] + growthVals[3] && i >= color4Centers[j] - growthVals[3]) {
            strip.setPixelColor(i, incompColor4);  
          }
          else {
            strip.setPixelColor(i, strip.Color(0, 0, 0, 255));  
          }  
        }
        
      }



      for (int i = 0; i < 4; i++) {
        if (growthVals[i] < maxLengths[i]) {
          growthVals[i]++;  
        }
        else if (growthVals[i] == maxLengths[i]) {
          doneGrowing[i] = true;  
        }
        if (doneGrowing[i]) {
          numDone++;
        }  
      }

      if (numDone == 4) return;

      strip.show();
      delay(500);

      
//        if (arrayContains(color1Centers, centerArrayLength, i)) {
//          strip.setPixelColor(i, incompColor1);
//          
//        }
//        else if (arrayContains(color2Centers, centerArrayLength,  i)) {
//          strip.setPixelColor(i, incompColor2);  
//        }
//        else if (arrayContains(color3Centers, centerArrayLength, i)) {
//          strip.setPixelColor(i, incompColor3);  
//        }
//        else if (arrayContains(color4Centers, centerArrayLength, i)) {
//          strip.setPixelColor(i, incompColor4);  
//        }
//        else {
//          strip.setPixelColor(i, strip.Color(0, 0, 0, 255));  
//        }
    }
  
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
