interface HackInstrument
{
  void playNote(int note, int vel);
  void noteOff(int note);
  void setVibrato(int vib);
  void kill();
}