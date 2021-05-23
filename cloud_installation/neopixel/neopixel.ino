#include <Adafruit_NeoPixel.h>

#define LED_PIN 18
#define LED_COUNT 240

#define BRIGHTNESS 100

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

uint32_t incompColor1 = strip.Color(201, 87, 194);
uint32_t incompColor2 = strip.Color(85, 206, 191);
uint32_t incompColor3 = strip.Color(245, 180, 50);
uint32_t incompColor4 = strip.Color(120, 255, 30);
uint32_t incompColor5 = strip.Color(227, 79, 30);

int randBehaviorTime = random(20000, 30000);
int randTrigTime = random(10000, 20000);
bool trig = false;
bool interrupt = false;
int d = 1;
int avgChange = -100;
int dummyAvg = 44999;
//int switchDirTime = random(60000, 80000);

int numOfSensors = 1;

int growth = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  
  strip.begin();
  strip.show();
  strip.setBrightness(BRIGHTNESS);
}

void loop() {
  // put your main code here, to run repeatedly:
  
//  int mappedAvgBrightness = map(dummyAvg, 1500, 45000, 255, 0);
//  Serial.println(dummyAvg);
  
  //incompleteBase(numOfSensors);
    //incompleteInterrupt(5);
//  pulseWhite(5);

  incomplete(numOfSensors);

  //colorWipe(incompColor1, 5);

  //meteorRain(255,255,255,10, 64, true, 5);
    
//  int mappedAvgSpeed = map(dummyAvg, 1500, 45000, 25, 150);

//    incomplete(mappedAvgSpeed, numOfSensors);
//    pulseWhite(5);

      //completeBase();
//  for (int i = 0; i < strip.numPixels(); i++) {
//    strip.setPixelColor(i, strip.Color(255, 0, 0));  
//  }



    
        
}

void waiting(int num) {
  
  for(;;) {
    // if (sensor detects person) break;
    whiteOverRainbow(75,5);
    pulseWhite(5);
    rainbowFade2White(3, 3, 1);
    
  }
}
