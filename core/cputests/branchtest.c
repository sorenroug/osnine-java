#include <stdio.h>
#include "cputest.h"

/**
 * Branch on greater than.
 * BGT = 0x2E
 */
static void BGT()
{
    static char instructions[] = {0x2E, 0x03, LDA, 0x01, RTS, LDA, 0x02, RTS};

    setA(0);
    setCC(0x00);
    setCCflag(1, CC_Z);
    setCCflag(0, CC_N);
    setCCflag(0, CC_V);
    runinst("BGT1", instructions);
    assertA(1);

    setCCflag(0, CC_Z);
    setCCflag(0, CC_N);
    setCCflag(0, CC_V);
    runtest("BGT2");
    assertA(2);

    setCCflag(0, CC_Z);
    setCCflag(1, CC_N);
    setCCflag(0, CC_V);
    runtest("BGT3");
    assertA(1);

    setCCflag(0, CC_Z);
    setCCflag(1, CC_N);
    setCCflag(1, CC_V);
    runtest("BGT4");
    assertA(2);

    setCCflag(1, CC_Z);
    setCCflag(1, CC_N);
    setCCflag(0, CC_V);
    runtest("BGT5");
    assertA(1);
}

/**
 * Branch on higher
 * BHI = 0x22
 */
static void BHI()
{
    static char instructions[] = {0x22, 0x03, LDA, 0x01, RTS, LDA, 0x02, RTS};

    setA(0);
    setCC(0x00);
    setCCflag(1, CC_Z);
    setCCflag(0, CC_C);
    runinst("BHI1", instructions);
    assertA(1);
}

int main()
{
    setupCtl();

    BGT();
    BHI();
}

