#include <Adafruit_NeoPixel.h>

#define LED_PIN 18
#define LED_COUNT 240

#define BRIGHTNESS 100

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

int randBehaviorTime = random(10000, 20000);
int lastTime = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  
  strip.begin();
  strip.show();
  strip.setBrightness(BRIGHTNESS);
}

void loop() {
  // put your main code here, to run repeatedly:
    incompleteAmbience(75, 3);
    pulseWhite(5);
  
}

void incompleteAmbience(int stripDelay, int num) {  // num will be numOfSensors, 1 thru 3 

    int loopNum = 0;
    
    int stripLength = 0;
    

    switch (num) {
      case 1:
      stripLength = 40;
      break;
      case 2:
      stripLength = 30;
      break;
      case 3:
      stripLength = 24;
      break;  
    }

    int tails[strip.numPixels()/stripLength];
    int heads[strip.numPixels()/stripLength];

    for (int i = 0; i < strip.numPixels()/stripLength; i++) {
      tails[i] = i * stripLength;
      heads[i] = stripLength - 1 + i * stripLength;  
    }

    for(;;) {
      for (int i = 0; i < strip.numPixels(); i++) {
        for (int j = 0; j < strip.numPixels()/stripLength; j++) {
          if (((i >= tails[j]) && (i <= heads[j])) || ((tails[j] > heads[j]) && ((i >= tails[j]) || (i <= heads[j])))) {
            switch (num) {
              case 1:
              switch(j % 3) {
                case 0:
                strip.setPixelColor(i, strip.Color(201, 87, 194));
                break;
                case 1:
                strip.setPixelColor(i, strip.Color(85, 206, 191));
                break;
                case 2:
                strip.setPixelColor(i, strip.Color(245, 180, 50));
                break;  
              }
              break;
              case 2:
              switch(j % 4) {
                case 0:
                strip.setPixelColor(i, strip.Color(201, 87, 194));
                break;
                case 1:
                strip.setPixelColor(i, strip.Color(85, 206, 191));
                break;
                case 2:
                strip.setPixelColor(i, strip.Color(245, 180, 50));
                break;
                case 3:
                strip.setPixelColor(i, strip.Color(255, 255, 0));
                break;  
              }
              break;
              case 3:
              switch(j % 5) {
                case 0:
                strip.setPixelColor(i, strip.Color(201, 87, 194));
                break;
                case 1:
                strip.setPixelColor(i, strip.Color(85, 206, 191));
                break;
                case 2:
                strip.setPixelColor(i, strip.Color(245, 180, 50));
                break;
                case 3:
                strip.setPixelColor(i, strip.Color(255, 255, 0));
                break;
                case 4:
                strip.setPixelColor(i, strip.Color(97, 165, 38));
                break;
              }
              break;      
            }   
          }  
        }
      }

    strip.show();
      
    for (int i = 0; i < strip.numPixels()/stripLength; i++) {
      tails[i]++;
      heads[i]++;
      if (heads[i] >= strip.numPixels()) {
        heads[i] = 0;
        if (i == 0) {
          loopNum++;
        }  
      }
      if (tails[i] >= strip.numPixels()) {
        tails[i] = 0;  
      }  
    }

    delay(stripDelay);
    
    if (millis() > randBehaviorTime) {
      randBehaviorTime = millis() + random(10000, 20000);
      return;
    }

  }

}

void pulseWhite(uint8_t wait) {
  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }
}
