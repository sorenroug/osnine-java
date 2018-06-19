/*
 * os9ker.c  Os9 kermit main program
 */

#define EXTERN  /* global variables are actually declared here */
#include "os9inc.h"

/*
 * K e r m i t  File Transfer Utility
 *
 * UNIX Kermit, Columbia University, 1981, 1982, 1983
 * Bill Catchings, Bob Cattani, Chris Maio, Frank da Cruz, Alan Crosswell
 *
 *  Also:       Jim Guyton, Rand Corporation
 *              Walter Underwood, Ford Aerospace
 *              Glenn Seaton, Kennedy Space Center
 *              Bradley Bosch,
 *              Robert Larson, U. of Southern California <Blarson@usc-ecl>      
 *              James Jones
 *
 *
 *  usage:  kermit c [lbe line baud escapechar]         to connect
 *          kermit s [d..iflb line baud] file ...       to send files
 *          kermit r [d..iflb line baud]                to receive files
 *
 *  where   c=connect, s=send, r=receive,
 *          d=debug, i=image mode, f=no filename conversion, l=tty line,
 *          b=baud rate, e=escape char.
 *
 *  For remote Kermit, format is either:
 *       kermit r               to receive files
 *  or   kermit s file ...            to send files
 *
 */
/*
 *   OS-9 Version and differences
 *   kermit s[ifdl] path filename      is send format
 *   OS-9 version has time-out on rx data of MAXTRY
 *     if not server "W"ait mode.
 *
 *   Host Server command
 *   Kermit h[idfl path]           Host Server mode
 *   Kermit g[idf]l path filename  Get file from a server
 *   Kermit q[idf]l path           Tell Host Server to terminate
 *
 */

/*
 *  Modification History:
 *
 * 07/02/85 ral     Add connect command from Brad Bosch's os9 kermit
 *                  Rewrite setstat/getstat for putting in raw mode (os9raw.c)
 *                  Add flushinput call to send packet routine
 *                  Rewrite timeout code to be system independent and more
 *                    comprehensive.  (routine readtimed)
 *                  Add compile switches for timeout
 *                  Add nooverlap switch for good performance on CoCo and others
 *                  (coco can't overlap disk and serial i/o, and will timeout
 *                   often if the code assumes it can.  Others should overlap to
 *                   maximize performance.)
 *                  Fix problems with image vs. text.  Make CRLF processing the
 *                    default, (eliminate 'u' mode)
 *                  Make lowercasing of received filenames the default
 *                  Add handling of nak and timeout in get and quit commands
 *                  Allow / in filenames sent in get command
 *                  Fix long-standing bug in receiving SOH in the middle of a
 *                  packet
 *                  Miscellaneous indentation and other coding fixes.
 *                  (Don't blame the indentation on me, someone's tab to space
 *                   converter must have done this mess.)
 * 06/29/85 ral     Split into smaller separately compilable files,
 *                  move #defines, #includes, and global variables to os9inc.h
 *                  rename everything so it fits with Columbia distribution
 *
 * April 9, 1985    Move Option messages, debug show Rpack
 *                  rx cksum if bad.
 * Feburary 27, 1985 Defined rpack type char for OS-9/68k
 * December 12, 1984 fix OS-9 time-out, Server to standard
 * November 19, 1984 Added OS9 time-out for Rx data.  W.G. Seaton
 * November 14, 1984 Added Host Server Mode  W.G. Seaton
 *                 - Added include kermserv.c for server function
 *                 - Added include kermget.c for get function
 * November  9,1984 Modified for OS9  by W.G. Seaton,NASA KSC
 *  Oct. 17 Included fixes from Alan Crosswell (CUCCA) for IBM_UTS:
 *       - Changed MYEOL character from \n to \r.
 *       - Change char to int in bufill so getc would return -1 on
 *         EOF instead of 255 (-1 truncated to 8 bits)
 *       - Added read() in rpack to eat the EOL character
 *       - Added fflush() call in printmsg to force the output
 *       NOTE: The last three changes are not conditionally compiled
 *        since they should work equally well on any system.
 *
 *       Added support for error packets and cleaned up the printing
 *       routines.
 */

/*
 *  m a i n
 *
 *  Main routine - parse command and options, set up the
 *  tty lines, and dispatch to the appropriate routine.
 */

main(argc, argv)
int     argc;           /* Character pointers to and count of */
char    **argv;         /* command line arguments */
{
        char    *ttyname,       /* tty name for LINE argument */
                *cp;            /* char pointer */
        int     speed,          /* speed of assigned tty, */
                len, num,       /* length, number  */
                qflg, cflg,     /* GET, CONNECT flags   */
                rflg, sflg;     /* flags for RECEIVE, SEND */

        struct sgbuf 
                insave,         /* Input scf mode save */
                outsave,        /* Output scf mode save */
                linesave;       /* mode of tty line in LINE option */

        if (argc < 2)
                usage();        /* Make sure there's a command line */

        cp = *++argv; 
        argv++; 
        argc -= 2;      /* Set up pointers to args */

        /*  Initialize these values and hope the first packet gets across OK */

        eol = CR;               /* EOL for outgoing packets */
        quote = '#';            /* Standard control-quote char "#" */
        pad = 0;                /* No padding */
        padchar = NULL;         /* Use null if any padding wanted */

        speed = cflg = sflg = rflg = 0; /* Turn off all parse flags */
        uflg = server = qflg = gflg = hflg = 0;
        ttyname = 0;            /* Default is remote mode */

        image = FALSE;
        filnamcnv = TRUE; 

        escchr = ESCCHR;        /* Default escape character */

        while ((*cp) != NULL)   /* Parse characters in first arg. */
                switch (*cp++) {
                case 'c':
                        cflg++; break;  /* C = Connect command */
                case 's':
                        sflg++; break;  /* S = Send command */
                case 'r':
                        rflg++; break;  /* R = Receive command */
                case 'g':
                        gflg++; break;  /* G = Get file from server */
                case 'h':
                        hflg++; break;  /* H = Host Server Command */
                case 'q':
                        qflg++; break;  /* Q = tell remote Host to quit */
                case 'u': 
                        uflg++; break;  /* U = Unix mode file transfer */
                case 'd':
                        debug++; break; /* D = Increment debug mode count */
                case 'f':
                        filnamcnv = FALSE; break;
                                        /* F = don't do case conversion */
                case 'i':
                        image = TRUE; break;
                                        /* I = Image mode; 8-bit, no CRLF map */
                case 'l':               /* L = specify tty line to use */
                        if (argc--)
                                ttyname = *argv++;
                        else
                                usage(); 
                        if (debug)
                                printf("Line to remote host is %s\n", ttyname); 
                        break;
                case 'e':               /* E = specify escape char */
                        if (argc--)
                                escchr = **argv++;
                        else
                                usage();
                        if (debug)
                                printf("Escape char is \"%c\"\n",escchr);
                        break;
                case 'b':               /* B = specify baud rate */
                        printmsg("Speed setting not yet implemented.");
                        exit(1);
                }

        /* Done parsing */

        /* Only one command allowed */

        if ((cflg + qflg + gflg + hflg + sflg + rflg) != 1)
                usage();

        if (ttyname) {
                /* LINE was specified, we operate in local mode */ 
                ttyfd = open(ttyname, 3);   /* Open the line for update */
                if (ttyfd < 0) {
                        printmsg("Cannot open %s", ttyname);
                        exit(1);
                }
                remot = FALSE;         /* Indicate we're in local mode */
        } else {
                /* No LINE specified so we operate */
                /* in remote mode (ie. controlling */
                /* tty is the communications line) */
                ttyfd = 0;
                remot = TRUE;
        }


        /*
         * Tell User Options and Modes Invoked.
         */
        if (debug) {
                printf("Debugging level = %d\n\n", debug);
                if      (cflg) puts("Connect command");
                else if (sflg) puts("Send command");
                else if (rflg) puts("Receive command");
                else if (gflg) puts("Get command");
                else if (hflg) puts("Host Server command");
                else if (qflg) puts("Quit to Host Server command");
                else if (uflg) puts("Unix file transfer Mode");
        }
        /* Put the proper tty into the correct mode */

        if (remot) {          /* If remote, use controlling tty */
                raw(0, &insave);        /* put input in raw mode */
                raw(1, &outsave);       /* ditto for output */
        } else {            /* Local, use assigned line */
                raw(ttyfd,&linesave);   /* put assigned line in raw mode */
        }   

        /* All set up, now execute the command that was given. */

        if (cflg)
                connect();      /* Connect command */
        else {
                if (gflg) {              /* Set up Get Function  */
                        /* Get file to request  */
                        if (argc--)
                                filnam = *argv++;
                        else
                                usage();         /* Parameter error quit */
                        fp = NULL;        /* No files open yet  */
                        filelist = argv;  /* set up list of files to request */
                        filecount = argc; /* Number of files to get */
                        getsw();          /* Initate remote Get    */
                }
                if (hflg) servsw();       /* Initate Server Mode */
                if (qflg) quitsw();       /* Initate Quit mode */
                if (sflg) {               /* Send command */
                        /* Get file to send */
                        if (argc--)
                                filnam = *argv++;
                        else {
                                if (remot){
                                        /* restore controlling scf device */
                                        /* modes in reverse order */
                                        cook(1, &outsave);
                                        cook(0, &insave);
                                } else
                                        /* restore assigned line */
                                        cook(ttyfd, &linesave);
                                usage();
                        }
                        fp = NULL;        /* Indicate no file open yet */
                        filelist = argv;  /* Set up the rest of the file list */
                        filecount = argc; /* Number of files left to send */
                        /* Send the file(s) */
                        printmsg(sendsw() == FALSE ? "Send failed." : "done.");
                }
                if (rflg) {            /* Receive command */
                        printmsg(recsw() == FALSE ? "Receive failed.": "done.");
                }
        }

        if (remot) {
                cook(1, &outsave);    /* restore controlling scf modes */
                cook(0, &insave);     /* in reverse order */
        } else
                cook(ttyfd, &linesave); /* restore assigned line */
}
