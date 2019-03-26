class A {

    int myMethod(int i) {
        return 1;
    }

    void myMethod(char c) {
        return 1;
    }

    public static void main() {
        int i = myMethod('c');
    }
}