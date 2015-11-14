class Pair<A, B> {
  public A first;
  public B second;

  public Pair(final A first, final B second) {
    this.first = first;
    this.second = second;
  }
  
  public String toString() {
    return "(" + first + "," + second + ")";
  }
}

class Triple <A, B, C> {
  public A first;
  public B second;
  public C third;

  public Triple(final A first, final B second, final C third) {
    this.first = first;
    this.second = second;
    this.third = third;
  }
  
  public String toString() {
    return "(" + first + "," + second + "," + third + ")";
  }
}