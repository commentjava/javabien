package java.lang;

class Double{
  /** *** Hacks *** */
  private static native final double _max_value();
  private static native final double _min_normal();
  private static native final double _min_value();
  private static native final double _nan();
  private static native final double _negative_infinity();
  private static native final double _positive_infinity();

  private static native final boolean _isNaN(double d);
  private static native final boolean _isInfinite(double d);
  private static native final int _intValue(double d);



  /** *** Fields *** */

  /** The number of bytes used to represent a double value. */
  public static final int BYTES = 8;
  /** Maximum exponent a finite double variable may have. */
  public static final int MAX_EXPONENT = 1023;
  /** A constant holding the largest positive finite value of type double, (2-2^-52)·2^1023. */
  public static final double MAX_VALUE = Double._max_value();
  /** Minimum exponent a normalized double variable may have. */
  public static final int MIN_EXPONENT = -1022;
  /** A constant holding the smallest positive normal value of type double, 2^-1022. */
  public static final double MIN_NORMAL = Double._min_normal();
  /** A constant holding the smallest positive nonzero value of type double, 2^-1074. */
  public static final double MIN_VALUE = Double._min_value();
  /** A constant holding a Not-a-Number (NaN) value of type double. */
  public static final double NaN = Double._nan();
  /** A constant holding the negative infinity of type double. */
  public static final double NEGATIVE_INFINITY = Double._negative_infinity();
  /** A constant holding the positive infinity of type double. */
  public static final double POSITIVE_INFINITY = Double._positive_infinity();
  /** A constant holding the positive infinity of type double. */
  public static final int SIZE = 64;
  //** The Class instance representing the primitive type double. */
  // public static final java.lang.Class TYPE

  /** The double value. */
  private final double value;



  /** *** Constructors *** */

  /**
   * Constructs a newly allocated Double object that represents the primitive
   * double argument.
   *
   * @param value the value to be represented by the Double.
   */
  public Double(double d){
    this.value = d;
  }
  //** Constructs a newly allocated Double object that represents the floating-point value of type double represented by the string. */
  // public Double(String s) throws java.lang.NumberFormatException // Not possible due to overload



  /** *** Methods *** */

  // public byte byteValue()

  /**
   * Compares the two specified double values.
   *
   * @param   d1  the first double to compare.
   * @param   d2  the second double to compare.
   * @return  the value 0 if d1 is numerically equal to d2;
   *          a value less than 0 if d1 is numerically less than d2;
   *          and a value greater than 0 if d1 is numerically greater than d2.
   */
  public static int compare(double d1, double d2){
    if(Double.isNaN(d1) && Double.isNaN(d2)){ return 0; }
    else if(Double.isNaN(d1)) { return 1; }
    else if(Double.isNaN(d2)) { return -1; }
    else if(d1 > d2) { return 1; }
    else if(d1 == d2) { return 0; }
    else { return -1; }
  }

  /**
   * Compares two Double objects numerically.
   *
   * @param   anotherDouble   the Double to be compared.
   * @return  the value 0 if anotherDouble is numerically equal to this Double;
   *          a value less than 0 if this Double is numerically less
   *          than anotherDouble;
   *          and a value greater than 0 if this Double is numerically
   *          greater than anotherDouble.
   */
  public int compareTo(Double anotherDouble){
    return Double.compare(this.value, anotherDouble.doubleValue());
  }

  // public static long doubleToLongBits(double d)

  // public static long doubleToRawLongBits(double d)

  /**
   * Returns the double value of this Double object.
   *
   * @return the double value represented by this object.
   */
  public double doubleValue(){
    return this.value;
  }

  // public boolean equals(Object obj)

  /**
   * Returns the value of this Double as a float after a narrowing primitive
   * conversion.
   *
   * @return the double value represented by this object converted to type float.
   */
  public float floatValue(){
    return this.value;
  }

  // public int hashCode()

  // public static int hashCode(double d)

  /**
   * Returns the value of this Double as an int after a narrowing primitive
   * conversion.
   *
   * @return the double value represented by this object converted to type int.
   */
  public int intValue(){
    return Double._intValue(this.value);
  }

  /**
   * Returns true if the argument is a finite floating-point value;
   * returns false otherwise (for NaN and infinity arguments).
   *
   * @param   d   the double value to be tested.
   * @return  true if the argument is a finite floating-point value,
              false otherwise.
   */
  public static boolean isFinite(double d){
    return !(Double._isInfinite(d));
  }

  // public boolean isInfinite() // Not possible due to overload

  /**
   * Returns true if the specified number is infinitely large in magnitude,
   * false otherwise.
   *
   * @param   v   the value to be tested.
   * @return  true if the value of the argument is positive infinity or
   *          negative infinity; false otherwise.
   */
  public static boolean isInfinite(double d){
    return Double._isInfinite(d);
  }

  // public boolean isNaN() // Not possible due to overload

  /**
   * Returns true if the specified number is a Not-a-Number (NaN) value,
   * false otherwise.
   *
   * @param   v   the value to be tested.
   * @return  true if the value of the argument is NaN; false otherwise.
   */
  public static boolean isNaN(double d){
    return Double._isNaN(d);
  }

  // public static double longBitsToDouble(long l)

  /**
   * Returns the value of this Double as a long after a narrowing primitive
   * conversion.
   *
   * @return  the double value represented by this object converted to type
   *          long.
   */
  public long longValue(){
    return Double._intValue(this.value);
  }

  /**
   * Returns the greater of two double values as if by calling Math.max.
   *
   * @param   a   the first operand.
   * @param   b   the second operand.
   * @return  the greater of a and b.
   */ // TODO
  public static double max(double d1, double d2){
    if(d1 > d2){
      return d1;
    }
    else{
      return d2;
    }
  }

  /**
   * Returns the smaller of two double values as if by calling Math.min.
   *
   * @param   a   the first operand.
   * @param   b   the second operand.
   * @return  the smaller of a and b.
   */ // TODO
  public static double min(double d1, double d2){
    if(d1 > d2){
      return d2;
    }
    else{
      return d1;
    }
  }

  // public static double parseDouble(String s) // Not possible due to exceptions raising

  // public short shortValue()

  /**
   * Adds two double values together as per the + operator.
   *
   * @param   a   the first operand.
   * @param   b   the second operand.
   * @return  the sum of a and b.
   */
  public static double sum(double d1, double d2){
    return d1 + d2;
  }

  // public static String toHexString(double d)

  // public String toString()

  /**
   * Returns a string representation of the double argument.
   *
   * @param   d   the double to be converted.
   * @return  a string representation of the argument.
   */
  public static String toString(double d){
    if(Double._isNaN(d)){ return "NaN"; }
    String res = "";
    if(d < 0){ res = String.concat(res, "-"); }
    if(Double._isInfinite(d)){ res = String.concat(res, "Infinity"); }
    else if(d == 0){ res = String.concat(res, "0.0"); }
    else if(0.001 <= d && d < 10000000){
      int nb_digits = 15, pos_digit = -nb_digits, digit;
      float d_copy = d;
      for(int i = 0 ; i < nb_digits ; i ++){ d_copy *= 10; }
      d_copy += 0.5;
      String s_digits = "";
      boolean skip0 = true;
      while(pos_digit < 0 || d_copy >= 1){
        digit = Double._intValue(d_copy % 10.0);
        if(!(skip0 && digit == 0)){
          skip0 = false;
          s_digits = String.concat(String.fromInteger(digit), s_digits);
        }
        d_copy /= 10.0;
        pos_digit ++;
        if(pos_digit == -1){
          skip0 = false;
        }
        if(pos_digit == 0){
          s_digits = String.concat(".", s_digits);
        }
      }
      res = String.concat(res, s_digits);
    }
    else{
      int p = 0;
      float d_copy = d;
      while(d_copy >= 10){
        d_copy /= 10.0;
        p ++;
      }
      while(d_copy < 1){
        d_copy *= 10.0;
        p --;
      }
      res = Double.toString(d_copy);
      res = String.concat(res, "E");
      res = String.concat(res, String.fromInteger(p));
    }
    return res;
  }

  /**
   * Returns a Double instance representing the specified double value.
   *
   * @param   d   a double value.
   * @return  a Double instance representing d.
   */
  public static Double valueOf(double d){
    return new Double(d);
  }

  // public static Double valueOf(String s) // Not possible due to overload
}
