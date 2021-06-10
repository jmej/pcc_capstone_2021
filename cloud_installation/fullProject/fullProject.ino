#include <Adafruit_NeoPixel.h>

#define LED_PIN1 11
#define LED_PIN2 4
#define LED_COUNT1 240
#define LED_COUNT2 240

#define BRIGHTNESS 200

Adafruit_NeoPixel strip(LED_COUNT1, LED_PIN1, NEO_GRBW + NEO_KHZ800);
Adafruit_NeoPixel strip2(LED_COUNT2, LED_PIN2, NEO_GRBW + NEO_KHZ800);

bool didIt = false;

int valCheck = 1000;

int frameCount = 0;

float fBrightness = 100;
float fWhite = 0;

int randBehaviorTime = random(10000, 20000);

int pot1Pin = 18;
int pot2Pin = 19;
int pot3Pin = 20;
int pot4Pin = 21;

int pot1Val, pot2Val, pot3Val, pot4Val;

int sensor1Pin = 15;
int sensor2Pin = 14;
int sensor3Pin = 16;
int sensor4Pin = 17;
int sensor1Max = 45000;
int sensor2Max = 45000;
int sensor3Max = 45000;
int sensor4Max = 45000;
int sensorMax = 45000;
int sensorMin = 1500;
int sensor1Val, sensor2Val, sensor3Val, sensor4Val;
int s1scaled, s2scaled, s3scaled, s4scaled; 
long mm1, mm2, mm3, mm4;
int usedSensors = 0;

int currentBrightness;

bool trig = false;
bool interrupt = false;
int d = 1;
int avgChange = -100;
int dummyAvg = 44999;

int previous = 0;
bool shrinkingIncomplete = false;
bool growingIncomplete = false;
bool incompleteToComplete = false;
bool completeToIncomplete = false;
bool waitingToIncomplete = false;
bool incompleteToWaiting = false;
bool completeToWaiting = false;
bool waitingToComplete = false;

int checkTime = 20000;

uint32_t incompColor1 = strip.Color(201, 87, 194);
uint32_t incompColor2 = strip.Color(85, 206, 191);
uint32_t incompColor3 = strip.Color(245, 180, 50);
uint32_t incompColor4 = strip.Color(120, 255, 30);
uint32_t incompColor5 = strip.Color(227, 79, 30);

uint32_t compColor1 = strip.Color(8, 157, 101);
uint32_t compColor2 = strip.Color(27, 173, 191);
uint32_t compColor3 = strip.Color(37, 88, 152);
uint32_t compColor4 = strip.Color(149, 216, 216);

uint32_t incompColors[] = {incompColor1, incompColor4, incompColor5};
uint32_t compColors[] = {compColor1, compColor2, compColor3, compColor4};


const int numReadings = 20;
int readings[4][numReadings];
int readIndex = 0;
int totals[4];
int averages[4];

bool reachedEnd = false;


// generate time to read sensors, maybe every second? start smaller?



//char command;

void setup() {

  pinMode(pot1Pin, INPUT);
  pinMode(pot2Pin, INPUT);
  pinMode(pot3Pin, INPUT);
  pinMode(pot4Pin, INPUT);

  pinMode(sensor1Pin, INPUT);
  pinMode(sensor2Pin, INPUT);
  pinMode(sensor3Pin, INPUT);
  pinMode(sensor4Pin, INPUT);

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < numReadings; j++) {
      readings[i][j] = 0;  
    }  
  }

  strip.begin();
  strip.show();
  strip2.begin();
  strip2.show();
  strip.setBrightness(BRIGHTNESS);
  strip2.setBrightness(BRIGHTNESS);

}

void loop() {


  //incomplete(1);
  //Fire(20, 50, 15);
//  meteorRain(201, 87, 194, 4, 22, true, 25);
//  if (reachedEnd) {
//    reverseMeteorRain(201, 87, 194, 4, 22, true, 25);  
//  }
  
  //strip.fill(0, strip.Color(255, 0, 0, 0));

  complete();

  //colorWipe(incompColor1, 5);
  //Fire(20, 50, 15);
 
}


  
void waiting() {
  
  for(;;) {

    //trackSensors();

    strip.setBrightness(BRIGHTNESS);
    currentBrightness = BRIGHTNESS;
    
    whiteOverRainbow(40,5);
    pulseWhite(5);
    rainbowFade2White(3, 3, 1);
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
}

void readSensors() {
  mm1 = analogRead(sensor1Pin);
  mm2 = analogRead(sensor2Pin);
  mm3 = analogRead(sensor3Pin);
  mm4 = analogRead(sensor4Pin);
}

void printRange() {
  Serial.print("S1: ");
  Serial.print(mm1);
  Serial.print(" || S2: ");
  Serial.print(mm2);
  Serial.print(" || S3: ");
  Serial.println(mm3);
}

void trackSensors(int vals[]) {

  usedSensors = 0;

  for (int i = 0; i < 4; i++) {
    if (vals[i] < sensorMax) {
      usedSensors++; 
    }
  }

  if (usedSensors != previous) {
    if (usedSensors < 4 && usedSensors > previous) {
      growingIncomplete = true;
      Serial.print("growing Incomplete");  
    }
    else if (usedSensors < 4 && usedSensors < previous) {
      shrinkingIncomplete = true;
      Serial.print("shrinking incomplete");  
    }
    else if (usedSensors == 4) {
      incompleteToComplete = true;
      Serial.print("i to c");  
    }
    else if (usedSensors < 4 && previous == 4) {
      completeToIncomplete = true;
      Serial.print("c to i");  
    }
    else if (1 <= usedSensors && usedSensors < 4 && previous == 0) {
      waitingToIncomplete = true;
      Serial.print("w to i");  
    }
    else if (usedSensors == 0 && previous > 0 && previous < 4) {
      incompleteToWaiting = true;
      Serial.print("i to w");
    }
    else if (usedSensors == 0 && previous == 4) {
      completeToWaiting = true;
      Serial.print("c to i");  
    }
    else if (usedSensors == 4 && previous == 0) {
      waitingToComplete = true;
      Serial.print("w to c");  
    }   
  }

  previous = usedSensors;


}


int avgSensorVal(int vals[]) {

  int sum = 0;

  for (int i = 0; i < 4; i++) {
    sum += vals[i];
  }

  return sum / 4;
}

int findMaxSensor(int vals[]) {

  int maxVal = 0;
  int maxIndex = 0;

  for (int i = 0; i < 4; i++) {
    if (vals[i] > maxVal) {
      maxIndex = i;  
    }
  }

  return maxIndex;

}

void smoothVals(int vals[]) {

  for (int i = 0; i < 4; i++) {
    totals[i] = totals[i] - readings[i][readIndex];
    readings[i][readIndex] = analogRead(i+14); 
    totals[i] = totals[i] + readings[i][readIndex];  
  }

  readIndex++;

  if (readIndex >= numReadings) {
    readIndex = 0;  
  }

  for (int i = 0; i < 4; i++) {
    averages[i] = totals[i] / numReadings;  
  }

  for (int i = 0; i < 4; i++) {
    vals[i] = averages[i];  
  }

  

}

void scaleMax(int vals[]) {

  pot1Val = analogRead(pot1Pin);
  pot2Val = analogRead(pot2Pin);
  pot3Val = analogRead(pot3Pin);
  pot4Val = analogRead(pot4Pin);

  sensor1Max = map(vals[0], 0, 1023, 2000, 45000);
  sensor2Max = map(vals[1], 0, 1023, 2000, 45000);
  sensor3Max = map(vals[2], 0, 1023, 2000, 45000);
  sensor4Max = map(vals[3], 0, 1023, 2000, 45000);
  
}

// the data mapping logic needs to change based on how the max changes
// instead of it just being max to min, it's about the percentage or something of the distance
// 

//void sendSensorData() {
//
//  readSensors();
//
//  s1Scaled = map(mm1, sensorMin, sensorMax, 0, 100);
//  s2Scaled = map(mm2, sensorMin, sensorMax, 0, 100);
//  s3Scaled = map(mm3, sensorMin, sensorMax, 0, 100);
//  s4Scaled = map(mm4, sensorMin, sensorMax, 0, 100);
//
//  usbMIDI.sendControlChange(1, s1Scaled, 1);
//  usbMIDI.sendControlChange(2, s2Scaled, 1);
//  usbMIDI.sendControlChange(3, s3Scaled, 1);
//  usbMIDI.sendControlChange(4, s4Scaled, 1);
//  
//}
