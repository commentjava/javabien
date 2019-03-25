/*
 * @(#)FileInputStream.java	1.60 03/01/23
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 * Modified for javabien
 */

package java.io;

import java.nio.channels.FileChannel;

public
class FileInputStream extends InputStream
{
    /* File Descriptor - handle to the open file */
    private FileDescriptor fd;

    // private FileChannel channel = null;

    public FileInputStream(FileDescriptor fdObj) {
	this.fd = fdObj;
    }

    /**
     * Reads a subarray as a sequence of bytes.
     * @param b the data to be written
     * @param off the start offset in the data
     * @param len the number of bytes that are written
     * @exception IOException If an I/O error has occurred.
     */
    private native int readBytes(byte b[], int off, int len) throws IOException;

    /**
     * Reads up to <code>b.length</code> bytes of data from this input
     * stream into an array of bytes. This method blocks until some input
     * is available.
     *
     * @param      b   the buffer into which the data is read.
     * @return     the total number of bytes read into the buffer, or
     *             <code>-1</code> if there is no more data because the end of
     *             the file has been reached.
     * @exception  IOException  if an I/O error occurs.
     */
    public int read(byte b[]) throws IOException {
	return readBytes(b, 0, b.length);
    }

    /**
     * Returns the <code>FileDescriptor</code>
     * object  that represents the connection to
     * the actual file in the file system being
     * used by this <code>FileInputStream</code>.
     *
     * @return     the file descriptor object associated with this stream.
     * @exception  IOException  if an I/O error occurs.
     * @see        java.io.FileDescriptor
     */
    public final FileDescriptor getFD() throws IOException {
	if (fd != null) return fd;
	throw new IOException();
    }

    public FileDescriptor open(String filename) {
            int[] flags = {File.O_RDONLY};
            FileDescritor fd = File.open(filename, flags, 640);
            return new FileInputStream(fd);
    }

    public native void close();
}
