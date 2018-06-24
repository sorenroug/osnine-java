package org.roug.osnine;

import java.io.OutputStream;
import java.io.IOException;

/**
 * Convert GO51 escape sequences to VT100. This terminal is monochrome.
 */
enum GO51Terminal {

    NORMAL {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                throws IOException {
            switch (val) {
                case 0x1B:
                    return ESCAPE;
                default:
                    clientOut.write(val);
                    clientOut.flush();
                    return NORMAL;
            }
        }
    },

    ESCAPE {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                throws IOException {
            switch (val) {
                case 0x42:   // Clear to end of line.
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('K');
                    clientOut.flush();
                    return NORMAL;
                case 0x46:  // Reverse on
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('7');
                    clientOut.write('m');
                    clientOut.flush();
                    return NORMAL;
                case 0x47:  // Reverse off
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('0');  // Turns all attributes off. Turn underline back on
                    clientOut.write('m');
                    clientOut.flush();
                    return NORMAL;
                case 0x48:  // Underline on
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('4');
                    clientOut.write('m');
                    clientOut.flush();
                    return NORMAL;
                default:
                    clientOut.write(val);
                    clientOut.flush();
                    return NORMAL;
            }
        }
    },

    X_VAL {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                throws IOException {
            column = val + 1; // VT100 starts at 1.
            return Y_VAL;
        }
    },

    Y_VAL {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                throws IOException {
            val++; // VT100 starts at 1.
            if (val > 100) {
                clientOut.write('0' + val / 100);
                val = val / 100;
            }
            if (val > 10) {
                clientOut.write('0' + val / 10);
                val = val / 10;
            }
            clientOut.write('0' + val);
            clientOut.write(';' + val);

            if (column > 100) {
                clientOut.write('0' + column / 100);
                column = column / 100;
            }
            if (column > 10) {
                clientOut.write('0' + column / 10);
                column = column / 10;
            }
            clientOut.write('0' + column);
            clientOut.write('H' + val);
            return NORMAL;
        }
    };

    private static int column;
    private static final int ESC = 0x1B;

    abstract GO51Terminal handleCharacter(int val, OutputStream clientOut)
            throws IOException;
}
