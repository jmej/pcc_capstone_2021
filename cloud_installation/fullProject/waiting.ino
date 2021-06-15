void waiting() {

  waitingBase();
  if (waitingToComplete) {
    waitingToComplete = false;
    complete();  
  }
  if (waitingToIncomplete) {
    waitingToIncomplete = false;
    incomplete(usedSensors);  
  }
  
}

void waitingBase() {
  
  for(;;) {

    if (waitingToComplete || waitingToIncomplete) return;
    //trackSensors();
    incWaiting();
    if (waitingToComplete || waitingToIncomplete) return;
    breakableColorWipe(strip.Color(0, 0, 0, 255));
    cWaiting();
      
  }

    strip.setBrightness(BRIGHTNESS);
    currentBrightness = BRIGHTNESS;
    
    if (waitingToIncomplete) {
      waitingToIncomplete = false;
      //fromWtoI();
      incomplete(usedSensors);  
    }
    if (waitingToComplete) {
      waitingToComplete = false;
      //fromCtoI();
      complete();  
    }
  }

void incWaiting() {

  counter = 0;
  int stripLength = 30;

  int tails[8];
  int heads[8];

  for (int i = 0; i < 8; i++) {
    tails[i] = i * stripLength;
    heads[i] = stripLength - 1 + i * stripLength;  
  }

  for(;;) {

    float s1 = analogRead(sensor1Pin);
    float s2 = analogRead(sensor2Pin);
    float s3 = analogRead(sensor3Pin);
    float s4 = analogRead(sensor4Pin);
    float vals[] = {s1, s2, s3, s4};

    smoothVals(vals);

    //trackSensors(vals);

    if(waitingToIncomplete || waitingToComplete) return;

      
    for (int i = 0; i < strip.numPixels() * 2; i++) {
      for (int j = 0; j < 4; j++) {
        if (((i >= tails[j]) && (i <= heads[j])) || ((tails[j] > heads[j]) && ((i >= tails[j]) || (i <= heads[j])))) {
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

    counter++;
    Serial.println(counter);

    delay(100);

    if (counter > 240) {
      fade = true;
      return;  
    }
  }

  if (waitingToComplete || waitingToIncomplete) {
    return;  
  }
  
//  for (int i = 0; i < 40; i++) {
//    for (int j = 0; j < strip.numPixels(); j++) {
//      fadeToWhite(i, 25);  
//    }
//    delay(100);
//  }
//  colorWipe(strip.Color(0, 0, 0, 255));
//
//  for(;;) {
//    float s1 = analogRead(sensor1Pin);
//    float s2 = analogRead(sensor2Pin);
//    float s3 = analogRead(sensor3Pin);
//    float s4 = analogRead(sensor4Pin);
//    float vals[] = {s1, s2, s3, s4};
//
//    smoothVals(vals);
//
//    //trackSensors(vals);
//    
//    if (waitingToComplete || waitingToIncomplete) return;
//    //modified version of complete behavior here  
//  }
//  
//  if (waitingToComplete || waitingToIncomplete) return;

  //some simple transition from complete back to incomplete here
  
  
}

void cWaiting() {

  Serial.println("complete stuff");

  fc = 0;

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
    centers[i] = 10 + 20*i;
  }

  for(;;) {

    float s1 = analogRead(sensor1Pin);
    float s2 = analogRead(sensor2Pin);
    float s3 = analogRead(sensor3Pin);
    float s4 = analogRead(sensor4Pin);

    float vals[] = {s1, s2, s3, s4};

    smoothVals(vals);
    //trackSensors(vals);

    if(waitingToComplete || waitingToIncomplete) return;
    
    for (int i = 0; i < numOfWaves; i++) {
      if (reachedMax[i]) {
        dirs[i] = -dirs[i];
        minGrowthVals[i] = int(random(3, 5));
//        switch(i%4) {
//          case 0:
//          minGrowthVals[i] = int(map(vals[0], sensorMin, sensor1Max, 6, 0));
//          break;
//          case 1:
//          minGrowthVals[i] = int(map(vals[1], sensorMin, sensor2Max, 6, 0));
//          break;
//          case 2:
//          minGrowthVals[i] = int(map(vals[2], sensorMin, sensor3Max, 6, 0));
//          break;
//          case 3:
//          minGrowthVals[i] = int(map(vals[3], sensorMin, sensor4Max, 6, 0));
//          break;  
//        }
        reachedMax[i] = false;  
      }
      if (reachedMin[i]) {
        dirs[i] = -dirs[i];
        maxGrowthVals[i] = int(random(8, 14));
//        switch(i % 4) {
//          case 0:
//          maxGrowthVals[i] = int(map(vals[0], sensorMin, sensor1Max, 15, 7));
//          break;
//          case 1:
//          maxGrowthVals[i] = int(map(vals[1], sensorMin, sensor2Max, 15, 7));
//          break;
//          case 2:
//          maxGrowthVals[i] = int(map(vals[2], sensorMin, sensor3Max, 15, 7));
//          break;
//          case 3:
//          maxGrowthVals[i] = int(map(vals[3], sensorMin, sensor4Max, 15, 7));
//          break;  
//        }
        reachedMin[i] = false;  
      }   
    }
    
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

    fc++;

    for (int i = 0; i < numOfWaves; i++) {
      growthVals[i] += dirs[i];
      if (growthVals[i] == maxGrowthVals[i]) {
        reachedMax[i] = true;
        Serial.println("reached max");  
      }
      if (growthVals[i] == minGrowthVals[i]) {
        reachedMin[i] = true; 
        Serial.println("reached min"); 
      }
      if (fc % 4 == 0) {
        if (centers[i] < strip.numPixels() - 1) {
          centers[i]++;  
        }
        else {
          centers[i] = 0;  
        }  
      }
    }

    if (fc > 240) return;

    strip.show();
    delay(160);
        
  }

}
