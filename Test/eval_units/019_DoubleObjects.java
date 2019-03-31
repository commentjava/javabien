// calculs
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

// Double object
// constants
//: infinity
//: neg_infinity
//: nan
//: 1.79769313486e+308
//: 4.94065645841e-324

// toString

//: 4
//: true
//: true
//: true
//: true

//: 3
//: true
//: true
//: true

//: 9
//: true
//: true
//: true
//: true
//: true
//: true
//: true
//: true
//: true

//: 6
//: true
//: true
//: true
//: true
//: true
//: true

//: 5
//: true
//: true
//: true
//: true
//: true

// valueOf

// parseDouble

// isNaN
//: true
//: false
//: false

// isInfinite
//: false
//: true
//: false

// intValue
//: 2
//: 2
//: 4
//: 9
//: 4611686018427387903
//: 4611686018427387903
//: 0

// doubleValue
//: 2.61

 // compareTo
//: 1
//: 0
//: -1
//: -1
//: 1
//: -1

// compare
//: 0
//: 1
//: -1
//: 0
//: 1
//: -1
//: 1
//: 0
//: -1


class Main{
  static void main(String[] args) {
    System.initializeSystemClass();  // Mandatory call

    double a = 2.61, b = 2.0, c = 4.68, d = 9;
    Double da = new Double(a), db = new Double(b), dc = new Double(c), dd = new Double(d);
    // calculs
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

    // Double object
    // constants
    Debug.debug(Double.POSITIVE_INFINITY);
    Debug.debug(Double.NEGATIVE_INFINITY);
    Debug.debug(Double.NaN);
    Debug.debug(Double.MAX_VALUE);
    Debug.debug(Double.MIN_VALUE);

    // toString
    String sa = Double.toString(a);
    Debug.debug(sa.length());
    Debug.debug(sa.toCharArray()[0] == '2');
    Debug.debug(sa.toCharArray()[1] == '.');
    Debug.debug(sa.toCharArray()[2] == '6');
    Debug.debug(sa.toCharArray()[3] == '1');
    String sb = Double.toString(Double.NaN);
    Debug.debug(sb.length());
    Debug.debug(sb.toCharArray()[0] == 'N');
    Debug.debug(sb.toCharArray()[1] == 'a');
    Debug.debug(sb.toCharArray()[2] == 'N');
    String sc = Double.toString(Double.NEGATIVE_INFINITY);
    Debug.debug(sc.length());
    Debug.debug(sc.toCharArray()[0] == '-');
    Debug.debug(sc.toCharArray()[1] == 'I');
    Debug.debug(sc.toCharArray()[2] == 'n');
    Debug.debug(sc.toCharArray()[3] == 'f');
    Debug.debug(sc.toCharArray()[4] == 'i');
    Debug.debug(sc.toCharArray()[5] == 'n');
    Debug.debug(sc.toCharArray()[6] == 'i');
    Debug.debug(sc.toCharArray()[7] == 't');
    Debug.debug(sc.toCharArray()[8] == 'y');
    String sd = Double.toString(0.00001);
    Debug.debug(sd.length());
    Debug.debug(sd.toCharArray()[0] == '1');
    Debug.debug(sd.toCharArray()[1] == '.');
    Debug.debug(sd.toCharArray()[2] == '0');
    Debug.debug(sd.toCharArray()[3] == 'E');
    Debug.debug(sd.toCharArray()[4] == '-');
    Debug.debug(sd.toCharArray()[5] == '5');
    String se = Double.toString(100000000.0);
    Debug.debug(se.length());
    Debug.debug(se.toCharArray()[0] == '1');
    Debug.debug(se.toCharArray()[1] == '.');
    Debug.debug(se.toCharArray()[2] == '0');
    Debug.debug(se.toCharArray()[3] == 'E');
    Debug.debug(se.toCharArray()[4] == '8');

    // valueOf

    //parseDouble

    // isNaN
    Debug.debug(Double.isNaN(Double.NaN));
    Debug.debug(Double.isNaN(c));
    Debug.debug(Double.isNaN(d));

    //isInfinite
    Debug.debug(Double.isInfinite(c));
    Debug.debug(Double.isInfinite(Double.NEGATIVE_INFINITY));
    Debug.debug(Double.isInfinite(Double.NaN));

    //intValue
    Debug.debug(da.intValue());
    Debug.debug(db.intValue());
    Debug.debug(dc.intValue());
    Debug.debug(dd.intValue());
    Debug.debug((new Double(5611686018427387903.0)).intValue());
    Debug.debug((new Double(Double.POSITIVE_INFINITY)).intValue());
    Debug.debug((new Double(Double.NaN)).intValue());

    // doubleValue
    Debug.debug((new Double(a)).doubleValue());

    // compareTo
    Debug.debug(da.compareTo(db));
    Debug.debug(dc.compareTo(dc));
    Debug.debug(dd.compareTo(new Double(Double.POSITIVE_INFINITY)));
    Debug.debug((new Double(Double.NEGATIVE_INFINITY)).compareTo(dd));
    Debug.debug((new Double(Double.NaN)).compareTo(da));
    Debug.debug(da.compareTo(new Double(Double.NaN)));

    // compare
    Debug.debug(Double.compare(Double.NaN, Double.NaN));
    Debug.debug(Double.compare(Double.NaN, Double.POSITIVE_INFINITY));
    Debug.debug(Double.compare(5.87, Double.NaN));
    Debug.debug(Double.compare(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY));
    Debug.debug(Double.compare(Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY));
    Debug.debug(Double.compare(5.87, Double.POSITIVE_INFINITY));
    Debug.debug(Double.compare(5.87, Double.NEGATIVE_INFINITY));
    Debug.debug(Double.compare(5.87, 5.87));
    Debug.debug(Double.compare(5.87, 587));

  }
}
