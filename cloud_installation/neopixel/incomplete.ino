void incompleteBase(int num) {  // num will be numOfSensors, 1 thru 3 

    int stripLength = 0;

//    int mappedMinTime = map(dummyAvg, 1500, 45000, 4000, 35000);
//    int mappedMaxTime = map(dummyAvg, 1500, 45000, 6000, 42000);
    
    switch (num) {
      case 1:
      stripLength = 40;
      break;
      case 2:
      stripLength = 30;
      break;
      case 3:
      stripLength = 24;
      break;  
    }

    int tails[strip.numPixels()/stripLength];
    int heads[strip.numPixels()/stripLength];

    for (int i = 0; i < strip.numPixels()/stripLength; i++) {
      tails[i] = i * stripLength;
      heads[i] = stripLength - 1 + i * stripLength;  
    }

    for(;;) {
      if (num == 4) {
        break;  
      }
      for (int i = 0; i < strip.numPixels(); i++) {
        for (int j = 0; j < strip.numPixels()/stripLength; j++) {
          if (((i >= tails[j]) && (i <= heads[j])) || ((tails[j] > heads[j]) && ((i >= tails[j]) || (i <= heads[j])))) {
            switch (num) {
              case 1:
              switch(j % 3) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                break;  
              }
              break;
              case 2:
              switch(j % 4) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                break;
                case 3:
                strip.setPixelColor(i, incompColor4);
                break;  
              }
              break;
              case 3:
              switch(j % 5) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                break;
                case 3:
                strip.setPixelColor(i, incompColor4);
                break;
                case 4:
                strip.setPixelColor(i, incompColor5);
                break;
              }
              break;      
            }   
          }  
        }
      }

    strip.show();

      
    for (int i = 0; i < strip.numPixels()/stripLength; i++) {
      tails[i]+=d;
      heads[i]+=d;
      if (heads[i] >= strip.numPixels()) {
        heads[i] = 0;
      }
      if (tails[i] >= strip.numPixels()) {
        tails[i] = 0;  
      }
      if(heads[i] < 0) {
        heads[i] = strip.numPixels()-1;  
      }
      if (tails[i] < 0) {
        tails[i] = strip.numPixels()-1;  
      }  
    }

    int mappedAvgSpeed = map(dummyAvg, 1500, 45000, 30, 150);
    
    if (millis() > randBehaviorTime) {
      randBehaviorTime = millis() + random(20000, 30000);
      interrupt = true;
      d = -d;
      return;
    }

    if (millis() > randTrigTime) {
      randTrigTime = millis() + random(10000, 20000);
      trig = true;
      return;  
    }

    int mappedAvgBrightness = map(dummyAvg, 1500, 45000, 200, 0);

    strip.setBrightness(mappedAvgBrightness);

    delay(mappedAvgSpeed);

    dummyAvg += avgChange;
    if ((dummyAvg <= 1500) || (dummyAvg >= 45000)) {
      avgChange = -avgChange; 
    }

  }

}

void incompleteInterrupt(int wait) {


  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(201, 87, 194, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(201, 87, 194, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(85, 206, 191, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(85, 206, 191, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(245, 180, 50, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(245, 180, 50, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

//  if (num >= 2) {
//    for(int j = 0; j < 256; j++) {
//      strip.fill(strip.Color(120, 255, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait);  
//    }
//
//    for(int j = 255; j >= 0; j++) {
//      strip.fill(strip.Color(120, 255, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait);  
//    }
//  }
//
//  if (num == 3) {
//    for(int j = 0; j < 256; j++) {
//      strip.fill(strip.Color(227, 79, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait); 
//    }
//    for(int j = 255; j >= 0; j--) {
//      strip.fill(strip.Color(227, 79, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait);  
//    }   
//  }
  
}

void incomplete(int num) {
  for(;;) {
    if (!(1 <= num && 3 >= num)) return;
    incompleteBase(num);
    if (trig == true) {
      colorWipe(incompColor1, 5);
      trig = false;  
    }
    //incompleteInterrupt(num);
    if (interrupt == true) {
      //incompleteInterrupt();
      pulseWhite(5);
      interrupt = false;  
    }
  }  
}
