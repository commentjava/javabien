/**
 * Simple HTTP server 
 */

class Request {
        private String type;
        private String uri;
        private String protocol;

        public Request(String type, String uri, String protocol) {
                this.type = type;
                this.uri = uri;
                this.protocol = protocol;
        }

        public void log() {
                System.out.print(this.type);
                System.out.print(" ");
                System.out.print(this.uri);
                System.out.print(" ");
                System.out.print(this.protocol);
                System.out.println("");
        }
}

class HServer {
        private int portNumber;
        private FileInputStream is;
        private FileOutputStream os;
        
        private String folder;

        public HServer(int portNumber, String folder) {
                this.portNumber = portNumber;
                this.folder = folder;
        }

        /**
         * This is a helper function because comparing with `\n` does not work
         */
        public static boolean isLR(char c) {
                String s = "\n";
                return s.indexOf(c) >= 0;
        }
        public void start() {
                ServerSocket serverSocket = new ServerSocket(this.portNumber);
                int s = 0;
                while (s == 0) {
                        Socket clientSocket = serverSocket.accept();
                        this.is = clientSocket.getInputStream();
                        this.os = clientSocket.getOutputStream();

                        Request req = handle_request();
                        req.log();
                        handle_response(req);

                        // clientSocket.close();
                }
                serverSocket.close();
        }
        int fileSize(String filename) {
                int l = 1;
                int file_size = 0;
                char[] buffer = new char[1024];
                FileInputStream file = FileInputStream.open(filename);
                if (!file.getFD().valid()) {
                        return 0;
                }
                while (l > 0) {
                        l = file.read(buffer);
                        file_size += l;
                }
                file.close();
                return file_size;
        }
        void printFile(String filename, int buff_size) {
                if (buff_size <= 0) {
                        return;
                }
                int l = 1;
                String s;
                char[] buffer = new char[buff_size];
                char[] sub_buffer;
                FileInputStream file = FileInputStream.open(filename);
                while (l > 0) {
                        l = file.read(buffer);
                        sub_buffer = System.arraycopy(buffer, l);
                        s = new String(sub_buffer);
                        this.os.print(s);
                }
                file.close();
        }
        private void handle_response(Request request) {
                // Print headers
                this.os.println("HTTP/1.0 200 OK");
                // this.os.println("Content-Type: text/html; charset=UTF-8");
                this.os.println("Server: JavabienHTTPServer");
                String filename = String.concat(this.folder, request.uri);
                int fs = this.fileSize(filename);
                String contentLen = String.concat("Content-Length: ", String.fromInteger(fs));
                this.os.println(contentLen);
                if (fs > 2048) {
                        fs = 2018;
                }
                this.os.println("Connection: close");
                this.os.println("");

                // Print content
                this.printFile(filename, fs);
        }

        private Request handle_request() {
                String s;
                char[] buffer = new char[256];
                char[] req_type = new char[5];
                char[] req_uri = new char[200];
                char[] req_pro = new char[20];
                int i = 0;
                int offset = 0;
                this.is.read(buffer);

                // Get request type
                for (i = 0; buffer[i] != ' '; i++) {
                        req_type[i] = buffer[i];
                }
                req_type = System.arraycopy(req_type, i);
                i++; // Skip space
                
                // Get request uri
                offset = i;
                for (; buffer[i] != ' '; i++) {
                        req_uri[i - offset] = buffer[i];
                }
                req_uri = System.arraycopy(req_uri, i-offset);
                i++; // Skip space

                // Get request protocol
                offset = i;
                for (; buffer[i] != ' ' && !HServer.isLR(buffer[i]); i++) {
                        req_pro[i - offset] = buffer[i];
                }
                req_pro = System.arraycopy(req_pro, i-offset);

                Request req = new Request(
                        new String(req_type),
                        new String(req_uri),
                        new String(req_pro)
                );

                // Skip two spaces
                for (; !HServer.isLR(buffer[i]) && !HServer.isLR(buffer[i+1]); i++) {}

                return req;
        }
}

class HttpServer {
        public static void main(String[] args) {
                System.initializeSystemClass();  // Mandatory call
                if (args.length < 2) {
                        System.out.println("Usage: HttpServer <listen_port> <served_folder>");
                        return;
                }
                int portNumber = Integer.parseInt(args[0]);
                String folder = args[1];
                HServer server = new HServer(portNumber, folder);
                server.start();
        }
}
