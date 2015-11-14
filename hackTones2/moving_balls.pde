  
  ArrayList<Pair<Float,Float>> coords = new ArrayList<Pair<Float,Float>>();
  ArrayList<Triple<Integer,Integer,Integer>> colors = new ArrayList<Triple<Integer,Integer,Integer>>();
  ArrayList<Integer> sizes = new ArrayList<Integer>();
  int numItems;
  float xDist = 5;
  
  //drawing function for this mode
  void draw38() {
    for (int i = 0; i < numItems; i++) {
      noStroke();
      fill(colors.get(i).first, colors.get(i).second, colors.get(i).third);
      ellipse(coords.get(i).first, coords.get(i).second, sizes.get(i), sizes.get(i));
      println(coords.get(i));
    }
    move();
  }
  
  //adjust the speed circles move across the screen based on the speed knob
  void adjustXDist(int newDist) {
    xDist = (newDist/7.0) + 2;
  }
 
  //adjust the x values of the coordinates array to move circles across the screen
  void move() {
    for (int i = 0; i < numItems; i++) {
       coords.get(i).first += xDist;
       if (coords.get(i).first > width) {
         removeCircle(i);
       }
    }
  }
  
  //add a new circle to the screen when a piano key is pressed
  void addCircle(MidiMessage message) {
    int note = (int)(message.getMessage()[1] & 0xFF) % 25;
    int intensity = (int)(message.getMessage()[2] & 0xFF);
    float scale = height/25.0;
    coords.add(new Pair<Float,Float>(0.0, note * scale));
    colors.add(randomizeColor(red,green,blue));
    sizes.add(intensity/2);
    numItems++;
  }
  
  //removes a circle from being drawn when it moves off screen
  void removeCircle(int index) {
    coords.remove(index);
    colors.remove(index);
    sizes.remove(index);
    numItems--;
  }
  
  //randomly changes the red green and blue values slightly to add variation in colors
  Triple<Integer, Integer, Integer> randomizeColor(int red, int green, int blue) {
    int newRed = red + (int)random(-50,50);
    
    int newGreen = green + (int)random(-50,50);
    
    int newBlue = blue + (int)random(-50,50);
    
    return new Triple<Integer, Integer, Integer>(newRed, newBlue, newGreen);  
  }