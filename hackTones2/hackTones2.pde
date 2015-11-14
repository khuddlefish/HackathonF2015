import themidibus.*;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;
import ddf.minim.*;
import ddf.minim.ugens.*;

MidiBus myBus; 
Minim minim;
AudioOutput out;
Squarefield squarefield;
HackInstrument instrument;

//Instance variables
ArrayList<int[]> coord = new ArrayList<int[]>();
ArrayList<Integer> xCoor = new ArrayList<Integer>();
ArrayList<Integer> yCoor = new ArrayList<Integer>();
int huan;
double weight = 1;
int r;
float h;

int[] circles = new int[8]; //Array for circle sizes. 

int red = 100;
int green = 100;
int blue = 100;

int speed = 0;

float n = 0.0;
float dim = 25.0;
float time = 0;
ArrayList<bouncingBall> balls = new ArrayList<bouncingBall>();
spiralGraph graph = new spiralGraph();
boolean[] modes = new boolean[16]; 

void setup() {
  //size(400, 400);
  
  minim = new Minim(this);
 
  out = minim.getLineOut();
  InstrumentPresets presets = new InstrumentPresets();
  instrument = presets.preset(7);
  
  squarefield = new Squarefield();
  
  fullScreen();
  //Initiate array
  for (int i = 0; i < circles.length; i++) {
    circles[i] = 10;
  }

  //Midibus stuff, no idea what it does, but works, don't change it.
  MidiBus.list(); 
  myBus = new MidiBus(this, 0, 0);
  myBus.sendTimestamps(false);
  
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
  background(red, green, blue); //Redraw background based on RGB from knobs
  
  if (modes[0]) {
  //Display trippy graph
  graph.display(n, dim, red, green, blue);
  n += (noise(time)-0.5)*0.1; time += 0.1;
  }
  
  if (modes[1]){
  //Draw circles based on knobs
  drawKnobs();
  }
  
  if (modes[2]){
    animation44(huan);
  }
  
  if (modes[3]){
  //Draw and move bouncing balls
  drawBalls(); 
  }
  
  if (modes[4]){
  draw38();  
  }
  
  if (modes[5]){
  squarefield.draw_self();
  }
  
  if (modes[6]){
  drawWaves();
  }
  
  
  if (balls.size() > 20) {
    balls.remove(0);
  }
}

void midiMessage(MidiMessage message) {

  //Print the MIDI input in the console, don't change. 
  println();
  println("MidiMessage Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1; i < message.getMessage().length; i++) {
    println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
  }

  //Variables with the MIDI input messages.
  int zero = (int)(message.getMessage()[0]& 0xFF);
  int one = (int)(message.getMessage()[1]& 0xFF);
  int two = (int)(message.getMessage()[2]& 0xFF);

  //Check if a knob is being turned. 
  if (zero == 176 && one < 29 && one > 20)  {
    knobRGB(one, two); //Set RGB values.
    circles [one - 21] = two; //Set circle radious.
  }
  
  delegate(message);
  
  if (zero == 144) {
    balls.add(new bouncingBall(((width/25)*((one+2)%25)), height - two*2));
    n += (((one+2)%25)-12)/100;
    dim = two/2;
    huan = one;
    h = random(0,360);
  }
  
  if (zero == 153){
    modes[one-36] = !modes[one-36];
  }
}

void knobRGB(int knobNum, int cValue) {
  if (knobNum == 21) {
    red = cValue*2;
  } else if (knobNum == 22) {
    green = cValue*2;
  } else if (knobNum ==23) {
    blue = cValue*2;
  }
}

void drawKnobs(){
  int circlePosition = 55;
  noFill();
  for (int i = 0; i < circles.length; i++) {
    if (i==0) stroke(200,50,50);
    else if (i==1) stroke(50,200,50);
    else if (i==2) stroke(50,50,200);
    else stroke(0,0,0);
    ellipse (circlePosition, 50, circles[i], circles[i]);
    circlePosition += 40;
  }
}

void drawBalls(){
  for (int i = 0; i < balls.size(); i++) {
    balls.get(i).run();
  }
}

void setSpeed(int newSpeed) {
  speed = newSpeed;
  adjustXDist(newSpeed);
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
  for (int r = radius; r > 0; r-=5) {
    fill(h, 200, 200);
    ellipse(x, y, r, r);
    h = (h + 5) % 255;
  }
}

void rawMidi(byte[] data) { // You can also use rawMidi(byte[] data, String bus_name)
  // Receive some raw data
  // data[0] will be the status byte
  // data[1] and data[2] will contain the parameter of the message (e.g. pitch and volume for noteOn noteOff)
  println();
  println("Raw Midi Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+(int)(data[0] & 0xFF));
  // N.B. In some cases (noteOn, noteOff, controllerChange, etc) the first half of the status byte is the command and the second half if the channel
  // In these cases (data[0] & 0xF0) gives you the command and (data[0] & 0x0F) gives you the channel
  for (int i = 1;i < data.length;i++) {
    println("Param "+(i+1)+": "+(int)(data[i] & 0xFF));
  }
  
  switch((int)(data[0] & 0xFF)){
    case 176:
      if(data[1] == 1){
        instrument.setVibrato((int)(data[2] & 0xFF)); 
      }
      break;
    case 144:
      instrument.playNote(data[1], (int)(data[2]&0xFF));
      break;
    case 128:
      instrument.noteOff(data[1]);
      break;
    default:
      break;
  }
}

void drawWaves()
{
  stroke(255);
  strokeWeight(1); 
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50  - out.left.get(i)*50,  i+1, 50  - out.left.get(i+1)*50 );
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
  }
  
}