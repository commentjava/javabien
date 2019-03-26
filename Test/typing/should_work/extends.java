class A {
    int attr = 0;

    public int myMethod(int i) {
        attr = i;
        return attr;
    }
}

class B extends A {

    public int myOtherMethod(int i) {
        return this.myMethod(i);
    }
}