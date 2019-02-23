package tutu.titi.toto;


class B {
	public int j;

	public B() {
	}

	public B(int h) {
	}
}

class A {
	public void method1() {
		B b = new B(1, 2);
		int j = b.j;
	}
}
