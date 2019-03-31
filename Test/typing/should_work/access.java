class C {

    public class D {

        D() {}
        public int myMethod() {
            return 1;
        }
    }

    C() {}

    public int myMethod() {
        return 2;
    }
}
class A {

    class B {
        public int myMethod() {
            return 3;
        }

        B(int i) {}
    }

    public int myMethod() {
        return 4;
    }

    public int myMethod(int i) {
        return 4;
    }

    public static void main(String[] args) {
        int a = myMethod();
        int e = myMethod(1);
        int b = B.myMethod();
        int c = C.myMethod();
        int d = C.D.myMethod();
        C.D objectD = new C.D();
        C objectC = new C();
        B objectBb = new B(1);
        A objectA = new A();
    }
}
