package java.lang;


class Math {

  /** *** Fields *** */
  // public static double E
  // public static double PI



  /** *** Hidden fialds *** */
  /** Holds the natural logarithm of the value 2 */
  private static double ln2 = Math.ln_suite(2.0);



  /** *** Methods *** */

  // static double abs(double a)

  // static float abs(float a)

  // static int abs(int a)

  // static long abs(long a)

  // static double acos(double a)

  // static int addExact(int x, int y)

  // static long addExact(long x, long y)

  // static double asin(double a)

  // static double atan(double a)

  // static double atan2(double y, double x)

  // static double cbrt(double a)

  // static double ceil(double a)

  // static double copySign(double magnitude, double sign)

  // static float copySign(float magnitude, float sign)

  // static double cos(double a)

  // static double cosh(double x)

  // static int decrementExact(int a)

  // static long decrementExact(long a)

  /**
   * Returns Euler's number e raised to the power of a double value.
   *
   * @param   a   the exponent to raise e to.
   * @return  the value e^a, where e is the base of the natural logarithms.
   */
  static double exp(double a){
    if(Double.isNaN(a)){ return Double.NaN; }
    if(a == Double.POSITIVE_INFINITY){ return Double.POSITIVE_INFINITY; }
    if(a == Double.NEGATIVE_INFINITY){ return 0.0; }
    int p = 0;
    double b = a;
    while(b <= -0.5 || 0.5 <= b){
      b /= 2.0;
      p ++;
    }
    double res = Math.exp_suite(b);
    for(int i = 0 ; i < p ; i ++){
      res *= res;
    }
    return res;
  }

  // static double expm1(double x)

  // static double floor(double a)

  // static int floorDiv(int x, int y)

  // static long floorDiv(long x, long y)

  // static int floorMod(int x, int y)

  // static long floorMod(long x, long y)

  // static int getExponent(double d)

  // static int getExponent(float f)

  // static double hypot(double x, double y)

  // static double IEEEremainder(double f1, double f2)

  // static int incrementExact(int a)

  // static long incrementExact(long a)

  /**
   * Returns the natural logarithm (base e) of a double value.
   *
   * @param   a   a value.
   * @return  the value ln a, the natural logarithm of a.
   */
  static double log(double a){
    if(Double.isNaN(a) || a < 0){ return Double.NaN; }
    if(Double .isInfinite(a)){ return Double.POSITIVE_INFINITY; }
    if(a == 0){ return Double.NEGATIVE_INFINITY; }
    int p = 0;
    double b = a;
    while(b >= 2){
      b /= 2.0;
      p ++;
    }
    return p * Math.ln2 + Math.ln_suite(b);
  }

  // static double log10(double a)

  // static double log1p(double x)

  // static double max(double a, double b)

  // static float max(float a, float b)

  // static int max(int a, int b)

  // static long max(long a, long b)

  // static double min(double a, double b)

  // static float min(float a, floatb)

  static int min(int a, int b) {
          if (a < b) {
                  return a;
          } else {
                  return b;
          }
  }

  // static long min(long a, long b)

  // static int multiplyExact(int x, int y)

  // static long multiplyExact(long x, long y)

  // static int negateExact(int a)

  // static long negateExact(long a)

  // static double nextAfter(double start, double direction)

  // static float nextAfter(float start, float direction)

  // static double nextDown(double d)

  // static float nextDown(float f)

  // static double nextUp(double d)

  // static float nextUp(float f)

  // static double pow(double a, double b)

  // static double random()

  // static double rint(double a)

  // static long round(double a)

  // static int round(float a)

  // static double scalb(double d, int scaleFactor)

  // static float scalb(float f, int scaleFactor)

  // static double signum(double d)

  // static float signum(float f)

  // static double sin(double a)

  // static double sinh(double a)

  // static double sqrt(double a)

  // static int subtractExact(int x, int y)

  // static long subtractExact(long x, long y)

  // static double tan(double a)

  // static double tanh(double x)

  // static double toDegrees(double angrad)

  // static int toIntExact(long value)

  // static double toRadian(double angdeg)

  // static double ulp(double d)

  // static float ulp(float f)



  /** *** Hidden methods *** */

  /** Auxiliary function for 'static double Math.log(double a)'
    * Computes the natural logarithm of d using the suite decomposition
    * d must be in ]0 ; 2[ in order to :
    *   - have a correct answer
    *   - have a quick convergence and, as a consequence, a good precision
    */
  private static double ln_suite(double d){
    int iter_max = 50;
    double res = 0.0, coef = (d - 1.0) / (d + 1.0), sq_coef = coef * coef;
    for(int i = iter_max ; i >= 0 ; i --){
      res = 1.0 / (2 * i + 1) + sq_coef * res;
    }
    return 2.0 * coef * res;
  }

  /** Auxiliary finction for 'static double Math.exp(double a)'
    * Computes the the Euler's number raised to the power of d, usin the suite decomposition
    * d must be in ]-1/2 ; 1/2[ in order to have quick convergence and, as a consequence, a good precision
    */
  private static double exp_suite(double d){
    int iter_max = 60;
    double res = 0.0;
    for(int i = iter_max ; i > 0 ; i --){
      res = 1 + (1.0 * d / i) * res;
    }
    return res;
  }


  static public native int pow(int a, int b) {}
}
