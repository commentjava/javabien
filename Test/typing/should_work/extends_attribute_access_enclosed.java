class A {

    class B {
        int attr = 0;

        public int myMethod(int i) {
            attr = i;
            return attr;
        }
    }
}

class C extends A.B {

    public int myOtherMethod(int i) {
        int j = attr;
        // int h = this.attr;
        return attr;
    }
}