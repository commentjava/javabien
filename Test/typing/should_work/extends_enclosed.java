class A {

    class C {
        int attr = 0;

        public int myMethod(int i) {
            attr = i;
            return attr;
        }
    }
}

class B extends A.C {

    public int myOtherMethod(int i) {
        myMethod(1);
        return this.myMethod(i);
    }
}