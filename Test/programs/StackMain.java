class Node {
        private Node next;
        private int value;

        int getValue() {
                return this.value;
        }
        void setValue(int v) {
                this.value = v;
        }
        Node getNext() {
                return this.next;
        }
        void setNext(Node n) {
                this.next = n;
        }
}

class Stack {
        Node start;
        void printStack() {
                Node n = this.start;
                while(n != null) {
                        int v = n.getValue();
                        Debug.debug(v);
                        n = n.getNext();
                }
        }
        void push(int v) {
                Node new_node = new Node();
                new_node.setValue(v);
                new_node.setNext(this.start);
                this.start = new_node;
        }
        int peak() {
                return this.start.getValue();
        }
        int pop() {
                int v = this.start.getValue();
                this.start = this.start.getNext();
                return v;

        }

}

class StackMain {
        static void main() {
                Stack s = new Stack();
                int i = 0;
                while (i < 20) {
                        s.push(i);
                        i = i + 1;
                }
                s.printStack();
                while (i > 5) {
                        s.pop();
                        i = i - 1;
                }
                s.printStack();
                int v = s.peak();
                Debug.debug(v);
        }
}
