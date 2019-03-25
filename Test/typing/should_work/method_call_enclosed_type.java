class A {

    static class B {
        static class C {
            static int myMethod(int i) {
                return i++;
            }
        }
    }
    public static void main(String[] args) {
        int result = B.C.myMethod(10);
    }
}
