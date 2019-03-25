//: true
//: 4

class Main {
        static void main(String[] args) {
                boolean a = true;
                Debug.debug(a);
                if (a) {
                        int b = 4;
                        Debug.debug(b);
                } else {
                        int c = 5;
                        Debug.debug(b);
                }
        }
}
