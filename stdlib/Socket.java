class Socket {
        private FileDescriptor fd;

        public FileInputStream getInputStream() {
                return new FileInputStream(this.fd);
        }

        public native void close();
}

