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
import org.roug.usim.WordLSB;
import org.roug.usim.WordMSB;
import static org.roug.usim.BitOperations.*;

/**
 * Implementation of the Zilog Z80 CPU.
 * INCOMPLETE!
 */
public class Z80 extends USimIntel {

    /* LSB, MSB masking values */
    final static int LSB = 0x00FF;
    final static int MSB = 0xFF00;
//     final static int LSW = 0x0000FFFF;

    public static final int NMI_ADDR = 0x0066;
    public static final int MODE0_ADDR = 0x0038;

    /** Addressing mode. */
    private int interruptMode;

    /**  Interrupt enable flip-flop. */
    private boolean iff1 = false;
    /** Temporary storage location for IFF1. */
    private boolean iff2 = false;

    /** Stack Pointer register. */
    final Word registerSP = new Word("SP");
    /** Index register X. */
    final Word registerIX = new Word("IX");
    /** Index register Y. */
    final Word registerIY = new Word("IY");

    /** Accumulator A. */
    final UByte registerA = new UByte("A");
    /** Flag register #1. */
    final FlagRegister registerF = new FlagRegister();
    /** Accumulator B. */
    final UByte registerB = new UByte("B");
    /** Accumulator C. */
    final UByte registerC = new UByte("C");
    /** Accumulator D. */
    final UByte registerD = new UByte("D");
    /** Accumulator E. */
    final UByte registerE = new UByte("E");
    /** Accumulator H. */
    final UByte registerH = new UByte("H");
    /** Accumulator L. */
    final UByte registerL = new UByte("L");

    /* Alternate registers */
    /** Accumulator A'. */
    final UByte registerA_ = new UByte("A'");
    /** Flag register #2. */
    final FlagRegister registerF_ = new FlagRegister();
    /** Accumulator B. */
    final UByte registerB_ = new UByte("B'");
    /** Accumulator C. */
    final UByte registerC_ = new UByte("C'");
    /** Accumulator D. */
    final UByte registerD_ = new UByte("D'");
    /** Accumulator E. */
    final UByte registerE_ = new UByte("E'");
    /** Accumulator H. */
    final UByte registerH_ = new UByte("H'");
    /** Accumulator L. */
    final UByte registerL_ = new UByte("L'");

    /** Interrupt Page Address (I) Register. */
    final UByte registerI = new UByte("I");

    /** Memory Refresh (R) Register. */
    private int registerR;
    /** Bit 7 of registerR. Only the bits 0-6 are used for counting. */
    private int registerRb7;

    /** Accumulator AF. Combined from A and F. */
    final RegisterBytePair registerAF = new RegisterBytePair("AF", registerA, registerF);

    /** Accumulator BC. Combined from B and C. */
    final RegisterBytePair registerBC = new RegisterBytePair("BC", registerB, registerC);

    /** Accumulator DE. Combined from D and E. */
    final RegisterBytePair registerDE = new RegisterBytePair("DE", registerD, registerE);

    /** Accumulator HL. Combined from H and L. */
    final RegisterBytePair registerHL = new RegisterBytePair("HL", registerH, registerL);

    /** Accumulator AF'. Combined from A' and F'. */
    final RegisterBytePair registerAF_ =
                        new RegisterBytePair("AF'", registerA_, registerF_);

    /** Accumulator BC'. Combined from B' and C'. */
    final RegisterBytePair registerBC_ =
                        new RegisterBytePair("BC'", registerB_, registerC_);

    /** Accumulator DE'. Combined from D' and E'. */
    final RegisterBytePair registerDE_ =
                        new RegisterBytePair("DE'", registerD_, registerE_);

    /** Accumulator HL'. Combined from H' and L'. */
    final RegisterBytePair registerHL_ =
                        new RegisterBytePair("HL'", registerH_, registerL_);

    final RegisterIndirect indirectBC = new RegisterIndirect("BCind", this, registerBC);

    final RegisterIndirect indirectDE = new RegisterIndirect("DEind", this, registerDE);

    final RegisterIndirect indirectHL = new RegisterIndirect("HLind", this, registerHL);

    /** Least significant byte of register IX. Used in undocumented ops. */
    final WordLSB registerIXlsb = new WordLSB("IXlsb", registerIX);

    /** Most significant byte of register IY. Used in undocumented ops. */
    final WordMSB registerIXmsb = new WordMSB("IXmsb", registerIX);

    final RegisterDisplaced displacedIX = new RegisterDisplaced("IXdisp", this, registerIX);

    /** Least significant byte of register IY. Used in undocumented ops. */
    final WordLSB registerIYlsb = new WordLSB("IYlsb", registerIY);

    /** Most significant byte of register IY. Used in undocumented ops. */
    final WordMSB registerIYmsb = new WordMSB("IYmsb", registerIY);

    final RegisterDisplaced displacedIY = new RegisterDisplaced("IYdisp", this, registerIY);

    private final Register regTable[] = { registerB, registerC,
                                registerD, registerE,
                                registerH, registerL,
                                indirectHL, registerA };

    private final Register regTableIX[] = { registerB, registerC,
                                registerD, registerE,
                                registerIXmsb, registerIXlsb,
                                displacedIX, registerA };

    private final Register regTableIY[] = { registerB, registerC,
                                registerD, registerE,
                                registerIYmsb, registerIYlsb,
                                displacedIY, registerA };

    /* Active 16 bit register. Can be HL, IXdisp or IYdisp. */
    private Word activeReg16;

    private Register activeFromRegTbl[] = regTable;

    /** Prevent NMI handling. */
//     private boolean inhibitNMI;

    /** RESET signalled. */
    private volatile boolean resetSignal;

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
     * Do we have active NMIs?
     */
    private boolean isNMIActive() {
        return bus.isNMIActive();
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

    private void invalidInstruction() {
        invalid("instruction");
    }

    @Override
    public int fetch() {
        registerR++;
        return super.fetch();
    }

    @Override
    public int fetch_word() {
        registerR += 2;
        return super.fetch_word();
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
        registerR = 0;
        registerRb7 = 0;
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
        activeFromRegTbl = regTable;
        activeReg16 = registerHL;
        ir = fetch();

        parseIR();

        if (isNMIActive()) {
            doNMI();
        }
        if (isINTActive()) {
            doInterrupt();
        }
    }

    /**
     * Handle interrupt.
     * TODO
     */
    private void doInterrupt() {
        iff1 = false;
        iff2 = false;
        switch (interruptMode) {
        case 0:
            bus.ackInterrupt(true);
            activeFromRegTbl = regTable;
            activeReg16 = registerHL;
            ir = bus.readIO(0); // FIXME Don't use 0
            parseIR();
            bus.ackInterrupt(false);
        case 1:
            helpCALL(MODE0_ADDR);
            break;
        default: // mode 2
            bus.ackInterrupt(true);
            int n = bus.readIO(0); // FIXME
            bus.ackInterrupt(false);
            int newAddress = registerI.get() * 256 + (n & 0xFE);
            helpCALL(newAddress);
        }
    }

    /**
     * Handle nonmaskable interrupt.
     * TODO
     */
    private void doNMI() {
        iff2 = iff1;
        iff1 = false;
        helpCALL(NMI_ADDR);
    }

    private void parseIR() {
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
    }

    /**
     * Opcodes between 0x00 and 0x3F.
     * COMPLETE
     */
    private void execute00() {
        switch (ir) {
            case 0x00: // NOP
                break;
            case 0x01:
                registerBC.set(fetch_word()); break;
            case 0x02:
                write(registerBC.get(), registerA.get()); break;
            case 0x03:
                helpINC16(); break;
            case 0x04:
                helpINC8(); break;
            case 0x05:
                helpDEC8(); break;
            case 0x06:
                helpLdMemInxFromAddr(); break;
            case 0x07:
                helpRLCreg(getRegisterLow3(), true); break;

            case 0x08:
                int regTmp = registerAF.get();
                registerAF.set(registerAF_.get());
                registerAF_.set(regTmp);
                break;
            case 0x09:
                helpADD16(false); break;
            case 0x0A:
                registerA.set(read(registerBC.get())); break;
            case 0x0B:
                helpDEC16(); break;
            case 0x0C:
                helpINC8(); break;
            case 0x0D:
                helpDEC8(); break;
            case 0x0E:
                helpLdMemInxFromAddr(); break;
            case 0x0F:
                helpRRCreg(true); break;

            case 0x10: // DJNZ, e
                registerB.add(-1);
                helpCondJR(registerB.get() != 0);
                break;
            case 0x11:
                registerDE.set(fetch_word()); break;
            case 0x12:
                write(registerDE.get(), registerA.get()); break;
            case 0x13:
                helpINC16(); break;
            case 0x14:
                helpINC8(); break;
            case 0x15:
                helpDEC8(); break;
            case 0x16:
                helpLdMemInxFromAddr(); break;
            case 0x17: // RLA
                helpRLreg(true); break;

            case 0x18: // JR e
                helpCondJR(true);
                break;
            case 0x19:
                helpADD16(false); break;
            case 0x1A:
                registerA.set(read(registerDE.get())); break;
            case 0x1B:
                helpDEC16(); break;
            case 0x1C:
                helpINC8(); break;
            case 0x1D:
                helpDEC8(); break;
            case 0x1E:
                helpLdMemInxFromAddr(); break;
            case 0x1F:
                helpRRreg(true); break;

            case 0x20: // JR NZ, e
                helpCondJR(!registerF.isSetZ());
                break;
            case 0x21:
                activeReg16.set(fetch_word()); break;
            case 0x22:
                write_word(fetch_word(), activeReg16.get()); break;
            case 0x23:
                helpINC16(); break;
            case 0x24:
                helpINC8(); break;
            case 0x25:
                helpDEC8(); break;
            case 0x26:
                helpLdMemInxFromAddr(); break;
            case 0x27:
                helpDAA(); break;

            case 0x28: // JR C, e
                helpCondJR(registerF.isSetZ());
                break;
            case 0x29:
                helpADD16(false); break;
            case 0x2A:
                activeReg16.set(read_word(fetch_word())); break;
            case 0x2B:
                helpDEC16(); break;
            case 0x2C:
                helpINC8(); break;
            case 0x2D:
                helpDEC8(); break;
            case 0x2E:
                helpLdMemInxFromAddr(); break;
            case 0x2F:
                helpCPL(); break;

            case 0x30: // JR NC, e
                helpCondJR(!registerF.isSetC());
                break;
            case 0x31:
                registerSP.set(fetch_word()); break;
            case 0x32:
                write(fetch_word(),registerA.get()); break;
            case 0x33:
                helpINC16(); break;
            case 0x34:
                helpINC8(); break;
            case 0x35:
                helpDEC8(); break;
            case 0x36:
                helpLdMemInxFromAddr(); break;
            case 0x37:
                helpSCF(); break;

            case 0x38: // JR C, e
                helpCondJR(registerF.isSetC());
                break;
            case 0x39:
                helpADD16(false); break;
            case 0x3A:
                registerA.set(read(fetch_word())); break;
            case 0x3B:
                helpDEC16(); break;
            case 0x3C:
                helpINC8(); break;
            case 0x3D:
                helpDEC8(); break;
            case 0x3E:
                helpLdMemInxFromAddr(); break;
            case 0x3F:
                helpCCF(); break;

            default:
                invalidInstruction();
        }
    }

    /**
     * Opcodes between 0x40 and 0x7F.
     * COMPLETE
     */
    private void execute40() {
        if (ir == 0x76) {
            halt();
        } else {
            helpLdRegNoFlags();
        }
    }

    /**
     * Opcodes between 0x80 and 0xBF.
     * COMPLETE
     */
    private void execute80() {
        Register regFrom = getRegisterLow3();
        int value = regFrom.get();

        switch (ir & 0xF8) {
            case 0x80: // ADD
                helpAddIntToA(value, false); break;
            case 0x88: // ADC
                helpAddIntToA(value, true); break;
            case 0x90: // SUB
                helpSubIntFromA(value, false); break;
            case 0x98: // SBC
                helpSubIntFromA(value, true); break;
            case 0xA0: // AND
                helpAndIntToA(value); break;
            case 0xA8: // XOR
                helpXorIntToA(value); break;
            case 0xB0: // OR
                helpOrIntToA(value); break;
            case 0xB8: // CP (compare)
                helpCPIntWithA(value); break;
            default:
                invalidInstruction();
        }
    }

    /**
     * Opcodes between 0xC0 and 0xFF.
     */
    private void executeC0() {
        switch (ir) {
            case 0xC0:
                helpRETcc(); break;
            case 0xC1: // POP register BC
                helpPop16(); break;
            case 0xC2: // JP NZ,nn
                helpCondJump(!registerF.isSetZ()); break;
            case 0xC3: // JP
                pc.set(fetch_word()); break;
            case 0xC4:
                helpCALLcc(); break;
            case 0xC5:
                helpPushExt(registerBC); break;
            case 0xC6: // ADD A, n
                helpAddIntToA(fetch(), false); break;
            case 0xC7:
                helpRST(); break;
            case 0xC8:
                helpRETcc(); break;
            case 0xC9:
                helpRET(); break;
            case 0xCA: // JP Z,nn
                helpCondJump(registerF.isSetZ()); break;
            case 0xCB: // Rotate instructions
                executeCB(); break;
            case 0xCC:
                helpCALLcc(); break;
            case 0xCD:
                helpCALL(fetch_word()); break;
            case 0xCE: // ADC A, n
                helpAddIntToA(fetch(), true); break;
            case 0xCF:
                helpRST(); break;

            case 0xD0:
                helpRETcc(); break;
            case 0xD1: // POP register DE
                helpPop16(); break;
            case 0xD2: // JP NC,nn
                helpCondJump(!registerF.isSetC()); break;
            case 0xD3:
                helpOutNA(); break;
            case 0xD4:
                helpCALLcc(); break;
            case 0xD5:
                helpPushExt(registerDE); break;
            case 0xD6:  // SUB A,n
                helpSubIntFromA(fetch(), false); break;
            case 0xD7:
                helpRST(); break;
            case 0xD8:
                helpRETcc(); break;
            case 0xD9:
                helpEXX(); break;
            case 0xDA: // JP NC,nn
                helpCondJump(registerF.isSetC()); break;
            case 0xDB: //IN A, (n)
                helpInAn(); break;
            case 0xDC:
                helpCALLcc(); break;
            case 0xDD:
                activeFromRegTbl = regTableIX;
                activeReg16 = registerIX;
                executeDDorFD();
                break;
            case 0xDE:  // SBC A,n
                helpSubIntFromA(fetch(), true);
                break;
            case 0xDF:
                helpRST(); break;

            case 0xE0:
                helpRETcc(); break;
            case 0xE1: // POP register HL
                helpPop16(); break;
            case 0xE2: // JP PO,nn
                helpCondJump(!registerF.isSetPV()); break;
            case 0xE3: {
                int regTmp = activeReg16.get();
                activeReg16.set(read_word(registerSP.get()));
                write_word(registerSP.get(), regTmp);
                }
                break;
            case 0xE4:
                helpCALLcc(); break;
            case 0xE5:
                helpPushExt(activeReg16); break;
            case 0xE6:
                helpAndIntToA(fetch()); break;
            case 0xE7:
                helpRST(); break;
            case 0xE8:
                helpRETcc(); break;
            case 0xE9:
                pc.set(activeReg16.get()); break;
            case 0xEA: // JP PE,nn
                helpCondJump(registerF.isSetPV());
                break;
            case 0xEB: // SWAP DE, HL
                helpSWAP(); break;
            case 0xEC:
                helpCALLcc(); break;
            case 0xED:
                executeED(); break;
            case 0xEE:
                helpXorIntToA(fetch()); break;
            case 0xEF:
                helpRST(); break;

            case 0xF0:
                helpRETcc(); break;
            case 0xF1: // POP register AF
                helpPop16(); break;
            case 0xF2: // JP P,nn
                helpCondJump(!registerF.isSetS());
                break;
            case 0xF3:
                iff1 = false; iff2 = false; break;
            case 0xF4:
                helpCALLcc(); break;
            case 0xF5:
                helpPushExt(registerAF); break;
            case 0xF6:
                helpOrIntToA(fetch()); break;
            case 0xF7:
                helpRST(); break;
            case 0xF8:
                helpRETcc(); break;
            case 0xF9:
                registerSP.set(activeReg16.get()); break;
            case 0xFA: // JP M,nn
                helpCondJump(registerF.isSetS());
                break;
            case 0xFB:
                iff1 = true; iff2 = true; break;
            case 0xFC:
                helpCALLcc(); break;
            case 0xFD:
                activeFromRegTbl = regTableIY;
                activeReg16 = registerIY;
                executeDDorFD();
                break;
            case 0xFE: // CP n
                helpCPIntWithA(fetch()); break;
            case 0xFF:
                helpRST(); break;

            default:
                invalidInstruction();
        }
    }

    private void executeCB() {
        ir = fetch();
        if (ir >= 0x40) {
            helpBitOps();
            return;
        }
        switch (ir & 0xF8) {
            case 0x00: helpRLCreg(getRegisterLow3(), false); break;
            case 0x08: helpRRCreg(false); break;
            case 0x10: helpRLreg(false); break;
            case 0x18: helpRRreg(false); break;
            case 0x20: helpSLreg(0); break;
            case 0x28: helpSRreg(1); break;
            case 0x30: helpSLreg(1); break; // Undocumented
            case 0x38: helpSRreg(0); break;
            default: 
                invalidInstruction();
        }
    }

    private void helpBitOps() {
        Register reg = getRegisterLow3();
        switch (ir & 0xC0) {
        case 0x40:
            helpBitTest(reg); break;
        case 0x80: // RES
            helpBitClear(reg); break;
        case 0xC0: // SET
            helpBitSet(reg); break;
        }
    }
    /**
     * Execute one extended (0xDD or 0xFD) instruction.
     * If the instruction is unknown, then 0xDD/0xFD is treated as a NOP.
     */
    private void executeDDorFD() {
        ir = fetch();

        switch (ir) {
            case 0x70:
            case 0x71:
            case 0x72:
            case 0x73:
            case 0x74:
            case 0x75:
            // 0x76 is undocumented halt
            case 0x77:
                helpLdMemInxFromReg(); break;
            case 0xCB:
                helpBitOpDisplaced(); break;
            default:
                parseIR();
        }
    }

    /**
     * Execute one extended (0xED) instruction.
     * Instructions in the range 00 to 3F have no effect.
     * Instructions in the range 80 to BF, except those documented as block
     * loads, compares, ins or out, have no effect.
     * Instructions in the range C0 to FF have no effect.
     * The holes in the range 40 to 7F typically duplicate documented instructions
     */
    private void executeED() {
        ir = fetch();

        switch (ir) {
            case 0x40: // IN r(C)
                helpInRC(); break;
            case 0x41: // OUT (C), r
                helpOutCr(); break;
            case 0x42:
                helpSBCHL(); break;
            case 0x43:
                write_word(fetch_word(), registerBC.get()); break;
            case 0x44:
                helpNEG(); break;
            case 0x45:
                helpRETN(); break;
            case 0x46:
                interruptMode = 0; break;
            case 0x47: // LD I,A
                registerI.set(registerA.get()); break;
            case 0x48: // IN r(C)
                helpInRC(); break;
            case 0x49: // OUT (C), r
                helpOutCr(); break;
            case 0x4A: // ADC
                helpADD16(true); break;
            case 0x4B: // LD dd, (nn)
                registerBC.set(read_word(fetch_word())); break;
            case 0x4C: // Undocumented
                helpNEG(); break;
            case 0x4D:
                helpRETI(); break;
            case 0x4E: // Undocumented Set IM to an undefined state
                interruptMode = 0; break;
            case 0x4F:
                registerR = registerA.get();
                registerRb7 = registerR & 0x80;
                break;

            case 0x50: // IN r(C)
                helpInRC(); break;
            case 0x51: // OUT (C), r
                helpOutCr(); break;
            case 0x52:
                helpSBCHL();
                break;
            case 0x53:
                write_word(fetch_word(), registerDE.get()); break;
            case 0x54: // Undocumented
                helpNEG(); break;
            case 0x55: // Undocumented
                helpRETN(); break;
            case 0x56:
                interruptMode = 1; break;
            case 0x57:
                helpLdFromReg(registerA, registerI.get()); break;
            case 0x58: // IN r(C)
                helpInRC(); break;
            case 0x59: // OUT (C), r
                helpOutCr(); break;
            case 0x5A: // ADC
                helpADD16(true); break;
            case 0x5B: // LD dd, (nn)
                registerDE.set(read_word(fetch_word())); break;
            case 0x5C: // Undocumented
                helpNEG(); break;
            case 0x5D:
                helpRETI(); break;
            case 0x5E:
                interruptMode = 2; break;
            case 0x5F: {
                int rVal = (registerRb7 & 0x80) | (registerR & 0x7F);
                helpLdFromReg(registerA, rVal);
                }
                 break;
            case 0x60: // IN r(C)
                helpInRC(); break;
            case 0x61: // OUT (C), r
                helpOutCr(); break;
            case 0x62:
                helpSBCHL();
                break;
            case 0x63:
                write_word(fetch_word(), registerHL.get()); break;
            case 0x64: // Undocumented
                helpNEG(); break;
            case 0x65: // Undocumented
                helpRETN(); break;
            case 0x66:
                interruptMode = 0; break;
            case 0x67:
                helpRRD(); break;
            case 0x68: // IN r(C)
                helpInRC(); break;
            case 0x69: // OUT (C), r
                helpOutCr(); break;
            case 0x6A: // ADC
                helpADD16(true); break;
            case 0x6B: // LD dd, (nn)
                registerHL.set(read_word(fetch_word())); break;
            case 0x6C: // Undocumented
                helpNEG(); break;
            case 0x6D:
                helpRETI(); break;
            case 0x6E: // Undocumented Set IM to an undefined state
                interruptMode = 0; break;
            case 0x6F:
                helpRLD(); break;

            case 0x70: // Undefined IN F, (C)
                helpInRC(); break;
            case 0x71: // Undocumented OUT (C), 0
                bus.writeIO(registerC.get(), 0xFF); break;
            case 0x72:
                helpSBCHL();
                break;
            case 0x73:
                write_word(fetch_word(), registerSP.get()); break;
            case 0x74: // Undocumented
                helpNEG(); break;
            case 0x75: // Undocumented
                helpRETN(); break;
            case 0x76:
                interruptMode = 1; break;
            case 0x77: // Undocumented NOP
                break;
            case 0x78: // IN r(C)
                helpInRC(); break;
            case 0x79: // OUT (C), r
                helpOutCr(); break;
            case 0x7A: // ADC
                helpADD16(true); break;
            case 0x7B: // LD dd, (nn)
                registerSP.set(read_word(fetch_word())); break;
            case 0x7C: // Undocumented
                helpNEG(); break;
            case 0x7D:
                helpRETI(); break;
            case 0x7E:
                interruptMode = 2; break;
            case 0x7F: // Undocumented NOP
                break;

            case 0xA0: helpLDI(); break;
            case 0xA1: helpCPI(); break;
            case 0xA2: helpINDecInc(1); break;
            case 0xA3: helpOUTDecInc(1); break;
            case 0xA8: helpLDD(); break;
            case 0xA9: helpCPD(); break;
            case 0xAA: helpINDecInc(-1); break;
            case 0xAB: helpOUTDecInc(-1); break;

            case 0xB0: // LDIR
                helpLDI();
                if (registerBC.get() != 0)
                    pc.add(-2);
                break;
            case 0xB1: // CPIR
                helpCPI();
                if (registerBC.get() != 0 && !registerF.isSetZ())
                    pc.add(-2);
                break;
            case 0xB2:
                helpINDecInc(1);
                if (registerB.get() != 0)
                    pc.add(-2);
                break;
            case 0xB3: // OTIR
                helpOUTDecInc(1);
                if (registerB.get() != 0)
                    pc.add(-2);
                break;
            case 0xB8: // LDDR
                helpLDD();
                if (registerBC.get() != 0)
                    pc.add(-2);
                break;
            case 0xB9: // CPDR
                helpCPD();
                if (registerBC.get() != 0 && !registerF.isSetZ())
                    pc.add(-2);
                break;
            case 0xBA:
                helpINDecInc(-1);
                if (registerB.get() != 0)
                    pc.add(-2);
                break;
            case 0xBB: // OTDR
                helpOUTDecInc(-1);
                if (registerB.get() != 0)
                    pc.add(-2);
                break;

            default:
                invalidInstruction();
        }
    }

    /**
     * Get register from active register set.
     */
    private Register getRegister(int regCode) {
        Register reg = activeFromRegTbl[regCode];
        return reg.getRealRegister();
    }

    private Register getRegisterLow3() {
        return getRegister(ir & 0x07);
    }

    /**
     * Get register from main register set.
     */
    private Register getRegisterMain(int regCode) {
        Register reg = regTable[regCode];
        return reg.getRealRegister();
    }

    /**
     * Get the index value, make signed as its two's compliment.
     *
     * @return The index register offset value in the range -128..+127
     */
    private int fetchIndexOffset() {
        int index = fetch();
        if (index > 0x7f)
            return (index - 256);
        else
            return index;
    }

    /**
     * Jump to another location dependent on bit in flag register.
     */
    private void helpCondJump(boolean test) {
        int newLoc = fetch_word();
        if (test) pc.set(newLoc);
    }

    /**
     * Jump to relative location dependent on bit in flag register.
     */
    private void helpCondJR(boolean test) {
        int offset = fetchIndexOffset();
        if (test) {
            pc.add(offset);
        }
    }

    /**
     * Call subroutine.
     */
    private void helpCALL(int newLoc) {
        helpPushExt(pc);
        pc.set(newLoc);
    }

    /**
     * Call subroutine conditionally.
     */
    private void helpCALLcc() {
        int bitnum = (ir & 0x38) >> 3;
        int newLoc = fetch_word();
        switch (bitnum) {
            case 0: if (!registerF.isSetZ()) helpCALL(newLoc); break;
            case 1: if (registerF.isSetZ()) helpCALL(newLoc); break;
            case 2: if (!registerF.isSetC()) helpCALL(newLoc); break;
            case 3: if (registerF.isSetC()) helpCALL(newLoc); break;
            case 4: if (!registerF.isSetPV()) helpCALL(newLoc); break;
            case 5: if (registerF.isSetPV()) helpCALL(newLoc); break;
            case 6: if (!registerF.isSetS()) helpCALL(newLoc); break;
            case 7: if (registerF.isSetS()) helpCALL(newLoc); break;
        }
    }

    /**
     * Return from subroutine.
     */
    private void helpRET() {
        pc.set(read_word(registerSP.get()));
        registerSP.add(2);
    }

    /**
     * Return conditionally.
     */
    private void helpRETcc() {
        int bitnum = (ir & 0x38) >> 3;
        switch (bitnum) {
            case 0: if (!registerF.isSetZ()) helpRET(); break;
            case 1: if (registerF.isSetZ()) helpRET(); break;
            case 2: if (!registerF.isSetC()) helpRET(); break;
            case 3: if (registerF.isSetC()) helpRET(); break;
            case 4: if (!registerF.isSetPV()) helpRET(); break;
            case 5: if (registerF.isSetPV()) helpRET(); break;
            case 6: if (!registerF.isSetS()) helpRET(); break;
            case 7: if (registerF.isSetS()) helpRET(); break;
        }
    }

    /**
     * Return from interrupt subroutine.
     * TODO: Implement side-effects.
     */
    private void helpRETI() {
        helpRET();
    }

    /**
     * Return from non-maskable interrupt subroutine.
     * TODO: Implement side-effects.
     */
    private void helpRETN() {
        helpRET();
        iff1 = iff2;
    }

    /**
     * Restore instruction.
     * Push program counter on stack and go to encoded address.
     */
    private void helpRST() {
        helpPushExt(pc);
        pc.set(ir & 0x38);
    }

    /**
     * Push a word register on stack.
     */
    private void helpPushExt(Word reg) {
        registerSP.add(-2);
        write_word(registerSP.get(), reg.get());
    }

    /**
     * LD A,I and LD A,R.
     * Load one register into another with flag operations.
     * Sets P/V flag to IFF2.
     */
    private void helpLdFromReg(UByte regTo, int regFrom) {
        registerF.setS(regFrom > 0x7F);
        registerF.setZ(regFrom == 0);
        registerF.setH(false);
        registerF.setPV(iff2);
        registerF.setN(false);
        regTo.set(regFrom);
    }

    /** LR R,n and LD (IX+d), n. */
    private void helpLdMemInxFromAddr() {
        Register regTo = getRegister((ir & 0x38) >> 3);
        regTo.set(fetch());
    }

    /**
     * LD R,r.
     * CPU behaving inconsistently in regTo.
     */
    private void helpLdRegNoFlags() {
        Register regFrom = getRegisterLow3();
        Register regTo = getRegisterMain((ir & 0x38) >> 3);
        regTo.set(regFrom.get());
    }

    /**
     * LD (IX+d), r. -- Opcodes 0xDD, 0x7?
     * CPU behaving inconsistently in regFrom.
     */
    private void helpLdMemInxFromReg() {
        Register regFrom = getRegisterMain(ir & 0x07);
        Register regTo = getRegister((ir & 0x38) >> 3);
        regTo.set(regFrom.get());
    }

    /** Block move increment. */
    private void helpLDI() {
        indirectDE.set(indirectHL.get());
        registerDE.add(1);
        registerHL.add(1);
        registerBC.add(-1);
        registerF.setPV(registerBC.get() == 0x00);
        registerF.setH(false);
        registerF.setN(false);
    }

    /** Block compare increment. */
    private void helpCPI() {
        registerF.setS((registerA.get() - indirectHL.get()) < 0);
        registerF.setZ(registerA.get() == indirectHL.get());
        boolean halfCarry = (registerA.get() & 0x0F) < (indirectHL.get() & 0x0F);
        registerF.setH(halfCarry);
        registerHL.add(1);
        registerBC.add(-1);
        registerF.setPV(registerBC.get() == 0x00);
        registerF.setN(true);
    }

    /** Block move decrement. */
    private void helpLDD() {
        indirectDE.set(indirectHL.get());
        registerDE.add(-1);
        registerHL.add(-1);
        registerBC.add(-1);
        registerF.setPV(registerBC.get() == 0x00);
        registerF.setH(false);
        registerF.setN(false);
    }

    /** Block compare decrement. */
    private void helpCPD() {
        registerF.setS((registerA.get() - indirectHL.get()) < 0);
        registerF.setZ(registerA.get() == indirectHL.get());
        boolean halfCarry = (registerA.get() & 0x0F) < (indirectHL.get() & 0x0F);
        registerF.setH(halfCarry);
        registerHL.add(-1);
        registerBC.add(-1);
        registerF.setPV(registerBC.get() == 0x00);
        registerF.setN(true);
    }

    /**
     * Complement accumulator.
     */
    private void helpCPL() {
        registerA.set(~registerA.intValue());
        registerF.setH(true);
        registerF.setN(true);
    }

    /**
     * Negate accumulator - 2's complement.
     */
    private void helpNEG() {
        registerF.setPV(registerA.get() == 0x80);
        registerF.setC(registerA.get() == 0x00);
        registerA.set(0 - registerA.intValue());
        registerF.setS(registerA.get() > 0x7F);
        registerF.setZ(registerA.get() == 0);
        registerF.setH(true);
        registerF.setN(true);
    }

    /**
     * Exchange BC, DE, and HL.
     * Each 2-byte value in register pairs BC, DE, and HL is exchanged with
     * the 2-byte value in BC', DE', and HL', respectively.
     */
    private void helpEXX() {
        int tempVal = registerBC.get();
        registerBC.set(registerBC_.get());
        registerBC_.set(tempVal);
        tempVal = registerDE.get();
        registerDE.set(registerDE_.get());
        registerDE_.set(tempVal);
        tempVal = registerHL.get();
        registerHL.set(registerHL_.get());
        registerHL_.set(tempVal);
    }

    /** Swap DE and HL. */
    private void helpSWAP() {
        int tempVal = registerDE.get();
        registerDE.set(registerHL.get());
        registerHL.set(tempVal);
    }

    /**
     * Halt CPU.
     * When a software HALT instruction is executed, the CPU executes NOPs
     * until an interrupt is received (either a nonmaskable or a maskable
     * interrupt while the interrupt flip-flop is enabled).
     * To avoid wasting CPU cycles we use Java's wait() operation.
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
     * 8-bit increment.
     * Unlike a standard ADD, the Carry flag is not affected.
     */
    private void helpINC8() {
        Register regTo = getRegister((ir & 0x38) >> 3);
        int value = regTo.get();

        int halfCarry = (value & 0x0f) + 1;
        registerF.setH(bittst(halfCarry, 4));

        int t = value + 1;
        registerF.setPV(bittst(value ^ 1 ^ t ^ (t >> 1), 7));

        regTo.set(t);
        registerF.setS(regTo.get() > 0x7F);
        registerF.setZ(regTo.get() == 0);
        registerF.setN(false);
    }

    /**
     * 8-bit decrement.
     * Unlike a standard SUB, the Carry flag is not affected.
     */
    private void helpDEC8() {
        Register targetReg = getRegister((ir & 0x38) >> 3);
        int oldValue = targetReg.add(-1);

        int halfCarry = (oldValue & 0x0f) - 1;
        registerF.setH(bittst(halfCarry, 4));

        int t = (oldValue - 1) & 0xFF;
        registerF.setPV(oldValue == 0x80);
        registerF.setS(t > 0x7F);
        registerF.setZ(t == 0);
        registerF.setN(true);
    }

    private Word getRegister16(int regCode) {
        switch (regCode) {
            case 0x00: return registerBC;
            case 0x01: return registerDE;
            case 0x02: return activeReg16;
            case 0x03: return registerSP;
        }
        return registerHL; // Should not reach here
    }

    /**
     * 16-bit increment.
     * Does not change flag register.
     */
    private void helpINC16() {
        int regCode = (ir & 0x30) >> 4;
        Word targetReg = getRegister16(regCode);
        targetReg.add(1);
    }

    /**
     * Pop 2 bytes of the stack.
     */
    private void helpPop16() {
        int regCode = (ir & 0x30) >> 4;
        Word targetReg = getRegister16(regCode);
        int newVal = read_word(registerSP.get());
        targetReg.set(newVal);
        registerSP.add(2);
    }

    /**
     * 16-bit decrement.
     * Does not change flag register.
     */
    private void helpDEC16() {
        int regCode = (ir & 0x30) >> 4;
        Word targetReg = getRegister16(regCode);
        targetReg.add(-1);
    }

    /**
     * 16-bit add.
     */
    private void helpADD16(boolean withCarry) {
        int regCode = (ir & 0x30) >> 4;
        Word targetReg = getRegister16(regCode);
        int value = targetReg.get() + (withCarry?registerF.getC():0);
        registerF.setC(bittst(value, 16));
        int halfCarry = (activeReg16.get() & 0x0FFF) + (value & 0x0FFF);
        registerF.setN(false);
        registerF.setH(bittst(halfCarry, 12));
        activeReg16.add(value);
        registerF.setS(bittst(activeReg16.get(), 15));
    }

    /**
     * Subtract from HL with carry.
     */
    private void helpSBCHL() {
        int regCode = (ir & 0x30) >> 4;
        Word targetReg = getRegister16(regCode);
        int subtrahend = targetReg.get();
        int value = registerHL.get();
        int halfCarry = (value & 0x0fff) - (subtrahend & 0x0fff) - registerF.getC();
        registerF.setH(bittst(halfCarry, 12));
        int t = value - subtrahend - registerF.getC();
        registerF.setC(bittst(t, 16));
        t &= 0xFFFF;
        registerHL.set(t);
        registerF.setS(t > 0x7FFF);
        registerF.setZ(t == 0);
        registerF.setN(true);
    }

    /**
     * Add value to register A with or without carry flag.
     */
    private void helpAddIntToA(int value, boolean withCarry) {
        int halfCarry = (registerA.get() & 0x0f) + (value & 0x0f);
        registerF.setH(bittst(halfCarry, 4));

        int t = registerA.get() + value + (withCarry?registerF.getC():0);
        registerF.setPV(bittst(registerA.get() ^ value ^ t ^ (t >> 1), 7));

        registerF.setC(bittst(t, 8));
        registerA.set(t);
        registerF.setS(registerA.get() > 0x7F);
        registerF.setZ(registerA.get() == 0);
        registerF.setN(false);
    }

    private int subtractionFlags(int value, int subtrahend, boolean withCarry) {

        int halfCarry = (value & 0x0f) + (subtrahend & 0x0f);
        registerF.setH(bittst(halfCarry, 4));

        int t = value - subtrahend - (withCarry?registerF.getC():0);
        registerF.setPV(bittst(value ^ subtrahend ^ t ^ (t >> 1), 7));
        registerF.setC(bittst(t, 8));
        t &= 0xFF;
        registerF.setS(t > 0x7F);
        registerF.setZ(t == 0);
        registerF.setN(true);
        return t;
    }

    /**
     * Compare value with content of Register A.
     * This is a subtraction without storing the result.
     */
    private void helpCPIntWithA(int subtrahend) {
        int t = subtractionFlags(registerA.get(), subtrahend, false);
    }

    /**
     * Subtract value from register A with or without carry flag.
     * Result is stored in register A.
     */
    private void helpSubIntFromA(int subtrahend, boolean withCarry) {
        int t = subtractionFlags(registerA.get(), subtrahend, withCarry);
        registerA.set(t);
    }

    /**
     * AND value to register A.
     */
    private void helpAndIntToA(int value) {
        int t = registerA.get() & value;
        registerF.setH(true);
        registerF.setPV(parityOf(t));
        registerA.set(t);
        registerF.setC(false);
        registerF.setS(t > 0x7F);
        registerF.setZ(t == 0);
        registerF.setN(false);
    }

    /**
     * OR value to register A.
     */
    private void helpOrIntToA(int value) {
        int t = registerA.get() | value;
        registerF.setH(false);
        registerF.setPV(parityOf(t));
        registerA.set(t);
        registerF.setS(t > 0x7F);
        registerF.setZ(t == 0);
        registerF.setN(false);
        registerF.setC(false);
    }

    /**
     * Xor value to register A.
     */
    private void helpXorIntToA(int value) {
        int t = registerA.get() ^ value;
        registerF.setH(false);
        registerF.setPV(parityOf(t));
        registerA.set(t);
        registerF.setS(t > 0x7F);
        registerF.setZ(t == 0);
        registerF.setN(false);
        registerF.setC(false);
    }

    /**
     * Decimal adjust.
     */
    private void helpDAA() {
        if (registerF.isSetN()) {
            // Subtractions.
            if (((registerA.get() & 0x0f) > 9) || (registerF.isSetH())) {
                registerF.setH(((registerA.get() & 0x0f) - 6) < 0);
                registerA.add(-6);
            }
            if (((registerA.get() & 0xf0) > 0x90) || (registerF.isSetC())) {
                if (((registerA.get() & 0xf0) - 0x60) < 0) registerF.setC(true);
                registerA.add(-0x60);
            }
        } else {
            // Additions
            if (((registerA.get() & 0x0f) > 9) || (registerF.isSetH())) {
                registerF.setH(((registerA.get() & 0x0f) + 6) > 0x0f);
                registerA.add(6);
            }
            if (((registerA.get() & 0xf0) > 0x90) || (registerF.isSetC())) {
                if (((registerA.get() & 0xf0) + 0x60) > 0xf0) registerF.setC(true);
                registerA.add(0x60);
            }
          }
        registerF.setZ(registerA.get() == 0);
        registerF.setS(registerA.get() > 0x7F);
        registerF.setPV(parityOf(registerA.get()));
    }

    /**
     * Complement (invert) Carry Flag.
     */
    private void helpCCF() {
        registerF.setH(registerF.isSetC());
        registerF.setN(false);
        registerF.setC(!registerF.isSetC());
    }

    /**
     * Set Carry Flag.
     */
    private void helpSCF() {
        registerF.setH(false);
        registerF.setN(false);
        registerF.setC(true);
    }

/*======================================================
 * Rotate and Shift group
 ======================================================*/
    /**
     * Rotate Left.
     * The contents of the register are rotated left 1 bit position through the
     * Carry flag. The previous contents of the Carry flag are copied to bit 0.
     */
    private void helpRLreg(boolean stopShort) {
        Register reg = getRegisterLow3();
        int prevC = registerF.getC();
        registerF.setC(reg.get() >= 0x80);
        int newVal = ((reg.get() << 1) | prevC) & 0xFF;
        reg.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        if (stopShort) return;
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
        
    }

    /**
     * RR = Rotate Right.
     * The contents of the register are rotated right 1 bit position through the
     * Carry flag. The previous contents of the Carry flag are copied to bit 7.
     */
    private void helpRRreg(boolean stopShort) {
        Register reg = getRegisterLow3();
        int prevC = registerF.getC() << 7;
        registerF.setC(bittst(reg.get(), 0));
        int newVal = (reg.get() >> 1) | prevC;
        reg.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        if (stopShort) return;
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * RRC = Rotate Right.
     * The contents of the register are rotated right 1 bit position through the
     * Carry flag and also to bit 7.
     */
    private void helpRRCreg(boolean stopShort) {
        Register reg = getRegisterLow3();
        boolean newC = bittst(reg.get(), 0);
        registerF.setC(newC);
        int newVal = (reg.get() >> 1) | (newC ? 0x80 : 0);
        reg.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        if (stopShort) return;
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * Rotate Left.
     * The contents of register r are rotated left 1 bit position. The contents
     * of bit 7 are copied to the Carry flag and also to bit 0.
     */
    private void helpRLCreg(Register reg, boolean stopShort) {
        boolean bit7 = bittst(reg.get(), 7);
        int newVal = ((reg.get() << 1) | (bit7?1:0)) & 0xFF;
        reg.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        registerF.setC(bit7);
        if (stopShort) return;
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * Shift Left Arithmetical/Logical.
     * The contents of register r are shift left 1 bit position. The contents
     * of bit 7 are copied to the Carry flag. Bit 0 is set to 1.
     */
    private void helpSLreg(int bit0) {
        Register reg = getRegisterLow3();
        boolean bit7 = bittst(reg.get(), 7);
        int newVal = (reg.get() << 1) | bit0;
        reg.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        registerF.setC(bit7);
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * Shift Right Arithmetical/Logical.
     * The contents of register r are shift right 1 bit position. The contents
     * of bit 0 are copied to the Carry flag. Bit 7 is kept as is.
     */
    private void helpSRreg(int bit7) {
        Register reg = getRegisterLow3();
        boolean bit0 = bittst(reg.get(), 0);
        if (bit7 == 1) bit7 = bittst(reg.get(), 7) ? 0x80 : 0;
        int newVal = (reg.get() >> 1) | bit7;
        reg.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        registerF.setC(bit0);
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * BCD digit rotate instruction.
     */
    private void helpRRD() {
        int a = registerA.get();
        int v = read(registerHL.get());
        write(registerHL, ((a << 4) & 0xF0) | ((v >> 4) & 0x0F));
        int newVal = (a & 0xF0) | (v & 0x0F);
        registerA.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * BCD digit rotate instruction.
     */
    private void helpRLD() {
        int a = registerA.get();
        int v = read(registerHL.get());
        write(registerHL, ((v << 4) & 0xF0) | (a & 0x0F));
        int newVal = (a & 0xF0) | ((v >> 4) & 0x0F);
        registerA.set(newVal);
        registerF.setH(false);
        registerF.setN(false);
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

/*======================================================
 * Bit Test, Set & Reset group
 ======================================================*/

    
    /**
     * Test a bit in a register.
     */
    private void helpBitTest(Register reg) {
        int bitnum = (ir & 0x38) >> 3;
        registerF.setZ(!bittst(reg.get(), bitnum));
        registerF.setH(true);
        registerF.setN(false);
    }

    private void helpBitSet(Register reg) {
        int bitnum = (ir & 0x38) >> 3;
        reg.set(bitset(reg.get(), bitnum));
    }

    private void helpBitClear(Register reg) {
        int bitnum = (ir & 0x38) >> 3;
        reg.set(bitclr(reg.get(), bitnum));
    }

    /**
     * Test a bit in a register for IX+disp and IY+disp.
     */
    private void helpBitOpDisplaced() {
        Register reg = getRegister(6); // Fetches displacement byte
        ir = fetch(); // Get instruction

        switch (ir & 0xC0) {
        case 0x00: // RLC (IX+d)
            helpRLCreg(reg, false); break;
        case 0x40: // BIT b, (IX+d)
            helpBitTest(reg); break;
        case 0x80: // RES b, (IX+d)
            helpBitClear(reg); break;
        case 0xC0: // SET b, (IX+d)
            helpBitSet(reg);
            break;
        default:
            invalidInstruction();
        }

        if ((ir & 0xC0) != 0x40) {
            int sideEffectCode = ir & 0x07;
            if (sideEffectCode != 0x06) {
                Register sideEffectReg = getRegisterMain(sideEffectCode);
                sideEffectReg.set(reg.get());
            }
        }
    }

    private final static boolean parityTable[] = {
        true,   // 0000
        false,  // 0001
        false,  // 0010
        true,   // 0011
        false,  // 0100
        true,   // 0101
        true,   // 0110
        false,  // 0111

        false,  // 1000
        true,   // 1001
        true,   // 1010
        false,  // 1011
        true,   // 1100
        false,  // 1101
        false,  // 1110
        true    // 1111
    };

    /**
     * Calculate parity of value.
     * The PV flag is used with logical operations and rotate instructions
     * to indicate the resulting parity is even. The number of 1 bits in a byte
     * are counted. If the total is Odd, ODD parity is flagged (i.e., P = 0).
     * If the total is even, even parity is flagged (i.e., P = 1).
     */
    private boolean parityOf(int value) {
        return !parityTable[(value >> 4) & 0xF] ^ parityTable[value & 0xF];
    }

/*======================================================
 * Input/Output group
 ======================================================*/

    /**
     * OUT (n), A.
     * The operand n is placed on the bottom half (A0 through A7) of the
     * address bus to select the I/O device at one of 256 possible ports. The
     * contents of the Accumulator (Register A) also appear on the top half
     * (A8 through A15) of the address bus at this time. Then the byte
     * contained in the Accumulator is placed on the data bus and written to
     * the selected peripheral device.
     */
    private void helpOutNA() {
        int n = fetch();
        bus.writeIO((registerA.get() << 8) | n, registerA.get());
    }

    /**
     * IN A, (n).
     * The operand n is placed on the bottom half (A0 through A7) of the
     * address bus to select the I/O device at one of 256 possible ports. The
     * contents of the Accumulator also appear on the top half (A8 through A15)
     * of the address bus at this time. Then one byte from the selected port
     * is placed on the data bus and written to the Accumulator (Register A)
     * in the CPU.
     */
    private void helpInAn() {
        int n = fetch();
        registerA.set((registerA.get() << 8) | bus.readIO(n));
    }

    /**
     * OUT (C), r.
     * The contents of Register C are placed on the bottom half (A0 through A7)
     * of the address bus to select the I/O device at one of 256 possible
     * ports. The contents of Register B are placed on the top half (A8 through
     *  A15) of the address bus at this time. Then the byte contained in
     * register r is placed on the data bus and written to the selected
     * peripheral device. Register r identifies any of the CPU registers shown
     * in the following table, which also shows the corresponding three-bit r
     * field for each that appears in the assembled object code.
     */
    private void helpOutCr() {
        Register regTo = getRegister((ir & 0x38) >> 3);
        bus.writeIO(registerBC.get(), regTo.get());
    }

    /**
     * IN r (C).
     */
    private void helpInRC() {
        int newVal = bus.readIO(registerBC.get());
        if (ir != 0x70) {
            Register regTo = getRegister((ir & 0x38) >> 3);
            regTo.set(newVal);
        }
        registerF.setH(false);
        registerF.setN(false);
        registerF.setZ(newVal == 0);
        registerF.setS(newVal > 0x7F);
        registerF.setPV(parityOf(newVal));
    }

    /**
     * INI/IND.
     */
    private void helpINDecInc(int increment) {
        int newVal = bus.readIO(registerBC.get());
        write(registerHL.get(), newVal);
        registerB.add(-1);
        registerHL.add(increment);
        registerF.setZ(registerB.get() == 0);
        registerF.setN(true);
    }

    /**
     * OUTI/OUTD.
     */
    private void helpOUTDecInc(int increment) {
        int newVal = read(registerHL.get());
        registerB.add(-1);
        bus.writeIO(registerBC.get(), newVal);
        registerHL.add(increment);
        registerF.setZ(registerB.get() == 0);
        registerF.setN(true);
    }

}
