/*
 * 32-bit CRC sum.
 * This program exists to verify that files transferred are identical
 * at both source and destination.
 * It uses the same algoritm as zip files.
 *
 * OS-9/6809 edition
 */
#include <stdio.h>

#define uint8_t char
#define uint32_t long
#define const 
#define void int

static int have_table = 0;
static uint32_t table[256];

/* Shift a long int right without keeping the sign
 * Assumes that the sign bit is shifted right as well.
 */
uint32_t llsr(lp, num)
    uint32_t lp;
    int num;
{
    lp >>= 1;
    if (lp < 0) lp &= 0x7FFFFFFFL;
    num--;
    lp >>= num;
    return lp;
}

/* Calculate CRC table. */
void table_init()
{
    int i, j;
    uint32_t rem;

    for (i = 0; i < 256; i++) {
        rem = i;  /* remainder from polynomial division */
        for (j = 0; j < 8; j++) {
            if (rem & 1) {
                rem = llsr(rem, 1);
                rem ^= 0xEDB88320L;
            } else
                rem = llsr(rem, 1);
        }
        table[i] = rem;
    }
    have_table = 1;
}

uint32_t
rc_crc32(crc, buf, len)
    uint32_t crc;
    uint8_t *buf;
    int len;
{
    uint8_t octet;
    uint8_t *p, *q;

    /* This check is not thread safe; there is no mutex. */
    if (have_table == 0) table_init();

    crc = ~crc;
    q = buf + len;
    for (p = buf; p < q; p++) {
            octet = *p;  /* Cast to unsigned octet. */
            crc = llsr(crc, 8) ^ table[(crc & 0xff) ^ (octet & 0xff)];
    }
    return ~crc;
}

 
int
main(argc, argv)
int argc; char *argv[];
{
    int argi;
    int num;
    uint32_t crc;
    FILE *inputFp;
    char *fn;
    long filesize;
    char *teststr = "The quick brown fox jumps over the lazy dog";
    uint8_t buffer[BUFSIZ];

    pflinit();
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file...\n", argv[0]);
        fprintf(stderr, "Calculates CRC of files.\n");
        /* Self-test */
        strcpy((char*)buffer, teststr);
        crc = 0;
        crc = rc_crc32(crc, buffer, strlen(teststr));
        if (crc != 0x414fa339L) {
            fprintf(stderr, "FAIL: Self-test gave wrong result: %lX, len=%d\n",
                    crc, strlen(teststr));
        }
        exit(1);
    }

    for (argi = 1; argi < argc; argi++) {
        fn = argv[argi];
        if ((inputFp = fopen(fn,  "r")) == NULL) {
            fprintf(stderr, "Can't open %s\n", fn);
        }
        filesize = 0;
        crc = 0;
        while ((num = fread(buffer, 1, BUFSIZ, inputFp)) != 0) {
            filesize += num;
            crc = rc_crc32(crc, buffer, num);
        }
        fclose(inputFp);
        printf("%s: %lX - size: %ld\n", fn, crc, filesize);
    }
    exit(0);
}

