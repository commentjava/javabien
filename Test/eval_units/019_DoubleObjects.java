//: 1023
//: -1022
//: 64

//: 6.68
//: 9.36
//: 2.34
//: -2.68

class Main{
  static void main(){
    Double a = new Double();

    Debug.debug(Double.MAX_EXPONENT);
    Debug.debug(Double.MIN_EXPONENT);
    Debug.debug(Double.SIZE);

    double b = 2.0, c = 4.68, d = 1;
    Debug.debug(b + c);
    Debug.debug(b * c);
    Debug.debug(c / b);
    Debug.debug(b - c);

    Debug.dumpMemory();
  }
}
