import ddf.minim.*;
import ddf.minim.ugens.*;
import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus;

Minim       minim;
AudioOutput out;

MonoInstrument mono;
void setup()
{
  size(512, 200, P3D);
 
   MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object
  
  minim = new Minim(this);
 
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  mono = new MonoInstrument();
}
 
void draw()
{
  background(0);
  stroke(255);
  strokeWeight(1);
 
  // draw the waveform of the output
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50  - out.left.get(i)*50,  i+1, 50  - out.left.get(i+1)*50 );
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
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
        mono.setVibrato((int)(data[2] & 0xFF)); 
      }
      break;
    case 144:
      mono.setNote(data[1]);
      mono.noteOn(1);
      break;
    case 128:
      mono.noteOff();
      break;
    default:
      break;
  }
}