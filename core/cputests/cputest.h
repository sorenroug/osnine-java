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

extern void setRegs();
extern void setA();
extern void setB();
extern void setCC();
extern void setCCflag();
extern char getDP();
extern void setDP();
extern void setX();
extern void copydata();
extern void writeDPloc();
extern int readDPloc();
extern void runtest();
extern void runcode();
extern void assertInt();
extern void assertRegs();
extern void assertCC();
extern void assertDP();
extern void assertA();
extern void assertB();
extern unsigned setMem();
extern int setupCtl();
