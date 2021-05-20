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
    int tail1 = 0;
    int tail2 = 70;
    int tail3 = 160;
    int head1 = stripLength - 1;
    int head2 = stripLength - 1 + 70;
    int head3 = stripLength - 1 + 160;
    int loops = 3;
    int loop1Num = 0;
    int loop2Num = 0;
    int loop3Num = 0;
    uint32_t lastTime1 = millis();
    uint32_t lastTime2 = millis();
    uint32_t lastTime3 = millis();
    uint32_t firstPixelHue = 0;

    for(;;) {
      for(int i = 0; i < strip.numPixels(); i++) {
        if(((i >= tail1) && (i <= head1)) || ((tail1 > head1) && ((i >= tail1) || (i <= head1)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else if(((i >= tail2) && (i <= head2)) || ((tail2 > head2) && ((i >= tail2) || (i <= head2)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else if(((i >= tail3) && (i <= head3)) || ((tail3 > head3) && ((i >= tail3) || (i <= head3)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else {
          strip.setPixelColor(i, strip.Color(0,0,0,0));  
        }  
      }

      strip.show();

      if((millis() - lastTime1) > stripSpeed) { // Time to update head/tail?
      if(++head1 >= strip.numPixels()) {      // Advance head, wrap around
        head1 = 0;
        if(++loop1Num >= loops) return;
      }
      if(++tail1 >= strip.numPixels()) {      // Advance tail, wrap around
        tail1 = 0;
      }
      lastTime1 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime2) > stripSpeed) { // Time to update head/tail?
      if(++head2 >= strip.numPixels()) {      // Advance head, wrap around
        head2 = 0;
        if(++loop2Num >= loops) return;
      }
      if(++tail2 >= strip.numPixels()) {      // Advance tail, wrap around
        tail2 = 0;
      }
      lastTime2 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime3) > stripSpeed) { // Time to update head/tail?
      if(++head3 >= strip.numPixels()) {      // Advance head, wrap around
        head3 = 0;
        if(++loop3Num >= loops) return;
      }
      if(++tail3 >= strip.numPixels()) {      // Advance tail, wrap around
        tail3 = 0;
      }
      lastTime3 = millis();                   // Save time of last movement
    }
  }
}
