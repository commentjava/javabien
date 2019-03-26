//: 0.69314718056
//: 1.60943791243
//: nan
//: nan
//: inf
//: -inf

//: 7.38905609893
//: 148.413159103
//: nan
//: inf
//: 0.

class Main{
  public static void main(String[] args){
    System.initializeSystemClass();  // Mandatory call

    //System.out.println("0.6931471805599453 expected");
    Debug.debug(Math.log(2.0));
    //System.out.println("1.6094379124341003 expected");
    Debug.debug(Math.log(5.0));
    Debug.debug(Math.log(-1));
    Debug.debug(Math.log(Double.NaN));
    Debug.debug(Math.log(Double.POSITIVE_INFINITY));
    Debug.debug(Math.log(0));

    Debug.debug(Math.exp(2.0));
    Debug.debug(Math.exp(5.0));
    Debug.debug(Math.exp(Double.NaN));
    Debug.debug(Math.exp(Double.POSITIVE_INFINITY));
    Debug.debug(Math.exp(Double.NEGATIVE_INFINITY));
  }
}
    
