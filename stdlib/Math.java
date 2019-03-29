/*
 * @(#)Math.java  1.57 03/01/23
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 * Modified for javabien
 */

package java.lang;
import java.util.Random;


public final strictfp class Math {
  /**
   * Don't let anyone instantiate this class.
   */
  private Math() {}



  /** *** Fields *** */

  /**
   * The <code>double</code> value that is closer than any other to
   * <i>e</i>, the base of the natural logarithms.
   */
  public static final double E = 2.7182818284590452354;

  /**
   * The <code>double</code> value that is closer than any other to
   * <i>pi</i>, the ratio of the circumference of a circle to its
   * diameter.
   */
  public static final double PI = 3.14159265358979323846;



  /** *** Methods *** */

  /**
   * Returns the trigonometric sine of an angle.  Special cases:
   * <ul><li>If the argument is NaN or an infinity, then the
   * result is NaN.
   * <li>If the argument is zero, then the result is a zero with the
   * same sign as the argument.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   an angle, in radians.
   * @return  the sine of the argument.
   */
  public static native double sin(double a); // originaly defined in StrictMath

  /**
   * Returns the trigonometric cosine of an angle. Special cases:
   * <ul><li>If the argument is NaN or an infinity, then the
   * result is NaN.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   an angle, in radians.
   * @return  the cosine of the argument.
   */
  public static native double cos(double a); // originaly defined in StrictMath

  /**
   * Returns the trigonometric tangent of an angle.  Special cases:
   * <ul><li>If the argument is NaN or an infinity, then the result
   * is NaN.
   * <li>If the argument is zero, then the result is a zero with the
   * same sign as the argument.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   an angle, in radians.
   * @return  the tangent of the argument.
   */
  public static native double tan(double a); // originaly defined in StrictMath

  /**
   * Returns the arc sine of an angle, in the range of -<i>pi</i>/2 through
   * <i>pi</i>/2. Special cases:
   * <ul><li>If the argument is NaN or its absolute value is greater
   * than 1, then the result is NaN.
   * <li>If the argument is zero, then the result is a zero with the
   * same sign as the argument.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   the value whose arc sine is to be returned.
   * @return  the arc sine of the argument.
   */
  public static native double asin(double a); // originaly defined in StrictMath

  /**
   * Returns the arc cosine of an angle, in the range of 0.0 through
   * <i>pi</i>.  Special case:
   * <ul><li>If the argument is NaN or its absolute value is greater
   * than 1, then the result is NaN.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   the value whose arc cosine is to be returned.
   * @return  the arc cosine of the argument.
   */
  public static native double acos(double a); // originaly defined in StrictMath

  /**
   * Returns the arc tangent of an angle, in the range of -<i>pi</i>/2
   * through <i>pi</i>/2.  Special cases:
   * <ul><li>If the argument is NaN, then the result is NaN.
   * <li>If the argument is zero, then the result is a zero with the
   * same sign as the argument.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   the value whose arc tangent is to be returned.
   * @return  the arc tangent of the argument.
   */
  public static native double atan(double a); // originaly defined in StrictMath

  /**
   * Converts an angle measured in degrees to an approximately
   * equivalent angle measured in radians.  The conversion from
   * degrees to radians is generally inexact.
   *
   * @param   angdeg   an angle, in degrees
   * @return  the measurement of the angle <code>angdeg</code>
   *          in radians.
   * @since   1.2
   */
  public static double toRadians(double angdeg) {
    return angdeg / 180.0 * Math.PI;
  }

  /**
   * Converts an angle measured in radians to an approximately
   * equivalent angle measured in degrees.  The conversion from
   * radians to degrees is generally inexact; users should
   * <i>not</i> expect <code>cos(toRadians(90.0))</code> to exactly
   * equal <code>0.0</code>.
   *
   * @param   angrad   an angle, in radians
   * @return  the measurement of the angle <code>angrad</code>
   *          in degrees.
   * @since   1.2
   */
  public static double toDegrees(double angrad) {
    return angrad * 180.0 / Math.PI;
  }

  /*
  static int min(int a, int b) {
          if (a < b) {
                  return a;
          } else {
                  return b;
          }
  }
  */
  /**
   * Returns Euler's number <i>e</i> raised to the power of a
   * <code>double</code> value.  Special cases:
   * <ul><li>If the argument is NaN, the result is NaN.
   * <li>If the argument is positive infinity, then the result is
   * positive infinity.
   * <li>If the argument is negative infinity, then the result is
   * positive zero.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   the exponent to raise <i>e</i> to.
   * @return  the value <i>e</i><sup><code>a</code></sup>,
   *          where <i>e</i> is the base of the natural logarithms.
   */
  public static native double exp(double a); // originaly defined in StrictMath

  /**
   * Returns the natural logarithm (base <i>e</i>) of a <code>double</code>
   * value.  Special cases:
   * <ul><li>If the argument is NaN or less than zero, then the result
   * is NaN.
   * <li>If the argument is positive infinity, then the result is
   * positive infinity.
   * <li>If the argument is positive zero or negative zero, then the
   * result is negative infinity.</ul>
   * <p>
   * A result must be within 1 ulp of the correctly rounded result.  Results
   * must be semi-monotonic.
   *
   * @param   a   a number greater than <code>0.0</code>.
   * @return  the value ln&nbsp;<code>a</code>, the natural logarithm of
   *          <code>a</code>.
   */
  public static native double log(double a); // originaly defined in StrictMath

  /**
   * Returns the correctly rounded positive square root of a
   * <code>double</code> value.
   * Special cases:
   * <ul><li>If the argument is NaN or less than zero, then the result
   * is NaN.
   * <li>If the argument is positive infinity, then the result is positive
   * infinity.
   * <li>If the argument is positive zero or negative zero, then the
   * result is the same as the argument.</ul>
   * Otherwise, the result is the <code>double</code> value closest to
   * the true mathematical square root of the argument value.
   *
   * @param   a   a value.
   * <!--@return  the value of &radic;&nbsp;<code>a</code>.-->
   * @return  the positive square root of <code>a</code>.
   *          If the argument is NaN or less than zero, the result is NaN.
   */
  public static native double sqrt(double a); // originaly defined in StrictMath

  // public static double IEEEremainder(double f1, double f2) // Needs StrictMath

  /**
   * Returns the smallest (closest to negative infinity)
   * <code>double</code> value that is not less than the argument and is
   * equal to a mathematical integer. Special cases:
   * <ul><li>If the argument value is already equal to a mathematical
   * integer, then the result is the same as the argument.
   * <li>If the argument is NaN or an infinity or positive zero or negative
   * zero, then the result is the same as the argument.
   * <li>If the argument value is less than zero but greater than -1.0,
   * then the result is negative zero.</ul>
   * Note that the value of <code>Math.ceil(x)</code> is exactly the
   * value of <code>-Math.floor(-x)</code>.
   *
   * @param   a   a value.
   * <!--@return  the value &lceil;&nbsp;<code>a</code>&nbsp;&rceil;.-->
   * @return  the smallest (closest to negative infinity)
   *          floating-point value that is not less than the argument
   *          and is equal to a mathematical integer.
   */
  public static native double ceil(double a); // originaly defined in StrictMath

  /**
   * Returns the largest (closest to positive infinity)
   * <code>double</code> value that is not greater than the argument and
   * is equal to a mathematical integer. Special cases:
   * <ul><li>If the argument value is already equal to a mathematical
   * integer, then the result is the same as the argument.
   * <li>If the argument is NaN or an infinity or positive zero or
   * negative zero, then the result is the same as the argument.</ul>
   *
   * @param   a   a <code>double</code> value.
   * <!--@return  the value &lfloor;&nbsp;<code>a</code>&nbsp;&rfloor;.-->
   * @return  the largest (closest to positive infinity)
   *          floating-point value that is not greater than the argument
   *          and is equal to a mathematical integer.
   */
  public static native double floor(double a); // originaly defined in StrictMath

  /**
   * Returns the <code>double</code> value that is closest in value
   * to the argument and is equal to a mathematical integer. If two
   * <code>double</code> values that are mathematical integers are
   * equally close, the result is the integer value that is
   * even. Special cases:
   * <ul><li>If the argument value is already equal to a mathematical
   * integer, then the result is the same as the argument.
   * <li>If the argument is NaN or an infinity or positive zero or negative
   * zero, then the result is the same as the argument.</ul>
   *
   * @param   a   a <code>double</code> value.
   * @return  the closest floating-point value to <code>a</code> that is
   *          equal to a mathematical integer.
   */
  public static double rint(double a){
    if(!(a == a)){ return a; } // a is NaN
    double f = Math.floor(a);
    if(f == a){ return a; } // a is equal to an int or +/- infinity
    double c = Math.ceil(a), df = a - f , dc = c - a;
    if(df < dc){ return f; }
    if(df > dc){ return c; }
    if(f % 2.0 == 0.0){ return f;}
    return c;
  }

  /**
   * Converts rectangular coordinates (<code>x</code>,&nbsp;<code>y</code>)
   * to polar (r,&nbsp;<i>theta</i>).
   * This method computes the phase <i>theta</i> by computing an arc tangent
   * of <code>y/x</code> in the range of -<i>pi</i> to <i>pi</i>. Special
   * cases:
   * <ul><li>If either argument is NaN, then the result is NaN.
   * <li>If the first argument is positive zero and the second argument
   * is positive, or the first argument is positive and finite and the
   * second argument is positive infinity, then the result is positive
   * zero.
   * <li>If the first argument is negative zero and the second argument
   * is positive, or the first argument is negative and finite and the
   * second argument is positive infinity, then the result is negative zero.
   * <li>If the first argument is positive zero and the second argument
   * is negative, or the first argument is positive and finite and the
   * second argument is negative infinity, then the result is the
   * <code>double</code> value closest to <i>pi</i>.
   * <li>If the first argument is negative zero and the second argument
   * is negative, or the first argument is negative and finite and the
   * second argument is negative infinity, then the result is the
   * <code>double</code> value closest to -<i>pi</i>.
   * <li>If the first argument is positive and the second argument is
   * positive zero or negative zero, or the first argument is positive
   * infinity and the second argument is finite, then the result is the
   * <code>double</code> value closest to <i>pi</i>/2.
   * <li>If the first argument is negative and the second argument is
   * positive zero or negative zero, or the first argument is negative
   * infinity and the second argument is finite, then the result is the
   * <code>double</code> value closest to -<i>pi</i>/2.
   * <li>If both arguments are positive infinity, then the result is the
   * <code>double</code> value closest to <i>pi</i>/4.
   * <li>If the first argument is positive infinity and the second argument
   * is negative infinity, then the result is the <code>double</code>
   * value closest to 3*<i>pi</i>/4.
   * <li>If the first argument is negative infinity and the second argument
   * is positive infinity, then the result is the <code>double</code> value
   * closest to -<i>pi</i>/4.
   * <li>If both arguments are negative infinity, then the result is the
   * <code>double</code> value closest to -3*<i>pi</i>/4.</ul>
   *
   * @param   y   the ordinate coordinate
   * @param   x   the abscissa coordinate
   * @return  the <i>theta</i> component of the point
   *          (<i>r</i>,&nbsp;<i>theta</i>)
   *          in polar coordinates that corresponds to the point
   *          (<i>x</i>,&nbsp;<i>y</i>) in Cartesian coordinates.
   */
  public static native double atan2(double y, double x); // originaly defined in StrictMath

  /**
   * Returns the value of the first argument raised to the power of the
   * second argument. Special cases:
   *
   * <ul><li>If the second argument is positive or negative zero, then the
   * result is 1.0.
   * <li>If the second argument is 1.0, then the result is the same as the
   * first argument.
   * <li>If the second argument is NaN, then the result is NaN.
   * <li>If the first argument is NaN and the second argument is nonzero,
   * then the result is NaN.
   *
   * <li>If
   * <ul>
   * <li>the absolute value of the first argument is greater than 1
   * and the second argument is positive infinity, or
   * <li>the absolute value of the first argument is less than 1 and
   * the second argument is negative infinity,
   * </ul>
   * then the result is positive infinity.
   *
   * <li>If
   * <ul>
   * <li>the absolute value of the first argument is greater than 1 and
   * the second argument is negative infinity, or
   * <li>the absolute value of the
   * first argument is less than 1 and the second argument is positive
   * infinity,
   * </ul>
   * then the result is positive zero.
   *
   * <li>If the absolute value of the first argument equals 1 and the
   * second argument is infinite, then the result is NaN.
   *
   * <li>If
   * <ul>
   * <li>the first argument is positive zero and the second argument
   * is greater than zero, or
   * <li>the first argument is positive infinity and the second
   * argument is less than zero,
   * </ul>
   * then the result is positive zero.
   *
   * <li>If
   * <ul>
   * <li>the first argument is positive zero and the second argument
   * is less than zero, or
   * <li>the first argument is positive infinity and the second
   * argument is greater than zero,
   * </ul>
   * then the result is positive infinity.
   *
   * <li>If
   * <ul>
   * <li>the first argument is negative zero and the second argument
   * is greater than zero but not a finite odd integer, or
   * <li>the first argument is negative infinity and the second
   * argument is less than zero but not a finite odd integer,
   * </ul>
   * then the result is positive zero.
   *
   * <li>If
   * <ul>
   * <li>the first argument is negative zero and the second argument
   * is a positive finite odd integer, or
   * <li>the first argument is negative infinity and the second
   * argument is a negative finite odd integer,
   * </ul>
   * then the result is negative zero.
   *
   * <li>If
   * <ul>
   * <li>the first argument is negative zero and the second argument
   * is less than zero but not a finite odd integer, or
   * <li>the first argument is negative infinity and the second
   * argument is greater than zero but not a finite odd integer,
   * </ul>
   * then the result is positive infinity.
   *
   * <li>If
   * <ul>
   * <li>the first argument is negative zero and the second argument
   * is a negative finite odd integer, or
   * <li>the first argument is negative infinity and the second
   * argument is a positive finite odd integer,
   * </ul>
   * then the result is negative infinity.
   *
   * <li>If the first argument is finite and less than zero
   * <ul>
   * <li> if the second argument is a finite even integer, the
   * result is equal to the result of raising the absolute value of
   * the first argument to the power of the second argument
   *
   * <li>if the second argument is a finite odd integer, the result
   * is equal to the negative of the result of raising the absolute
   * value of the first argument to the power of the second
   * argument
   *
   * <li>if the second argument is finite and not an integer, then
   * the result is NaN.
   * </ul>
   *
   * <li>If both arguments are integers, then the result is exactly equal
   * to the mathematical result of raising the first argument to the power
   * of the second argument if that result can in fact be represented
   * exactly as a <code>double</code> value.</ul>
   *
   * <p>(In the foregoing descriptions, a floating-point value is
   * considered to be an integer if and only if it is finite and a
   * fixed point of the method {@link #ceil <tt>ceil</tt>} or,
   * equivalently, a fixed point of the method {@link #floor
   * <tt>floor</tt>}. A value is a fixed point of a one-argument
   * method if and only if the result of applying the method to the
   * value is equal to the value.)
   *
   * @param   a   base.
   * @param   b   the exponent.
   * @return  the value <code>a<sup>b</sup></code>.
   */
  public static native double pow(double a, double b); // originaly defined in StrictMath

  // public static int round(float a)                   // Cannot be implemented due to overcharging

  /**
   * Returns the closest <code>long</code> to the argument. The result
   * is rounded to an integer by adding 1/2, taking the floor of the
   * result, and casting the result to type <code>long</code>. In other
   * words, the result is equal to the value of the expression:
   * <p><pre>(long)Math.floor(a + 0.5d)</pre>
   * <p>
   * Special cases:
   * <ul><li>If the argument is NaN, the result is 0.
   * <li>If the argument is negative infinity or any value less than or
   * equal to the value of <code>Long.MIN_VALUE</code>, the result is
   * equal to the value of <code>Long.MIN_VALUE</code>.
   * <li>If the argument is positive infinity or any value greater than or
   * equal to the value of <code>Long.MAX_VALUE</code>, the result is
   * equal to the value of <code>Long.MAX_VALUE</code>.</ul>
   *
   * @param   a   a floating-point value to be rounded to a
   *    <code>long</code>.
   * @return  the value of the argument rounded to the nearest
   *          <code>long</code> value.
   * @see     java.lang.Long#MAX_VALUE
   * @see     java.lang.Long#MIN_VALUE
   */
  public static long round(double a){
    return (new Double(Math.floor(a + 0.5))).intValue();
  }

  // private static Random randomNumberGenerator;       // Needs Random

  // private static synchronized void initRG()          // Needs Random

  // public static double random()                      // Needs Random

  // public static int abs(int a)                       // Cannot be implemented due to overcharging

  // public static long abs(long a)                     // Cannot be implemented due to overcharging

  // public static float abs(float a)                   // Cannot be implemented due to overcharging

  /**
   * Returns the absolute value of a <code>double</code> value.
   * If the argument is not negative, the argument is returned.
   * If the argument is negative, the negation of the argument is returned.
   * Special cases:
   * <ul><li>If the argument is positive zero or negative zero, the result
   * is positive zero.
   * <li>If the argument is infinite, the result is positive infinity.
   * <li>If the argument is NaN, the result is NaN.</ul>
   * In other words, the result is the same as the value of the expression:
   * <p><code>Double.longBitsToDouble((Double.doubleToLongBits(a)&lt;&lt;1)&gt;&gt;&gt;1)</code>
   *
   * @param   a   the argument whose absolute value is to be determined
   * @return  the absolute value of the argument.
   */
  public static double abs(double a) {
    if(a <= 0.0){ return 0.0 - a; }
    else{ return a; }
    // return (a <= 0.0D) ? 0.0D - a : a;
  }

  // public static int max(int a, int b)                // Cannot be implemented due to overcharging

  // public static long max(long a, long b)             // Cannot be implemented due to overcharging

  // private static long negativeZeroFloatBits = Float.floatToIntBits(-0.0f);

  // private static long negativeZeroDoubleBits = Double.doubleToLongBits(-0.0d);

  // public static float max(float a, float b)          // Cannot be implemented due to overcharging

  /**
   * Returns the greater of two <code>double</code> values.  That
   * is, the result is the argument closer to positive infinity. If
   * the arguments have the same value, the result is that same
   * value. If either value is NaN, then the result is NaN.  Unlike
   * the the numerical comparison operators, this method considers
   * negative zero to be strictly smaller than positive zero. If one
   * argument is positive zero and the other negative zero, the
   * result is positive zero.
   *
   * @param   a   an argument.
   * @param   b   another argument.
   * @return  the larger of <code>a</code> and <code>b</code>.
   */
  public static double max(double a, double b) {
    if (!(a == a)) return a;  // a is NaN
    if((1.0 / a == Double.NEGATIVE_INFINITY) && (b == 0.0)){ return b; }
    if(a >= b){ return a; }
    else{ return b; }
  }

  // public static int min(int a, int b)                // Cannot be implemented due to overcharging

  // public static long min(long a, long b)             // Cannot be implemented due to overcharging

  // public static float min(float a, floatb)           // Cannot be implemented due to overcharging

  /**
   * Returns the smaller of two <code>double</code> values.  That
   * is, the result is the value closer to negative infinity. If the
   * arguments have the same value, the result is that same
   * value. If either value is NaN, then the result is NaN.  Unlike
   * the the numerical comparison operators, this method considers
   * negative zero to be strictly smaller than positive zero. If one
   * argument is positive zero and the other is negative zero, the
   * result is negative zero.
   *
   * @param   a   an argument.
   * @param   b   another argument.
   * @return  the smaller of <code>a</code> and <code>b</code>.
   */
  public static double min(double a, double b) {
    if (!(a == a)) return a;  // a is NaN
    if ((a == 0.0) && (1.0 / b == Double.NEGATIVE_INFINITY)){ return b ; }
    if(a <= b){ return a; }
    else{ return b; }
  }
}
