package java.lang;

class String {
    /** The value is used for character storage. */
    private char value[];

    /** The offset is the first index of the storage that is used. */
    private int offset;

    /** The count is the number of characters in the String. */
    private int count;

    /** Cache the hash code for the string */
    private int hash = 0;

    /** use serialVersionUID from JDK 1.0.2 for interoperability */
    // private static final long serialVersionUID = -6849794470754667710L;

    public String(char[] c) {
        this.value = c;
        this.count = c.length;
    }
    public char[] toCharArray() {
            return this.value;
    }

    /**
     * Returns the index within this string of the first occurrence of the
     * specified character. If a character with value <code>ch</code> occurs
     * in the character sequence represented by this <code>String</code>
     * object, then the index of the first such occurrence is returned --
     * that is, the smallest value <i>k</i> such that:
     * <blockquote><pre>
     * this.charAt(<i>k</i>) == ch
     * </pre></blockquote>
     * is <code>true</code>. If no such character occurs in this string,
     * then <code>-1</code> is returned.
     *
     * @param   ch   a character.
     * @return  the index of the first occurrence of the character in the
     *          character sequence represented by this object, or
     *          <code>-1</code> if the character does not occur.
     */
    public int indexOf(int ch) {
	int i = indexOf2(ch, 0);
        return i;
    }

    /**
     * Returns the index within this string of the first occurrence of the
     * specified character, starting the search at the specified index.
     * <p>
     * If a character with value <code>ch</code> occurs in the character
     * sequence represented by this <code>String</code> object at an index
     * no smaller than <code>fromIndex</code>, then the index of the first
     * such occurrence is returned--that is, the smallest value <i>k</i>
     * such that:
     * <blockquote><pre>
     * (this.charAt(<i>k</i>) == ch) && (<i>k</i> &gt;= fromIndex)
     * </pre></blockquote>
     * is true. If no such character occurs in this string at or after
     * position <code>fromIndex</code>, then <code>-1</code> is returned.
     * <p>
     * There is no restriction on the value of <code>fromIndex</code>. If it
     * is negative, it has the same effect as if it were zero: this entire
     * string may be searched. If it is greater than the length of this
     * string, it has the same effect as if it were equal to the length of
     * this string: <code>-1</code> is returned.
     *
     * @param   ch          a character.
     * @param   fromIndex   the index to start the search from.
     * @return  the index of the first occurrence of the character in the
     *          character sequence represented by this object that is greater
     *          than or equal to <code>fromIndex</code>, or <code>-1</code>
     *          if the character does not occur.
     */
    public int indexOf2(int ch, int fromIndex) {
	int max = this.count;
	char v[] = this.value;

	if (fromIndex < 0) {
	    fromIndex = 0;
	} else if (fromIndex >= this.count) {
	    // Note: fromIndex might be near -1>>>1.
	    return -1;
	}
	for (int i = fromIndex ; i < max ; i++) {
	    if (v[i] == ch) {
		return i;
	    }
	}
	return -1;
    }

    public static String concat(String s1, String s2)  {
            int new_len = s1.count + s2.count;
            char[] n = new char[new_len];
            int i = 0;
            for (i=0; i < s1.count; i++) {
                    n[i] = s1.value[i];
            }

            for (i=0; i < s2.count; i++) {
                    n[i+s1.count] = s2.value[i];
            }
            return new String(n);
    }

    public native static String fromInteger(int n);
}
