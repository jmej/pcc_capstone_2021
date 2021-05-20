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
    int tail2 = tail1 + 20;
    int tail3 = tail2 + 20;
    int tail4 = tail3 + 20;
    int tail5 = tail4 + 20;
    int tail6 = tail5 + 20;
    int tail7 = tail6 + 20;
    int tail8 = tail7 + 20;
    int tail9 = tail8 + 20;
    int tail10 = tail9 + 20;
    int tail11 = tail10 + 20;
    int tail12 = tail11 + 20;
    int head1 = stripLength - 1;
    int head2 = head1 + 20;
    int head3 = head2 + 20;
    int head4 = head3 + 20;
    int head5 = head4 + 20;
    int head6 = head5 + 20;
    int head7 = head6 + 20;
    int head8 = head7 + 20;
    int head9 = head8 + 20;
    int head10 = head9 + 20;
    int head11 = head10 + 20;
    int head12 = head11 + 20;
    int loops = 3;
    int loop1Num = 0;
    int loop2Num = 0;
    int loop3Num = 0;
    int loop4Num = 0;
    int loop5Num = 0;
    int loop6Num = 0;
    int loop7Num = 0;
    int loop8Num = 0;
    int loop9Num = 0;
    int loop10Num = 0;
    int loop11Num = 0;
    int loop12Num = 0;
    uint32_t lastTime1 = millis();
    uint32_t lastTime2 = millis();
    uint32_t lastTime3 = millis();
    uint32_t lastTime4 = millis();
    uint32_t lastTime5 = millis();
    uint32_t lastTime6 = millis();
    uint32_t lastTime7 = millis();
    uint32_t lastTime8 = millis();
    uint32_t lastTime9 = millis();
    uint32_t lastTime10 = millis();
    uint32_t lastTime11 = millis();
    uint32_t lastTime12 = millis();
    uint32_t firstPixelHue = 0;

    
    int redTails[] = {0, 60, 120, 180};
    int redHeads[] = {19, 79, 139, 199};
    int blueTails[] = {20, 80, 140, 200};
    int blueHeads[] = {39, 99, 159, 219};
    int greenTails[] = {40, 100, 160, 220};
    int greenHeads[] = {59, 119, 179, 239};

    for(;;) {
      for(int i = 0; i < strip.numPixels(); i++) {
        if(((i >= tail1) && (i <= head1)) || ((tail1 > head1) && ((i >= tail1) || (i <= head1)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else if(((i >= tail2) && (i <= head2)) || ((tail2 > head2) && ((i >= tail2) || (i <= head2)))) {
          strip.setPixelColor(i, strip.Color(0, 255, 0));  
        }
        else if(((i >= tail3) && (i <= head3)) || ((tail3 > head3) && ((i >= tail3) || (i <= head3)))) {
          strip.setPixelColor(i, strip.Color(0, 0, 255));  
        }
        else if(((i >= tail4) && (i <= head4)) || ((tail4 > head4) && ((i >= tail4) || (i <= head4)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else if(((i >= tail5) && (i <= head5)) || ((tail5 > head5) && ((i >= tail5) || (i <= head5)))) {
          strip.setPixelColor(i, strip.Color(0, 255, 0));  
        }
        else if(((i >= tail6) && (i <= head6)) || ((tail6 > head6) && ((i >= tail6) || (i <= head6)))) {
          strip.setPixelColor(i, strip.Color(0, 0, 255));  
        }
        else if(((i >= tail7) && (i <= head7)) || ((tail7 > head7) && ((i >= tail7) || (i <= head7)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else if(((i >= tail8) && (i <= head8)) || ((tail8 > head8) && ((i >= tail8) || (i <= head8)))) {
          strip.setPixelColor(i, strip.Color(0, 255, 0));  
        }
        else if(((i >= tail9) && (i <= head9)) || ((tail9 > head9) && ((i >= tail9) || (i <= head9)))) {
          strip.setPixelColor(i, strip.Color(0, 0, 255));  
        }
        else if(((i >= tail10) && (i <= head10)) || ((tail10 > head10) && ((i >= tail10) || (i <= head10)))) {
          strip.setPixelColor(i, strip.Color(255, 0, 0));  
        }
        else if(((i >= tail11) && (i <= head11)) || ((tail11 > head11) && ((i >= tail11) || (i <= head11)))) {
          strip.setPixelColor(i, strip.Color(0, 255, 0));  
        }
        else if(((i >= tail12) && (i <= head12)) || ((tail12 > head12) && ((i >= tail12) || (i <= head12)))) {
          strip.setPixelColor(i, strip.Color(0, 0, 255));  
        }
        else {
          strip.setPixelColor(i, strip.Color(0,0,0,0));  
        }  
      }

//      for(int i = 0; i < strip.numPixels(); i++) {
//        for(int j = 0; j < 4; j++) {
//          if(((i >= redTails[j]) && (i <= redHeads[j])) || ((redTails[j] > redHeads[j]) && ((i >= redTails[j]) || (i <= redHeads[j])))) {
//            strip.setPixelColor(i, strip.Color(255,0,0));  
//          }
//          else {
//            strip.setPixelColor(i, strip.Color(0,0,0,0));  
//          }   
//        }  
//      }

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
    if((millis() - lastTime4) > stripSpeed) { // Time to update head/tail?
      if(++head4 >= strip.numPixels()) {      // Advance head, wrap around
        head4 = 0;
        if(++loop4Num >= loops) return;
      }
      if(++tail4 >= strip.numPixels()) {      // Advance tail, wrap around
        tail4 = 0;
      }
      lastTime4 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime5) > stripSpeed) { // Time to update head/tail?
      if(++head5 >= strip.numPixels()) {      // Advance head, wrap around
        head5 = 0;
        if(++loop5Num >= loops) return;
      }
      if(++tail5 >= strip.numPixels()) {      // Advance tail, wrap around
        tail5 = 0;
      }
      lastTime5 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime6) > stripSpeed) { // Time to update head/tail?
      if(++head6 >= strip.numPixels()) {      // Advance head, wrap around
        head6 = 0;
        if(++loop3Num >= loops) return;
      }
      if(++tail6 >= strip.numPixels()) {      // Advance tail, wrap around
        tail6 = 0;
      }
      lastTime6 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime7) > stripSpeed) { // Time to update head/tail?
      if(++head7 >= strip.numPixels()) {      // Advance head, wrap around
        head7 = 0;
        if(++loop7Num >= loops) return;
      }
      if(++tail7 >= strip.numPixels()) {      // Advance tail, wrap around
        tail7 = 0;
      }
      lastTime7 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime8) > stripSpeed) { // Time to update head/tail?
      if(++head8 >= strip.numPixels()) {      // Advance head, wrap around
        head8 = 0;
        if(++loop8Num >= loops) return;
      }
      if(++tail8 >= strip.numPixels()) {      // Advance tail, wrap around
        tail8 = 0;
      }
      lastTime8 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime9) > stripSpeed) { // Time to update head/tail?
      if(++head9 >= strip.numPixels()) {      // Advance head, wrap around
        head9 = 0;
        if(++loop9Num >= loops) return;
      }
      if(++tail9 >= strip.numPixels()) {      // Advance tail, wrap around
        tail9 = 0;
      }
      lastTime9 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime10) > stripSpeed) { // Time to update head/tail?
      if(++head10 >= strip.numPixels()) {      // Advance head, wrap around
        head10 = 0;
        if(++loop10Num >= loops) return;
      }
      if(++tail10 >= strip.numPixels()) {      // Advance tail, wrap around
        tail10 = 0;
      }
      lastTime10 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime11) > stripSpeed) { // Time to update head/tail?
      if(++head11 >= strip.numPixels()) {      // Advance head, wrap around
        head11 = 0;
        if(++loop11Num >= loops) return;
      }
      if(++tail11 >= strip.numPixels()) {      // Advance tail, wrap around
        tail11 = 0;
      }
      lastTime11 = millis();                   // Save time of last movement
    }
    if((millis() - lastTime12) > stripSpeed) { // Time to update head/tail?
      if(++head12 >= strip.numPixels()) {      // Advance head, wrap around
        head12 = 0;
        if(++loop12Num >= loops) return;
      }
      if(++tail12 >= strip.numPixels()) {      // Advance tail, wrap around
        tail12 = 0;
      }
      lastTime12 = millis();                   // Save time of last movement
    }



//    if((millis() - lastTime1) > stripSpeed) {
//      for (int i = 0; i < 4; i++) {
//        if(++redHeads[i] >= strip.numPixels()) {
//          redHeads[i] = 0;
//          if(++loop1Num >= loops) return;  
//        }  
//      }  
//    }
  }
}
