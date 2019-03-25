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
    int a = OtherClass.f() + OtherClass.g();
    int b = OtherClass.f() + 4;
    Debug.dumpMemory();
  }
}
