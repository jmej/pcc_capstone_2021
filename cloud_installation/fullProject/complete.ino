void complete() {
  for(;;) {
    completeBasev2();
    if (completeToIncomplete) {
      Serial.println("c to i");
      completeToIncomplete = false;
      fromCtoI();
      incomplete(usedSensors);  
    }
    if (completeToWaiting) {
      Serial.println("c to w");
      completeToWaiting = false;
      fromCtoW();
      waiting();  
    }
    if (interrupt) {
      Serial.println("interrupt");
      completeInterrupt();
    }  
  }
}

void completeInterrupt() {

  interrupt = false;
//
//  for(;;) {
//    Fire(20, 50, 15);
//    if (fWhite >= 255) return;
//    //Serial.println(halfRecordedFrameCount);
//  }
//  for (int i = 0; i < strip.numPixels()*2; i++) {
//    doubleFade(i, 22);
//  }

    

  //Serial.println(halfRecordedFrameCount);
  // play around with values
  
  
}

void completeBase() {

  fBrightness = 0;
  fWhite = 0;


  // for now, generate random location and random max length
  // need variables for center location, max length, current length
  // need to store color of appearing strip and colors on either side

  //map sensor1Val to dominance of color1, sensor2Val -> color2, sensor3Val -> color3, sensor4Val -> color4



  for(;;){
    if (completeToIncomplete || completeToWaiting || interrupt) return;

//    maxSensorIndex = findMaxSensor(storeVals());
//
//    int avg = avgSensors(storeVals());
//    int startingIndex;
//    if (maxSensorIndex < 3) {
//      startingIndex = maxSensorIndex + 1; 
//    }
//    else {
//      startingIndex = 0;  
//    }


    int centerArrayLength = 4;

    int maxLength = 10; 

    int growthVals[] = {0, 0, 0, 0};


    int centers1[4][centerArrayLength];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < centerArrayLength; j++) {
        //centers[i][j] = int(random(0, 256));
        centers1[i][j] = int(random(j * strip.numPixels()/centerArrayLength, (j + 1) * strip.numPixels()/centerArrayLength));  
      }  
    }

    int centers2[4][centerArrayLength];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < centerArrayLength; j++) {
        //centers[i][j] = int(random(0, 256));
        centers2[i][j] = int(random(j * strip.numPixels()/centerArrayLength, (j + 1) * strip.numPixels()/centerArrayLength));  
      }  
    }

    bool doneGrowing[] = {false, false, false, false};

    
    
    for(;;) {

      float s1 = analogRead(sensor1Pin);
      float s2 = analogRead(sensor2Pin);
      float s3 = analogRead(sensor3Pin);
      float s4 = analogRead(sensor4Pin);

      float vals[] = {s1, s2, s3, s4};

//
      smoothVals(vals);
      //scaleMax(vals);

      //trackSensors(vals);
      if (completeToIncomplete || completeToWaiting || interrupt) return;

//      
      //int mappedAvgBrightness = map(avgSensorVal(vals), sensorMin, sensorMax, 200, 0);
      //int mappedAvgIndices = int(map(avgSensorVal(vals), sensorMin, sensorMax, 120, 10));
      int mappedAvgIndices = 20;
      int numDone = 0;

      int color1MaxLength = map(vals[0], sensorMin, sensor1Max, 16, 1);
      int color2MaxLength = map(vals[1], sensorMin, sensor2Max, 16, 1);
      int color3MaxLength = map(vals[2], sensorMin, sensor3Max, 16, 1);
      int color4MaxLength = map(vals[3], sensorMin, sensor4Max, 16, 1);

      int maxLengths[] = {color1MaxLength, color2MaxLength, color3MaxLength, color4MaxLength};
      //int maxLengths[] = {10, 10, 10, 10};

      //int mappedAvg = map(avgSensorVal(), 1500, 45000, 60, 10);
      
      int maxVal = 0;
      int maxSensor;
      int startingIndex;

      for (int i = 0; i < 4; i++) {
        if (vals[i] > maxVal) {
          maxSensor = i;
        }
      }

      if (maxSensor == 4) {
        startingIndex = 0;  
      }
      else {
        startingIndex = maxSensor + 1;  
      }
   
      int twinklingIndices[mappedAvgIndices];

      for (int i = 0; i < mappedAvgIndices; i++) {
        twinklingIndices[i] = int(random(0, 480));  
      }
      

      for (int i = 0; i < strip.numPixels() * 2; i++) {
        for (int j = 0; j < centerArrayLength; j++) {
          for (int k = startingIndex; k < startingIndex + 4; k++) {
            if (i < 240) {
              if (i <= centers1[k % 4][j] + growthVals[k % 4] && i >= centers1[k % 4][j] - growthVals[k % 4]) {
                strip.setPixelColor(i, compColors[k % 4]);  
              }
            }
            else {
              if ((i-240) <= centers2[k % 4][j] + growthVals[k % 4] && (i-240) >= centers2[k % 4][j] - growthVals[k % 4]) {
                strip2.setPixelColor(i-240, compColors[k % 4 ]);
              }  
            } 
          } 
        }
      }
//
//      for (int i = 0; i < strip.numPixels() * 2; i++) {
//        if (arrayContains(twinklingIndices, mappedAvgIndices, i)) {
//          if (i < 240) {
//            strip.setPixelColor(i, strip.Color(0,0,0,255));
//          }
//          else {
//            strip2.setPixelColor(i - 240, strip.Color(0, 0, 0, 255));  
//          }  
//        }  
//      }

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

      if (numDone == 4) {
        return;
      }

      strip.show();
      strip2.show();

      if(millis() > checkTime) {
        interrupt = true;
        checkTime = millis() + 20000;
        return;
      }
     
      delay(100);


//      strip.setBrightness(mappedAvgBrightness);
//      strip2.setBrightness(mappedAvgBrightness);
      //currentBrightness = mappedAvgBrightness;
      
    }
  }
}

void completeBasev2() {

  int numOfWaves = 12;

  bool reachedMax[numOfWaves] = {false};
  bool reachedMin[numOfWaves] = {false};

  int centers[numOfWaves];
  
  int dirs[numOfWaves];
  int growthVals[numOfWaves];
  int maxGrowthVals[numOfWaves];
  int minGrowthVals[numOfWaves];

  for (int i = 0; i < numOfWaves; i++) {
    dirs[i] = 1;
    growthVals[i] = 0;
    maxGrowthVals[i] = 10;
    minGrowthVals[i] = 0;
    centers[i] = int(random(7,15)) + 20*i;
  }

  int numOfTwinkles = 24;

  int twinklingIndices[numOfTwinkles];

  halfRecordedTime = millis();
  

  for(;;) {

    float s1 = analogRead(sensor1Pin);
    float s2 = analogRead(sensor2Pin);
    float s3 = analogRead(sensor3Pin);
    float s4 = analogRead(sensor4Pin);

    float vals[] = {s1, s2, s3, s4};

    int waveIndices[240] = {-1};

    smoothVals(vals);
    scaleMax(vals);
    int mod = int(map(avgSensorVal(vals), 0, 1, 8, 1));
    int mappedBrightness = int(map(avgSensorVal(vals), 0, 1, 0, 255));

    if (fc % 2 == 0) {
      for (int i = 0; i < numOfTwinkles; i++) {
        twinklingIndices[i] = int(random(0, 240));  
      }
    }


    //Serial.println(avgSensorVal(vals));
    //trackSensors(vals);

    //mapping the data
    //map average sensor data to brightness and speed
    //speed is x in fc % x
    

    for (int i = 0; i < numOfWaves; i++) {
      if (reachedMax[i]) {
        dirs[i] = -dirs[i];
        switch(i%4) {
          case 0:
          minGrowthVals[i] = int(map(vals[0], sensorMin, sensor1Max, 6, 0));
          break;
          case 1:
          minGrowthVals[i] = int(map(vals[1], sensorMin, sensor2Max, 6, 0));
          break;
          case 2:
          minGrowthVals[i] = int(map(vals[2], sensorMin, sensor3Max, 6, 0));
          break;
          case 3:
          minGrowthVals[i] = int(map(vals[3], sensorMin, sensor4Max, 6, 0));
          break;  
        }
        reachedMax[i] = false;  
      }
      if (reachedMin[i]) {
        dirs[i] = -dirs[i];
        switch(i % 4) {
          case 0:
          maxGrowthVals[i] = int(map(vals[0], sensorMin, sensor1Max, 15, 7));
          break;
          case 1:
          maxGrowthVals[i] = int(map(vals[1], sensorMin, sensor2Max, 15, 7));
          break;
          case 2:
          maxGrowthVals[i] = int(map(vals[2], sensorMin, sensor3Max, 15, 7));
          break;
          case 3:
          maxGrowthVals[i] = int(map(vals[3], sensorMin, sensor4Max, 15, 7));
          break;  
        }
        reachedMin[i] = false;  
      }   
    }

    //strip.fill(compColors[4]);
    strip.fill(strip.Color(0,0,0, 255));
    strip2.fill(strip2.Color(0,0,0,255));
    for (int i = 0; i < strip.numPixels(); i++) {
      for(int j = 0; j < numOfWaves; j++) {
        if (i <= centers[j] + growthVals[j] && i >= centers[j] - growthVals[j]) {
          strip.setPixelColor(i, compColors[j%4]);
          strip2.setPixelColor(i, compColors[j%4]);  
        }
      }
    }

    if (twinkle) {
        for (int i = 0; i < strip.numPixels() * 2; i++) {
          if (arrayContains(twinklingIndices, numOfTwinkles, i)) {
            if (i < 240) {
              strip.setPixelColor(i, strip.Color(0,0,0,255));
            }
            else {
              strip2.setPixelColor(i - 240, strip.Color(0, 0, 0, 255));  
            }  
          }  
        }
        twinkleFrames++;
      }
      if(twinkleFrames > 60) {
        twinkle = false;  
      }

    fc++;

    for (int i = 0; i < numOfWaves; i++) {
      growthVals[i] += dirs[i];
      if (growthVals[i] == maxGrowthVals[i]) {
        reachedMax[i] = true;  
      }
      if (growthVals[i] == minGrowthVals[i]) {
        reachedMin[i] = true;  
      }
      if (fc % mod == 0) {
        if (centers[i] < strip.numPixels() - 1) {
          centers[i]++;  
        }
        else {
          centers[i] = 0;  
        }  
      }
    }

    if (!atHalf(vals) && millis() > halfRecordedTime + 20000) {
      canInterrupt = true;  
    }

    if (atHalf(vals) && canInterrupt) {
      halfRecordedTime = millis();
      canInterrupt = false;
      interrupt = true;  
    }

    

    if (completeToIncomplete || completeToWaiting || interrupt) return;
    //strip.setBrightness(mappedBrightness);
    strip.show();
    strip2.show();
    delay(200);
  }



  
  
}
