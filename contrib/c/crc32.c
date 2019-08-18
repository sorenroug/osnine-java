/*
 * 32-bit CRC sum.
 * This program exists to verify that files transferred are identical
 * at both source and destination.
 * It uses the same algoritm as zip files.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define uint8_t unsigned char
#ifdef __STDC__
#define uint32_t unsigned int
#else
#define uint32_t unsigned long
#endif
#define const 

static int have_table = 0;
static uint32_t table[256];

/* Calculate CRC table. */
void table_init()
{
    int i, j;
    uint32_t rem;

    for (i = 0; i < 256; i++) {
        rem = i;  /* remainder from polynomial division */
        for (j = 0; j < 8; j++) {
            if (rem & 1) {
                rem >>= 1;
                rem ^= 0xedb88320;
            } else
                rem >>= 1;
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
            crc = (crc >> 8) ^ table[(crc & 0xff) ^ octet];
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

#ifdef OS9_6809
    pflinit();
#endif
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file...\n", argv[0]);
        fprintf(stderr, "Calculates CRC of files.\n");
        /* Self-test */
        strcpy((char*)buffer, teststr);
        crc = 0;
        crc = rc_crc32(crc, buffer, strlen(teststr));
        if (crc != 0x414fa339) {
            fprintf(stderr, "FAIL: Self-test gave wrong result: %lX, len=%d\n",
                    crc, strlen(teststr));
        }
        exit(1);
    }

    for (argi = 1; argi < argc; argi++) {
        fn = argv[argi];
        if ((inputFp = fopen(fn,  "rb")) == NULL) {
            fprintf(stderr, "Can't open %s\n", fn);
        }
        filesize = 0;
        crc = 0;
        while ((num = fread(buffer, 1, BUFSIZ, inputFp)) != 0) {
            filesize += num;
            crc = rc_crc32(crc, buffer, num);
        }
        printf("%s: %X - size: %lu\n", fn, crc, filesize);
        fclose(inputFp);
    }
    exit(0);
}

