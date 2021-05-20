#include <Adafruit_NeoPixel.h>

#define LED_PIN 18
#define LED_COUNT 240

#define BRIGHTNESS 50

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  strip.begin();
  strip.show();
  strip.setBrightness(BRIGHTNESS);
}

void loop() {
  // put your main code here, to run repeatedly:
  incomplete(75, 20);
  
}

void incomplete(int stripSpeed, int stripLength) {
    if(stripLength >= strip.numPixels()) stripLength = strip.numPixels() -1;
    int loopNum = 0;
    int loops = 3;
    
    uint32_t firstPixelHue = 0;
    uint32_t lastTime = 0;
    
    int redTails[] = {0, 60, 120, 180};
    int redHeads[] = {19, 79, 139, 199};
    int blueTails[] = {20, 80, 140, 200};
    int blueHeads[] = {39, 99, 159, 219};
    int greenTails[] = {40, 100, 160, 220};
    int greenHeads[] = {59, 119, 179, 239};

    for(;;) {
      for(int i = 0; i < strip.numPixels(); i++) {
        for(int j = 0; j < 4; j++) {
          if(((i >= redTails[j]) && (i <= redHeads[j])) || ((redTails[j] > redHeads[j]) && ((i >= redTails[j]) || (i <= redHeads[j])))) {
            strip.setPixelColor(i, strip.Color(255, 0, 0));  
          }
          else if(((i >= blueTails[j]) && (i <= blueHeads[j])) || ((blueTails[j] > blueHeads[j]) && ((i >= blueTails[j]) || (i <= blueHeads[j])))) {
            strip.setPixelColor(i, strip.Color(0, 0, 255));  
          }
          else if(((i >= greenTails[j]) && (i <= greenHeads[j])) || ((greenTails[j] > greenHeads[j]) && ((i >= greenTails[j]) || (i <= greenHeads[j])))) {
            strip.setPixelColor(i, strip.Color(0, 255, 0));  
          }  
        }  
      }

      strip.show();

      if((millis() - lastTime) > stripSpeed) {
        for (int i = 0; i < 4; i++) {
          if(++redHeads[i] >= strip.numPixels()) {
            redHeads[i] = 0;
            //if(++loopNum >= loops) return;  
          }
          if(++blueHeads[i] >= strip.numPixels()) {
            blueHeads[i] = 0;  
            //if(++loopNum >= loops) return;
          }
          if(++greenHeads[i] >= strip.numPixels()) {
            greenHeads[i] = 0;
            //if(++loopNum >= loops) return;  
          }
        }
        lastTime = millis();   
      }
       
      
  }
}
