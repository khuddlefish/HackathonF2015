class Arpeggiator implements HackInstrument{
  ArpeggioThread at;
   Arpeggiator(HackInstrument instrument){
     at = new ArpeggioThread(instrument);
     at.start();
   }
   void playNote(int note, int vel){
     at.notes[note%12] = true;
   }
  void noteOff(int note){
    at.notes[note%12] = false;
  }
  void setVibrato(int vib){
    
  }
  void kill(){
    at.active = false;
    at.ins.kill();
  }
}

class ArpeggioThread extends Thread {
    boolean[] notes = new boolean[12];
    boolean up, active;
    int octave, base_octave, octave_range;
    int current_note;
    int rate;
    HackInstrument ins;
    public ArpeggioThread(HackInstrument instrument){
       ins = instrument;
       rate = 100;
       current_note = 0;
       active = true;
       base_octave = 5;
       octave_range = 4;
    }
    void run(){
      while(active){
        //println("Hi");
        ins.noteOff((base_octave+octave)*12+current_note);
      for(int i = 0; i < 24; i++){
        if(up){
           current_note++;
           if(current_note>=12){
              current_note = 0;
              octave++;
              if(octave>=octave_range)octave = 0;
           }
        }
        else{
            current_note--;
           if(current_note<0){
              current_note = 11;
              octave--;
              if(octave<0)octave = octave_range-1;
           }
        }
        if(notes[current_note]){
          //println("Yay");
            ins.playNote((base_octave+octave)*12+current_note, 127);
            break;
        }
      }
      try{
       Thread.sleep(rate);
      }
      catch(Exception e){}
    }
  } 
}