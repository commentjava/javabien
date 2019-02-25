//: 2
//: 1

class HelloWorld {
        static void main() {
                int a = 1;
                int b = a;
                if (true) {
                        a = 2;
                }
                Debug.debug(a);
                Debug.debug(b);
        }
}
