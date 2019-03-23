
/*
 * @(#)System.java	1.131 03/01/29
 *
 * Copyright 2003 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 * Modified for the javabien project
 */

package java.lang;
import java.io.*;

public final class System {
        public static FileInputStream in;
        public static FileOutputStream out;
        public static FileOutputStream err;

        private static native void setIn0(InputStream in);
        private static native void setOut0(PrintStream out);
        private static native void setErr0(PrintStream err);

        private static void initializeSystemClass() {
                this.in = new FileInputStream(new FileDescriptor(0));
                this.out = new FileOutputStream(new FileDescriptor(1));
                this.err = new FileOutputStream(new FileDescriptor(2));

                // setIn0(new BufferedInputStream(fdIn));
                // setOut0(new PrintStream(new BufferedOutputStream(fdOut, 128), true));
                // setErr0(new PrintStream(new BufferedOutputStream(fdErr, 128), true));
        }
}
