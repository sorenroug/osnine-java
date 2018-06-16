
typedef char pid_t;
typedef char byte;
typedef int  uid_t;

#define NumPaths 16
#define DefIOSiz 12

struct pdes {
    pid_t P_ID; /* 1 Process ID */
    pid_t P_PID; /* 1 Parent's ID */
    pid_t P_SID; /* 1 Sibling's ID */
    pid_t P_CID; /* 1 Child's ID */
    char *P_SP; /* 2 Stack ptr */
    byte P_CHAP; /* 1 process chapter number */
    byte P_ADDR; /* 1 user address beginning page number */
    byte P_PagCnt; /* 1 Memory Page Count */
    uid_t P_User; /* 2 User Index */
    byte P_Prior; /* 1 Priority */
    byte P_Age; /* 1 Age */
    byte P_State; /* 1 Status */
    struct pdes *P_Queue; /* 2 Queue Link (Process ptr) */
    pid_t P_IOQP; /* 1 Previous I/O Queue Link (Process ID) */
    pid_t P_IOQN; /* 1 Next     I/O Queue Link (Process ID) */
    char *P_PModul; /* 2 Primary Module */
    char *P_SWI; /* 2 SWI Entry Point */
    char *P_SWI2; /* 2 SWI2 Entry Point */
    char *P_SWI3; /* 2 SWI3 Entry Point */
    byte P_DIO[DefIOSiz]; /* default I/O ptrs */
    byte P_PATH[NumPaths]; /* I/O path table */
    byte P_Signal; /* 1 Signal Code */
    char *P_SigVec; /* 2 Signal Intercept Vector */
    char *P_SigDat; /* 2 Signal Intercept Data Address */
};

struct page0 {
    char D_FILLER[32];
    char *D_FMBMs,*D_FMBMe; /* Free memory bit map pointers */
    int D_MLIM; /* Memory limit */
    char *D_MDirs,*D_MDire; /* Module directory */
    char *D_Init; /* Rom base address */
    char *D_SWI3 ; /* 2 Swi3 vector */
    char *D_SWI2 ; /* 2 Swi2 vector */
    char *D_FIRQ ; /* 2 Firq vector */
    char *D_IRQ ; /* 2 Irq vector */
    char *D_SWI ; /* 2 Swi vector */
    char *D_NMI ; /* 2 Nmi vector */
    char *D_SvcIRQ ; /* 2 Interrupt service entry */
    char *D_Poll ; /* 2 Interrupt polling routine */
    char *D_UsrIRQ ; /* 2 User irq routine */
    char *D_SysIRQ ; /* 2 System irq routine */
    char *D_UsrSvc ; /* 2 User service request routine */
    char *D_SysSvc ; /* 2 System service request routine */
    char *D_UsrDis ; /* 2 User service request dispatch table */
    char *D_SysDis ; /* 2 System service request dispatch table */
    char D_Slice ; /* 1 Process time slice count */
    char *D_PrcDBT ; /* 2 Process descriptor block address */
    struct pdes *D_Proc ; /* 2 Process descriptor address */
    struct pdes *D_AProcQ ; /* 2 Active process queue */
    struct pdes *D_WProcQ ; /* 2 Waiting process queue */
    struct pdes *D_SProcQ ; /* 2 Sleeping process queue */
    char D_Year ; /* 1 */
    char D_Month ; /* 1 */
    char D_Day ; /* 1 */
    char D_Hour ; /* 1 */
    char D_Min ; /* 1 */
    char D_Sec ; /* 1 */
    char D_Tick ; /* 1 */
    char D_TSec ; /* 1 Ticks / second */
    char D_TSlice ; /* 1 Ticks / time-slice */
    char *D_IOML ; /* 2 I/O mgr free memory low bound */
    char *D_IOMH ; /* 2 I/O mgr free memory hi  bound */
    char *D_DevTbl ; /* 2 Device driver table addr */
    char *D_PolTbl ; /* 2 Irq polling table addr */
    char *D_PthDBT ; /* 2 Path descriptor block table addr */
    char *D_BTLO ; /* 2 Bootstrap low address */
    char *D_BTHI ; /* 2 Bootstrap hi address */
    char D_DMAReq ; /* 1 DMA in use flag */
    char *D_AltIRQ;  /* 2 Alternate IRQ vector (CC) */
    char *D_KbdSta;  /* Keyboard scanner static storage (CC) */
    char *D_DskTmr;   /*  2 Disk Motor Timer (CC) */
    char D_CBStrt[16]; /* 16 Reserved for CC warmstart ($71) */
    char *D_Clock;    /*   2 Address of Clock Tick Routine (CC) */
};

