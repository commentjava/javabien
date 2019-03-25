class A {
    public static int myMethod(Object A) {
        return 1;
    }

    public static float myMethod(int i) {
        return 1f;
    }


    public static void main(String[] args) {
        float f = myMethod(1);
        int i = myMethod(new A());
        int j = myMethod(2f);
    }

}