#include "cputest.h"

/**
 * Shift a byte at 0x0402, because DP = 0x04.
 */
static void ASRMem() {
    static char instructions[] = { 0x07, 0x02, RTS };
    int result;

    setRegs(0,0,0,0,0);
    setCC(0x00);
    setDP();
    writeDPloc(0x02, 0xF1);
    runinst("ASRMem", instructions);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
    result = readDPloc(0x02);
    assertInt(0xf8, result, "0x02");
}

/**
 * Shift a byte at 0x0402, because DP = 0x04.
 */
static void ASRB() {
    static char instructions[] = { 0x57, RTS };

    setB(0xF2);
    setCC(0x00);
    runinst("ASRB1", instructions);
    assertB(0xF9);
    assertCC(0, CC_C);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);

    setB(0x01);
    runtest("ASRB2");
    assertB(0x00);
    assertCC(1, CC_C);
    assertCC(1, CC_Z);
    assertCC(0, CC_N);
}

/**
 * Test the LSL - Logical Shift Left instruction.
 *  H The affect on the Half-Carry flag is undefined for these instructions.
 *  N The Negative flag is set equal to the new value of bit 7; previously bit 6.
 *  Z The Zero flag is set if the new 8-bit value is zero; cleared otherwise.
 *  V The Overflow flag is set to the Exclusive-OR of the original values of bits 6 and 7.
 *  C The Carry flag receives the value shifted out of bit 7.
 *
 * Logical Shift Left of 0xff in register A
 */
static void LSLA() {
    static char instructions[] = { 0x48, RTS };
    setCC(0);
    setA(0xFF);
    runinst("LSL1", instructions);
    assertA(0xFE);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);

/* Logical Shift Left of 1. */
    setCC(0);
    setCCflag(1, CC_V);
    setA(0x01);
    runinst("LSL2", instructions);
    assertA(0x02);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

/* Logical Shift Left of 0xB8. */
    setCC(0);
    setCCflag(0, CC_V);
    setA(0xB8);
    runinst("LSL3", instructions);
    assertA(0x70);
    assertCC(1, CC_C);
    assertCC(1, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
}

/**
 * Test the LSR - Logical Shift Right instruction.
 * Logical Shift Right of 0x3E to 0x1F
 */
static void LSRA() {
    static char instructions[] = { 0x44, RTS };
    setCC(0x0F);
    setA(0x3E);
    runinst("LSR1", instructions);
    assertA(0x1F);
    assertCC(0, CC_C);
    assertCC(1, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

/* Logical Shift Right of 1 */
    setCCflag(0, CC_C);
    setCCflag(1, CC_V);
    setCCflag(1, CC_N);
    setA(0x01);
    runinst("LSR2", instructions);
    assertA(0x00);
    assertCC(1, CC_C);
    assertCC(1, CC_Z);
    assertCC(0, CC_N);

/* Logical Shift Right of 0xB8.  */
    setCCflag(0, CC_C);
    setCCflag(0, CC_V);
    setA(0xB8);
    runinst("LSR3", instructions);
    assertA(0x5C);
    assertCC(0, CC_C);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

}

/**
 * Rotate 8-Bit Accumulator or Memory Byte Left through Carry.
 * N The Negative flag is set equal to the new value of bit 7.
 * Z The Zero flag is set if the new 8-bit value is zero; cleared otherwise.
 * V The Overflow flag is set equal to the exclusive-OR of the original values of bits 6 and 7.
 * C The Carry flag receives the value shifted out of bit 7.
 * Rotate 0x89 to 0x13.
 */
static void ROLB() {
    static char instructions[] = { 0x59, RTS };

    setB(0x89);
    setCC(0);
    setCCflag(1, CC_N);
    setCCflag(1, CC_C);
    runinst("ROLB1", instructions);
    assertB(0x13);
    assertCC(1, CC_V);
    assertCC(1, CC_C);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

    /* Logical Shift Left of 1 with carry set */
    setCCflag(1, CC_C);
    setCCflag(1, CC_V);
    setB(0x01);
    runinst("ROLB2", instructions);
    assertB(0x03);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

    /* Rotate Left of 0xD8 */
    setCCflag(0, CC_C);
    setCCflag(0, CC_V);
    setB(0xD8);
    runinst("ROLB3", instructions);
    assertB(0xB0);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
}

/**
 * Rotate 8-Bit Accumulator or Memory Byte Right through Carry
 * N The Negative flag is set equal to the new value of bit 7 (original value of Carry).
 * Z The Zero flag is set if the new 8-bit value is zero; cleared otherwise.
 * V The Overflow flag is not affected by these instructions.
 * C The Carry flag receives the value shifted out of bit 0.
 */
static void RORB() {
    /* Rotate 0x89 with CC set to 0xC4 */
    static char instructions[] = { 0x56, RTS };
    setB(0x89);
    setCC(0);
    setCCflag(1, CC_C);
    runinst("RORB1", instructions);
    assertB(0xC4);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);

    /* Rotate 0x89 with CC clear to 0x44 */
    setB(0x89);
    setCC(0);
    setCCflag(0, CC_C);
    runinst("RORB2", instructions);
    assertB(0x44);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

    /* Rotate 0x08 with CC clear to 0x04 */
    setB(0x08);
    setCC(0);
    setCCflag(0, CC_C);
    runinst("RORB3", instructions);
    assertB(0x04);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
}

int main()
{
    setupCtl();

    ASRMem();
    ASRB();
    LSLA();
    LSRA();
    ROLB();
    RORB();
}

