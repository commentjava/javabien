//: 5

class TestClass {
        int returns3() {
                int x = 3;
                return x + 2;
        }
}

class Main {
        static void main(String[] args) {
                int a = 2;
                TestClass t = new TestClass();
                a = t.returns3();
                Debug.debug(a);

        }
}
