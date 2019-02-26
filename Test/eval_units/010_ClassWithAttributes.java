//: 10
//: 20
//: 7
//: 14
//: 7
//: null

class TestClass {
        int myattr;

        void setMyAttr(int a) {
                this.myattr = a;
        }

        int getMyAttr() {
                return this.myattr;
        }
}

class TestClass2 {
        int simpleAttr = 7;

        void setMyAttr(int a) {
                this.simpleAttr = a;
        }

        int getMyAttr() {
                return this.simpleAttr;
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

                TestClass2 v = new TestClass2();
                TestClass2 w = new TestClass2();
                Debug.debug(v.getMyAttr());

                v.setMyAttr(v.getMyAttr() + v.getMyAttr());
                Debug.debug(v.getMyAttr());
                Debug.debug(w.getMyAttr());
                
                TestClass x = new TestClass();
                Debug.debug(x.getMyAttr());
        }
}
