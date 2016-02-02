class tweetPoem {

  String texte;
  float posX, posY, size, speed;
  PFont  font;
  boolean uppercase = false;
  int id;
  boolean fullSeen = false;
  float posXavoid;
  tweetPoem(String _texte, int _id, float _posXavoid) {
    id = _id;
    texte = _texte;
    posXavoid = _posXavoid;
    size = random(40, 70);
    
    if(frameCount < 5){
      posX = random(width/2, width);
      //DOING FULLSCREEEEEEN
    }else{
      
      posX = random(width+50, width+200);
    }
    
    posY = random(size, lineHeight);
    if(posXavoid >-1){
     int i = 0;
    while(posY >(posXavoid-size) && posY < posXavoid+size && i<10){
      //println("on the same spot : reprocess...");
       posY = random(size, lineHeight);
      i++;
    }

    }
    speed = random(0.5, 3); //0.5, 1
    int randomFont = floor(random(0, fonts.length));
    texte = clean(texte);

    font = fonts[randomFont];
    if (randomFont == 2) {
      uppercase = true;
      size = size*0.8;
      texte = texte.toUpperCase();
    }
    //println("New tweet create : "+posX+","+posY);
  }
  

  void draw() {
   //println("TWEET N°"+id+" draw");
   
    fill(255);
    textFont(font);
    textSize(size);

    text(texte, posX, (id*lineHeight)+posY+offsetT);
    rect(posX, (id*lineHeight)+posY+offsetT, 10,10);

    updatePos();
  }

  void updatePos() {
    posX -=speed;
    //println(frameCount +" TWEET N°"+id+" draw  "+posX+"/"+width+"  ,  "+posY+"/"+height+"   "+texte);
    float textW = textWidth(texte);
    if ((posX+textW)<width && fullSeen == false) {
      //println("TEXTE EN ENTIER :"+id);
      fullSeen = true;
      createNewTweet();
    }else if(posX+textW<0){
      removeTweetFromDisplay(this);
    }
  }
  
  void createNewTweet(){
    if(bufferTweetPoems.size() > 0){
      String newMsg = bufferTweetPoems.get(0);
      bufferTweetPoems.remove(0); 
      displayTweetPoems.add(new tweetPoem(newMsg, id, posX));
    }
  }
  String clean(String msgToClean) {

    String check1 ="\n";
    String check2 ="\r";
    String check3 ="http://";
    String check4 ="https://";
    //char check2 = '\\';
    if ( msgToClean.indexOf(check1) != -1 ) {
      //println("_________________found check1   "+msgToClean);
      //msgToClean = msgToClean.substring(0, msgToClean.indexOf(check1));
      msgToClean = msgToClean.replace(check1,"");
    } else {
      //println("nothing found");
    }

    if ( msgToClean.indexOf(check2) != -1 ) {
      //println("_________________found check2  "+msgToClean);
      //msgToClean = msgToClean.substring(0, msgToClean.indexOf(check2));
      msgToClean = msgToClean.replace(check2,"");
    } else {
      //println("nothing found");
    }
    
    if ( msgToClean.indexOf(check3) != -1 ) {
      //println("_________________found check2  "+msgToClean);
      String msgSplit[] = split(msgToClean,' ');
      msgToClean = "";
      for(int i =0;i<msgSplit.length;i++){
        if(msgSplit[i].indexOf(check3) != -1){
          
        }else{
          msgToClean += msgSplit[i];
        } 
      }
      
    }
    
    if ( msgToClean.indexOf(check4) != -1 ) {
      //println("_________________found check2  "+msgToClean);
     String msgSplit[] = split(msgToClean,' ');
      msgToClean = "";
      for(int i =0;i<msgSplit.length;i++){
        if(msgSplit[i].indexOf(check4) != -1){
          
        }else{
          msgToClean += msgSplit[i]+" ";
        } 
      }
      
    }

    return msgToClean;
  }
}