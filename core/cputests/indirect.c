#include "cputest.h"

/**
 */
static void LEAXpcr()
{
    static char instructions[] = {0x30, 0x8C, 0xE4, RTS};

    setCC(0x00);
    setX(0x1234);
    runinst("LEAXpcr", instructions);
    assertX(memory + CODESTRT - 25);
    assertCC(0, CC_Z);
}

/*
 * Increment X by 2.
 */
static void LEAXinc2()
{
    static char instructions[] = {0x30, 0x02, RTS};

    setCC(0x00);
    setX(0x1234);
    runinst("LEAXinc2", instructions);
    assertX(0x1236);
    assertCC(0, CC_Z);
}

/**
 * LEAX from Y with no offset.
 */
static void LEAXno()
{
    static char instructions[] = {0x30, 0xA4, RTS};

    setCC(0x00);
    setX(0x1234);
    setY(0x4321);
    runinst("LEAXno", instructions);
    assertX(0x4321);
    assertCC(0, CC_Z);
}

static void LEAXinc()
{
    static char instructions[] = {0x30, 0xA0, RTS};

    setCC(0x00);
    setX(0x1234);
    setY(0x4321);
    runinst("LEAXinc1", instructions);
    assertX(0x4321);
    assertY(0x4322);
    assertCC(0, CC_Z);

    setCC(0x00);
    setY(0x0);
    runinst("LEAXinc2", instructions);
    assertX(0x0);
    assertY(0x1);
    assertCC(1, CC_Z);
}

/**
 * LEAX D,Y
 */
static void Doffset()
{
    static char instructions[] = {0x30, 0xAB, RTS};

    setCC(0x00);
    setX(0xABCD);
    setY(0x804F);
    setA(0x80);
    setB(0x01);
    runinst("Doffset1", instructions);
    assertX(0x50);
    assertCC(0, CC_Z);

    setCC(0x28);
    setX(0x0EFA);
    setY(0x0EF8);
    setA(0xFF);
    setB(0x82);
    runinst("Doffset2", instructions);
    assertX(0x0E7A);
    assertCC(0, CC_Z);
}

int main()
{
    setupCtl();

    LEAXpcr();
    LEAXinc2();
    LEAXinc();
    LEAXno();
    Doffset();
}

