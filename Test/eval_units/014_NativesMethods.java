class Debug2 {
        native static void dumpMemory2(Object a);
}

class HelloWorld {
        static void main() {
                int a = 2;
                Debug2.dumpMemory2(a);
        }
}
