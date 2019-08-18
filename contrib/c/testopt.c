#include <stdio.h>
#include "getopt.h"

#define SUCCESS 0
#define FAILURE 1

int
main(argc,argv)
    int argc;
    char *argv[];
{
    int flags, opt;
    int nsecs, tfnd;

    nsecs = 0;
    tfnd = 0;
    flags = 0;
    while ((opt = getopt(argc, argv, "nt:")) != -1) {
        switch (opt) {
        case 'n':
            flags = 1;
            break;
        case 't':
            nsecs = atoi(optarg);
            tfnd = 1;
            break;
        default: /* '?' */
            fprintf(stderr, "Usage: %s [-t nsecs] [-n] name\n", argv[0]);
            exit(FAILURE);
        }
    }

    printf("flags=%d; tfnd=%d; nsecs=%d; optind=%d\n",
            flags, tfnd, nsecs, optind);

    if (optind >= argc) {
        fprintf(stderr, "Expected argument after options\n");
        exit(FAILURE);
    }

    printf("name argument = %s\n", argv[optind]);
    exit(SUCCESS);
}
