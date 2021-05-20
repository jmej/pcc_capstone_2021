#include <Adafruit_NeoPixel.h>
#include <OSCMessage.h>
#include <WiFi.h>
#include <WiFiUdp.h>

#define LED_PIN 18
#define LED_COUNT 240

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

int bVal = 200;

int sensor1Pin = 15;
int sensor2Pin = 14;
int sensor3Pin = 16;
int sensor4Pin = 17;
int sensorMax = 45000;
int sensorMin = 1500;
int s1scaled, s2scaled, s3scaled, s4scaled; 
long mm1, mm2, mm3, mm4;


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
//
//  sensor1Val = pulseIn(sensor1Pin, HIGH);
//  sensor2Val = pulseIn(sensor2Pin, HIGH);
//  sensor3Val = pulseIn(sensor3Pin, HIGH);
//  sensor4Val = pulseIn(sensor4Pin, HIGH);

//  int sensorVals[] = {sensor1Val, sensor2Val, sensor3Val, sensor4Val};
//
//  for (int i = 0; i < 4; i++) {
//    if (sensorVals[i] < sensorMax) {
//      usedSensors++;  
//    }
//  }
//
//  if (usedSensors == 0) {
//    waiting();
//    
//  }
//  else if (usedSensors < 4) {
//  // code for "incomplete" behavior here
////    for (int i = 0; i < PIXEL_COUNT; i++) {
////      switch (usedSensors) {
////        case 1:
////        break;
////        case 2:
////        break;
////        case 3:
////        break;
////      }  
////    }
//    
//  }
//  else {
//    // code for "complete" behavior here
//    float avg = (sensor1Val + sensor2Val + sensor3Val + sensor4Val) / 4;
//    
//      
//  }

  ambience(strip.Color(255,0,0), strip.Color(0,255,0), strip.Color(0, 0, 255), 50, 40);

// need to map the values of the sensors to the color of the pixels
// should it display the same colors if it's getting the same data but from different sides? (like {0, 0, 0, 1} vs. {1, 0, 0, 0})
// what behavior do I want if no one is close to it? no lights? *
// behavior should only be complete if there are people on every side
// so what does complete vs. incomplete behavior look like? number of lit up pixels? intermittent glowing?
// if the behavior is "complete" (someone on every side), how will it change as people move closer and farther away?

// incomplete:
 // - intermittent glowing
    // - one color (palette) for each person (?) being detected as long as there are less than four
    // - different parts of the strip glow different colors, not at the same time

// complete:
  // - too basic to just have the color change
  // other things I have control over:
    // - # of lit up pixels
    // flashing/blinking
    // different parts glowing different colors
        // would it be too hard to control each side individually? it would mean being really intentional about how I thread the strips through the wire

    
    
// am I trying to send any particular message? about being together? closeness? what is "good"? how does good vs. bad translate to the light?



  }
  
//  s1scaled = int(map(mm1, sensorMin, sensorMax, 0, 127));
//  s2scaled = int(map(mm2, sensorMin, sensorMax, 0, 127));
//  s3scaled = int(map(mm3, sensorMin, sensorMax, 0, 127));
//  s4scaled = int(map(mm4, sensorMin, sensorMax, 0, 127));
//
//  Serial.println(s1scaled);
//  
//  usbMIDI.sendControlChange(1, s1scaled, 1);
//  usbMIDI.sendControlChange(2, s2scaled, 1);
//  usbMIDI.sendControlChange(3, s3scaled, 1);
//  usbMIDI.sendControlChange(4, s4scaled, 1);
//  
//  delay(100);

//void rainbow() {
//  int button = digitalRead(rotarySwitchPin);
//  for(long firstPixelHue = 0; firstPixelHue < 3*65536; firstPixelHue += 256) {
//    for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
//      // Offset pixel hue by an amount to make one full revolution of the
//      // color wheel (range of 65536) along the length of the strip
//      // (strip.numPixels() steps):
//      int pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
//      // strip.ColorHSV() can take 1 or 3 arguments: a hue (0 to 65535) or
//      // optionally add saturation and value (brightness) (each 0 to 255).
//      // Here we're using just the single-argument hue variant. The result
//      // is passed through strip.gamma32() to provide 'truer' colors
//      // before assigning to each pixel:
//      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue)));
//    }
//    if (button == 1) {
//      strip.show(); // Update strip with new contents
//    }
//  }
//}

void waiting() {
  // modified version of rainbow() function
  for(long firstPixelHue = 0; firstPixelHue < 3*65536; firstPixelHue += 256) {
    for (int i = 0; i < strip.numPixels(); i++) {
      int pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue)));  
    }
    strip.show();  
  }
      
}

void colorWipe(uint32_t color, int wait) {
  for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
    strip.setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}
  
  // trying to make version of colorWipe() that fills strips instead of individual pixels w/ 3 different colors
  // add one color for each additional person? or change the scheme completely?

  
void ambience(uint32_t color1, uint32_t color2, uint32_t color3, int wait, int num) {
  for(int i = 0; i < strip.numPixels(); i++) {
      strip.fill(color1, i, num);
//      strip.fill(color2, i + num + 20, num);
//      strip.fill(color3, i + 2*(num + 20), num);
      strip.show();
      delay(wait);
  }  
}
