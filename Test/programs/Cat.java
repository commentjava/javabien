class Cat {
        static char[] copy_buff(char[] b, int l) {
                int to_cpy;
                if (b.length < l) {
                        to_cpy = b.length;
                } else {
                        to_cpy = l;
                }
                char[] n = new char[to_cpy];
                for (int i = 0; i < to_cpy; i++) {
                        n[i] = b[i];
                }
                return n;

        }
        static void printFile(String filename) {
                int l = 1;
                String s;
                char[] buffer = new char[1024];
                char[] sub_buffer;
                FileInputStream file = FileInputStream.open(filename);
                while (l > 0) {
                        l = file.read(buffer);
                        sub_buffer = Cat.copy_buff(buffer, l);
                        s = new String(sub_buffer);
                        System.out.print(s);
                }
                file.close();
        }
        static void main(String[] args) {
                System.initializeSystemClass();  // Not handled by the evaluator
                if (args.length <= 0) {
                        System.out.println("Usage: Cat [file1] [file2]...");
                }
                for (int i = 0; i < args.length; i++) {
                        Cat.printFile(args[i]);
                }
        }
}
