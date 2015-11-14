class InstrumentPresets{
  MoogFilter filter;
  Delay delay;
  
  void setCutoff(float freq){
     filter.frequency.setLastValue(freq); 
  }
  void setDelay(float amp){
     delay.setDelAmp(amp); 
  }
  
  
   HackInstrument preset(int num){
     Summer bus = new Summer();
     filter = new MoogFilter(10000, 0.1);
     delay = new Delay(0.375, 0.2, true);
     MonoInstrument mono = new MonoInstrument(bus);
     PolyInstrument poly = new PolyInstrument(bus);
     
      switch(num){
        case 1:
          mono.osc.setWaveform(Waves.TRIANGLE);
          bus.patch(filter).patch(delay).patch(out);
          return mono;
        case 2:
          mono.osc.setWaveform(Waves.SQUARE);
          
          bus.patch(filter).patch(delay).patch(out);
          return mono;
        case 3:
          mono.adsr.setParameters(1, 1, 0.1, 1, 1, 0, 0);
          mono.filter.frequency.setLastValue(2000);
          mono.vibrato.setFrequency(5);
          mono.vibrato.setAmplitude(0.5);
          mono.slide_rate = 0.15;
          bus.patch(filter).patch(delay).patch(out);
          return mono;
        case 4:
          bus.patch(filter).patch(delay).patch(out);
          return poly;
        
        case 7:
          for(int i = 0; i < poly.num_voices; i++){
              poly.voices[i].adsr.setParameters(0.5, 0.0001, 0.1, 0, 0.001, 0, 0);
              poly.voices[i].osc.setWaveform(Waves.SAW);
              poly.voices[i].setCutoff(5000);
          }
          Arpeggiator arp = new Arpeggiator(poly);
          arp.at.rate = 20;
          bus.patch(filter).patch(delay).patch(out);
          //bus.patch(out);
          return arp;
        case 8:
          for(int i = 0; i < poly.num_voices; i++){
              poly.voices[i].adsr.setParameters(0.001, 0.2, 0, 0.25, 1, 0, 0);
              poly.voices[i].osc.setWaveform(Waves.TRIANGLE);
          }
          bus.patch(filter).patch(delay).patch(out);
          return poly;
        default:
          bus.patch(filter).patch(delay).patch(out);
          return mono;
      }
   }
}