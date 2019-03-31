/*
 * @(#)Double.java  1.82 03/01/23
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 * Modified for javabien
 *
 */


package java.lang;

class Double{
  /** *** Hacks *** */
  private static native final double _max_value();
  private static native final double _min_value();

  private static native final int _intValue(double d);



  /** *** Fields *** */

  /**
   * A constant holding the positive infinity of type
   * <code>double</code>. It is equal to the value returned by
   * <code>Double.longBitsToDouble(0x7ff0000000000000L)</code>.
   */
  public static final double POSITIVE_INFINITY = 1.0 / 0.0;

  /**
   * A constant holding the negative infinity of type
   * <code>double</code>. It is equal to the value returned by
   * <code>Double.longBitsToDouble(0xfff0000000000000L)</code>.
   */
  public static final double NEGATIVE_INFINITY = -1.0 / 0.0;

  /**
   * A constant holding a Not-a-Number (NaN) value of type
   * <code>double</code>. It is equivalent to the value returned by
   * <code>Double.longBitsToDouble(0x7ff8000000000000L)</code>.
   */
  public static final double NaN = 0.0 / 0.0;

  /**
   * A constant holding the largest positive finite value of type
   * <code>double</code>, (2-2<sup>-52</sup>)&middot;2<sup>1023</sup>.
   * It is equal to the value returned by:
   * <code>Double.longBitsToDouble(0x7fefffffffffffffL)</code>.
   */
  public static final double MAX_VALUE = Double._max_value();

  /**
   * A constant holding the smallest positive nonzero value of type
   * <code>double</code>, 2<sup>-1074</sup>. It is equal to the
   * value returned by <code>Double.longBitsToDouble(0x1L)</code>.
   */
  public static final double MIN_VALUE = Double._min_value();

  // public static final java.lang.Class TYPE

  /**
   * The value of the Double.
   *
   * @serial
   */
  private double value;



  /** *** Constructors *** */

  /**
   * Constructs a newly allocated <code>Double</code> object that
   * represents the primitive <code>double</code> argument.
   *
   * @param   value   the value to be represented by the <code>Double</code>.
   */
  public Double(double value) {
    this.value = value;
  }

  // public Double(String s) throws NumberFormatException // Cannot be implemented due to overcharging



  /** *** Methods *** */

  /**
   * Returns a string representation of the <code>double</code>
   * argument. All characters mentioned below are ASCII characters.
   * <ul>
   * <li>If the argument is NaN, the result is the string
   *     &quot;<code>NaN</code>&quot;.
   * <li>Otherwise, the result is a string that represents the sign and
   * magnitude (absolute value) of the argument. If the sign is negative,
   * the first character of the result is '<code>-</code>'
   * (<code>'&#92;u002D'</code>); if the sign is positive, no sign character
   * appears in the result. As for the magnitude <i>m</i>:
   * <ul>
   * <li>If <i>m</i> is infinity, it is represented by the characters
   * <code>"Infinity"</code>; thus, positive infinity produces the result
   * <code>"Infinity"</code> and negative infinity produces the result
   * <code>"-Infinity"</code>.
   *
   * <li>If <i>m</i> is zero, it is represented by the characters
   * <code>"0.0"</code>; thus, negative zero produces the result
   * <code>"-0.0"</code> and positive zero produces the result
   * <code>"0.0"</code>.
   *
   * <li>If <i>m</i> is greater than or equal to 10<sup>-3</sup> but less
   * than 10<sup>7</sup>, then it is represented as the integer part of
   * <i>m</i>, in decimal form with no leading zeroes, followed by
   * '<code>.</code>' (<code>'&#92;u002E'</code>), followed by one or
   * more decimal digits representing the fractional part of <i>m</i>.
   *
   * <li>If <i>m</i> is less than 10<sup>-3</sup> or greater than or
   * equal to 10<sup>7</sup>, then it is represented in so-called
   * "computerized scientific notation." Let <i>n</i> be the unique
   * integer such that 10<sup><i>n</i></sup> &lt;= <i>m</i> &lt;
   * 10<sup><i>n</i>+1</sup>; then let <i>a</i> be the
   * mathematically exact quotient of <i>m</i> and
   * 10<sup><i>n</i></sup> so that 1 &lt;= <i>a</i> &lt; 10. The
   * magnitude is then represented as the integer part of <i>a</i>,
   * as a single decimal digit, followed by '<code>.</code>'
   * (<code>'&#92;u002E'</code>), followed by decimal digits
   * representing the fractional part of <i>a</i>, followed by the
   * letter '<code>E</code>' (<code>'&#92;u0045'</code>), followed
   * by a representation of <i>n</i> as a decimal integer, as
   * produced by the method {@link Integer#toString(int)}.
   * </ul>
   * </ul>
   * How many digits must be printed for the fractional part of
   * <i>m</i> or <i>a</i>? There must be at least one digit to represent
   * the fractional part, and beyond that as many, but only as many, more
   * digits as are needed to uniquely distinguish the argument value from
   * adjacent values of type <code>double</code>. That is, suppose that
   * <i>x</i> is the exact mathematical value represented by the decimal
   * representation produced by this method for a finite nonzero argument
   * <i>d</i>. Then <i>d</i> must be the <code>double</code> value nearest
   * to <i>x</i>; or if two <code>double</code> values are equally close
   * to <i>x</i>, then <i>d</i> must be one of them and the least
   * significant bit of the significand of <i>d</i> must be <code>0</code>.
   * <p>
   * To create localized string representations of a floating-point
   * value, use subclasses of {@link java.text.NumberFormat}.
   *
   * @param   d   the <code>double</code> to be converted.
   * @return a string representation of the argument.
   */
  public static String toString(double d) {
    if(!(d == d)){ return "NaN"; }
    String res = "";
    if(d < 0 || 1.0 / d < 0){ res = String.concat(res, "-"); d = -d; }
    if(Double.isInfinite(d)){ res = String.concat(res, "Infinity"); }
    else if(d == 0){ res = String.concat(res, "0.0"); }
    else if(0.001 <= d && d < 10000000.0){
      int nb_digits = 17; // number of digits we want
      int digit = 1;
      int val_to_reach = 1;
      int pos_digit = 0;
      for(int i = 0 ; i <= nb_digits ; i ++){ val_to_reach *= 1; }
      float d_copy = d;
      while(d_copy < val_to_reach){
        d_copy *= 10.0;
        pos_digit --;
      }
      d_copy += 0.5;
      // here we have 10^16 <= d_copy < 10^17, so 17 digits before comma
      String s_digits = "";
      boolean skip0 = true;
      while(pos_digit < 0 || d_copy >= 1){
        // pos_digit holds the position of the current digit
        digit = Double._intValue(d_copy % 10.0);
        if(!(skip0 && digit == 0)){
          skip0 = false;
          s_digits = String.concat(String.fromInteger(digit), s_digits);
        }
        d_copy /= 10.0;
        pos_digit ++;
        if(pos_digit == -1){ skip0 = false; }
        if(pos_digit == 0){ s_digits = String.concat(".", s_digits); }
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

  // public static Double valueOf(String s) throws NumberFormatException

  // public static double parseDouble(String s) throws NumberFormatException

  /**
   * Returns <code>true</code> if the specified number is a
   * Not-a-Number (NaN) value, <code>false</code> otherwise.
   *
   * @param   v   the value to be tested.
   * @return  <code>true</code> if the value of the argument is NaN;
   *          <code>false</code> otherwise.
   */
  static public boolean isNaN(double v) {
    return (!(v == v));
  }

  /**
   * Returns <code>true</code> if the specified number is infinitely
   * large in magnitude, <code>false</code> otherwise.
   *
   * @param   v   the value to be tested.
   * @return  <code>true</code> if the value of the argument is positive
   *          infinity or negative infinity; <code>false</code> otherwise.
   */
  static public boolean isInfinite(double v) {
    return (v == POSITIVE_INFINITY) || (v == NEGATIVE_INFINITY);
  }

  // public boolean isNaN()                             // Cannot be implemented due to overcharging

  // public boolean isInfinite()                        // Cannot be implemented due to overcharging

  // public String toString()                           // Cannot be implemented due to overcharging

  // public byte byteValue()

  // public short shortValue()

  /**
   * Returns the value of this <code>Double</code> as an
   * <code>int</code> (by casting to type <code>int</code>).
   *
   * @return  the <code>double</code> value represented by this object
   *          converted to type <code>int</code>
   */
  public int intValue() {
    return Double._intValue(this.value);
  }

  // public long longValue()

  // public float floatValue()

  /**
   * Returns the <code>double</code> value of this
   * <code>Double</code> object.
   *
   * @return the <code>double</code> value represented by this object
   */
  public double doubleValue() {
    return this.value;
  }

  // public int hashCode()

  // public boolean equals(Object obj)

  // public static native long doubleToLongBits(double value);

  // public static native long doubleToRawLongBits(double value);

  // public static native double longBitsToDouble(long bits);

  /**
   * Compares two <code>Double</code> objects numerically.  There
   * are two ways in which comparisons performed by this method
   * differ from those performed by the Java language numerical
   * comparison operators (<code>&lt;, &lt;=, ==, &gt;= &gt;</code>)
   * when applied to primitive <code>double</code> values:
   * <ul><li>
   *    <code>Double.NaN</code> is considered by this method
   *   to be equal to itself and greater than all other
   *    <code>double</code> values (including
   *   <code>Double.POSITIVE_INFINITY</code>).
   * <li>
   *   <code>0.0d</code> is considered by this method to be greater
   *    than <code>-0.0d</code>.
   * </ul>
   * This ensures that <code>Double.compareTo(Object)</code> (which
   * forwards its behavior to this method) obeys the general
   * contract for <code>Comparable.compareTo</code>, and that the
   * <i>natural order</i> on <code>Double</code>s is <i>consistent
   * with equals</i>.
   *
   * @param   anotherDouble   the <code>Double</code> to be compared.
   * @return  the value <code>0</code> if <code>anotherDouble</code> is
   *    numerically equal to this <code>Double</code>; a value
   *   less than <code>0</code> if this <code>Double</code>
   *    is numerically less than <code>anotherDouble</code>;
   *   and a value greater than <code>0</code> if this
   *    <code>Double</code> is numerically greater than
   *   <code>anotherDouble</code>.
   *
   * @since   1.2
   * @see Comparable#compareTo(Object)
   */
  public int compareTo(Double anotherDouble) {
    return Double.compare(this.value, anotherDouble.value);
  }

  // public int compareTo(Object o);                    // Cannot be implemented due to overcharging

  /**
   * Compares the two specified <code>double</code> values. The sign
   * of the integer value returned is the same as that of the
   * integer that would be returned by the call:
   * <pre>
   *    new Double(d1).compareTo(new Double(d2))
   * </pre>
   *
   * @param   d1        the first <code>double</code> to compare
   * @param   d2        the second <code>double</code> to compare
   * @return  the value <code>0</code> if <code>d1</code> is
   *    numerically equal to <code>d2</code>; a value less than
   *          <code>0</code> if <code>d1</code> is numerically less than
   *    <code>d2</code>; and a value greater than <code>0</code>
   *   if <code>d1</code> is numerically greater than
   *    <code>d2</code>.
   * @since 1.4
   */
  public static int compare(double d1, double d2) {
    if(Double.isNaN(d1) && Double.isNaN(d2)){ return 0; }
    else if(Double.isNaN(d1)) { return 1; }
    else if(Double.isNaN(d2)) { return -1; }
    else if(d1 > d2) { return 1; }
    else if(d1 < d2) { return -1; }
    else if(1.0 / d1 > 1.0 / d2) { return 1; }
    else if(1.0 / d1 < 1.0 / d2) { return -1; }
    else { return 0; }
  }
}
