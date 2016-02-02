class tweetPoem {

  String texte;
  float posX, posY, size, speed;
  PFont  font;
  boolean uppercase = false;
  int id;
  boolean fullSeen = false;
  tweetPoem(String _texte, int _id) {
    id = _id;
    texte = _texte;
    size = random(10, 30);
    if(frameCount < 5){
      posX = random(width/2, width);
      //DOING FULLSCREEEEEEN
    }else{
      
      posX = random(width+50, width+200);
    }
    
    posY = random(size, lineHeight);


    speed = random(0.5, 1);
    int randomFont = floor(random(0, fonts.length));
    texte = clean(texte);

    font = fonts[randomFont];
    if (randomFont == 2) {
      uppercase = true;
      size = size*0.8;
      texte = texte.toUpperCase();
    }
    println("New tweet create : "+posX+","+posY);
  }
  String clean(String msgToClean) {

    String check1 ="\n";
    String check2 ="\r";
    //char check1 = '\\';
    //char check2 = '\\';
    if ( msgToClean.indexOf(check1) != -1 ) {
      println("_________________found check1   "+msgToClean);
      msgToClean = msgToClean.substring(0, msgToClean.indexOf(check1));
    } else {
      println("nothing found");
    }

    if ( msgToClean.indexOf(check2) != -1 ) {
      println("_________________found check2  "+msgToClean);
      msgToClean = msgToClean.substring(0, msgToClean.indexOf(check2));
    } else {
      println("nothing found");
    }

    return msgToClean;
  }

  void draw() {
    fill(255);
    textFont(font);
    textSize(size);

    text(texte, posX, (id*lineHeight)+posY+offsetT);

    updatePos();
  }

  void updatePos() {
    posX -=speed;

    float textW = textWidth(texte);
    if ((posX+textW)<width && fullSeen == false) {
      println("TEXTE EN ENTIER :"+id);
      fullSeen = true;
      createNewTweet();
    }
  }
  
  void createNewTweet(){
    if(bufferTweetPoems.size() > 0){
      String newMsg = bufferTweetPoems.get(0);
      bufferTweetPoems.remove(0); 
      displayTweetPoems.add(new tweetPoem(newMsg, id));
    } 
  }
}