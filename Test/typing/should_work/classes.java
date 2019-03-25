package tutu.titi.toto;


class B {
	public int j;

	public B() {
		j = 1;
	}

	public B(int h) {
		j = h;
	}
}

class A {
	public void method1() {
		B b = new B(1);
		B b2 = new B();
		int j = b.j;
	}
}
