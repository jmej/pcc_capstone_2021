#include <Adafruit_NeoPixel.h>

#define LED_PIN 18
#define LED_COUNT 240

#define BRIGHTNESS 100

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

int randBehaviorTime = random(10000, 20000);
int switchDirTime = random(60000, 80000);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  
  strip.begin();
  strip.show();
  strip.setBrightness(BRIGHTNESS);
}

void loop() {
  // put your main code here, to run repeatedly:
    incomplete(75, 1);
    pulseWhite(5);
  
}

void waiting() {
  
  for(;;) {
    // if (sensor detects person) break;
    whiteOverRainbow(75,5);
    pulseWhite(5);
    rainbowFade2White(3, 3, 1);
    
  }
}



void incomplete(int stripDelay, int num) {  // num will be numOfSensors, 1 thru 3 

    int stripLength = 0;

    int d = 1;
    

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
      if (num == 4) {
        break;  
      }
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

    if (millis() > switchDirTime) {
      switchDirTime = millis() + random(60000, 80000);
      d = -d;
    }
      
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

    delay(stripDelay);
    
    if (millis() > randBehaviorTime) {
      randBehaviorTime = millis() + random(10000, 20000);
      return;
    }

  }

}

void incompleteInterrupt() {
  
  
}

void complete() {
    for(;;) {
      // if (person leaves) break;

    
      
    }
}

void completeInterrupt() {
  
  
}



void colorWipe(uint32_t color, int wait) {
  for(int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, color);
    strip.show();
    delay(wait);  
  }  
}



void whiteOverRainbow(int whiteSpeed, int whiteLength) {

  if(whiteLength >= strip.numPixels()) whiteLength = strip.numPixels() - 1;

  int      head          = whiteLength - 1;
  int      tail          = 0;
  int      loops         = 3;
  int      loopNum       = 0;
  uint32_t lastTime      = millis();
  uint32_t firstPixelHue = 0;

  for(;;) { // Repeat forever (or until a 'break' or 'return')
    for(int i=0; i<strip.numPixels(); i++) {  // For each pixel in strip...
      if(((i >= tail) && (i <= head)) ||      //  If between head & tail...
         ((tail > head) && ((i >= tail) || (i <= head)))) {
        strip.setPixelColor(i, strip.Color(0, 0, 0, 255)); // Set white
      } else {                                             // else set rainbow
        int pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
        strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue)));
      }
    }

    strip.show(); // Update strip with new contents
    // There's no delay here, it just runs full-tilt until the timer and
    // counter combination below runs out.

    firstPixelHue += 40; // Advance just a little along the color wheel

    if((millis() - lastTime) > whiteSpeed) { // Time to update head/tail?
      if(++head >= strip.numPixels()) {      // Advance head, wrap around
        head = 0;
        if(++loopNum >= loops) return;
      }
      if(++tail >= strip.numPixels()) {      // Advance tail, wrap around
        tail = 0;
      }
      lastTime = millis();                   // Save time of last movement
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

void rainbowFade2White(int wait, int rainbowLoops, int whiteLoops) {
  int fadeVal=0, fadeMax=100;

  // Hue of first pixel runs 'rainbowLoops' complete loops through the color
  // wheel. Color wheel has a range of 65536 but it's OK if we roll over, so
  // just count from 0 to rainbowLoops*65536, using steps of 256 so we
  // advance around the wheel at a decent clip.
  for(uint32_t firstPixelHue = 0; firstPixelHue < rainbowLoops*65536;
    firstPixelHue += 256) {

    for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...

      // Offset pixel hue by an amount to make one full revolution of the
      // color wheel (range of 65536) along the length of the strip
      // (strip.numPixels() steps):
      uint32_t pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());

      // strip.ColorHSV() can take 1 or 3 arguments: a hue (0 to 65535) or
      // optionally add saturation and value (brightness) (each 0 to 255).
      // Here we're using just the three-argument variant, though the
      // second value (saturation) is a constant 255.
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255,
        255 * fadeVal / fadeMax)));
    }

    strip.show();
    delay(wait);

    if(firstPixelHue < 65536) {                              // First loop,
      if(fadeVal < fadeMax) fadeVal++;                       // fade in
    } else if(firstPixelHue >= ((rainbowLoops-1) * 65536)) { // Last loop,
      if(fadeVal > 0) fadeVal--;                             // fade out
    } else {
      fadeVal = fadeMax; // Interim loop, make sure fade is at max
    }
  }

  for(int k=0; k<whiteLoops; k++) {
    for(int j=0; j<256; j++) { // Ramp up 0 to 255
      // Fill entire strip with white at gamma-corrected brightness level 'j':
      strip.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
      strip.show();
    }
    delay(1000); // Pause 1 second
    for(int j=255; j>=0; j--) { // Ramp down 255 to 0
      strip.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
      strip.show();
    }
  }

  delay(500); // Pause 1/2 second
}
