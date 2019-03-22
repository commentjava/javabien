
//: 94
//: 94
//: 95
//: 95
//: 95
//: 94

//: false
//: -94
//: 95
//: 94
//: -2

//: 94
//: 97
//: 94
//: 282
//: 94
//: 1
//: 8
//: 1
//: 2
//: 92
//: 95

//: true
//: false
//: 95
//: 2
//: 93
//: false
//: false
//: true
//: true
//: true
//: false
//: true
//: false
//: 752
//: 11
// : 11
//: 97
//: 91
//: 282
//: 31
//: 1
class Main{
  static void main(){
    int i = 94;
    boolean b = true;
    // Incr
    Debug.debug(i);
    Debug.debug(i++);
    Debug.debug(i);

    // Decr
    Debug.debug(i);
    Debug.debug(i--);
    Debug.debug(i);
    
    // Op_not
    Debug.debug(!b);
    // Op_neg
    Debug.debug(-i);
    // Op_incr
    Debug.debug(++i);
    // Op_decr
    Debug.debug(--i);
    // Op_bnot
    Debug.debug(~1);

    // Assign
    Debug.debug(i = 94);
    // Ass_add
    Debug.debug(i += 3);
    // Ass_sub
    Debug.debug(i -= 3);
    // Ass_mul
    Debug.debug(i *= 3);
    // Ass_div
    Debug.debug(i /= 3);
    // Ass_mod
    Debug.debug(i %= 3);
    // Ass_shl
    Debug.debug(i <<= 3);
    // Ass_shr
    Debug.debug(i >>= 3);
    // Ass_shrr
    //Not implemented
    // Ass_and
    i = 94;
    Debug.debug(i &= 3);
    // Ass_xor
    Debug.debug(i ^= 94);
    // Ass_or
    Debug.debug(i |= 3);
    
    // Op_cor
    Debug.debug(true || false);
    // Op_cand
    Debug.debug(true && false);
    // Op_or
    Debug.debug(94 | 3);
    // Op_and
    Debug.debug(94 & 3);
    // Op_xor
    Debug.debug(94 ^ 3);
    // Op_eq
    Debug.debug(94 == 3);
    Debug.debug(true == false);
    // Op_ne
    Debug.debug(94 != 3);
    Debug.debug(true != false);
    // Op_gt
    Debug.debug(94 > 3);
    // Op_lt
    Debug.debug(94 < 3);
    // Op_ge
    Debug.debug(94 >= 3);
    // Op_le
    Debug.debug(94 <= 3);
    // Op_shl
    Debug.debug(94 << 3);
    // Op_shr
    Debug.debug(94 >> 3);
    // Op_shrr
    //Debug.debug(94 >>> 3); Not implemented
    // Op_add
    Debug.debug(94 + 3);
    // Op_sub
    Debug.debug(94 - 3);
    // Op_mul
    Debug.debug(94 * 3);
    // Op_div
    Debug.debug(94 / 3);
    // Op_mod
    Debug.debug(94 % 3);
  }
}
