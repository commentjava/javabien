//: false
//: -94
//: -2

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


class Container{
  int ival;
  boolean bval;

  public Container(int i_, boolean b_){
    this.ival = i_;
    this.bval = b_;
  }

}

class Main{
  static void main(){
    // ### Values ###
    // Incr
    //Debug.debug(i++);
    // Decr
    //Debug.debug(i--);
    
    // Op_not
    Debug.debug(!true);
    // Op_neg
    Debug.debug(-94);
    // Op_incr
    //Debug.debug(++i);
    // Op_decr
    //Debug.debug(--i);
    // Op_bnot
    Debug.debug(~1);

    // Assign
    //Debug.debug(i = 94);
    // Ass_add
    //Debug.debug(i += 3);
    // Ass_sub
    //Debug.debug(i -= 3);
    // Ass_mul
    //Debug.debug(i *= 3);
    // Ass_div
    //Debug.debug(i /= 3);
    // Ass_mod
    //Debug.debug(i %= 3);
    // Ass_shl
    //Debug.debug(i <<= 3);
    // Ass_shr
    //Debug.debug(i >>= 3);
    // Ass_shrr
    //Not implemented
    // Ass_and
    //Debug.debug(i &= 3);
    // Ass_xor
    //Debug.debug(i ^= 94);
    // Ass_or
    //Debug.debug(i |= 3);
    
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


    // Simple variables

    int i = 94, j = 3, k = 1, m = 94;
    boolean b = true, c = false;

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
    Debug.debug(~k);

    // Assign
    Debug.debug(i = m);
    // Ass_add
    Debug.debug(i += j);
    // Ass_sub
    Debug.debug(i -= j);
    // Ass_mul
    Debug.debug(i *= j);
    // Ass_div
    Debug.debug(i /= j);
    // Ass_mod
    Debug.debug(i %= j);
    // Ass_shl
    Debug.debug(i <<= j);
    // Ass_shr
    Debug.debug(i >>= j);
    // Ass_shrr
    //Not implemented
    // Ass_and
    i = m;
    Debug.debug(i &= j);
    // Ass_xor
    Debug.debug(i ^= m);
    // Ass_or
    Debug.debug(i |= j);

    // Op_cor
    Debug.debug(b || c);
    // Op_cand
    Debug.debug(b && c);
    // Op_or
    Debug.debug(m | j);
    // Op_and
    Debug.debug(m & j);
    // Op_xor
    Debug.debug(m ^ j);
    // Op_eq
    Debug.debug(m == j);
    Debug.debug(b == c);
    // Op_ne
    Debug.debug(m != j);
    Debug.debug(b != c);
    // Op_gt
    Debug.debug(m > j);
    // Op_lt
    Debug.debug(m < j);
    // Op_ge
    Debug.debug(m >= j);
    // Op_le
    Debug.debug(m <= j);
    // Op_shl
    Debug.debug(m << j);
    // Op_shr
    Debug.debug(m >> j);
    // Op_shrr
    //Debug.debug(m >>> j); Not implemented
    // Op_add
    Debug.debug(m + j);
    // Op_sub
    Debug.debug(m - j);
    // Op_mul
    Debug.debug(m * j);
    // Op_div
    Debug.debug(m / j);
    // Op_mod
    Debug.debug(m % j);

    // ### Attr ###

    Container ca = new Container(94, true), cb = new Container(3, false), cc = new Container(1, false), cd = new Container(94, true);
    // Incr
    Debug.debug(ca.ival);
    Debug.debug(ca.ival++);
    Debug.debug(ca.ival);

    // Decr
    Debug.debug(ca.ival);
    Debug.debug(ca.ival--);
    Debug.debug(ca.ival);

    // Op_not
    Debug.debug(!ca.bval);
    // Op_neg
    Debug.debug(-ca.ival);
    // Op_incr
    Debug.debug(++ca.ival);
    // Op_decr
    Debug.debug(--ca.ival);
    // Op_bnot
    Debug.debug(~cc.ival);

    // Assign
    Debug.debug(ca.ival = cd.ival);
    // Ass_add
    Debug.debug(ca.ival += cb.ival);
    // Ass_sub
    Debug.debug(ca.ival -= cb.ival);
    // Ass_mul
    Debug.debug(ca.ival *= cb.ival);
    // Ass_div
    Debug.debug(ca.ival /= cb.ival);
    // Ass_mod
    Debug.debug(ca.ival %= cb.ival);
    // Ass_shl
    Debug.debug(ca.ival <<= cb.ival);
    // Ass_shr
    Debug.debug(ca.ival >>= cb.ival);
    // Ass_shrr
    //Not implemented
    // Ass_and
    ca.ival = cd.ival;
    Debug.debug(ca.ival &= cb.ival);
    // Ass_xor
    Debug.debug(ca.ival ^= cd.ival);
    // Ass_or
    Debug.debug(ca.ival |= cb.ival);

    // Op_cor
    Debug.debug(ca.bval || cb.bval);
    // Op_cand
    Debug.debug(ca.bval && cb.bval);
    // Op_or
    Debug.debug(cd.ival | cb.ival);
    // Op_and
    Debug.debug(cd.ival & cb.ival);
    // Op_xor
    Debug.debug(cd.ival ^ cb.ival);
    // Op_eq
    Debug.debug(cd.ival == cb.ival);
    Debug.debug(ca.bval == cb.bval);
    // Op_ne
    Debug.debug(cd.ival != cb.ival);
    Debug.debug(ca.bval != cb.bval);
    // Op_gt
    Debug.debug(cd.ival > cb.ival);
    // Op_lt
    Debug.debug(cd.ival < cb.ival);
    // Op_ge
    Debug.debug(cd.ival >= cb.ival);
    // Op_le
    Debug.debug(cd.ival <= cb.ival);
    // Op_shl
    Debug.debug(cd.ival << cb.ival);
    // Op_shr
    Debug.debug(cd.ival >> cb.ival);
    // Op_shrr
    //Debug.debug(cd.ival >>> cb.ival); Not implemented
    // Op_add
    Debug.debug(cd.ival + cb.ival);
    // Op_sub
    Debug.debug(cd.ival - cb.ival);
    // Op_mul
    Debug.debug(cd.ival * cb.ival);
    // Op_div
    Debug.debug(cd.ival / cb.ival);
    // Op_mod
    Debug.debug(cd.ival % cb.ival);

  }
}
