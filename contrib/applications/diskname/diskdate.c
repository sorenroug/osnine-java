/*
 * Program to set the creation date of a disk to today's date.
 */
#include <stdio.h>
#include <direct.h>
#include <time.h>
#include <ctype.h>
#include "getopt.h"

#define SUCCESS 0
#define FAILURE 1

/*
 * An os9 string is terminated with highorder bit set
 * This helpful function copies it into a C-convention string.
 */
static char *
strcpyh(s1, s2)
    char *s1;
    char *s2;
{
    char *p = s1;
    while(*s2 > 0)
        *p++ = *s2++;
    *p++ = *s2 & 127;
    *p = '\0';
    return s1;
}

/*
 * Copy a C-string to an OS-9 string with highorder bit set.
 */
static int strcpyc(s1, s2, n)
    char *s1;
    char *s2;
    int n;
{
    while(n && *s2) {
        *s1++ = *s2++;
        n--;
    }
    s1--;
    *s1 |= 128;
    return;
}

main(argc,argv)
    int argc;
    char *argv[];
{
    int opt;
    int hasargs = 0;
    FILE *dfp;
    long totsect;
    int e;
    char buffer[40];
    char *namebuf = NULL;
    char *datebuf = NULL;
    char diskbuf[10];
    struct ddsect idsector;

    while ((opt = getopt(argc, argv, "c:n:")) != -1) {
        switch (opt) {
        case 'n':
            namebuf = optarg;
            hasargs = 1;
            break;
        case 'c':
            datebuf = optarg;
            hasargs = 1;
            break;
        default: /* '?' */
            fprintf(stderr, "Usage: %s [-c date] [-n name] {disk}\n", argv[0]);
            exit(FAILURE);
        }
    }

    pflinit();

    if (optind >= argc) {
        strcpy(diskbuf, defdrive());
    } else {
        strncpy(diskbuf, argv[optind], 8);
    }
    strcat(diskbuf, "@");

    dfp = fopen(diskbuf, (hasargs)?"r+":"r");
    if (dfp == NULL) {
        fprintf(stderr, "Unable to open: %s\n", argv[1]);
        exit(0xd6);
    }
    fread(&idsector, sizeof(idsector), 1, dfp);

    if (hasargs) {
        if (namebuf != NULL) {
            if (strlen(namebuf) > 32) {
                fprintf(stderr, "Label maximum length: 32\n");
                exit(3);
            }
        }
        if (datebuf != NULL) {
            timeparse(datebuf, buffer);
            _strass(idsector.dd_date, buffer, 5);
        }

        e = rewind(dfp);
        if (e == -1) {
            fprintf(stderr, "Unable to rewind\n");
            exit(1);
        }
        fwrite(&idsector, sizeof(idsector), 1, dfp);
    }
    strcpyh(buffer, idsector.dd_name);
    fclose(dfp);
    printf("Label: %s\n", buffer);
    printf("ID: %X\n", idsector.dd_dsk);
}

/* TODO: */
timeparse(datebuf, outbuf)
    char *datebuf;
    char *outbuf;
{
    int t,i = 0;
    while (*datebuf != '\0') {
        if (isdigit(*datebuf)) {
            t = (*datebuf - '0') * (i % 2)?1:10;
            i++;
        }
    }
    outbuf[0] += 100;  /* Add 21st century */
}
