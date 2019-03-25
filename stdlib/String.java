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
}
