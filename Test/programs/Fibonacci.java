class HelloWorld {
        static void main() {
                int N = 50;
                int a = 1;
                int b = 1;
                int i = 0;
                int tmp = 0;

                while (i < N) {
                        tmp = a;
                        a = a + b;
                        b = tmp;
                        i = 1 + i;
                        debug(a);
                }
        }
}
