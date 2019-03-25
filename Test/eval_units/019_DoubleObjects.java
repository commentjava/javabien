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

//: true
//: false
//: false

//: false
//: true
//: true
//: false

//: 35.29
//: 15.07
//: 9.29
//: 5.78

//: 0
//: 1
//: -1
//: 0
//: 1
//: -1
//: 1
//: 0
//: -1

//: 1
//: -1
//: 1
//: -1
//: 0

class Main{
  static void main(){
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
    boolean bn = Double.isNaN(n);
    Debug.debug(Double.isNaN(n));
    Debug.debug(Double.isNaN(c));
    Debug.debug(Double.isNaN(d));

    double df = Double.NEGATIVE_INFINITY;
    Debug.debug(Double.isInfinite(c));
    Debug.debug(Double.isFinite(d));
    Debug.debug(Double.isInfinite(df));
    Debug.debug(Double.isFinite(df));

    Double copyd = Double.valueOf(35.29);
    Debug.debug(copyd.floatValue());
    Debug.debug(Double.sum(5.78, 9.29));
    Debug.debug(Double.max(5.78, 9.29));
    Debug.debug(Double.min(5.78, 9.29));

    Debug.debug(Double.compare(Double.NaN, Double.NaN));
    Debug.debug(Double.compare(Double.NaN, Double.POSITIVE_INFINITY));
    Debug.debug(Double.compare(5.87, Double.NaN));
    Debug.debug(Double.compare(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY));
    Debug.debug(Double.compare(Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY));
    Debug.debug(Double.compare(5.87, Double.POSITIVE_INFINITY));
    Debug.debug(Double.compare(5.87, Double.NEGATIVE_INFINITY));
    Debug.debug(Double.compare(5.87, 5.87));
    Debug.debug(Double.compare(5.87, 587));

    Double no = new Double(n);
    Double dfo = new Double(df);
    Debug.debug(no.compareTo(dfo));
    Debug.debug(copyd.compareTo(no));
    Debug.debug(copyd.compareTo(dfo));
    Debug.debug((new Double(5.87)).compareTo(copyd));
    Debug.debug((new Double(35.29)).compareTo(copyd));
  }
}
