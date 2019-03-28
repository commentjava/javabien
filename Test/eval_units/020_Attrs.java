//: 15
//: 16
//: 17
//: 19
//: 20
//: 21

class A {
        int a = 15;
        int b = 17;
        static int c = 19;
        static int d = 20;
        void f() {
                Debug.debug(a);

                int b = 16;
                Debug.debug(b);
                Debug.debug(this.b);

                Debug.debug(c);
                Debug.debug(d);
        }
}

class Main {
        static int d = 21;
        static void main(String[] args) {
                A a = new A();
                a.f();
                Debug.debug(d);
        }
}
