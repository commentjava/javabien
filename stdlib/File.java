class File {
        public static int O_RDONLY = 0;
        public static int O_WRONLY = 1;
        public static int O_RDWR = 1;
        native public static FileDescriptor open(String filename, int[] flags, int perm);
}
