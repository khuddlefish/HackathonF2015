import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; // The MidiBus

void setup() {
  size(400, 400);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object

  // On mac you will need to use MMJ since Apple's MIDI subsystem doesn't properly support SysEx. 
  // However MMJ doesn't support sending timestamps so you have to turn off timestamps.
  myBus.sendTimestamps(false);
}

//Instance variables
int red = 0;
int green = 0;
int blue = 0;
int r;

void draw() {
  background(255);
  stroke(red, blue, green);
  ellipse(width/2, height/2, r, r);
}

void midiMessage(MidiMessage message) {
  println();
  println("MidiMessage Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1;i < message.getMessage().length;i++) {
    println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
  }  
  int zero = (int)(message.getMessage()[0]& 0xFF);
  int one = (int)(message.getMessage()[1]& 0xFF);
  int two = (int)(message.getMessage()[2]& 0xFF);
  if(zero == 176){
    knob(one, two);
  }
  
  r = (int)(message.getMessage()[2] & 0xFF);

}
//1: 21 --> 28
//2: 0 - 127 --> rgb * 2
void knob(int knobNum, int cValue){
    if(knobNum == 21){
      red = cValue*2;
    }else if(knobNum == 22){
      green = cValue*2;
    }else if(knobNum ==23){
      blue = cValue*2;
    }
}


void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}