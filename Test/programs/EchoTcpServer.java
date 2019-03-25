/**
 * Simple tcp server that print everything that goes through a tcp socket
 */
class EchoTcpServer {
        public static void main(String[] args) {
                System.initializeSystemClass();  // Mandatory call
                if (args.length < 1) {
                        System.out.println("Usage: EchoTcpServer <listen_port>");
                        return;
                }
                int portNumber = Integer.parseInt(args[0]);
                ServerSocket serverSocket = new ServerSocket(portNumber);
                Socket clientSocket = serverSocket.accept();
                FileInputStream is = clientSocket.getInputStream();

                int l = 1;
                String s;
                char[] buffer = new char[16];
                char[] sub_buffer;
                while (l > 0) {
                        l = is.read(buffer);
                        sub_buffer = System.arraycopy(buffer, l);
                        s = new String(sub_buffer);
                        System.out.print(s);
                }
                clientSocket.close();
                serverSocket.close();
        }
}
