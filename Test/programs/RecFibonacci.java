class Fib {
        int fib (int N) {
                if (N <= 1) {
                        return 1;
                }
                // Debug.dumpMemory();
                int f1 = fib(N-1);
                int f2 = fib(N-2);
                return f1 + f2;
        }
}

class RecFibonacci {
        static void main() {
                int N = 22;;
                Fib f = new Fib();
                int res = f.fib(N); 
                // Debug.dumpMemory();
                Debug.debug(res);
        }
}
