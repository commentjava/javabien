package java.lang;

class Double{
  /** Hacks */
  private static native final double _max_value();
  private static native final double _min_normal();
  private static native final double _min_value();
  private static native final double _nan();
  private static native final double _negative_infinity();
  private static native final double _positive_infinity();

  private static native final boolean _isNaN(double d);
  private static native final boolean _isInfinite(double d);
  private static native final boolean _intValue(double d);

  /** Fields */
  public static final int MAX_EXPONENT = 1023;
  public static final double MAX_VALUE = Double._max_value();
  public static final int MIN_EXPONENT = -1022;
  public static final double MIN_NORMAL = Double._min_normal();
  public static final double MIN_VALUE = Double._min_value();
  public static final double NaN = Double._nan();
  public static final double NEGATIVE_INFINITY = Double._negative_infinity();
  public static final double POSITIVE_INFINITY = Double._positive_infinity();
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
  // public Double(String s) throws java.lang.NumberFormatException // Not possible due to overload

  // public static String toString(double d)
  // public static String toHexString(double d)
  // public static Double valueOf(String s) // Not possible due to overload
  public static Double valueOf(double d){
    return new Double(d);
  }
  // public static double parseDouble(String s) // Not possible due to exceptions raising
  public static boolean isNaN(double d){
    return Double._isNaN(d);
  }
  public static boolean isInfinite(double d){
    return Double._isInfinite(d);
  }
  public static boolean isFinite(double d){
    return !(Double._isInfinite(d));
  }
  // public boolean isNaN() // Not possible due to overload
  // public boolean isInfinite() // Not possible due to overload
  // public String toString()
  // public byte byteValue()
  // public short shortValue()
  public int intValue(){
    return Double._intValue(this.value);
  }
  public long longValue(){
    return Double._intValue(this.value);
  }
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
  public static int compare(double d1, double d2){
    if(Double.isNaN(d1) && Double.isNaN(d2)){ return 0; }
    else if(Double.isNaN(d1)) { return 1; }
    else if(Double.isNaN(d2)) { return -1; }
    else if(d1 > d2) { return 1; }
    else if(d1 == d2) { return 0; }
    else { return -1; }
  }
  public int compareTo(Double anotherDouble){
    return Double.compare(this.value, anotherDouble.doubleValue());
  }
  public static double sum(double d1, double d2){
    return d1 + d2;
  }
  public static double max(double d1, double d2){
    if(d1 > d2){
      return d1;
    }
    else{
      return d2;
    }
  }
  public static double min(double d1, double d2){
    if(d1 > d2){
      return d2;
    }
    else{
      return d1;
    }
  }
  // public bridge synthetic int compareTo(Double)


}
