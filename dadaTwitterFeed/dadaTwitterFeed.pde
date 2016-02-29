import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;
import java.util.*;

ConfigurationBuilder   cb;
Query query;
Twitter twitter;

/*eviter qu'ils puissent se mettre exactement où était l'autre tweet d'avant
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
// FloatingText MANAGER ////////////////////////////////////////////////////////
final String FILE_PLAYER = "zone_setup.txt";// fichier de position des zones
public ArrayList<FloatingText> zones; //listes des zones
FloatingText activeZone; //zone active

void setup() { 
  size(1280, 800);
  background(0);
  smooth(2);
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

void queryTwitter() {
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
        println("TWEET N° "+i+" removed because retweet");
      } else {

        if (displayTweetPoems.size()>displayNb-1) {
          bufferTweetPoems.add(msg);
          println("TWEET N° "+i+" added to buffer");
        } else {
          displayTweetPoems.add(new tweetPoem(msg, j, -1, -1, -1));
          println("TWEET N° "+i+" added to display");
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
void draw() {
  background(0);
  fill(198, 87, 79);
  textFont(fonts[2]);
  textSize(50);
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
    //println("TWEET N°"+i+" draw");
    displayTweetPoems.get(i).display();
  }
}

void removeTweetFromDisplay(tweetPoem poem) {

  displayTweetPoems.remove(poem);
}


void keyPressed() {

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
    for (int i = 0; i<displayTweetPoems.size (); i++) {
    //println("TWEET N°"+i+" draw");
    displayTweetPoems.get(i).glitch = glitchall;
    
  } 
    
  }/*else if (keyCode == UP) {

    if (activeZone != null && editable) activeZone.drag(mouseX, mouseY);
  } else if (keyCode == DOWN) {
  } else if (keyCode == LEFT) {
  } else if (keyCode == RIGHT) {
  }*/
}
//SAUVEGARDER LES ZONES
void addFloatingText() {
  int w = 200;
  int h = 130;
  int s = 30;
  String Text = "";
  zones.add(new FloatingText((int)random(width-w), (int)random(height-h), Text, s));
}

void saveZones(String fileName) {
  String out = "";
  for (int i=0; i<zones.size (); i++) {
    FloatingText a = zones.get(i);
    out += a.x + "_" + a.y + "_" + a.w + "_" + a.h+"_"+a.txt+"_"+a.s+"\n";
  }  
  out = trim(out);
  saveStrings(fileName, split(out, '\n'));
}

void loadZones(String fileName) {

  zones.clear();

  String[] in = loadStrings(fileName);
  for (int i=0; i<in.length; i++) {
    String[] l = split(in[i], '_');

    int x = int(l[0]);
    int y = int(l[1]);
    int w = int(l[2]);
    int h = int(l[3]);
    String txt = l[4];
    /*for(int j=0; j<txt.length();j++){
      txt.charAt(j)
    }*/
    int s = int(l[5]);
    println(" zone loaded : "+x + "_" + y + "_" + w + "_" + h+"_"+txt+"_"+s);
    FloatingText a = new FloatingText(x, y, txt, s);
    
    zones.add(a);
  }
}

//Déplacer les zones avec la souris
void mouseDragged() {
  if (activeZone != null && editable) activeZone.drag(mouseX, mouseY);
}

void mousePressed() {
  for (FloatingText a : zones) {
    if (a.isRollover(mouseX, mouseY) && editable) {
      a.click(mouseX, mouseY);
      activeZone = a;
      break;
    }
  }
}

void mouseReleased() {
  activeZone = null;
}



boolean checkRetweet(String msgToClean) {

  String check1 ="RT @";

  if ( msgToClean.indexOf(check1) != -1 ) {
    //println("++++++++++++++++found RETWEET   "+msgToClean);
    return true;
  } else {
    return false;
  }
}