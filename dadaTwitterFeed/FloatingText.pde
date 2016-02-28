class FloatingText {
  int x, y, w, h;
  int ox, oy;
  int s;
  String txt;

  Boolean active = false;
  Boolean clipTrigger = false;
  Boolean mouseIn = false;

  FloatingText(int x, int y, String txt, int s) {
    this.x = x;
    this.y = y;
    this.txt = txt;
    this.s = s;
     textFont(fonts[2]);
    textSize(s); 
    println(s);
    println(textAscent());
    this.w = int(textWidth(txt));
    println(w);
    this.h = s; 
    println("zone created : "+this.x + "_" + this.y + "_" + this.w + "_" + this.h+"_"+this.txt+"_"+this.s);
  } 

  void draw() {
    // FILL 
    noFill();
    stroke(255,0,0);
    rect(x, y, w, h);
    fill(255,0,0);
    textFont(fonts[2]);
    textSize(s);
    textAlign(CENTER, CENTER);
    text(txt, x + w/2, y + h/2 -10);

    
  } 

  
  
   //Si on est sur la case
  boolean isRollover(int pX, int pY) {
    //sur la case ou pas
    boolean over = pX >= x && pX < x + w && pY >= y && pY < y + h ; 
      if (over) {
        
          mouseIn = true;
          active = !active;
        
      //if not over
      }else{
        if (mouseIn) {
          mouseIn = false;
        }
      }
      return over;

  }

  void drag(int px, int py) {
    x = px + ox;
    y = py + oy;
  }

  void click(int px, int py) {
    if (isRollover(px, py)) {
      ox = x - px;
      oy = y - py;
    }
  }
}