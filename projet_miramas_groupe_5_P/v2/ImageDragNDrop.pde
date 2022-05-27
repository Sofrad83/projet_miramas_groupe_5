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
        if(this.isDrag){
          image(this.image, mouseX, mouseY, this.w, this.h);
          setHitboxPosition(mouseX, mouseY);
          setImagePosition(mouseX, mouseY);
        }
        if(isCollide(this.ix, this.iy, this.hx, this.hy, this.hw, this.hh) && this.isPlaced == false && canBePlaced){
            this.isPlaced = true;
            this.isDrag = false;
            gear_clink.play();
          }
        if(isCollide(mouseX, mouseY, this.sx, this.sy, this.w, this.h)){
          if(!this.isPlaced){
            this.isDrag = true;
          }
          image(this.image, mouseX, mouseY, this.w, this.h);
          setHitboxPosition(mouseX, mouseY);
          setImagePosition(mouseX, mouseY);
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