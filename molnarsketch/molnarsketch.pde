//int colArrayNum = 0;
float PHI = 1.618033988749894848204586834365638117720309179805762862135448;
float rotation = 0;
boolean pause = false;

//int frames;

color[] colArray = {
  
  color(255, 255, 255), //white
  color(200, 5, 20), //red
  color(55, 188, 25), //green
  color(15, 35, 250), //blue
  color(125, 235, 250), //light blue
  color(240, 245, 15), //yellow
  color(160, 60, 235),  //purple
};

int grid = 15;
int margin = 70;

void setup() {
  size(700, 900);
  
  
  
}

void draw() {
  background(15, 20, 30);
  //frames++;
  if (!pause){
    //rotation = random(PI*2);
    rotation += 0.0004;
      rotation = rotation%PI;
      //rotation = rotation%PI*2;
    }
  translate(width/2, height/2);
  //float rotation = map(mouseX, 0, width, 0, PI);
  for(int i =1; i < 500; i ++) {
   //pushMatrix();
   
   rotate(rotation);
   stroke(255);
   molnar(50 * (i % 10), 50);
   
   fill(255);
   //text(rotation, 50 * (i % 10), 50);
   //popMatrix();
  }
}
 void molnar(float xLoc, float yLoc){
   
    //if(frames % 2 == 0){ 
    //  colArrayNum = (int)random(7);
    //}
    int colArrayNum = (int)random(7);
    stroke(colArray[colArrayNum]);
    strokeWeight(2);
    pushMatrix();
    translate(xLoc, yLoc);
    for(int num = 0; num<8; num++){
      
      float d =grid;
        
      float x1 = -random(d);
      float y1 = -random(d);
      float x2 = random(d);
      float y2 = -random(d);
      float x3 = random(d);
      float y3 = random(d);
      float x4 = -random(d);
      float y4 = random(d);
    
    
      //pushMatrix();
      
      
      noFill();
      quad(x1, y1, x2, y2, x3, y3, x4, y4);
      
      
   } 
    popMatrix();

}
