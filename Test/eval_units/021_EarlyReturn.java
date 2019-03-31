//: 5
//: 5
//: 5
class Main {
        static int earlyWhile() {
                int i = 0;
                while (i < 10) {
                        if (i == 5) {
                                return i;
                        }
                        i++;
                }
                return i;
        }

        static int earlyFor() {
                int i = 0;
                for (i = 0; i < 10; i++) {
                        if (i == 5) {
                                return i;
                        }
                }
                return i;
        }

        static int earlyIf() {
                int i = 5;
                if (true) {
                        return i;
                }
                i = 10;
                return i;
        }

        public static void main(String[] args) {
                Debug.debug(earlyWhile());
                Debug.debug(earlyFor());
                Debug.debug(earlyIf());
        }
}
