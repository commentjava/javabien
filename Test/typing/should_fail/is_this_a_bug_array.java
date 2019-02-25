package tutu.titi.toto;

class A {
	int notseenasanarray[]; // First bug, this is seen as an int whereas it should be an array

	public void method1() {
		int[] two;
		int[] one;
		two[] = one; // Second bug, this shouldn't be parsed
		one = two[]; // Third bug, this shouldn't be parsed
	}
}
