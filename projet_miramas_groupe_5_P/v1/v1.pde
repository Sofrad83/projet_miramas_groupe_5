PImage bg;
PImage lever_base, button, buttonPush;
float angleRotate = 0.0;
ImageDragNDrop middleGear, motorGear, rightGear;
ImageRotate lever_cut;

//Création d'une classe ImageDragNDrop
class ImageDragNDrop{
  String path;
  PImage image;

  boolean isPlaced;
  boolean isDrag;

  /*
  * Position du drag
  */
  //Position hitbox 
  float sx; //x
  float sy; //y

  //Position img
  float ix; //x
  float iy; //y

  //Position de base de l'img
  float bx;
  float by;

  float w; //width
  float h; //height

  /*
  * Position de l'objet placé
  */
  //Position hitbox
  float hx; //x
  float hy; //y
  float hw; //width
  float hh; //height

  //Position img
  float px;
  float py;

  int direction; //sens de rotation de l'objet placé

  /*
  * imagePath => chemin de l'image
  * x, y => coordonnées de l'image à drag and drop
  * w, h => width et height de l'image à drag and drop
  * hx, hy => coordonnées de l'image placé
  * hw, hh => width et height de la hitbox pour placer l'image
  */
  public ImageDragNDrop(String imagePath, float x, float y, float w, float h, float px, float py, float hw, float hh, int direction){
    this.path = imagePath;

    this.sx = x-(w/2);
    this.sy = y-(h/2);

    this.ix = x;
    this.iy = y;

    this.bx = x;
    this.by = y;

    this.w = w;
    this.h = h;

    this.hx = px-(hw/2);
    this.hy = py-(hh/2);
    this.hw = hw;
    this.hh = hh;
    this.px = px;
    this.py = py;

    this.isPlaced = false;

    this.direction = direction;
  }

  void ImageSetup(){
    image = loadImage(path);
    image(this.image, this.ix, this.iy, this.w, this.h);
  }

  void drag(boolean rotate, boolean canBePlaced, boolean canBeDrag){
    if(this.isPlaced){
      makeGear(this.image, this.px, this.py, this.w, this.h, direction, rotate);
    }else{
      if(canBeDrag){
        if(isCollide(mouseX, mouseY, this.sx, this.sy, this.w, this.h)){
          if(mousePressed){
            image(this.image, mouseX, mouseY, this.w, this.h);
            setHitboxPosition(mouseX, mouseY);
            setImagePosition(mouseX, mouseY);
            this.isDrag = true;
          }else if(isCollide(this.ix, this.iy, this.hx, this.hy, this.hw, this.hh) && this.isPlaced == false && canBePlaced){
            this.isPlaced = true;
            this.isDrag = false;
          }else{
            image(this.image, this.ix, this.iy, this.w, this.h);
            setHitboxPosition(bx, by);
            setImagePosition(bx, by);
            this.isDrag = false;
          }
        }else{
          image(this.image, this.ix, this.iy, this.w, this.h);
          setHitboxPosition(bx, by);
          setImagePosition(bx, by);
          this.isDrag = false;
        }
      }else{
        image(this.image, this.ix, this.iy, this.w, this.h);
        setHitboxPosition(bx, by);
        setImagePosition(bx, by);
        this.isDrag = false;
      }
    }
  }

  void setHitboxPosition(float x, float y){
    this.sx = x-(this.w/2);
    this.sy = y-(this.h/2);
  }

  void setImagePosition(float x, float y){
    this.ix = x;
    this.iy = y;
  }
}

class ImageRotate{
  String path;
  PImage image;
  boolean isDrag;

  /*
  * Position du drag
  */
  //Position hitbox 
  float sx; //x
  float sy; //y
  float sw; //width
  float sh; //height

  //Position img
  float x; //x
  float y; //y

  float w; //width
  float h; //height

  float angleRotate;
  int mouse_x;

  public ImageRotate(String imagePath, float x, float y, float w, float h, float sx, float sy, float sw, float sh){
    this.path = imagePath;

    this.sx = sx;
    this.sy = sy;
    this.sw = sw;
    this.sh = sh;

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.angleRotate = 0.0;
    this.isDrag = false;
  }

  void ImageSetup(){
    image = loadImage(path);
    image(this.image, this.x, this.y, this.w, this.h);
  }

  void drag(){
    if(isCollide(mouseX, mouseY, this.sx, this.sy, this.sw, this.sh)){
      if(mousePressed){
        this.angleRotate = angleRotate;
        if(this.x-50 > mouseX){
          this.angleRotate -= 2;
        }else if(this.x+50 < mouseX){
          this.angleRotate += 2;
        }
        setHitboxPosition(mouseX, mouseY);
        pushMatrix();
        translate(this.x, this.y);
        rotate(radians(angleRotate));
        image(this.image, 0, 0, this.w, this.h);
        popMatrix();
        this.mouse_x = mouseX;
        this.isDrag = true;
      }else{
        translate(this.x, this.y);
        rotate(radians(angleRotate));
        image(this.image, 0, 0, this.w, this.h);
        setHitboxPosition(this.x, this.y);
        this.isDrag = false;
      }
    }else{
      translate(this.x, this.y);
      rotate(radians(angleRotate));
      image(this.image, 0, 0, this.w, this.h);
      setHitboxPosition(this.x, this.y);
      this.isDrag = false;
    }
  }

  void setHitboxPosition(float x, float y){
    this.sx = x-(this.sw/2);
    this.sy = y-(this.sh/2);
  }
}

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
  rightGear = new ImageDragNDrop("Steampunk-Gear_3.png", 680, 100, 190, 190, 476, 464, 200, 200, 1);
  rightGear.ImageSetup();
  middleGear = new ImageDragNDrop("engrenage.png", 680, 250, 190, 190, 320, 420, 190, 190, -1);
  middleGear.ImageSetup();
  motorGear = new ImageDragNDrop("Steampunk-Gear_4.png", 680, 400, 190, 190, 177, 435, 200, 200, 1);
  motorGear.ImageSetup();

  lever_cut = new ImageRotate("Lever_cut_2.png", 475, 305, 107, 107, 475, 305, 107, 107);
  lever_cut.ImageSetup();
}

void setAllImages(){
  lever_base = loadImage("Lever_base.png");
  //lever_cut = loadImage("Lever_cut.png");
  button = loadImage("Button-S.png");
  buttonPush = loadImage("Button-S-push.png");
}

void setup()
{
  size(800,550);
  bg = loadImage("bg.png");
  setAllImages();
  setAllGears();
  imageMode(CENTER);
  frameRate(100);
}

void draw()
{
  background(bg);
  mecanism();
}  

void mecanism() {

  pushMatrix();
  translate(475, 305);
  image(lever_base, 0, 0, 107, 107);
  popMatrix();
  /*pushMatrix();
  translate(475, 305);
  rotate(radians(angleRotate));
  image(lever_cut, 0, 0, 107, 107);
  popMatrix();*/
  
  for (int i = 0; i < 3; i = i+1) {
    pushMatrix();
    translate(463, 95 + i*60);
    image(button, 0, 0, 55, 55);
    popMatrix();
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
      middleGear.drag(true, false, true);
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

  lever_cut.drag();

  angleRotate += 0.5;
}

void makeGear(PImage img, float x, float y, float scale_x, float scale_y, int direction, boolean rotate) {
  pushMatrix();
  translate(x, y);
  if(rotate){
    rotate(radians(angleRotate * direction));
  }
  image(img, 0, 0, scale_x, scale_y);
  popMatrix();
}
