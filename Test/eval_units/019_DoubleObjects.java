//: 1023
//: -1022
//: 64

//: 4.68
//: 5.68
//: -4.68

//: 6.68
//: 9.36
//: 2.34
//: -2.68

//: 5.68
//: 4.68
//: 13.68
//: 4.68
//: 42.12
//: 4.68

//: false
//: true
//: false
//: true
//: false
//: true

class Main{
  static void main(){
    Debug.dumpMemory();
    Double a = new Double(2.61);

    Debug.debug(Double.MAX_EXPONENT);
    Debug.debug(Double.MIN_EXPONENT);
    Debug.debug(Double.SIZE);

    double b = 2.0, c = 4.68, d = 9;
    Debug.debug(c++);
    Debug.debug(c--);
    Debug.debug(-c);

    Debug.debug(b + c);
    Debug.debug(b * c);
    Debug.debug(c / b);
    Debug.debug(b - c);

    Debug.debug(++c);
    Debug.debug(--c);
    Debug.debug(c += d);
    Debug.debug(c -= d);
    Debug.debug(c *= d);
    Debug.debug(c /= d);

    Debug.debug(b == c);
    Debug.debug(b != c);
    Debug.debug(b > c);
    Debug.debug(b < c);
    Debug.debug(b >= c);
    Debug.debug(b <= c);

    double n = Double.NaN;

    Debug.dumpMemory();
  }
}
