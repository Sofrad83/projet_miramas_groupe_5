PImage img, img2;
float imageRotation = random(360);
int counter = 1;
float angle;
float jitter;
float angleRotate = 0.0;


void setup() {
  size(1000,1000);
  smooth();
  //fullScreen();
  //background(0);
  img = loadImage("engrenage.png");
  img2 = loadImage("Steampunk-Gear_3.png");
  //background(0, 0, 0);
  //img = loadImage("radialoutlinel.png");
  imageMode(CENTER); //you can change mode to CORNER to see the difference.
  
  frameRate(3);
  //image(img, 0, 0);
  //image(img2, 450, 20);
}

void draw() {
  background(0);
  fill(255);
  //image1();
  //image2();
  image3();
  //image4();
}

void image1() {
  counter++;
  translate(width/2, height/2);
  rotate(counter*TWO_PI/360);
  image(img, 0, 0, 300, 300);
}

void image2() {
  counter++;
  float r = cos(counter*TWO_PI/360);
  translate(width/2, height/2);
  rotate(r);
  image(img2, 360, 0, 300, 300);
}

void image3() {
  background(0);

  strokeWeight(1);
  stroke(153);

  //pushMatrix();
  //float angle1 = radians(45);
  //translate(100, 180);
  //rotate(angle1);
  //text("45 DEGREES", 0, 0);
  //line(0, 0, 150, 0);
  //popMatrix();

  pushMatrix();
  float angle2 = radians(270);
  translate(200, 180);
  rotate(radians(angleRotate*-1));
  //text("270 DEGREES", 0, 0);
  image(img, 0, 0, 300, 300);
  line(0, 0, 150, 0);
  popMatrix();
  
  pushMatrix();
  translate(440, 260);
  rotate(radians(angleRotate));
  //text(int(angleRotate) % 360 + " DEGREES", 0, 0);
  image(img2, 0, 0, 300, 300);
  line(0, 0, 150, 0);
  popMatrix();
  
  angleRotate += 1.5;

  stroke(255, 0, 0);
  strokeWeight(4);
  //point(100, 180);
  point(200, 180);
  point(440, 260);
}
