//: 5

class TestClass {
        int sum(int a, int b) {
                return a + b;
        }
}

class HelloWorld {
        static void main() {
                int alpha = 2;
                int beta = 3;
                TestClass t = new TestClass();
                alpha = t.sum(alpha, beta);
                Debug.debug(alpha);
        }
}
