package org.roug.osnine.os9;

/* error code conditions */
/* WDDisk "TEST" Error Codes */
interface ErrCodes {
    public static final int E_WD2797 = 101;             /* WD 1002-05 WD2797 FD controller */
    public static final int E_WD1010 = 102;             /* WD 1002-05 WD1010 HD controller */
    public static final int E_WDSBuf = 103;             /* WD 1002-05 sector buffer */
    public static final int E_WD1014 = 104;             /* WD 1002-05 WD1014 error detection or bus */
    public static final int E_WD1015 = 105;             /* WD 1002-05 WD1015 control processor */

  /* System Dependent Error Codes */
    public static final int E_IWTyp = 183;              /* illegal window type */
    public static final int E_WADef = 184;              /* window already defined */
    public static final int E_NFont = 185;              /* font not found */
    public static final int E_StkOvf = 186;             /* Stack overflow */
    public static final int E_IllArg = 187;             /* Illegal argument */
    public static final int E_188 = 188;                /* reserved */
    public static final int E_ICoord = 189;             /* Illegal coordinates */
    public static final int E_Bug = 190;                /* Bug (should never be returned) */
    public static final int E_BufSiz = 191;             /* Buffer size is too small */
    public static final int E_IllCmd = 192;             /* Illegal command */
    public static final int E_TblFul = 193;             /* Screen or window table is full */
    public static final int E_BadBuf = 194;             /* Bad/Undefined buffer number */
    public static final int E_IWDef = 195;              /* Illegal window definition */
    public static final int E_WUndef = 196;             /* Window undefined */
    public static final int E_Up = 197;                 /* up-arrow pressed on SCF I$ReadLn with PD.UP enabled */
    public static final int E_Dn = 198;                 /* dn-arrow pressed on SCF I$ReadLn with PD.DN enabled */
    public static final int E_Alias = 199; 

  /* Standard OS-9 Error Codes */
    public static final int E_PthFul = 200;             /* Path Table full */
    public static final int E_BPNum = 201;              /* Bad Path Number */
    public static final int E_Poll = 202;               /* Polling Table Full */
    public static final int E_BMode = 203;              /* Bad Mode */
    public static final int E_DevOvf = 204;             /* Device Table Overflow */
    public static final int E_BMID = 205;               /* Bad Module ID */
    public static final int E_DirFul = 206;             /* Module Directory Full */
    public static final int E_MemFul = 207;             /* Process Memory Full */
  
    public static final int E_UnkSvc = 208;             /* Unknown Service Code */
    public static final int E_ModBsy = 209;             /* Module Busy */
    public static final int E_BPAddr = 210;             /* Bad Page Address */
    public static final int E_EOF = 211;                /* End of File */
    public static final int E_xxx1 = 212;
    public static final int E_NES = 213;                /* Non-Existing Segment */
    public static final int E_FNA = 214;                /* File Not Accesible */
    public static final int E_BPNam = 215;              /* Bad Path Name */
    public static final int E_PNNF = 216;               /* Path Name Not Found */
    public static final int E_SLF = 217;                /* Segment List Full */
    public static final int E_CEF = 218;                /* Creating Existing File */
    public static final int E_IBA = 219;                /* Illegal Block Address */
    public static final int E_HangUp = 220;             /* Carrier Detect Lost */
    public static final int E_MNF = 221;                /* Module Not Found */
    public static final int E_xxx2 = 222;
    public static final int E_DelSP = 223;              /* Deleting Stack Pointer memory */
    public static final int E_IPrcID = 224;             /* Illegal Process ID */
    public static final int E_BPrcID = E_IPrcID;        /* Bad Process ID (formerly #238) */
    public static final int E_xxx3 = 225; 
    public static final int E_NoChld = 226;             /* No Children */
    public static final int E_ISWI = 227;               /* Illegal SWI code */
    public static final int E_PrcAbt = 228;             /* Process Aborted */
    public static final int E_PrcFul = 229;             /* Process Table Full */
    public static final int E_IForkP = 230;             /* Illegal Fork Parameter */
    public static final int E_KwnMod = 231;             /* Known Module */
    public static final int E_BMCRC = 232;              /* Bad Module CRC */
    public static final int E_USigP = 233;              /* Unprocessed Signal Pending */
    public static final int E_NEMod = 234;              /* Non Existing Module */
    public static final int E_BNam = 235;               /* Bad Name */
    public static final int E_BMHP = 236;               /* (bad module header parity) */
    public static final int E_NoRam = 237;              /* No (System) Ram Available */
    public static final int E_DNE = 238;                /* Directory not empty */
    public static final int E_NoTask = 239;             /* No available Task number */

    public static final int E_Unit = 240;               /* Illegal Unit (drive) */
    public static final int E_Sect = 241;               /* Bad SECTor number */
    public static final int E_WP = 242;                 /* Write Protect */
    public static final int E_CRC = 243;                /* Bad Check Sum */
    public static final int E_Read = 244;               /* Read Error */
    public static final int E_Write = 245;              /* Write Error */
    public static final int E_NotRdy = 246;             /* Device Not Ready */
    public static final int E_Seek = 247;               /* Seek Error */
    public static final int E_Full = 248;               /* Media Full */
    public static final int E_BTyp = 249;               /* Bad Type (incompatable) media */
    public static final int E_DevBsy = 250;             /* Device Busy */
    public static final int E_DIDC = 251;               /* Disk ID Change */
    public static final int E_Lock = 252;               /* Record is busy (locked out) */
    public static final int E_Share = 253;              /* Non-sharable file busy */
    public static final int E_DeadLk = 254;             /* I/O Deadlock error */
}

