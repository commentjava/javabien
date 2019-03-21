//: 6
//: 9

class TestClass {
        int returns9() {
                // implicit call to this
                return returns6() + returns3();
        }
        int returns6() {
                // explicit call to this
                return this.returns3() + this.returns3();
        }
        int returns3() {
                return 3;
        }
}

class Main {
        static void main() {
                int a = 2;
                TestClass t = new TestClass();
                a = t.returns6();
                Debug.debug(a);
                a = t.returns9();
                Debug.debug(a);

        }
}
