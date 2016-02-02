import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;
import java.util.*;

ConfigurationBuilder   cb;
Query query;
Twitter twitter;

int sqrH;
int sqrW;
int nbW = 6;
int nbH = 6;
int offsetT = 0;//top
int offsetB = 0;//bottom

int displayNb = 5;
int requestedNb = 15;
int lineHeight;
ArrayList<String> bufferTweetPoems;
ArrayList<tweetPoem> displayTweetPoems;
tweetPoem[] tweetPoems;
PFont[] fonts;
//PFont font = loadFont("SteelfishRg-Regular-30.vlw"); 

boolean debug = false;
void setup() { 
  size(1280,800);
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
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    //println("New Tweet : ");
    int i = 0;
    for (Status tw : tweets) {
      String msg = tw.getText();
      
      if(displayTweetPoems.size()>displayNb-1){
        bufferTweetPoems.add(msg);
      }else{
        displayTweetPoems.add(new tweetPoem(msg, i));
      }
      //tweetPoems[i] = new tweetPoem(msg, i);
      
      //tw.get
      println("tweet : " + msg);
      i++;
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}
void draw(){
  background(0);
   if (buffertweetPoems.size() § {
    //queryTwitter();
  }
  stroke(255);
  fill(0);
  if(debug){
  for(int i = 0;i<displayNb+1;i++){
    line(0,offsetT+(lineHeight*i),width,offsetT+(lineHeight*i));
  }
  }
  for(int i = 0;i<nbW;i++){
    for(int j = 0;j<nbH;j++){
      
      //rect(i*sqrW+((width-(nbW*sqrW))/2), j*sqrH,sqrW, sqrH);
    }  
  }
  
//  for(int i = 0;i<tweetPoems.length;i++){
//    tweetPoems[i].draw();
//    
//  }
  for(int i = 0;i<displayTweetPoems.size();i++){
    displayTweetPoems.get(i).draw();
    
  }
//  for(tweetPoem t : displayTweetPoems){
//    t.draw();
//  } 
}


void keyPressed(){
  
  if (key == ' '){
    debug = !debug;
    
  }
}