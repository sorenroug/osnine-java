package org.roug.osnine.format;

interface D0Descriptor {
    final static int SAS_SIZE = 8;

    final static int NUM_HEADS = 2;

    /** Number of tracks on disk. */
    final static int DISK_TRACKS = 40;

    /** Sectors per track. */
    final static int SECTORS_PER_TRACK = 18;

    /** Number of sectors in a cluster bit. */
    final static int CLUSTER_SIZE = 1;

}
