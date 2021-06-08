//dropzone for file dropping
var dropzone;

//robby's sketchy birds
let birds = [];
let x;
let y;
let timer = 0;
let timer2 = 0;
let mass = 0.6;


function setup() {
  createCanvas(1800, 1000, WEBGL);
  background(0);


  dropzone = select('#dropzone');
  dropzone.dragOver(highlight);
  dropzone.dragLeave(unhighlight);
  dropzone.drop(gotFile, unhighlight);

  angleMode(DEGREES);

  //sketchy birds
   for (let i = 0; i < 28; i++) {
      birds.push(new Motion());
      }
}


function draw(){


  push();
  translate(-width*0.5, -height*0.5);
  //sketchy birds
    for (let i = 0; i < birds.length; i++) {
      birds[i].move();
      birds[i].display();
      }
  pop();

}


function gotFile(file) {
  createP(file.name + ' ' + file.size);
  var img = createImg(file.data);
  img.size(100, 100);
}


function highlight() {
  dropzone.style('background-color', '#ccc');
}

function unhighlight() {
  dropzone.style('background-color', '#fff');
}


// sketchy birds class
class Motion {
  constructor() {
    this.x = random(width);
    this.y = random(height);
    this.diameter = random(10, 30);
    this.speed = 10;
    this.r = random(150, 200);
    this.g = random(50, 75);
    this.b = random(50, 75);
    this.alpha = random(0, 100);
    // this.newX = 0;
    // this.newY = 0;
  }

  move() {
    this.x += random(-this.speed, this.speed);
    this.y += random(-this.speed, this.speed);

    this.r += random(-1, 1);
    this.g += random(-1, 1);
    this.b += random(-1, 1);

    if (this.alpha <= 0)
      {
      this.alpha += random(this.alpha*0.1);
      }
    if (this.alpha >= 100)
      {
      this.alpha -= random(this.alpha*0.1);
      }
      
  }

  display() {
    noFill();

    stroke(this.r, this.g, this.b, this.alpha);
    
    if(timer <= 2000){
      timer ++;
      }
      else{
        timer = 0;
        this.x = random(width);
        this.y = random(height);
      }

    if(timer2 <= 2000){
      timer2 ++;
      }
      else{
        timer2 = 0;
        this.x = random(width);
        this.y = random(height);
      }

    let newX = map(timer, 0, 2000, this.x, width/2 + random(20)); //+ random(10));
    let newY = map(timer, 0, 2000, this.y, height/2 - 100 + random(20));//+random(10));

    
    beginShape();
      for (let i=0; i<1500; i++) {
        vertex(newX, newY);
        mass = map(timer2, 0, 2500, 0.6, 0.001);
        newX += random(-mass, mass);
        newY += random(-mass, mass);
      }
    endShape();
  }
}
