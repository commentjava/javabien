class Fibonacci {
        static void main(String[] args) {
                int N = 22;
                int a = 1;
                int b = 1;
                int i = 0;
                int tmp = 0;

                while (i < N  - 1) {
                        tmp = a;
                        a = a + b;
                        b = tmp;
                        i = 1 + i;
                }
                Debug.debug(a);
        }
}
