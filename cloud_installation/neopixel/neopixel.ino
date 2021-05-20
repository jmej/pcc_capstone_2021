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
  incompleteAmbience(75, 20);
  
}

void incompleteAmbience(int stripDelay, int stripLength) {
    if(stripLength >= strip.numPixels()) stripLength = strip.numPixels() -1;
    
    uint32_t lastTime = 0;

    int tails[] = {0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220};
    int heads[] = {19, 39, 59, 79, 99, 119, 139, 159, 179, 199, 219, 239};

    for(;;) {
      for (int i = 0; i < strip.numPixels(); i++) {
        for (int j = 0; j < 12; j++) {
          if (((i >= tails[j]) && (i <= heads[j])) || ((tails[j] > heads[j]) && ((i >= tails[j]) || (i <= heads[j])))) {
            if (j == 0 || j == 3 || j == 6 || j == 9) {
              strip.setPixelColor(i, strip.Color(201, 87, 194));  
            }
            else if (j == 1 || j == 4 || j == 7 || j == 10) {
              strip.setPixelColor(i, strip.Color(85, 206, 191));  
            }
            else if (j == 2 || j == 5 || j == 8 || j == 11) {
              strip.setPixelColor(i, strip.Color(245, 180, 50));  
            }  
          }  
        }  
      }

      strip.show();
      
      for (int i = 0; i < 12; i++) {
        tails[i]++;
        heads[i]++;
        if (heads[i] >= strip.numPixels()) {
          heads[i] = 0;  
        }
        if (tails[i] >= strip.numPixels()) {
          tails[i] = 0;  
        }  
      }

      delay(stripDelay);
      
    }   
      
}
