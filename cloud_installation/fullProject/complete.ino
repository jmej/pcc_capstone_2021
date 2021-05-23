void completeInterrupt() {

  
  
}

void completeBase() {


  // for now, generate random location and random max length
  // need variables for center location, max length, current length
  // need to store color of appearing strip and colors on either side

  for(;;){

    read_sensors();

    int usedSensors = 0;
    int sensorTotal = 0;
//
    sensor1Val = pulseIn(sensor1Pin, HIGH);
    sensor2Val = pulseIn(sensor2Pin, HIGH);
    sensor3Val = pulseIn(sensor3Pin, HIGH);
    sensor4Val = pulseIn(sensor4Pin, HIGH);

    int sensorVals[] = {sensor1Val, sensor2Val, sensor3Val, sensor4Val};

    for (int i = 0; i < 4; i++) {
      if (sensorVals[i] < sensorMax) {
        usedSensors++;
        sensorTotal+=sensorVals[i]; 
      }
    }

    sensorAvg = sensorTotal / usedSensors;
  

    if (usedSensors != previous) {
      if (usedSensors < 4 && usedSensors > previous) {
        growingIncomplete = true;  
      }
      else if (usedSensors < 4 && usedSensors < previous) {
        shrinkingIncomplete = true;  
      }
      else if (usedSensors == 4) {
        incompleteToComplete = true;  
      }
      else if (usedSensors < 4 && previous == 4) {
        completeToIncomplete = true;  
      }
      else if (1 <= usedSensors && usedSensors < 4 && previous == 0) {
        waitingToIncomplete = true;  
      }
      else if (usedSensors == 0 && previous > 0 && previous < 4) {
        incompleteToWaiting = true;
      }
      else if (usedSensors == 0 && previous == 4) {
        completeToWaiting = true;  
      }
      else if (usedSensors == 4 && previous == 0) {
        waitingToComplete = true;  
      }   
    }

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

  previous = usedSensors;

  }

}

void complete(int num) {
  for(;;) {
    completeBase();
    if (completeToIncomplete) {
      completeToIncomplete = false;
      incomplete();  
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
