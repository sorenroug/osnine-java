#include "cputest.h"

/**
 * Add Accumulator B into index register X.
 * The ABX instruction was included in the 6809 instruction set for
 * compatibility with the 6801 microprocessor.
 * void setRegs(a, b, x, y, u)
 */
static void ABX()
{
    static char instructions[] = {0x3a, RTS};

    setRegs(0,0xCE,0x8006,0,0);
    setCC(0x00);
    runinst("ABX1", instructions);
    assertRegs(0, 0xCE, 0x80D4, 0,0);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
    assertCC(0, CC_H);

    setRegs(0,0xD6,0x7FFE,0,0);
    setCC(0x07);
    runinst("ABX2", instructions);
    assertRegs(0, 0xD6, 0x80D4, 0,0);
    assertCC(1, CC_C);
    assertCC(1, CC_V);
    assertCC(1, CC_Z);
    assertCC(0, CC_N);
    assertCC(0, CC_H);
}

/**
 * Add 2 to register A.
 */
static void ADCANoC() {
    static char instructions[] = {0x89, 0x02, RTS};

    copydata(CODESTRT, instructions, sizeof instructions);
    setA(5);
    setCC(0);
    runtest("ADCANoC1");
    assertA(7);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
    assertCC(0, CC_H);

    /* Test half-carry $E + $2 = $10 */
    setA(0x0E);
    setCC(0);
    runtest("ADCANoC2");
    assertA(0x10);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
    assertCC(1, CC_H);
}

/**
 * Add $22 and carry to register A ($14).
 */
static void ADCAWiC() {
    static char instructions[] = {0x89, 0x22, RTS};

    setA(0x14);
    setCC(0);
    setCCflag(1, CC_C);
    setCCflag(1, CC_H);
    runinst("ADCAWiC", instructions);
    assertA(0x37);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(0, CC_N);
    assertCC(0, CC_H);
}

/*
 * Test that half-carry is set when adding with a carry.
 */
static void ADCAWiHC() {
    static char instructions[] = {
        0x89, /* ADCA */
        0x2B,  /* value */
        RTS
    };
    setCCflag(1, CC_C);
    setA(0x14);
    runinst("ADCAWiHC", instructions);
    assertA(0x40);
    assertCC(0, CC_C);
    assertCC(1, CC_H);
}

/**
 * positive + positive with overflow.
 * B=0x40 + 0x41 becomes 0x81 or -127
 */
static void ADDB1() {
    static char instructions[] = {0xCB, 0x41, RTS};
    setCC(0);
    setB(0x40);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDB1");
    assertB(0x81);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(1, CC_V);
    assertCC(0, CC_C);
    assertCC(0, CC_H);
}

/**
 * negative + negative
 * B=0xFF + 0xFF becomes 0xFE or -2
 */
static void ADDB2() {
    static char instructions[] = {0xCB, 0xFF, RTS};
    setCC(0);
    setB(0xFF);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDB2");
    assertB(0xFE);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * negative + negative with overflow
 * B=0xC0 + 0xBF becomes 0x7F or 127
 */
static void ADDB3() {
    static char instructions[] = {0xCB, 0xBF, RTS};
    setCC(0);
    setB(0xC0);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDB3");
    assertB(0x7F);
    assertCC(0, CC_N);
    assertCC(0, CC_Z);
    assertCC(1, CC_V);
    assertCC(1, CC_C);
}

/**
 * positive + negative with negative result
 * B=0x02 + 0xFC becomes 0xFE or -2
 */
static void ADDB4() {
    static char instructions[] = {0xCB, 0xFC, RTS};
    setCC(0);
    setB(0x02);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDB4");
    assertB(0xFE);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
}

/**
 * Add 0x02 to A=0x04.
 */
static void ADDANoC() {
    static char instructions[] = {
        0x8B, /* ADDA */
        0x02, /* value */
        RTS
    };
    setCC(0);
    setA(0x04);
    setB(0x05);
    runinst("ADDANoC", instructions);
    assertA(0x06);
    assertB(0x05);
    assertCC(0, CC_H);
    assertCC(0, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
}

/**
 * The overflow (V) bit indicates signed two’s complement overflow, which occurs when the
 * sign bit differs from the carry bit after an arithmetic operation.
 * A=0x03 + 0xFF becomes 0x02
 */
static void ADDAWiC() {
    static char instructions[] = {
        0x8B, /* ADDA */
        0xFF, /* value */
        RTS
    };
    setCC(0);
    setA(0x03);
    copydata(CODESTRT, instructions, sizeof instructions);
    runinst("ADDAWiC", instructions);
    assertA(0x02);
    assertCC(0, CC_N);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * Add 0x02B0 to D=0x0405 becomes 0x6B5.
 * positive + positive = positive
 */
static void ADDDNoC() {
    static char instructions[] = {
        0xC3, /* ADDD */
        0x02, /* value */
        0xB0,  /* value */
        RTS
    };
    setCC(0);
    setA(0x04);
    setB(0x05);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDDNoC");
    assertA(0x06);
    assertB(0xB5);
    assertCC(0, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
}

/**
 * Add 0xE2B0 to D=0x8405 becomes 0x66B5.
 * negative + negative = positive + overflow
 */
static void ADDD1() {
    static char instructions[] = {
        0xC3, /* ADDD */
        0xE2, /* value */
        0xB0,  /* value */
        RTS
    };
    setCC(0);
    setA(0x84);
    setB(0x05);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDD1");
    assertA(0x66);
    assertB(0xB5);
    assertCC(0, CC_N);
    assertCC(0, CC_Z);
    assertCC(1, CC_V);
    assertCC(1, CC_C);
}

/**
 * negative + negative = negative
 * Add 0xE000 to D=0xD000 becomes 0xB000
 */
static void ADDD2() {
    static char instructions[] = {
        0xC3, /* ADDD */
        0xE0, /* value */
        0x00,  /* value */
        RTS
    };
    setCC(0);
    setA(0xD0);
    setB(0x00);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDD2");
    assertA(0xB0);
    assertB(0x00);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(1, CC_C);
}

/**
 * positive + positive = negative + overflow
 * Add 0x7000 to D=0x7000 becomes 0xE000
 */
static void ADDD3() {

    static char instructions[] = {
        0xC3, /* ADDD */
        0x70, /* value */
        0x00,  /* value */
        RTS
    };
    setCC(0);
    setA(0x70);
    setB(0x00);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("ADDD3");
    assertA(0xE0);
    assertB(0x00);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(1, CC_V);
    assertCC(0, CC_C);
}

/**
 * Increment register A.
 */
static void INCA() {
    static char instructions[] = {
        0x4C, /* INCA */
        RTS
    };
    setCC(0);
    setA(0x32);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("INCA1");
    assertA(0x33);
    assertCC(0, CC_N);
    assertCC(0, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);

    /* Test 0x7F - special case */
    setCC(0);
    setA(0x7F);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("INCA2");
    assertA(0x80);
    assertCC(1, CC_N);
    assertCC(0, CC_Z);
    assertCC(1, CC_V);
    assertCC(0, CC_C);


    /* Test 0xFF - special case */
    setCC(0);
    setA(0xFF);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("INCA3");
    assertA(0x00);
    assertCC(0, CC_N);
    assertCC(1, CC_Z);
    assertCC(0, CC_V);
    assertCC(0, CC_C);
}

int main()
{
    setupCtl();

    ABX();
    ADCANoC();
    ADCAWiC();
    ADCAWiHC();
    ADDB1();
    ADDB2();
    ADDB3();
    ADDB4();
    ADDANoC();
    ADDAWiC();
    ADDD1();
    ADDD2();
    ADDD3();
    INCA();
}

