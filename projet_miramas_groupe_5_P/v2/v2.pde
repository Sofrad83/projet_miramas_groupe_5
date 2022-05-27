import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture cam_;
OpenCV opencv_;

float timeMS_ = millis();
float timeS_ = timeMS_ * 0.001;
float timeSOld_ = timeMS_;

/**int videoWidth_ = 320;
 int videoHeight_ = 180;*/
int videoWidth_ = 640;
int videoHeight_ = 360;
int scale_ = 3;
//int scale_ = 3;

PImage[] frames_ = new PImage[2];
int currentFrameIndex_ = 0;
boolean first_ = true;
PImage fullFrame_ = new PImage(videoWidth_*scale_, videoHeight_*scale_);
PImage bg, lever_base, button, buttonPush, btn_vert, btn_orange, btn_rouge, horloge, egguille1, egguille2;
Bouton btn1, btn2, btn3;
ImageDragNDrop middleGear, motorGear, rightGear;
ImageRotate lever_cut;
float angleRotate = 0.0;
float speedRotate = 0.0;
boolean answerIsGood;
IntList reponse = new IntList(2, 3, 1);
IntList actuel = new IntList();
boolean premier_tour = false;
boolean deuxieme_tour = false;

float angleRotateEgguille1 = 0.0;
float angleRotateEgguille2 = 0.0;
float speedRotateEgguille1 = 0.1;
float speedRotateEgguille2 = 0.1;
boolean canBePush;
float absolute_mag = 0.0;
//int io=-1, jo=-1;
//float max_mag = 0;


int minute = -1;
boolean isDraggable = true;
import processing.sound.*;
SoundFile gear_clink, running_gear, button_click, cuckoo;
float volume = 0.0;
boolean cuckoo_played = false;
boolean is_finish = false;

Flow flow_ = null;
HotSpot[] hotSpots_ = new HotSpot[9];

//================================
float detectAbsoluteMagMin_ = 2.0;
float detectAverageMagMax_ = 1.2;
float psAverageMax_ = 0.2;
//=================================

int selectedHotSpotIndex_ = -1;
float selectDelaySo_ = 0.5;
float selectDelayS_ = selectDelaySo_;


//Permet de savoir si le curseur est sur la hitbox
boolean isCollide(float x, float y, float rx, float ry, float rw, float rh) {

  if (x >= rx &&        
      x <= rx + rw &&   
      y >= ry &&        
      y <= ry + rh) {
        return true;
  }
  return false;
}

void setAllGears() {
  rightGear = new ImageDragNDrop("Steampunk-Gear_3.png", 1496, 170, 400, 400, 1108, 912, 480, 480, 1);
  rightGear.ImageSetup();
  middleGear = new ImageDragNDrop("engrenage.png", 1496, 510, 400, 400, 800, 800, 456, 456, -1);
  middleGear.ImageSetup();
  motorGear = new ImageDragNDrop("Steampunk-Gear_4.png", 1496, 840, 400, 400, 520, 860, 480, 480, 1);
  motorGear.ImageSetup();

  lever_cut = new ImageRotate("Lever_cut_2.png", 1114, 605, 257, 257);
  lever_cut.ImageSetup();
}

void setAllImages(){
  lever_base = loadImage("Lever_base.png");
  button = loadImage("Button-S.png");
  buttonPush = loadImage("Button-S-push.png");
  btn_vert = loadImage("btn-vert.png");
  btn_rouge = loadImage("btn-rouge.png");
  btn_orange = loadImage("btn-orange.png");
  horloge = loadImage("Horlog.png");
  egguille1 = loadImage("egguille1.png");
  egguille2 = loadImage("egguille2.png");
}

void setBoutons(){
  btn1 = new Bouton("Button-S.png", "Button-S-push.png", 1085, 185, 110, 110, 1);
  btn1.ImageSetup();

  btn2 = new Bouton("Button-S.png", "Button-S-push.png", 1085, 185+120, 110, 110, 2);
  btn2.ImageSetup();

  btn3 = new Bouton("Button-S.png", "Button-S-push.png", 1085, 185+120+120, 110, 110, 3);
  btn3.ImageSetup();
}

void setup()
{
  /*********************************************SETUP JEU******************************/
  canBePush = false;
  size(1920, 1080);
  bg = loadImage("bg-big.png");
  fullScreen();
  setAllImages();
  setAllGears();
  setBoutons();
  cuckoo = new SoundFile(this, "cuckoo.wav");
  gear_clink = new SoundFile(this, "gear_clink.wav");
  running_gear = new SoundFile(this, "running_gear.wav");
  running_gear.loop();
  button_click = new SoundFile(this, "button_click.wav");
  imageMode(CENTER);
  frameRate(100);

/*********************************************SETUP CAM******************************/
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam_ = new Capture(this, videoWidth_, videoHeight_, "HD Pro Webcam C920");

    opencv_ = new OpenCV(this, videoWidth_, videoHeight_);
    flow_ = opencv_.flow;

    flow_.setPyramidScale(0.5); // default : 0.5
    flow_.setLevels(1); // default : 4
    flow_.setWindowSize(8); // default : 8
    flow_.setIterations(1); // default : 2
    flow_.setPolyN(3); // default : 7
    flow_.setPolySigma(1.5); // default : 1.5

    int m = 10;
    int w = 600;
    int h = 300;

    int x = m;
    int y = m;
    hotSpots_[0] = new HotSpot(x, y, w, h);

    x = videoWidth_ / 2 - w / 2;
    hotSpots_[1] = new HotSpot(x, y, w, h);

    x = videoWidth_ - m - w ;
    hotSpots_[2] = new HotSpot(x, y, w, h);

    x = m;
    y = videoHeight_ - m - h ;
    hotSpots_[3] = new HotSpot(x, y, w, h);

    x = videoWidth_ / 2 - w / 2;
    hotSpots_[4] = new HotSpot(x, y, w, h);

    x = videoWidth_ - m - w;
    hotSpots_[5] = new HotSpot(x, y, w, h);

    x = m;
    y = videoHeight_ - m - h/2 ;
    hotSpots_[6] = new HotSpot(x, y, w, h);

    x = videoWidth_ / 2 - w / 2;
    hotSpots_[7] = new HotSpot(x, y, w, h);

    x = videoWidth_ - m - w;
    hotSpots_[8] = new HotSpot(x, y, w, h);


    cam_.start();
  }
}

void draw()
{
  synchronized(this) {

    timeMS_ = millis();
    timeS_ = timeMS_ * 0.001;

    selectDelayS_ -= timeS_ - timeSOld_;




    if ( frames_[currentFrameIndex_] != null ) {

      //frames_[currentFrameIndex_].resize(640*scale,360*scale); // slow...

      frames_[currentFrameIndex_].loadPixels();
      fullFrame_.loadPixels();
      for (int j = 0; j < fullFrame_.height; j+=2) {
        for ( int i = 0; i < fullFrame_.width; i++ ) {
          int index_src = ( j / scale_ ) * frames_[currentFrameIndex_].width + ( i / scale_ );
          int index_dst = j * fullFrame_.width + i;
          fullFrame_.pixels[index_dst] = frames_[currentFrameIndex_].pixels[index_src];
        }
      }
      fullFrame_.updatePixels();

      tint(255, 255, 255, 255);
      image(fullFrame_, 0, 0);
      background(bg);
      mecanism();
      stroke(255, 0, 0);

      strokeWeight(1.);
      scale(scale_);
      //opencv_.drawOpticalFlow();
      drawHotSpots();

      detectHotSpots();

      first_ = false;
    }
  }

  timeSOld_ = timeS_;
}  

boolean detectHotSpots() {

  for ( int k = 0; k < 1; k++ ) {

    HotSpot hs = hotSpots_[k];

    int nb = 0;

    
    PVector p_average = new PVector(0., 0.);
    float ps_average = 0.0;

    int step = 10;
    float max_mag = 15;
    int io=-1, jo=-1;
    //=======================================
    for ( int j = 0; j < hs.h; j += step ) {
      for ( int i = 0; i < hs.w; i += step ) {
        PVector p = flow_.getFlowAt(hs.x+i, hs.y+j);
        float m = p.mag();
        if (m>max_mag){
          max_mag = m;
          
          io = i;
          mouseX = io*3;
          jo = j;
          mouseY = jo*3;
        }
        absolute_mag += m;
        
        p_average.add(p);
        nb++;
      }
      
    }
    
    absolute_mag /= nb;
    p_average.div(nb);
    float average_mag = p_average.mag();
    
    

    //=======================================
    for ( int j = 0; j < hs.h; j += step ) {
      for ( int i = 0; i < hs.w; i += step ) {
        PVector p = flow_.getFlowAt(hs.x+i, hs.y+j);
        ps_average += p.dot(p_average);
        nb++;
      }
    }
    ps_average /= nb;

    noFill();
    stroke(0, 0, 255);
    strokeWeight(2.);
    float x1 = hs.x + hs.w / 2.;
    float y1 = hs.y + hs.h / 2.;
    float x2 = x1 + p_average.x;
    float y2 = y1 + p_average.y;
    line(x1, y1, x2, y2);
    
    if(io>0 && jo>0){
      float x3 = hs.x + io;
      float y3 = hs.y + jo;
      circle(x3,y3,15);
      
    }
    

    boolean absolute_mag_ok = absolute_mag > detectAbsoluteMagMin_;
    boolean average_mag_ok = average_mag < detectAverageMagMax_;
    boolean ps_average_ok = ps_average < psAverageMax_;

    if ( selectDelayS_ < 0.) {

      if ( absolute_mag_ok ) {

        if ( average_mag_ok ) {

          if ( ps_average_ok ) {

            selectedHotSpotIndex_ = selectedHotSpotIndex_ == k ? -1 : k;
            selectDelayS_ = selectDelaySo_;
          }
        }
      }
    }
  }
  return true;
}


void drawHotSpots() {
  noFill();
  strokeWeight(1.);
  for ( int k = 0; k < 1; k++ ) {
    stroke(255, 0, 0);
    if ( ( selectedHotSpotIndex_ >= 0 ) && ( k == selectedHotSpotIndex_ ) ) {
      stroke(0, 255, 0);
      //print(hotSpots_[k].x);
      //print("                                                         ");
    }
    //rect(hotSpots_[k].x, hotSpots_[k].y, hotSpots_[k].w, hotSpots_[k].h);
  }
}

//============================
void captureEvent(Capture c) {

  synchronized(this) {

    c.read();
    //opencv.useColor(RGB);
    opencv_.useGray();
    opencv_.loadImage(cam_);
    opencv_.flip(OpenCV.HORIZONTAL);
    //opencv_.flip(OpenCV.VERTICAL);
    opencv_.calculateOpticalFlow();

    frames_[currentFrameIndex_] = opencv_.getSnapshot();
  }
}

//=================
void keyPressed() {
  if ( (keyCode == ESC) || ( keyCode == 'q' ) || ( keyCode == 'Q' )) {
    cam_.stop();
    exit();
  }
}


void mecanism() {

  pushMatrix();
  translate(1106, 597);
  image(lever_base, 0, 0, 225, 225);
  popMatrix();

  pushMatrix();
  translate(723, 423);
  image(horloge, 0, 0, 300, 300);
  popMatrix();

  pushMatrix();
  translate(723, 423);
  rotate(radians(angleRotateEgguille2));
  image(egguille2, 0, 0, 300, 300);
  popMatrix();

  pushMatrix();
  translate(723, 423);
  rotate(radians(angleRotateEgguille1));
  image(egguille1, 0, 0, 300, 300);
  popMatrix();

  pushMatrix();
  translate(482, 429);
  if(speedRotate >= 24.0 && speedRotate < 28.0){
    canBePush = true;
    image(btn_vert, 0, 0, 55, 55);
  }else{
    canBePush = false;
    image(btn_vert, 0, 0, 0, 0);
  }
  popMatrix();
  
  pushMatrix();
  translate(482, 429);
  if((speedRotate >= 9.6 && speedRotate < 24.0) || (speedRotate >= 28.0 && speedRotate < 36.0)){
    image(btn_orange, 0, 0, 55, 55);
  }else{
    image(btn_orange, 0, 0, 0, 0);
  }
  popMatrix();

  pushMatrix();
  translate(482, 429);
  if(speedRotate < 9.6 || speedRotate > 36.0){
    image(btn_rouge, 0, 0, 55, 55);
  }else{
    image(btn_rouge, 0, 0, 0, 0);
  }
  popMatrix();

  pushMatrix();
  if(motorGear.isDrag || rightGear.isDrag || middleGear.isDrag || is_finish){
    lever_cut.drag(false);
  }else{
    lever_cut.drag(true);
  }
  popMatrix();

  if(canBePush){
    btn1.onClick();
    btn2.onClick();
    btn3.onClick();
    answerIsGood = true;
    for(int i = 0; i<actuel.size(); i++){
      if(actuel.get(i) != reponse.get(i)){
        answerIsGood = false;
      }
    }
    if(answerIsGood == false){
      actuel = new IntList();

      btn1.reset();
      btn2.reset();
      btn3.reset();
    }
    if(answerIsGood && actuel.size() == 3){
      if(speedRotateEgguille1 < 300 && premier_tour == false){
        speedRotateEgguille1 = speedRotateEgguille1*1.2;
        speedRotateEgguille2 = speedRotateEgguille1*1.2;
        if(speedRotateEgguille1 > 300){
          premier_tour = true;
          if(cuckoo_played == false){
            cuckoo.play();
            cuckoo_played = true;
          }
        }
      }else{
        if(deuxieme_tour == false){
          speedRotateEgguille1 = speedRotateEgguille1/1.3;
          speedRotateEgguille2 = speedRotateEgguille1/1.3;
          if(speedRotateEgguille1 < 0.5){
            deuxieme_tour = true;
            is_finish = true;
            canBePush = false;
          }
        }else{
          if(minute() > minute){
            speedRotateEgguille1 = 0.7;
            speedRotateEgguille2 = 5;
            minute = minute();
          }else{
            speedRotateEgguille1 = 0;
            speedRotateEgguille2 = 0;
          }
        }
        
      }
      angleRotateEgguille1 += speedRotateEgguille1;
      angleRotateEgguille2 += speedRotateEgguille2;
      
    }
  }else{
    pushMatrix();
    translate(1085, 185);
    image(button, 0, 0, 110, 110);
    popMatrix();

    pushMatrix();
    translate(1085, 185+120);
    image(button, 0, 0, 110, 110);
    popMatrix();

    pushMatrix();
    translate(1085, 185+240);
    image(button, 0, 0, 110, 110);
    popMatrix();

    actuel = new IntList();

    btn1.reset();
    btn2.reset();
    btn3.reset();
    premier_tour = false;
    deuxieme_tour = false;
  }

  if(motorGear.isPlaced && rightGear.isPlaced){
    if(motorGear.isDrag || rightGear.isDrag){
      middleGear.drag(true, true, false);
    }else{
      middleGear.drag(true, true, true);
    }
  }else{
    if(motorGear.isDrag || rightGear.isDrag || lever_cut.isDrag){
      middleGear.drag(true, false, false);
    }else{
      middleGear.drag(true, false, false);
    }
  }
  if(motorGear.isPlaced && middleGear.isPlaced){
    if(motorGear.isDrag || middleGear.isDrag || lever_cut.isDrag){
      rightGear.drag(true, true, false);
    }else{
      rightGear.drag(true, true, true);
    }
  }else{
    if(motorGear.isDrag || middleGear.isDrag || lever_cut.isDrag){
      rightGear.drag(false, true, false);

    }else{
      rightGear.drag(false, true, true);
    }
  }
  if(middleGear.isDrag || rightGear.isDrag || lever_cut.isDrag){
    motorGear.drag(true, true, false);

  }else{
    motorGear.drag(true, true, true);
  }

  running_gear.amp(volume);

  angleRotate += speedRotate;
}

//fontion qui fait un engrenage!
void makeGear(PImage img, float x, float y, float scale_x, float scale_y, int direction, boolean rotate) {
  pushMatrix();
  translate(x, y);
  if(rotate){
    rotate(radians(angleRotate * direction));
  }
  image(img, 0, 0, scale_x, scale_y);
  popMatrix();
}
