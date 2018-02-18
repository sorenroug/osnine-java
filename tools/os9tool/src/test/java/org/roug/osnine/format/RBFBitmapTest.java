package org.roug.osnine.format;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;
import org.junit.Before;
import org.junit.Test;

public class RBFBitmapTest {

    private final static int SECTOR_SIZE = 256;

    @Test
    public void create720() {
        RBFBitmap bm = new RBFBitmap(720, 1);
        assertNotNull(bm);
        int lsn = bm.getFreeBit();
        assertEquals(2, lsn);

        int s = bm.getSectorsInAllocMap();
        assertEquals(1, s);

        byte[] sectors = bm.getSectors();
        assertEquals(SECTOR_SIZE, sectors.length);
    }

    /**
     * Create a bitmap that requires two sectors.
     */
    @Test
    public void create3072() {
        RBFBitmap bm = new RBFBitmap(3072, 1);
        assertNotNull(bm);
        int lsn = bm.getFreeBit();
        assertEquals(2, lsn);

        int s = bm.getSectorsInAllocMap();
        assertEquals(2, s);

        byte[] sectors = bm.getSectors();
        assertEquals(SECTOR_SIZE * 2, sectors.length);
    }
}
