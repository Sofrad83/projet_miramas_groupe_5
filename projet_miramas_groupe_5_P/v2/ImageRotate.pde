class ImageRotate{
  String path;
  PImage image;
  boolean isDrag;

  /*
  * Position du drag
  */
  //Position hitbox 
  float rx; //x
  float ry; //y
  float rw; //width
  float rh; //height

  float lx; //x
  float ly; //y
  float lw; //width
  float lh; //height


  //Position img
  float x; //x
  float y; //y

  float w; //width
  float h; //height

  float angleRotate;
  int mouse_x;

  public ImageRotate(String imagePath, float x, float y, float w, float h){
    this.path = imagePath;

    this.rx = x;
    this.ry = y-h*0.5;
    this.rw = w*0.75;
    this.rh = h;

    this.lx = x-w*0.75;
    this.ly = y-h*0.5;
    this.lw = w*0.75;
    this.lh = h;

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.angleRotate = -40.0;
    this.isDrag = false;
  }

  void ImageSetup(){
    image = loadImage(path);
    image(this.image, this.x, this.y, this.w, this.h);
  }

  void drag(boolean canBeDrag){
    rect(rx, ry, rw, rh);
    rect(lx, ly, lw, lh);
    if(isCollide(mouseX, mouseY, this.rx, this.ry, this.rw, this.rh)){
      if(canBeDrag){
        this.angleRotate = angleRotate;
        this.angleRotate += 2;
        if(volume < 1){
        volume += 0.003333;
        }
        speedRotate = angleRotate/10;
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
        this.isDrag = false;
      }
    }else if(isCollide(mouseX, mouseY, this.lx, this.ly, this.lw, this.lh)){
        if(canBeDrag){
        this.angleRotate = angleRotate;
        this.angleRotate -= 2;
        if(volume > -1){
        volume -= 0.003333;
        }
        speedRotate = angleRotate/10;
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
        this.isDrag = false;
      }
        

    }else{
      translate(this.x, this.y);
      rotate(radians(angleRotate));
      image(this.image, 0, 0, this.w, this.h);
      this.isDrag = false;
    }
  }
}
