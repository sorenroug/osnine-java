package org.roug.osnine;

import java.io.InputStream;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * State engine to handle telnet protocol. It also catches VT100 cursor keys
 * and translate them into the equivalent expected by OS-9.
 */
enum TelnetState {

    NORMAL {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case NULL_CHAR:
                case NEWLINE_CHAR:
                    return NORMAL; // Swallow newlines
                case IAC_CHAR:
                    return IAC;
                case DEL_CHAR:
                    handler.dataReceived(8);
                    return NORMAL;
                case CR_CHAR:
                    handler.eolReceived();
                    return NORMAL;
                case ESC_CHAR:
                    return ESCAPE;
                default:
                    handler.dataReceived(receiveData);
                    return NORMAL;
            }
        }
    },

    IAC {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case IP_CHAR:  // Interrupt process
                    handler.dataReceived(INTR_CHAR);
                    return NORMAL;
                case DO_CHAR:
                    return DO;
                case DONT_CHAR:
                    return DONT;
                case WILL_CHAR:
                    return WILL;
                case WONT_CHAR:
                    return WONT;
                default:
                    return NORMAL;
            }
        }
    },

    /**
     * Client sends will.
     */
    WILL {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case ECHO:
                    handler.pleaseDo(receiveData);
                    return NORMAL;
                default:        // Must respond to unsupported option
                    LOGGER.debug("Don't do: {}", receiveData);
                    handler.pleaseDont(receiveData);
                    return NORMAL;
            }
        }
    },

    /**
     * Client sends won't.
     */
    WONT {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                default:        // Must respond to unsupported option
                    return NORMAL;
            }
        }
    },

    DO {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case SUPPRESS_GA:
                case ECHO:
                    handler.willDo(receiveData);
                    return NORMAL;
                default:        // Must respond to unsupported option
                    LOGGER.info("Wont do: {}", receiveData);
                    handler.wontDo(receiveData);
                    return NORMAL;
            }
        }
    },

    DONT {
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                default:
                    return NORMAL;
            }
        }
    },

    ESCAPE {  // Keyboard escape sequence.
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case '[':
                    return BRACKET;
                default:
                    handler.dataReceived(ESC_CHAR);
                    handler.dataReceived(receiveData);
                    return NORMAL;
            }
        }
    },

    BRACKET {  // Keyboard escape sequence.
        @Override
        TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
                throws IOException {
            switch (receiveData) {
                case 'A': // Up-arrow
                    handler.dataReceived(12);
                    return NORMAL;
                case 'B': // Down-arrow
                    handler.dataReceived(10);
                    return NORMAL;
                case 'C': // Right-arrow
                    handler.dataReceived(9);
                    return NORMAL;
                case 'D': // Left-arrow (shift <-)
                    handler.dataReceived(0x18);
                    return NORMAL;
                case 'F': // To end of line (ctrl ->)
                    handler.dataReceived(17);
                    return NORMAL;
                case 'H': // Home (ctrl ^)
                    handler.dataReceived(19);
                    return NORMAL;
                default:  // Unrecognized sequence - send it all forward.
                    handler.dataReceived(ESC_CHAR);
                    handler.dataReceived('[');
                    handler.dataReceived(receiveData);
                    return NORMAL;
            }
        }
    };

    private static final Logger LOGGER = 
            LoggerFactory.getLogger(TelnetState.class);

    private static final int NULL_CHAR = 0;
    private static final int INTR_CHAR = 3;
    private static final int QUIT_CHAR = 5;
    private static final int NEWLINE_CHAR = 10;
    private static final int CR_CHAR = 13;
    private static final int ESC_CHAR = 27;
    private static final int DEL_CHAR = 127;   // VT100 sends DEL and not BS

    static final int TRANSMIT_BINARY = 0;
    static final int ECHO = 1;
    static final int SUPPRESS_GA = 3;  // Suppress Go ahead
    static final int TIMING = 6;  // Telnet option Timing mark

    static final int NOP_CHAR = 241;  // No operation
    static final int IP_CHAR = 244;   // Interrupt Process
    static final int WILL_CHAR = 251;
    static final int WONT_CHAR = 252;
    static final int DO_CHAR = 253;
    static final int DONT_CHAR = 254;
    static final int IAC_CHAR = 255;  // Interpret as Command

    abstract TelnetState handleCharacter(int receiveData, AciaTelnetUI handler)
            throws IOException;
}
