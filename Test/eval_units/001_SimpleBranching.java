//: true
//: 4

class Main {
        static void main(String[] args) {
                boolean a = true;
                Debug.debug(a);
                int b = 4;
                if (a) {
                        Debug.debug(b);
                } else {
                        int c = 5;
                        Debug.debug(b);
                }
        }
}
