package org.roug.osnine.os9;

/**
 *     Module Definitions.
 *
 *     Universal Module Offsets
 */
public interface ModuleConst {
    static final int m_ID = 0x0; /* 2 ID Code */
    static final int m_Size = 0x2; /* 2 Module Size */
    static final int m_Name = 0x4; /* 2 Module Name */
    static final int m_Type = 0x6; /* 1 Type / Language */
    static final int m_Revs = 0x7; /* 1 Attributes / Revision Level */
    static final int m_Parity = 0x8; /* 1 Header Parity */
    static final int m_IDSize = 0x9;  /* Module ID Size */
    //
    //     Type-Dependent Module Offsets
    //
    //   System, File Manager, Device Driver, Program Module
    //
    static final int m_Exec = 0x9; /* 2 Execution Entry Offset */
    //
    //   Device Driver, Program Module
    //
    static final int m_Mem = 0xB; /* 2 Stack Requirement */
    //
    //   Device Driver, Device Descriptor Module
    //
    static final int m_Mode = 0xD; /* 1 Device Driver Mode Capabilities */
    //
    //   Device Descriptor Module
    //
    static final int m_FMgr = 0x9; /* 2 File Manager Name Offset */
    static final int m_PDev = 0xB; /* 2 Device Driver Name Offset */
    // m_Mode (defined above)
    static final int m_Port = 0xE; /* 3 Port Address */
    static final int m_Opt = 0x11; /* 1 Device Default Options */
    //static final int m_DTyp = 0; /* 1 Device Type */
    //
    //   Configuration Module Entry Offsets
    //
    static final int MaxMem = 0x9; /* 3 Maximum Free Memory */
    static final int PollCnt = 0xC; /* 1 Entries in Interrupt Polling Table */
    static final int DevCnt = 0xD; /* 1 Entries in Device Table */
    static final int InitStr = 0xE; /* 2 Initial Module Name */
    static final int SysStr = 0x10; /* 2 System Device Name */
    static final int StdStr = 0x12; /* 2 Standard I/O Pathlist */
    static final int BootStr = 0x14; /* 2 Bootstrap Module name */
}
