#include <stdio.h>
#include "cputest.h"

/**
 * Shift a byte a 0x0402, because DP = 0x04.
 */
static void ASRMemoryByte() {
    static char instructions[] = { 0x07, 0x02, RTS };
    int result;

    setRegs(0,0,0,0,0);
    setCC(0x00);
    setDP();
    writeDPloc(0x02, 0xF1);
    copydata(CODESTRT, instructions, sizeof instructions);
    runtest("testASR");

    assertCC(1, CC_C);
    assertCC(0, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
    result = readDPloc(0x02);
    assertInt(0xf8, result, "0x02");
}

int main()
{
    setupCtl();

    ASRMemoryByte();
}

