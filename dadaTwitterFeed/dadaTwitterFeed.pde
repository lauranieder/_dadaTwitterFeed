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
 
int requestedNb = 5;

tweetPoem[] tweetPoems;
PFont[] fonts;
//PFont font = loadFont("SteelfishRg-Regular-30.vlw"); 

void setup() { 
  size(1280,800);
  background(0);
  sqrH = sqrW= height/nbH;
  
  tweetPoems = new tweetPoem[requestedNb];
  fonts = new PFont[5];
  //fonts[]
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
      tweetPoems[i] = new tweetPoem(msg);
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
   if (frameCount % 10 == 0) {
    //queryTwitter();
  }
  stroke(255);
  fill(0);
  for(int i = 0;i<nbW;i++){
    for(int j = 0;j<nbH;j++){
      
      //rect(i*sqrW+((width-(nbW*sqrW))/2), j*sqrH,sqrW, sqrH);
    }  
  }
  
  for(int i = 0;i<tweetPoems.length;i++){
    tweetPoems[i].draw();
    
  }
  
}