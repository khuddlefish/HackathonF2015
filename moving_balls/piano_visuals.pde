  
import themidibus.*;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; 

//Instance variables
int[] circles = new int[8]; //Array for circle sizes. 
int red = 0;
int green = 0;
int blue = 0;

int speed = 0;

void setup() {
  size(400,400);
  
  //Initiate array
  for (int i = 0; i < circles.length; i++) {
      circles[i] = 10;
   }
  
  //Midibus stuff, no idea what it does, but works, don't change it.
  MidiBus.list(); 
  myBus = new MidiBus(this, 0, 0);
  myBus.sendTimestamps(false);
}

void draw() {
  //background(red, green, blue); //Redraw background based on RGB from knobs
  
  //Draw circles
  //int circlePosition = 55;
  //noFill();
  //for (int i = 0; i < circles.length; i++) {
  //    ellipse (circlePosition, 50, circles[i], circles[i]);
  //    circlePosition += 40;
  //}
  draw38();  
}

void midiMessage(MidiMessage message) {
  
  //Print the MIDI input in the console, don't change. 
  /*
  println();
  println("MidiMessage Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1;i < message.getMessage().length;i++) {
    println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
  }
  */
  
  //Variables with the MIDI input messages.
  int zero = (int)(message.getMessage()[0]& 0xFF);
  int one = (int)(message.getMessage()[1]& 0xFF);
  int two = (int)(message.getMessage()[2]& 0xFF);
  
  delegate(message);
  //Check if a knob is being turned. 
  if (zero == 176 && one < 29 && one > 20) {
    knobRGB(one, two); //Set RGB values.
    circles [one - 21] = two; //Set circle radious. 
  }
     
}

void knobRGB(int knobNum, int cValue){
    if(knobNum == 21){
      red = cValue*2;
    }else if(knobNum == 22){
      green = cValue*2;
    }else if(knobNum ==23){
      blue = cValue*2;
    }
}

void setSpeed(int newSpeed) {
  speed = newSpeed;
  adjustXDist(newSpeed);
}