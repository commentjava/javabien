class Socket {
        private FileDescriptor fd;
        private FileInputStream is;
        private FileOutputStream os;

        public FileInputStream getInputStream() {
                if (this.is == null) {
                        this.is = new FileInputStream(this.fd);
                } 
                return this.is;
        }

        public FileOutputStream getOutputStream() {
                if (this.os == null) {
                        this.os = new FileOutputStream(this.fd);
                } 
                return this.os;
        }

        public native void close();
}

