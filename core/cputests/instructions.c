#include <stdio.h>
#include "cputest.h"
/**
 * Tests AND A with a value loaded from the direct page.
 */
int testANDA()
{
    static char testins[] = {0x94, 0xEF, 0x39};

    currtest = "testANDA";
    setRegs(0x8B,0,0,0,0);
    setCC(0x02);
    setDP(dpLoc);
    writeDPloc(0xEF, 0x0F);
    copydata(CODESTRT, testins, sizeof testins);
    /*printMem(0, 20);*/
    runtest();
    printf("Save_s content: %X\n", save_s);

    assertRegs(0x0B,0,0,0,0);
    assertCC(0, CC_C);
    assertCC(0, CC_V);
    assertDP(dpLoc);
}

/**
 * Tests negation of the A register.
 */
int testNEG() {
    static char testins[] = {0x40, 0x39};

    currtest = "testNEG";
    copydata(CODESTRT, testins, sizeof testins);
    /* Negate 0 */
    setRegs(0,0,0,0,0);
    setCC(0);
    runtest();
    assertRegs(0,0,0,0,0);
    assertCC(0, CC_C);
    assertCC(0, CC_V);

    /* Negate 1 */
    setRegs(1,0,0,0,0);
    setCC(0);
    runtest();
    assertRegs(0xFF,0,0,0,0);
    assertCC(1, CC_C);
    assertCC(0, CC_V);

    /* Negate 2 */
    setRegs(2,0,0,0,0);
    setCC(0);
    runtest();
    assertRegs(0xFE,0,0,0,0);
    assertCC(1, CC_C);
    assertCC(0, CC_V);

    /* Negate 0x80 */
    setRegs(0x80,0,0,0,0);
    setCC(0);
    runtest();
    assertRegs(0x80,0,0,0,0);
    assertCC(1, CC_C);
    assertCC(1, CC_V);
    assertCC(0, CC_Z);
    assertCC(1, CC_N);
}

