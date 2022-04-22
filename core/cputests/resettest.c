#include "cputest.h"

/**
 * Test undocumented instruction - reset
 */
static void tRESET()
{
    static char instructions[] = {0x3E, RTS};

    setA(0);
    setCC(0x00);
    setCCflag(1, CC_Z);
    setCCflag(0, CC_N);
    setCCflag(0, CC_V);
    runinst("RESET", instructions);
    assertA(0);
}

int main()
{
    setupCtl();

    tRESET();
}

