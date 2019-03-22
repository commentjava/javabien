package java.lang;

class Double{
  /** Fields. */
  public static int MAX_EXPONENT = 1023;
  public static int MIN_EXPONENT = -1022;
  public static int SIZE = 64;

  /** The sign coded on 1 bit. */
  private int sign;

  /** The exponent coded on 11 bits. */
  private int exponent;

  /** The fraction coded on 52 bits. */
  private int fraction;


  /**
   * Initializes a newly created <code>Double</code> object so that it
   * represents a zero value.
   */
  public Double(){
    this.sign = 0;
    this.exponent = 0;
    this.fraction = 0;
  }

  // byte byteValue()
  // static int compare(double d1, double d2)
  // int compareTo(Double anotherDouble)
  // static long doubleToLongBits(double value)
  // double doubleValue()
  // boolean equals(Object obj)
  // float floatValue()
  // int hashCode()
  // int intValue()
  // boolean isInfinite()
  // static boolean isInfinite(double v)
  // boolean isNaN()
  // static double longBitsToDouble(long bits)
  // long longValue()
  // 

}
