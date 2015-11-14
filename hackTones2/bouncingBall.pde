class bouncingBall{
 //VARIABLES
 int t;
 float x = 0;
 float y = 0;
 float speedX = 0;
 float speedY = random(-2,2);
  
 //CONSTRUCTOR
 bouncingBall(float _x, float _y){
  x = _x;
  y = _y;
  t = 20;
 }
  
 //FUNCTIONS
 void run(){
   display();
   move();
   bounce();
   gravity();
   verifyGravity();
 }
  
  void display(){ 
    noFill();
    strokeWeight(8);
    ellipse( x, y, 20+t, 20 + t);
    noStroke();
    fill(255);
    ellipse( x, y, 20-t, 20-t);
    
    if(t>0)t--;
 }
  
 void move(){
  x += speedX;
  y += speedY;
 }
 
 void bounce(){
   
   if(y > (height-10)){
     speedY *= -1;
 
   }
   
   if(y < 10){
     speedY *= -1;
 
   }  
 }
  
  void gravity(){
    speedY += out.left.level()*3;
  }
   
  void verifyGravity(){
    if(y > height-10){
     y = height-10;
    }
  }
}