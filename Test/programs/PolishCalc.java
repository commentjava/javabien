/**
 * A simple reversed polish calculator
 */

class Stack {
        int[] s;
        int c;

        Stack(int max_s) {
                this.s = new int[max_s];
                this.c = 0;
        }
        
        void push(int v) {
                this.s[this.c] = v;
                this.c++;
        }
        int pop() {
                this.c--;
                return this.s[this.c];
        }
}
class PolishCalc {
        static public void main (String[] args) {
                System.initializeSystemClass();  // Mandatory because not implemented by evaluator
                if (args.length < 1) {
                        System.out.println("Usage: PolishCalc [num1] [num2] [num3]...");
                        return;
                } 
                
                Stack s = new Stack(args.length);
                for (int i = 0; i < args.length; i++) {
                        if (args[i].indexOf('+') >= 0) {
                                int a = s.pop();
                                int b = s.pop();
                                s.push(a + b);
                        } else if (args[i].indexOf('-') >= 0) {
                                int a = s.pop();
                                int b = s.pop();
                                s.push(a - b);
                        } else if (args[i].indexOf('*') >= 0) {
                                int a = s.pop();
                                int b = s.pop();
                                s.push(a * b);
                        } else {
                                s.push(Integer.parseInt(args[i]));
                        }
                }
                Debug.debug(s.pop());
        }
}
