class InstrumentPresets{
   HackInstrument preset(int i){
     Summer bus = new Summer();
     
     MonoInstrument mono = new MonoInstrument(bus);
     PolyInstrument poly = new PolyInstrument(bus);
      switch(i){
        case 1:
          mono.osc.setWaveform(Waves.TRIANGLE);
          bus.patch(out);
          return mono;
        case 2:
          mono.osc.setWaveform(Waves.SQUARE);
          
          bus.patch(new Delay(0.375, 0.5, true)).patch(out);
          return mono;
        case 3:
          mono.adsr.setParameters(2, 1, 0.1, 1, 1, 0, 0);
          mono.filter.frequency.setLastValue(2000);
          mono.vibrato.setFrequency(5);
          mono.vibrato.setAmplitude(0.5);
          mono.slide_rate = 0.15;
          bus.patch(out);
          return mono;
        case 4:
          bus.patch(out);
          return poly;
        
        default:
          return mono;
      }
   }
}