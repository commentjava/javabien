/*
 * @(#)FileDescriptor.java	1.20 03/01/23
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 * Modified for the javabien project
 */

package java.io;

public final class FileDescriptor {

    private int fd = -1;

    public FileDescriptor(int fd) {
	this.fd = fd;
    }

    /**
     * Tests if this file descriptor object is valid.
     *
     * @return  <code>true</code> if the file descriptor object represents a
     *          valid, open file, socket, or other active I/O connection;
     *          <code>false</code> otherwise.
     */
    public boolean valid() {
	    return this.fd != -1;
    }

}

