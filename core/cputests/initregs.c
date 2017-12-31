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

void setA(value)
    char value;
{
    initregs.rg_a = value;
}

void assertA(exp)
    char exp;
{
    assertInt(exp, initregs.rg_a, "A");
}

void setB(value)
    char value;
{
    initregs.rg_b = value;
}

void assertB(exp)
    char exp;
{
    assertInt(exp, initregs.rg_b, "B");
}

/*
void setD(value)
    unsigned value;
{
    initregs.rg_a = value >> 8;
    initregs.rg_b = value & 0xFF;
}
*/
void setDP()
{
    initregs.rg_dp = (dpLoc >> 8);
}

char getDP()
{
    return dpLoc >> 8;
}

void assertDP(exp)
    char exp;
{
    assertInt(exp, initregs.rg_dp, "DP");
}

/**
 * Set the condition codes but don't turn off interrupts.
 */
void setCC(cc)
    char cc;
{
    initregs.rg_cc = (cc & 0xAF);
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

void setX(value)
    unsigned value;
{
    initregs.rg_x = value;
}

void assertX(exp)
    unsigned exp;
{
    assertInt(exp, initregs.rg_x, "X");
}

void setY(value)
    unsigned value;
{
    initregs.rg_y = value;
}

void assertY(exp)
    unsigned exp;
{
    assertInt(exp, initregs.rg_y, "Y");
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
