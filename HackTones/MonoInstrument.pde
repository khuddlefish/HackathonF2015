class MonoInstrument implements HackInstrument, Instrument{
   Oscil osc;
   Oscil vibrato;
   Line slide;
   Line bend;
   Summer pitch;
   ADSR adsr;
   Midi2Hz m2h;
   MoogFilter filter;
   
   Summer bus;
   
   int note;
   int keys;
   
   float slide_rate = 0.05;
   MonoInstrument(Summer output_bus){
     
     bus = output_bus;
     keys = 0;
     note = 50;
     
     slide = new Line(1);
     bend = new Line(0.01, 0, 0);
     vibrato = new Oscil(8, 0, Waves.SINE);
     osc = new Oscil(440, 0.4, Waves.SAW);
     adsr = new ADSR(1, 0.001, 0.05, 1, 0.05);
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
   void playNote(int newnote, int velocity){
     setNote(newnote);
     noteOn(0.5);
   }
   void setNote(int newnote){
     if(keys == 0){
       slide.activate(0.001, newnote, newnote);
     }
     else{
       slide.activate(slide_rate, note, newnote); 
     }
     note = newnote;
   }
   
   void noteOn(float velocity){
     if(keys == 0){
       adsr.unpatch(bus);
       osc.setAmplitude(velocity);
       adsr.noteOn();
       adsr.patch(bus);
     }
     keys++;
   }
   void noteOff(int note){
      noteOff(); 
   }
   void noteOff(){
     keys--;
     if(keys == 0){
       adsr.unpatchAfterRelease(bus);
       adsr.noteOff();
     }
   }
   
   void kill(){
      //noteOff(); 
      keys = 0;
      adsr.noteOff();
      adsr.unpatch(bus);

   }
}