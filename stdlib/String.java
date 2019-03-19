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

    /**
     * Initializes a newly created <code>String</code> object so that it
     * represents an empty character sequence.  Note that use of this 
     * constructor is unnecessary since Strings are immutable. 
     */
    public String() {
        value = new char[0];
    }

    /**
     * Initializes a newly created <code>String</code> object so that it
     * represents the same sequence of characters as the argument; in other
     * words, the newly created string is a copy of the argument string. Unless 
     * an explicit copy of <code>original</code> is needed, use of this 
     * constructor is unnecessary since Strings are immutable. 
     *
     * @param   original   a <code>String</code>.
     */
    public String(String original) {
        this.count = original.count;
        if (original.value.length > this.count) {
            // The array representing the String is bigger than the new
            // String itself.  Perhaps this constructor is being called
            // in order to trim the baggage, so make a copy of the array.
            this.value = new char[this.count];
            System.arraycopy(original.value, original.offset,
        		     this.value, 0, this.count);
        } else {
            // The array representing the String is the same
            // size as the String, so no point in making a copy.
            this.value = original.value;
        }
    }
}
