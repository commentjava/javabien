package tutu.titi.toto;

class A {
	int j = 2;
	float j1 = 2.0;
	int j2 = 2;

	public int method1() {
		j2 = 3;
		return j;
	}

	public int method1(int b) {
		j = b;
		return j;
	}

	public int method1(float b) {
		j1 = b;
		return j;
	}
}
