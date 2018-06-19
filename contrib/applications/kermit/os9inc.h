/*
 * os9inc.h  Os9 kermit includes, defines, and global variable declarations
 */

#define VERSION 1      /* Unix-OS9 Version number  */
#define RELEASE 6      /* Update release           */

/* most conditional compilation has been removed.    */
#define OS9          1        /* OS9 is related to UNIX */

#define NO_TANDEM    1        /* no x-on x-off          */

#ifdef COCO
#ifndef tps
/* tps is wrong in coco include file */
#define tps 60
#endif /* tps */
/* coco cannot handle floppy and other i/o at the same time */
#define nooverlap
#else /* not COCO */
#ifndef tps
#ifndef OSK   /* tps isn't in Os9/68k time.h */
/* make sure tps is correct in time.h ! */
#include <time.h>
#else /* OSK */
#define tps 100 /* assumption for os9/68k, since tps not defined in time.h */
#endif /* OSK */
#endif /* tps */
#endif /* COCO */

#ifdef OSK
#define SGXONOFF   /* os9/68k has xon/xoff in scf drivers */
#define SLEEPOK    /* " sleep function shoudld be relable */
#endif

/* see note in readtimed before making tps, ticstosleep,
 * or timeoutint a variable 
 */

#ifndef ticstosleep
/* tics to wait between read tries in reading packet (>=1) */
#define ticstosleep 4
#endif

#ifndef timeoutint
#define timeoutint 15  /* timeout interval in "seconds" */
                       /* actual timeout time will be longer, unless */
                       /* ticstosleep is 1, where it might be shorter */
#endif

#ifndef EXTERN
#define EXTERN extern  /* global varibles are extern in all but one module */
#endif

#include <stdio.h>       /* Standard UNIX definitions */

#ifndef SLEEPOK
#define sleep(sec) tsleep((sec)*tps+1)   /* library sleep routine is wrong */
                                         /* in some os9 C's (coco) */
#endif

/*
 * Speeds
 */
#ifndef OSK /* speeds different for Os9/68k */
#define B110    0
#define B300    1
#define B600    2
#define B1200   3
#define B2400   4
#define B4800   5
#define B9600   6
#define B19200  7
#endif

#include <sgstat.h>

/* Symbol Definitions */

#define MAXPACKSIZ  94       /* Maximum packet size */
#define SOH          1       /* Start of header */
#define CR          13       /* ASCII Carriage Return */
#define SP          32       /* ASCII space */
#define DEL        127       /* Delete (rubout) */
#define ESCCHR     '~'       /* Default escape character for CONNECT */

#define MAXTRY      10       /* Times to retry a packet */
#define MYQUOTE    '#'       /* Quote character I will use */
#define MYPAD        0       /* Number of padding characters I will need */
#define MYPCHAR      0       /* Padding character I need (NULL) */

#define MYEOL     '\n'       /* End-Of-Line character I need (none needed) */

#define MYTIME      10       /* Seconds after which I should be timed out */
#define MAXTIM      60       /* Maximum timeout interval */
#define MINTIM       2       /* Minumum timeout interval */

#define TRUE        -1       /* Boolean constants */
#define FALSE        0       /* (TRUE+1 == FALSE) */


/* Macro Definitions */

/*
 * tochar: converts a control character to a printable one by adding a space.
 *
 * unchar: undoes tochar.
 *
 * ctl:      converts between control characters and printable characters by
 *      toggling the control bit (ie. ^A becomes A and A becomes ^A).
 */
#define tochar(ch)    ((ch) + ' ')
#define unchar(ch)    ((ch) - ' ')
#define ctl(ch)       ((ch) ^ 64 )


/* Global Variables */

EXTERN int
   size,             /* Size of present data */
   rpsiz,            /* Maximum receive packet size */
   spsiz,            /* Maximum send packet size */
   pad,              /* How much padding to send */
   timint,           /* Timeout for foreign host on sends */
   n,                /* Packet number */
   n_total,          /* Total number of packets sent  */
   numtry,           /* Times this packet retried */
   oldtry,           /* Times previous packet retried */
   ttyfd,            /* File descriptor of tty for I/O, 0 if remote */
   server,           /* Host server mode flag      */
   hflg,             /* Host Server flag           */
   gflg,             /* Get file flag              */
   uflg,             /* Unix file transfer mode  */
   remot,            /* -1 means we're a remote kermit */
   image,            /* -1 means 8-bit mode */
   debug,            /* indicates level of debugging output (0=none) */
   filnamcnv,        /* -1 means do file name case conversions */
   filecount;        /* Number of files left to send */

EXTERN char
   state,            /* Present state of the automaton */
   rpack(),          /* Function to receive packet  */
   padchar,          /* Padding character to send */
   eol,              /* End-Of-Line character to send */
   escchr,           /* Connect command escape character */
   quote,            /* Quote character in incoming data */
   **filelist,       /* List of files to be sent */
   *filnam,          /* Current file name */
   recpkt[MAXPACKSIZ], /* Receive packet buffer */
   packet[MAXPACKSIZ]; /* Packet buffer */

EXTERN FILE
   *fp,              /* File pointer for current disk file */
   *log;             /* File pointer for Logfile */

