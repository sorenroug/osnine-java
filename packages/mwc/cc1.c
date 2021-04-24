/*
 * Compilation instructions:
 * DRAGON 64:
 * cc1 -DDRAGON -E=4 -n=cc1.dragon -F=newcc1 cc1.c
 *
 * TANDY:
 * cc1 -DTANDY -E=4 -F=newcc1 cc1.c
 * 
 * Unbranded:
 * cc1 -E=4 -F=newcc1 cc1.c
 */
#include <stdio.h>
#include <module.h>

#define boolean int
#define TRUE 1
#define FALSE 0

direct boolean comments = FALSE; /* C opt given to compiler */
direct int nmOverid = 0; /* F option - Override default name */
direct int u0005 = 0;             /* Unused */
direct boolean noStkChk = FALSE; /* S option */
direct int u0009 = 0;             /* Unused */
direct boolean noLink = FALSE; /* R option */
direct boolean noAsm = FALSE; /* A option */
direct int u000F = 0;
direct int noOptim = 0; /* O option */
direct int u0013 = 0;
direct boolean profiler = FALSE; /* P option */
direct int numLibs = 0; /* Number of libraries */
direct boolean noExec = FALSE; /* X option */
direct int u001B = 0;             /* Unused */
direct char *u001D = NULL;
direct char *memSize[] = { 0 }; /* Initial memory size */
direct char *edition[] = { 0 };
direct char *realName; /* N argument given to linker */
direct int numSrcs; /* Number of source files */
direct int numDefs;
direct int hasRlocs;
/* At $002B */
direct FILE *comfd;

/* At $002D,y */
char tmpname[20] = "ctmp.XXXXXX";
/* At $0041,y */
char ccom[30] = "c.com";

extern char *getdev();

#ifdef TANDY
#define DUALDISK 1
#define VERSION "RS 01.00.00"
static char
*banner = "CC1 VERSION %s\nCOPYRIGHT 1983 MICROWARE\nREPRODUCED UNDER LICENSE\nTO TANDY\n";
#else
#ifdef DRAGON
#define DUALDISK 1
#define VERSION "1.1"

static char
*banner = "CC1 VERSION %s\nCOPYRIGHT 1983 MICROWARE\nREPRODUCED UNDER LICENSE\nTO DRAGON DATA, LTD.\n";
#else
#define VERSION "1.1"
static char
*banner = "CC1 Version %s Copyright 1983 Microware\nReproduced under license\n";
#endif
#endif

static char *libs[4]; /* table for libraries */

char *sources[100]; /* Files to compile */
char suffices[100];
char *defines[100]; /* Defines */
char cmdLine[60];
char mTmpFile[60];
char rTmpFile[60];
char temp1[60];
char temp2[60];
char outName[60]; /* Output file name */
char g0573[50];
char g05A5[20];

/* L0180 */
int main(argc, argv)
    int argc;     /* argc = $13,s */
    char **argv;  /* argv = $15,s */
{
    char s0E;
    char *s0C;
    char **s0A;
    int s08,s06,s04,s02,s00;

    fprintf(stderr, banner, VERSION); /* $005F,y */
    s08 = 0;
    mktemp(tmpname);

    if ((comfd = fopen(ccom, "w")) == NULL) {
        errexit("can't open shell command file");
    }
    /* L0445 */
    while (--argc > 0 && (++s08 < 100)) {
        
        if (*(s0C = *++argv) == '-') {
            while (*++s0C) {
                switch (*s0C & 0xDF) {
                    case 'D': /* Define identifier */
                        if (s0C[1] == '\0') goto nomore;
                        *--s0C='-';
                        s0C[1] = 'D';
                        defines[numDefs++] = s0C;
                        goto nomore;
                    case 'N': /* Set module name */
                        *--s0C = '-';
                        realName = s0C;
                        goto nomore;
                    case 'X': /* Don't execute c.com */
                        noExec = TRUE;
                        break;
                    case 'S': /* Stop stack checking */
                        noStkChk = TRUE;
                        break;
                    case 'C': /* Source as comments */
                        comments = TRUE;
                        break;
                    case 'P': /* Invoke profiler */
                        profiler = TRUE;
                        break;
                    case 'O': /* Inhibit optimizer */
                        noOptim = TRUE;
                        break;
                    case 'R': /* Suppress linking */
                        noLink = TRUE;
                        break;
                    case 'A': /* Suppress assembly */
                        noAsm = TRUE;
                        break;
                    case 'E':
                        s0A = edition;
                        goto optm;
                    case 'M': /* Memory size for linker */
                        s0A = memSize;
                        optm: *s0C = *s0C & 0x5F;
                        if (s0C[1] == '\0') goto nomore;
                        *--s0C = '-';
                        *s0A = s0C;
                        goto nomore;
                    case 'F': /* Output file name */
                        if (*++s0C == '=') {
                            strcpy(outName, &s0C[1]);
                            if (! *outName) goto nomore;
                            nmOverid++;
                            s0E = suffixOf(outName);
                            if(s0E == 'c' || s0E == 'r' || s0E == 'C' || s0E == 'R')
                                errexit("Suffix '%.c' not allowed for output", s0E);
                        }
                        goto nomore;
                    case 'L': /* Library name */
                        if (s0C[1] == '=') {
                            if (numLibs == 4)
                                errexit("Too many libraries");
                            *--s0C = '-';
                            libs[numLibs++] = s0C;
                        }
                        goto nomore;
                    default:
                        errexit("unknown flag : -%c\n", *s0C);
                        break;
                }
            } /* end while */
        nomore: ;
        } else {
            s0E = suffixOf(*argv);

            switch (s0E) {
                case 'R':
                case 'r':
                    hasRlocs = 1;
                case 'A':
                case 'C':
                case 'a':
                case 'c':
                    suffices[numSrcs] = s0E;
                    sources[numSrcs] = *argv;
                    numSrcs++;
                    break;
                default:
                    errexit("%s : no recognized suffix", *argv);
                    break;
            }
        }
    } /* end while */
    if (numSrcs == 0) {
        fprintf(stderr, "no files!");
        exit(0);
    }
    if (noAsm + noLink > 1) {
        errexit("incompatible flags", NULL);
    }
    if (nmOverid) {
        if (numSrcs > 1) {
            if(noAsm || noLink) {
                errexit("%s : output name not applicable", outName);
            }
        }
    }
    if (!nmOverid) {
        if (numSrcs == 1)
            strcpy(outName, *sources);
        else
            strcpy(outName, "output");
    }
    strcpy(mTmpFile, tmpname);
    strcat(mTmpFile, ".m");
    strcpy(rTmpFile, tmpname);
    strcat(rTmpFile, ".r");
    for(s08 = 0; s08 < numSrcs; s08++) {
        wrtcom("echo '");     /* L052B */
        wrtcom(sources[s08]);
        wrtcom("'\n");
        if (suffices[s08] == 'C' || suffices[s08] == 'c') {
            s00 = 1;
            strcpy(temp1, mTmpFile);
            setSufx(temp1, 'm');
            wrtcom("-x\necho c.prep:\n");
            wrtcom("C.PREP ");
            if (comments)
                wrtcom("-l ");
            if (*edition) {
                wrtcom(*edition);
                wrtcom(" ");
            }
            for (s04 = 0; s04 < numDefs;) {
                wrtcom(defines[s04++]);
                wrtcom(" ");
            }
            wrtcom(sources[s08]);
            wrtcom(" >");
            wrtcom(temp1);
            strcpy(temp2, temp1);
            wrtcom("\nx\necho c.pass1:\n");
            wrtcom("C.PASS1 ");
            wrtcom(temp2);
            if (u0013)
                wrtcom("-e ");
            if (noStkChk)
                wrtcom(" -s ");
            if (profiler)
                wrtcom(" -p ");
            strcpy(temp1, mTmpFile);
            setSufx(temp1, 'i');
            wrtcom(" -o=");
            wrtcom(temp1);
            if (!u0013) {
                wrtcom("\ndel ");
                wrtcom(temp2);
                wrtcom("\n");
            } else {
                strcpy(g0573, temp2);
            }
            wrtcom("echo c.pass2:\n");
            wrtcom("C.PASS2 ");
            strcpy(temp2, temp1);
            wrtcom(temp2);
            if (noStkChk)
                wrtcom(" -s ");
            if (profiler)
                wrtcom(" -p ");
            if (u0013) {
                wrtcom(" ");
                wrtcom(g0573);
            }
            if (noAsm) {
                if (nmOverid) {
                    strcpy(temp1, outName);
                } else {
                    strcpy(temp1, sources[s08]);
                    setSufx(temp1, 'a');
                }
            } else {
                setSufx(temp1, 'a');
            }
            wrtcom(" -o=");
            wrtcom(temp1);
            wrtcom("\ndel ");
            wrtcom(temp2);
            if (u0013) {
                wrtcom(" ");
                wrtcom(g0573);
            }
            wrtcom("\n");
        } else {
            s00 = 0;
        }
        /* Assembly step */
        if (!noAsm && suffices[s08] != 'R' && suffices[s08] != 'r') {
            if (suffices[s08] == 'A' || suffices[s08] == 'a') {
                strcpy(temp2, sources[s08]);
            } else {
                strcpy(temp2, temp1);
            }
            if (!noOptim) {
                wrtcom("echo c.opt:\n");
                wrtcom("C.OPT ");
                wrtcom(temp2);
                strcpy(temp1, mTmpFile);
                setSufx(temp1, 'o');
                wrtcom(" ");
                wrtcom(temp1);
                wrtcom("\n");
                if (s00) {
                    wrtcom("del ");
                    wrtcom(temp2);
                    wrtcom("\n");
                }
                strcpy(temp2, temp1);
            }    
            wrtcom("echo c.asm:\n");
            wrtcom("C.ASM ");
            wrtcom(temp2);
            if (!(numSrcs != 1 || noLink)) {
                strcpy(temp1, rTmpFile);
            } else {
                if (nmOverid && noLink) {
                    strcpy(temp1, outName);
                } else {
                    setSufx(sources[s08], 'r');
                    strcpy(temp1, sources[s08]);
                }
            }
            wrtcom(" -o=");
            wrtcom(temp1);
            wrtcom("\n");
            if (s00) {
                wrtcom("del ");
                wrtcom(temp2);
                wrtcom("\n");
            }
        }
    }
    if (!noAsm && !noLink) {
        if (!nmOverid) {
            setSufx(outName, '\0');
        }
        wrtcom("echo c.link:\n");
        wrtcom("C.LINK ");
#ifdef DUALDISK
        s0C = "/d0";
#else
        s0C = getdev();
#endif
        wrtcom(s0C);
        wrtcom("/lib/cstart.r");
        if ((numSrcs == 1) && (suffices[0] != 'R') && (suffices[0] != 'r')) {
                wrtcom(" ");
                wrtcom(u001D = temp1);
        } else {
            for (s08 = 0; s08 < numSrcs; s08++) {
                wrtcom(" ");
                wrtcom(sources[s08]);
            }
            u001D = NULL;
        }
        wrtcom(" -o=");
        wrtcom(outName);
        for (s06 = 0; s06 < numLibs; s06++) {
            wrtcom(" ");
            wrtcom(libs[s06]);
        }
        wrtcom(" -l=");
        wrtcom(s0C);
        wrtcom("/lib/clib.l ");
        wrtarg(realName);
        wrtarg(*edition);
        wrtarg(*memSize);
        wrtcom("\n");
        if (u001D) {
            wrtcom("del ");
            wrtcom(u001D);
            wrtcom("\n");
        }
    }
    fclose(comfd);
    if (!noExec) {
        strcpy(cmdLine, "-t -p\n");
        if (freopen(ccom, "r", stdin) == NULL) {
            errexit("can't reopen '%s'", ccom);
        }
        chain("shell", strlen(cmdLine), cmdLine, 1,1,0);
    }
}

/*
 * Find the device where the libraries are.
 * Links to "ccdevice". If not found then try defdrive().
 *
 * This code is not called from anywhere.
 */
/* L0BAB */
char *getdev()
{
    register char *c;
    char *x;
    
    /* Link to data module */
    if ((c = modlink("ccdevice", 4, 0)) == -1) {
        return defdrive();
    } else {
        x = c->m_data + c;
        strcpy(g05A5, x);
        munlink(c);
    }
    return g05A5;
}

/* L0BFC */
/* Write argument to c.com and append space */
int wrtarg(arg1)
    char *arg1;
{
    if (arg1 != NULL) {
        wrtcom(arg1);
        wrtcom(" ");
    }
}

/* L0C1E */
int errexit(arg1, arg2)
    char *arg1, *arg2;
{
    fprintf(stderr, arg1, arg2);
    putc('\n', stderr);
    exit(1);
}

/* L0C53 */
/* If filename has no suffix then return.
 * Otherwise replace the suffix with arg2.
 */
int setSufx(filename, sufxchar)
    register char *filename;
    char sufxchar;
{
    while (*filename++) ; /* Find the end */
    if (filename[-3] != '.') return;
    if (sufxchar == '\0') filename[-3] = '\0';
    else filename[-2] = sufxchar;
}

/* L0C79 */
/* Find the suffix of the file argument. */
int suffixOf(arg1)
    register char *arg1;
{
    int s01;
    char s00;
    
    for (s01 = 0; (s00 = *arg1++) != 0; ) {
        if (s00 == '/') s01 = 0;
        else s01++;
    }
    if (s01 > 29 || s01 <= 2 || arg1[-3] != '.')
        return 0;
    else
        return (arg1[-2] | 0x40);

}

/* L0CBF */
int wrtcom(arg1)
    char *arg1;
{
    fprintf(comfd, arg1);
}
