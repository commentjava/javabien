class MyObject {
    public MyObject() {
    }

    public MyObject(int j) {
    }
}

class YourObject {
    YourObject() {}
}

class HelloWorld {
    static void main(String[] args) {
        MyObject obj;
        MyObject obj2 = new MyObject();
        YourObject obj3 = new YourObject();
        MyObject fourth = obj2;
        int test_int = 5;
    }
}
