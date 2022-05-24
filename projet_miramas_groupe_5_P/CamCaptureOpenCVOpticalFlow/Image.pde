class ImageRotate {
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

  public ImageRotate(String imagePath, float x, float y, float w, float h, float sx, float sy, float sw, float sh) {
    this.path = imagePath;

    this.sx = sx;
    this.sy = sy;
    this.sw = sw;
    this.sh = sh;

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.angleRotate = -40.0;
    this.isDrag = false;
  }

  void ImageSetup() {
    image = loadImage(path);
    image(this.image, this.x, this.y, this.w, this.h);
  }

  void dragrot(boolean canBeDrag) {
    if (isCollide(mouseX, mouseY, this.sx, this.sy, this.sw, this.sh)) {
      if (canBeDrag) {
      //if (max_mag>30) {
        this.angleRotate = angleRotate;
        if (this.x-50 > mouseX) {
          this.angleRotate -= 2;
          if(volume > -1){
            volume -= 0.003333;
          }
        } else if (this.x+50 < mouseX) {
          this.angleRotate += 2;
           if(volume < 1){
            volume += 0.003333;
          }
        }
        speedRotate = angleRotate/10;
        setHitboxPosition(mouseX, mouseY);

        translate(this.x, this.y);
        rotate(radians(angleRotate));
        image(this.image, 0, 0, this.w, this.h);
        //this.mouse_x = mouseX;
        this.isDrag = true;
      } else {
        translate(this.x, this.y);
        rotate(radians(angleRotate));
        image(this.image, 0, 0, this.w, this.h);
        setHitboxPosition(this.x, this.y);
        this.isDrag = false;
      }
    } else {
      translate(this.x, this.y);
      rotate(radians(angleRotate));
      image(this.image, 0, 0, this.w, this.h);
      setHitboxPosition(this.x, this.y);
      this.isDrag = false;
    }
  }

  void setHitboxPosition(float x, float y) {
    this.sx = x-(this.sw/2);
    this.sy = y-(this.sh/2);
  }
}
