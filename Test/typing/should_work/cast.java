package tutu.titi.toto;

class B {
	int j;
	B(int i, int j) {
		j = 1;
	}
}

class A {

	public void method1() {
		B b = new B(1, 2);
		int j = b.j;
	}
}
