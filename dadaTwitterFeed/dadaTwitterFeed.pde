int sqrH;
int sqrW;
int nbW = 6;
int nbH = 6;


void setup(){
  size(1280,800);
  sqrH = sqrW= height/nbH;
  
  
  
  
}


void draw(){
  
  for(int i = 0;i<nbW;i++){
    for(int j = 0;j<nbH;j++){
      
      rect(i*sqrW+((width-(nbW*sqrW))/2), j*sqrH,sqrW, sqrH);
    }  
  }
  
}
