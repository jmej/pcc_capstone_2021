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
