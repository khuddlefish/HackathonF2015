class PolyInstrument implements HackInstrument{
    int num_voices = 16;
    
    int current_voice;
    MonoInstrument[] voices;
    
    PolyInstrument(Summer bus){
      voices = new MonoInstrument[num_voices];
      current_voice = 0;
      for(int i = 0; i < num_voices; i++){
         voices[i] = new MonoInstrument(bus); 
         voices[i].adsr.setParameters(0.5, 0.001, 5, 0.2, 1, 0, 0); 
         voices[i].vibrato.setFrequency(5);
      }
    }
  
    void playNote(int note, int vel){
      voices[current_voice].kill();
      voices[current_voice].setNote(note);
      voices[current_voice].noteOn((float)vel/300.);
      current_voice++;
      current_voice %= num_voices;
    }
    
    void noteOff(int note){
      for(int i = 0; i < num_voices; i++){
         if(voices[i].note == note){
            voices[i].noteOff(); 
         }
      }
    }
    void setVibrato(int vib){
      for(int i = 0; i < num_voices; i++){
         voices[i].setVibrato(vib);
      }
    }
    void kill(){
      for(int i = 0; i < num_voices; i++){
         voices[i].kill();
      }
    }
}