class InstrumentPresets{
   HackInstrument preset(int num){
     Summer bus = new Summer();
     
     MonoInstrument mono = new MonoInstrument(bus);
     PolyInstrument poly = new PolyInstrument(bus);
     
      switch(num){
        case 1:
          mono.osc.setWaveform(Waves.TRIANGLE);
          bus.patch(out);
          return mono;
        case 2:
          mono.osc.setWaveform(Waves.SQUARE);
          
          bus.patch(new Delay(0.375, 0.5, true)).patch(out);
          return mono;
        case 3:
          mono.adsr.setParameters(1, 1, 0.1, 1, 1, 0, 0);
          mono.filter.frequency.setLastValue(2000);
          mono.vibrato.setFrequency(5);
          mono.vibrato.setAmplitude(0.5);
          mono.slide_rate = 0.15;
          bus.patch(out);
          return mono;
        case 4:
          bus.patch(out);
          return poly;
        
        case 7:
          for(int i = 0; i < poly.num_voices; i++){
              poly.voices[i].adsr.setParameters(1, 0.0001, 0.1, 0, 0.1, 0, 0);
              poly.voices[i].osc.setWaveform(Waves.SAW);
              poly.voices[i].setCutoff(10000);
          }
          Arpeggiator arp = new Arpeggiator(poly);
          arp.at.rate = 20;
          bus.patch(new Delay(0.375, 0.5, true)).patch(out);
          //bus.patch(out);
          return arp;
        case 8:
          for(int i = 0; i < poly.num_voices; i++){
              poly.voices[i].adsr.setParameters(0.001, 0.2, 0, 0.25, 1, 0, 0);
              poly.voices[i].osc.setWaveform(Waves.TRIANGLE);
          }
          return poly;
        default:
          return mono;
      }
   }
}