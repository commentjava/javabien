//: 10

class Constructed {
        int a;
        Constructed(int a) {
                this.a = a;
        }
}
class Main {
        static void main(String[] args) {
                Constructed c = new Constructed(10);
                Debug.debug(c.a);
        }
}
