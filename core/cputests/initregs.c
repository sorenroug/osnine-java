#include <stdio.h>
#include "cputest.h"

void setRegs(a, b, x, y, u)
    char a, b;
    unsigned x, y, u;
{
    initregs.rg_a = a;
    initregs.rg_b = b;
    initregs.rg_x = x;
    initregs.rg_y = y;
    initregs.rg_u = u;
} 

void assertInt(exp, act, reg)
    int exp, act;
    char *reg;
{
    if (exp != act) {
        printf("%s:%s expected %X - actual %X\n", currtest, reg, exp, act);
    }
}

void setDP()
{
    initregs.rg_dp = (dpLoc >> 8);
}

char getDP()
{
    return dpLoc >> 8;
}


void setCCflag(exp, bit)
    int exp, bit;
{
    register int mask = 1 << bit;
    if (exp == 0) {
        initregs.rg_cc &= ~mask;
    } else {
        initregs.rg_cc |= mask;
    }
}

void assertCC(exp, bit)
    int exp, bit;
{
    static char names[] = "CVZNIHFE";
    if ((initregs.rg_cc & (1 << bit)) != (exp << bit))
        printf("%s:CC-%c expected %d\n", currtest, names[bit], exp);
}

void assertRegs(a, b, x, y, u)
    char a, b;
    unsigned x, y, u;
{
    assertInt(a,  initregs.rg_a, "A");
    assertInt(b,  initregs.rg_b, "B");
    assertInt(x,  initregs.rg_x, "X");
    assertInt(y,  initregs.rg_y, "Y");
    assertInt(u,  initregs.rg_u, "U");
} 

void printRegs()
{
    printf("CC=%X A=%X B=%X DP=%X\n",
            initregs.rg_cc, initregs.rg_a,
            initregs.rg_b, initregs.rg_dp);
    printf("X=%x Y=%X U=%X\n", initregs.rg_x, initregs.rg_y, initregs.rg_u);
}
