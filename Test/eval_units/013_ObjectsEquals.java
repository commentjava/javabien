//: 1
//: 2
//: 3
//: 4
//: 5
//: 6
//: 7
//: 8

class C {
        int a;
}

class Main {
        static void main(String[] args) {
                C c1 = new C();
                c1.a = 0;

                C c2 = c1;

                C c3 = new C();
                c3.a = 0;

                C c4;

                if (c1 == c2) {
                        Debug.debug(1);
                }
                if (c1 == c3) {
                        Debug.debug(0);
                } else {
                        Debug.debug(2);
                }
                if (c4 == null) {
                        Debug.debug(3);
                }
                if (null == c4) {
                        Debug.debug(4);
                }
                if (null == null) {
                        Debug.debug(5);
                }
                if (null == c3) {
                        Debug.debug(0);
                } else {
                        Debug.debug(6);
                }

                if (c2 != c3) {
                        Debug.debug(7);
                }
                if (c2 != null) {
                        Debug.debug(8);
                }


        }
}
