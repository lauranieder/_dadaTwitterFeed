class tweetPoem{
  
  String texte;
  float posX, posY, size, speed;
  
  tweetPoem(String texte){
    this.texte = texte;
    posX = random(0,width);
    posY = random(0,height);
    size = random(10,30);
    speed = random(0.1, 1);
    println("New tweet create : "+posX+","+posY);
    
  }
  
  void draw(){
    fill(255);
    textSize(size);
    text(texte, posX, posY);
    updatePos();
  }

void updatePos(){
  posX -=speed;
}  
}
