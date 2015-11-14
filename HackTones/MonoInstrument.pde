class MonoInstrument implements Instrument{
   Oscil osc;
   Oscil vibrato;
   Line slide;
   Line bend;
   Summer pitch;
   ADSR adsr;
   Midi2Hz m2h;
   MoogFilter filter;
   
   
   int note;
   int keys;
   MonoInstrument(){
     
     keys = 0;
     note = 50;
     
     slide = new Line(1);
     bend = new Line(0.01, 0, 0);
     vibrato = new Oscil(5, 0, Waves.SINE);
     osc = new Oscil(440, 0.5, Waves.SAW);
     adsr = new ADSR(1, 0.001, 0.05, 1, 0.001);
     m2h = new Midi2Hz();
     
     filter = new MoogFilter(4000, 0.1);
     
     pitch = new Summer();
     //bend.patch(vibrato).patch(slide).patch(m2h).patch(osc.frequency);
     bend.patch(pitch);
     slide.patch(pitch);
     vibrato.patch(pitch);
     pitch.patch(m2h).patch(osc.frequency);
     
     osc.patch(filter).patch(adsr);
   }
   void setVibrato(int vib){
       vibrato.setAmplitude((float)vib/127.);
   }
   
   void setNote(int newnote){
     if(keys == 0){
       slide.activate(0.05, newnote, newnote);
     }
     else{
       slide.activate(0.05, note, newnote); 
     }
     note = newnote;
   }
   
   void noteOn(float velocity){
     if(keys == 0){
       adsr.unpatch(out);
       adsr.noteOn();
       adsr.patch(out);
     }
     keys++;
   }
   void noteOff(){
     keys--;
     if(keys == 0){
       adsr.unpatchAfterRelease(out);
       adsr.noteOff();
     }
   }
}