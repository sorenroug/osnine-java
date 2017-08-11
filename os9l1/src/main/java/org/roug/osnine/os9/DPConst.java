package org.roug.osnine.os9;

/*
 * Locations of page 0 variables.
 */
public interface DPConst {
    int D_FMBM   = 32; /* Free memory bit map pointers */
    int D_FMBME  = 34;
    int D_MLIM   = 36; /* Memory limit */
    int D_MDir   = 38; /* Module directory */
    int D_MDirE  = 40;
    int D_Init   = 42; /* Rom base address */
    int D_SWI3   = 44; /* 2 Swi3 vector */
    int D_SWI2   = 46; /* 2 Swi2 vector */
    int D_FIRQ   = 48; /* 2 Firq vector */
    int D_IRQ    = 50; /* 2 Irq vector */
    int D_SWI    = 52; /* 2 Swi vector */
    int D_NMI    = 54; /* 2 Nmi vector */
    int D_SvcIRQ = 56; /* 2 Interrupt service entry */
    int D_Poll   = 58; /* 2 Interrupt polling routine */
    int D_UsrIRQ = 60; /* 2 User irq routine */
    int D_SysIRQ = 62; /* 2 System irq routine */
    int D_UsrSvc = 64; /* 2 User service request routine */
    int D_SysSvc = 66; /* 2 System service request routine */
    int D_UsrDis = 68; /* 2 User service request dispatch table */
    int D_SysDis = 70; /* 2 System service request dispatch table */
    int D_Slice  = 72; /* 1 Process time slice count */
    int D_PrcDBT = 73; /* 2 Process descriptor block address */
    int D_Proc   = 75; /* 2 Process descriptor address */
    int D_AProcQ = 77; /* 2 Active process queue */
    int D_WProcQ = 79; /* 2 Waiting process queue */
    int D_SProcQ = 81; /* 2 Sleeping process queue */
}
