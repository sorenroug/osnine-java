package org.roug.osnine;

public class DisAssembler {

    class Opcode {
        String name;
        int  clock;
        int  bytes;
        int  display;

        Opcode(String name, int clock, int bytes, int display) {
            this.name = name;
            this.clock = clock;
            this.bytes = bytes;
            this.display = display;
        }
    }

    private MC6809 cpu;

    private final Opcode[] optable = {
      new Opcode( "NEG  ",  6,  2, 1),	 /* 0x00 */
      new Opcode( "?????",  0,  1, 0),	 /* 0x01 */
      new Opcode( "?????",  0,  1,	0),	 /* 0x02 */
      new Opcode( "COM  ",  6,  2,	1),	 /* 0x03 */
      new Opcode( "LSR  ",  6,  2,	1),	 /* 0x04 */
      new Opcode( "?????",  0,  1,	0),	 /* 0x05 */
      new Opcode( "ROR  ",  6,  2,	1),	 /* 0x06 */
      new Opcode( "ASR  ",  6,  2,	1),	 /* 0x07 */
      new Opcode( "LSL  ",  6,  2,	1),	 /* 0x08 */
      new Opcode( "ROR  ",  6,  2,	1),	 /* 0x09 */
      new Opcode( "DEC  ",  6,  2,	1),	 /* 0x0a */
      new Opcode( "?????",  0,  1,	0),	 /* 0x0b */
      new Opcode( "INC  ",  6,  2,	1),	 /* 0x0c */
      new Opcode( "TST  ",  6,  2,	1),	 /* 0x0d */
      new Opcode( "JMP  ",  3,  2,	1),	 /* 0x0e */
      new Opcode( "CLR  ",  6,  2,	1),     /* 0x0f */

      new Opcode( "",       0,  1, 12),	 /* 0x10 */
      new Opcode( "",       0,  1, 13),	 /* 0x11 */
      new Opcode( "NOP  ",  2,  1, 4),	 /* 0x12 */
      new Opcode( "SYNC ",  4,  1, 4),        /* 0x13 */
      new Opcode( "?????",  0,  1, 0),	 /* 0x14 */
      new Opcode( "?????",  0,  1, 0),        /* 0x15 */
      new Opcode( "LBRA ",  5,  3, 8),	 /* 0x16 */
      new Opcode( "LBSR ",  9,  3, 8),	 /* 0x17 */
      new Opcode( "?????",  0,  1, 0),	 /* 0x18 */
      new Opcode( "DAA  ",  2,  1, 4),	 /* 0x19 */
      new Opcode( "ORCC ",  3,  2, 2),	 /* 0x1a */
      new Opcode( "?????",  0,  1, 0),	 /* 0x1b */
      new Opcode( "ANDCC",  3,  2, 2),        /* 0x1c */
      new Opcode( "SEX  ",  2,  1, 4),	 /* 0x1d */
      new Opcode( "EXG  ",  8,  2, 9),	 /* 0x1e */
      new Opcode( "TFR  ",  6,  2,   9),	 /* 0x1f */

      new Opcode( "BRA  ",  3,  2,   7),	 /* 0x20 */
      new Opcode( "BRN  ",  3,  2,   7),	 /* 0x21 */
      new Opcode( "BHI  ",  3,  2,   7),	 /* 0x22 */
      new Opcode( "BLS  ",  3,  2,   7),	 /* 0x23 */
      new Opcode( "BCC  ",  3,  2,   7),	 /* 0x24 */
      new Opcode( "BCS  ",  3,  2,   7),	 /* 0x25 */
      new Opcode( "BNE  ",  3,  2,   7),	 /* 0x26 */
      new Opcode( "BEQ  ",  3,  2,   7),	 /* 0x27 */
      new Opcode( "BVC  ",  3,  2,   7),	 /* 0x28 */
      new Opcode( "BVS  ",  3,  2,   7),	 /* 0x29 */
      new Opcode( "BPL  ",  3,  2,   7),	 /* 0x2a */
      new Opcode( "BMI  ",  3,  2,   7),	 /* 0x2b */
      new Opcode( "BGE  ",  3,  2,   7),	 /* 0x2c */
      new Opcode( "BLT  ",  3,  2,   7),	 /* 0x2d */
      new Opcode( "BGT  ",  3,  2,   7),	 /* 0x2e */
      new Opcode( "BLE  ",  3,  2,   7),	 /* 0x2f */

      new Opcode( "LEAX ",  4,  2,   5),      /* 0x30 */
      new Opcode( "LEAY ",  4,  2,   5),      /* 0x31 */
      new Opcode( "LEAS ",  4,  2,   5),      /* 0x32 */
      new Opcode( "LEAU ",  4,  2,   5),      /* 0x33 */
      new Opcode( "PSHS ",  5,  2,   10),      /* 0x34 */
      new Opcode( "PULS ",  5,  2,   10),      /* 0x35 */
      new Opcode( "PSHU ",  5,  2,   11),      /* 0x36 */
      new Opcode( "PULU ",  5,  2,   11),      /* 0x37 */
      new Opcode( "?????",  0,  1,   0),      /* 0x38 */
      new Opcode( "RTS  ",  5,  1,   4),      /* 0x39 */
      new Opcode( "ABX  ",  3,  1,   4),      /* 0x3a */
      new Opcode( "RTI  ",  6,  1,   4),      /* 0x3b */
      new Opcode( "CWAI ",  20, 2,   4),      /* 0x3c */
      new Opcode( "MUL  ",  11, 1,   4),      /* 0x3d */
      new Opcode( "?????",  0,  1,   0),      /* 0x3e */
      new Opcode( "SWI  ",  19, 1,   4),      /* 0x3f */

      new Opcode( "NEGA ",   2,  1,   4),	 /* 0x40 */
      new Opcode(  "?????",  0, 1,   0),	 /* 0x41 */
      new Opcode(  "?????",  0, 1,   0),	 /* 0x42 */
      new Opcode(  "COMA ",  2, 1,   4),	 /* 0x43 */
      new Opcode(  "LSRA ",  2, 1,   4),	 /* 0x44 */
      new Opcode(  "?????",  0, 1,   0),	 /* 0x45 */
      new Opcode(  "RORA ",  2, 1,   4),	 /* 0x46 */
      new Opcode(  "ASRA ",  2, 1,   4),	 /* 0x47 */
      new Opcode(  "LSLA ",  2, 1,   4),	 /* 0x48 */
      new Opcode(  "ROLA ",  2, 1,   4),	 /* 0x49 */
      new Opcode(  "DECA ",  2, 1,   4),	 /* 0x4a */
      new Opcode(  "?????",  0, 1,   0),	 /* 0x4b */
      new Opcode(  "INCA ",  2, 1,   4),	 /* 0x4c */
      new Opcode(  "TSTA ",  2, 1,   4),      /* 0x4d */
      new Opcode(  "?????",  0, 1,   0),	 /* 0x4e */
      new Opcode(  "CLRA ",  2, 1,   4),	 /* 0x4f */

      new Opcode(  "NEGB ",  2, 1,   4),	 /* 0x50 */
      new Opcode( "?????",   0, 1,   0),	 /* 0x51 */
      new Opcode( "?????",   0, 1,   0),	 /* 0x52 */
      new Opcode( "COMB ",   2, 1,   4),	 /* 0x53 */
      new Opcode( "LSRB ",   2, 1,   4),	 /* 0x54 */
      new Opcode( "?????",   0, 1,   0),	 /* 0x55 */
      new Opcode( "RORB ",   2, 1,   4),	 /* 0x56 */
      new Opcode( "ASRB ",   2, 1,   4),	 /* 0x57 */
      new Opcode( "LSLB ",   2, 1,   4),	 /* 0x58 */
      new Opcode( "ROLB ",   2, 1,   4),	 /* 0x59 */
      new Opcode( "DECB ",   2, 1,   4),	 /* 0x5a */
      new Opcode( "?????",   0, 1,   0),	 /* 0x5b */
      new Opcode( "INCB ",   2, 1,   4),	 /* 0x5c */
      new Opcode( "TSTB ",   2, 1,   4),	 /* 0x5d */
      new Opcode( "?????",   0, 1,   0),	 /* 0x5e */
      new Opcode( "CLRB ",   2, 1,   4),	 /* 0x5f */

      new Opcode( "NEG  ",   6, 2,   5),	 /* 0x60 */
      new Opcode( "?????",   0, 2,   0),	 /* 0x61 */
      new Opcode( "?????",   0, 2,   0),	 /* 0x62 */
      new Opcode( "COM  ",   6, 2,   5),	 /* 0x63 */
      new Opcode( "LSR  ",   6, 2,   5),	 /* 0x64 */
      new Opcode( "?????",   0, 2,   5),	 /* 0x65 */
      new Opcode( "ROR  ",   6, 2,   5),	 /* 0x66 */
      new Opcode( "ASR  ",   6, 2,   5),	 /* 0x67 */
      new Opcode( "LSL  ",   6, 2,   5),	 /* 0x68 */
      new Opcode( "ROL  ",   6, 2,   5),	 /* 0x69 */
      new Opcode( "DEC  ",   6, 2,   5),	 /* 0x6a */
      new Opcode( "?????",   0, 2,   0),	 /* 0x6b */
      new Opcode( "INC  ",   6, 2,   5),	 /* 0x6c */
      new Opcode( "TST  ",   6, 2,   5),	 /* 0x6d */
      new Opcode( "JMP  ",   3, 2,   5),	 /* 0x6e */
      new Opcode( "CLR  ",   6, 2,   5),	 /* 0x6f */

      new Opcode( "NEG  ",   7, 3,   6),      /* 0x70 */
      new Opcode( "?????",   0, 1,   0),      /* 0x71 */
      new Opcode( "?????",   0, 1,   0),	 /* 0x72 */
      new Opcode( "COM  ",   7, 3,   6),	 /* 0x73 */
      new Opcode( "LSR  ",   7, 3,   6),	 /* 0x74 */
      new Opcode( "?????",   0, 1,   0),	 /* 0x75 */
      new Opcode( "ROR  ",   7, 3,   6),	 /* 0x76 */
      new Opcode( "ASR  ",   7, 3,   6),	 /* 0x77 */
      new Opcode( "LSL  ",   7, 3,   6),	 /* 0x78 */
      new Opcode( "ROL  ",   7, 3,   6),	 /* 0x79 */
      new Opcode( "DEC  ",   7, 3,   6),	 /* 0x7a */
      new Opcode( "?????",   0, 1,   0),	 /* 0x7b */
      new Opcode( "INC  ",   7, 3,   6),	 /* 0x7c */
      new Opcode( "TST  ",   7, 3,   6),	 /* 0x7d */
      new Opcode( "JMP  ",   4, 3,   6),	 /* 0x7e */
      new Opcode( "CLR  ",   7, 3,   6),	 /* 0x7f */

      new Opcode( "SUBA ",  2,  2,   2),	/* 0x80 */
      new Opcode( "CMPA ",  2,  2,   2),	/* 0x81 */
      new Opcode( "SBCA ",  2,  2,   2),	/* 0x82 */
      new Opcode( "SUBD ",  4,  3,   3),	/* 0x83 */
      new Opcode( "ANDA ",  2,  2,   2),	/* 0x84 */
      new Opcode( "BITA ",  2,  2,   2),	/* 0x85 */
      new Opcode( "LDA  ",  2,  2,   2),	/* 0x86 */
      new Opcode( "?????",  0,  2,   0),	/* 0x87 */
      new Opcode( "EORA ",  2,  2,   2),	/* 0x88 */
      new Opcode( "ADCA ",  2,  2,   2),	/* 0x89 */
      new Opcode( "ORA  ",  2,  2,   2),	/* 0x8a */
      new Opcode( "ADDA ",  2,  2,   2),	/* 0x8b */
      new Opcode( "CMPX ",  4,  3,   3),	/* 0x8c */
      new Opcode( "BSR  ",  7,  2,   7),	/* 0x8d */
      new Opcode( "LDX  ",  3,  3,   3),	/* 0x8e */
      new Opcode( "?????",  0,  2,   0),	/* 0x8f */

      new Opcode( "SUBA ",  4,  2,   1),	/* 0x90 */
      new Opcode( "CMPA ",  4,  2,   1),	/* 0x91 */
      new Opcode( "SBCA ",  4,  2,   1),	/* 0x92 */
      new Opcode( "SUBD ",  6,  2,   1),	/* 0x93 */
      new Opcode( "ANDA ",  4,  2,   1),	/* 0x94 */
      new Opcode( "BITA ",  4,  2,   1),	/* 0x95 */
      new Opcode( "LDA  ",  4,  2,   1),	/* 0x96 */
      new Opcode( "STA  ",  4,  2,   1),	/* 0x97 */
      new Opcode( "EORA ",  4,  2,   1),	/* 0x98 */
      new Opcode( "ADCA ",  4,  2,   1),	/* 0x99 */
      new Opcode( "ORA  ",  4,  2,   1),	/* 0x9a */
      new Opcode( "ADDA ",  4,  2,   1),	/* 0x9b */
      new Opcode( "CMPX ",  6,  2,   1),	/* 0x9c */
      new Opcode( "JSR  ",  7,  2,   1),	/* 0x9d */
      new Opcode( "LDX  ",  5,  2,   1),	/* 0x9e */
      new Opcode( "STX  ",  5,  2,   1),	/* 0x9f */

      new Opcode( "SUBA ",  4,  2,   5),	/* 0xa0 */
      new Opcode( "CMPA ",  4,  2,   5),	/* 0xa1 */
      new Opcode( "SBCA ",  4,  2,   5),	/* 0xa2 */
      new Opcode( "SUBD ",  6,  2,   5),	/* 0xa3 */
      new Opcode( "ANDA ",  4,  2,   5),	/* 0xa4 */
      new Opcode( "BITA ",  4,  2,   5),	/* 0xa5 */
      new Opcode( "LDA  ",  4,  2,   5),	/* 0xa6 */
      new Opcode( "STA  ",  4,  2,   5),	/* 0xa7 */
      new Opcode( "EORA ",  4,  2,   5),	/* 0xa8 */
      new Opcode( "ADCA ",  4,  2,   5),	/* 0xa9 */
      new Opcode( "ORA  ",  4,  2,   5),	/* 0xaa */
      new Opcode( "ADDA ",  4,  2,   5),	/* 0xab */
      new Opcode( "CMPX ",  6,  2,   5),	/* 0xac */
      new Opcode( "JSR  ",  7,  2,   5),	/* 0xad */
      new Opcode( "LDX  ",  5,  2,   5),	/* 0xae */
      new Opcode( "STX  ",  5,  2,   5),	/* 0xaf */

      new Opcode( "SUBA ",  5,  3,   6),	/* 0xb0 */
      new Opcode( "CMPA ",  5,  3,   6),	/* 0xb1 */
      new Opcode( "SBCA ",  5,  3,   6),	/* 0xb2 */
      new Opcode( "SUBD ",  7,  3,   6),	/* 0xb3 */
      new Opcode( "ANDA ",  5,  3,   6),	/* 0xb4 */
      new Opcode( "BITA ",  5,  3,   6),	/* 0xb5 */
      new Opcode( "LDA  ",  5,  3,   6),	/* 0xb6 */
      new Opcode( "STA  ",  5,  3,   6),	/* 0xb7 */
      new Opcode( "EORA ",  5,  3,   6),	/* 0xb8 */
      new Opcode( "ADCA ",  5,  3,   6),	/* 0xb9 */
      new Opcode( "ORA  ",  5,  3,   6),	/* 0xba */
      new Opcode( "ADDA ",  5,  3,   6),	/* 0xbb */
      new Opcode( "CMPX ",  7,  3,   6),	/* 0xbc */
      new Opcode( "JSR  ",  8,  3,   6),	/* 0xbd */
      new Opcode( "LDX  ",  6,  3,   6),	/* 0xbe */
      new Opcode( "STX  ",  6,  3,   6),	/* 0xbf */

      new Opcode( "SUBB ",  2,  2,   2),	/* 0xc0 */
      new Opcode( "CMPB ",  2,  2,   2),	/* 0xc1 */
      new Opcode( "SBCB ",  2,  2,   2),	/* 0xc2 */
      new Opcode( "ADDD ",  4,  3,   3),	/* 0xc3 */
      new Opcode( "ANDB ",  2,  2,   2),	/* 0xc4 */
      new Opcode( "BITB ",  2,  2,   2),	/* 0xc5 */
      new Opcode( "LDB  ",  2,  2,   2),	/* 0xc6 */
      new Opcode( "?????",  0,  1,   0),	/* 0xc7 */
      new Opcode( "EORB ",  2,  2,   2),	/* 0xc8 */
      new Opcode( "ADCB ",  2,  2,   2),	/* 0xc9 */
      new Opcode( "ORB  ",  2,  2,   2),	/* 0xca */
      new Opcode( "ADDB ",  2,  2,   2),	/* 0xcb */
      new Opcode( "LDD  ",  3,  3,   3),	/* 0xcc */
      new Opcode( "?????",  0,  1,   0),	/* 0xcd */
      new Opcode( "LDU  ",  3,  3,   3),	/* 0xce */
      new Opcode( "?????",  0,  1,   0),	/* 0xcf */

      new Opcode( "SUBB ",  4,  2,   1),	/* 0xd0 */
      new Opcode( "CMPB ",  4,  2,   1),	/* 0xd1 */
      new Opcode( "SBCB ",  4,  2,   1),	/* 0xd2 */
      new Opcode( "ADDD ",  6,  2,   1),	/* 0xd3 */
      new Opcode( "ANDB ",  4,  2,   1),	/* 0xd4 */
      new Opcode( "BITB ",  4,  2,   1),	/* 0xd5 */
      new Opcode( "LDB  ",  4,  2,   1),	/* 0xd6 */
      new Opcode( "STB  ",  4,  2,   1),	/* 0xd7 */
      new Opcode( "EORB ",  4,  2,   1),	/* 0xd8 */
      new Opcode( "ADCB ",  4,  2,   1),	/* 0xd9 */
      new Opcode( "ORB  ",  4,  2,   1),	/* 0xda */
      new Opcode( "ADDB ",  4,  2,   1),	/* 0xdb */
      new Opcode( "LDD  ",  5,  2,   1),	/* 0xdc */
      new Opcode( "STD  ",  5,  2,   1),	/* 0xdd */
      new Opcode( "LDU  ",  5,  2,   1),	/* 0xde */
      new Opcode( "STU  ",  5,  2,   1),	/* 0xdf */

      new Opcode( "SUBB ",  4,  2,   5),	   /* 0xe0 */
      new Opcode( "CMPB ",  4,  2,   5),	   /* 0xe1 */
      new Opcode( "SBCB ",  4,  2,   5),	   /* 0xe2 */
      new Opcode( "ADDD ",  6,  2,   5),  	   /* 0xe3 */
      new Opcode( "ANDB ",  4,  2,   5),	   /* 0xe4 */
      new Opcode( "BITB ",  4,  2,   5),	   /* 0xe5 */
      new Opcode( "LDB  ",  4,  2,   5),	   /* 0xe6 */
      new Opcode( "STB  ",  4,  2,   5),	   /* 0xe7 */
      new Opcode( "EORB ",  4,  2,   5),	   /* 0xe8 */
      new Opcode( "ADCB ",  4,  2,   5),	   /* 0xe9 */
      new Opcode( "ORB  ",  4,  2,   5),	   /* 0xea */
      new Opcode( "ADDB ",  4,  2,   5),	   /* 0xeb */
      new Opcode( "LDD  ",  5,  2,   5),	   /* 0xec */
      new Opcode( "STD  ",  5,  2,   5),	   /* 0xed */
      new Opcode( "LDU  ",  5,  2,   5),	   /* 0xee */
      new Opcode( "STU  ",  5,  2,   5),	   /* 0xef */

      new Opcode( "SUBB ",  5,  3,   6),	   /* 0xf0 */
      new Opcode( "CMPB ",  5,  3,   6),	   /* 0xf1 */
      new Opcode( "SBCB ",  5,  3,   6),	   /* 0xf2 */
      new Opcode( "ADDD ",  7,  3,   6),	   /* 0xf3 */
      new Opcode( "ANDB ",  5,  3,   6),	   /* 0xf4 */
      new Opcode( "BITB ",  5,  3,   6),	   /* 0xf5 */
      new Opcode( "LDB  ",  5,  3,   6),	   /* 0xf6 */
      new Opcode( "STB  ",  5,  3,   6),	   /* 0xf7 */
      new Opcode( "EORB ",  5,  3,   6),	   /* 0xf8 */
      new Opcode( "ADCB ",  5,  3,   6),	   /* 0xf9 */
      new Opcode( "ORB  ",  5,  3,   6),	   /* 0xfa */
      new Opcode( "ADDB ",  5,  3,   6),	   /* 0xfb */
      new Opcode( "LDD  ",  6,  3,   6),	   /* 0xfc */
      new Opcode( "STD  ",  6,  3,   6),	   /* 0xfd */
      new Opcode( "LDU  ",  6,  3,   6),	   /* 0xfe */
      new Opcode( "STU  ",  6,  3,   6),   	   /* 0xff */
    };

    private final Opcode[] optable10 = {
      new Opcode( "?????",  0,  1,   0),        /* 0x00 */
      new Opcode( "?????",  0,  1,   0),	   /* 0x01 */
      new Opcode( "?????",  0,  1,   0),	   /* 0x02 */
      new Opcode( "?????",  0,  1,   0),        /* 0x03 */
      new Opcode( "?????",  0,  1,   0),        /* 0x04 */
      new Opcode( "?????",  0,  1,   0),	   /* 0x05 */
      new Opcode( "?????",  0,  1,   0),        /* 0x06 */
      new Opcode( "?????",  0,  1,   0),        /* 0x07 */
      new Opcode( "?????",  0,  1,   0),        /* 0x08 */
      new Opcode( "?????",  0,  1,   0),        /* 0x09 */
      new Opcode( "?????",  0,  1,   0),        /* 0x0a */
      new Opcode( "?????",  0,  1,   0),        /* 0x0b */
      new Opcode( "?????",  0,  1,   0),        /* 0x0c */
      new Opcode( "?????",  0,  1,   0),        /* 0x0d */
      new Opcode( "?????",  0,  1,   0),        /* 0x0e */
      new Opcode( "?????",  0,  1,   0),        /* 0x0f */

      new Opcode( "?????",  0,  1,   0),        /* 0x10 */
      new Opcode( "?????",  0,  1,   0),        /* 0x11 */
      new Opcode( "?????",  0,  1,   0),        /* 0x12 */
      new Opcode( "?????",  0,  1,   0),        /* 0x13 */
      new Opcode( "?????",  0,  1,   0),        /* 0x14 */
      new Opcode( "?????",  0,  1,   0),        /* 0x15 */
      new Opcode( "?????",  0,  1,   0),        /* 0x16 */
      new Opcode( "?????",  0,  1,   0),        /* 0x17 */
      new Opcode( "?????",  0,  1,   0),        /* 0x18 */
      new Opcode( "?????",  0,  1,   0),        /* 0x19 */
      new Opcode( "?????",  0,  1,   0),        /* 0x1a */
      new Opcode( "?????",  0,  1,   0),        /* 0x1b */
      new Opcode( "?????",  0,  1,   0),        /* 0x1c */
      new Opcode( "?????",  0,  1,   0),        /* 0x1d */
      new Opcode( "?????",  0,  1,   0),        /* 0x1e */
      new Opcode( "?????",  0,  1,   0),        /* 0x1f */

      new Opcode( "?????",  0,  1,   0),        /* 0x20 */
      new Opcode( "LBRN ",  5,  4,   8),        /* 0x21 */
      new Opcode( "LBHI ",  5,  4,   8),        /* 0x22 */
      new Opcode( "LBLS ",  5,  4,   8),        /* 0x23 */
      new Opcode( "LBCC ",  5,  4,   8),        /* 0x24 */
      new Opcode( "LBCS ",  5,  4,   8),        /* 0x25 */
      new Opcode( "LBNE ",  5,  4,   8),        /* 0x26 */
      new Opcode( "LBEQ ",  5,  4,   8),        /* 0x27 */
      new Opcode( "LBVC ",  5,  4,   8),        /* 0x28 */
      new Opcode( "LBVS ",  5,  4,   8),        /* 0x29 */
      new Opcode( "LBPL ",  5,  4,   8),        /* 0x2a */
      new Opcode( "LBMI ",  5,  4,   8),        /* 0x2b */
      new Opcode( "LBGE ",  5,  4,   8),        /* 0x2c */
      new Opcode( "LBLT ",  5,  4,   8),        /* 0x2d */
      new Opcode( "LBGT ",  5,  4,   8),        /* 0x2e */
      new Opcode( "LBLE ",  5,  4,   8),        /* 0x2f */

      new Opcode( "?????",  0,  1,   0),        /* 0x30 */
      new Opcode( "?????",  0,  1,   0),        /* 0x31 */
      new Opcode( "?????",  0,  1,   0),        /* 0x32 */
      new Opcode( "?????",  0,  1,   0),        /* 0x33 */
      new Opcode( "?????",  0,  1,   0),        /* 0x34 */
      new Opcode( "?????",  0,  1,   0),        /* 0x35 */
      new Opcode( "?????",  0,  1,   0),        /* 0x36 */
      new Opcode( "?????",  0,  1,   0),        /* 0x37 */
      new Opcode( "?????",  0,  1,   0),        /* 0x38 */
      new Opcode( "?????",  0,  1,   0),        /* 0x39 */
      new Opcode( "?????",  0,  1,   0),        /* 0x3a */
      new Opcode( "?????",  0,  1,   0),        /* 0x3b */
      new Opcode( "?????",  0,  1,   0),        /* 0x3c */
      new Opcode( "?????",  0,  1,   0),        /* 0x3d */
      new Opcode( "?????",  0,  1,   0),        /* 0x3e */
    /* Fake SWI2 as an OS9 F$xxx system call */
      new Opcode( "OS9  ",  20, 3,   14),             /* 0x3f */

      new Opcode( "?????",  0,  1,   0),        /* 0x40 */
      new Opcode( "?????",  0,  1,   0),        /* 0x41 */
      new Opcode( "?????",  0,  1,   0),        /* 0x42 */
      new Opcode( "?????",  0,  1,   0),        /* 0x43 */
      new Opcode( "?????",  0,  1,   0),        /* 0x44 */
      new Opcode( "?????",  0,  1,   0),        /* 0x45 */
      new Opcode( "?????",  0,  1,   0),        /* 0x46 */
      new Opcode( "?????",  0,  1,   0),        /* 0x47 */
      new Opcode( "?????",  0,  1,   0),        /* 0x48 */
      new Opcode( "?????",  0,  1,   0),        /* 0x49 */
      new Opcode( "?????",  0,  1,   0),        /* 0x4a */
      new Opcode( "?????",  0,  1,   0),        /* 0x4b */
      new Opcode( "?????",  0,  1,   0),        /* 0x4c */
      new Opcode( "?????",  0,  1,   0),        /* 0x4d */
      new Opcode( "?????",  0,  1,   0),        /* 0x4e */
      new Opcode( "?????",  0,  1,   0),        /* 0x4f */

      new Opcode( "?????",  0,  1,   0),        /* 0x50 */
      new Opcode( "?????",  0,  1,   0),        /* 0x51 */
      new Opcode( "?????",  0,  1,   0),        /* 0x52 */
      new Opcode( "?????",  0,  1,   0),        /* 0x53 */
      new Opcode( "?????",  0,  1,   0),        /* 0x54 */
      new Opcode( "?????",  0,  1,   0),        /* 0x55 */
      new Opcode( "?????",  0,  1,   0),        /* 0x56 */
      new Opcode( "?????",  0,  1,   0),        /* 0x57 */
      new Opcode( "?????",  0,  1,   0),        /* 0x58 */
      new Opcode( "?????",  0,  1,   0),        /* 0x59 */
      new Opcode( "?????",  0,  1,   0),        /* 0x5a */
      new Opcode( "?????",  0,  1,   0),        /* 0x5b */
      new Opcode( "?????",  0,  1,   0),        /* 0x5c */
      new Opcode( "?????",  0,  1,   0),        /* 0x5d */
      new Opcode( "?????",  0,  1,   0),        /* 0x5e */
      new Opcode( "?????",  0,  1,   0),        /* 0x5f */

      new Opcode( "?????",  0,  1,   0),        /* 0x60 */
      new Opcode( "?????",  0,  1,   0),        /* 0x61 */
      new Opcode( "?????",  0,  1,   0),        /* 0x62 */
      new Opcode( "?????",  0,  1,   0),        /* 0x63 */
      new Opcode( "?????",  0,  1,   0),        /* 0x64 */
      new Opcode( "?????",  0,  1,   0),        /* 0x65 */
      new Opcode( "?????",  0,  1,   0),        /* 0x66 */
      new Opcode( "?????",  0,  1,   0),        /* 0x67 */
      new Opcode( "?????",  0,  1,   0),        /* 0x68 */
      new Opcode( "?????",  0,  1,   0),        /* 0x69 */
      new Opcode( "?????",  0,  1,   0),        /* 0x6a */
      new Opcode( "?????",  0,  1,   0),        /* 0x6b */
      new Opcode( "?????",  0,  1,   0),        /* 0x6c */
      new Opcode( "?????",  0,  1,   0),        /* 0x6d */
      new Opcode( "?????",  0,  1,   0),        /* 0x6e */
      new Opcode( "?????",  0,  1,   0),        /* 0x6f */

      new Opcode( "?????",  0,  1,   0),        /* 0x70 */
      new Opcode( "?????",  0,  1,   0),        /* 0x71 */
      new Opcode( "?????",  0,  1,   0),        /* 0x72 */
      new Opcode( "?????",  0,  1,   0),        /* 0x73 */
      new Opcode( "?????",  0,  1,   0),        /* 0x74 */
      new Opcode( "?????",  0,  1,   0),        /* 0x75 */
      new Opcode( "?????",  0,  1,   0),        /* 0x76 */
      new Opcode( "?????",  0,  1,   0),        /* 0x77 */
      new Opcode( "?????",  0,  1,   0),        /* 0x78 */
      new Opcode( "?????",  0,  1,   0),        /* 0x79 */
      new Opcode( "?????",  0,  1,   0),        /* 0x7a */
      new Opcode( "?????",  0,  1,   0),        /* 0x7b */
      new Opcode( "?????",  0,  1,   0),        /* 0x7c */
      new Opcode( "?????",  0,  1,   0),        /* 0x7d */
      new Opcode( "?????",  0,  1,   0),        /* 0x7e */
      new Opcode( "?????",  0,  1,   0),        /* 0x7f */

      new Opcode( "?????",  0,  1,   0),        /* 0x80 */
      new Opcode( "?????",  0,  1,   0),        /* 0x81 */
      new Opcode( "?????",  0,  1,   0),        /* 0x82 */
      new Opcode( "CMPD ",  5,  4,   3),        /* 0x83 */
      new Opcode( "?????",  0,  1,   0),        /* 0x84 */
      new Opcode( "?????",  0,  1,   0),        /* 0x85 */
      new Opcode( "?????",  0,  1,   0),        /* 0x86 */
      new Opcode( "?????",  0,  1,   0),        /* 0x87 */
      new Opcode( "?????",  0,  1,   0),        /* 0x88 */
      new Opcode( "?????",  0,  1,   0),        /* 0x89 */
      new Opcode( "?????",  0,  1,   0),        /* 0x8a */
      new Opcode( "?????",  0,  1,   0),        /* 0x8b */
      new Opcode( "CMPY ",  5,  4,   3),        /* 0x8c */
      new Opcode( "?????",  0,  1,   0),        /* 0x8d */
      new Opcode( "LDY  ",  4,  4,   3),        /* 0x8e */
      new Opcode( "?????",  0,  1,   0),        /* 0x8f */

        new Opcode( "?????",  0,  1,   0),        /* 0x90 */
        new Opcode( "?????",  0,  1,   0),        /* 0x91 */
        new Opcode( "?????",  0,  1,   0),        /* 0x92 */
        new Opcode( "CMPD ",  7,  3,   1),        /* 0x93 */
        new Opcode( "?????",  0,  1,   0),        /* 0x94 */
        new Opcode( "?????",  0,  1,   0),        /* 0x95 */
        new Opcode( "?????",  0,  1,   0),        /* 0x96 */
        new Opcode( "?????",  0,  1,   0),        /* 0x97 */
        new Opcode( "?????",  0,  1,   0),        /* 0x98 */
        new Opcode( "?????",  0,  1,   0),        /* 0x99 */
        new Opcode( "?????",  0,  1,   0),        /* 0x9a */
        new Opcode( "?????",  0,  1,   0),        /* 0x9b */
        new Opcode( "CMPY ",  7,  3,   1),        /* 0x9c */
        new Opcode( "?????",  0,  1,   0),        /* 0x9d */
        new Opcode( "LDY  ",  6,  3,   1),        /* 0x9e */
        new Opcode( "STY  ",  6,  3,   1),        /* 0x9f */

        new Opcode( "?????",  0,  1,   0),        /* 0xa0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa2 */
        new Opcode( "CMPD ",  7,  3,   5),        /* 0xa3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xaa */
        new Opcode( "?????",  0,  1,   0),        /* 0xab */
        new Opcode( "CMPY ",  7,  3,   5),        /* 0xac */
        new Opcode( "?????",  0,  1,   0),        /* 0xad */
        new Opcode( "LDY  ",  6,  3,   5),        /* 0xae */
        new Opcode( "STY  ",  6,  3,   5),        /* 0xaf */

        new Opcode( "?????",  0,  1,   0),        /* 0xb0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb2 */
        new Opcode( "CMPD ",  8,  4,   6),        /* 0xb3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xba */
        new Opcode( "?????",  0,  1,   0),        /* 0xbb */
        new Opcode( "CMPY ",  8,  4,   6),        /* 0xbc */
        new Opcode( "?????",  0,  1,   0),        /* 0xbd */
        new Opcode( "LDY  ",  7,  4,   6),        /* 0xbe */
        new Opcode( "STY  ",  7,  4,   6),        /* 0xbf */

        new Opcode( "?????",  0,  1,   0),        /* 0xc0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xca */
        new Opcode( "?????",  0,  1,   0),        /* 0xcb */
        new Opcode( "?????",  0,  1,   0),        /* 0xcc */
        new Opcode( "?????",  0,  1,   0),        /* 0xcd */
        new Opcode( "LDS  ",  4,  4,   3),        /* 0xce */
        new Opcode( "?????",  0,  1,   0),        /* 0xcf */

        new Opcode( "?????",  0,  1,   0),        /* 0xd0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xda */
        new Opcode( "?????",  0,  1,   0),        /* 0xdb */
        new Opcode( "?????",  0,  1,   0),        /* 0xdc */
        new Opcode( "?????",  0,  1,   0),        /* 0xdd */
        new Opcode( "LDS  ",  6,  3,   1),        /* 0xde */
        new Opcode( "STS  ",  6,  3,   1),        /* 0xdf */

        new Opcode( "?????",  0,  1,   0),        /* 0xe0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xea */
        new Opcode( "?????",  0,  1,   0),        /* 0xeb */
        new Opcode( "?????",  0,  1,   0),        /* 0xec */
        new Opcode( "?????",  0,  1,   0),        /* 0xed */
        new Opcode( "LDS  ",  6,  3,   5),        /* 0xee */
        new Opcode( "STS  ",  6,  3,   5),        /* 0xef */

        new Opcode( "?????",  0,  1,   0),        /* 0xf0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xfa */
        new Opcode( "?????",  0,  1,   0),        /* 0xfb */
        new Opcode( "?????",  0,  1,   0),        /* 0xfc */
        new Opcode( "?????",  0,  1,   0),        /* 0xfd */
        new Opcode( "LDS  ",  7,  4,   6),        /* 0xfe */
        new Opcode( "STS  ",  7,  4,   6),        /* 0xff */

    };


    private final Opcode optable11[] = {
        new Opcode( "?????",  0,  1,   0),        /* 0x00 */
        new Opcode( "?????",  0,  1,   0),        /* 0x01 */
        new Opcode( "?????",  0,  1,   0),        /* 0x02 */
        new Opcode( "?????",  0,  1,   0),        /* 0x03 */
        new Opcode( "?????",  0,  1,   0),        /* 0x04 */
        new Opcode( "?????",  0,  1,   0),        /* 0x05 */
        new Opcode( "?????",  0,  1,   0),        /* 0x06 */
        new Opcode( "?????",  0,  1,   0),        /* 0x07 */
        new Opcode( "?????",  0,  1,   0),        /* 0x08 */
        new Opcode( "?????",  0,  1,   0),        /* 0x09 */
        new Opcode( "?????",  0,  1,   0),        /* 0x0a */
        new Opcode( "?????",  0,  1,   0),        /* 0x0b */
        new Opcode( "?????",  0,  1,   0),        /* 0x0c */
        new Opcode( "?????",  0,  1,   0),        /* 0x0d */
        new Opcode( "?????",  0,  1,   0),        /* 0x0e */
        new Opcode( "?????",  0,  1,   0),        /* 0x0f */

        new Opcode( "?????",  0,  1,   0),        /* 0x10 */
        new Opcode( "?????",  0,  1,   0),        /* 0x11 */
        new Opcode( "?????",  0,  1,   0),        /* 0x12 */
        new Opcode( "?????",  0,  1,   0),        /* 0x13 */
        new Opcode( "?????",  0,  1,   0),        /* 0x14 */
        new Opcode( "?????",  0,  1,   0),        /* 0x15 */
        new Opcode( "?????",  0,  1,   0),        /* 0x16 */
        new Opcode( "?????",  0,  1,   0),        /* 0x17 */
        new Opcode( "?????",  0,  1,   0),        /* 0x18 */
        new Opcode( "?????",  0,  1,   0),        /* 0x19 */
        new Opcode( "?????",  0,  1,   0),        /* 0x1a */
        new Opcode( "?????",  0,  1,   0),        /* 0x1b */
        new Opcode( "?????",  0,  1,   0),        /* 0x1c */
        new Opcode( "?????",  0,  1,   0),        /* 0x1d */
        new Opcode( "?????",  0,  1,   0),        /* 0x1e */
        new Opcode( "?????",  0,  1,   0),        /* 0x1f */

        new Opcode( "?????",  0,  1,   0),        /* 0x20 */
        new Opcode( "?????",  0,  1,   0),        /* 0x21 */
        new Opcode( "?????",  0,  1,   0),        /* 0x22 */
        new Opcode( "?????",  0,  1,   0),        /* 0x23 */
        new Opcode( "?????",  0,  1,   0),        /* 0x24 */
        new Opcode( "?????",  0,  1,   0),        /* 0x25 */
        new Opcode( "?????",  0,  1,   0),        /* 0x26 */
        new Opcode( "?????",  0,  1,   0),        /* 0x27 */
        new Opcode( "?????",  0,  1,   0),        /* 0x28 */
        new Opcode( "?????",  0,  1,   0),        /* 0x29 */
        new Opcode( "?????",  0,  1,   0),        /* 0x2a */
        new Opcode( "?????",  0,  1,   0),        /* 0x2b */
        new Opcode( "?????",  0,  1,   0),        /* 0x2c */
        new Opcode( "?????",  0,  1,   0),        /* 0x2d */
        new Opcode( "?????",  0,  1,   0),        /* 0x2e */
        new Opcode( "?????",  0,  1,   0),        /* 0x2f */

        new Opcode( "?????",  0,  1,   0),        /* 0x30 */
        new Opcode( "?????",  0,  1,   0),        /* 0x31 */
        new Opcode( "?????",  0,  1,   0),        /* 0x32 */
        new Opcode( "?????",  0,  1,   0),        /* 0x33 */
        new Opcode( "?????",  0,  1,   0),        /* 0x34 */
        new Opcode( "?????",  0,  1,   0),        /* 0x35 */
        new Opcode( "?????",  0,  1,   0),        /* 0x36 */
        new Opcode( "?????",  0,  1,   0),        /* 0x37 */
        new Opcode( "?????",  0,  1,   0),        /* 0x38 */
        new Opcode( "?????",  0,  1,   0),        /* 0x39 */
        new Opcode( "?????",  0,  1,   0),        /* 0x3a */
        new Opcode( "?????",  0,  1,   0),        /* 0x3b */
        new Opcode( "?????",  0,  1,   0),        /* 0x3c */
        new Opcode( "?????",  0,  1,   0),        /* 0x3d */
        new Opcode( "?????",  0,  1,   0),        /* 0x3e */
        new Opcode( "SWI3 ",  20, 2,   4),        /* 0x3f */

        new Opcode( "?????",  0,  1,   0),        /* 0x40 */
        new Opcode( "?????",  0,  1,   0),        /* 0x41 */
        new Opcode( "?????",  0,  1,   0),        /* 0x42 */
        new Opcode( "?????",  0,  1,   0),        /* 0x43 */
        new Opcode( "?????",  0,  1,   0),        /* 0x44 */
        new Opcode( "?????",  0,  1,   0),        /* 0x45 */
        new Opcode( "?????",  0,  1,   0),        /* 0x46 */
        new Opcode( "?????",  0,  1,   0),        /* 0x47 */
        new Opcode( "?????",  0,  1,   0),        /* 0x48 */
        new Opcode( "?????",  0,  1,   0),        /* 0x49 */
        new Opcode( "?????",  0,  1,   0),        /* 0x4a */
        new Opcode( "?????",  0,  1,   0),        /* 0x4b */
        new Opcode( "?????",  0,  1,   0),        /* 0x4c */
        new Opcode( "?????",  0,  1,   0),        /* 0x4d */
        new Opcode( "?????",  0,  1,   0),        /* 0x4e */
        new Opcode( "?????",  0,  1,   0),        /* 0x4f */

        new Opcode( "?????",  0,  1,   0),        /* 0x50 */
        new Opcode( "?????",  0,  1,   0),        /* 0x51 */
        new Opcode( "?????",  0,  1,   0),        /* 0x52 */
        new Opcode( "?????",  0,  1,   0),        /* 0x53 */
        new Opcode( "?????",  0,  1,   0),        /* 0x54 */
        new Opcode( "?????",  0,  1,   0),        /* 0x55 */
        new Opcode( "?????",  0,  1,   0),        /* 0x56 */
        new Opcode( "?????",  0,  1,   0),        /* 0x57 */
        new Opcode( "?????",  0,  1,   0),        /* 0x58 */
        new Opcode( "?????",  0,  1,   0),        /* 0x59 */
        new Opcode( "?????",  0,  1,   0),        /* 0x5a */
        new Opcode( "?????",  0,  1,   0),        /* 0x5b */
        new Opcode( "?????",  0,  1,   0),        /* 0x5c */
        new Opcode( "?????",  0,  1,   0),        /* 0x5d */
        new Opcode( "?????",  0,  1,   0),        /* 0x5e */
        new Opcode( "?????",  0,  1,   0),        /* 0x5f */

        new Opcode( "?????",  0,  1,   0),        /* 0x60 */
        new Opcode( "?????",  0,  1,   0),        /* 0x61 */
        new Opcode( "?????",  0,  1,   0),        /* 0x62 */
        new Opcode( "?????",  0,  1,   0),        /* 0x63 */
        new Opcode( "?????",  0,  1,   0),        /* 0x64 */
        new Opcode( "?????",  0,  1,   0),        /* 0x65 */
        new Opcode( "?????",  0,  1,   0),        /* 0x66 */
        new Opcode( "?????",  0,  1,   0),        /* 0x67 */
        new Opcode( "?????",  0,  1,   0),        /* 0x68 */
        new Opcode( "?????",  0,  1,   0),        /* 0x69 */
        new Opcode( "?????",  0,  1,   0),        /* 0x6a */
        new Opcode( "?????",  0,  1,   0),        /* 0x6b */
        new Opcode( "?????",  0,  1,   0),        /* 0x6c */
        new Opcode( "?????",  0,  1,   0),        /* 0x6d */
        new Opcode( "?????",  0,  1,   0),        /* 0x6e */
        new Opcode( "?????",  0,  1,   0),        /* 0x6f */

        new Opcode( "?????",  0,  1,   0),        /* 0x70 */
        new Opcode( "?????",  0,  1,   0),        /* 0x71 */
        new Opcode( "?????",  0,  1,   0),        /* 0x72 */
        new Opcode( "?????",  0,  1,   0),        /* 0x73 */
        new Opcode( "?????",  0,  1,   0),        /* 0x74 */
        new Opcode( "?????",  0,  1,   0),        /* 0x75 */
        new Opcode( "?????",  0,  1,   0),        /* 0x76 */
        new Opcode( "?????",  0,  1,   0),        /* 0x77 */
        new Opcode( "?????",  0,  1,   0),        /* 0x78 */
        new Opcode( "?????",  0,  1,   0),        /* 0x79 */
        new Opcode( "?????",  0,  1,   0),        /* 0x7a */
        new Opcode( "?????",  0,  1,   0),        /* 0x7b */
        new Opcode( "?????",  0,  1,   0),        /* 0x7c */
        new Opcode( "?????",  0,  1,   0),        /* 0x7d */
        new Opcode( "?????",  0,  1,   0),        /* 0x7e */
        new Opcode( "?????",  0,  1,   0),        /* 0x7f */

        new Opcode( "?????",  0,  1,   0),        /* 0x80 */
        new Opcode( "?????",  0,  1,   0),        /* 0x81 */
        new Opcode( "?????",  0,  1,   0),        /* 0x82 */
        new Opcode( "CMPU ",  5,  4,   3),        /* 0x83 */
        new Opcode( "?????",  0,  1,   0),        /* 0x84 */
        new Opcode( "?????",  0,  1,   0),        /* 0x85 */
        new Opcode( "?????",  0,  1,   0),        /* 0x86 */
        new Opcode( "?????",  0,  1,   0),        /* 0x87 */
        new Opcode( "?????",  0,  1,   0),        /* 0x88 */
        new Opcode( "?????",  0,  1,   0),        /* 0x89 */
        new Opcode( "?????",  0,  1,   0),        /* 0x8a */
        new Opcode( "?????",  0,  1,   0),        /* 0x8b */
        new Opcode( "CMPS ",  5,  4,   3),        /* 0x8c */
        new Opcode( "?????",  0,  1,   0),        /* 0x8d */
        new Opcode( "?????",  0,  1,   0),        /* 0x8e */
        new Opcode( "?????",  0,  1,   0),        /* 0x8f */

        new Opcode( "?????",  0,  1,   0),        /* 0x90 */
        new Opcode( "?????",  0,  1,   0),        /* 0x91 */
        new Opcode( "?????",  0,  1,   0),        /* 0x92 */
        new Opcode( "CMPU ",  7,  3,   1),        /* 0x93 */
        new Opcode( "?????",  0,  1,   0),        /* 0x94 */
        new Opcode( "?????",  0,  1,   0),        /* 0x95 */
        new Opcode( "?????",  0,  1,   0),        /* 0x96 */
        new Opcode( "?????",  0,  1,   0),        /* 0x97 */
        new Opcode( "?????",  0,  1,   0),        /* 0x98 */
        new Opcode( "?????",  0,  1,   0),        /* 0x99 */
        new Opcode( "?????",  0,  1,   0),        /* 0x9a */
        new Opcode( "?????",  0,  1,   0),        /* 0x9b */
        new Opcode( "CMPS ",  7,  3,   1),        /* 0x9c */
        new Opcode( "?????",  0,  1,   0),        /* 0x9d */
        new Opcode( "?????",  0,  1,   0),        /* 0x9e */
        new Opcode( "?????",  0,  1,   0),        /* 0x9f */

        new Opcode( "?????",  0,  1,   0),        /* 0xa0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa2 */
        new Opcode( "CMPU ",  7,  3,   5),        /* 0xa3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xa9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xaa */
        new Opcode( "?????",  0,  1,   0),        /* 0xab */
        new Opcode( "CMPS ",  7,  3,   5),        /* 0xac */
        new Opcode( "?????",  0,  1,   0),        /* 0xad */
        new Opcode( "?????",  0,  1,   0),        /* 0xae */
        new Opcode( "?????",  0,  1,   0),        /* 0xaf */

        new Opcode( "?????",  0,  1,   0),        /* 0xb0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb2 */
        new Opcode( "CMPU ",  8,  4,   6),        /* 0xb3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xb9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xba */
        new Opcode( "?????",  0,  1,   0),        /* 0xbb */
        new Opcode( "CMPS ",  8,  4,   6),        /* 0xbc */
        new Opcode( "?????",  0,  1,   0),        /* 0xbd */
        new Opcode( "?????",  0,  1,   0),        /* 0xbe */
        new Opcode( "?????",  0,  1,   0),        /* 0xbf */

        new Opcode( "?????",  0,  1,   0),        /* 0xc0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xc9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xca */
        new Opcode( "?????",  0,  1,   0),        /* 0xcb */
        new Opcode( "?????",  0,  1,   0),        /* 0xcc */
        new Opcode( "?????",  0,  1,   0),        /* 0xcd */
        new Opcode( "?????",  0,  1,   0),        /* 0xce */
        new Opcode( "?????",  0,  1,   0),        /* 0xcf */

        new Opcode( "?????",  0,  1,   0),        /* 0xd0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xd9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xda */
        new Opcode( "?????",  0,  1,   0),        /* 0xdb */
        new Opcode( "?????",  0,  1,   0),        /* 0xdc */
        new Opcode( "?????",  0,  1,   0),        /* 0xdd */
        new Opcode( "?????",  0,  1,   0),        /* 0xde */
        new Opcode( "?????",  0,  1,   0),        /* 0xdf */

        new Opcode( "?????",  0,  1,   0),        /* 0xe0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xe9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xea */
        new Opcode( "?????",  0,  1,   0),        /* 0xeb */
        new Opcode( "?????",  0,  1,   0),        /* 0xec */
        new Opcode( "?????",  0,  1,   0),        /* 0xed */
        new Opcode( "?????",  0,  1,   0),        /* 0xee */
        new Opcode( "?????",  0,  1,   0),        /* 0xef */

        new Opcode( "?????",  0,  1,   0),        /* 0xf0 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf1 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf2 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf3 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf4 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf5 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf6 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf7 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf8 */
        new Opcode( "?????",  0,  1,   0),        /* 0xf9 */
        new Opcode( "?????",  0,  1,   0),        /* 0xfa */
        new Opcode( "?????",  0,  1,   0),        /* 0xfb */
        new Opcode( "?????",  0,  1,   0),        /* 0xfc */
        new Opcode( "?????",  0,  1,   0),        /* 0xfd */
        new Opcode( "?????",  0,  1,   0),        /* 0xfe */
        new Opcode( "?????",  0,  1,   0),        /* 0xff */
    };

    private final static int[] iotable = {
        0x0000,
        0x0001,
        0x0002,
        0x0003,
        0x0008,
        0x0009,
        0x000a,
        0x000b,
        0x000c,
        0x000d,
        0x000e,
        0x0010,
        0x0011,
        0x0012,
        0x0013,
        0x0014,
        0x8000,
        0x8001,
        0x8002,
        0x8003,
        0x8004,
        0x8005,
        0x8006,
        0x8007,
        0x8008,
        0x8009,
        0x800a,
        0x800b,
        0x800c,
        0x800d,
        0x800e,
        0x800f,
    };

    private final static String[] iocomment = {
        "Data direction register port 1",
        "Data direction register port 2",
        "I/O register port 1",
        "I/O register port 2",
        "Timer control and status",
        "Counter high byte",
        "Counter low byte",
        "Output compare high byte",
        "Output compare low byte",
        "Input capture high byte",
        "Input capture low byte",
        "Serial rate and mode register",
        "Serial control and status register",
        "Serial receiver data register",
        "Serial transmit data register",
        "Ram control register",
        "Modem port 0",
        "Modem port 1",
        "Modem port 2",
        "Modem port 3",
        "Modem port 4",
        "Modem port 5",
        "Modem port 6",
        "Modem port 7",
        "Modem port 8",
        "Modem port 9",
        "Modem port 10",
        "Modem port 11",
        "Modem port 12",
        "Modem port 13",
        "Modem port 14",
        "Modem port 15",
    };

    private final static String[] os9opcodes = {
      "00 - F$Link",   "01 - F$Load",  "02 - F$UnLink", "03 - F$Fork",
      "04 - F$Wait",   "05 - F$Chain", "06 - F$Exit",   "07 - F$Mem",
      "08 - F$Send",   "09 - F$Icpt",  "0A - F$Sleep",  "0B - F$SSpd",
      "0C - F$ID",     "0D - F$SPrior", "0E - F$SSWI", "0F - F$Perr",

      "10 - F$PrsNam", "11 - F$CmpNam",  "12 - F$SchBit", "13 - F$AllBit",
      "14 - F$DelBit", "15 - F$Time",    "16 - F$STime", "17 - F$CRC",
      "18 - F$GPrDsc", "19 - F$GBlkMap", "1A - F$GModDr", "1B - F$CpyMem",
      "1C - F$SUser",  "1D - F$UnLoad", "1E", "1F",

      "20", "21", "22", "23",
      "24", "25", "26", "27",
      "28 - F$SRqMem", "29 - F$SRtMem", "2A - F$IRQ", "2B - F$IOQu",
      "2C - F$AProc",  "2D - F$NProc", "2E", "2F",

      "30", "31", "32", "33",
      "34", "35", "36", "37",
      "38", "39", "3A", "3B",
      "3C", "3D", "3E", "3F",

      "40", "41", "42", "43",
      "44", "45", "46", "47",
      "48", "49", "4A", "4B",
      "4C", "4D", "4E", "4F",

      "50", "51", "52", "53",
      "54", "55", "56", "57",
      "58", "59", "5A", "5B",
      "5C", "5D", "5E", "5F",

      "60", "61", "62", "63",
      "64", "65", "66", "67",
      "68", "69", "6A", "6B",
      "6C", "6D", "6E", "6F",

      "70", "71", "72", "73",
      "74", "75", "76", "77",
      "78", "79", "7A", "7B",
      "7C", "7D", "7E", "7F",

      "80 - I$Attach", "81 - I$Detach", "82 - I$Dup", "83",
      "84", "85", "86", "87",
      "88 - I$Seek", "89 - I$Read", "8A - I$Write", "8B - I$ReadLn",
      "8C - I$WritLn", "8D - I$GetStt", "8E - I$SetStt", "8F - I$Close",

      "90 - I$DeleteX", "91", "92", "93",
      "94", "95", "96", "97",
      "98", "99", "9A", "9B",
      "9C", "9D", "9E", "9F"
    };

    final String[] Inter_Register={"D","X","Y","U","S","PC","??","??","A","B","CC","DP","??","??","??","??"};

    final String[] Indexed_Register={"X","Y","U","S"};


    private final int  lastio = 32;

    public DisAssembler(MC6809 cpu) {
        this.cpu = cpu;
    }

    int readMemory(int loc) {
        return cpu.read(loc);
    }

    int read_word(int loc) {
        return cpu.read_word(loc);
    }

    void output(String format, Object... arguments) {
        System.err.format(format, arguments);
    }

    int D_Illegal(Opcode op, int code, int pcLoc, final String suffix) {
        output("%02X          %s%s", code, suffix, op.name);
        return op.bytes;
    }

    int D_Direct(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;

        offset = readMemory(pcLoc+1);
        output("%02X %02X       %s%s       $%02X",
               code, offset, suffix, op.name, offset);
        return op.bytes;
    }

    int D_Page10(Opcode op, int code, int pcLoc, final String suffix) {
        output("10 ");
        code = readMemory(pcLoc+1);
        return opcodeSwitch(optable10, code, pcLoc+1, "");
    }

    int D_Page11(Opcode op, int code, int pcLoc, final String suffix) {
        output("11 ");
        code = readMemory(pcLoc+1);
        return opcodeSwitch(optable11, code, pcLoc+1, "");
    }

    int D_Immediat(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;

        offset = readMemory(pcLoc+1);
        output("%02X %02X       %s%s       #$%02X",
              code, offset, suffix, op.name, offset);
        return op.bytes;
    }

    int D_ImmediatL(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;

        offset = readMemory(pcLoc+1) * 256 + readMemory(pcLoc+2);
        output("%02X %02X %02X    %s%s       #$%04X",
              code, readMemory(pcLoc+1), readMemory(pcLoc+2), suffix, op.name, offset);
        return op.bytes;
    }

    int D_Inherent(Opcode op, int code, int pcLoc, final String suffix) {
        output("%02X          %s%-16s", code, suffix, op.name);
        return op.bytes;
    }

    private int D_OS9(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;

        offset = readMemory(pcLoc+1);

        output("%02X %02X       %s%s %10s",
              code, offset, suffix, op.name, os9opcodes[readMemory(pcLoc + 1)]);
        return op.bytes;
    }

    final String IndexRegister(int postbyte) {
        return Indexed_Register[ (postbyte>>5) & 0x03];
    }

    private int D_Indexed(Opcode op, int code, int pcLoc, final String suffix) {
        int postbyte;
        final String prefix;
        int extrabytes;
        int disp;
        int address;
        int offset;

        extrabytes = 0;
        postbyte = readMemory(pcLoc+1);
        if ((postbyte & 0x80) == 0x00) {
            disp = postbyte & 0x1f;
            if ((postbyte & 0x10) == 0x10) {
                      prefix = "-";
                      disp = 0x20 - disp;
            } else
               prefix = "+";
            output("%02X %02X       %s%s       %s$%02X,%s",
                              code, postbyte, suffix, op.name, prefix, disp, IndexRegister(postbyte));
        } else {
               switch(postbyte & 0x1f) {
               case 0x00 :
                      output("%02X %02X       %s%s       ,%s+",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x01 :
                      output("%02X %02X       %s%s       ,%s++",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x02 :
                      output("%02X %02X       %s%s       ,-%s",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x03 :
                      output("%02X %02X       %s%s       ,--%s",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x04 :
                      output("%02X %02X       %s%s       ,%s",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x05 :
                      output("%02X %02X       %s%s       B,%s",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x06 :
                      output("%02X %02X       %s%s       A,%s",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x07 :
                      break;
               case 0x08 :
                      offset = readMemory(pcLoc+2);
                      if (offset < 128)
                        prefix = "+";
                      else {
                        prefix = "-";
                        offset = 0x0100-offset;
                      }
                      output("%02X %02X %02X    %s%s       %s$%02X,%s",
                              code, postbyte, readMemory(pcLoc+2), suffix, op.name, prefix, offset,
                      IndexRegister(postbyte));
                      extrabytes=1;
                      break;
               case 0x09 :
                      offset = readMemory(pcLoc+2) * 256 + readMemory(pcLoc+3);
                      if (offset < 32768)
                              prefix = "+";
                      else {
                        prefix = "-";
                        offset = 0xffff-offset+1;
                      }
                      output("%02X %02X %02X %02X %s%s       %s$%04X,%s",
                              code, postbyte, readMemory(pcLoc+2), readMemory(pcLoc+3), suffix, op.name, prefix, offset,
                      IndexRegister(postbyte));
                      extrabytes=2;
                      break;
               case 0x0a :
                      break;
               case 0x0b :
                      output("%02X %02X       %s%s       D,%s",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x0c :
                      offset = ((readMemory(pcLoc+2))+pcLoc+3) & 0xFFFF;
                      prefix = "<";
                      output("%02X %02X %02X    %s%s       %s$%02X,PCR",
                                        code, postbyte, readMemory(pcLoc+2), suffix, op.name, prefix, offset);
                      extrabytes = 1;
                      break;
               case 0x0d :
                      offset = (readMemory(pcLoc+2) * 256 + readMemory(pcLoc+3)+pcLoc+4) & 0xFFFF;
                      prefix = ">";
                      output("%02X %02X %02X %02X %s%s       %s$%04X,PCR",
                                        code, postbyte, readMemory(pcLoc+2), readMemory(pcLoc+3), suffix, op.name, prefix, offset);
                      extrabytes = 2;
                      break;
               case 0x0e :
                      break;
               case 0x0f :
                      output("%02X %02X       %s?????",
                                        code, postbyte, suffix);
                      break;
               case 0x10 :
                      output("%02X %02X       %s?????",
                                        code, postbyte, suffix);
                      break;
               case 0x11 :
                      output("%02X %02X       %s%s       [,%s++]",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x12 :
                      output("%02X %02X       %s?????",
                                        code, postbyte, suffix);
                      break;
               case 0x13 :
                      output("%02X %02X       %s%s       [,--%s]",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x14 :
                      output("%02X %02X       %s%s       [,%s]",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x15 :
                      output("%02X %02X       %s%s       [B,%s]",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x16 :
                      output("%02X %02X       %s%s       [A,%s]",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x17 :
                      break;
               case 0x18 :
                      offset = readMemory(pcLoc+2);
                      if (offset < 128)
                          prefix = "+";
                      else {
                          prefix = "-";
                          offset = 0x0100-offset;
                      }
                      output("%02X %02X %02X    %s%s       [%s$%02X,%s]",
                              code, postbyte, readMemory(pcLoc+2), suffix, op.name, prefix, offset,
                      IndexRegister(postbyte));
                      break;
               case 0x19 :
                      offset = readMemory(pcLoc+2) * 256 + readMemory(pcLoc+3);
                      if (offset < 32768)
                          prefix = "+";
                      else {
                          prefix = "-";
                          offset = 0xffff-offset+1;
                      }
                      output("%02X %02X %02X %02X %s%s       %s$%04X,%s",
                              code, postbyte, readMemory(pcLoc+2), readMemory(pcLoc+3), suffix, op.name, prefix, offset,
                      IndexRegister(postbyte));
                      break;
               case 0x1a :
                      break;
               case 0x1b :
                      output("%02X %02X       %s%s       [D,%s]",
                                        code, postbyte, suffix, op.name, IndexRegister(postbyte));
                      break;
               case 0x1c :
                      offset = (readMemory(pcLoc+2)+pcLoc+3) & 0xFFFF;
                      prefix = "<";
                      output("%02X %02X %02X    %s%s       [%s$%02X,PCR]",
                                        code, postbyte, readMemory(pcLoc+2), suffix, op.name, prefix, offset);
                      extrabytes = 1;
                      break;
               case 0x1d :
                      offset = (readMemory(pcLoc+2) * 256 + readMemory(pcLoc+3)+pcLoc+4) & 0xFFFF;
                      prefix = ">";
                      output("%02X %02X %02X %02X %s%s       [%s$%04X,PCR]",
                                        code, postbyte, readMemory(pcLoc+2), readMemory(pcLoc+3), suffix, op.name, prefix, offset);
                      extrabytes = 2;
                      break;
               case 0x1e :
                      break;
               case 0x1f :
                      address = readMemory(pcLoc+2) * 256 + readMemory(pcLoc+3);
                      extrabytes = 2;
                      output("%02X %02X %02X %02X %s%s       [$%04X]",
                                        code, postbyte, readMemory(pcLoc+2), readMemory(pcLoc+3), suffix, op.name, address);
                      break;
               }
        }
        return op.bytes + extrabytes;
    }

    private int D_Extended(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;

        offset = readMemory(pcLoc+1) * 256 + readMemory(pcLoc+2);
        output("%02X %02X %02X    %s%s       $%04X",
              code, readMemory(pcLoc+1), readMemory(pcLoc+2), suffix, op.name, offset);
        return op.bytes;
    }

    private int D_Relative(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;
        int disp;

        offset = readMemory(pcLoc+1);
        if (offset < 127 )
               disp   = pcLoc + 2 + offset;
        else
               disp   = pcLoc + 2 - (256 - offset);
        output("%02X %02X       %s%s       $%04X",
              code, offset, suffix, op.name, disp);
        return op.bytes;
    }

    private int D_RelativeL(Opcode op, int code, int pcLoc, final String suffix) {
        int offset;
        int disp;

        offset = readMemory(pcLoc+1) * 256 + readMemory(pcLoc+2);
        if (offset < 32767 )
               disp   = pcLoc + 3 + offset;
        else
               disp   = pcLoc + 3 - (65536 - offset);
        output("%02X %02X %02X    %s%s       $%04X",
              code, readMemory(pcLoc+1), readMemory(pcLoc+2), suffix, op.name, disp);
        return op.bytes;
    }

    private int D_Register0(Opcode op, int code, int pcLoc, final String suffix) {
        int postbyte;

        postbyte = readMemory(pcLoc+1);

        output("%02X %02X       %s%s       %s,%s",
              code, postbyte, suffix, op.name, Inter_Register[postbyte>>4], Inter_Register[postbyte & 0x0F]);


        return op.bytes;
    }

    private int D_Register1(Opcode op, int code, int pcLoc, final String suffix) {
        int postbyte;
        int i;
        int flag = 0;
        final String[] s_stack = {"PC","U","Y","X","DP","B","A","CC"};
        final int[] bits = {0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01};

        postbyte = readMemory(pcLoc+1);

        output("%02X %02X       %s%s       ",
              code, postbyte, suffix, op.name);

        for(i = 0;i<8;i++) {
            if ((postbyte & bits[i]) != 0) {
                if (flag != 0) {
                    output(",");
                } else {
                    flag = 1;
                }
                output(s_stack[i]);
            }
        }
        return op.bytes;
    }

    private int D_Register2(Opcode op, int code, int pcLoc, final String suffix) {
        int postbyte;
        int i;
        int flag = 0;
        final String[] u_stack = {"PC","S","Y","X","DP","B","A","CC"};
        final int[] bits = {0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01};

        postbyte = readMemory(pcLoc+1);
        output("%02X %02X       %s%s       ",
              code, postbyte, suffix, op.name);

        for(i = 0;i<8;i++) {
          if ((postbyte & bits[i]) != 0) {
            if (flag != 0) {
              output(",");
            } else {
              flag=1;
            }
            output(u_stack[i]);
          }
        }
        return op.bytes;
    }


    private int opcodeSwitch(Opcode[] optable, int code, int programCounter, final String suffix) {
        int offset = -1;

        switch (optable[code].display) {
                case 0:
                    offset = D_Illegal(optable[code], code, programCounter, suffix);
                    break;
                case 1:
                    offset = D_Direct(optable[code], code, programCounter, suffix);
                    break;
                case 2:
                    offset = D_Immediat(optable[code], code, programCounter, suffix);
                    break;
                case 3:
                    offset = D_ImmediatL(optable[code], code, programCounter, suffix);
                    break;
                case 4:
                    offset = D_Inherent(optable[code], code, programCounter, suffix);
                    break;
                case 5:
                    offset = D_Indexed(optable[code], code, programCounter, suffix);
                    break;
                case 6:
                    offset = D_Extended(optable[code], code, programCounter, suffix);
                    break;
                case 7:
                    offset = D_Relative(optable[code], code, programCounter, suffix);
                    break;
                case 8:
                    offset = D_RelativeL(optable[code], code, programCounter, suffix);
                    break;
                case 9:
                    offset = D_Register0(optable[code], code, programCounter, suffix);
                    break;
                case 10:
                    offset = D_Register1(optable[code], code, programCounter, suffix);
                    break;
                case 11:
                    offset = D_Register2(optable[code], code, programCounter, suffix);
                    break;
                case 12:
                    offset = D_Page10(optable[code], code, programCounter, suffix);
                    break;
                case 13:
                    offset = D_Page11(optable[code], code, programCounter, suffix);
                    break;
                case 14:
                    offset = D_OS9(optable[code], code, programCounter, suffix);
                    break;
            }
            return offset;

    }

    /**
     * Diassemble one instruction.
     */
    void disasmPC() {
        int code;

        code = readMemory(cpu.pc.intValue());
        output("|CC=%02X|A=%02X|B=%02X|X=%04X|Y=%04X|U=%04X|S=%04X|  ",
            cpu.cc.intValue(),
            cpu.a.intValue(), cpu.b.intValue(),
            cpu.x.intValue(), cpu.y.intValue(),
            cpu.u.intValue(), cpu.s.intValue());
        output("%04X: ", cpu.pc.intValue());
        opcodeSwitch(optable, code, cpu.pc.intValue(), "   ");
    }

    /**
     * Disassemble a program.
     */
    void disasm(int start, int end) {
        int programCounter;
        int code;

        for (programCounter = start; programCounter <= end;) {
            code = readMemory(programCounter);
            output("%04X: ", programCounter);
            programCounter += opcodeSwitch(optable, code, programCounter, "   ");
            output("\n");
        }
    }

} 
