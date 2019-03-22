//: 1023
//: -1022
//: 64

class Main{
  static void main(){
    Double a = new Double();

    Debug.debug(Double.MAX_EXPONENT);
    Debug.debug(Double.MIN_EXPONENT);
    Debug.debug(Double.SIZE);

    double d = 2.0;
    Debug.dumpMemory();
  }
}
