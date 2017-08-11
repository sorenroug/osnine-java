package org.roug.osnine.os9;

/* error code conditions */
/* WDDisk "TEST" Error Codes */
interface ErrCodes {
    int E_WD2797 = 101;             /* WD 1002-05 WD2797 FD controller */
    int E_WD1010 = 102;             /* WD 1002-05 WD1010 HD controller */
    int E_WDSBuf = 103;             /* WD 1002-05 sector buffer */
    int E_WD1014 = 104;             /* WD 1002-05 WD1014 error detection or bus */
    int E_WD1015 = 105;             /* WD 1002-05 WD1015 control processor */

  /* System Dependent Error Codes */
    int E_IWTyp = 183;              /* illegal window type */
    int E_WADef = 184;              /* window already defined */
    int E_NFont = 185;              /* font not found */
    int E_StkOvf = 186;             /* Stack overflow */
    int E_IllArg = 187;             /* Illegal argument */
    int E_188 = 188;                /* reserved */
    int E_ICoord = 189;             /* Illegal coordinates */
    int E_Bug = 190;                /* Bug (should never be returned) */
    int E_BufSiz = 191;             /* Buffer size is too small */
    int E_IllCmd = 192;             /* Illegal command */
    int E_TblFul = 193;             /* Screen or window table is full */
    int E_BadBuf = 194;             /* Bad/Undefined buffer number */
    int E_IWDef = 195;              /* Illegal window definition */
    int E_WUndef = 196;             /* Window undefined */
    int E_Up = 197;                 /* up-arrow pressed on SCF I$ReadLn with PD.UP enabled */
    int E_Dn = 198;                 /* dn-arrow pressed on SCF I$ReadLn with PD.DN enabled */
    int E_Alias = 199; 

  /* Standard OS-9 Error Codes */
    int E_PthFul = 200;             /* Path Table full */
    int E_BPNum = 201;              /* Bad Path Number */
    int E_Poll = 202;               /* Polling Table Full */
    int E_BMode = 203;              /* Bad Mode */
    int E_DevOvf = 204;             /* Device Table Overflow */
    int E_BMID = 205;               /* Bad Module ID */
    int E_DirFul = 206;             /* Module Directory Full */
    int E_MemFul = 207;             /* Process Memory Full */
  
    int E_UnkSvc = 208;             /* Unknown Service Code */
    int E_ModBsy = 209;             /* Module Busy */
    int E_BPAddr = 210;             /* Bad Page Address */
    int E_EOF = 211;                /* End of File */
    int E_xxx1 = 212;
    int E_NES = 213;                /* Non-Existing Segment */
    int E_FNA = 214;                /* File Not Accesible */
    int E_BPNam = 215;              /* Bad Path Name */
    int E_PNNF = 216;               /* Path Name Not Found */
    int E_SLF = 217;                /* Segment List Full */
    int E_CEF = 218;                /* Creating Existing File */
    int E_IBA = 219;                /* Illegal Block Address */
    int E_HangUp = 220;             /* Carrier Detect Lost */
    int E_MNF = 221;                /* Module Not Found */
    int E_xxx2 = 222;
    int E_DelSP = 223;              /* Deleting Stack Pointer memory */
    int E_IPrcID = 224;             /* Illegal Process ID */
    int E_BPrcID = E_IPrcID;        /* Bad Process ID (formerly #238) */
    int E_xxx3 = 225; 
    int E_NoChld = 226;             /* No Children */
    int E_ISWI = 227;               /* Illegal SWI code */
    int E_PrcAbt = 228;             /* Process Aborted */
    int E_PrcFul = 229;             /* Process Table Full */
    int E_IForkP = 230;             /* Illegal Fork Parameter */
    int E_KwnMod = 231;             /* Known Module */
    int E_BMCRC = 232;              /* Bad Module CRC */
    int E_USigP = 233;              /* Unprocessed Signal Pending */
    int E_NEMod = 234;              /* Non Existing Module */
    int E_BNam = 235;               /* Bad Name */
    int E_BMHP = 236;               /* (bad module header parity) */
    int E_NoRam = 237;              /* No (System) Ram Available */
    int E_DNE = 238;                /* Directory not empty */
    int E_NoTask = 239;             /* No available Task number */

    int E_Unit = 240;               /* Illegal Unit (drive) */
    int E_Sect = 241;               /* Bad SECTor number */
    int E_WP = 242;                 /* Write Protect */
    int E_CRC = 243;                /* Bad Check Sum */
    int E_Read = 244;               /* Read Error */
    int E_Write = 245;              /* Write Error */
    int E_NotRdy = 246;             /* Device Not Ready */
    int E_Seek = 247;               /* Seek Error */
    int E_Full = 248;               /* Media Full */
    int E_BTyp = 249;               /* Bad Type (incompatable) media */
    int E_DevBsy = 250;             /* Device Busy */
    int E_DIDC = 251;               /* Disk ID Change */
    int E_Lock = 252;               /* Record is busy (locked out) */
    int E_Share = 253;              /* Non-sharable file busy */
    int E_DeadLk = 254;             /* I/O Deadlock error */
}

