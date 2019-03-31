// Constants
//: 2.71828182846
//: 3.14159265359

// sin
//: -nan
// why ??
//: -nan
//: -nan
//: 1.
//: 0.5

// cos
//: -nan
//: -nan
//: -nan
//: true
//: 0.5

// tan
//: -nan
//: -nan
//: -nan
//: true
//: 1.

// asin
//: -nan
//: nan
//: 1.57079632679
//: 0.523598775598

// acos
//: -nan
//: nan
//: 0.
//: 1.0471975512

// atan
//: -nan
//: 1.57079632679
//: 0.785398163397
//: 0.463647609001

// toRadians, toDegrees
//: 1.57079632679
//: 90.

// exp
//: 7.38905609893
//: 148.413159103
//: -nan
//: inf
//: 0.

// log
//: 0.69314718056
//: 1.60943791243
//: nan
//: -nan
//: inf
//: -inf

// exp, log
//: 23.75432
//: 23.75432

// sqrt
//: -nan
//: -nan
//: inf
//: 0.
//: 1.41421356237

// ceil
//: 5.
//: -nan
//: inf
//: -inf
//: 5.
//: -0.

// floor
//: 5.
//: -nan
//: inf
//: -inf
//: 4.
//: -1.

// rint
//: 5.
//: -nan
//: inf
//: -inf
//: 4.
//: -0.
//: 0.
//: 2.

// atan2
//: -nan
//: -nan
//: 0.
//: 0.
//: -0.
//: -0.
//: 3.14159265359
//: 3.14159265359
//: -3.14159265359
//: -3.14159265359
//: 1.57079632679
//: 1.57079632679
//: 1.57079632679
//: 1.57079632679
//: -1.57079632679
//: -1.57079632679
//: -1.57079632679
//: -1.57079632679
//: 0.785398163397
//: 2.35619449019
//: -0.785398163397
//: -2.35619449019
//: 0.643501108793
//: -0.380506377112

// pow
//: 1.
//: 1.
//: 5.2
//: -nan
//: 1.
//: -nan
//: inf
//: inf
//: 0.
//: 0.
//: nan
//: nan
//: 0.
//: 0.
//: inf
//: inf
//: 0.
//: 0.
//: -0.
//: -0.
//: inf
//: inf
//: -inf
//: -inf
//: 0.00136768670565
//: -0.000263016674163
//: -nan
//: -32.

// round
//: 0
//: -4611686018427387904
//: -4611686018427387904
//: 4611686018427387903
//: 4611686018427387903
//: 6
//: 4
//: 3

// abs
//: 5.7
//: 5.7
//: 0.
//: 0.
//: inf
//: inf
//: -nan

// max
//: 6.7
//: 7.7
//: inf
//: -nan
//: -nan
//: 0.
//: 0.

// min
//: 11.7
//: 13.7
//: -inf
//: -nan
//: -nan
//: -0.
//: -0.

class Main{
  public static void main(String[] args){
    System.initializeSystemClass();  // Mandatory call

    // Constants
    Debug.debug(Math.E);
    Debug.debug(Math.PI);

    // sin
    Debug.debug(Math.sin(Double.NaN));
    Debug.debug(Math.sin(Double.POSITIVE_INFINITY));
    Debug.debug(Math.sin(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.sin(Math.PI / 2));
    Debug.debug(Math.sin(Math.PI / 6));

    // cos
    Debug.debug(Math.cos(Double.NaN));
    Debug.debug(Math.cos(Double.POSITIVE_INFINITY));
    Debug.debug(Math.cos(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.cos(Math.PI / 2) < Math.pow(10.0, -10.0));
    Debug.debug(Math.cos(Math.PI / 3));

    // tan
    Debug.debug(Math.tan(Double.NaN));
    Debug.debug(Math.tan(Double.POSITIVE_INFINITY));
    Debug.debug(Math.tan(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.tan(Math.PI / 2) > Math.pow(10, 10));
    Debug.debug(Math.tan(Math.PI / 4));

    // asin
    Debug.debug(Math.asin(Double.NaN));
    Debug.debug(Math.asin(2.0));
    Debug.debug(Math.asin(1.0));
    Debug.debug(Math.asin(0.5));

    // acos
    Debug.debug(Math.acos(Double.NaN));
    Debug.debug(Math.acos(2.0));
    Debug.debug(Math.acos(1.0));
    Debug.debug(Math.acos(0.5));

    // atan
    Debug.debug(Math.atan(Double.NaN));
    Debug.debug(Math.atan(Double.POSITIVE_INFINITY));
    Debug.debug(Math.atan(1.0));
    Debug.debug(Math.atan(0.5));

    // toRadians, toDegrees
    Debug.debug(Math.toRadians(90));
    Debug.debug(Math.toDegrees(Math.PI / 2));

    // exp
    Debug.debug(Math.exp(2.0));
    Debug.debug(Math.exp(5.0));
    Debug.debug(Math.exp(Double.NaN));
    Debug.debug(Math.exp(Double.POSITIVE_INFINITY));
    Debug.debug(Math.exp(Double.NEGATIVE_INFINITY));

    // log
    Debug.debug(Math.log(2.0));
    Debug.debug(Math.log(5.0));
    Debug.debug(Math.log(-1));
    Debug.debug(Math.log(Double.NaN));
    Debug.debug(Math.log(Double.POSITIVE_INFINITY));
    Debug.debug(Math.log(0));

    // exp, log
    Debug.debug(Math.exp(Math.log(23.75432)));
    Debug.debug(Math.log(Math.exp(23.75432)));

    // sqrt
    Debug.debug(Math.sqrt(Double.NaN));
    Debug.debug(Math.sqrt(-1));
    Debug.debug(Math.sqrt(Double.POSITIVE_INFINITY));
    Debug.debug(Math.sqrt(0.0));
    Debug.debug(Math.sqrt(2));

    // ceil
    Debug.debug(Math.ceil(5.0));
    Debug.debug(Math.ceil(Double.NaN));
    Debug.debug(Math.ceil(Double.POSITIVE_INFINITY));
    Debug.debug(Math.ceil(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.ceil(4.2));
    Debug.debug(Math.ceil(-0.7));

    // floor
    Debug.debug(Math.floor(5.0));
    Debug.debug(Math.floor(Double.NaN));
    Debug.debug(Math.floor(Double.POSITIVE_INFINITY));
    Debug.debug(Math.floor(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.floor(4.2));
    Debug.debug(Math.floor(-0.7));

    // rint
    Debug.debug(Math.rint(5.0));
    Debug.debug(Math.rint(Double.NaN));
    Debug.debug(Math.rint(Double.POSITIVE_INFINITY));
    Debug.debug(Math.rint(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.rint(4.2));
    Debug.debug(Math.rint(-0.3));
    Debug.debug(Math.rint(0.5));
    Debug.debug(Math.rint(1.5));

    // atan2
    Debug.debug(Math.atan2(Double.NaN, 0.5));
    Debug.debug(Math.atan2(0.5, Double.NaN));
    Debug.debug(Math.atan2(0.0, 3.0));
    Debug.debug(Math.atan2(3.0, Double.POSITIVE_INFINITY));
    Debug.debug(Math.atan2(1.0 / Double.NEGATIVE_INFINITY, 3.0));
    Debug.debug(Math.atan2(-3.0, Double.POSITIVE_INFINITY));
    Debug.debug(Math.atan2(0.0, -3.0));
    Debug.debug(Math.atan2(3.0, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.atan2(1.0 / Double.NEGATIVE_INFINITY, -3.0));
    Debug.debug(Math.atan2(-3.0, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.atan2(3.0, 0.0));
    Debug.debug(Math.atan2(3.0, 1.0 / Double.NEGATIVE_INFINITY));
    Debug.debug(Math.atan2(Double.POSITIVE_INFINITY, 3.0));
    Debug.debug(Math.atan2(Double.POSITIVE_INFINITY, -3.0));
    Debug.debug(Math.atan2(-3.0, 0.0));
    Debug.debug(Math.atan2(-3.0, 1.0 / Double.NEGATIVE_INFINITY));
    Debug.debug(Math.atan2(Double.NEGATIVE_INFINITY, 3.0));
    Debug.debug(Math.atan2(Double.NEGATIVE_INFINITY, -3.0));
    Debug.debug(Math.atan2(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY));
    Debug.debug(Math.atan2(Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.atan2(Double.NEGATIVE_INFINITY, Double.POSITIVE_INFINITY));
    Debug.debug(Math.atan2(Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.atan2(3.0, 4.0));
    Debug.debug(Math.atan2(-2.0, 5.0));

    // pow
    Debug.debug(Math.pow(5.2, 0.0));
    Debug.debug(Math.pow(5.2, 1.0 / Double.NEGATIVE_INFINITY));
    Debug.debug(Math.pow(5.2, 1.0));
    Debug.debug(Math.pow(5.2, Double.NaN));
    Debug.debug(Math.pow(Double.NaN, 0.0));
    Debug.debug(Math.pow(Double.NaN, 5.2));
    Debug.debug(Math.pow(-5.2, Double.POSITIVE_INFINITY));
    Debug.debug(Math.pow(0.52, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.pow(-5.2, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.pow(0.52, Double.POSITIVE_INFINITY));
    Debug.debug(Math.pow(1.0, Double.POSITIVE_INFINITY));
    Debug.debug(Math.pow(1.0, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.pow(0.0, 5.2));
    Debug.debug(Math.pow(Double.POSITIVE_INFINITY, -5.2));
    Debug.debug(Math.pow(0.0, -5.2));
    Debug.debug(Math.pow(Double.POSITIVE_INFINITY, 5.2));
    Debug.debug(Math.pow(1.0 / Double.NEGATIVE_INFINITY, 5.2));
    Debug.debug(Math.pow(Double.NEGATIVE_INFINITY, -5.2));
    Debug.debug(Math.pow(1.0 / Double.NEGATIVE_INFINITY, 5.0));
    Debug.debug(Math.pow(Double.NEGATIVE_INFINITY, -5.0));
    Debug.debug(Math.pow(1.0 / Double.NEGATIVE_INFINITY, -5.2));
    Debug.debug(Math.pow(Double.NEGATIVE_INFINITY, 5.2));
    Debug.debug(Math.pow(1.0 / Double.NEGATIVE_INFINITY, -5.0));
    Debug.debug(Math.pow(Double.NEGATIVE_INFINITY, 5.0));
    Debug.debug(Math.pow(-5.2, -4.0));
    Debug.debug(Math.pow(-5.2, -5.0));
    Debug.debug(Math.pow(-5.2, -5.2));
    Debug.debug(Math.pow(-2.0, 5.0));

    // round
    Debug.debug(Math.round(Double.NaN));
    Debug.debug(Math.round(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.round(-5611686018427387903.0));
    Debug.debug(Math.round(Double.POSITIVE_INFINITY));
    Debug.debug(Math.round(5611686018427387903.0));
    Debug.debug(Math.round(5.7));
    Debug.debug(Math.round(4.3));
    Debug.debug(Math.round(2.5));

    // abs
    Debug.debug(Math.abs(5.7));
    Debug.debug(Math.abs(-5.7));
    Debug.debug(Math.abs(0.0));
    Debug.debug(Math.abs(1.0 / Double.NEGATIVE_INFINITY));
    Debug.debug(Math.abs(Double.POSITIVE_INFINITY));
    Debug.debug(Math.abs(Double.NEGATIVE_INFINITY));
    Debug.debug(Math.abs(Double.NaN));

    // max
    Debug.debug(Math.max(5.1, 6.7));
    Debug.debug(Math.max(7.7, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.max(8.7, Double.POSITIVE_INFINITY));
    Debug.debug(Math.max(Double.NaN, 9.7));
    Debug.debug(Math.max(10.7, Double.NaN));
    Debug.debug(Math.max(0.0, 1.0 / Double.NEGATIVE_INFINITY));
    Debug.debug(Math.max(1.0 / Double.NEGATIVE_INFINITY, 0.0));

    // min
    Debug.debug(Math.min(11.7, 12.7));
    Debug.debug(Math.min(13.7, Double.POSITIVE_INFINITY));
    Debug.debug(Math.min(14.7, Double.NEGATIVE_INFINITY));
    Debug.debug(Math.min(Double.NaN, 15.7));
    Debug.debug(Math.min(16.7, Double.NaN));
    Debug.debug(Math.min(0.0, 1.0 / Double.NEGATIVE_INFINITY));
    Debug.debug(Math.min(1.0 / Double.NEGATIVE_INFINITY, 0.0));

  }
}
    
