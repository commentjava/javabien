/*
 * @(#)FileOutputStream.java	1.56 03/01/23
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 * 
 * Modified for javabien
 */

package java.io;

import java.nio.channels.FileChannel;
import sun.nio.ch.FileChannelImpl;

public
class FileOutputStream extends OutputStream
{
        /**
         * The system dependent file descriptor. The value is
         * 1 more than actual file descriptor. This means that
         * the default value 0 indicates that the file is not open.
         */
        private FileDescriptor fd;

        private FileChannel channel= null;

        private boolean append = false;

        /**
         * Creates an output file stream to write to the specified file 
         * descriptor, which represents an existing connection to an actual 
         * file in the file system.
         * <p>
         * First, if there is a security manager, its <code>checkWrite</code> 
         * method is called with the file descriptor <code>fdObj</code> 
         * argument as its argument.
         *
         * @param      fdObj   the file descriptor to be opened for writing
         * @exception  SecurityException  if a security manager exists and its
         *               <code>checkWrite</code> method denies
         *               write access to the file descriptor
         * @see        java.lang.SecurityManager#checkWrite(java.io.FileDescriptor)
         */
        public FileOutputStream(FileDescriptor fdObj) {
                this.fd = fdObj;
        }

        /**
         * Writes a sub array as a sequence of bytes.
         * @param b the data to be written
         * @param off the start offset in the data
         * @param len the number of bytes that are written
         * @exception IOException If an I/O error has occurred.
         */
        private native void writeBytes(byte b[], int off, int len) throws IOException;

        /**
         * Writes <code>len</code> bytes from the specified byte array 
         * starting at offset <code>off</code> to this file output stream. 
         *
         * @param      b     the data.
         * @param      off   the start offset in the data.
         * @param      len   the number of bytes to write.
         * @exception  IOException  if an I/O error occurs.
         */
        public void write(byte b[], int off, int len) throws IOException {
                this.writeBytes(b, off, len);
        }

        /**
         * Returns the file descriptor associated with this stream.
         *
         * @return  the <code>FileDescriptor</code> object that represents 
         *          the connection to the file in the file system being used 
         *          by this <code>FileOutputStream</code> object. 
         * 
         * @exception  IOException  if an I/O error occurs.
         * @see        java.io.FileDescriptor
         */
        public final FileDescriptor getFD()  throws IOException {
                if (fd != null) return fd;
                throw new IOException();
        }

        public void print(String str) {
                this.write(str.value, 0, str.count);
        }
        public void println(String str) {
                this.print(str);
                this.print("\n");
        }

        public native void close();
}

