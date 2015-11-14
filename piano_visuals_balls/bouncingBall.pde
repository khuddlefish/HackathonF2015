class bouncingBall{
 //VARIABLES
 float x = 0;
 float y = 0;
 float speedX = 0;
 float speedY = random(-2,2);
  
 //CONSTRUCTOR
 bouncingBall(float _x, float _y){
  x = _x;
  y = _y;
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
    ellipse( x, y, 20, 20);
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
    speedY += 0.2;
  }
   
  void verifyGravity(){
    if(y > height-10){
     y = height-10;
    }
  }
}