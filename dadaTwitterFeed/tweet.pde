class tweet{
  
  String texte;
  float posX, posY;
  
  tweet(String texte){
    this.texte = texte;
    
    
    
  }
  
  void draw(){
    textSize(32);
    text(texte, 10, 30);
    
    
  }
  
  
}
