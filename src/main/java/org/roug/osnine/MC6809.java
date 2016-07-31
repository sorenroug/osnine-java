package org.roug.osnine;

public class MC6809 extends USimMotorola {

    private int debug;

    public static final int immediate = 0;
    public static final int relative = 0;
    public static final int inherent = 1;
    public static final int extended = 2;
    public static final int direct = 3;
    public static final int indexed = 3;

    protected int mode;

/*
    public enum Modes {
                immediate(0),
                relative(0),
                inherent(1),
                extended(2),
                direct(3),
                indexed(4)
    }
    protected Modes mode;
*/


    public Word u;       //!< Stack pointer U
    public Word s;       //!< Stack pointer S
    public Word x;       //!< Index register X
    public Word y;       //!< Index register Y
    /** Direct Page register. */
    public UByte  dp = new UByte();
    public UByte a = new UByte();
    public UByte b = new UByte();
    public RegisterD d = new RegisterD(a, b);

    private CC cc = new CC();

    /**
     * Constructor: Allocate 65.536 bytes of memory and reset the CPU.
     */
    public MC6809() //: a(acc.byte.a), b(acc.byte.b), d(acc.d)
    {
        allocate_memory(0x10000);
        reset();
    }

    /**
     * Reset the simulator. Program counter is set to the content for the top
     * two bytes in memory. Direct page register is set to 0.
     */
    public void reset() {
        pc = read_word(0xfffe);
        dp.set(0x00);      /* Direct page register = 0x00 */
        cc.clearCC();      /* Clear all flags */
        cc.bit_i = 1;       /* IRQ disabled */
        cc.bit_f = 1;       /* FIRQ disabled */
    }

    public void status() {
    }

    /**
     * Execute one instruction.
     */
    public void execute()
    {
    //                   disasmPC();
        ir = fetch();

        /* Select addressing mode */
        switch (ir & 0xf0) {
            case 0x00: case 0x90: case 0xd0:
                mode = direct; break;
            case 0x20:
                mode = relative; break;
            case 0x30: case 0x40: case 0x50:
                if (ir < 0x34) {
                    mode = indexed;
                } else if (ir < 0x38) {
                    mode = immediate;
                } else {
                    mode = inherent;
                }
                break;
            case 0x60: case 0xa0: case 0xe0:
                mode = indexed; break;
            case 0x70: case 0xb0: case 0xf0:
                mode = extended; break;
            case 0x80: case 0xc0:
                if (ir == 0x8d) {
                    mode = relative;
                } else {
                    mode = immediate;
                }
                break;
            case 0x10:
                switch (ir & 0x0f) {
                    case 0x02: case 0x03: case 0x09:
                    case 0x0d: case 0x0e: case 0x0f:
                        mode = inherent; break;
                    case 0x06: case 0x07:
                        mode = relative; break;
                    case 0x0a: case 0x0c:
                        mode = immediate; break;
                    case 0x00: case 0x01:
                        ir <<= 8;
                        ir |= fetch();
                        switch (ir & 0xf0) {
                            case 0x20:
                                mode = relative; break;
                            case 0x30:
                                mode = inherent; break;
                            case 0x80: case 0xc0:
                                mode = immediate; break;
                            case 0x90: case 0xd0:
                                mode = direct; break;
                            case 0xa0: case 0xe0:
                                mode = indexed; break;
                            case 0xb0: case 0xf0:
                                mode = extended; break;
                        }
                        break;
                }
                break;
        }

    }

    public int getSignedByte(int value) {
        if (value < 0x80) {
            return value;
        } else {
            return -((~value & 0x7f) + 1);
        }
    }

    public int getSignedWord(int value) {
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
        }
    }

    /**
     * Find 16-bit register name in post-byte.
     * 00 = X
     * 01 = Y
     * 10 = U
     * 11 = S
     */
    private Word refreg(int post) {
        post &= 0x60;
        post >>= 5;

        if (post == 0) {
            return x;
        } else if (post == 1) {
            return y;
        } else if (post == 2) {
            return u;
        } else {
            return s;
        }
    }

    private int byterefreg(int r)
    {
        if (r == 0x08) {
            return a.intValue();
        } else if (r == 0x09) {
            return b.intValue();
        } else if (r == 0x0a) {
            return cc.getCC();
        } else {
            return dp.intValue();
        }
    }

    private int wordrefreg(int r) {
        if (r == 0x00) {
            return d.intValue();
        } else if (r == 0x01) {
            return x.intValue();
        } else if (r == 0x02) {
            return y.intValue();
        } else if (r == 0x03) {
            return u.intValue();
        } else if (r == 0x04) {
            return s.intValue();
        } else {
            return pc;
        }
    }

    private int fetch_operand() {
        int ret = 0;
        int addr;

        if (mode == immediate) {
            ret = fetch();
        } else if (mode == relative) {
            ret = fetch();
        } else if (mode == extended) {
            addr = fetch_word();
            ret = read(addr);
        } else if (mode == direct) {
            addr = (dp.intValue() << 8) | fetch();
            ret = read(addr);
        } else if (mode == indexed) {
            int post = fetch();
            do_predecrement(post);
            addr = do_effective_address(post);
            ret = read(addr);
            do_postincrement(post);
        } else {
            invalid("addressing mode");
        }

        return ret;
    }

    private int fetch_word_operand() {
        int ret = 0;
        int addr;

        if (mode == immediate) {
            ret = fetch_word();
        } else if (mode == relative) {
            ret = fetch_word();
        } else if (mode == extended) {
            addr = fetch_word();
            ret = read_word(addr);
        } else if (mode == direct) {
            addr = dp.intValue() << 8 | fetch();
            ret = read_word(addr);
        } else if (mode == indexed) {
            int post = fetch();
            do_predecrement(post);
            addr = do_effective_address(post);
            do_postincrement(post);
            ret = read_word(addr);
        } else {
            invalid("addressing mode");
        }

        return ret;
    }

    private int fetch_effective_address() {
        int addr = 0;

        if (mode == extended) {
            addr = fetch_word();
        } else if (mode == direct) {
            addr = dp.intValue() << 8 | fetch();
        } else if (mode == indexed) {
            int post = fetch();
            do_predecrement(post);
            addr = do_effective_address(post);
            do_postincrement(post);
        } else {
            invalid("addressing mode");
        }

        return addr;
    }

    /**
     * Calculate indirect addressing.
     */
    private int do_effective_address(int post) {
        int addr = 0;
        int sOffset;
        int uOffset;

        if ((post & 0x80) == 0x00) {
            addr = refreg(post).intValue() + extend5(post & 0x1f);   // Constant 5-bit offset from register
        } else {
            switch (post & 0x1f) {
                case 0x00:  // Increment by 1 (done elsewhere)
                case 0x02:  // Decrement by 1 (done elsewhere)
                    addr = refreg(post).intValue();
                    break;
                case 0x01:  // Increment by 2 (done elsewhere)
                case 0x03:  // Decrement by 2 (done elsewhere)
                case 0x11:  // Increment by 2 (done elsewhere)
                case 0x13:  // Decrement by 2 (done elsewhere)
                    addr = refreg(post).intValue();
                    break;
                case 0x04:  // Non-Indirect No offset
                case 0x14:  // Indirect No offset
                    addr = refreg(post).intValue();
                    break;
                case 0x05:  // Non-Indirect B-register offset
                case 0x15:  // Indirect B-register offset
                    addr = b.getSigned() + refreg(post).intValue();
                    break;
                case 0x06:  // Non-Indirect A-register offset
                case 0x16:  // Indirect A-register offset
                    addr = a.getSigned() + refreg(post).intValue();
                    break;
                case 0x08:  // Non-Indirect 8-bit offset
                case 0x18:  // Indirect 8-bit offset
                    addr = refreg(post).intValue() + extend8(fetch());
                    break;
                case 0x09:  // Non-Indirect 16-bit offset
                case 0x19:  // Indirect 16-bit offset
                    sOffset = getSignedWord(fetch_word());
                    addr = refreg(post).intValue() + sOffset;
                    break;
                case 0x0b:   // Non-Indirect D-register offset
                case 0x1b:   //  Indirect D-register offset
                    sOffset = refreg(post).getSigned();
                    addr = getSignedWord(d.intValue() + sOffset);
                    break;
                case 0x0c:   // Non-Indirect Constant 8-bit offset from PC
                case 0x1c:   // Indirect Constant 8-bit offset from PC
                    uOffset = extend8(fetch());
                    addr = pc + uOffset;
                    break;
                case 0x0d:   // Non-Indirect Constant 16-bit offset from PC
                case 0x1d:   // Indirect Constant 16-bit offset from PC
                    sOffset = getSignedWord(fetch_word());
                    addr = pc + sOffset;
                    break;
                case 0x1f:   // Extended indirect
                    addr = fetch_word();
                    break;
                default:
                    invalid("indirect addressing postbyte");
                    break;
            }

            /* Do extra indirection */
            if ((post & 0x10) != 0) {
                addr = read_word(addr);
            }
        }

        return addr;
    }

    // Bit extend operations
    private int extend5(int x) {
        if ((x & 0x10) != 0) {
            return x | 0xffe0;
        } else {
            return x;
        }
    }

    private int extend8(int x) {
        if ((x & 0x80) != 0) {
            return x | 0xff00;
        } else {
            return x;
        }
    }

    private void do_postincrement(int post) {
        switch (post & 0x9f) {
            case 0x80:
                refreg(post).add(1);
                break;
            case 0x90:
                invalid("postincrement");
                break;
            case 0x81: case 0x91:
                refreg(post).add(2);
                break;
        }
    }

    private void do_predecrement(int post) {
        switch (post & 0x9f) {
            case 0x82:
                refreg(post).add(-1);
                break;
            case 0x92:
                invalid("predecrement");
                break;
            case 0x83: case 0x93:
                refreg(post).add(-2);
                break;
        }
    }

}
