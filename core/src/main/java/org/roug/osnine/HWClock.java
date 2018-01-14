package org.roug.osnine;

import java.time.LocalDateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Access to the host clock.
 * The software can <i>read</i> from six memory locations to
 * get year, month, day, hour, minute and second.
 * Time is local time.
 */
public class HWClock extends MemorySegment {

    public static final int YEAR_LOC = 0;
    public static final int MONTH_LOC = 1;
    public static final int DAY_LOC = 2;
    public static final int HOUR_LOC = 3;
    public static final int MINUTE_LOC = 4;
    public static final int SECOND_LOC = 5;

    private static final Logger LOGGER = LoggerFactory.getLogger(HWClock.class);

    /** Reference to CPU for the purpose of sending IRQ. */
    private Bus6809 cpu;

    /**
     * Constructor.
     */
    public HWClock(int start, Bus6809 cpu) {
        super(start, start + 6);
        this.cpu = cpu;
    }

    @Override
    protected int load(int addr) {
        LOGGER.debug("Reading {}", addr);
        LocalDateTime ldt = LocalDateTime.now();
        switch (addr - getStartAddress()) {
        case YEAR_LOC:
            return ldt.getYear() - 1900;
        case MONTH_LOC:
            return ldt.getMonthValue();
        case DAY_LOC:
            return ldt.getDayOfMonth();
        case HOUR_LOC:
            return ldt.getHour();
        case MINUTE_LOC:
            return ldt.getMinute();
        case SECOND_LOC:
            return ldt.getSecond();
        default:
            return 0;
        }
    }

    @Override
    protected void store(int addr, int val) {
        return;
    }

}
