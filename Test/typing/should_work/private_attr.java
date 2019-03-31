public class B {

    class A {
        class C {
            private int attrA;
        }

        public void myMethod() {
            A.C.attrA = 2;
        }

    }

    private int attr;

    public static void main(String[] args) {
        B b = new B();
        b.attr = 1;
    }
}