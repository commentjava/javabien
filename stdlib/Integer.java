class Integer {
        /**
         * Very slow toy implementation of parseInt
         */
        public static int parseInt(String str) {
                int v = 0;
                char[] arr = str.toCharArray();
                String numbers = "0123456789";
                for (int i = 0; i < arr.length; i++) {
                        int k = numbers.indexOf(arr[i]);
                        if (k == -1) {
                                throw Exception();

                        }
                        v += k * Math.pow(10, arr.length - i - 1);
                }
                return v;
        }
}
