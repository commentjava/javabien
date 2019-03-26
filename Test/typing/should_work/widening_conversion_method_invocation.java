class A {

    int myMethod(int i) {
        return 1;
    }

    String myMethod() {
        return "1";
    }

    public static void main() {
        String a = myMethod();
        myMethod('c');
    }
}