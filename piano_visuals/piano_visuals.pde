import themidibus.*;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; 
ArrayList<int[]> coord = new ArrayList<int[]>();
ArrayList<Integer> xCoor = new ArrayList<Integer>();
ArrayList<Integer> yCoor = new ArrayList<Integer>();
//Instance variables
int[] circles = new int[8]; //Array for circle sizes. 
int red = 0, green = 0, blue = 0;
int huan;
double weight = 1;
int r;
float time = 0.0;
float h;
void setup() {
  size(400, 400);
  
  //Initiate array
  for (int i = 0; i < circles.length; i++) {
      circles[i] = 10;
   }
  
  //Midibus stuff, no idea what it does, but works, don't change it.
  MidiBus.list(); 
  myBus = new MidiBus(this, 0, 0);
  myBus.sendTimestamps(false);
    
  //draw blank circles
  background(0);
  int x,y,w,h;
  w = width/6;
  h = height/6;
    for(int i = 0; i < 5; i++){
    x = (width/10)+((width/5)*i);
    for(int j = 0; j < 5; j++){
      y = (height/10)+((height/5)*j);
      ellipse((float)x,(float)y,(float)w,(float)h);
      xCoor.add(x);
      yCoor.add(y);
    }
    }
}

void draw() {
  animation44(huan);
}

void midiMessage(MidiMessage message) {
  
  //Print the MIDI input in the console, don't change. 
  println();
  println("MidiMessage Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1;i < message.getMessage().length;i++) {
    println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
  }
  
  //Variables with the MIDI input messages.
  int zero = (int)(message.getMessage()[0]& 0xFF);
  int one = (int)(message.getMessage()[1]& 0xFF);
  int two = (int)(message.getMessage()[2]& 0xFF);
  
  //Check if a knob is being turned. 
  if (zero == 176 && one < 29 && one > 20) {
    knobRGB(one, two); //Set RGB values.
    circles [one - 21] = two; //Set circle radious. 
  }
  
  //Check if animation clicked
  if(zero == 144 ){
    huan = one;
    h = random(0,360);
  }
}

//Changing knobs to different colors
void knobRGB(int knobNum, int cValue){
    if(knobNum == 21){
      red = cValue*2;
    }else if(knobNum == 22){
      green = cValue*2;
    }else if(knobNum ==23){
      blue = cValue*2;
    }else if(knobNum == 24){
      weight = cValue/12.7;
    }
}

void knobThick(){
  
}
//Circle clicked becomes gradient
void animation44(int one){
  noStroke();
  int index = (one+2)%25;
  drawGradient(xCoor.get(index), yCoor.get(index));
}

//Draw gradient in a circle
void drawGradient(float x, float y) {
  int radius = width/6;
  colorMode(HSB, 360, 100, 100);
  for (int r = radius; r > 0; r-=5) {
    fill(h, 90, 90);
    ellipse(x, y, r, r);
    h = (h + 5) % 360;
  }
}
  