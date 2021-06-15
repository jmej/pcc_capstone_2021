#include <Adafruit_NeoPixel.h>

#define LED_PIN1 11
#define LED_PIN2 4
#define LED_COUNT1 240
#define LED_COUNT2 240

#define BRIGHTNESS 200

Adafruit_NeoPixel strip(LED_COUNT1, LED_PIN1, NEO_GRBW + NEO_KHZ800);
Adafruit_NeoPixel strip2(LED_COUNT2, LED_PIN2, NEO_GRBW + NEO_KHZ800);

int valCheck = 1000;


float fBrightness = 100;
float fWhite = 0;

int randBehaviorTime = random(10000, 20000);

int pot1Pin = 19;
int pot2Pin = 20;
int pot3Pin = 21;
int pot4Pin = 22;

int pot1Val, pot2Val, pot3Val, pot4Val;

int sensor1Pin = 15;
int sensor2Pin = 18;
int sensor3Pin = 16;
int sensor4Pin = 17;
int sensor1Max = 1023;
int sensor2Max = 1023;
int sensor3Max = 1023;
int sensor4Max = 1023;
int sensorMaxes[] = {sensor1Max, sensor2Max, sensor3Max, sensor4Max};
int sensorMin = 1500;
int sensor1Val, sensor2Val, sensor3Val, sensor4Val;
int s1scaled, s2scaled, s3scaled, s4scaled; 
long mm1, mm2, mm3, mm4;
int usedSensors = 0;
int whichSensors[] {-1, -1, -1, -1};

int fc = 0;

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
bool fade = false;

int counter = 0;

bool twinkle = false;
int twinkleFrames = 0;

int checkTime = 20000;

//uint32_t incompColor1 = strip.Color(201, 87, 194);
//uint32_t incompColor2 = strip.Color(85, 206, 191);
//uint32_t incompColor3 = strip.Color(245, 180, 50);
//uint32_t incompColor4 = strip.Color(120, 255, 30);
//uint32_t incompColor5 = strip.Color(227, 79, 30);

//uint32_t incompColor1 = strip.Color(234, 80, 66);
//uint32_t incompColor2 = strip.Color(232, 118, 47);
//uint32_t incompColor3 = strip.Color(255, 219, 50);
//uint32_t incompColor4 = strip.Color(255, 113, 215);
//uint32_t incompColor5 = strip.Color(255, 249, 211);

uint32_t incompColor1 = strip.Color(0, 55, 255);
uint32_t incompColor2 = strip.Color(37, 250, 80);
uint32_t incompColor3 = strip.Color(144, 52, 140);

uint32_t compColor1 = strip.Color(8, 157, 101);
uint32_t compColor2 = strip.Color(27, 173, 191);
uint32_t compColor3 = strip.Color(37, 88, 152);
uint32_t compColor4 = strip.Color(0, 69, 124);
uint32_t compColor5 = strip.Color(149, 216, 216);

//uint32_t incompColors[] = {incompColor1, incompColor4, incompColor5};
uint32_t incompColors[] = {incompColor1, incompColor2, incompColor3};
uint32_t compColors[] = {compColor1, compColor2, compColor3, compColor4, compColor5};


const int numReadings = 20;
int readings[4][numReadings];
int readIndex = 0;
int totals[4];
int averages[4];

bool reachedEnd = false;

bool didFire = false;
int halfRecordedTime = 15000;
// generate time to read sensors, maybe every second? start smaller?

bool canInterrupt = true;

int dVal = 1250;



//char command;

void setup() {

  Serial.begin(9600);

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

  float s1 = analogRead(sensor1Pin);
  float s2 = analogRead(sensor2Pin);
  float s3 = analogRead(sensor3Pin);
  float s4 = analogRead(sensor4Pin);

  float vals[] = {s1, s2, s3, s4};


  incomplete(3);
  //waiting();
  //Fire(20, 50, 15);
  //meteorRain(201, 87, 194, 4, 22, true, 8);
//  if (reachedEnd) {
//    reverseMeteorRain(201, 87, 194, 4, 22, true, 25);  
//  }
 
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

void trackSensors(float vals[]) {

  usedSensors = 0;

  for (int i = 0; i < 4; i++) {
    if (vals[i] < sensorMaxes[i]) {
      usedSensors++;
      whichSensors[i] = 1; 
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

float avgSensorVal(float vals[]) {

  float numOfSensors = 0;
  float sum = 0;

  for (int i = 0; i < 4; i++) {
    if (vals[i] < sensorMaxes[i]) {
      sum += vals[i];
      numOfSensors += 1.0;
    }  
  }

  return sum/numOfSensors;

}

int findMaxSensor(float vals[]) {

  int maxVal = 0;
  int maxIndex = 0;

  for (int i = 0; i < 4; i++) {
    if (vals[i] > maxVal) {
      maxIndex = i;  
    }
  }

  return maxIndex;

}

void smoothVals(float vals[]) {

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

bool atHalf(float vals[]) {

  int numAtHalf = 0;

  if (vals[0] < sensorMin + (sensor1Max - sensorMin)/2) {
    numAtHalf++;  
  }
  if (vals[1] < sensorMin + (sensor2Max - sensorMin)/2) {
    numAtHalf++;  
  }
  if (vals[2] < sensorMin + (sensor3Max - sensorMin)/2) {
    numAtHalf++;  
  }
  if (vals[3] < sensorMin + (sensor4Max - sensorMin)/2) {
    numAtHalf++;  
  }
  if(numAtHalf == 4) {
    return true;  
  }
  else {
    return false;  
  }

}

void scaleMax(float vals[]) {

  pot1Val = analogRead(pot1Pin);
  pot2Val = analogRead(pot2Pin);
  pot3Val = analogRead(pot3Pin);
  pot4Val = analogRead(pot4Pin);

  float potVals[] = {pot1Val, pot2Val, pot3Val, pot4Val};
  smoothVals(potVals);

  sensor1Max = potVals[0];
  sensor2Max = potVals[1];
  sensor3Max = potVals[2];
  sensor4Max = potVals[3];
  
}

void scaleVals(float vals[]) {

  for (int i = 0; i < 4; i++) {
    vals[i] = map(vals[i], 0, sensorMaxes[i], 0, 1);  
  }
  
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
void trackDummySensors() {

  dVal--;
  Serial.println(dVal);

  if (dVal <= 500) {
    incompleteToComplete = true;  
  }
  
}
