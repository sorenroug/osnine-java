package org.roug.osnine.os9;

/*
 * Process descriptor constants.
 *
 * This structure does not necesarily match the structure used in OS9,
 * except to make 'PROCS' work. (Uses P_ID, P_PagCnt, P_User, P_Queue etc.)
 */
public interface PDConst {
    static final int p_ID = 0; /* 1 Process ID */
    static final int p_PID = 1; /* 1 Parent's ID */
    static final int p_SID = 2; /* 1 Sibling's ID */
    static final int p_CID = 3; /* 1 Child's ID */
    static final int p_SP = 4; /* 2 Stack ptr */
    static final int p_CHAP = 6; /* 1 process chapter number */
    static final int p_ADDR = 7; /* 1 user address beginning page number */
    static final int p_PagCnt = 8; /* 1 Memory Page Count */
    static final int p_User = 9; /* 2 User Index */
    static final int p_Prior = 11; /* 1 Priority */
    static final int p_Age = 12; /* 1 Age */
    static final int p_State = 13; /* 1 Status */
    static final int p_Queue = 14; /* 2 Queue Link (Process ptr) */
    static final int p_IOQP = 16; /* 1 Previous I/O Queue Link (Process ID) */
    static final int p_IOQN = 17; /* 1 Next     I/O Queue Link (Process ID) */
    static final int p_PModul = 18; /* 2 Primary Module */
    static final int p_SWI = 20; /* 2 SWI Entry Point */
    static final int p_SWI2 = 22; /* 2 SWI2 Entry Point */
    static final int p_SWI3 = 24; /* 2 SWI3 Entry Point */
    static final int p_DIO = 26; /* default I/O ptrs */
    static final int p_PATH = 38; /* I/O path table */
    static final int p_Signal = 54; /* 1 Signal Code */
    static final int p_SigVec = 55; /* 2 Signal Intercept Vector */
    static final int p_SigDat = 57; /* 2 Signal Intercept Data Address */
}
