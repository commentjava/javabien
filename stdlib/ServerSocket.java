class ServerSocket {
        int port;
        private FileDescriptor fd;

        public ServerSocket(int port) {
                this.port = port;
                this.fd = this.init();
        }

        private native FileDescriptor init();
        public native Socket accept();
        public native void close();
}

