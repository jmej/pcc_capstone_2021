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



void incompleteBase(int num) {  // num will be numOfSensors, 1 thru 3 

    int stripLength = 0;

//    int mappedMinTime = map(dummyAvg, 1500, 45000, 4000, 35000);
//    int mappedMaxTime = map(dummyAvg, 1500, 45000, 6000, 42000);
    
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
                strip.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                break;  
              }
              break;
              case 2:
              switch(j % 4) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                break;
                case 3:
                strip.setPixelColor(i, incompColor4);
                break;  
              }
              break;
              case 3:
              switch(j % 5) {
                case 0:
                strip.setPixelColor(i, incompColor1);
                break;
                case 1:
                strip.setPixelColor(i, incompColor2);
                break;
                case 2:
                strip.setPixelColor(i, incompColor3);
                break;
                case 3:
                strip.setPixelColor(i, incompColor4);
                break;
                case 4:
                strip.setPixelColor(i, incompColor5);
                break;
              }
              break;      
            }   
          }  
        }
      }

    strip.show();

      
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

    int mappedAvgSpeed = map(dummyAvg, 1500, 45000, 30, 150);
    
    if (millis() > randBehaviorTime) {
      randBehaviorTime = millis() + random(20000, 30000);
      interrupt = true;
      d = -d;
      return;
    }

    if (millis() > randTrigTime) {
      randTrigTime = millis() + random(10000, 20000);
      trig = true;
      return;  
    }

    int mappedAvgBrightness = map(dummyAvg, 1500, 45000, 200, 0);

    strip.setBrightness(mappedAvgBrightness);

    delay(mappedAvgSpeed);

    dummyAvg += avgChange;
    if ((dummyAvg <= 1500) || (dummyAvg >= 45000)) {
      avgChange = -avgChange; 
    }

  }

}

void incompleteInterrupt(int wait) {


  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(201, 87, 194, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(201, 87, 194, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(85, 206, 191, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(85, 206, 191, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=0; j<256; j++) { // Ramp up from 0 to 255
    // Fill entire strip with white at gamma-corrected brightness level 'j':
    strip.fill(strip.Color(245, 180, 50, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(245, 180, 50, strip.gamma8(j)));
    strip.show();
    delay(wait);
  }

//  if (num >= 2) {
//    for(int j = 0; j < 256; j++) {
//      strip.fill(strip.Color(120, 255, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait);  
//    }
//
//    for(int j = 255; j >= 0; j++) {
//      strip.fill(strip.Color(120, 255, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait);  
//    }
//  }
//
//  if (num == 3) {
//    for(int j = 0; j < 256; j++) {
//      strip.fill(strip.Color(227, 79, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait); 
//    }
//    for(int j = 255; j >= 0; j--) {
//      strip.fill(strip.Color(227, 79, 30, strip.gamma8(j)));
//      strip.show();
//      delay(wait);  
//    }   
//  }
  
}

void incomplete(int num) {
  for(;;) {
    if (!(1 <= num && 3 >= num)) return;
    if (millis() >= randTrigTime) {
      Serial.println("should trigger");
      trig = true;
      randTrigTime = millis() + randTrigTime;   
    }
    incompleteBase(num);
    if (trig == true) {
      colorWipe(incompColor1, 5);
      trig = false;  
    }
    //incompleteInterrupt(num);
    if (interrupt == true) {
      pulseWhite(5);
      interrupt = false;  
    }
  }  
}

void completeInterrupt() {
  
  
}

void completeBase() {


  // for now, generate random location and random max length
  // need variables for center location, max length, current length
  // need to store color of appearing strip and colors on either side

  uint32_t blue = strip.Color(0, 0, 255);
  int center = 20;
  int maxLength = 19;
  
  for (int i = 0; i < strip.numPixels(); i++) {

    if(i <= center + growth && i >= center-growth) {
      strip.setPixelColor(i, blue);  
    }
    else {
      strip.setPixelColor(i, strip.Color(255, 0, 0));
    }  
  }
  strip.show();

  if (growth < maxLength) {
    growth++;  
  }

  delay(200);

   
}

void complete(int num) {
  for(;;) {
    if(num != 4) return;
    completeBase();
    completeInterrupt();  
  }
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


void meteorRain(int red, int green, int blue, byte meteorSize, byte meteorTrailDecay, boolean meteorRandomDecay, int SpeedDelay) {  
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(0, 0, 0, 0);
  }
 
  for(int i = 0; i < 2 * strip.numPixels(); i++) {
   
   
    // fade brightness all LEDs one step
    for(int j=0; j<strip.numPixels(); j++) {
      if( (!meteorRandomDecay) || (random(100)>99) ) {
        fadeToBlack(j, meteorTrailDecay );        
      }
    }
   
    // draw meteor
    for(int j = 0; j < meteorSize; j++) {
      if( ( i-j <strip.numPixels()) && (i-j>=0) ) {
        strip.setPixelColor(i-j, red, green, blue);
      }
    strip.show();
    }
   
    
    //delay(SpeedDelay);
  }
}

void fadeToBlack(int ledNo, byte fadeValue) {
    uint32_t oldColor;
    uint8_t r, g, b;
    int value;
   
    oldColor = strip.getPixelColor(ledNo);
    r = (oldColor & 0x00ff0000UL) >> 16;
    g = (oldColor & 0x0000ff00UL) >> 8;
    b = (oldColor & 0x000000ffUL);

    r=(r<=10)? 0 : (int) r-(r*fadeValue/256);
    g=(g<=10)? 0 : (int) g-(g*fadeValue/256);
    b=(b<=10)? 0 : (int) b-(b*fadeValue/256);
   
    strip.setPixelColor(ledNo, r,g,b);
    strip.show();

}
