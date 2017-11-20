/*
 * Test of 6809 instructions.
 *
 * The strategy is to allocate one kilobyte for a test area, which will
 * allow the code to load data at locations under and over the code itself.
 * There is a small control routine that is set and then calls the test
 * at location 500. It expects the test to return with a RTS instruction.
 */
#include <stdio.h>
#include "cputest.h"

/* Allocate enough memory to run the instructions in that allows
 * for jumps back and forth. Statck pointer is set at top.
 * initregs must follow immediately.
 */
char memory[MEMSIZE];
struct registers initregs;

char *currtest;


#define CODESTRT 0

/* Small code segment to save registers and call test.
 */
unsigned ctlmemory[50];

/* Store the initial value of the stack pointer. */
unsigned save_s;
unsigned dpLoc;

/**
 * Copy the instructions to test.
 * Instructions must begin at CODESTRT
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

void writebyte(loc, value)
    int loc;
    char value;
{
    memory[loc] = value;
}

unsigned setMem(addr, value)
    int addr;
    char value;
{
    memory[addr] = value;
    return (unsigned) &memory[addr];
}

void writeword(loc, value)
    int loc;
    unsigned value;
{
    memory[loc++] = value >> 8;
    memory[loc] = value & 0xFF;
}

/**
 * Calculate a valid value for the DP register.
 */
static unsigned calcDP()
{
    register unsigned t = (unsigned) memory;
    t = (t & 0xff00) + ((t & 0xff) != 0 ? 0x100 : 0x0);
    return t;
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

void runtest(ctest)
    char *ctest;
{
    currtest = ctest;
    printf("Running %s\n", currtest);
    jsrtest(ctlmemory);
}

int setupCtl()
{
    int start;
    printf("Memory addr: %X\n", memory);
    dpLoc = calcDP();

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
 * Write a value into the direct page.
 */
void writeDPloc(offset, value)
    int offset;
    char value;
{
    int loc = dpLoc - (unsigned) memory + offset;
    memory[loc] = value;
}

/*
int main()
{
    setupCtl();

    instructions();
    subtractions();
}
*/
