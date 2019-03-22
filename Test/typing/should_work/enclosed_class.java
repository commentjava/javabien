package tutu.titi.toto;

class A {

    A(int i){}

    private void myMethod(){
        int a = 1;
    }

	class B {

        B(float j){}

        private void myMethodB(){
            int a = 2;
        }

        class C {

            C(float j){}

            private void myMethodB(){
                int a = 2;
            }
        }
    }

    class C {

        C(float j){}

        private void myMethodB(){
            int a = 2;
        }
    }
}