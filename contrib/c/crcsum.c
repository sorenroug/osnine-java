/*
 *  Calculate CRC for any type of file.
 *  Useful to verify if a copy was made without corruption.
 *  The program will not match a module CRC as the last three bytes
 *  of the module are included in the calculation.
 */
#include <stdio.h>

static char *progname;

crcsum(fn)
    char *fn;
{
    register int num;
    FILE *inputFp;
    char accum[3];
    long filesize, crcresult;
    char buffer[BUFSIZ];

    if ((inputFp = fopen(fn,  "r")) == NULL) {
        fprintf(stderr, "%s Can't open %s\n", progname, fn);
    }

    filesize = 0;
    accum[0] = 0xFF;
    accum[1] = 0xFF;
    accum[2] = 0xFF;
    while ((num = fread(buffer, 1, BUFSIZ, inputFp)) != 0) {
        filesize += num;
        crc(buffer, BUFSIZ, accum);
    }
    fclose(inputFp);
    l3tol(&crcresult, accum, 1);
    printf("%6ld %06lX %s\n", filesize, crcresult, fn);
}

main(argc, argv)
int argc; char *argv[];
{
    int argi;

    pflinit();
    progname = argv[0];
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file...\n", progname);
        fprintf(stderr, "Calculates CRC of files.\n");
        exit(1);
    }

    for (argi = 1; argi < argc; argi++) {
        crcsum(argv[argi]);
    }
    exit(0);
}
