#include <stdio.h>
#include "cputest.h"

/**
 * Test indirect mode: CMPA ,Y+
 * We're subtracting 0xff from 0xff and incrementing Y
 */
static void CMP1() {

    static char testins[] = {0xA1, 0xA0, RTS};
    unsigned memloc;

    /* Set up a byte to test at address 0x205 */
    memloc = setMem(0x205, 0xff);
    setCC(0);
    /* Set register Y to point to that location */
    setRegs(0xff, 0, 0, memloc, 0);
    /* Two bytes of instruction */
    copydata(CODESTRT, testins, sizeof testins);
    runtest("CMP1");
    assertRegs(0xff, 0, 0, memloc+1, 0);
    /* assertCC(1, CC_H); */
    assertCC(1, CC_Z);
}
    
static void CMP2()
{
    /* B = 0xA0, CMPB with 0xA0 */
    static char testins[] = {0xC1, 0xA0, RTS};

    setCCflag(1, CC_N);
    setCCflag(0, CC_Z);

    setB(0xA0); 
    copydata(CODESTRT, testins, sizeof testins);
    runtest("CMP2");
    assertCC(0, CC_N);
    assertCC(1, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
}
    
static void CMP3()
{
    static char testins[] = {0xC1, 0xA0, RTS};
    /* B = 0x70, CMPB with 0xA0 */
    /* positive - negative = negative + overflow */
    setCC(0);
    setB(0x70); 
    copydata(CODESTRT, testins, sizeof testins);
    runtest("CMP3");
    assertCC(1, CC_C);
    assertCC(1, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
}

/**
 * Compare 0x5410 with 0x5410.
 */
static void CMP16()
{
    unsigned memloc;
    setCC(0x23);
    setX(0x5410);
    memloc = setMem(0x33, 0x54);
    setMem(0x34, 0x10);
    /*writeword(CODESTRT + 0x33, 0x5410);*/
    writebyte(CODESTRT, 0xBC);
    writeword(CODESTRT+1, memloc);
    writebyte(CODESTRT+3, RTS);

    runtest("CMP16");
    assertX(0x5410);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(1, CC_Z);
    assertCC(0, CC_N);
}

/**
 * Decrement register A.
 */
static void DECA() {
    setCC(0);
    setA(0x32);
    writebyte(CODESTRT, 0x4A);
    writebyte(CODESTRT+1, RTS);
    runtest("DECA0x32");
    assertA(0x31);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

    /* Test 0x80 - special case */
    setA(0x80);
    runtest("DECA0x80");
    assertA(0x7F);
    assertCC(0, CC_C);
    assertCC(1, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);

    /* Test 0x00 - special case */
    setA(0x00);
    runtest("DECA0x00");
    assertA(0xFF);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
}

/**
 * Test the subtraction with carry instruction.
 * B=0x35 - addr(0x503)=0x3 - C=1 becomes 0x31
 * SBCB dp+03
 */
static void SBCB() {
    static char testins[] = {0xD2, 0x03, RTS};
    setDP();
    writeDPloc(0x03, 0x03);
    setB(0x35);
    setCC(0);
    setCCflag(1, CC_C);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SBCB");
    assertB(0x31);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
    /* assertCC(1, CC_H); */
}

/**
 * Test the SBCA instruction.
 * A=0xFF - 0xFE - C=1 becomes 0x00
 */
static void SBCA1() {
    static char testins[] = {0x82, 0xFE, RTS};
    setCCflag(1, CC_C);
    setCCflag(1, CC_N);
    setCCflag(0, CC_Z);
    setA(0xFF);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SBCA1");
    assertA(0);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(1, CC_Z);
    assertCC(0, CC_N);
}

/**
 * Test the SBCA instruction.
 * A=0x00 - 0xFF - C=0 becomes 0x01
 */
static void SBCA2() {
    static char testins[] = {0x82, 0xFF, RTS};
    setCCflag(0, CC_C);
    setCCflag(1, CC_N);
    setCCflag(0, CC_Z);
    setCCflag(1, CC_V);
    setA(0x00);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SBCA2");
    assertA(0x01);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
}

/**
 * Test the SBCA instruction.
 * A=0x00 - 0x01 - C=0 becomes 0xFF
 */
static void SBCA3() {
    static char testins[] = {0x82, 0x01, RTS};
    setCCflag(0, CC_C);
    setCCflag(1, CC_N);
    setCCflag(0, CC_Z);
    setCCflag(1, CC_V);
    setA(0x00);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SBCA2");
    assertA(0xFF);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
}

/**
 * Test the SUBA instruction.
 * The overflow (V) bit indicates signed two’s complement overflow, which
 * occurs when the sign bit differs from the carry bit after an arithmetic
 * operation.
 * A=0x00 - 0xFF becomes 0x01
 * positive - negative = positive
 */
static void SUBA1() {
    static char testins[] = {0x80, 0xFF, RTS};
    setCCflag(1, CC_C);
    setCCflag(1, CC_N);
    setCCflag(0, CC_Z);
    setCCflag(1, CC_V);
    setA(0x00);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SUBA1");
    assertA(0x01);
    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
}

/**
 * A=0x00 - 0x01 becomes 0xFF
 * positive - positive = negative
 */
static void SUBA2() {
    static char testins[] = {0x80, 0x01, RTS};
    setCCflag(1, CC_C);
    setCCflag(1, CC_N);
    setCCflag(0, CC_Z);
    setCCflag(1, CC_V);
    setA(0x00);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SUBA2");
    assertA(0xFF);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * Test the subtraction instruction.
 * IMMEDIATE mode:   B=0x02 - 0xB3  becomes 0x4F
 * positive - negative = positive
 */
static void SUBB1() {
    static char testins[] = {0xC0, 0xB3, RTS};
    setB(0x02);
    setCC(0);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SUBB1");
    assertB(0x4F);
    assertCC(0, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * Test the subtraction instruction.
 * IMMEDIATE mode:   B=0x02 - 0x81  becomes 0x81
 * positive - negative = negative + overflow
 */
static void SUBB2() {
    static char testins[] = {0xC0, 0x81, RTS};
    setB(0x02);
    setCC(0);
    copydata(CODESTRT, testins, sizeof testins);
    runtest("SUBB2");
    assertB(0x81);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(1, CC_V);
    assertCC(1, CC_C);
}

/**
 * Example from Programming the 6809.
 * 0x03 - 0x21 = 0xE2
 * positive - positive = negative
 */
static void SUBBY() {
    unsigned memloc;
    static char testins[] = {0xE0, 0xA4, RTS};
    setB(0x03);
    setCC(0);
    setCCflag(1, CC_Z);
    memloc = setMem(0x21, 0x21);
    setY(memloc);
    runinst("SUBBY", testins);
    assertB(0xE2);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

int main() {
    setupCtl();

    CMP1();
    CMP2();
    CMP3();
    CMP16();
    DECA();
    SBCB();
    SBCA1();
    SBCA2();
    SBCA3();
    SUBA1();
    SUBA2();
    SUBB1();
    SUBB2();
    SUBBY();
}

