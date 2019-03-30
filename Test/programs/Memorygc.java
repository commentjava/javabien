class OtherClass{
  public static int f(){
    return 1001 + 1002;
  }
  public static int g(){
    return 1003 + 1004;
  }
  public static int h(){
    return 1005 + 1006;
  }
}

class Memorygc{
  static void main(String[] args){
    System.initializeSystemClass();  // Not handled by the evaluator
    int a = OtherClass.f() + OtherClass.g();
    int b = OtherClass.f() + 4;
    //Debug.dumpMemory();
    System.out.println(Double.toString(Double.POSITIVE_INFINITY));
    System.out.println(Double.toString(Double.NEGATIVE_INFINITY));
    System.out.println(Double.toString(Double.NaN));
    System.out.println(Double.toString(0));
    System.out.println(Double.toString(2.0));
    System.out.println(Double.toString(4.7));
    System.out.println(Double.toString(.792346));
    System.out.println(Double.toString(0.00000000235657));
    System.out.println(Double.toString(100000000000000.0));
/*
    Debug.debug("coucou");
    Debug.debug(Integer.parseInt("65315"));
    Debug.debug(Double.NaN == Double.NaN);
    Debug.debug(Double.NaN != Double.NaN);
    Debug.debug("coucou");
*/
    double d = -2.0 + 4.0;
    System.out.println(Double.toString(0.0));
    String s = Double.toString(d);
    System.out.println(Double.toString(d));
  }
}
