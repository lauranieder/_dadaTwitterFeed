import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import twitter4j.conf.*; 
import twitter4j.api.*; 
import twitter4j.*; 
import java.util.*; 

import twitter4j.*; 
import twitter4j.api.*; 
import twitter4j.auth.*; 
import twitter4j.conf.*; 
import twitter4j.json.*; 
import twitter4j.management.*; 
import twitter4j.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class dadaTwitterFeed extends PApplet {






ConfigurationBuilder   cb;
Query query;
Twitter twitter;

/*eviter qu'ils puissent se mettre exactement o\u00f9 \u00e9tait l'autre tweet d'avant
/*enlever les retweet*/

int sqrH;
int sqrW;
int nbW = 6;
int nbH = 6;
int offsetT = 100;//top
int offsetB = 0;//bottom

int displayNb = 5;
int requestedNb = 60;
int lineHeight;
PShape SSRSRG, arte, rsi, rsr, rss;

ArrayList<String> bufferTweetPoems;
ArrayList<tweetPoem> displayTweetPoems;
tweetPoem[] tweetPoems;
PFont[] fonts;
//PFont font = loadFont("SteelfishRg-Regular-30.vlw"); 

boolean debug = false;
boolean editable = false;
boolean retweet = false;
boolean glitchall = false;
int glitchNB = 1;
 int glitchDuration = 15;
 int glitchDelay = 450;
  int glitchTime = 0;
  int glitchTimeDelay = 0;
  
// FloatingText MANAGER ////////////////////////////////////////////////////////
final String FILE_PLAYER = "zone_setup.txt";// fichier de position des zones
public ArrayList<FloatingText> zones; //listes des zones
FloatingText activeZone; //zone active

public void setup() { 
  
  background(0);
  
  sqrH = sqrW= height/nbH;
  lineHeight = floor((height-offsetT-offsetB)/displayNb);
  tweetPoems = new tweetPoem[displayNb];
  bufferTweetPoems = new ArrayList<String>();
  displayTweetPoems = new ArrayList<tweetPoem>();
  fonts = new PFont[4];
  fonts[0] = loadFont("SteelfishRg-Regular-60.vlw"); 
  fonts[1] = loadFont("BebasNeueRegular-60.vlw");
  fonts[2] = loadFont("BrandonGrotesque-Medium-60.vlw"); 
  fonts[3] = loadFont("BebasNeueBold-70.vlw"); 

  //SSRSRG = loadShape("SSRSRG.svg");
  //SRF = loadShape("SRF.svg");
  //SRF = loadShape("SRF.svg");
  //SRF = loadShape("SRF.svg");
  //SRF = loadShape("SRF.svg");

  //Acreditacion
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("2qMiURIx98A0ZGrE0oO14UpUQ");
  cb.setOAuthConsumerSecret("VdbqlTx0uOBS0NCPgVRdUqtgFOKP8idiH8dNLpAYazmfzv2lVx");
  cb.setOAuthAccessToken("1546407708-6Jou8lWT0m4ISQ2xdeLKgcXLz1jsaUEbCrF0uUn");
  cb.setOAuthAccessTokenSecret("97zUR7ocCovwKoJO8amsWfCGja21l2fhTIenU03FwSsez");

  //Make the twitter object and prepare the query
  twitter = new TwitterFactory(cb.build()).getInstance();

  println("------ Commandes ------");
  println("- key +        addFloatingText");
  println("- key s        save");
  println("- key l        loadZones");

  //FloatingText MANAGER //////////////////////////////////////////////////////////
  zones = new ArrayList();
  
  loadZones(FILE_PLAYER);
  queryTwitter();
}

public void queryTwitter() {
  //BUSCAR NUEVO TWITTER
  query = new Query("#dadadata");
  query.setCount(requestedNb);
  try {
    println("_____________PROCESSING TWEETS____________");
    println("_____________requested : "+requestedNb+"____________");
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    int i = 0;
    int j = 0;
    for (Status tw : tweets) {
      String msg = tw.getText();
      if (!retweet && checkRetweet(msg)) {
        println("TWEET N\u00b0 "+i+" removed because retweet");
      } else {

        if (displayTweetPoems.size()>displayNb-1) {
          bufferTweetPoems.add(msg);
          println("TWEET N\u00b0 "+i+" added to buffer");
        } else {
          displayTweetPoems.add(new tweetPoem(msg, j, -1, -1, -1));
          println("TWEET N\u00b0 "+i+" added to display");
          j++;
        }
      }
      i++;
    }
    println("display/ "+displayTweetPoems.size()+"     buffer/"+bufferTweetPoems.size());
    println("___________________________________________");
    if (bufferTweetPoems.size()<20) {
      requestedNb +=10; //next request will ask for more tweets
    } else if (bufferTweetPoems.size()>40) {
      requestedNb -=10; //next request will ask for less tweets
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}
//void draw() {
// for(int i=0; i<4; i++) {
//   drawRoutine();
// }
//}
public void draw() {

  background(0);
  fill(198, 87, 79);
  textFont(fonts[2]);
  textSize(50);
  manageGlitch();
  if (!editable) {
    noCursor();
  } else {
    cursor();
  }
  for (FloatingText a : zones) {
    if (a.isRollover(mouseX, mouseY)) {
      //zoneMsg += a.id+",";
      //activeMsg += a.active+",";
    }

    a.draw();
  }
  text("Next glitch in :  "+glitchTimeDelay+" / "+glitchDelay,200,50);
  text("Glitch :  "+glitchall, 200,100);
  //text("#dada", 660-20,204+10); //660+10,204+60+10
  //text("data", 790-10,164); //790+20,164+60+10
  //text("Die Wache", 350+20,420+60+10); //538+20,464+60+10
  // textSize(55);
  //text("La Garde", 126+45,500+60+25); //826+45,542+60+25
  //textSize(39);
  //text("www.", 700,600-40); //817+20,740+40
  //text("data-data", textWidth("www.")+704,600);
  //text(".net", textWidth("www.dada-data")+700,600+30);

  /*text("#dada", 660+10,204+60+10);
   text("data", 790+20,164+60+10);
   text("Die Wache", 538+20,464+60+10);
   textSize(55);
   text("La Garde", 826+45,542+60+25);
   textSize(40);
   text("www.data-data.net", 817+20,740+40);*/

 //background(0);
 //fill(198,87,79);
 //textFont(fonts[2]);
 //textSize(50);
 //noCursor();
 //text("#dada", 660-20,204+10); //660+10,204+60+10
 //text("data", 790-10,164); //790+20,164+60+10
 //text("Die Wache", 350+20,420+60+10-30); //538+20,464+60+10
  
 
 // textSize(55);
 //text("La Garde", 126+45,500+60+25); //826+45,542+60+25
 //textSize(39);
 //text("www.", 700,600-40); //817+20,740+40
 //text("data-data", textWidth("www.")+704,600);
 //text(".net", textWidth("www.dada-data")+700,600+30);
 ////
 // textSize(30);
 //text("Prenez une bo\u00eete !", 126+45,500+60+25+30); 
 // text("Nehmen Sie eine Schachtel!", 350+20,420+60+10+0);

  if (bufferTweetPoems.size() < 5) {
    queryTwitter();
  }
  stroke(255);
  fill(0);
  pushStyle();
  if (debug) {
    for (int i = 0; i<displayNb+1; i++) { 
      fill(255, 255, 255);
      stroke(255, 255, 255);
      strokeWeight(4);
      line(0, offsetT+(lineHeight*i), width, offsetT+(lineHeight*i));
    }
    
  }
  popStyle();

  for (int i = 0; i<displayTweetPoems.size (); i++) {
    //println("TWEET N\u00b0"+i+" draw");
    displayTweetPoems.get(i).display();
  }
}

public void removeTweetFromDisplay(tweetPoem poem) {

  displayTweetPoems.remove(poem);
}


public void keyPressed() {

  if (key == ' ') {
    debug = !debug;
  } else if (key == 'k') {
    println("display/ "+displayTweetPoems.size()+"     buffer/"+bufferTweetPoems.size());
  } else if (key == 'e') {
    editable = !editable;
  } else if (key == '+') addFloatingText();  
  else if (key == 's') {
    saveZones(FILE_PLAYER);
    loadZones(FILE_PLAYER);
  } else if(key == 'g'){
    glitchall = !glitchall;
    glitchTimeDelay = 0;
    glitchTime = 0;
    for (int i = 0; i<displayTweetPoems.size (); i++) {
    //println("TWEET N\u00b0"+i+" draw");
    displayTweetPoems.get(i).glitch = glitchall;
    
    } 
    
  }/*else if (keyCode == UP) {

    if (activeZone != null && editable) activeZone.drag(mouseX, mouseY);
  } else if (keyCode == DOWN) {
  } else if (keyCode == LEFT) {
  } else if (keyCode == RIGHT) {
  }*/
}
public void manageGlitch(){
  if(glitchall){
    if (glitchTime < glitchDuration){
    glitchTime++;
    
    
    }else{
      //glitch false
      glitchTime = 0;
      glitchall = false;
      glitchDelay = PApplet.parseInt(random(400,800));
    }
    
  }else{
    if (glitchTimeDelay < glitchDelay){
    glitchTimeDelay++;
    
    
    }else{
      //glitch false
      glitchTimeDelay = 0;
      glitchall = true;
    }
    
  }
  for (int i = 0; i<displayTweetPoems.size (); i++) {
    //println("TWEET N\u00b0"+i+" draw");
    displayTweetPoems.get(i).glitch = glitchall;
    
    } 
  
  
}


//SAUVEGARDER LES ZONES
public void addFloatingText() {
  int w = 200;
  int h = 130;
  int s = 30;
  String Text = "";
  zones.add(new FloatingText((int)random(width-w), (int)random(height-h), Text, s));
}

public void saveZones(String fileName) {
  String out = "";
  for (int i=0; i<zones.size (); i++) {
    FloatingText a = zones.get(i);
    out += a.x + "_" + a.y + "_" + a.w + "_" + a.h+"_"+a.txt+"_"+a.s+"\n";
  }  
  out = trim(out);
  saveStrings(fileName, split(out, '\n'));
}

public void loadZones(String fileName) {

  zones.clear();

  String[] in = loadStrings(fileName);
  for (int i=0; i<in.length; i++) {
    String[] l = split(in[i], '_');

    int x = PApplet.parseInt(l[0]);
    int y = PApplet.parseInt(l[1]);
    int w = PApplet.parseInt(l[2]);
    int h = PApplet.parseInt(l[3]);
    String txt = l[4];
    /*for(int j=0; j<txt.length();j++){
      txt.charAt(j)
    }*/
    int s = PApplet.parseInt(l[5]);
    println(" zone loaded : "+x + "_" + y + "_" + w + "_" + h+"_"+txt+"_"+s);
    FloatingText a = new FloatingText(x, y, txt, s);
    
    zones.add(a);
  }
}

//D\u00e9placer les zones avec la souris
public void mouseDragged() {
  if (activeZone != null && editable) activeZone.drag(mouseX, mouseY);
}

public void mousePressed() {
  for (FloatingText a : zones) {
    if (a.isRollover(mouseX, mouseY) && editable) {
      a.click(mouseX, mouseY);
      activeZone = a;
      break;
    }
  }
}

public void mouseReleased() {
  activeZone = null;
}



public boolean checkRetweet(String msgToClean) {

  String check1 ="RT @";

  if ( msgToClean.indexOf(check1) != -1 ) {
    //println("++++++++++++++++found RETWEET   "+msgToClean);
    return true;
  } else {
    return false;
  }
}
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
    this.w = PApplet.parseInt(textWidth(txt));
    println(w);
    this.h = s; 
    println("zone created : "+this.x + "_" + this.y + "_" + this.w + "_" + this.h+"_"+this.txt+"_"+this.s);
  } 

  public void draw() {
    // FILL 
    //noFill();
    //stroke(255,0,0);
    //rect(x, y, w, h);
    fill(255,0,0);
    textFont(fonts[2]);
    textSize(s);
    textAlign(CENTER, CENTER);
    text(txt, x + w/2, y + h/2 -10);

    
  } 

  
  
   //Si on est sur la case
  public boolean isRollover(int pX, int pY) {
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

  public void drag(int px, int py) {
    x = px + ox;
    y = py + oy;
  }

  public void click(int px, int py) {
    if (isRollover(px, py)) {
      ox = x - px;
      oy = y - py;
    }
  }
}
class tweetPoem {

  String texte;
  float posX, posY, size, speed, textAscent, speedAvoid;
  PFont  font;
  boolean uppercase = false;
  int id;
  boolean fullSeen = false;
  float posYavoid, sizeAvoid;
  boolean glitch = false;
 

  tweetPoem(String _texte, int _id, float _posYavoid, float _sizeAvoid, float _speedAvoid) {
    //d\u00e9finition
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
      size = size*0.8f;
      if (randomFont == 2) {
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
    speed = random(0.5f, 1); //0.5, 1

    //Si il va plus vite que l'objet d'avant
    if (speed > speedAvoid && speedAvoid>-1) {
      //Si on connait la position de l'object d'avant
      if (posYavoid >-1 && sizeAvoid >-1) {
        float oldposY = posY;

        //int i = 0;
        //while (posY >(posXavoid-sizeAvoid) && posY < posXavoid+size && i<10) {
        //  //println("on the same spot : reprocess...");
        //  posY = random(size, lineHeight);
        //  i++;
        //}

        if (posY >(posYavoid-sizeAvoid) && posY < posYavoid+size) {
          if (posYavoid+size>lineHeight) {
            println("not enough space after");
            posY = random(size, posYavoid-sizeAvoid);
          } else if (posYavoid-sizeAvoid<size) {
            println("not enough space before");
            posY = random(posYavoid+size, lineHeight);
          } else {
            println("enough space both");
            int test = round(random(0, 1));
            if (test == 0) {
              posY = random(size, posYavoid-sizeAvoid);
            } else {
              posY = random(posYavoid+size, lineHeight);
            }
          }
          println("on the same spot : reprocess..."+oldposY+",   "+posY);
        }
      }
    }



    //println("New tweet create : "+posX+","+posY);
  }


  public void display() {
    /////////////////////GLITCH////////////////////
    if (glitch) {
      //pushStyle();
     
      //fill(255);
      //stroke(255);
      // int randomFontV = floor(random(0, fonts.length));
      //PFont fontV = fonts[randomFontV];
      //textFont(fontV);
      //int sV = int(random(-10,10));
      ////textSize(size+sV);
      //textSize(size);
      ////line(0, offsetT+(lineHeight*i), width, offsetT+(lineHeight*i));

      //text(texte, Math.round(posX), Math.round((id*lineHeight)+posY+offsetT));
      // popStyle();
      pushStyle();
       fill(255);
     stroke(255);
       int randomFontV = floor(random(0, fonts.length));
      PFont fontV = fonts[randomFontV];
      textFont(fontV);
      //textFont(font);
      
      //textSize(size);
     float offsetTxt = 0;
     String texteTemp = texte;
     
     for (int i = 0;i<texte.length();i++){
       int sV = PApplet.parseInt(random(-20,200));
      textSize(size+sV);
       char cTemp = texte.charAt(i);
       textAlign(LEFT);
       text(cTemp, Math.round(posX)+offsetTxt, Math.round((id*lineHeight)+posY+offsetT));
       //println();
       if(i<texte.length()-1){
         char cTemp2 = texte.charAt(i+1);
         String extract = ""+cTemp+cTemp2;
         float txtw = textWidth(extract) - textWidth(cTemp2);
         offsetTxt +=txtw;
       }
     }
     
      float hL = random(0, height);
      line(0, hL, width, hL);

      //text(texte, Math.round(posX), Math.round((id*lineHeight)+posY+offsetT));
       popStyle();
       
    } else {
      //println("TWEET N\u00b0"+id+" draw");
      pushStyle();
      fill(255);
      stroke(255);
      textFont(font);
      textSize(size);
      //line(0, offsetT+(lineHeight*i), width, offsetT+(lineHeight*i));

      text(texte, Math.round(posX), Math.round((id*lineHeight)+posY+offsetT));
      popStyle();
      if (debug) {
        pushStyle();
        fill(255, 0, 0);
        stroke(255, 0, 0);
        strokeWeight(1);
        text(id, Math.round(posX-20), Math.round((id*lineHeight)+posY+offsetT));
        if (posYavoid >-1 && sizeAvoid >-1) {
          float textW = textWidth(texte);
          if ((posX+textW)>width) {


            line(0, Math.round((id*lineHeight)+(posYavoid-sizeAvoid)+offsetT), width, Math.round((id*lineHeight)+(posYavoid-sizeAvoid)+offsetT));
            stroke(0, 255, 0);
            line(0, Math.round((id*lineHeight)+(posYavoid)+offsetT), width, Math.round((id*lineHeight)+(posYavoid)+offsetT));
          }
        }
        popStyle();
      }
    }
    //rect(posX, (id*lineHeight)+posY+offsetT, 10,10);

    updatePos();
  }

  public void updatePos() {
    posX -=speed;
    //println(frameCount +" TWEET N\u00b0"+id+" draw  "+posX+"/"+width+"  ,  "+posY+"/"+height+"   "+texte);
    float textW = textWidth(texte);
    if ((posX+textW)<width && fullSeen == false) {
      //println("TEXTE EN ENTIER :"+id);
      fullSeen = true;
      createNewTweet();
    } else if (posX+textW<0) {
      removeTweetFromDisplay(this);
    }
  }

  public void createNewTweet() {
    if (bufferTweetPoems.size() > 0) {
      String newMsg = bufferTweetPoems.get(0);
      bufferTweetPoems.remove(0); 
      displayTweetPoems.add(new tweetPoem(newMsg, id, posY, textAscent, speed));
    }
  }
  public String clean(String msgToClean) {

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
  public void settings() {  size(1280, 800);  smooth(2); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "dadaTwitterFeed" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
