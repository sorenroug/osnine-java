package org.roug.osnine.format;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;
import org.junit.Before;
import org.junit.Test;

public class IdSectorTest {

    private final static int SECTOR_SIZE = 256;

    @Test
    public void create() {
        IdentificationSector ids = new IdentificationSector();
        assertNotNull(ids);
        ids.setTotalSectors(720);
        byte[] sector = ids.getSector();
        assertEquals(SECTOR_SIZE, sector.length);
    }

}
