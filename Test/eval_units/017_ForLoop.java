//: 0
//: 1
//: 2

//: 2
//: 4

//: 0
//: 1
//: 2
//: 3
//: 4

class Main {
  static void main(String[] args) {
    for(int i = 0 ; i < 3 ; i = i + 1){
      Debug.debug(i);
    }
    int j;
    for(j = 2 ; j < 5 ; j = j + 2){
      Debug.debug(j);
    }
    for(int k = 0 ; k < 5 ; k ++){
      Debug.debug(k);
    }
  }
}
