package org.roug.usim.mc6809;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.MemorySegment;
import org.roug.usim.RandomAccessMemory;
import org.roug.usim.Register;
import org.roug.usim.RegisterBytePair;
import org.roug.usim.UByte;
import org.roug.usim.USimMotorola;
import org.roug.usim.Word;
import static org.roug.usim.BitOperations.bittst;


/**
 * Implementation of the Motorola 6809 MPU.
 */
public class MC6809 extends USimMotorola {

    public static final int SWI3_ADDR = 0xfff2;
    public static final int SWI2_ADDR = 0xfff4;
    public static final int FIRQ_ADDR = 0xfff6;
    public static final int IRQ_ADDR = 0xfff8;
    public static final int SWI_ADDR = 0xfffa;
    public static final int NMI_ADDR = 0xfffc;
    public static final int RESET_ADDR = 0xfffe;

    private static final int IMMEDIATE = 0;
    private static final int RELATIVE = 0;
    private static final int INHERENT = 1;
    private static final int EXTENDED = 2;
    private static final int DIRECT = 3;
    private static final int INDEXED = 4;

    /** Addressing mode. */
    private int mode;

    /** Set to true to disassemble executed instruction. */
    private boolean traceInstructions = false;

    /** Stack pointer U. */
    public final Word u = new Word("U");
    /** Stack pointer S. */
    public final Word s = new Word("S");
    /** Index register X. */
    public final Word x = new Word("X");
    /** Index register Y. */
    public final Word y = new Word("Y");

    /** Direct Page register. */
    public final UByte dp = new UByte("DP");
    /** Accumulater A. */
    public final UByte a = new UByte("A");
    /** Accumulater B. */
    public final UByte b = new UByte("B");
    /** Accumulater D. Combined from A and B. */
    public final RegisterBytePair d = new RegisterBytePair("D", a, b);

    /** Condiction codes. */
    public final RegisterCC cc = new RegisterCC();

    /** Make memory location act like a register. */
    private MemoryProxy memReg = new MemoryProxy();

    /** Prevent NMI handling. */
    private boolean inhibitNMI;

    /** RESET signalled. */
    private volatile boolean resetSignal;

    /** CWAI active? */
    private boolean waitState = false;

    private static final Logger LOGGER = LoggerFactory.getLogger(MC6809.class);

    private DisAssembler disAsm = null;

    /** The bus the CPU is connected to. */
    private Bus8Motorola bus;

    /**
     * Do we have active FIRQs and we're accepting FIRQs?
     */
    private boolean isFIRQActive() {
        return !cc.isSetF() && bus.isFIRQActive();
    }

    /**
     * Do we have active IRQs and we're accepting IRQs?
     */
    private boolean isIRQActive() {
        return !cc.isSetI() && bus.isIRQActive();
    }

    /**
     * Do we have active NMIs and we're accepting NMIs?
     */
    private boolean isNMIActive() {
        return !inhibitNMI && bus.isNMIActive();
    }

    /**
     * Create CPU, the bus it is attached to and 16 bytes of memory for
     * interrupt vectors.
     */
    public MC6809() {
        super(new BusStraight());
        bus = (Bus8Motorola) super.getBus();
        allocate_memory(0xfff0, 16);
        if(LOGGER.isTraceEnabled()) {
            setTraceInstructions(true);
        }
        reset();
    }

    /**
     * Constructor: Assigned bus.
     *
     * @param bus the memory bus the CPU is attached to
     */
    public MC6809(Bus8Motorola bus) {
        super(bus);
        this.bus = bus;
        if(LOGGER.isTraceEnabled()) {
            setTraceInstructions(true);
        }
        reset();
    }

    private void setTraceInstructions(boolean value) {
        traceInstructions = value;
        if (disAsm == null && value) {
            disAsm = new DisAssembler(this);
        }
    }

    /**
     * Get the memory bus.
     */
    public Bus8Motorola getBus() {
        return bus;
    }

    /**
     * Constructor: Allocate memory starting from address 0.
     *
     * @param memorySize - amount of memory to allocate
     */
    public MC6809(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    private void allocate_memory(int start, int memorySize) {
        MemorySegment newMemory = new RandomAccessMemory(start, bus, Integer.toString(memorySize));
        bus.addMemorySegment(newMemory);
    }

    /**
     * Send a signal to reset the CPU when it is done with the current
     * instruction. Program counter is set to the content for the top
     * two bytes in memory. Direct page register is set to 0.
     */
    public void signalReset() {
        resetSignal = true;
    }

    /**
     * Reset the simulator. Program counter is set to the content for the top
     * two bytes in memory. Direct page register is set to 0.
     */
    public void reset() {
        resetSignal = false;
        pc.set(read_word(RESET_ADDR));
        dp.set(0x00);      // Direct page register = 0x00
        cc.clear();      // Clear all flags
        cc.setI(1);       // IRQ disabled
        cc.setF(1);       // FIRQ disabled
        inhibitNMI = true;
    }

    /**
     * Print out status.
     */
    public void status() {
        LOGGER.debug("PC:{} A:{} B:{}", pc, a, b);
    }

    /**
     * Execute one instruction.
     */
    public void execute() {
        if (resetSignal) {
            reset();
        }
        if (traceInstructions) {
            disAsm.disasmPC();
        }
        ir = fetch();

        // Select addressing mode
        switch (ir & 0xf0) {
            case 0x00: case 0x90: case 0xd0:
                mode = DIRECT; break;
            case 0x20:
                mode = RELATIVE; break;
            case 0x30: case 0x40: case 0x50:
                if (ir < 0x34) {
                    mode = INDEXED;
                } else if (ir < 0x38) {
                    mode = IMMEDIATE;
                } else {
                    mode = INHERENT;
                }
                break;
            case 0x60: case 0xa0: case 0xe0:
                mode = INDEXED; break;
            case 0x70: case 0xb0: case 0xf0:
                mode = EXTENDED; break;
            case 0x80: case 0xc0:
                mode = IMMEDIATE; break;
            case 0x10:
                switch (ir & 0x0f) {
                    case 0x02: case 0x03: case 0x09:
                    case 0x0d: case 0x0e: case 0x0f:
                        mode = INHERENT; break;
                    case 0x06: case 0x07:
                        mode = RELATIVE; break;
                    case 0x0a: case 0x0c:
                        mode = IMMEDIATE; break;
                    case 0x00: case 0x01:
                        ir <<= 8;
                        ir |= fetch();
                        switch (ir & 0xf0) {
                            case 0x20:
                                mode = RELATIVE; break;
                            case 0x30:
                                mode = INHERENT; break;
                            case 0x80: case 0xc0:
                                mode = IMMEDIATE; break;
                            case 0x90: case 0xd0:
                                mode = DIRECT; break;
                            case 0xa0: case 0xe0:
                                mode = INDEXED; break;
                            case 0xb0: case 0xf0:
                                mode = EXTENDED; break;
                        }
                        break;
                }
                break;
        }

        // Select instruction
        if (ir < 0x80) {
            executeUnder80();
        } else if (ir >= 0x1080) {
            execute1080();
        } else if (ir >= 0x1000) {
            execute1000();
        } else {
            execute80toFF();
        }

        if (isNMIActive()) {
            nmi();
        }
        if (isFIRQActive()) {
            firq();
        }
        if (isIRQActive()) {
            irq();
        }
    }

    /**
     * Execute instructions with opcodes below 0x80.
     */
    private void executeUnder80() {
        switch (ir) {
            case 0x3a:
                abx(); break;
            case 0x1c:
                andcc(); break;
            case 0x47:
                help_asr(a); break;
            case 0x57:
                help_asr(b); break;
            case 0x07: case 0x67: case 0x77:
                help_asr(memReg.fetch()); break;
            case 0x24:
                bcc(); break;
            case 0x25:
                bcs(); break;
            case 0x27:
                beq(); break;
            case 0x2c:
                bge(); break;
            case 0x2e:
                bgt(); break;
            case 0x22:
                bhi(); break;
            case 0x2f:
                ble(); break;
            case 0x23:
                bls(); break;
            case 0x2d:
                blt(); break;
            case 0x2b:
                bmi(); break;
            case 0x26:
                bne(); break;
            case 0x2a:
                bpl(); break;
            case 0x20:
                bra(); break;
            case 0x16:
                lbra(); break;
            case 0x21:
                brn(); break;
            case 0x17:
                lbsr(); break;
            case 0x28:
                bvc(); break;
            case 0x29:
                bvs(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x4f:
            case 0x4f: case 0x4e:
                help_clr(a); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x5f:
            case 0x5f: case 0x5e:
                help_clr(b); break;
            case 0x0f: case 0x6f: case 0x7f:
                help_clr(memReg.fetch()); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x43:
            case 0x43: case 0x42:
                help_com(a); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x53:
            case 0x53: case 0x52:
                help_com(b); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x03: case 0x63: case 0x73:
            case 0x03: case 0x62: case 0x63: case 0x73:
                help_com(memReg.fetch()); break;
            case 0x3c:
                cwai(); break;
            case 0x19:
                daa(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x4a:
            case 0x4a: case 0x4b:
                help_dec(a); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x5a:
            case 0x5a: case 0x5b:
                help_dec(b); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x0a: case 0x6a: case 0x7a:
            case 0x0a: case 0x0b: case 0x6a: case 0x6b:
            case 0x7a: case 0x7b:
                help_dec(memReg.fetch()); break;
            case 0x1e:
                exg(); break;
            case 0x4c:
                help_inc(a); break;
            case 0x5c:
                help_inc(b); break;
            case 0x0c: case 0x6c: case 0x7c:
                help_inc(memReg.fetch()); break;
            case 0x0e: case 0x6e: case 0x7e:
                jmp(); break;
            case 0x32:
                leas(); break;
            case 0x33:
                leau(); break;
            case 0x30:
                leax(); break;
            case 0x31:
                leay(); break;
            case 0x48:
                help_lsl(a); break;
            case 0x58:
                help_lsl(b); break;
            case 0x08: case 0x68: case 0x78:
                help_lsl(memReg.fetch()); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x44:
            case 0x44: case 0x45:
                help_lsr(a); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x54:
            case 0x54: case 0x55:
                help_lsr(b); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x04: case 0x64: case 0x74:
            case 0x04: case 0x05: case 0x64: case 0x65:
            case 0x74: case 0x75:
                help_lsr(memReg.fetch()); break;
            case 0x3d:
                mul(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x40:
            case 0x40: case 0x41:
                help_neg(a); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x50:
            case 0x50: case 0x51:
                help_neg(b); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x00: case 0x60: case 0x70:
            case 0x00: case 0x01: case 0x60: case 0x61:
            case 0x70: case 0x71:
                help_neg(memReg.fetch()); break;
            // BDA - Adding in undocumented 6809 instructions
            // NEG/COM combination instruction for direct page
            case 0x02:
                if (cc.getC() == 1)
                    help_com(memReg.fetch());
                else
                    help_neg(memReg.fetch());
                break;
            case 0x12:
                nop(); break;
            case 0x1a:
                orcc(); break;
            case 0x34:
                pshs(); break;
            case 0x36:
                pshu(); break;
            case 0x35:
                puls(); break;
            case 0x37:
                pulu(); break;
            // BDA - Adding in undocumented 6809 instructions
            case 0x3e:
                reset(); break;
            case 0x49:
                help_rol(a); break;
            case 0x59:
                help_rol(b); break;
            case 0x09: case 0x69: case 0x79:
                help_rol(memReg.fetch()); break;
            case 0x46:
                help_ror(a); break;
            case 0x56:
                help_ror(b); break;
            case 0x06: case 0x66: case 0x76:
                help_ror(memReg.fetch()); break;
            case 0x3b:
                rti(); break;
            case 0x39:
                rts(); break;
            case 0x1d:
                sex(); break;
            case 0x3f:
                swi(); break;
            case 0x13:
                sync(); break;
            case 0x1f:
                tfr(); break;
            case 0x4d:
                help_tst(a); break;
            case 0x5d:
                help_tst(b); break;
            case 0x0d: case 0x6d: case 0x7d:
                help_tst(memReg.fetch()); break;
            default:
                invalid("instruction"); break;
        }
    }

    /**
     * Execute instructions with opcodes between 0x80 to 0xFF.
     */
    private void execute80toFF() {
        // Could do a switch (ir & 0xCF) here. But watch out for bsr().
        switch (ir) {
            case 0x89: case 0x99: case 0xa9: case 0xb9:
                help_adc(a); break;
            case 0xc9: case 0xd9: case 0xe9: case 0xf9:
                help_adc(b); break;
            case 0x8b: case 0x9b: case 0xab: case 0xbb:
                help_add(a); break;
            case 0xcb: case 0xdb: case 0xeb: case 0xfb:
                help_add(b); break;
            case 0xc3: case 0xd3: case 0xe3: case 0xf3:
                addd(); break;
            case 0x84: case 0x94: case 0xa4: case 0xb4:
                help_and(a); break;
            case 0xc4: case 0xd4: case 0xe4: case 0xf4:
                help_and(b); break;
            case 0x85: case 0x95: case 0xa5: case 0xb5:
                help_bit(a); break;
            case 0xc5: case 0xd5: case 0xe5: case 0xf5:
                help_bit(b); break;
            case 0x81: case 0x91: case 0xa1: case 0xb1:
                help_cmp(a); break;
            case 0xc1: case 0xd1: case 0xe1: case 0xf1:
                help_cmp(b); break;
            case 0x8c: case 0x9c: case 0xac: case 0xbc:
                help_cmp(x); break;
            case 0x88: case 0x98: case 0xa8: case 0xb8:
                help_eor(a); break;
            case 0xc8: case 0xd8: case 0xe8: case 0xf8:
                help_eor(b); break;
            case 0x8d:
                bsr(); break;
            case 0x9d: case 0xad: case 0xbd:
                jsr(); break;
            case 0x86: case 0x96: case 0xa6: case 0xb6:
                help_ld(a); break;
            case 0xc6: case 0xd6: case 0xe6: case 0xf6:
                help_ld(b); break;
            case 0xcc: case 0xdc: case 0xec: case 0xfc:
                help_ld(d); break;
            case 0xce: case 0xde: case 0xee: case 0xfe:
                help_ld(u); break;
            case 0x8e: case 0x9e: case 0xae: case 0xbe:
                help_ld(x); break;
            case 0x8a: case 0x9a: case 0xaa: case 0xba:
                help_or(a); break;
            case 0xca: case 0xda: case 0xea: case 0xfa:
                help_or(b); break;
            case 0x82: case 0x92: case 0xa2: case 0xb2:
                help_sbc(a); break;
            case 0xc2: case 0xd2: case 0xe2: case 0xf2:
                help_sbc(b); break;
            case 0x97: case 0xa7: case 0xb7:
                help_st(a); break;
            case 0xd7: case 0xe7: case 0xf7:
                help_st(b); break;
            case 0xdd: case 0xed: case 0xfd:
                help_st(d); break;
            case 0xdf: case 0xef: case 0xff:
                help_st(u); break;
            case 0x9f: case 0xaf: case 0xbf:
                help_st(x); break;
            case 0x80: case 0x90: case 0xa0: case 0xb0:
                help_sub(a); break;
            case 0xc0: case 0xd0: case 0xe0: case 0xf0:
                help_sub(b); break;
            case 0x83: case 0x93: case 0xa3: case 0xb3:
                subd(); break;
            default:
                invalid("instruction"); break;
        }
    }

    private void execute1000() {
        switch (ir) {
            case 0x1024:
                lbcc(); break;
            case 0x1025:
                lbcs(); break;
            case 0x1027:
                lbeq(); break;
            case 0x102c:
                lbge(); break;
            case 0x102e:
                lbgt(); break;
            case 0x1022:
                lbhi(); break;
            case 0x102f:
                lble(); break;
            case 0x1023:
                lbls(); break;
            case 0x102d:
                lblt(); break;
            case 0x102b:
                lbmi(); break;
            case 0x1026:
                lbne(); break;
            case 0x102a:
                lbpl(); break;
            case 0x1021:
                lbrn(); break;
            case 0x1028:
                lbvc(); break;
            case 0x1029:
                lbvs(); break;
            case 0x103f:
                swi2(); break;
            default:
                invalid("instruction"); break;
        }
    }

    private void execute1080() {
        switch (ir) {
            case 0x1083: case 0x1093: case 0x10a3: case 0x10b3:
                help_cmp(d); break;
            case 0x118c: case 0x119c: case 0x11ac: case 0x11bc:
                help_cmp(s); break;
            case 0x1183: case 0x1193: case 0x11a3: case 0x11b3:
                help_cmp(u); break;
            case 0x108c: case 0x109c: case 0x10ac: case 0x10bc:
                help_cmp(y); break;
            case 0x10ce: case 0x10de: case 0x10ee: case 0x10fe:
                help_ld(s);
                inhibitNMI = false;
                break;
            case 0x108e: case 0x109e: case 0x10ae: case 0x10be:
                help_ld(y); break;
            case 0x10df: case 0x10ef: case 0x10ff:
                help_st(s); break;
            case 0x109f: case 0x10af: case 0x10bf:
                help_st(y); break;
            case 0x113f:
                swi3(); break;
            default:
                invalid("instruction"); break;
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

        switch (post) {
            case 0: return x;
            case 1: return y;
            case 2: return u;
            default: return s;
        }
    }

    private Register tfrrefreg(int r) {
        switch (r) {
            case 0x00: return d;
            case 0x01: return x;
            case 0x02: return y;
            case 0x03: return u;
            case 0x04: return s;
            case 0x05: return pc;
            case 0x08: return a;
            case 0x09: return b;
            case 0x0A: return cc;
            case 0x0B: return dp;
            default:
                invalid("register");
                return null;
        }
    }

    private int refregvalue(int r) {
        switch (r) {
            case 0x00: return d.intValue();
            case 0x01: return x.intValue();
            case 0x02: return y.intValue();
            case 0x03: return u.intValue();
            case 0x04: return s.intValue();
            case 0x05: return pc.intValue();
            case 0x08: return a.intValue() | 0xFF00;
            case 0x09: return b.intValue() | 0xFF00;
            case 0x0A: return cc.intValue() | 0xFF00;
            case 0x0B: return dp.intValue() | 0xFF00;
            default:
                return 0xFFFF;
        }
    }

    private int fetch_operand() {
        int ret = 0;
        int addr;

        switch (mode) {
            case IMMEDIATE:  // or RELATIVE
                ret = fetch();
                break;
            case EXTENDED:
                addr = fetch_word();
                ret = read(addr);
                break;
            case DIRECT:
                addr = (dp.intValue() << 8) | fetch();
                ret = read(addr);
                break;
            case INDEXED:
                int post = fetch();
                do_predecrement(post);
                addr = do_effective_address(post);
                ret = read(addr);
                do_postincrement(post);
                break;
            default:
                invalid("addressing mode");
        }

        return ret;
    }

    private int fetch_word_operand() {
        int ret = 0;
        int addr;

        switch (mode) {
            case IMMEDIATE:  // or RELATIVE
                ret = fetch_word();
                break;
            case EXTENDED:
                addr = fetch_word();
                ret = read_word(addr);
                break;
            case DIRECT:
                addr = dp.intValue() << 8 | fetch();
                ret = read_word(addr);
                break;
            case INDEXED:
                int post = fetch();
                do_predecrement(post);
                addr = do_effective_address(post);
                do_postincrement(post);
                ret = read_word(addr);
                break;
            default:
                invalid("addressing mode");
        }

        return ret;
    }

    private int fetch_effective_address() {
        int addr = 0;
        int post;

        switch (mode) {
            // Used as a mode for jsr() instead of bsr().
//          case IMMEDIATE:
//              post = fetch();
//              addr = pc.intValue() + extend8(post);
//              break;
            case EXTENDED:
                addr = fetch_word();
                break;
            case DIRECT:
                addr = dp.intValue() << 8 | fetch();
                break;
            case INDEXED:
                post = fetch();
                do_predecrement(post);
                addr = do_effective_address(post);
                do_postincrement(post);
                break;
            default:
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
                    addr = (d.intValue() + sOffset) & 0xFFFF;
                    break;
                case 0x0c:   // Non-Indirect Constant 8-bit offset from PC
                case 0x1c:   // Indirect Constant 8-bit offset from PC
                    uOffset = extend8(fetch());
                    addr = pc.intValue() + uOffset;
                    break;
                case 0x0d:   // Non-Indirect Constant 16-bit offset from PC
                case 0x1d:   // Indirect Constant 16-bit offset from PC
                    sOffset = getSignedWord(fetch_word());
                    addr = pc.intValue() + sOffset;
                    break;
                case 0x1f:   // Extended indirect
                    addr = fetch_word();
                    break;
                default:
                    invalid("indirect addressing postbyte");
                    break;
            }

            // Do extra indirection
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

    private static int getSignedByte(int value) {
        if (value < 0x80) {
            return value;
        } else {
            return -((~value & 0x7f) + 1);
        }
    }

    private static int getSignedWord(int value) {
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
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

    private void setBitZ(Register ref) {
        cc.setZ(ref.intValue() == 0);
    }

    /**
     * Set CC bit N if value is negative.
     */
    private void setBitN(Register ref) {
        cc.setN(ref.btst(ref.getWidth() - 1));
    }

    /**
     * Add Accumulator B into index register X.
     */
    private void abx() {
        x.add(b.intValue());
    }

    /**
     * Add with carry into accumulator.
     */
    private void help_adc(UByte refB) {
        int m = fetch_operand();

        int halfCarry = (refB.intValue() & 0x0f) + (m & 0x0f) + cc.getC();
        cc.setH(bittst(halfCarry, 4));         // Half carry

        int carryIn = (refB.intValue() & 0x7f) + (m & 0x7f) + cc.getC();
        cc.setV(bittst(carryIn, 7));      // Bit 7 carry in
        int t = refB.intValue() + m + cc.getC();
        cc.setC(bittst(t, 8));         // Bit 7 carry out
        cc.setV(cc.getV() != cc.getC());
        refB.set(t);

        setBitN(refB);
        setBitZ(refB);
    }

    /**
     * Add two 8-bit numbers.
     * The rules for turning on the overflow flag in binary/integer math are two:

     * 1. If the sum of two numbers with the sign bits off yields a result number
     *    with the sign bit on, the "overflow" flag is turned on.

     *    0100 + 0100 = 1000 (overflow flag is turned on)

     * 2. If the sum of two numbers with the sign bits on yields a result number
     *    with the sign bit off, the "overflow" flag is turned on.

     *    1000 + 1000 = 0000 (overflow flag is turned on)

     * Otherwise, the overflow flag is turned off.
     * 0100 + 0001 = 0101 (overflow flag is turned off)
     * 0110 + 1001 = 1111 (overflow flag is turned off)
     * 1000 + 0001 = 1001 (overflow flag is turned off)
     * 1100 + 1100 = 1000 (overflow flag is turned off)

     * Note that you only need to look at the sign bits (leftmost) of the three
     * numbers to decide if the overflow flag is turned on or off.

     * If you are doing two's complement (signed) arithmetic, overflow flag on
     * means the answer is wrong - you added two positive numbers and got a
     * negative, or you added two negative numbers and got a positive.
     */
    private void help_add(UByte refB) {
        int m = fetch_operand();

        int halfCarry = (refB.intValue() & 0x0f) + (m & 0x0f);
        cc.setH(bittst(halfCarry, 4));         // Half carry

        int carryIn = (refB.intValue() & 0x7f) + (m & 0x7f);
        cc.setV(bittst(carryIn, 7));      // Bit 7 carry in

        int t = refB.intValue() + m;
        cc.setC(bittst(t, 8));
        cc.setV(cc.getV() != cc.getC());
        refB.set(t);

        setBitN(refB);
        setBitZ(refB);
    }

    /**
     * Add memory into accumulator D.
     */
    private void addd() {
        int m = fetch_word_operand();
        int t = d.intValue() + m;

        cc.setV(bittst(d.intValue() ^ m ^ t ^ (t >> 1), 15));
        int newD = d.intValue() + m;
        d.set(newD);
        cc.setC(newD > 0xffff);
        cc.setN(d.btst(15));
        setBitZ(d);
    }

    /**
     * Add memory into accumulator.
     */
    private void help_and(UByte refB) {
        refB.set(refB.intValue() & fetch_operand());
        cc.setN(refB.btst(7));
        setBitZ(refB);
        cc.setV(0);
    }

    /**
     * AND Immediate Data into Condition Code register.
     */
    private void andcc() {
        cc.set(cc.intValue() & fetch());
    }

    /**
     * Arithmetic Shift Right.
     */
    private void help_asr(UByte refB) {
        cc.setC(refB.btst(0));
        refB.set(refB.intValue() >> 1);    // Shift word right
        cc.setN(refB.btst(6));
        if (cc.getN() != 0) {
            refB.bset(7);
        }
        setBitZ(refB);
    }

    /**
     * Branch on Carry Clear.
     */
    private void bcc() {
        do_br(!cc.isSetC());
    }

    /**
     * Long Branch on Carry Clear.
     */
    private void lbcc() {
        do_lbr(!cc.isSetC());
    }

    /**
     * Branch on Carry Set.
     */
    private void bcs() {
        do_br(cc.isSetC());
    }

    /**
     * Long Branch on Carry Set.
     */
    private void lbcs() {
        do_lbr(cc.isSetC());
    }

    private void beq() {
        do_br(cc.isSetZ());
    }

    private void lbeq() {
        do_lbr(cc.isSetZ());
    }

    private void bge() {
        do_br(cc.isSetN() == cc.isSetV());
    }

    private void lbge() {
        do_lbr(cc.isSetN() == cc.isSetV());
    }

    private void bgt() {
        do_br(!cc.isSetZ() && (cc.isSetN() == cc.isSetV()));
    }

    private void lbgt() {
        do_lbr(!cc.isSetZ() && (cc.isSetN() == cc.isSetV()));
    }


    private void bhi() {
        do_br(!(cc.isSetC() || cc.isSetZ()));
    }

    private void lbhi() {
        do_lbr(!(cc.isSetC() || cc.isSetZ()));
    }


    private void help_bit(UByte arg) {
        UByte t = UByte.valueOf(arg.intValue() & fetch_operand());
        setBitN(t);
        cc.setV(0);
        setBitZ(t);
    }

    private void ble() {
        do_br(cc.isSetZ() || (cc.isSetN() != cc.isSetV()));
    }

    private void lble() {
        do_lbr(cc.isSetZ() || (cc.isSetN() != cc.isSetV()));
    }

    private void bls() {
        do_br(cc.isSetC() || cc.isSetZ());
    }

    private void lbls() {
        do_lbr(cc.isSetC() || cc.isSetZ());
    }

    private void blt() {
        do_br(cc.isSetN() != cc.isSetV());
    }

    private void lblt() {
        do_lbr(cc.isSetN() != cc.isSetV());
    }

    private void bmi() {
        do_br(cc.isSetN());
    }

    private void lbmi() {
        do_lbr(cc.isSetN());
    }

    private void bne() {
        do_br(!cc.isSetZ());
    }

    private void lbne() {
        do_lbr(!cc.isSetZ());
    }

    private void bpl() {
        do_br(!cc.isSetN());
    }

    private void lbpl() {
        do_lbr(!cc.isSetN());
    }

    private void bra() {
        do_br(true);
    }

    private void lbra() {
        do_lbr(true);
    }

    private void brn() {
        do_br(false);
    }

    private void lbrn() {
        do_lbr(false);
    }

    private void bsr() {
        int relAddr = fetch();
        s.add(-1);
        write(s, pc.intValue());
        s.add(-1);
        write(s, (pc.intValue() >> 8));
        pc.add(extend8(relAddr));
    }

    private void lbsr() {
        int relAddr = fetch_word();
        s.add(-1);
        write(s, pc.intValue());
        s.add(-1);
        write(s, (pc.intValue() >> 8));
        pc.add(relAddr);
    }

    private void bvc() {
        do_br(!cc.isSetV());
    }

    private void lbvc() {
        do_lbr(!cc.isSetV());
    }

    private void bvs() {
        do_br(cc.isSetV());
    }

    private void lbvs() {
        do_lbr(cc.isSetV());
    }

    private void help_clr(UByte refB) {
        cc.setN(0);
        cc.setZ(1);
        cc.setV(0);
        cc.setC(0);
        refB.set(0);
    }

    /**
     * Compare byte.
     * The half-carry is undefined after this operation.
     */
    private void help_cmp(UByte reg) {
        int m = fetch_operand();
        int t = reg.intValue() - m;

        cc.setH((t & 0x0f) < (m & 0x0f));

        int carryIn = (reg.intValue() & 0x7f) - (m & 0x7f);
        cc.setV(bittst(carryIn, 7));      // Bit 7 carry in
        cc.setC(bittst(t, 8));
        cc.setV(cc.getV() != cc.getC());
        cc.setN(bittst(t, 7));
        cc.setZ(t == 0);
    }

    private void help_cmp(Word reg) {
        int m = fetch_word_operand();
        int t = reg.intValue() - m;

//      int tmp = reg.intValue() ^ m ^ t ^ (t >> 1);
//      cc.setV(bittst(tmp, 15));
        int carryIn = (reg.intValue() & 0x7fff) - (m & 0x7fff);
        cc.setV(bittst(carryIn, 15));      // Bit 15 carry in
        cc.setC(bittst(t, 16));
        cc.setV(cc.getV() != cc.getC());
        cc.setN(bittst(t, 15));
        cc.setZ(t == 0);
    }

    private void help_com(UByte tx) {
        tx.set(~tx.intValue());
        cc.setC(1);
        cc.setV(0);
        setBitN(tx);
        setBitZ(tx);
    }

    private void waitForInterrupt() {
        try {
            synchronized(bus) {
                while (!(isIRQActive() || isFIRQActive() || isNMIActive() )) {
                    bus.wait();
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("Wait interrupted");
        }
    }

    /**
     * Puts the registers on stack and waits for an interrupt.
     * This makes the MPU react faster to interrupts.
     * TODO: If the I-bit is set, then simulate a firq or nmi to get the
     * cpu out of the sleep.
     */
    private void cwai() {
        cc.set(cc.intValue() & fetch());
        cc.setE(1);
        help_psh(0xff, s, u);
        waitState = true;
        waitForInterrupt();
    }

    /**
     * Synchronize to external event.
     * The processor halts and waits for an interrupt to occur.
     * If the interrupt is masked then the processor continues with
     * the instruction following the SYNC instruction.
     * If the interrupt is enabled then a normal interrupt sequence begins
     * after the SYNC instruction completes.
     */
    private void sync() {
        try {
            synchronized(bus) {
                while(!(bus.isIRQActive() || bus.isFIRQActive() || bus.isNMIActive() )) {
                    bus.wait();
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("Wait interrupted");
        }
    }

    /**
     * Decimal Addition Adjust.
     */
    private void daa() {
        int c = 0;
        int lsn = (a.intValue() & 0x0f);
        int msn = (a.intValue() & 0xf0) >> 4;

        if (cc.isSetH() || (lsn > 9)) {
            c |= 0x06;
        }

        if (cc.isSetC() ||
            (msn > 9) ||
            ((msn > 8) && (lsn > 9))) {
            c |= 0x60;
        }

        {
            int t = a.intValue() + c;
            cc.setC(bittst(t, 8) || cc.isSetC());
            a.set(t);
        }

        setBitN(a);
        setBitZ(a);
    }

    private void help_dec(UByte x) {
        cc.setV(x.intValue() == 0x80);
        x.set(x.intValue() - 1);
        setBitN(x);
        setBitZ(x);
    }

    /**
     * Exclusive OR.
     */
    private void help_eor(UByte x) {
        x.set(x.intValue() ^ fetch_operand());
        cc.setV(0);
        setBitN(x);
        setBitZ(x);
    }

    /**
     * Exchange registers.
     */
    private void exg() {
        int r1, r2;
        int w = fetch();
        r1 = (w & 0xf0) >> 4;
        r2 = (w & 0x0f) >> 0;
        int t = refregvalue(r2);
        tfrrefreg(r2).set(refregvalue(r1));
        tfrrefreg(r1).set(t);
    }

    /**
     * Fast hardware interrupt (FIRQ).
     * The <em>fast interrupt request</em> is similar to the IRQ, as it is
     * maskable by setting the F bit in the condition code register to 1.
     * When an FIRQ is received, only the PC and condition code register are
     * saved on the hardware stack. The E bit is not set, because the entire
     * machine state has not been saved. The PC for the FIRQ handler is fetched
     * from locations FFF6:FFF7. Both the F and the I bits are set to 1 to
     * prevent any more interrupts.
     *
     * The fast interrupt request executes much more quickly than the NMI
     * or IRQ, because only three bytes are pushed onto the stack. The FIRQ
     * takes ten cycles to execute. The NMI and IRQ require nineteen. The fast
     * interrupt request is very useful when speed is essential, but the
     * registers are not used extensively. If a reqister is used, it must first
     * be pushed and then pulled, before execution of the RTI instruction.
     * The RTI restores the condition code register and the PC of the
     * interrupted program.
     */
    private void firq() {
        if (!waitState) {
            cc.setE(0);
            help_psh(0x81, s, u);
        }
        waitState = false;
        LOGGER.debug("FIRQ received at {}", pc);
        cc.setF(1);
        cc.setI(1);
        pc.set(read_word(FIRQ_ADDR));
    }

    private void help_inc(UByte x) {
        cc.setV(x.intValue() == 0x7f);
        x.set(x.intValue() + 1);
        setBitN(x);
        setBitZ(x);
    }

    /**
     * Hardware interrupt (IRQ).
     * When an IRQ occurs and the I bit is zero, the PC and all the registers
     * (except S) are pushed onto the hardware stack. The PC of the IRQ
     * handler is fetched from memory locations FFF8:FFF9. This process is
     * the same for the NMI. The E bit in the condition register is set to 1,
     * because the entire machine state is saved; the I bit is set to 1 to
     * prevent any more IRQs. It is usually not necessary to be able to handle
     * more than one IRQ at a time. However, the I bit may be cleared by the
     * program and more IRQs accepted if necessary.
     *
     * The IRQ handler is terminated with an RTI instruction. This instruction
     * restores all the registers from the stack and the PC of the interrupted
     * program.
     */
    private void irq() {
        if (cc.isSetI()) {
            return;
        }
        cc.setE(1);
        if (!waitState) {
            help_psh(0xff, s, u);
        }
        waitState = false;
        cc.setI(1);
        pc.set(read_word(IRQ_ADDR));
    }

    private void jmp() {
        pc.set(fetch_effective_address());
    }

    /**
     * Jump to subroutine.
     * Also used for bsr when mode is IMMEDIATE.
     */
    private void jsr() {
        int addr = fetch_effective_address();
        s.add(-1);
        write(s, pc.intValue());
        s.add(-1);
        write(s, pc.intValue() >> 8);
        pc.set(addr);
    }

    private void help_ld(UByte regB) {
        regB.set(fetch_operand());
        setBitN(regB);
        cc.setV(0);
        setBitZ(regB);
    }

    private void help_ld(Word regW) {
        regW.set(fetch_word_operand());
        setBitN(regW);
        cc.setV(0);
        setBitZ(regW);
    }

    private void leas() {
        s.set(fetch_effective_address());
        inhibitNMI = false;
    }

    private void leau() {
        u.set(fetch_effective_address());
    }

    private void leax() {
        x.set(fetch_effective_address());
        setBitZ(x);
    }

    private void leay() {
        y.set(fetch_effective_address());
        setBitZ(y);
    }

    private void help_lsl(UByte regB) {
        cc.setC(regB.btst(7));
        cc.setV(regB.btst(7) ^ regB.btst(6));
        regB.set(regB.intValue() << 1);
        setBitN(regB);
        setBitZ(regB);
    }

    private void help_lsr(UByte byteLoc) {
        cc.setC(byteLoc.btst(0));
        byteLoc.set(byteLoc.intValue() >> 1); // Shift word right
        cc.setN(0);
        setBitZ(byteLoc);
    }

    private void mul() {
        d.set(a.intValue() * b.intValue());
        cc.setC(b.btst(7));
        setBitZ(d);
    }

    private void help_neg(UByte byteLoc) {
        cc.setV(byteLoc.intValue() == 0x80);
        {
            int t = ((~byteLoc.intValue()) & 0xff) + 1;
            byteLoc.set(t & 0xff);
        }

        setBitN(byteLoc);
        setBitZ(byteLoc);
        cc.setC(byteLoc.intValue() != 0);
    }

    /**
     * The Non-Maskable Interrupt (NMI).
     * The non-maskable interrup (NMI) cannot be inhibited by the
     * programmer. It is always accepted by the 6809 upon completion of the
     * current instruction, assuming no bus request was received.
     *
     * The NMI causes the automatic push of the program counter and all
     * other registers (except the S register) onto the hardware stack, S (If an
     * NMI is received during a DMA/BREQ, it will set an internal NMI latch,
     * and be processed at the end of the DMA/BREQ.) A new program counter
     * is loaded from the data in memory locations FFFC and FFFD. The starting
     * address of the NMI handler is stored with the high byte in FFFC and
     * the low byte in FFFD.
     */
    private void nmi() {
        cc.setE(1);
        if (!waitState) {
            help_psh(0xff, s, u);
        }
        waitState = false;
        cc.setF(1);
        cc.setI(1);
        bus.clearNMI();
        pc.set(read_word(NMI_ADDR));
    }

    /**
     * No operation.
     */
    private void nop() {
    }

    private void help_or(UByte byteLoc) {
        byteLoc.set(byteLoc.intValue() | fetch_operand());
        cc.setV(0);
        setBitN(byteLoc);
        setBitZ(byteLoc);
    }

    private void orcc() {
        cc.set(cc.intValue() | fetch_operand());
    }

    private void pshs() {
        help_psh(fetch(), s, u);
    }

    private void pshu() {
        help_psh(fetch(), u, s);
    }

    private void help_psh(int w, Word s, Word u) {
        if (bittst(w, 7)) {
            s.add(-1);
            write(s, pc.intValue());
            s.add(-1);
            write(s, (pc.intValue() >> 8));
        }
        if (bittst(w, 6)) {
            s.add(-1);
            write(s, u.intValue());
            s.add(-1);
            write(s, (u.intValue() >> 8));
        }
        if (bittst(w, 5)) {
            s.add(-1);
            write(s, y.intValue());
            s.add(-1);
            write(s, (y.intValue() >> 8));
        }
        if (bittst(w, 4)) {
            s.add(-1);
            write(s, x.intValue());
            s.add(-1);
            write(s, (x.intValue() >> 8));
        }
        if (bittst(w, 3)) {
            s.add(-1);
            write(s, dp.intValue());
        }
        if (bittst(w, 2)) {
            s.add(-1);
            write(s, b.intValue());
        }
        if (bittst(w, 1)) {
            s.add(-1);
            write(s, a.intValue());
        }
        if (bittst(w, 0)) {
            s.add(-1);
            write(s, cc.intValue());
        }
    }

    /**
     * PULS: Pull Registers from System Stack.
     * The stack grows downwards, and this means that when you PULL, the
     * stack pointer is increased.
     */
    private void puls() {
        int w = fetch();
        help_pul(w, s, u);
    }

    /**
     * PULU: Pull Registers from User Stack.
     */
    private void pulu() {
        int w = fetch();
        help_pul(w, u, s);
        inhibitNMI = false;
    }

    private void help_pul(int w, Word s, Word u) {
        if (bittst(w, 0)) {
            cc.set(read(s));
            s.add(1);
        }
        if (bittst(w, 1)) {
            a.set(read(s));
            s.add(1);
        }
        if (bittst(w, 2)) {
            b.set(read(s));
            s.add(1);
        }
        if (bittst(w, 3)) {
            dp.set(read(s));
            s.add(1);
        }
        if (bittst(w, 4)) {
            x.set(read_word(s));
            s.add(2);
        }
        if (bittst(w, 5)) {
            y.set(read_word(s));
            s.add(2);
        }
        if (bittst(w, 6)) {
            u.set(read_word(s));
            s.add(2);
        }
        if (bittst(w, 7)) {
            pc.set(read_word(s));
            s.add(2);
        }
    }

    private void help_rol(UByte byteLoc) {
        boolean oc = cc.isSetC();
        cc.setV(byteLoc.btst(7) ^ byteLoc.btst(6));
        cc.setC(byteLoc.btst(7));
        byteLoc.set(byteLoc.intValue() << 1);
        if (oc) {
            byteLoc.bset(0);
        }
        setBitN(byteLoc);
        setBitZ(byteLoc);
    }

    private void help_ror(UByte regB) {
        boolean oc = cc.isSetC();
        cc.setC(regB.btst(0));
        regB.set(regB.intValue() >> 1);
        if (oc) {
            regB.bset(7);
        }
        setBitN(regB);
        setBitZ(regB);
    }

    private void rti() {
        help_pul(0x01, s, u);
        if (cc.isSetE()) {
            help_pul(0xfe, s, u);
        } else {
            help_pul(0x80, s, u);
        }
    }

    private void rts() {
        pc.set(read_word(s));
        s.add(2);
    }

    /**
     * Subtract with carry.
     * The half-carry (V) is undefined after this operation.
     */
    private void help_sbc(UByte regB) {
        int m = fetch_operand();
        int t = regB.intValue() - m - cc.getC();

        cc.setH(((t & 0x0f) < (m & 0x0f))); // half-carry
        cc.setV(bittst(regB.intValue() ^ m ^ t ^ (t >> 1), 7));
        cc.setC(bittst(t, 8));
        t = t & 0xFF;
        cc.setN(bittst(t, 7));
        cc.setZ(t == 0);
        regB.set(t);
    }

    /**
     * Sign extend.
     */
    private void sex() {
        setBitN(b);
        a.set(cc.isSetN() ? 255 : 0);
        setBitZ(a);
    }

    /**
     * Store byte in memory.
     */
    private void help_st(UByte data) {
        int addr = fetch_effective_address();
        write(addr, data);
        cc.setV(0);
        setBitN(data);
        setBitZ(data);
    }

    /**
     * Store word in memory.
     */
    private void help_st(Word dataW) {
        int addr = fetch_effective_address();
        write_word(addr, dataW.intValue());
        cc.setV(0);
        setBitN(dataW);
        setBitZ(dataW);
    }

    private void help_sub(UByte byteLoc) {
        int m = fetch_operand();
        int t = byteLoc.intValue() - m;

        int carryIn = (byteLoc.intValue() & 0x7f) - (m & 0x7f);
        cc.setV(bittst(carryIn, 7));      // Bit 7 carry in
        //cc.setV(bittst(byteLoc.intValue() ^ m ^ t ^ (t >> 1), 7));
        cc.setC(bittst(t, 8));
        cc.setV(cc.getV() != cc.getC());
        cc.setN(bittst(t, 7));
        cc.setZ(t == 0);
        byteLoc.set(t);
    }

    private void subd() {
        int m = fetch_word_operand();
        int t = d.intValue() - m;

        int carryIn = (d.intValue() & 0x7fff) - (m & 0x7fff);
        cc.setV(bittst(carryIn, 15));      // Bit 15 carry in
        //cc.setV(bittst(d.intValue() ^ m ^ t ^ (t >> 1), 15));
        cc.setC(bittst(t, 16));
        cc.setV(cc.getV() != cc.getC());
        cc.setN(bittst(t, 15));
        cc.setZ(t == 0);
        d.set(t);
    }

    /**
     * Software interrupt.
     * The entire machine state is pushed onto the hardware stack.
     * Program control is transferred via the software interrupt 1 vector.
     * Fast and normal interrupts are disabled.
     */
    protected void swi() {
        cc.setE(1);
        help_psh(0xff, s, u);
        cc.setF(1);
        cc.setI(1);
        pc.set(read_word(SWI_ADDR));
    }

    /**
     * Software interrupt 2.
     * The entire machine state is pushed onto the hardware stack.
     * Program control is transferred via the software interrupt 2 vector.
     * The F and I interrupt masks are not affected.
     */
    protected void swi2() {
        cc.setE(1);
        help_psh(0xff, s, u);
        pc.set(read_word(SWI2_ADDR));
    }

    /**
     * Software interrupt 3.
     * The entire machine state is pushed onto the hardware stack.
     * Program control is transferred via the software interrupt 3 vector.
     * The F and I interrupt masks are not affected.
     */
    protected void swi3() {
        cc.setE(1);
        help_psh(0xff, s, u);
        pc.set(read_word(SWI3_ADDR));
    }

    private void tfr() {
        int w = fetch();
        int r1 = (w & 0xf0) >> 4;
        int r2 = (w & 0x0f) >> 0;
        tfrrefreg(r2).set(refregvalue(r1));
    }

    private void help_tst(UByte dataB) {
        cc.setV(0);
        setBitN(dataB);
        setBitZ(dataB);
    }

    private void do_br(boolean test) {
        int offset = extend8(fetch_operand());
        if (test) {
            pc.add(offset);
        }
    }

    private void do_lbr(boolean test) {
        int offset = fetch_word_operand();
        if (test) {
            pc.add(offset);
        }
    }

    /**
     * Treat a memory location as a register.
     */
    private class MemoryProxy extends UByte {

        public static final int MAX = 0xff;

        private int addr;

        /**
         * Constructor.
         */
        public MemoryProxy() {
            addr = 0;
        }

        /**
         * Constructor.
         * @param name Name of register for debugging
         */
        public MemoryProxy(String name) {
            addr = 0;
        }

        /**
         * Constructor.
         * @param i Initial addr
         */
        public MemoryProxy(int i) {
            addr = i;
        }

        public MemoryProxy fetch() {
            addr = fetch_effective_address();
            return this;
        }

        @Override
        public int get() {
            return intValue();
        }

        @Override
        public int intValue() {
            return read(addr) & 0xff;
        }

        /**
         * Write the value through to the memory location.
         */
        @Override
        public void set(int newValue) {
            write(addr, newValue & MAX);
        }

        @Override
        public int getSigned() {
            int value = read(addr);
            if (value < 0x80) {
                return value;
            } else {
                return -((~value & 0x7f) + 1);
            }
        }

        @Override
        public int getWidth() {
            return 8;
        }

//      public void add(int x) {
//          int value = read(addr);
//          value += x;
//          write(addr, value & MAX);
//      }

        @Override
        public String toString() {
            return "Location=" + Integer.toHexString(addr);
        }

        /**
         * Bit test.
         */
        @Override
        public int btst(int n) {
            return ((read(addr) & (1 << n)) != 0) ? 1 : 0;
        }

        @Override
        public void bset(int n) {
            int value = read(addr);
            write(addr, value |= (1 << n));
        }

        @Override
        public void bclr(int n) {
            int value = read(addr);
            write(addr, value & ~(1 << n));
        }

    }


}
