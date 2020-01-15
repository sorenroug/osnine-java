/* Wrap data files in an OS-9 data module.
   The module can then be loaded into memory.
*/
#include <stdio.h>

#define HSIZE 13
#define CRCSIZE 3

static int headxor = 0xFF;
static char *modname = "DataModule";
static char accum[3];

long fsize(fp)
    FILE *fp;
{
    long size;

    if(getstat(2, fileno(fp), &size) == 0)
        return size;
    else
        return 0L;
}

main(argc, argv)
    int argc;
    char *argv[];
{
    int i,c,len;
    long sumsize = 0;
    FILE *ifp;
    char *m;
    char buf[BUFSIZ];

    accum[0] = 0xFF;
    accum[1] = 0xFF;
    accum[2] = 0xFF;

    /* Get sizes, check if all files can fit */
    for (i=1; i < argc; i++) {
        ifp = fopen(argv[i], "r");
        sumsize += fsize(ifp);
        sumsize += strlen(argv[i]);
        sumsize += 4L; /* size of per file attributes */
        fclose(ifp);
        if (sumsize > 0xE000L) {
            fprintf(stderr, "Module will become too large\n");
            exit(1);
        }
    }
    hint(0x87CD); /* Write header */
    /* Write module size */
    c = (int)(sumsize & 0xFFFF);
    hint(c  + strlen(modname) + HSIZE + CRCSIZE);
    hint(HSIZE); /* Write offset to name */
    hint(0x4081); /* Data type, Reentrant, revision 1 */
    hbyte(headxor);
    hint(HSIZE + strlen(modname)); /* Data offset */
    hint(c); /* Data size */
    wstr(modname);

    for (i=1; i < argc; i++) {
        ifp = fopen(argv[i], "r");
        hint(strlen(argv[i]) + 2); /* Offset to file content */
        sumsize = fsize(ifp);
        hint((int)(sumsize & 0xFFFF));  /* Size of data */
        wstr(argv[i]);  /* File name */
        while ((len = fread(buf, 1, BUFSIZ, ifp)) > 0) {
            crc(buf, len, accum);
            fwrite(buf, 1, len, stdout);
        }
        fclose(ifp);
    }

    putchar(accum[0] ^ 0xFF);
    putchar(accum[1] ^ 0xFF);
    putchar(accum[2] ^ 0xFF);
    fflush(stdout);
}

hbyte(b)
    int b;
{
    char c = (char)b;
    putchar(b);
    headxor ^= c;
    crc(&c, 1, accum);
}

hint(b)
    int b;
{
    int high;
    high = b >> 8;

    putchar(high);
    headxor ^= high;

    putchar(b);
    headxor ^= b;
    crc(&b, sizeof(int), accum);
}

/*
 * Write null-terminated string with high-order bit termination.
 */
wstr(s)
    char *s;
{
    for (; *s; s++) {
        if (*(s+1) == '\0')
            hbyte(*s | 0x80);
        else
            hbyte(*s);
    }
}
