void incomplete(int num) {
  for(;;) {
    incompleteBasev2(num);
    if (growingIncomplete == true) {
      colorWipe(incompColors[num]);
      growingIncomplete = false;  
    }
    if (shrinkingIncomplete == true) {
      reverseColorWipe(incompColors[num - 1]);
      shrinkingIncomplete = false;  
    }
    if (interrupt == true) {
      incompleteInterrupt();
      //pulseWhite(5);
      interrupt = false;  
    }
    if (incompleteToComplete) {
      incompleteToComplete = false;
      fromItoC();
      complete();  
    }
    if (incompleteToWaiting) {
      incompleteToWaiting = false;
      waiting();  
    }
  }
}



//void incompleteBase(int num) {  // num will be numOfSensors, 1 thru 3
//
//    int stripLength = 0;
//
////    int mappedMinTime = map(dummyAvg, 1500, 45000, 4000, 35000);
////    int mappedMaxTime = map(dummyAvg, 1500, 45000, 6000, 42000);
//    
//    switch (num) {
//      case 1:
//      stripLength = 40;
//      break;
//      case 2:
//      stripLength = 30;
//      break;
//      case 3:
//      stripLength = 24;
//      break;  
//    }
//
//    int tails[strip.numPixels()/stripLength];
//    int heads[strip.numPixels()/stripLength];
//
//    for (int i = 0; i < strip.numPixels()/stripLength; i++) {
//      tails[i] = i * stripLength;
//      heads[i] = stripLength - 1 + i * stripLength;  
//    }
//
//    int numOfTwinkles = 24;
//
//    int twinklingIndices[numOfTwinkles];
//
//    for(;;) {
//
//        float s1 = analogRead(sensor1Pin);
//        float s2 = analogRead(sensor2Pin);
//        float s3 = analogRead(sensor3Pin);
//        float s4 = analogRead(sensor4Pin);
//        float vals[] = {s1, s2, s3, s4};
//
//      //smoothVals(vals);
//
//      //trackSensors(vals);
//      if (incompleteToComplete || incompleteToWaiting || shrinkingIncomplete || growingIncomplete) return;
//
//      int mappedAvgBrightness = int(map(avgSensorVal(vals), 0, 1, 200, 0));
//      int mappedDelay = int(map(avgSensorVal(vals), 0, 1, 50, 300));
//
//      for (int i = 0; i < numOfTwinkles; i++) {
//        twinklingIndices[i] = int(random(0, 240));  
//      }
//
//
//      
//      for (int i = 0; i < strip.numPixels() * 2; i++) {
//        for (int j = 0; j < strip.numPixels()/stripLength; j++) {
//          if (((i >= tails[j]) && (i <= heads[j])) || ((tails[j] > heads[j]) && ((i >= tails[j]) || (i <= heads[j])))) {
//            switch (num) {
//              case 1:
//              switch(j % 3) {
//                case 0:
//                strip.setPixelColor(i, incompColor1);
//                strip2.setPixelColor(i, incompColor1);
//                break;
//                case 1:
//                strip.setPixelColor(i, incompColor2);
//                strip2.setPixelColor(i, incompColor2);
//                break;
//                case 2:
//                strip.setPixelColor(i, incompColor3);
//                strip2.setPixelColor(i, incompColor3);
//                break;  
//              }
//              break;
//              case 2:
//              switch(j % 4) {
//                case 0:
//                strip.setPixelColor(i, incompColor1);
//                strip2.setPixelColor(i, incompColor1);
//                break;
//                case 1:
//                strip.setPixelColor(i, incompColor2);
//                strip2.setPixelColor(i, incompColor2);
//                break;
//                case 2:
//                strip.setPixelColor(i, incompColor3);
//                strip2.setPixelColor(i, incompColor3);
//                break;
//                case 3:
//                strip.setPixelColor(i, incompColor4);
//                strip2.setPixelColor(i, incompColor4);
//                break;  
//              }
//              break;
//              case 3:
//              switch(j % 5) {
//                case 0:
//                strip.setPixelColor(i, incompColor1);
//                strip2.setPixelColor(i, incompColor1);
//                break;
//                case 1:
//                strip.setPixelColor(i, incompColor2);
//                strip2.setPixelColor(i, incompColor2);
//                break;
//                case 2:
//                strip.setPixelColor(i, incompColor3);
//                strip2.setPixelColor(i, incompColor3);
//                break;
//                case 3:
//                strip.setPixelColor(i, incompColor4);
//                strip2.setPixelColor(i, incompColor4);
//                break;
//                case 4:
//                strip.setPixelColor(i, incompColor5);
//                strip2.setPixelColor(i, incompColor5);
//                break;
//              }
//              break;      
//            }   
//          }  
//        }
//      }
//
//      if (twinkle) {
//        for (int i = 0; i < strip.numPixels() * 2; i++) {
//          if (arrayContains(twinklingIndices, numOfTwinkles, i)) {
//            if (i < 240) {
//              strip.setPixelColor(i, strip.Color(0,0,0,255));
//            }
//            else {
//              strip2.setPixelColor(i - 240, strip.Color(0, 0, 0, 255));  
//            }  
//          }  
//        }
//        twinkleFrames++;
//      }
//      if(twinkleFrames > 60) {
//        twinkle = false;  
//      }
//
//
//    //colorWipe(strip.Color(255,0,0));
//
//    strip.show();
//    strip2.show();
//
//      
//    for (int i = 0; i < strip.numPixels()/stripLength; i++) {
//      tails[i]+=d;
//      heads[i]+=d;
//      if (heads[i] >= strip.numPixels()) {
//        heads[i] = 0;
//      }
//      if (tails[i] >= strip.numPixels()) {
//        tails[i] = 0;  
//      }
//      if(heads[i] < 0) {
//        heads[i] = strip.numPixels()-1;  
//      }
//      if (tails[i] < 0) {
//        tails[i] = strip.numPixels()-1;  
//      }  
//    }
////
////    if (millis() > checkTime) {
////      checkTime = millis() + 5000;
////      shrinkingIncomplete = true;  
////    }
//    
//    if (millis() > randBehaviorTime) {
//      randBehaviorTime = millis() + random(20000, 30000);
//      twinkleFrames = 0;
//      twinkle = true;
//      d = -d;
//      return;
//    }
//
//    delay(mappedDelay);
//
//    //int mappedAvgBrightness = map(dummyAvg, 1500, 45000, 200, 0);
//
//    strip.setBrightness(mappedAvgBrightness);
////    strip2.setBrightness(mappedAvgBrightness);
//    //currentBrightness = mappedAvgBrightness;
//
////    dummyAvg += avgChange;
////    if ((dummyAvg <= 1500) || (dummyAvg >= 45000)) {
////      avgChange = -avgChange; 
////    }
//  }
//
//}

void incompleteInterrupt() {

  float s1 = analogRead(sensor1Pin);
  float s2 = analogRead(sensor2Pin);
  float s3 = analogRead(sensor3Pin);
  float s4 = analogRead(sensor4Pin);
  float vals[] = {s1, s2, s3, s4};

  smoothVals(vals);
  //trackSensors(vals);

  meteorRain(201, 87, 194, 4, 22, true, 80);

  
  
  
}

void incompleteBasev2(int num) {

  int x = 0;
  int numOfIndices = 0;
  int numOfColor1 = 0;
  int numOfColor2 = 0;
  int numOfColor3 = 0;

  int usedSensorIndices[num];

  int usedSensorVals[num];
  int index = 0;
  bool usedSensorsRecorded = false;

  switch(num) {
    case 1:
    numOfIndices = 175;
    break;
    case 2:
    numOfIndices = 204;
    break;
    case 3:
    numOfIndices = 225;
    break;   
  }

  int doms[num];
  
  int indices[numOfIndices];

  for (int i = 0; i < numOfIndices; i++) {
    indices[i] = int(random(0, 240));  
  }

  //75 + 75 * 

  for(;;) {

    int sensorNotUsed = 0;

    int maxDiff = 0;
    int minDiff = 1;

    float s1 = analogRead(sensor1Pin);
    float s2 = analogRead(sensor2Pin);
    float s3 = analogRead(sensor3Pin);
    float s4 = analogRead(sensor4Pin);

    float vals[] = {s1, s2, s3, s4};
    
    smoothVals(vals);
    //trackSensors(vals);
    //scaleVals(vals);
    //trackDummySensors();
    if (incompleteToComplete || incompleteToWaiting || growingIncomplete || shrinkingIncomplete) return;


    if (num == 3) {
      for (int i = 0; i < 4; i++) {
        if (!(vals[i] < 1)) {
          sensorNotUsed = i;  
        }
      }  
    }

    
    for (int i = 0; i < 4; i++) {
      if (i != sensorNotUsed) {
        switch (sensorNotUsed) {
          case 0:
          usedSensorVals[i-1] = vals[i];
          break;
          case 1:
          if (i == 0) {
            usedSensorVals[i] = vals[i];  
          }
          else {
            usedSensorVals[i-1] = vals[i];  
          }
          break;
          case 2:
          if (i == 0 || i == 1) {
            usedSensorVals[i] = vals[i];  
          }
          else {
            usedSensorVals[i-1] = vals[i];  
          }
          break;
          case 3:
          usedSensorVals[i] = vals[i];
          break;   
        }  
      }
    }

    if (num == 3) {
      for (int i = 0; i < num; i++) {
        if (maxDiff > 0 && minDiff > 0) {
          //doms[i] = int(map(avgSensorVals(vals) - usedSensorVals[i], minDiff, maxDiff, 
        }
      }  
    }

    int mappedDelay = int(map(avgSensorVal(vals), 0, 1, 300, 2000));

    for (int i = 0; i < strip.numPixels(); i++) {
      switch(num) {
        case 1:
          if (arrayContains(indices, numOfIndices, i)) {
            strip.setPixelColor(i, incompColors[0]);
            strip2.setPixelColor(i, incompColors[0]);  
          }
          else {
            strip.setPixelColor(i, strip.Color(0,0,0,0));
            strip2.setPixelColor(i, strip.Color(0,0,0,0));
          }
        break;
        case 2:
          if (arrayContains(indices, numOfIndices, i)) {
            if (getIndex(indices, numOfIndices, i) < numOfIndices/2) {
              strip.setPixelColor(i, incompColors[0]);
              strip2.setPixelColor(i, incompColors[0]);  
            }
            else {
              strip.setPixelColor(i, incompColors[1]);
              strip2.setPixelColor(i, incompColors[1]);  
            }
          }
          else {
            strip.setPixelColor(i, strip.Color(0,0,0,0));
            strip2.setPixelColor(i, strip.Color(0, 0, 0,0));  
          }
        break;
        case 3:
          if (arrayContains(indices, numOfIndices, i)) {
            if (getIndex(indices, numOfIndices, i) < numOfIndices/3) {
              strip.setPixelColor(i, incompColors[0]);
              strip2.setPixelColor(i, incompColors[0]);  
            }
            else if (getIndex(indices, numOfIndices, i) >= numOfIndices/3 && getIndex(indices, numOfIndices, i) < 2 * (numOfIndices/3)) {
              strip.setPixelColor(i, incompColors[1]);
              strip2.setPixelColor(i, incompColors[1]);  
            }
            else {
              strip.setPixelColor(i, incompColors[2]);
              strip2.setPixelColor(i, incompColors[2]);  
            }  
          }
          else {
            strip.setPixelColor(i, strip.Color(0, 0, 0, 0));
            strip2.setPixelColor(i, strip.Color(0, 0, 0, 0));  
          }
        break;  
      }  
    }

    

    x++;

    if (x % 50 == 0) {
      for (int i = 0; i < numOfIndices; i++) {
        indices[i] = int(random(0, 240));  
      }
    }
    strip.show();
    strip2.show();
    //delay(2000);
  }
  
}
