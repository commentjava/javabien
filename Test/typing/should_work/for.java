public class MyClass {
    public static void main(String args[]) {
        int x=10;
        int y=25;

        for (int i=0,j=0; i < 2; j++,i++) {
            x += i;
            y += j;
        }

        int i;
        for (i=0; i < 2; i++) {
            x += i;
        }

        for (;i < 2;) {
            x++;
        }

        for (;;) {
            x++;
        }
    }
}