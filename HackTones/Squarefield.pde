class Squarefield{
  int num_squares = 200;
  Square[] squares = new Square[200];
  Squarefield(){
    for(int i = 0; i < num_squares; i++){
      squares[i] = new Square();
    }
  }
  void draw_self(){
    for(int i = 0; i < num_squares; i++){
      squares[i].update(0.01*(out.left.level()+0.1));
      squares[i].draw_self((out.left.level()*3+1)*4);
    }
  }
}

class Square{
  float x, y, z;
   Square(){
     z = random(2);
     x = random(width);
     y = random(height);
   }
   void update(float z_inc){
     z -= z_inc;
     if(z < 0.05){
       z = 1 + random(1);
       x = random(width);
       y = random(height);
     }
   }
   void draw_self(float size){
     noStroke();
     fill(255);
     rect((x-size/2-width/2)/z+width/2, (y-size/2-height/2)/z+height/2, 
         size/z,size/z);
   }
}