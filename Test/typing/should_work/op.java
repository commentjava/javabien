package tutu.titi.toto;

class A {
	public void method1() {
		int a = 1;
		a++;
		boolean c = true;
		boolean b = true || false;
		// b = true && true; Doesn't work, see README
		b = (true && true);
	}
}
