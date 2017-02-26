package org.roug.osnine.os9;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Emulate a process in the OS9 operating system.
 */
public class Process {

    private static final int NUM_PATHS = 16; // Whatever _NFILE is set to in os9's stdio.h
    private OS9 kernel;

    int processId;
    int parentProcessId;

    /** Address in memory holding process data. */
    int procAddr;

    /* Open paths. */
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

        if (parentProcessObj != null) {
            setParentProcessId(parentProcessObj.getProcessId());
        } else {
            // No parent process.
            setParentProcessId(0);
        }

        int tmpx = kernel.x.intValue();
        kernel.x.set(kernel.read_word(DPConst.D_PrcDBT));  // 73- Process descriptor block address
        kernel.f_all64();                // Allocate the process descriptor
        procAddr = kernel.y.intValue();
        setProcessId(kernel.getNextPID());

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

    void setPathDesc(int pathNum, PathDesc desc) {
        paths[pathNum] = desc;
    }

    void setUserId(int userid) {
        kernel.write_word(procAddr + PDConst.p_User, userid);  // Write user id
    }

}
