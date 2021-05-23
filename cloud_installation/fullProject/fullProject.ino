#include <Adafruit_NeoPixel.h>
#include <OSCMessage.h>
#include <WiFi.h>
#include <WiFiUdp.h>

#define LED_PIN 18
#define LED_COUNT 240

#define BRIGHTNESS 100

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

int randBehaviorTime = random(10000, 20000);

int sensor1Pin = 15;
int sensor2Pin = 14;
int sensor3Pin = 16;
int sensor4Pin = 17;
int sensorMax = 45000;
int sensorMin = 1500;
int s1scaled, s2scaled, s3scaled, s4scaled; 
long mm1, mm2, mm3, mm4;

int sensorAvg = 0;

int previous = 0;
bool shrinkingIncomplete = false;
bool growingIncomplete = false;
bool incompleteToComplete = false;
bool completeToIncomplete = false;
bool waitingToIncomplete = false;
bool incompleteToWaiting = false;
bool completeToWaiting = false;
bool waitingToComplete = false;


void setup() {
  // put your setup code here, to run once:
//  strip.begin();
//  strip.show();
//  strip.setBrightness(50);
  Serial.begin(9600);
  pinMode(sensor1Pin, INPUT);
  pinMode(sensor2Pin, INPUT);
  pinMode(sensor3Pin, INPUT);
  pinMode(sensor4Pin, INPUT);

  strip.begin();
  strip.show();

}

void read_sensors() {
  mm1 = pulseIn(sensor1Pin, HIGH);
  mm2 = pulseIn(sensor2Pin, HIGH);
  mm3 = pulseIn(sensor3Pin, HIGH);
  mm4 = pulseIn(sensor4Pin, HIGH);
}

void print_range() {
  Serial.print("S1: ");
  Serial.print(mm1);
  Serial.print(" || S2: ");
  Serial.print(mm2);
  Serial.print(" || S3: ");
  Serial.println(mm3);
}


void loop() {
  
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
      waitingToCopmlete = true;  
    }   
  }

  waiting(usedSensors);

  previous = usedSensors;

}
  
void waiting(int num) {
  
  for(;;) {
    if (num != 0) return;
    whiteOverRainbow(75,5);
    pulseWhite(5);
    rainbowFade2White(3, 3, 1);
    
  }
}
