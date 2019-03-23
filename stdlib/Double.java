package java.lang;

class Double{
  /** Fields. */
  public static final int MAX_EXPONENT = 1023;
  public static final double MAX_VALUE = (2 - (1.0 / (1 << 52))) *
    (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) *
    (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) *
    (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) *
    (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 50)) * (1.0 * (1 << 23));
  public static final int MIN_EXPONENT = -1022;
  // public static final double MIN_NORMAL
  // public static final double MIN_VALUE
  public static final double NaN = 0.0 / 0.0;
  // public static final double NEGATIVE_INFINITY
  // public static final double POSITIVE_INFINITY
  public static final int SIZE = 64;
  public static final int BYTES = 8;
  // public static final java.lang.Class TYPE
  // private static final long serialVersionUID = -9172774392245257468L;

  /** The double value. */
  private final double value;

  /**
   * Initializes a newly created <code>Double</code> object so that it
   * represents a zero value.
   */
  public Double(double d){
    this.value = d;
  }
  // public Double(String s) throws java.lang.NumberFormatException

  // public static String toString(double d)
  // public static String toHexString(double d)
  // public static Double valueOf(String s)
  // public static Double valueOf(double d)
  // public static double parseDouble(String s)
  // public static boolean isNaN(double d)
  // public static boolean isInfinite(double d)
  // public static boolean isFinite(double d)
  // public boolean isNaN()
  // public boolean isInfinite()
  // public String toString()
  // public byte byteValue()
  // public short shortValue()
  // public int intValue()
  // public long longValue()
  public float floatValue(){
    return this.value;
  }
  public double doubleValue(){
    return this.value;
  }
  // public int hashCode()
  // public static int hashCode(double d)
  // public boolean equals(Object obj)
  // public static long doubleToLongBits(double d)
  // public static native long doubleToRawLongBits(double d)
  // public static native double longBitsToDouble(long l)
  // public int compareTo(Double anotherDouble)
  // public static int compare(double d1, double d2)
  // public static double sum(double d1, double d2)
  // public static double max(double d1, double d2)
  // public static double min(double d1, double d2)
  // public bridge synthetic int compareTo(Double)


}
