//:5
//: null
class MyObject {
}

class YourObject {
}

class HelloWorld {
        static void main(String[] args) {
                MyObject obj;
                MyObject obj2 = new MyObject();
                YourObject obj3 = new YourObject();
                MyObject fourth = obj2;
                int test_int = 5;
                debug(test_int);
                debug(obj);
        }
}
