class Bouton{
  String path_unclicked;
  String path_clicked;
  PImage clicked, unclicked;
  int num;


  //Position img et hitbox
  float x; //x
  float y; //y
  float w;
  float h;

  //img unclicked
  float uw;
  float uh;

  //img clicked
  float cw; //width
  float ch; //height

  boolean isClicked = false;

  public Bouton(String path_unclicked, String path_clicked, float x, float y, float w, float h, int num)
  {
    this.path_unclicked = path_unclicked;
    this.path_clicked = path_clicked;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.uw = w;
    this.uh = h;
    this.cw = 0;
    this.ch = 0;
    this.num = num;
  }

  void ImageSetup(){
    this.clicked = loadImage(this.path_clicked);
    image(this.clicked, this.x, this.y, this.w, this.h);
    this.unclicked = loadImage(this.path_unclicked);
    image(this.unclicked, this.x, this.y, this.w, this.h);
  }

  void onClick(){

    if(isCollide(mouseX, mouseY, this.x-this.w/2, this.y-this.h/2, this.w, this.h)){
        if(isClicked == false){
            isClicked = true;
            actuel.append(this.num);
            if(!button_click.isPlaying()){
            button_click.play();
            }
        }
    }
    if(isClicked){
      this.uw = 0;
      this.uh = 0;
      this.cw = this.w;
      this.ch = this.h;
    }else{
      this.uw = this.w;
      this.uh = this.h;
      this.cw = 0;
      this.ch = 0;
    }
    pushMatrix();
    translate(this.x, this.y);
    image(this.clicked, 0, 0, this.cw, this.ch);
    popMatrix();
    pushMatrix();
    translate(this.x, this.y);
    image(this.unclicked, 0, 0, this.uw, this.uh);
    popMatrix();
    
  }

  void reset(){
    isClicked = false;
  }

}