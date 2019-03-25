//: 1
//: 2
//: 1
//: 9
//: 0
//: 2
//: 0
//: 5

class X {
        int x;
}
class Main {
        static void main(String[] args) {
                int[] a = {1, 2, 3};
                int b = a[0];
                Debug.debug(b);
                Debug.debug(a[1]);
                
                int[][] matrix = {
                        {1, 2, 3},
                        {4, 5, 6},
                        {7, 8, 9}
                };
                Debug.debug(matrix[0][0]);
                Debug.debug(matrix[2][2]);

                a[0] = 0;
                Debug.debug(a[0]);
                Debug.debug(a[1]);

                int[] myArray = new int[5];
                Debug.debug(myArray[0]);
                Debug.debug(myArray.length);
        }
}
