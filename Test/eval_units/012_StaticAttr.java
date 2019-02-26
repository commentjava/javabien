//: 7
//: 5
//: 2
//: 5
//: 5

class MyClass {
        int ns;
        static int st = 12;
}

class HelloWorld {

        void main () {
                MyClass a = new MyClass();
                MyClass b = new MyClass();
                a.ns = 7;
                b.ns = 2;
                b.st = 5;
                Debug.debug(a.ns);
                Debug.debug(a.st);
                Debug.debug(b.ns);
                Debug.debug(b.st);
                Debug.debug(MyClass.st);
        }
}
