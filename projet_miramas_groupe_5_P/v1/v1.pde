PImage bg;
PImage motorGear, rightGear, middleGear;
PImage lever, button, buttonPush;
float angleRotate = 0.0;

void setAllImages() {
  middleGear = loadImage("engrenage.png");
  rightGear = loadImage("Steampunk-Gear_3.png");
  motorGear = loadImage("Steampunk-Gear_4.png");
  
  lever = loadImage("Lever.png");
  button = loadImage("Button-S.png");
  buttonPush = loadImage("Button-S-push.png");
  
  imageMode(CENTER);
}

void setup()
{
  size(800,550);
  bg = loadImage("bg.png");
  
  setAllImages();
  
  frameRate(3);
}

void draw()
{
    background(bg);
    mecanism();
}  

void mecanism() {
  makeGear(middleGear, 320, 420, 190, 190, -1);
  makeGear(motorGear, 177, 435, 200, 200, 1);
  makeGear(rightGear, 476, 464, 200, 200, 1);
  
  pushMatrix();
  translate(475, 305);
  image(lever, 0, 0, 107, 107);
  popMatrix();
  
  for (int i = 0; i < 3; i = i+1) {
    pushMatrix();
    translate(463, 95 + i*60);
    image(button, 0, 0, 55, 55);
    popMatrix();
  }
  
  angleRotate += 1.5;
}

void makeGear(PImage img, int x, int y, int scale_x, int scale_y, int direction) {
  pushMatrix();
  translate(x, y);
  rotate(radians(angleRotate * direction));
  image(img, 0, 0, scale_x, scale_y);
  popMatrix();
}
