void delegate(MidiMessage message) {
  int commandNum = (int)(message.getMessage()[0] & 0xFF);
  int one = (int)(message.getMessage()[1]& 0xFF);
  int two = (int)(message.getMessage()[2]& 0xFF);
  switch(commandNum) {
    case 176:
      if (one > 20 && one < 29) {
        knobRGB(one, two); //Set RGB values.
        circles [one - 21] = two; //Set circle radious. 
        if (one == 24) {
          setSpeed(two);  
        }
      }
      break;
    
    case 153:
      //changeMode(one);
      break;
    case 144:
      addCircle(message);
      break; 
    }
  }