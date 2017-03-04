package org.roug.osnine.os9;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulate a process in the OS9 operating system.
 * This class could also hold a memory object to emulate memory management.
 */
public class Process {

    private static final int NUM_PATHS = 16; // Whatever _NFILE is set to in os9's stdio.h

    private OS9 kernel;

    private int processId;
    private int parentProcessId;

    /** Address in memory holding process data. */
    private int procAddr;

    /** Open paths. */
    private PathDesc[] paths = new PathDesc[NUM_PATHS];

    /** Working directory. */
    private String cwd;

    /** Execution directory, typically /d0/CMDS. */
    private String cxd;

    private static final Logger LOGGER = LoggerFactory.getLogger(Process.class);


    /**
     * Constructor.
     */
    public Process(OS9 kernel, Process parentProcessObj) {
        this.kernel = kernel;

        for (int inx = 0; inx < NUM_PATHS; inx++) {
            setPathDesc(inx, null);
        }

        int tmpx = kernel.x.intValue();
        kernel.x.set(kernel.read_word(DPConst.D_PrcDBT));  // 73- Process descriptor block address
        kernel.f_all64();                // Allocate the process descriptor
        kernel.write_word(DPConst.D_PrcDBT, kernel.x.intValue());
        procAddr = kernel.y.intValue();
        kernel.x.set(tmpx);
        setProcessId(kernel.getNextPID());
        if (parentProcessObj == null) {
            setParentProcessId(0); // No parent process.
        } else {
            setParentProcessId(parentProcessObj.getProcessId());
        }
    }

    public int getProcessBlock() {
        return procAddr;
    }

    public int getProcessId() {
        return processId;
    }

    public void setProcessId(int processId) {
        this.processId = processId;
        kernel.write(procAddr + PDConst.p_ID,  processId);      // Write process ID to memory
    }

    public void setParentProcessId(int parentProcessId) {
        this.parentProcessId = parentProcessId;
        kernel.write(procAddr + PDConst.p_PID,  parentProcessId);
    }

    public int getStackPointer() {
        return kernel.read_word(procAddr + PDConst.p_SP);
    }

    public void setStackPointer(int stackPointer) {
        kernel.write(procAddr + PDConst.p_SP,  stackPointer);
    }

    void setPathDesc(int pathNum, PathDesc desc) {
        paths[pathNum] = desc;
    }

    void setUserId(int userid) {
        kernel.write_word(procAddr + PDConst.p_User, userid);  // Write user id
    }

    void setAllocatedPages(int allocatedPages) {
        kernel.write(procAddr + PDConst.p_PagCnt, allocatedPages);  // Memory allocation in pages (Upper half of acc D).
    }

    void setPriority(int priority) {
        kernel.write(procAddr + PDConst.p_Prior,  100); // Write process priority
    }

    void setModuleStart(int moduleStart)  {
        kernel.write_word(procAddr + PDConst.p_PModul, moduleStart);  // Module start
    }

    public void setCWD(String directory) {
        cwd = directory;
    }

    public void setCXD(String directory) {
        cxd = directory;
    }

}
