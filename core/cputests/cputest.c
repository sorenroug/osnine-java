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

struct registers {
    char rg_cc,rg_a,rg_b,rg_dp;
    unsigned rg_x,rg_y,rg_u;
    } ;

struct registers initregs;

char *currtest;


#define MEMSIZE 1024
#define CODELOC 0

/* Small code segment to save registers and call test.
 */
unsigned ctlmemory[50];

unsigned save_s;

/* Allocate enough memory to run the instructions in that allows
 * for jumps back and forth.
 */
char memory[MEMSIZE];

void setRegs(cc, a, b, dp, x, y, u)
    char cc, a, b, dp;
    unsigned x, y, u;
{
    initregs.rg_cc = cc;
    initregs.rg_a = a;
    initregs.rg_b = b;
    initregs.rg_dp = dp;
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

void assertRegs(cc, a, b, dp, x, y, u)
    char cc, a, b, dp;
    unsigned x, y, u;
{
    assertInt(cc, initregs.rg_cc, "CC");
    assertInt(a,  initregs.rg_a, "A");
    assertInt(b,  initregs.rg_b, "B");
    assertInt(dp, initregs.rg_dp, "DP");
    assertInt(x,  initregs.rg_x, "X");
    assertInt(y,  initregs.rg_y, "Y");
    assertInt(u,  initregs.rg_u, "U");
} 

void printRegs()
{
    printf("CC=%X A=%X B=%X DP=%X\n", initregs.rg_cc, initregs.rg_a,
            initregs.rg_b, initregs.rg_dp);
    printf("X=%x Y=%X U=%X\n", initregs.rg_x, initregs.rg_y, initregs.rg_u);
}

/* Copy the instructions to test */
void copydata(start, insv, insc)
    int start;
    char *insv;
    int insc;
{
    register int i;
    /* Insert test code */
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

    /* Reset SP to normal stack by loading content of save_s */
    ctlmemory[start++] = 0x10FE; /* LDS */
    ctlmemory[start++] = &save_s;

    /* Call subroutine */
    ctlmemory[start++] = 0x12BD; /* NOP + JSR */
    ctlmemory[start++] = &memory[CODELOC];

    /* Change SP to initregs */
    ctlmemory[start++] = 0x10CE; /* LDS */
    ctlmemory[start++] = ((unsigned)&initregs) + sizeof initregs;

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

void printMem(size)
    int size;
{
    register int i;

    for (i = 0; i < size; i++) {
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

int main()
{
    int ctlsize;
    ctlsize = setupCtl();
    /*
    printCtl(ctlsize);
    */

    testANDA();

}

/**
 * Calculate a valid value for the DP register.
 */
unsigned calcDP()
{
    return ((unsigned)memory >> 8) + 1;
}

void writeDPloc(offset, value)
    int offset;
    char value;
{
    unsigned dp = calcDP();
    int loc = (dp << 8) - (unsigned)memory + offset;
    memory[loc] = value;
}

int testANDA()
{
    static char testins[] = {0x94, 0xEF, 0x39};
    unsigned mydp;

    printf("Memory addr: %X\n", memory);
    currtest = "testANDA";
    mydp = calcDP();
    setRegs(0x32,0x8B,0,mydp,0,0,0);
    writeDPloc(0xEF, 0x0F);
    printRegs();
    copydata(CODELOC, testins, sizeof testins);
    /*printMem(20);*/
    runtest();
    printf("Save_s content: %X\n", save_s);

    printRegs();
    assertRegs(0x30,0x0B,0,mydp,0,0,0);
}

