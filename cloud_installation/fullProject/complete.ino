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

  for(;;) {
    Fire(20, 50, 15);
    if (fWhite >= 255) return;
  }
  for (int i = 0; i < strip.numPixels()*2; i++) {
    doubleFade(i, 22);
  }
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

      int s1 = analogRead(sensor1Pin);
      int s2 = analogRead(sensor2Pin);
      int s3 = analogRead(sensor3Pin);
      int s4 = analogRead(sensor4Pin);

      int vals[] = {s1, s2, s3, s4};
//
      smoothVals(vals);
      scaleMax(vals);

      //trackSensors(vals);
      if (completeToIncomplete || completeToWaiting || interrupt) return;

//      
      int mappedAvgBrightness = map(avgSensorVal(vals), sensorMin, sensorMax, 200, 0);
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

  int d1 = 1;
  int d2 = 1;
  int d3 = 1;
  int d4 = 1;

  bool wave1ReachedMax = false;
  bool wave2ReachedMax = false;
  bool wave3ReachedMax = false;
  bool wave4ReachedMax = false;

  bool wave1ReachedMin = false;
  bool wave2ReachedMin = false;
  bool wave3ReachedMin = false;
  bool wave4ReachedMin = false;

  int centers[] = {20, 60, 100, 140, 180, 220};
  int growthVals[] = {0, 0, 0, 0, 0, 0};
  int maxGrowthVals[] = {19, 19, 19, 19, 19, 19};
  int minGrowthVals[] = {0, 0, 0, 0, 0, 0};
  

  for(;;) {

    int s1 = analogRead(sensor1Pin);
    int s2 = analogRead(sensor2Pin);
    int s3 = analogRead(sensor3Pin);
    int s4 = analogRead(sensor4Pin);

    int vals[] = {s1, s2, s3, s4};

    smoothVals(vals);
    scaleMax(vals);
    //trackSensors(vals);

    if (wave1ReachedMax || wave1ReachedMin) {
      d1 = -d1;
      if (wave1ReachedMax) {
        wave1ReachedMax = false;
      }
      else if (wave1ReachedMin) {
        wave1ReachedMin = false;  
      }
    }
    if (wave2ReachedMax || wave2ReachedMin) {
      d2 = -d2;
      if(wave2ReachedMax) {
        wave2ReachedMax = false;
      }
      else if (wave2ReachedMin) {
        wave2ReachedMin = false;
      }
    }
    if (wave3ReachedMax || wave3ReachedMin) {
      d3 = -d3;
      if (wave3ReachedMax) {
        wave3ReachedMax = false;
      }
      else if (wave3ReachedMin) {
        wave3ReachedMin = false;  
      }  
    }
//    if (wave4ReachedMax || wave4ReachedMin) {
//      d4 = -d4;
//      if (wave4ReachedMax) {
//        wave4ReachedMax = false;
//      }
//      else if (wave4ReachedMin) {
//        wave4ReachedMin = false;  
//      }  
//    }

    for (int i = 0; i < strip.numPixels(); i++) {
      for(int j = 0; j < 6; j++) {
        if (i <= centers[j] + growthVals[j] && i >= centers[j] - growthVals[j]) {
          strip.setPixelColor(i, compColors[j%3]);  
        }   
      }
    }

    growthVals[0] += d1;
    growthVals[1] += d2;
    growthVals[2] += d3;
    growthVals[3] += d1;
    growthVals[4] += d2;
    growthVals[5] += d3;
//    growthVals[3] += d4;

    if (growthVals[0] == 19) {
      wave1ReachedMax = true;  
    }
    if (growthVals[1] == 19) {
      wave2ReachedMax = true;  
    }
    if (growthVals[2] == 19) {
      wave3ReachedMax = true;  
    }
//    if (growthVals[3] == 19) {
//      wave4ReachedMax = true;  
//    }
    if (growthVals[0] == 0) {
      wave1ReachedMin = true;  
    }
    if (growthVals[1] == 0) {
      wave2ReachedMin = true;  
    }
    if (growthVals[2] == 0) {
      wave3ReachedMin = true;  
    }
    strip.show();
    delay(200);
  }
  
  
}
