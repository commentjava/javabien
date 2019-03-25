class Echo {
        void main(String[] args) {
                System.initializeSystemClass();
                if (args.length < 1) {
                        System.out.println("Usage: Echo '<string to print>'");
                } else {

                        for (int i = 0; i < args.length; i++) {
                                System.out.print(args[i]);
                                if (i < args.length - 1) {
                                        System.out.print(" ");
                                }
                        }
                        System.out.println("");
                }
        }
}
