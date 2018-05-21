/*
 *  Convert UNIX to OS9 line conventions.
 *  Convert all files given as arguments.
 */
#include <stdio.h>

#define NL 10
#define CR 13

static char *progname;

convert(fn)
    char *fn;
{
    register int ch;
    FILE *inputFp;
    FILE *outputFp;

    if ((inputFp = fopen(fn,  "r")) == NULL) {
        fprintf(stderr, "%s Can't open %s\n", progname, fn);
        exit(2);
    }

    if ((outputFp = fopen(fn, "r+")) == NULL) {
        fprintf(stderr, "%s Can't open file %s for update\n", progname, fn);
        exit(2);
    }

    while ((ch = fgetc(inputFp)) != EOF) {
        if (ch == NL) {
            ch = CR;
        }
        putc(ch, outputFp);
    }
    fclose(inputFp);
    fclose(outputFp);
}

main(argc, argv)
int argc; char *argv[];
{
    int argi;

    progname = argv[0];
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file...\n", progname);
        fprintf(stderr, "Replaces newlines with carriage return in files.\n");
        exit(1);
    }

    for (argi = 1; argi < argc; argi++) {
        convert(argv[argi]);
    }
    exit(0);
}
