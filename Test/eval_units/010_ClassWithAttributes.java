//: 10
//: 20

class TestClass {
        int myattr;

        void setMyAttr(int a) {
                this.myattr = a;
        }

        int getMyAttr() {
                return this.myattr;
        }
}

class HelloWorld {
        static void main() {
                int a = 5;
                int b = 10;
                int c;
                int d;
                TestClass t = new TestClass();
                TestClass u = new TestClass();
                t.setMyAttr(2*a);
                u.setMyAttr(2*b);
                c = t.getMyAttr();
                d = u.getMyAttr();
                Debug.debug(c);
                Debug.debug(d);
        }
}
