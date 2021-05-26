void complete() {
  for(;;) {
    completeBase();
    if (completeToIncomplete) {
      completeToIncomplete = false;
      fromCtoI();
      incomplete(usedSensors);  
    }
    if (completeToWaiting) {
      completeToWaiting = false;
      fromCtoW();
      waiting();  
    }
    if (interrupt) {
      completeInterrupt();
      interrupt = false;
    }  
  }
}



void completeInterrupt() {

  if (fWhite < 255) {
    Fire(20, 50, 15);
  }
  // play around with values
  
  
}

void completeBase() {


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

//      int s1 = pulseIn(sensor1Pin, HIGH);
//      int s2 = pulseIn(sensor2Pin, HIGH);
//      int s3 = pulseIn(sensor3Pin, HIGH);
//      int s4 = pulseIn(sensor4Pin, HIGH);
//
//      int vals[] = {s1, s2, s3, s4};

      int vals[] = {0, 0, 0, 0};

      smoothVals(vals);

      for (int i = 0; i < 4; i++) {
        Serial.print(vals[i]);
        Serial.print(", ");  
      }
      Serial.println();

      //trackSensors(vals);
      if (completeToIncomplete || completeToWaiting || interrupt) return;

//      
      int mappedAvgBrightness = map(avgSensorVal(vals), sensorMin, sensorMax, 200, 0);
      int mappedAvgIndices = int(map(avgSensorVal(vals), sensorMin, sensorMax, 120, 10)); 
      int numDone = 0;

      int color1MaxLength = map(vals[0], sensorMin, sensorMax, 16, 1);
      int color2MaxLength = map(vals[1], sensorMin, sensorMax, 16, 1);
      int color3MaxLength = map(vals[2], sensorMin, sensorMax, 16, 1);
      int color4MaxLength = map(vals[3], sensorMin, sensorMax, 16, 1);

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
      for (int i = 0; i < strip.numPixels() * 2; i++) {
        if (arrayContains(twinklingIndices, mappedAvgIndices, i)) {
          if (i < 240) {
            strip.setPixelColor(i, strip.Color(0,0,0,255));
          }
          else {
            strip2.setPixelColor(i - 240, strip.Color(0, 0, 0, 255));  
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

      if (numDone == 4) {
        return;
      }

      if(millis() > checkTime || !didIt) {
        didIt = true;
        interrupt = true;
        return;
      }
     
      //delay(100);


//      strip.setBrightness(mappedAvgBrightness);
//      strip2.setBrightness(mappedAvgBrightness);
      //currentBrightness = mappedAvgBrightness;

      strip.show();
      strip2.show();
      
    }
  }
}
