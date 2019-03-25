class Echo {
        void main(String[] args) {
                System.initializeSystemClass();
                if (args.length != 1) {
                        System.out.println("Usage: Echo '<string to print>'");
                } else {
                        System.out.println(args[0]);
                }

        }
}
