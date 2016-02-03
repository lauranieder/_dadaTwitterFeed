class tweetPoem {

  String texte;
  float posX, posY, size, speed, textAscent, speedAvoid;
  PFont  font;
  boolean uppercase = false;
  int id;
  boolean fullSeen = false;
  float posYavoid, sizeAvoid;
  tweetPoem(String _texte, int _id, float _posYavoid, float _sizeAvoid, float _speedAvoid) {
    id = _id;
    texte = _texte;
    posYavoid = _posYavoid;
    sizeAvoid = _sizeAvoid;
     speedAvoid = _speedAvoid;
    size = random(40, 70);
   
    
     texte = clean(texte);
 int randomFont = floor(random(0, fonts.length));
    font = fonts[randomFont];
    if (randomFont == 2) {
      uppercase = true;
      size = size*0.8;
      if(randomFont == 2){
      texte = texte.toUpperCase();
      }
    }
     textSize(size);
       textAscent= textAscent();
       println("size :"+size+" textAscent: "+textAscent);
    
    if (frameCount < 5) {
      posX = random(width/2, width);
      //DOING FULLSCREEEEEEN
    } else {

      posX = random(width+50, width+200);
    }
     posY = random(size, lineHeight);
    
      speed = random(0.5, 1); //0.5, 1
      
      
     
   
      //Si il va plus vite que l'objet d'avant
    if(speed > speedAvoid && speedAvoid>-1){
       //Si on connait la position de l'object d'avant
      if (posYavoid >-1 && sizeAvoid >-1) {
      float oldposY = posY;
      
      //int i = 0;
      //while (posY >(posXavoid-sizeAvoid) && posY < posXavoid+size && i<10) {
      //  //println("on the same spot : reprocess...");
      //  posY = random(size, lineHeight);
      //  i++;
      //}
      
      if(posY >(posYavoid-sizeAvoid) && posY < posYavoid+size){
        if(posYavoid+size>lineHeight){
           println("not enough space after");
          posY = random(size, posYavoid-sizeAvoid);
        }else if(posYavoid-sizeAvoid<size){
          println("not enough space before");
          posY = random(posYavoid+size, lineHeight);
        }else{
          println("enough space both");
        int test = round(random(0,1));
          if(test == 0){
            posY = random(size, posYavoid-sizeAvoid);
            
          }else{
            posY = random(posYavoid+size, lineHeight);
          }
        }
        println("on the same spot : reprocess..."+oldposY+",   "+posY);
      }
      
    }
    }
    
   
    
    //println("New tweet create : "+posX+","+posY);
  }


  void display() {
    //println("TWEET N°"+id+" draw");
    pushStyle();
    fill(255);
    stroke(255);
    textFont(font);
    textSize(size);
    //line(0, offsetT+(lineHeight*i), width, offsetT+(lineHeight*i));
    
    text(texte, Math.round(posX), Math.round((id*lineHeight)+posY+offsetT));
    popStyle();
    if(debug){
       pushStyle();
        fill(255,0,0);
        stroke(255,0,0);
        strokeWeight(1);
        text(id, Math.round(posX-20), Math.round((id*lineHeight)+posY+offsetT));
        if (posYavoid >-1 && sizeAvoid >-1) {
          float textW = textWidth(texte);
          if ((posX+textW)>width) {
     
   
          line(0,Math.round((id*lineHeight)+(posYavoid-sizeAvoid)+offsetT),width, Math.round((id*lineHeight)+(posYavoid-sizeAvoid)+offsetT));
          stroke(0,255,0);
          line(0,Math.round((id*lineHeight)+(posYavoid)+offsetT),width, Math.round((id*lineHeight)+(posYavoid)+offsetT)); 
           }
        }
        popStyle();
    }
    //rect(posX, (id*lineHeight)+posY+offsetT, 10,10);

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
    } else if (posX+textW<0) {
      removeTweetFromDisplay(this);
    }
  }

  void createNewTweet() {
    if (bufferTweetPoems.size() > 0) {
      String newMsg = bufferTweetPoems.get(0);
      bufferTweetPoems.remove(0); 
      displayTweetPoems.add(new tweetPoem(newMsg, id, posY, textAscent, speed));
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
      msgToClean = msgToClean.replace(check1, "");
    } else {
      //println("nothing found");
    }

    if ( msgToClean.indexOf(check2) != -1 ) {
      //println("_________________found check2  "+msgToClean);
      //msgToClean = msgToClean.substring(0, msgToClean.indexOf(check2));
      msgToClean = msgToClean.replace(check2, "");
    } else {
      //println("nothing found");
    }

    if ( msgToClean.indexOf(check3) != -1 ) {
      //println("_________________found check2  "+msgToClean);
      String msgSplit[] = split(msgToClean, ' ');
      msgToClean = "";
      for (int i =0; i<msgSplit.length; i++) {
        if (msgSplit[i].indexOf(check3) != -1) {
        } else {
          msgToClean += msgSplit[i];
        }
      }
    }

    if ( msgToClean.indexOf(check4) != -1 ) {
      //println("_________________found check2  "+msgToClean);
      String msgSplit[] = split(msgToClean, ' ');
      msgToClean = "";
      for (int i =0; i<msgSplit.length; i++) {
        if (msgSplit[i].indexOf(check4) != -1) {
        } else {
          msgToClean += msgSplit[i]+" ";
        }
      }
    }

    return msgToClean;
  }
}