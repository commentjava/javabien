//: 2
//: 1

class Main {
        static void main(String[] args) {
                int a = 1;
                int b = a;
                if (true) {
                        a = 2;
                }
                Debug.debug(a);
                Debug.debug(b);
        }
}
