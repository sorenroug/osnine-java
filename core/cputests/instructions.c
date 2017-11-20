#include <stdio.h>
#include "cputest.h"

/**
 * Tests AND A with a value loaded from the direct page.
 */
static int testANDA()
{
    static char testins[] = {0x94, 0xEF, RTS};
    char dp;

    setRegs(0x8B,0,0,0,0);
    setCC(0x02);
    setDP();
    dp = getDP();
    writeDPloc(0xEF, 0x0F);
    copydata(CODESTRT, testins, sizeof testins);
    /*printMem(0, 20);*/
    runtest("testANDA");
    printf("Save_s content: %X\n", save_s);

    assertRegs(0x0B,0,0,0,0);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertDP(dp);
}

/**
 * Tests negation of the A register.
 */
static int testNEG() {
    static char testins[] = {0x40, RTS};

    copydata(CODESTRT, testins, sizeof testins);
    /* Negate 0 */
    setRegs(0,0,0,0,0);
    setCC(0);
    runtest("testNEG0");
    assertRegs(0,0,0,0,0);
    assertCC(0, CC_C);
    assertCC(0, CC_V);

    /* Negate 1 */
    setRegs(1,0,0,0,0);
    setCC(0);
    runtest("testNEG1");
    assertRegs(0xFF,0,0,0,0);
    assertCC(1, CC_C);
    assertCC(0, CC_V);

    /* Negate 2 */
    setRegs(2,0,0,0,0);
    setCC(0);
    runtest("testNEG2");
    assertRegs(0xFE,0,0,0,0);
    assertCC(1, CC_C);
    assertCC(0, CC_V);

    /* Negate 0x80 */
    setRegs(0x80,0,0,0,0);
    setCC(0);
    runtest("testNEG80");
    assertRegs(0x80,0,0,0,0);
    assertCC(1, CC_C);
    assertCC(1, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
}

static void BITimm() {
    static char testins[] = {0x85, 0xAA, RTS};

    setA(0x8B);
    setCC(0x0F);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("BITimm");
    assertA(0x8B);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * Complement register A.
 */
static void COMA() {
    static char testins[] = {0x43, RTS};
    setCC(0);
    setA(0x74);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("COMA");
    assertA(0x8B);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * Decimal Addition Adjust.
 * The Half-Carry flag is not affected by this instruction.
 * The Negative flag is set equal to the new value of bit 7 in Accumulator A.
 * The Zero flag is set if the new value of Accumulator A is zero; cleared otherwise.
 * The affect this instruction has on the Overflow flag is undefined.
 * The Carry flag is set if the BCD addition produced a carry; cleared otherwise.
 */
static void DAA() {
    static char testins[] = {0x19, RTS};
    setCC(0);
    setA(0x7F);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("DAA");
    assertA(0x85);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
}

/**
 * Multiply 0x0C with 0x64. Result is 0x04B0.
 * The Zero flag is set if the 16-bit result is zero; cleared otherwise.
 * The Carry flag is set equal to the new value of bit 7 in Accumulator B.
 */
static void testMUL() {
    static char testins[] = {0x3D, RTS};
    setCCflag(0, CC_C);
    setCCflag(1, CC_Z);
    setA(0x0C);
    setB(0x64);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("MUL");
    assertA(0x04);
    assertB(0xB0);
    assertCC(0, CC_Z);
    assertCC(1, CC_C);
}

static void testSEX() {
    static char testins[] = {0x1D, RTS};
    setA(0x02);
    setB(0xE6);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("testSEX");
    assertA(0xFF);
    assertB(0xE6);
}

/**
 * Test the instruction TST.
 * TST: The Z and N bits are affected according to the value
 * of the specified operand. The V bit is cleared.
 */
static void TSTmemory() {
    static char testins[] = {0x4D, RTS};
    setCC(0);
    setA(0xFF);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("TSTmemory");
    assertA(0xFF);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
}

int main()
{
    setupCtl();

    testANDA();
    testNEG();
    BITimm();
    COMA();
    DAA();
    testMUL();
    testSEX();
    TSTmemory();
}

