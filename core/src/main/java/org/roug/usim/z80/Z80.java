package org.roug.usim.z80;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.roug.usim.Bus8Intel;
import org.roug.usim.MemorySegment;
import org.roug.usim.RandomAccessMemory;
import org.roug.usim.Register;
import org.roug.usim.RegisterBytePair;
import org.roug.usim.RegisterIndirect;
import org.roug.usim.UByte;
import org.roug.usim.USimIntel;
import org.roug.usim.Word;

/**
 * Implementation of the Zilog Z80 CPU.
 */
public class Z80 extends USimIntel {

    /* LSB, MSB masking values */
    final static int LSB = 0x00FF;
    final static int MSB = 0xFF00;
    final static int LSW = 0x0000FFFF;

    public static final int NMI_ADDR = 0x0066;
    public static final int RESET_ADDR = 0x0000;
    public static final int RST_56 = 0x0038;

    private static final int IMMEDIATE = 0;
    private static final int RELATIVE = 0;
    private static final int INHERENT = 1;
    private static final int EXTENDED = 2;
    private static final int DIRECT = 3;
    private static final int INDEXED = 4;

    /** Addressing mode. */
    private int interruptMode;

    /** Set to true to disassemble executed instruction. */
    private boolean traceInstructions = false;

    /**  Interrupt enable flip-flop. */
    private boolean iff1 = false;
    /** Temporary storage location for IFF1. */
    private boolean iff2 = false;

    /** Stack Pointer register. */
    public final Word registerSP = new Word("SP");
    /** Index register X. */
    public final Word registerIX = new Word("IX");
    /** Index register Y. */
    public final Word registerIY = new Word("IY");

    /** Accumulator A. */
    public final UByte registerA = new UByte("A");
    /** Flag register #1. */
    public final FlagRegister registerF = new FlagRegister();
    /** Accumulator B. */
    public final UByte registerB = new UByte("B");
    /** Accumulator C. */
    public final UByte registerC = new UByte("C");
    /** Accumulator D. */
    public final UByte registerD = new UByte("D");
    /** Accumulator E. */
    public final UByte registerE = new UByte("E");
    /** Accumulator H. */
    public final UByte registerH = new UByte("H");
    /** Accumulator L. */
    public final UByte registerL = new UByte("L");

    /* Alternate registers */
    /** Accumulator A'. */
    public final UByte registerA_ = new UByte("A'");
    /** Flag register #2. */
    public final FlagRegister registerF_ = new FlagRegister();
    /** Accumulator B. */
    public final UByte registerB_ = new UByte("B'");
    /** Accumulator C. */
    public final UByte registerC_ = new UByte("C'");
    /** Accumulator D. */
    public final UByte registerD_ = new UByte("D'");
    /** Accumulator E. */
    public final UByte registerE_ = new UByte("E'");
    /** Accumulator H. */
    public final UByte registerH_ = new UByte("H'");
    /** Accumulator L. */
    public final UByte registerL_ = new UByte("L'");

    /** Interrupt Page Address (I) Register. */
    public final UByte registerI = new UByte("I");

    /** Memory Refresh (R) Register. */
    public final UByte registerR = new UByte("R");

    /** Accumulator AF. Combined from A and F. */
    public final RegisterBytePair registerAF = new RegisterBytePair("AF", registerA, registerF);

    /** Accumulator BC. Combined from B and C. */
    public final RegisterBytePair registerBC = new RegisterBytePair("BC", registerB, registerC);

    /** Accumulator DE. Combined from D and E. */
    public final RegisterBytePair registerDE = new RegisterBytePair("DE", registerD, registerE);

    /** Accumulator HL. Combined from H and L. */
    public final RegisterBytePair registerHL = new RegisterBytePair("HL", registerH, registerL);

    /** Accumulator AF'. Combined from A' and F'. */
    public final RegisterBytePair registerAF_ = new RegisterBytePair("AF'", registerA_, registerF_);

    /** Accumulator BC'. Combined from B' and C'. */
    public final RegisterBytePair registerBC_ = new RegisterBytePair("BC'", registerB_, registerC_);

    /** Accumulator DE'. Combined from D' and E'. */
    public final RegisterBytePair registerDE_ = new RegisterBytePair("DE'", registerD_, registerE_);

    /** Accumulator HL'. Combined from H' and L'. */
    public final RegisterBytePair registerHL_ = new RegisterBytePair("HL'", registerH_, registerL_);

    final RegisterIndirect indirectBC = new RegisterIndirect("BCind", this, registerBC);

    final RegisterIndirect indirectDE = new RegisterIndirect("DEind", this, registerDE);

    final RegisterIndirect indirectHL = new RegisterIndirect("HLind", this, registerHL);

    /** Prevent NMI handling. */
    private boolean inhibitNMI;

    /** RESET signalled. */
    private volatile boolean resetSignal;

    /** CWAI active? */
    private boolean waitState = false;

    private static final Logger LOGGER = LoggerFactory.getLogger(Z80.class);

    /** The bus the CPU is connected to. */
    private Bus8Intel bus;

    /**
     * Do we have active IRQs and we're accepting IRQs?
     */
    private boolean isINTActive() {
        return iff1 && bus.isIRQActive();
    }

    /**
     * Do we have active NMIs and we're accepting NMIs?
     */
    private boolean isNMIActive() {
        return false;
    }

    /**
     * Create CPU, and a simple bus it is attached to.
     */
    public Z80() {
        super(new BusZ80());
        bus = (Bus8Intel) super.getBus();
        reset();
    }

    /**
     * Constructor: Assigned bus.
     *
     * @param bus the memory bus the CPU is attached to
     */
    public Z80(Bus8Intel bus) {
        super(bus);
        this.bus = bus;
        reset();
    }


    /**
     * Get the memory bus.
     */
    public Bus8Intel getBus() {
        return bus;
    }

    /**
     * Constructor: Allocate memory starting from address 0.
     *
     * @param memorySize - amount of memory to allocate
     */
    public Z80(int memorySize) {
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
        interruptMode = 0;
        iff1 = false;
        iff2 = false;
        pc.set(0);
        registerI.set(0);
        registerR.set(0);
    }

    /**
     * Print out status.
     */
    public void status() {
        LOGGER.debug("PC:{} A:{} B:{}", pc, registerA, registerB);
    }

    /**
     * Execute one instruction.
     */
    public void execute() {
        if (resetSignal) {
            reset();
        }
        ir = fetch();

        switch (ir & 0xC0) {
            case 0x00:
               execute00(); break;
            case 0x40:
               execute40(); break;
            case 0x80:
               execute80(); break;
            case 0xC0:
               executeC0(); break;
        }

        if (isINTActive()) {
            irq();
        }

    }

    /* Opcodes between 0x00 and 0x3F */
    private void execute00() {
        switch (ir) {
            case 0x00: // NOP
                break;
            case 0x01:
                registerBC.set(fetch_word());
                break;
            case 0x02:
                write(registerBC.get(), registerA.get());
                break;
            case 0x07:
                registerF.setC(registerA.get() == 0x80);
                registerA.set((registerA.get() << 1) + registerF.getC());
                registerF.setH(false);
                registerF.setN(false);
                break;
            case 0x08: {
                int regTmp = registerAF.get();
                registerAF.set(registerAF_.get());
                registerAF_.set(regTmp);
                }
                break;
            case 0x0A:
                registerA.set(read(registerBC.get()));
                break;
            case 0x11:
                registerDE.set(fetch_word());
                break;
            case 0x12:
                write(registerDE.get(), registerA.get());
                break;
            case 0x17:
                int prevC = registerF.getC();
                registerF.setC(registerA.get() == 0x80);
                registerA.set((registerA.get() << 1) + prevC);
                registerF.setH(false);
                registerF.setN(false);
                break;
            case 0x1A:
                registerA.set(read(registerDE.get()));
                break;

            case 0x21:
                registerHL.set(fetch_word());
                break;
            case 0x22:
                write_word(fetch_word(), registerHL.get());
                break;
            case 0x2A:
                registerHL.set(read_word(fetch_word()));
                break;
            case 0x2F:
                cpl(); break;
            case 0x31:
                registerSP.set(fetch_word());
                break;
            case 0x32:
                write(fetch_word(),registerA.get());
                break;
            case 0x36:
                indirectHL.set(fetch());
                break;
            case 0x3A:
                registerA.set(read(fetch_word()));
                break;
            default:
                invalid("instruction"); break;
        }
    }

    /* Opcodes between 0x40 and 0x7F */
    private void execute40() {
        switch (ir) {
            case 0x40: registerB.set(registerB.get()); break;
            case 0x41: registerB.set(registerC.get()); break;
            case 0x42: registerB.set(registerD.get()); break;
            case 0x43: registerB.set(registerE.get()); break;
            case 0x44: registerB.set(registerH.get()); break;
            case 0x45: registerB.set(registerL.get()); break;
            case 0x46: registerB.set(indirectHL.get()); break;
            case 0x47: registerB.set(registerA.get()); break;

            case 0x48: registerC.set(registerB.get()); break;
            case 0x49: registerC.set(registerC.get()); break;
            case 0x4A: registerC.set(registerD.get()); break;
            case 0x4B: registerC.set(registerE.get()); break;
            case 0x4C: registerC.set(registerH.get()); break;
            case 0x4D: registerC.set(registerL.get()); break;
            case 0x4E: registerC.set(indirectHL.get()); break;
            case 0x4F: registerC.set(registerA.get()); break;

            case 0x50: registerD.set(registerB.get()); break;
            case 0x51: registerD.set(registerC.get()); break;
            case 0x52: registerD.set(registerD.get()); break;
            case 0x53: registerD.set(registerE.get()); break;
            case 0x54: registerD.set(registerH.get()); break;
            case 0x55: registerD.set(registerL.get()); break;
            case 0x56: registerD.set(indirectHL.get()); break;
            case 0x57: registerD.set(registerA.get()); break;

            case 0x58: registerE.set(registerB.get()); break;
            case 0x59: registerE.set(registerC.get()); break;
            case 0x5A: registerE.set(registerD.get()); break;
            case 0x5B: registerE.set(registerE.get()); break;
            case 0x5C: registerE.set(registerH.get()); break;
            case 0x5D: registerE.set(registerL.get()); break;
            case 0x5E: registerE.set(indirectHL.get()); break;
            case 0x5F: registerE.set(registerA.get()); break;

            case 0x60: registerH.set(registerB.get()); break;
            case 0x61: registerH.set(registerC.get()); break;
            case 0x62: registerH.set(registerD.get()); break;
            case 0x63: registerH.set(registerE.get()); break;
            case 0x64: registerH.set(registerH.get()); break;
            case 0x65: registerH.set(registerL.get()); break;
            case 0x66: registerH.set(indirectHL.get()); break;
            case 0x67: registerH.set(registerA.get()); break;

            case 0x68: registerL.set(registerB.get()); break;
            case 0x69: registerL.set(registerC.get()); break;
            case 0x6A: registerL.set(registerD.get()); break;
            case 0x6B: registerL.set(registerE.get()); break;
            case 0x6C: registerL.set(registerH.get()); break;
            case 0x6D: registerL.set(registerL.get()); break;
            case 0x6E: registerL.set(indirectHL.get()); break;
            case 0x6F: registerL.set(registerA.get()); break;

            case 0x70: indirectHL.set(registerB.get()); break;
            case 0x71: indirectHL.set(registerC.get()); break;
            case 0x72: indirectHL.set(registerD.get()); break;
            case 0x73: indirectHL.set(registerE.get()); break;
            case 0x74: indirectHL.set(registerH.get()); break;
            case 0x75: indirectHL.set(registerL.get()); break;
            case 0x76:
                halt(); break;
            case 0x77: indirectHL.set(registerA.get()); break;

            case 0x78: registerA.set(registerB.get()); break;
            case 0x79: registerA.set(registerC.get()); break;
            case 0x7A: registerA.set(registerD.get()); break;
            case 0x7B: registerA.set(registerE.get()); break;
            case 0x7C: registerA.set(registerH.get()); break;
            case 0x7D: registerA.set(registerL.get()); break;
            case 0x7E: registerA.set(indirectHL.get()); break;
            case 0x7F: registerA.set(registerA.get()); break;
            default:
                invalid("instruction"); break;
        }
    }

    /**
     * LD operation. The two registers are defined in the lower 6 bits of the
     * IR.
     * Alternative to large switch in execute40
     * TODO: Implement
     */
    private void ldRegFromReg() {
        Register regTo = getRegister((ir & 0x38) >> 3);
        Register regFrom = getRegister(ir & 0x07);
        regTo.set(regFrom.get());
    }


    /* Opcodes between 0x80 and 0xBF */
    private void execute80() {
        switch (ir & 0x07) {
            case 0x80:
                addAR(); break;
            default:
                invalid("instruction"); break;
        }
    }

    /* Opcodes between 0xC0 and 0xFF */
    private void executeC0() {
        switch (ir) {
            case 0xC5:
                helpPushExt(registerBC); break;
            case 0xCD: {
                int newLoc = fetch_word();
                helpPushExt(pc);
                pc.set(newLoc);
                }
                break;
            case 0xD3:
                outNA(); break;
            case 0xD5:
                helpPushExt(registerDE); break;
            case 0xD9:
                exx(); break;
            case 0xDD:
                executeDDorFD(registerIX); break;
            case 0xE3: {
                int regTmp = registerHL.get();
                registerHL.set(read_word(registerSP.get()));
                write_word(registerSP.get(), regTmp);
                }
                break;
            case 0xE5:
                helpPushExt(registerHL); break;
            case 0xEB: {
                int regTmp = registerDE.get();
                registerDE.set(registerHL.get());
                registerHL.set(regTmp);
                }
                break;
            case 0xED:
                executeED(); break;
            case 0xF3:
                iff1 = false; iff2 = false; break;
            case 0xF5:
                helpPushExt(registerAF); break;
            case 0xF9:
                registerSP.set(registerHL.get()); break;
            case 0xFB:
                iff1 = true; iff2 = true; break;
            case 0xFD:
                executeDDorFD(registerIY); break;
            default:
                invalid("instruction"); break;
        }
    }

    /**
     * Execute one extended (0xDD or 0xFD) instruction.
     */
    private void executeDDorFD(Word regTarget) {
        ir = fetch();

        switch (ir) {
            case 0x19:
                regTarget.set(registerDE.get()); break; //TODO verify
            case 0x21:
                regTarget.set(fetch_word()); break;
            case 0x22:
                write_word(fetch_word(), regTarget.get()); break;
            case 0x23:
                regTarget.add(1); break;
            case 0x24: break;  //TODO implement
            case 0x25: break;  //TODO implement
            case 0x26: break;  //TODO implement
            case 0x29: break;  //TODO implement
            case 0x2A:
                regTarget.set(read_word(fetch_word()));
                break;
            case 0x2B:
                regTarget.add(-1); break;
            case 0x2C: break;  //TODO implement
            case 0x2D: break;  //TODO implement
            case 0x2E: break;  //TODO implement
            case 0x34: break;  //TODO implement
            case 0x35: break;  //TODO implement
            case 0x36: write(registerIX.get() + getIndexOffset(), fetch());
                break;

            case 0x40: registerB.set(registerB.get()); break;  // Noop
            case 0x41: registerB.set(registerC.get()); break;  //TODO verify
            case 0x42: registerB.set(registerD.get()); break;  //TODO verify
            case 0x43: registerB.set(registerE.get()); break;  //TODO verify
            case 0x44: registerB.set(getIndexAddressUndocumented(regTarget, 0x04)); break;  //TODO verify
            case 0x45: registerB.set(getIndexAddressUndocumented(regTarget, 0x05)); break;  //TODO verify
            case 0x46: registerB.set(get8BitRegisterIndexed(regTarget, 0x06)); break; //TODO verify
            case 0x47: registerB.set(registerA.get()); break;  //TODO verify
            case 0x48: registerC.set(registerB.get()); break;  //TODO verify
            case 0x49: registerC.set(registerC.get()); break;  // Noop
            case 0x4A: registerC.set(registerD.get()); break;  //TODO verify
            case 0x4B: registerC.set(registerE.get()); break;  //TODO verify
            case 0x4C: registerC.set(getIndexAddressUndocumented(regTarget, 0x04)); break;  //TODO verify
            case 0x4D: registerC.set(getIndexAddressUndocumented(regTarget, 0x05)); break;  //TODO verify
            case 0x4E: registerC.set(get8BitRegisterIndexed(regTarget, 0x06)); break; //TODO verify
            case 0x4F: registerC.set(registerA.get()); break;  //TODO verify

            case 0x50: registerD.set(registerB.get()); break;  // Noop
            case 0x51: registerD.set(registerC.get()); break;  //TODO verify
            case 0x52: registerD.set(registerD.get()); break;  //TODO verify
            case 0x53: registerD.set(registerE.get()); break;  //TODO verify
            case 0x54: registerD.set(getIndexAddressUndocumented(regTarget, 0x04)); break;  //TODO verify
            case 0x55: registerD.set(getIndexAddressUndocumented(regTarget, 0x05)); break;  //TODO verify
            case 0x56: registerD.set(get8BitRegisterIndexed(regTarget, 0x06)); break; //TODO verify
            case 0x57: registerD.set(registerA.get()); break;  //TODO verify
            case 0x58: registerE.set(registerB.get()); break;  //TODO verify
            case 0x59: registerE.set(registerC.get()); break;  // Noop
            case 0x5A: registerE.set(registerD.get()); break;  //TODO verify
            case 0x5B: registerE.set(registerE.get()); break;  //TODO verify
            case 0x5C: registerE.set(getIndexAddressUndocumented(regTarget, 0x04)); break;  //TODO verify
            case 0x5D: registerE.set(getIndexAddressUndocumented(regTarget, 0x05)); break;  //TODO verify
            case 0x5E: registerE.set(get8BitRegisterIndexed(regTarget, 0x06)); break; //TODO verify
            case 0x5F: registerE.set(registerA.get()); break;  //TODO verify

            case 0xE3: { // EX (SP), IX
                int regTmp = regTarget.get();
                regTarget.set(read_word(registerSP.get()));
                write_word(registerSP.get(), regTmp);
                }
                break;
            case 0xE5:
                helpPushExt(regTarget); break;
            case 0xE9:
                pc.set(regTarget.get()); break;
            case 0xF9:
                registerSP.set(regTarget.get()); break;
            default:
                invalid("instruction"); break;
        }
    }

    /**
     * Execute one extended (0xED) instruction.
     */
    private void executeED() {
        ir = fetch();

        switch (ir) {
            case 0x43:
                write_word(fetch_word(), registerBC.get()); break;
            case 0x44:
                neg(); break;
            case 0x46:
                interruptMode = 0; break;
            case 0x4F:
                registerR.set(registerA.get()); break;
            case 0x53:
                write_word(fetch_word(), registerDE.get()); break;
            case 0x56:
                interruptMode = 1; break;
            case 0x57:
                helpLdFromReg(registerA, registerI); break;
            case 0x5E:
                interruptMode = 2; break;
            case 0x5F:
                helpLdFromReg(registerA, registerR); break;

            case 0x63:
                write_word(fetch_word(), registerHL.get()); break;

            case 0x73:
                write_word(fetch_word(), registerSP.get()); break;

            case 0xA0: // LDI
                helpLDI();
                break;
            case 0xA8: // LDD
                helpLDD();
                break;

            case 0xB0: // LDIR
                do {
                    helpLDI();
                } while (registerBC.get() != 0);
                break;
            case 0xB8: // LDDR
                do {
                    helpLDD();
                } while (registerBC.get() != 0);
                break;
            default:
                invalid("instruction"); break;
        }
    }

    /**
     * Get the index value, make signed as its two's compliment.
     *
     * @return The index register offset value in the range -128..+127
     */
    private int getIndexOffset() {
        int index = fetch();
        if (index > 0x007f)
            return (index - 256);
        else
            return index;
    }

    private int getIndexAddress(Word activeReg) {
        return (activeReg.get() + getIndexOffset()) & LSW;
    }

    /*
     * Support for 8 bit index register manipulation (IX as IXH IXL)
     */
    private int getIndexAddressUndocumented(Word activeReg, int reg) {
        switch (reg) {
            case 4: {
                return ((activeReg.get() & MSB) >> 8);
            } // IXH
            case 5: {
                return (activeReg.get() & LSB);
            } // IXL
            default: {
                registerR.add(1);
                return read((activeReg.get() + getIndexOffset()) & LSW);
            } // (index+dd)
        }
    }

    /*
     * return an 8 bit register based on its code 000 -> 111
     */
    private int get8BitRegisterIndexed(Word activeReg, int reg) {
        switch (reg) {
            case 4: {
                return registerH.get();
            } // H
            case 5: {
                return registerL.get();
            } // L
            case 7: {
                return registerA.get();
            } // A
            default: {
                registerR.add(1);
                return read(getIndexAddress(activeReg));
            } // (index+dd)
        }
    }

    /**
     * Handle interrupt.
     */
    private void irq() {
        iff1 = false;
        iff2 = false;

    }

    private static int getSignedWord(int value) {
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
        }
    }


    private boolean btst(int x, int n) {
        return (x & (1 << n)) != 0;
    }

    private void setBitZ(Register ref) {
    }

    /**
     * Set CC bit N if value is negative.
     */
    private void setBitN(Register ref) {
    }

    /**
     * Push a word register on stack.
     */
    private void helpPushExt(Word reg) {
        registerSP.add(-2);
        write_word(registerSP.get(), reg.get());
    }

    /**
     * Load one register into another with flag operations.
     */
    private void helpLdFromReg(UByte regTo, UByte regFrom) {
        registerF.setS(regFrom.get() > 0x7F);
        registerF.setZ(regFrom.get() == 0);
        registerF.setH(false);
        registerF.setPV(iff2);
        registerF.setN(false);
        regTo.set(regFrom.get());
    }

    /* Block move increment */
    private void helpLDI() {
        indirectDE.set(indirectHL.get());
        registerDE.add(1);
        registerHL.add(1);
        registerBC.add(-1);
        registerF.setPV(registerBC.get() == 0x00);
        registerF.setH(false);
        registerF.setN(false);
    }

    /* Block move decrement */
    private void helpLDD() {
        indirectDE.set(indirectHL.get());
        registerDE.add(-1);
        registerHL.add(-1);
        registerBC.add(-1);
        registerF.setPV(registerBC.get() == 0x00);
        registerF.setH(false);
        registerF.setN(false);
    }


    /**
     * Complement accumulator.
     */
    private void cpl() {
        registerA.set(~registerA.intValue());
        registerF.setH(true);
        registerF.setN(true);
    }

    /**
     * Negate accumulator - 2's complement.
     */
    private void neg() {
        registerF.setPV(registerA.get() == 0x80);
        registerF.setC(registerA.get() == 0x00);
        registerA.set(0 - registerA.intValue());
        registerF.setS(registerA.get() > 0x7F);
        registerF.setZ(registerA.get() == 0);
        registerF.setH(true);
        registerF.setN(true);
    }

    /**
     * Each 2-byte value in register pairs BC, DE, and HL is exchanged with
     * the 2-byte value in BC', DE', and HL', respectively.
     */
    private void exx() {
        int tmp = registerBC.get();
        registerBC.set(registerBC_.get());
        registerBC_.set(tmp);
        tmp = registerDE.get();
        registerDE.set(registerDE_.get());
        registerDE_.set(tmp);
        tmp = registerHL.get();
        registerHL.set(registerHL_.get());
        registerHL_.set(tmp);
    }

    /**
     * Halt CPU.
     * When a software HALT instruction is executed, the CPU executes NOPs until an interrupt
     * is received (either a nonmaskable or a maskable interrupt while the interrupt flip-flop is
     * enabled).
     */
    private void halt() {
        try {
            synchronized(bus) {
                while(!(bus.isIRQActive() || bus.isNMIActive() )) {
                    bus.wait();
                }
            }
        } catch (InterruptedException e) {
            LOGGER.error("Wait interrupted");
        }
    }

    /**
     * OUT (n), A.
     * The operand n is placed on the bottom half (A0 through A7) of the
     * address bus to select the I/O device at one of 256 possible ports. The
     * contents of the Accumulator (Register A) also appear on the top half
     * (A8 through A15) of the address bus at this time. Then the byte
     * contained in the Accumulator is placed on the data bus and written to
     * the selected peripheral device.
     * TODO: Implement
     */
    private void outNA() {
        int n = fetch();
        bus.writeIO(n, registerA.intValue());
    }

    private Register getRegister(int r) {
        switch (r) {
            case 0x00: return registerB;
            case 0x01: return registerC;
            case 0x02: return registerD;
            case 0x03: return registerE;
            case 0x04: return registerH;
            case 0x05: return registerL;
            case 0x06: return indirectHL;
            case 0x07: return registerA;
            default: invalid("register"); return null;
        }
    }

    /**
     * ADD A, r.
     * The contents of register r are added to the contents of the Accumulator.
     * TODO: Implement
     */
    private void addAR() {
        Register regFrom = getRegister(ir & 0x07);
        registerA.add(regFrom.get());
    }

}
