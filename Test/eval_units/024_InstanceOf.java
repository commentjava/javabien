//: true
//: false

class A {}
class B {}

class Main {
        static void main(String[] args) {
                A a = new A();
                Debug.debug(a instanceof A);
                Debug.debug(a instanceof B);
        }
}
