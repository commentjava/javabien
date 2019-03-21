//: 1
//: 3
//: 5
//: 7
//: 9
class Main {
        static void main() {
                int a = 2;
                int i = 0;
                int j;
                int N = 10;
                while (i < N) {
                        int k = a + i;
                        i = i + 1;
                        j = k % 2;
                        
                        if (j == 0) {
                                Debug.debug(i);
                        }
                }
        }
}
