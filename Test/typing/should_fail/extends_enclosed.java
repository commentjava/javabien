class A {

    class C {
        int attr1 = 0;

        public int myMethod(int i) {
            attr = i;
            return attr;
        }
    }
}

class B extends A.C {

    public int myOtherMethod(int i) {
        int j = attr + i;
        this.attr++;
        myMethod(1);
        return this.myMethod(i);
    }
}