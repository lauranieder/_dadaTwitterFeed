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
int offsetT = 0;//top
int offsetB = 0;//bottom

int displayNb = 5;
int requestedNb = 60;
int lineHeight;
ArrayList<String> bufferTweetPoems;
ArrayList<tweetPoem> displayTweetPoems;
tweetPoem[] tweetPoems;
PFont[] fonts;
//PFont font = loadFont("SteelfishRg-Regular-30.vlw"); 

boolean debug = false;
boolean retweet = false;
void setup() { 
  size(1280, 800);
  background(0);
  smooth(2);
  sqrH = sqrW= height/nbH;
  lineHeight = floor((height-offsetT-offsetB)/displayNb);
  tweetPoems = new tweetPoem[displayNb];
  bufferTweetPoems = new ArrayList<String>();
  displayTweetPoems = new ArrayList<tweetPoem>();
  fonts = new PFont[3];
  fonts[0] = loadFont("SteelfishRg-Regular-30.vlw"); 
  fonts[1] = loadFont("BebasNeue-Thin-30.vlw");
  fonts[2] = loadFont("BrandonGrotesque-Regular-30.vlw"); 

  //Acreditacion
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("2qMiURIx98A0ZGrE0oO14UpUQ");
  cb.setOAuthConsumerSecret("VdbqlTx0uOBS0NCPgVRdUqtgFOKP8idiH8dNLpAYazmfzv2lVx");
  cb.setOAuthAccessToken("1546407708-6Jou8lWT0m4ISQ2xdeLKgcXLz1jsaUEbCrF0uUn");
  cb.setOAuthAccessTokenSecret("97zUR7ocCovwKoJO8amsWfCGja21l2fhTIenU03FwSsez");

  //Make the twitter object and prepare the query
  twitter = new TwitterFactory(cb.build()).getInstance();

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
      if(!retweet && checkRetweet(msg)){
        println("TWEET N° "+i+" removed because retweet");
      }else{
        
        if (displayTweetPoems.size()>displayNb-1) {
          bufferTweetPoems.add(msg);
          println("TWEET N° "+i+" added to buffer");
        } else {
          displayTweetPoems.add(new tweetPoem(msg, j, -1));
          println("TWEET N° "+i+" added to display");
          j++;
        } 
        
      }
      i++;
      
    }
    println("display/ "+displayTweetPoems.size()+"     buffer/"+bufferTweetPoems.size());
    println("___________________________________________");
    if(bufferTweetPoems.size()<20){
      requestedNb +=10; //next request will ask for more tweets
    }else if(bufferTweetPoems.size()>40){
      requestedNb -=10; //next request will ask for less tweets
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}
void draw() {
 background(0);
  if (bufferTweetPoems.size() < 5) {
    queryTwitter();
  }
  stroke(255);
  fill(0);
  if (debug) {
    for (int i = 0; i<displayNb+1; i++) {
      line(0, offsetT+(lineHeight*i), width, offsetT+(lineHeight*i));
    }
  }

  for (int i = 0; i<displayTweetPoems.size (); i++) {
    //println("TWEET N°"+i+" draw");
    displayTweetPoems.get(i).draw();
  }
 
}

void removeTweetFromDisplay(tweetPoem poem){
  
  displayTweetPoems.remove(poem);
}


void keyPressed() {

  if (key == ' ') {
    debug = !debug;
  }
  
   if (key == 'k') {
    println("display/ "+displayTweetPoems.size()+"     buffer/"+bufferTweetPoems.size());
  }
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