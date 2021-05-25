void incomplete(int num) {
  for(;;) {
    incompleteBase(num);
    if (growingIncomplete == true) {
      colorWipe(incompColors[num - 2], 5);
      growingIncomplete = false;  
    }
    if (shrinkingIncomplete == true) {
      reverseColorWipe(incompColors[num - 1], 5);   // not sure num -1 is correct here
      shrinkingIncomplete = false;  
    }
    if (interrupt == true) {
      //incompleteInterrupt();
      pulseWhite(5);
      interrupt = false;  
    }
    if (incompleteToComplete) {
      incompleteToComplete = false;
      complete();  
    }
    if (incompleteToWaiting) {
      incompleteToWaiting = false;
      waiting();  
    }
  }
}



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

//      int s1;
//      int s2;
//      int s3;
//      int s4;
//      int vals[4];
//      if (frameCount % 5 == 0) {
//        s1 = pulseIn(sensor1Pin, HIGH);
//        s2 = pulseIn(sensor2Pin, HIGH);
//        s3 = pulseIn(sensor3Pin, HIGH);
//        s4 = pulseIn(sensor4Pin, HIGH);
//        vals[0] = s1;
//        vals[1] = s2;
//        vals[3] = s3;
//        vals[4] = s4;
//        for (int i = 0; i < 4; i++) {
//          Serial.println(vals[i]);  
//        }
//        trackSensors(vals);
//      }

      int s1 = pulseIn(sensor1Pin, HIGH);
      int s2 = pulseIn(sensor2Pin, HIGH);
      int s3 = pulseIn(sensor3Pin, HIGH);
      int s4 = pulseIn(sensor4Pin, HIGH);
      int vals[] = {s1, s2, s3, s4};

      for (int i = 0; i < 4; i++) {
        Serial.print(vals[i]);
        Serial.print(", ");  
      }
      Serial.println();

      

      
      if (incompleteToComplete || incompleteToWaiting || shrinkingIncomplete || growingIncomplete) return;
      for (int i = 0; i < strip.numPixels() * 2; i++) {
        for (int j = 0; j < strip.numPixels()/stripLength; j++) {
          if (((i >= tails[j]) && (i <= heads[j])) || ((tails[j] > heads[j]) && ((i >= tails[j]) || (i <= heads[j])))) {
            switch (num) {
              case 1:
              switch(j % 3) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                strip2.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                strip2.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                strip2.setPixelColor(i, incompColor3);
                break;  
              }
              break;
              case 2:
              switch(j % 4) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                strip2.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                strip2.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                strip2.setPixelColor(i, incompColor3);
                break;
                case 3:
                strip.setPixelColor(i, incompColor4);
                strip2.setPixelColor(i, incompColor4);
                break;  
              }
              break;
              case 3:
              switch(j % 5) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                strip2.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                strip2.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                strip2.setPixelColor(i, incompColor3);
                break;
                case 3:
                strip.setPixelColor(i, incompColor4);
                strip2.setPixelColor(i, incompColor4);
                break;
                case 4:
                strip.setPixelColor(i, incompColor5);
                strip2.setPixelColor(i, incompColor5);
                break;
              }
              break;      
            }   
          }  
        }
      }

    strip.show();
    strip2.show();

      
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
    //int mappedAvgSpeed = map(avgSensorVal(vals), sensorMin, sensorMax, 30, 150);
    
    if (millis() > randBehaviorTime) {
      randBehaviorTime = millis() + random(20000, 30000);
      interrupt = true;
      d = -d;
      return;
    }

    int mappedAvgBrightness = map(dummyAvg, 1500, 45000, 200, 0);
    //int mappedAvgBrightness = map(avgSensorVal, sensorMin, sensorMax, 200, 0);

    strip.setBrightness(mappedAvgBrightness);
    strip2.setBrightness(mappedAvgBrightness);
    currentBrightness = mappedAvgBrightness;

    //delay(mappedAvgSpeed);

    dummyAvg += avgChange;
    if ((dummyAvg <= 1500) || (dummyAvg >= 45000)) {
      avgChange = -avgChange; 
    }
    frameCount++;
  }

}

void incompleteInterrupt(int wait) {

  
  
}
