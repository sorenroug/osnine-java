/*
 * Test of 6809 instructions.
 *
 * The strategy is to allocate one kilobyte for a test area, which will
 * allow the code to load data at locations under and over the code itself.
 * There is a small control routine that is set and then calls the test
 * at location 500. It expects the test to return with a RTS instruction.
 */
#include <stdio.h>

#ifdef __STDC__
#include <stdlib.h>
#else
#define void int
#endif
#define MEMSIZE 1024

struct registers {
    char rg_cc,rg_a,rg_b,rg_dp;
    unsigned rg_x,rg_y,rg_u;
    } ;

char memory[MEMSIZE];
struct registers initregs;

char *currtest;


#define CODESTRT 0

/* Small code segment to save registers and call test.
 */
unsigned ctlmemory[50];

unsigned save_s;
unsigned dpLoc;

/* Allocate enough memory to run the instructions in that allows
 * for jumps back and forth.
 */

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

void setDP(dp)
    char dp;
{
    initregs.rg_dp = dp;
}

void assertDP(exp)
    char exp;
{
    assertInt(exp, initregs.rg_dp, "DP");
}

#define CC_C 0
#define CC_V 1
#define CC_Z 2
#define CC_N 3
#define CC_I 4
#define CC_H 5
#define CC_F 6
#define CC_E 7

/**
 * Set the condition codes but don't turn off interrupts.
 */
void setCC(cc)
    char cc;
{
    initregs.rg_cc = (cc & 0xAF);
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

/**
 * Copy the instructions to test.
 * The instructions must begin at CODESTRT
 * The instructions must end with an RTS
 */
void copydata(start, insv, insc)
    int start;
    char *insv;
    int insc;
{
    register int i;

    for (i = 0; i < insc; i++) {
        memory[start++] = insv[i];
    }
}

/*
 * Start location is the argument on the stack.
 */
void jsrtest(startloc)
    char *startloc;
{
#ifndef __STDC__
#asm
*   ldu 4,s
*   stu save_s,y
    jsr [4,s]
#endasm
#endif
}

void runtest()
{
    printf("Running %s\n", currtest);
    jsrtest(ctlmemory);
}

int setupCtl()
{
    int start;

    start = 0;

    /* Push existing register state on normal stack */
    ctlmemory[start++] = 0x347F;

    /* Remember SP value */
    ctlmemory[start++] = 0x10FF; /* STS */
    ctlmemory[start++] = &save_s;

    /* Change SP to initregs */
    ctlmemory[start++] = 0x10CE; /* LDS */
    ctlmemory[start++] = &initregs;

    /* Pull all registers */
    ctlmemory[start++] = 0x357F; /* PulS */

    /* Call subroutine */
    ctlmemory[start++] = 0x12BD; /* NOP + JSR */
    ctlmemory[start++] = &memory[CODESTRT];

    /* Push registers back to initregs */
    ctlmemory[start++] = 0x347F; /* PshS */

    /* Reset SP to normal stack by loading content of save_s */
    ctlmemory[start++] = 0x10FE; /* LDS */
    ctlmemory[start++] = &save_s;

    /* Pull all registers */
    ctlmemory[start++] = 0x357F; /* PulS */

    ctlmemory[start++] = 0x3912; /* RTS + NOP */

    return start;
}

void printMem(start, size)
    int start, size;
{
    register int i;

    for (i = start; i < size; i++) {
        printf("%02X", memory[i]);
        if (i % 12 == 11) {
            printf("\n");
        } else {
            printf(":");
        }
    }
}

void printCtl(ctlsize)
    int ctlsize;
{
    register int i;

    printf("Save_s addr: %X\n", &save_s);
    printf("Save_s content: %X\n", save_s);
    printf("Memory addr: %X\n", memory);
    printf("Initregs addr: %X\n", &initregs);
    printf("CtlMem addr: %X\n", ctlmemory);

    for (i = 0; i < ctlsize; i++) {
        printf("%04X", ctlmemory[i]);
        if (i % 6 == 5) {
            printf("\n");
        } else {
            printf(":");
        }
    }
    printf("\n");
}

/**
 * Calculate a valid value for the DP register.
 */
unsigned calcDP()
{
    register unsigned t = (unsigned)memory;
    return (t >> 8) + ((t & 0xff) == 0 ? 1 : 0);
}

/**
 * Write a value into the direct page.
 */
void writeDPloc(offset, value)
    int offset;
    char value;
{
    unsigned dp = calcDP();
    int loc = (dpLoc << 8) - (unsigned)memory + offset;
    memory[loc] = value;
}

/* ------------- Tests --------------- */
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

/* Main routine */
int main()
{
    int ctlsize;
    ctlsize = setupCtl();
    dpLoc = calcDP();

    printf("Memory addr: %X\n", memory);
    testANDA();
    testNEG();

}

