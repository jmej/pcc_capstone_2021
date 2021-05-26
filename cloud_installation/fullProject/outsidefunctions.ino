void colorWipe(uint32_t color) {
  for(int i = 0; i < strip.numPixels() * 2; i++) {
    if (i < 240) {
      strip.setPixelColor(i, color);
    }
    else {
      strip2.setPixelColor(i - 240, color);
      Serial.println(i-240);  
    }
    strip.show();
    strip2.show();
    //delay(wait);
      
  }  
}

void reverseColorWipe(uint32_t color) {
  for(int i = strip.numPixels() * 2 - 1; i >= 0; i--) {
    if (i >= 240) {
      strip2.setPixelColor(i - 240, color);
    }
    else {
      strip.setPixelColor(i, color); 
    }
    strip.show();
    strip2.show();
    //delay(wait);
      
  }  
}



void whiteOverRainbow(int whiteSpeed, int whiteLength) {

  if(whiteLength >= strip.numPixels()) whiteLength = strip.numPixels() - 1;

  int      head          = whiteLength - 1;
  int      tail          = 0;
  int      loops         = 1;
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
    strip2.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
    strip.show();
    strip2.show();
    delay(wait);
  }

  for(int j=255; j>=0; j--) { // Ramp down from 255 to 0
    strip.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
    strip2.fill(strip.Color(0, 0, 0, strip.gamma8(j)));
    strip.show();
    strip2.show();
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


float Fire(int Cooling, int Sparking, int SpeedDelay) {
  static byte heat[LED_COUNT1];
  int cooldown;
 
  // Step 1.  Cool down every cell a little
  
    for( int i = 0; i < strip.numPixels(); i++) {
      cooldown = random(0, ((Cooling * 10) / strip.numPixels()) + 2);
   
      if(cooldown>heat[i]) {
        heat[i]=0;
      } else {
        heat[i]=heat[i]-cooldown;
      }
    }
 
    // Step 2.  Heat from each cell drifts 'up' and diffuses a little
    for( int k= strip.numPixels() - 1; k >= 2; k--) {
      heat[k] = (heat[k - 1] + heat[k - 2] + heat[k - 2]) / 3;
    }
   
    // Step 3.  Randomly ignite new 'sparks' near the bottom
    if( random(255) < Sparking ) {
      int y = random(7);
      heat[y] = heat[y] + random(160,255);
      //heat[y] = random(160,255);
    }

    // Step 4.  Convert heat to LED colors
    for( int j = 0; j < strip.numPixels(); j++) {
      setPixelHeatColor(j, heat[j] );
    }

    if (fBrightness < 255) {
      fBrightness+=1;  
    }

    if (fBrightness >= 255) {
      fWhite+=1;  
    }
  
    strip.setBrightness(fBrightness);
    strip.show();
    strip2.show();
    Serial.println(fBrightness);
    //delay(SpeedDelay);

}

void setPixelHeatColor (int Pixel, byte temperature) {
  // Scale 'heat' down from 0-255 to 0-191
  byte t192 = round((temperature/255.0)*191);
 
  // calculate ramp up from
  byte heatramp = t192 & 0x3F; // 0..63
  heatramp <<= 2; // scale up to 0..252
 
  // figure out which third of the spectrum we're in:
  if( t192 > 0x80) {                     // hottest
    strip.setPixelColor(239-Pixel, strip.Color(255, 255, heatramp, int(fWhite)));
    strip2.setPixelColor(239-Pixel, strip.Color(255, 255, heatramp, int(fWhite)));
    
  } else if( t192 > 0x40 ) {             // middle
    strip.setPixelColor(239-Pixel, strip.Color(255, heatramp, 0, int(fWhite)));
    strip2.setPixelColor(239-Pixel, strip.Color(255, heatramp, 0, int(fWhite)));
  } else {                               // coolest
    strip.setPixelColor(239-Pixel, strip.Color(heatramp, 0, 0, int(fWhite)));
    strip2.setPixelColor(239-Pixel, strip.Color(heatramp, 0, 0, int(fWhite)));
  }
}


void meteorRain(byte red, byte green, byte blue, byte meteorSize, byte meteorTrailDecay, boolean meteorRandomDecay, int SpeedDelay) {  
  ;
 
  for(int i = 0; i < strip.numPixels() * 2; i++) {
   
   
    // fade brightness all LEDs one step
    for(int j=0; j<strip.numPixels(); j++) {
      if( (!meteorRandomDecay) || (random(10)>5) ) {
        fadeToBlack(j, meteorTrailDecay );        
      }
    }
   
    // draw meteor
    for(int j = 0; j < meteorSize; j++) {
      if( ( i-j <strip.numPixels()) && (i-j>=0) ) {
        strip.setPixelColor(i-j, red, green, blue);
      }
    }
   
    strip.show();
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

}

void doubleFade(int ledNo, byte fadeValue) {
  uint32_t oldColor;
  uint8_t r, g, b;
  int value;

  if (ledNo < 240) {
    oldColor = strip.getPixelColor(ledNo);
    r = (oldColor & 0x00ff0000UL) >> 16;
    g = (oldColor & 0x0000ff00UL) >> 8;
    b = (oldColor & 0x000000ffUL);
  
    r=(r<=10)? 0 : (int) r-(r*fadeValue/256);
    g=(g<=10)? 0 : (int) g-(g*fadeValue/256);
    b=(b<=10)? 0 : (int) b-(b*fadeValue/256);
     
    strip.setPixelColor(ledNo, r,g,b);
  }
  else {
    oldColor = strip2.getPixelColor(ledNo - 240);
    r = (oldColor & 0x00ff0000UL) >> 16;
    g = (oldColor & 0x0000ff00UL) >> 8;
    b = (oldColor & 0x000000ffUL);
  
    r=(r<=10)? 0 : (int) r-(r*fadeValue/256);
    g=(g<=10)? 0 : (int) g-(g*fadeValue/256);
    b=(b<=10)? 0 : (int) b-(b*fadeValue/256);
     
    strip2.setPixelColor(ledNo - 240, r,g,b);
  }
  strip.show();
  strip2.show();  

}

bool arrayContains(int arr[], int arrayLength, int val) {
  bool isIn = false;
  for (int i = 0; i < arrayLength; i++) {
    if (arr[i] == val) {
      isIn = true;  
    }
  }
  return isIn;
}
