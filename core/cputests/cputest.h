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

extern char memory[MEMSIZE];
extern struct registers initregs;

extern char *currtest;


#define CODESTRT 0

#define runinst(funcname, inst) runcode(funcname, inst, sizeof inst)

/* Small code segment to save registers and call test.
 */
extern unsigned ctlmemory[50];

extern unsigned save_s;
extern unsigned dpLoc;

#define CC_C 0
#define CC_V 1
#define CC_Z 2
#define CC_N 3
#define CC_I 4
#define CC_H 5
#define CC_F 6
#define CC_E 7

#define LDA 0x86
#define LDB 0xC6
#define RTS 0x39

#define setA(value)    initregs.rg_a = value
#define assertA(exp)   assertInt(exp, initregs.rg_a & 0xFF, "A")
#define setB(value)    initregs.rg_b = value
#define assertB(exp)   assertInt(exp, initregs.rg_b & 0xFF, "B")
#define setX(value)    initregs.rg_x = value
#define assertX(exp)   assertInt(exp, initregs.rg_x, "X")
#define setY(value)    initregs.rg_y = value
#define assertY(exp)   assertInt(exp, initregs.rg_y, "Y")
/**
 * Set the condition codes but don't turn off interrupts.
 */
#define setCC(value)   initregs.rg_cc = (value & 0xAF)
#define assertDP(exp)   assertInt(exp, initregs.rg_dp & 0xFF, "DP")

extern void setRegs();
extern void setCCflag();
extern char getDP();
extern void setDP();
extern void copydata();
extern void writeDPloc();
extern int readDPloc();
extern void runtest();
extern void runcode();
extern void assertInt();
extern void assertRegs();
extern void assertCC();
extern unsigned setMem();
extern int setupCtl();
