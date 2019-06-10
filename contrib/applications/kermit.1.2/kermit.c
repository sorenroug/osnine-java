/*
 *  K e r m i t    File Transfer Utility
 *
 *  UNIX Kermit, Columbia University, 1981, 1982, 1983
 *   Bill Catchings, Bob Cattani, Chris Maio, Frank da Cruz, Alan Crosswell
 *
 *  Also:   Jim Guyton, Rand Corporation
 *       Walter Underwood, Ford Aerospace
 *
 *  usage:  kermit c [lbe line baud escapechar]      to connect
 *       kermit s [d..iflb line baud] file ...   to send files
 *       kermit r [d..iflb line baud]      to receive files
 *
 *  where   c=connect, s=send, r=receive,
 *       d=debug, i=image mode, f=no filename conversion, l=tty line,
 *       b=baud rate, e=escape char.
 *
 *  For remote Kermit, format is either:
 *       kermit r               to receive files
 *  or       kermit s file ...            to send files
 *
 */
/*
 *   OS9 Version and differences
 *   kermit s[ifdl path filename      is send format
 *   kermit OS9 does not have  connect function (yet).
 *   OS9 version has time-out on rx data of MAXTRY
 *     if not server "W"ait mode.
 *   OS9 option u=Unix mode transmissions, that is:
 *   CR -> CRLF on send, and CRLF -> CR on receive
 */

/*
 *   Host Server command
 *   Kermit h[idful path]      Host Server mode
 *   Kermit g[idfu]l path filename  Get file from a server
 *   Kermit q[idf]l path     Tell Host Server to terminate
 *
 */
#define VERSION 1      /* Unix-OS9 Version number  */
#define RELEASE 2      /* Update release           */

/*
 *  Modification History:
 *
* January  17,1985 Striped NON OS9 and Connect from program
* December 12,1984 fix OS9 time-out, Server to standard, and
*                  added u-Unix mode for OS9
* November 19,1984 Added OS9 time-out for Rx data.  W.G. Seaton
* November 14,1984 Added Host Server Mode  W.G. Seaton
                 - Added include kermserv.c for server function
                 - Added include kermget.c for get function
* November  9,1984 Modified for OS9  by W.G. Seaton,NASA KSC
* July 20,84  Added conditional equates for HP9000. Used for ioctl
              input buffer flush. D.L. Finley
 *  Oct. 17 Included fixes from Alan Crosswell (CUCCA) for IBM_UTS:
 *       - Changed MYEOL character from \n to \r.
 *       - Change char to int in bufill so getc would return -1 on
 *         EOF instead of 255 (-1 truncated to 8 bits)
 *       - Added read() in rpack to eat the EOL character
 *       - Added fflush() call in printmsg to force the output
 *       NOTE: The last three changes are not conditionally compiled
 *        since they should work equally well on any system.
 *
 *       Changed Berkeley 4.x conditional compilation flag from
 *      UNIX4X to UCB4X.
 *       Added support for error packets and cleaned up the printing
 *      routines.
 */

#include <stdio.h>       /* Standard UNIX definitions */

/* Conditional compilation has been removed.    */
#define OS9          1        /* OS9 DOS    UNIX sub-set  */

#define NO_TANDEM   1     /* no x-on x-off          */

#include <sgtty.h>
#include <signal.h>
#include <setjmp.h>
#define CREAD   0000400      /* read enable */
#define CS8   0000140      /* 8 bits per character */
#define CLOCAL   0010000      /* no dial up */

#define TANDEM       0       /* define it to be nothing if it's unsupported */


/* Symbol Definitions */

#define MAXPACKSIZ  94       /* Maximum packet size */
#define SOH       1       /* Start of header */
#define CR       13       /* ASCII Carriage Return */
#define SP       32       /* ASCII space */
#define DEL       127       /* Delete (rubout) */
#define ESCCHR       '~'       /* Default escape character for CONNECT */

#define MAXTRY       10       /* Times to retry a packet */
#define MYQUOTE       '#'       /* Quote character I will use */
#define MYPAD       0       /* Number of padding characters I will need */
#define MYPCHAR       0       /* Padding character I need (NULL) */

#define MYEOL       '\n'    /* End-Of-Line character I need */

#define MYTIME       10       /* Seconds after which I should be timed out */
#define MAXTIM       60       /* Maximum timeout interval */
#define MINTIM       2       /* Minumum timeout interval */

#define TRUE       -1       /* Boolean constants */
#define FALSE       0


/* Macro Definitions */

/*
 * tochar: converts a control character to a printable one by adding a space.
 *
 * unchar: undoes tochar.
 *
 * ctl:      converts between control characters and printable characters by
 *      toggling the control bit (ie. ^A becomes A and A becomes ^A).
 */
#define tochar(ch)  ((ch) + ' ')
#define unchar(ch)  ((ch) - ' ')
#define ctl(ch)       ((ch) ^ 64 )


/* Global Variables */

int   size,          /* Size of present data */
   rpsiz,          /* Maximum receive packet size */
   spsiz,          /* Maximum send packet size */
   pad,          /* How much padding to send */
   timint,          /* Timeout for foreign host on sends */
   n,          /* Packet number */
   n_total,    /* Total number of packets sent  */
   numtry,          /* Times this packet retried */
   oldtry,          /* Times previous packet retried */
   ttyfd,          /* File descriptor of tty for I/O, 0 if remote */
   server,          /* Host server mode flag      */
   gflg,            /* Get file flag              */
   uflg,            /* Unix file transfer mode  */
   remote,          /* -1 means we're a remote kermit */
   image,          /* -1 means 8-bit mode */
   debug,          /* indicates level of debugging output (0=none) */
   filnamcnv,       /* -1 means do file name case conversions */
   filecount;       /* Number of files left to send */

char   state,          /* Present state of the automaton */
   padchar,       /* Padding character to send */
   eol,          /* End-Of-Line character to send */
   escchr,          /* Connect command escape character */
   quote,          /* Quote character in incoming data */
   **filelist,       /* List of files to be sent */
   *filnam,       /* Current file name */
   recpkt[MAXPACKSIZ], /* Receive packet buffer */
   packet[MAXPACKSIZ]; /* Packet buffer */

FILE   *fp,          /* File pointer for current disk file */
   *log;          /* File pointer for Logfile */

jmp_buf env;          /* Environment ptr for timeout longjump */


/*
 *  m a i n
 *
 *  Main routine - parse command and options, set up the
 *  tty lines, and dispatch to the appropriate routine.
 */

main(argc,argv)
  int argc;                /* Character pointers to and count of */
  char **argv;             /* command line arguments */
{
  char *ttyname,           /* tty name for LINE argument */
   *cp;                    /* char pointer */
  int speed,               /* speed of assigned tty, */
    len,num,               /* lenght,number  */
    hflg,qflg,             /* GET, HOST(Server) flags          */
    cflg, rflg, sflg;      /* flags for CONNECT, RECEIVE, SEND */

  struct sgttyb
    rawmode,            /* Controlling tty raw mode */
    cookedmode,         /* Controlling tty cooked mode */
    ttymode;            /* mode of tty line in LINE option */

    if (argc < 2) usage();      /* Make sure there's a command line */

    cp = *++argv; argv++; argc -= 2;   /* Set up pointers to args */

/*  Initialize these values and hope the first packet will get across OK */

    eol = CR;            /* EOL for outgoing packets */
    quote = '#';         /* Standard control-quote char "#" */
    pad = 0;            /* No padding */
    padchar = NULL;         /* Use null if any padding wanted */

    speed = cflg = sflg = rflg = 0;   /* Turn off all parse flags */
    uflg=server=qflg=gflg=hflg=0;
    ttyname = 0;         /* Default is remote mode */

    image = TRUE;         /* Default to no processing for */
    filnamcnv = FALSE;         /* non-UNIX systems */

    escchr = ESCCHR;         /* Default escape character */
 
    while ((*cp) != NULL)      /* Parse characters in first arg. */
   switch (*cp++)
   {
       case 'c': cflg++; break;   /* C = Connect command */
       case 's': sflg++; break;   /* S = Send command */
       case 'r': rflg++; break;   /* R = Receive command */
       case 'g': gflg++; break;   /* G = Get file from server */
       case 'h': hflg++; break;   /* H = Host Server Command */
       case 'q': qflg++; break;   /* Q = tell remote Host to quit */
       case 'u': uflg++; break;  /* U = Unix mode file transfer */

       case 'd':         /* D = Increment debug mode count */
      debug++; break;
      
       case 'f':
      filnamcnv = FALSE;   /* F = don't do case conversion */
      break;         /*     on filenames */

       case 'i':         /* I = Image (8-bit) mode */
      image = TRUE; break;   /* (this is default for non-UNIX) */

       case 'l':         /* L = specify tty line to use */
      if (argc--) ttyname = *argv++;
      else usage(); 
      if (debug) printf("Line to remote host is %s\n",ttyname); 
      break;
      
       case 'e':         /* E = specify escape char */
      if (argc--) escchr = **argv++;
      else usage();
      if (debug) printf("Escape char is \"%c\"\n",escchr);
      break;
      
       case 'b':         /* B = specify baud rate */
      printmsg("Speed setting implemented for Unix only.");
      exit(1);
   }

/* Done parsing */

    if ((cflg+qflg+gflg+hflg+sflg+rflg) != 1)      /* Only one command allowed */
   usage();


    if (ttyname)         /* If LINE was specified, we */
    {               /* operate in local mode */
   ttyfd = open(ttyname,3);   /* Open the line in OS9 Update mode */
   if (ttyfd < 0)
   {
       printmsg("Cannot open %s",ttyname);
       exit(1);
   }
   remote = FALSE;         /* Indicate we're in local mode */
    }
    else            /* No LINE specified so we operate */
    {               /* in remote mode (ie. controlling */
   ttyfd = 0;         /* tty is the communications line) */
   remote = TRUE;
    }
    

/* Put the proper tty into the correct mode */

    if (remote)            /* If remote, use controlling tty */
    {
   gtty(0,&cookedmode);      /* Save current mode so we can */
   gtty(0,&rawmode);      /* restore it later */
   rawmode.sg_flags |= (RAW|TANDEM);
   rawmode.sg_flags &= ~(ECHO|CRMOD);
   stty(0,&rawmode);      /* Put tty in raw mode */
    }
    else            /* Local, use assigned line */
    {
   gtty(ttyfd,&ttymode);
   ttymode.sg_flags |= (RAW|TANDEM);
   ttymode.sg_flags &= ~(ECHO|CRMOD);


   stty(ttyfd,&ttymode);      /* Put asg'd tty in raw mode */
    }   


/* All set up, now execute the command that was given. */

/*
    if (debug)
    {
   printf("Debugging level = %d\n\n",debug);
*/

   if (cflg) printf("Connect command\n\n");
   if (sflg) printf("Send command\n\n");
   if (rflg) printf("Receive command\n\n");
   if (gflg) printf("Get command\n\n");
   if (hflg) printf("Host Server command\n\n");
   if (qflg) printf("Quit to Host Server command\n\n");
   if (uflg) printf("Unix file transfer Mode \n\n");
/*
    }
*/
  
    if (cflg) connect();      /* Connect command */
    if (gflg)                       /* Set up Get Function  */
    {
     if (argc--) filnam = *argv++;  /* Get file to request  */
     else
      usage();                      /* Parameter error quit */
     fp = NULL;      /* No files open yet  */
     filelist= argv; /* set up list of files to request */
     filecount= argc; /* Number of files to get */
     getsw();         /* Initate remote Get     */
    }
    if (hflg) servsw();       /* Initate Server Mode */
    if (qflg) quitsw();       /* Initate Quit mode */

    if (sflg)            /* Send command */ 
    {
   if (argc--) filnam = *argv++;   /* Get file to send */
   else
   {   if (remote)
      stty(0,&cookedmode);   /* Restore controlling tty's modes */
       usage();         /* and give error */
   }
   fp = NULL;         /* Indicate no file open yet */
   filelist = argv;      /* Set up the rest of the file list */
   filecount = argc;      /* Number of files left to send */
   if (sendsw() == FALSE)      /* Send the file(s) */
       printmsg("Send failed.");   /* Report failure */
   else            /*  or */
       printmsg("done.");      /* success */
    }

    if (rflg)            /* Receive command */
    {
   if (recsw() == FALSE)      /* Receive the file(s) */
       printmsg("Receive failed.");
   else            /* Report failure */
       printmsg("done.");      /* or success */
    }

    if (remote) stty(0,&cookedmode);   /* Restore controlling tty's modes */
}
#include "kermget.c"
#include "kermserv.c"
#include "kermquit.c"
#include "kermconnect.c"


/*
 *  s e n d s w
 *
 *  Sendsw is the state table switcher for sending files.  It loops until
 *  either it finishes, or an error is encountered.  The routines called
 *  by sendsw are responsible for changing the state.
 *
 */

sendsw()
{
    char sinit(), sfile(), sdata(), seof(), sbreak();

    state = 'S';         /* Send initiate is the start state */
    n = 0;            /* Initialize message number */
    numtry = 0;            /* Say no tries yet */
    while(TRUE)            /* Do this as long as necessary */
    {
   if (debug) printf("sendsw state: %c, Packet # %d\n",state,n);
    if ((!remote) && (!debug)) 
      if((n/10)*10 == n)
        printmsg("Status: Sending Packet # %d",n);

   switch(state)
   {
       case 'S':   state = sinit();  break; /* Send-Init */
       case 'F':   state = sfile();  break; /* Send-File */
       case 'D':   state = sdata();  break; /* Send-Data */
       case 'Z':   state = seof();     break; /* Send-End-of-File */
       case 'B':   state = sbreak(); break; /* Send-Break */
       case 'C':   return (TRUE);       /* Complete */
       case 'A':   return (FALSE);       /* "Abort" */
       default:   return (FALSE);       /* Unknown, fail */
   }
    }
}


/*
 *  s i n i t
 *
 *  Send Initiate: send this host's parameters and get other side's back.
 */

char sinit()
{
    int num, len;         /* Packet number, length */

    if (numtry++ > MAXTRY) return('A'); /* If too many tries, give up */
    spar(packet);         /* Fill up init info packet */

    flushinput();         /* Flush pending input */

    spack('S',n,6,packet);      /* Send an S packet */
    switch(rpack(&len,&num,recpkt))   /* What was the reply? */
    {
   case 'N':  return(state);   /* NAK, try it again */

   case 'Y':         /* ACK */
       if (n != num)      /* If wrong ACK, stay in S state */
      return(state);      /* and try again */
       rpar(recpkt);      /* Get other side's init info */

       if (eol == 0) eol = '\n';   /* Check and set defaults */
       if (quote == 0) quote = '#';

       numtry = 0;         /* Reset try counter */
       n = (n+1)%64;      /* Bump packet count */
       return('F');      /* OK, switch state to F */

   case 'E':         /* Error packet received */
       prerrpkt(recpkt);      /* Print it out and */
       return('A');      /* abort */

   case FALSE: return(state);   /* Receive failure, try again */

   default: return('A');      /* Anything else, just "abort" */
   }
 }


/*
 *  s f i l e
 *
 *  Send File Header.
 */

char sfile()
{
    int num, len;         /* Packet number, length */
    char filnam1[50],         /* Converted file name */
   *newfilnam,         /* Pointer to file name to send */
   *cp;            /* char pointer */

    if (numtry++ > MAXTRY) return('A'); /* If too many tries, give up */
    
   if( gflg == 0)          /* If Get mode just send name  */
   {
    if (fp == NULL)         /* If not already open, */
    {   if (debug) printf("   Opening %s for sending.\n",filnam);
   fp = fopen(filnam,"r");      /* open the file to be sent */
   if (fp == NULL)         /* If bad file pointer, give up */
   {
       error("Cannot open file %s",filnam);
       return('A');
   }
    }
   }

    strcpy(filnam1, filnam);      /* Copy file name */
    newfilnam = cp = filnam1;
    while (*cp != '\0')         /* Strip off all leading directory */
   if (*cp++ == '/')      /* names (ie. up to the last /). */
       newfilnam = cp;

    if (filnamcnv)         /* Convert lower case to upper   */
   for (cp = newfilnam; *cp != '\0'; cp++)
       if (*cp >= 'a' && *cp <= 'z')
      *cp ^= 040;

    len = cp - newfilnam;      /* Compute length of new filename */

   if ( gflg == 0)     /*  If not Get function   */
   {
    printmsg("Sending %s as %s",filnam,newfilnam);

    spack('F',n,len,newfilnam);      /* Send an F packet */
   }
   else
   {
    spack('R',n,len,newfilnam);      /* Send Get file packet */
    return;
   }

    switch(rpack(&len,&num,recpkt))   /* What was the reply? */
    {         
   case 'N':         /* NAK, just stay in this state, */
       num = (--num<0 ? 63:num);   /* unless it's NAK for next packet */
       if (n != num)      /* which is just like an ACK for */ 
      return(state);      /* this packet so fall thru to... */

   case 'Y':         /* ACK */
       if (gflg != 0)               /* Test if get function  */
        return('D');                /* If so no number check, Done   */
       if (n != num) return(state); /* If wrong ACK, stay in F state */
       numtry = 0;         /* Reset try counter */
       n = (n+1)%64;      /* Bump packet count */
       size = bufill(packet);   /* Get first data from file */
       return('D');      /* Switch state to D */

   case 'E':         /* Error packet received */
       prerrpkt(recpkt);      /* Print it out and */
       return('A');      /* abort */

   case FALSE: return(state);   /* Receive failure, stay in F state */

   default:    return('A');   /* Something else, just "abort" */
    }
}


/*
 *  s d a t a
 *
 *  Send File Data
 */

char sdata()
{
    int num, len;         /* Packet number, length */

    if (numtry++ > MAXTRY) return('A'); /* If too many tries, give up */

    spack('D',n,size,packet);      /* Send a D packet */
    switch(rpack(&len,&num,recpkt))   /* What was the reply? */
    {          
   case 'N':         /* NAK, just stay in this state, */
       num = (--num<0 ? 63:num);   /* unless it's NAK for next packet */
       if (n != num)      /* which is just like an ACK for */
      return(state);      /* this packet so fall thru to... */
      
   case 'Y':         /* ACK */
       if (n != num) return(state); /* If wrong ACK, fail */
       numtry = 0;         /* Reset try counter */
       n = (n+1)%64;      /* Bump packet count */
       if ((size = bufill(packet)) == EOF) /* Get data from file */
      return('Z');      /* If EOF set state to that */
       return('D');      /* Got data, stay in state D */

   case 'E':         /* Error packet received */
       prerrpkt(recpkt);      /* Print it out and */
       return('A');      /* abort */

   case FALSE: return(state);   /* Receive failure, stay in D */

   default:    return('A');   /* Anything else, "abort" */
    }
}


/*
 *  s e o f
 *
 *  Send End-Of-File.
 */

char seof()
{
    int num, len;         /* Packet number, length */
    if (numtry++ > MAXTRY) return('A'); /* If too many tries, "abort" */

    spack('Z',n,0,packet);      /* Send a 'Z' packet */
    switch(rpack(&len,&num,recpkt))   /* What was the reply? */
    {
   case 'N':         /* NAK, just stay in this state, */
       num = (--num<0 ? 63:num);   /* unless it's NAK for next packet, */
       if (n != num)      /* which is just like an ACK for */
      return(state);      /* this packet so fall thru to... */

   case 'Y':         /* ACK */
       if (n != num) return(state); /* If wrong ACK, hold out */
       numtry = 0;         /* Reset try counter */
       n = (n+1)%64;      /* and bump packet count */
       if (debug) printf("     Closing input file %s, ",filnam);
       fclose(fp);         /* Close the input file */
       fp = NULL;         /* Set flag indicating no file open */ 

       if (debug) printf("looking for next file...\n");
       if (gnxtfl() == FALSE)   /* No more files go? */
      return('B');      /* if not, break, EOT, all done */
       if (debug) printf("     New file is %s\n",filnam);
       return('F');      /* More files, switch state to F */

   case 'E':         /* Error packet received */
       prerrpkt(recpkt);      /* Print it out and */
       return('A');      /* abort */

   case FALSE: return(state);   /* Receive failure, stay in Z */

   default:    return('A');   /* Something else, "abort" */
    }
}


/*
 *  s b r e a k
 *
 *  Send Break (EOT)
 */

char sbreak()
{
    int num, len;         /* Packet number, length */
    if (numtry++ > MAXTRY) return('A'); /* If too many tries "abort" */

    spack('B',n,0,packet);      /* Send a B packet */
    switch (rpack(&len,&num,recpkt))   /* What was the reply? */
    {
   case 'N':         /* NAK, just stay in this state, */
       num = (--num<0 ? 63:num);   /* unless NAK for previous packet, */
       if (n != num)      /* which is just like an ACK for */
      return(state);      /* this packet so fall thru to... */

   case 'Y':         /* ACK */
       if (n != num) return(state); /* If wrong ACK, fail */
       numtry = 0;         /* Reset try counter */
       n = (n+1)%64;      /* and bump packet count */
       return('C');      /* Switch state to Complete */

   case 'E':         /* Error packet received */
       prerrpkt(recpkt);      /* Print it out and */
       return('A');      /* abort */

   case FALSE: return(state);   /* Receive failure, stay in B */

   default:    return ('A');   /* Other, "abort" */
   }
}


/*
 *  r e c s w
 *
 *  This is the state table switcher for receiving files.
 */

recsw()
{
    char rinit(), rfile(), rdata();   /* Use these procedures */

    state = 'R';         /* Receive-Init is the start state */
    n = 0;            /* Initialize message number */
    numtry = 0;            /* Say no tries yet */

    while(TRUE)
    {
   if (debug) printf(" recsw state: %c\n",state);
   switch(state)         /* Do until done */
   {
       case 'R':   state = rinit(); break; /* Receive-Init */
       case 'F':   state = rfile(); break; /* Receive-File */
       case 'D':   state = rdata(); break; /* Receive-Data */
       case 'C':   return(TRUE);      /* Complete state */
       case 'A':   return(FALSE);      /* "Abort" state */
   }
    }
}

    
/*
 *  r i n i t
 *
 *  Receive Initialization
 */
  
char rinit()
{
    int len, num;         /* Packet length, number */
      if ( gflg == 0)      /* If not Get from server */

       spack('N',n,0,0);  /* Send NAK, case sender started first  */
 
    if (numtry++ > MAXTRY) return('A'); /* If too many tries, "abort" */

    switch(rpack(&len,&num,packet))   /* Get a packet */
    {
   case 'S':         /* Send-Init */
       rpar(packet);      /* Get the other side's init data */
       spar(packet);      /* Fill up packet with my init info */
       spack('Y',n,6,packet);   /* ACK with my parameters */
       oldtry = numtry;      /* Save old try count */
       numtry = 0;         /* Start a new counter */
       n = (n+1)%64;      /* Bump packet number, mod 64 */
       return('F');      /* Enter File-Receive state */

   case 'E':         /* Error packet received */
       prerrpkt(packet);      /* Print it out and */
       return('A');      /* abort */

   case FALSE:         /* Didn't get packet */
       spack('N',n,0,0);      /* Return a NAK */
       return(state);      /* Keep trying */

   default:     return('A');   /* Some other packet type, "abort" */
    }
}


/*
 *  r f i l e
 *
 *  Receive File Header
 */

char rfile()
{
    int num, len;         /* Packet number, length */
    char filnam1[50];         /* Holds the converted file name */

    if (numtry++ > MAXTRY) return('A'); /* "abort" if too many tries */

    switch(rpack(&len,&num,packet))   /* Get a packet */
    {
   case 'S':         /* Send-Init, maybe our ACK lost */
       if (oldtry++ > MAXTRY) return('A'); /* If too many tries "abort" */
       if (num == ((n==0) ? 63:n-1)) /* Previous packet, mod 64? */
       {            /* Yes, ACK it again with  */
      spar(packet);      /* our Send-Init parameters */
      spack('Y',num,6,packet);
      numtry = 0;      /* Reset try counter */
      return(state);      /* Stay in this state */
       }
       else return('A');      /* Not previous packet, "abort" */

   case 'Z':         /* End-Of-File */
       if (oldtry++ > MAXTRY) return('A');
       if (num == ((n==0) ? 63:n-1)) /* Previous packet, mod 64? */
       {            /* Yes, ACK it again. */
      spack('Y',num,0,0);
      numtry = 0;
      return(state);      /* Stay in this state */
       }
       else return('A');      /* Not previous packet, "abort" */

   case 'F':         /* File Header (just what we want) */
       if (num != n) return('A');   /* The packet number must be right */
       strcpy(filnam1, packet);   /* Copy the file name */

       if (filnamcnv)      /* Convert upper case to lower */
      for (filnam=filnam1; *filnam != '\0'; filnam++)
          if (*filnam >= 'A' && *filnam <= 'Z')
         *filnam |= 040;

       if ((fp=fopen(filnam1,"w"))==NULL) /* Try to open a new file */
       {
      error("Cannot create %s",filnam1); /* Give up if can't */
      return('A');
       }
       else         /* OK, give message */
      printmsg("Receiving %s as %s",packet,filnam1);

       spack('Y',n,0,0);      /* Acknowledge the file header */
       oldtry = numtry;      /* Reset try counters */
       numtry = 0;         /* ... */
       n = (n+1)%64;      /* Bump packet number, mod 64 */
       return('D');      /* Switch to Data state */

   case 'B':         /* Break transmission (EOT) */
       if (num != n) return ('A'); /* Need right packet number here */
       spack('Y',n,0,0);      /* Say OK */
       return('C');      /* Go to complete state */

   case 'E':         /* Error packet received */
       prerrpkt(packet);      /* Print it out and */
       return('A');      /* abort */

   case FALSE:         /* Didn't get packet */
       spack('N',n,0,0);      /* Return a NAK */
       return(state);      /* Keep trying */

   default:    return ('A');   /* Some other packet, "abort" */
    }
}


/*
 *  r d a t a
 *
 *  Receive Data
 */

char rdata()
{
    int num, len;         /* Packet number, length */
    if (numtry++ > MAXTRY) return('A'); /* "abort" if too many tries */

    switch(rpack(&len,&num,packet))   /* Get packet */
    {
   case 'D':         /* Got Data packet */
       if (num != n)      /* Right packet? */
       {            /* No */
      if (oldtry++ > MAXTRY)
          return('A');   /* If too many tries, abort */
      if (num == ((n==0) ? 63:n-1)) /* Else check packet number */
      {         /* Previous packet again? */
          spack('Y',num,6,packet); /* Yes, re-ACK it */
          numtry = 0;      /* Reset try counter */
          return(state);   /* Don't write out data! */
      }
      else return('A');   /* sorry, wrong number */
       }
       /* Got data with right packet number */
       bufemp(packet,len);      /* Write the data to the file */
       spack('Y',n,0,0);      /* Acknowledge the packet */
       oldtry = numtry;      /* Reset the try counters */
       numtry = 0;         /* ... */
       n = (n+1)%64;      /* Bump packet number, mod 64 */
       return('D');      /* Remain in data state */

   case 'F':         /* Got a File Header */
       if (oldtry++ > MAXTRY)
      return('A');      /* If too many tries, "abort" */
       if (num == ((n==0) ? 63:n-1)) /* Else check packet number */
       {            /* It was the previous one */
      spack('Y',num,0,0);   /* ACK it again */
      numtry = 0;      /* Reset try counter */
      return(state);      /* Stay in Data state */
       }
       else return('A');      /* Not previous packet, "abort" */

   case 'Z':         /* End-Of-File */
       if (num != n) return('A');   /* Must have right packet number */
       spack('Y',n,0,0);      /* OK, ACK it. */
       fclose(fp);         /* Close the file */
       n = (n+1)%64;      /* Bump packet number */
       return('F');      /* Go back to Receive File state */

   case 'E':         /* Error packet received */
       prerrpkt(packet);      /* Print it out and */
       return('A');      /* abort */

   case FALSE:         /* Didn't get packet */
       spack('N',n,0,0);      /* Return a NAK */
       return(state);      /* Keep trying */

   default:     return('A');   /* Some other packet, "abort" */
    }
}


/*
 *   KERMIT utilities.
 */

clkint()            /* Timer interrupt handler */
{
    longjmp(env,TRUE);         /* Tell rpack to give up */
}


/*
 *  s p a c k
 *
 *  Send a Packet
 */

spack(type,num,len,data)
char type, *data;
int num, len;
{
    int i;            /* Character loop counter */
    char chksum, buffer[100];      /* Checksum, packet buffer */
    register char *bufp;      /* Buffer pointer */

    len=len & 0x7f;       /* Make sure len is not > 127  */
    if (len > MAXPACKSIZ )  /* Make sure not larger than buffer */
     len = MAXPACKSIZ-4;    /* IF so limit it  */

    if (debug>1)         /* Display outgoing packet */
    {
   if (data != NULL)
       data[len] = '\0';      /* Null-terminate data to print it */
   printf("  spack type: %c\n",type);
   printf("    num:  %d\n",num);
   printf("    len:  %d\n",len);
   if (data != NULL)
       printf("       data: \"%s\"\n",data);
    }
  
    bufp = buffer;         /* Set up buffer pointer */
    for (i=1; i<=pad; i++) write(ttyfd,&padchar,1); /* Issue any padding */

    *bufp++ = SOH;         /* Packet marker, ASCII 1 (SOH) */
    *bufp++ = tochar(len+3);      /* Send the character count */
    chksum  = tochar(len+3);      /* Initialize the checksum */
    *bufp++ = tochar(num);      /* Packet number */
    chksum += tochar(num);      /* Update checksum */
    *bufp++ = type;         /* Packet type */
    chksum += type;         /* Update checksum */

    for (i=0; i<len; i++)      /* Loop for all data characters */
    {
   *bufp++ = data[i];      /* Get a character */
   chksum += data[i];      /* Update checksum */
    }
    chksum = (((chksum&0300) >> 6)+chksum)&077; /* Compute final checksum */
    *bufp++ = tochar(chksum);      /* Put it in the packet */
    *bufp = eol;         /* Extra-packet line terminator */
    write(ttyfd, buffer,bufp-buffer+1); /* Send the packet */
}

/*
 *  r p a c k
 *
 *  Read a Packet
 */

rpack(len,num,data)
int *len, *num;         /* Packet length, number */
char *data;             /* Packet data */
{
    int i,j, done;        /* Data character number, loop exit */
    char t,             /* Current input character */
         type,               /* Packet type */
      cchksum,            /* Our (computed) checksum */
      rchksum;            /* Checksum received from other host */


     while (t != SOH)         /* Wait for packet header */
     {
     if(state != 'W')   /*  OS9 Time-out if not Server wait state */
      {
       i=1;             /*  Time-out counter per rx data   */
       j=1;             /*  Sub time-out counter */
       while(getstat(1,ttyfd) == -1) 
       {
        if (j == 20)
        {  j=1;      /* reset sub counter  */
        if (debug>1) printf("time-out loop %d\n",i);
        }
        tsleep(5);       /*  If no rx data  sleep .05 second  */
        j++;
        if (i++ > MAXTRY*20) return(FALSE); /* Time-out, Exit */
       }
      }

     read(ttyfd,&t,1);   /* Get character from rx buffer  */
     t &= 0177;         /* Handle parity */
     }

    done = FALSE;                  /* Got SOH, init loop */
    while (!done)               /* Loop to get a packet */
       {
         read(ttyfd,&t,1);            /* Get character */
         if (!image) t &= 0177;       /* Handle parity */
         if (t == SOH) continue;      /* Resynchronize if SOH */
         cchksum = t;                 /* Start the checksum */
         *len = unchar(t)-3;          /* Character count */

          read(ttyfd,&t,1);           /* Get character */
          if (!image) t &= 0177;      /* Handle parity */
          if (t == SOH) continue;      /* Resynchronize if SOH */
          cchksum = cchksum + t;      /* Update checksum */
          *num = unchar(t);           /* Packet number */

           read(ttyfd,&t,1);         /* Get character */
   if (!image) t &= 0177;      /* Handle parity */
   if (t == SOH) continue;      /* Resynchronize if SOH */
   cchksum = cchksum + t;      /* Update checksum */
   type = t;         /* Packet type */

   for (i=0; i<*len; i++)      /* The data itself, if any */
   {            /* Loop for character count */
       read(ttyfd,&t,1);      /* Get character */
       if (!image) t &= 0177;   /* Handle parity */
       if (t == SOH) continue;   /* Resynch if SOH */
       cchksum = cchksum + t;   /* Update checksum */
       data[i] = t;      /* Put it in the data buffer */
   }
   data[*len] = 0;         /* Mark the end of the data */

   read(ttyfd,&t,1);      /* Get last character (checksum) */
   rchksum = unchar(t);      /* Convert to numeric */
   read(ttyfd,&t,1);      /* get EOL character and toss it */
   if (!image) t &= 0177;      /* Handle parity */
   if (t == SOH) continue;      /* Resynchronize if SOH */
   done = TRUE;         /* Got checksum, done */
    }


    if (debug>1)         /* Display incoming packet */
    {
   if (data != NULL)
       data[*len] = '\0';      /* Null-terminate data to print it */
   printf("  rpack type: %c\n",type);
   printf("    num:  %d\n",*num);
   printf("    len:  %d\n",*len);
   if (data != NULL)
       printf("       data: \"%s\"\n",data);
    }
               /* Fold in bits 7,8 to compute */
    cchksum = (((cchksum&0300) >> 6)+cchksum)&077; /* final checksum */

    if (cchksum != rchksum) return(FALSE);

    return(type);         /* All OK, return packet type */
}


/*
 *  b u f i l l
 *
 *  Get a bufferful of data from the file that's being sent.
 *  Only control-quoting is done; 8-bit & repeat count prefixes are
 *  not handled.
 */

bufill(buffer)
char buffer[];            /* Buffer */
{
    int i,            /* Loop index */
   t;            /* Char read from file */
    char t7;            /* 7-bit version of above */
    char t9;            /* dup of data char t  */

    i = 0;            /* Init data buffer pointer */
    while((t = getc(fp)) != EOF)   /* Get the next character */
    {
   t9=t;                  /* Keep original pattern */
   t7 = t & 0177;         /* Get low order 7 bits */

   if (t7 < SP || t7==DEL || t7==quote) /* Does this char require */
   {                /* special handling? */
       if (t=='\n' && !image)
       {            /* Do LF->CRLF mapping if !image */
      buffer[i++] = quote;
      buffer[i++] = ctl('\r');
       }
       buffer[i++] = quote;   /* Quote the character */
       if (t7 != quote)
       {
      t = ctl(t);      /* and uncontrolify */
      t7 = ctl(t7);
       }
   }
   if (image)
       buffer[i++] = t;      /* Deposit the character itself */
   else
       buffer[i++] = t7;

   if (uflg)        /* If OS9 Unix mode  */

    if (t9 == '\r')  /* then if this is CR  */
     {
      buffer[i++]=quote;  /* Add LF   */
      buffer[i++]=ctl('\l');
     }

   if (i >= spsiz-8) return(i);   /* Check length */
    }
    if (i==0) return(EOF);      /* Wind up here only on EOF */
    return(i);            /* Handle partial buffer */
}


/*
 *   b u f e m p
 *
 *  Put data from an incoming packet into a file.
 */

bufemp(buffer,len)
char  buffer[];            /* Buffer */
int   len;            /* Length */
{
    int i;            /* Counter */
    char t;            /* Character holder */

    for (i=0; i<len; i++)      /* Loop thru the data field */
    {
   t = buffer[i];         /* Get character */
   if (t == MYQUOTE)      /* Control quote? */
   {            /* Yes */
       t = buffer[++i];      /* Get the quoted character */
       if ((t & 0177) != MYQUOTE)   /* Low order bits match quote char? */
      t = ctl(t);      /* No, uncontrollify it */
   }
   if (t==CR && !image)      /* Don't pass CR if in image mode */
       continue;

   if (uflg)     /* If Unix mode  */
    if (t == '\l')  /* then if t = LF  */
     if (ctl(buffer[i-2]) == '\r')   /* then if last char was CR  */
       continue;                      /* Skip LF, don't put in buffer */

   putc(t,fp);
    }
}


/*
 *  g n x t f l
 *
 *  Get next file in a file group
 */

gnxtfl()
{
    if (server) return(FALSE);    /* If server no multi send   */
    if (debug) printf("     gnxtfl: filelist = \"%s\"\n",*filelist);
    filnam = *(filelist++);
    if (filecount-- == 0) return FALSE; /* If no more, fail */
    else return TRUE;         /* else succeed */
}


/*
 *  s p a r
 *
 *  Fill the data array with my send-init parameters
 *
 */

spar(data)
char data[];
{
    data[0] = tochar(MAXPACKSIZ);      /* Biggest packet I can receive */
    data[1] = tochar(MYTIME);      /* When I want to be timed out */
    data[2] = tochar(MYPAD);      /* How much padding I need */
    data[3] = ctl(MYPCHAR);      /* Padding character I want */
    data[4] = tochar(MYEOL);      /* End-Of-Line character I want */
    data[5] = MYQUOTE;         /* Control-Quote character I send */
}


/*  r p a r
 *
 *  Get the other host's send-init parameters
 *
 */

rpar(data)
char data[];
{
    spsiz = unchar(data[0]);      /* Maximum send packet size */
    timint = unchar(data[1]);      /* When I should time out */
    pad = unchar(data[2]);      /* Number of pads to send */
    padchar = ctl(data[3]);      /* Padding character to send */
    eol = unchar(data[4]);      /* EOL character I must send */
    quote = data[5];         /* Incoming data quote character */
}
 

/*
 *  f l u s h i n p u t
 *
 *  Dump all pending input to clear stacked up NACK's.
 *  (Implemented only for Berkeley Unix at this time).
 */
flushinput()      /* Null version for non-Berkeley Unix */
{
/* OS9 Clear receive buffer   */
 char t;
 while(getstat(1,ttyfd) == 0)
 {
  read(ttyfd,&t,1);
  }
  return;
}


/*
 *  Kermit printing routines:
 *
 *  usage - print command line options showing proper syntax
 *  printmsg -   like printf with "Kermit: " prepended
 *  error - like printmsg if local kermit; sends a error packet if remote
 *  prerrpkt - print contents of error packet received from remote host
 */

/*
 *  u s a g e 
 *
 *  Print summary of usage info and quit
 */

usage()
{
     printf("Kermit Program   Version %d    Release %d \n",VERSION,RELEASE);
  printf("Usage:   kermit c[le line esc.char]       (connect mode)\n");
  printf("or:      kermit s[difl line] file ...       (send mode)\n");
  printf("or:      kermit r[difl line]          (receive mode)\n");
  printf("or:      kermit h[difl line]          (Host server mode \n");
  printf("or:      kermit g[diful line]       (Get file from remote Host\n");
  printf("or:      kermit q[diful line]       (Quit remote Host server\n");
     exit(0);
}

/*
 *  p r i n t m s g
 *
 *  Print message on standard output if not remote.
 */

/*VARARGS1*/
printmsg(fmt, a1, a2, a3, a4, a5)
char *fmt;
{
    if (!remote)
    {
   printf("Kermit: ");
   printf(fmt,a1,a2,a3,a4,a5);
   printf("\n");
   fflush(stdout);         /* force output (UTS needs it) */
    }
}

/*
 *  e r r o r
 *
 *  Print error message.
 *
 *  If local, print error message with printmsg.
 *  If remote, send an error packet with the message.
 */

/*VARARGS1*/
error(fmt, a1, a2, a3, a4, a5)
char *fmt;
{
    char msg[80];
    int len;

    if (remote || server)
    {
   sprintf(msg,fmt,a1,a2,a3,a4,a5); /* Make it a string */
   len = strlen(msg);
   spack('E',n,len,msg);      /* Send the error packet */
    }
    else
   printmsg(fmt, a1, a2, a3, a4, a5);

    return;
}

/*
 *  p r e r r p k t
 *
 *  Print contents of error packet received from remote host.
 */
prerrpkt(msg)
char *msg;
{
    printf("Kermit aborting with following error from remote host:\n%s\n",msg);
    return;
}
