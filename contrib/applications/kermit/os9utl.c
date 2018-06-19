/*
 * os9utl.c Packet handling and misc. routines for os9 kermit
 */

#include "os9inc.h"

/*
 *   KERMIT utilities.
 */

static unsigned int timeout;       /* total pauses spent recieving packet */

/*
 *  s p a c k
 *
 *  Send a Packet
 */

spack(type,num,len,data)
char type, *data;
int num, len;
{
   int i;                          /* Character loop counter */
   char chksum, buffer[100];       /* Checksum, packet buffer */
   register char *bufp;            /* Buffer pointer */

   if(type != 'Y' && type != 'N')
      flushinput();                /* dump any leftovers */
   len=len & 0x7f;                 /* Make sure len is not > 127  */
   if (len > MAXPACKSIZ )          /* Make sure not larger than buffer */
      len = MAXPACKSIZ-4;          /* IF so limit it  */

   if (debug>1)                    /* Display outgoing packet */
   {
      if (data != NULL)
         data[len] = '\0';          /* Null-terminate data to print it */
      printf("  spack type: %c\n",type);
      printf("         num:  %d\n",num);
      printf("         len:  %d\n",len);
      if (data != NULL)
         printf("       data: \"%s\"\n",data);
   }

   bufp = buffer;                  /* Set up buffer pointer */
   for (i=1; i<=pad; i++) write(ttyfd,&padchar,1); /* Issue any padding */

   *bufp++ = SOH;                  /* Packet marker, ASCII 1 (SOH) */
   *bufp++ = tochar(len+3);        /* Send the character count */
   chksum  = tochar(len+3);        /* Initialize the checksum */
   *bufp++ = tochar(num);          /* Packet number */
   chksum += tochar(num);          /* Update checksum */
   *bufp++ = type;                 /* Packet type */
   chksum += type;                 /* Update checksum */

   for (i=0; i<len; i++)           /* Loop for all data characters */
   {
      *bufp++ = data[i];           /* Get a character */
      chksum += data[i];           /* Update checksum */
   }
   chksum = (((chksum&0300) >> 6)+chksum)&077; /* Compute final checksum */
   *bufp++ = tochar(chksum);       /* Put it in the packet */
   *bufp = eol;                    /* Extra-packet line terminator */
   write(ttyfd, buffer,bufp-buffer+1); /* Send the packet */
}

/*
 *  r p a c k
 *
 *  Read a Packet
 */

char rpack(len,num,data)
int *len, *num;                    /* Packet length, number */
char *data;                        /* Packet data */
{
   int i,j, done;                  /* Data character number, loop exit */
   int abort;                      /* restart current packet */
   char t,                         /* Current input character */
   type,                           /* Packet type */
   cchksum,                        /* Our (computed) checksum */
   rchksum;                        /* Checksum received from other host */

   timeout=0;                      /* start timeout counter */
   do {
      if(readtimed(&t)) return(FALSE);
   } 
   while ((t&127) != SOH);         /* Wait for packet header */

   done = FALSE;                   /* Got SOH, init loop */
   while (!done)                   /* Loop to get a packet */
   {
      if(readtimed(&t)) return(FALSE); /* read character, or timeout */
      if (!image) t &= 0177;       /* Handle parity */
      if (t == SOH) continue;      /* Resynchronize if SOH */
      cchksum = t;                 /* Start the checksum */
      *len = unchar(t)-3;          /* Character count */

      if(readtimed(&t)) return(FALSE); /* read character, or timeout */
      if (!image) t &= 0177;       /* Handle parity */
      if (t == SOH) continue;      /* Resynchronize if SOH */
      cchksum = cchksum + t;       /* Update checksum */
      *num = unchar(t);            /* Packet number */

      if(readtimed(&t)) return(FALSE); /* read character, or timeout */
      if (!image) t &= 0177;       /* Handle parity */
      if (t == SOH) continue;      /* Resynchronize if SOH */
      cchksum = cchksum + t;       /* Update checksum */
      type = t;                    /* Packet type */
      abort=FALSE;

      for (i=0; i<*len; i++)       /* The data itself, if any */
      {            /* Loop for character count */
         if(readtimed(&t)) return(FALSE); /* read character, or timeout */
         if (!image) t &= 0177;    /* Handle parity */
         if (t == SOH) {           /* Resynch if SOH */
            abort=TRUE;
            break;
         }
         cchksum = cchksum + t;    /* Update checksum */
         data[i] = t;              /* Put it in the data buffer */
      }
      if(abort)continue;
      data[*len] = 0;              /* Mark the end of the data */

      if(readtimed(&t)) return(FALSE); /* read character, or timeout */
      t &= 0177;                   /* do not use parity bit of checksum */
      rchksum = unchar(t);         /* Convert to numeric */
      if (t == SOH) continue;      /* Resynchronize if SOH */
      done = TRUE;                 /* Got checksum, done */
   }

   if (debug>1)                    /* Display incoming packet */
   {
      if (data != NULL)
         data[*len] = '\0';        /* Null-terminate data to print it */
      printf("  rpack type: %c\n",type);
      printf("         num:  %d\n",*num);
      printf("         len:  %d\n",*len);
      if (data != NULL)
         printf("        data: \"%s\"\n",data);
   }
   /* Fold in bits 7,8 to compute */
   cchksum = (((cchksum&0300) >> 6)+cchksum)&077; /* final checksum */

   if (cchksum != rchksum)
   {
      if(debug >1 ) printf("Rx Checksum Error was %x sb %x\n",rchksum,cchksum);
      return(FALSE);
   }

   return(type);                   /* All OK, return packet type */
}

/* readtimed: read a character or timeout
 *            timeout is relitive to start of waiting for packet
 */

readtimed(c)
char *c;
{
   if(state != 'W'){ /* no timeout in server wait */
#ifdef OSK
      while(getstat(1,ttyfd)<1){
#else
      while(getstat(1,ttyfd)<0){
#endif
         tsleep(ticstosleep);
         /* note that right side of comparison is a constat */
         /* if anything in it is changed to a variable, move the calculation */
         /* out of the readtimed! */
         if(++timeout > (tps*timeoutint/((ticstosleep>1) ? ticstosleep-1 : 1))){
            if(debug)printf("Timed out while waiting for packet\n");
            return(TRUE);
         }
         if(debug>2 && ((timeout & 7)==0))
            printf("Timeout counter at %d pauses\n",timeout);
      }
   }
   read(ttyfd,c,1);
   if(debug>3) printf("Recieved character: %d\n",*c);
   return(FALSE);
}

/*
 *  b u f i l l
 *
 *  Get a bufferful of data from the file that's being sent.
 *  Only control-quoting is done; 8-bit & repeat count prefixes are
 *  not handled.
 */

bufill(buffer)
char buffer[];                      /* Buffer */
{
   int i,                           /* Loop index */
   t;                               /* Char read from file */
   char t7;                         /* 7-bit version of above */
   char t9;                         /* dup of data char t  */

   i = 0;                           /* Init data buffer pointer */
   while((t = getc(fp)) != EOF)     /* Get the next character */
   {
      t9=t;                         /* Keep original pattern */
      t7 = t & 0177;                /* Get low order 7 bits */

      if (t7 < SP || t7==DEL || t7==quote) /* Does this char require */
      {                             /* special handling? */
#ifndef OS9
         if (t=='\n' && !image)
         {                          /* Do LF->CRLF mapping if !image */
            buffer[i++] = quote;
            buffer[i++] = ctl('\r');
         }
#endif
         buffer[i++] = quote;       /* Quote the character */
         if (t7 != quote)
         {
            t = ctl(t);             /* and uncontrolify */
            t7 = ctl(t7);
         }
      }
      if (image)
         buffer[i++] = t;           /* Deposit the character itself */
      else
         buffer[i++] = t7;

#ifdef OS9
      if ((t9&127)== '\r' && !image)  /* then if this is CR  */
      {
         buffer[i++]=quote;         /* Add LF   */
         buffer[i++]=ctl('\l');
      }
#endif

      if (i >= spsiz-8) return(i);  /* Check length */
   }
   if (i==0) return(EOF);           /* Wind up here only on EOF */
   return(i);                       /* Handle partial buffer */
}


/*
 *   b u f e m p
 *
 *  Put data from an incoming packet into a file.
 */

bufemp(buffer,len)
char  buffer[];                     /* Buffer */
int   len;                          /* Length */
{
   int i;                           /* Counter */
   char t;                          /* Character holder */

   for (i=0; i<len; i++)            /* Loop thru the data field */
   {
      t = buffer[i];                /* Get character */
      if (t == MYQUOTE)             /* Control quote? */
      {            
         t = buffer[++i];           /* Get the quoted character */
         if ((t & 0177) != MYQUOTE) /* Low order bits match quote char? */
            t = ctl(t);             /* No, uncontrollify it */
      }
#ifndef OS9
      if (t==CR && !image)          /* Don't pass CR if in image mode */
         continue;
#else
      if (t == '\l' && !image)      /* then if t = LF  */
         /*      if (ctl(buffer[i-2]) == '\r')   /* then if last char was CR  */
         continue;                  /* Skip LF, don't put in buffer */
#endif

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
   if (server) return(FALSE);      /* If server no multi send   */
   if (debug) printf("     gnxtfl: filelist = \"%s\"\n",*filelist);
   filnam = *(filelist++);
   if (filecount-- == 0) return FALSE; /* If no more, fail */
   else return TRUE;               /* else succeed */
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
   data[0] = tochar(MAXPACKSIZ);  /* Biggest packet I can receive */
   data[1] = tochar(MYTIME);      /* When I want to be timed out */
   data[2] = tochar(MYPAD);       /* How much padding I need */
   data[3] = ctl(MYPCHAR);        /* Padding character I want */
   data[4] = tochar(MYEOL);       /* End-Of-Line character I want */
   data[5] = MYQUOTE;             /* Control-Quote character I send */
}


/*  r p a r
 *
 *  Get the other host's send-init parameters
 *
 */

rpar(data)
char data[];
{
   spsiz = unchar(data[0]);       /* Maximum send packet size */
   timint = unchar(data[1]);      /* When I should time out */
   pad = unchar(data[2]);         /* Number of pads to send */
   padchar = ctl(data[3]);        /* Padding character to send */
   eol = unchar(data[4]);         /* EOL character I must send */
   quote = data[5];               /* Incoming data quote character */
}


/*
 *  f l u s h i n p u t
 *
 *  Dump all pending input to clear stacked up NACK's.
 */
flushinput()    
{
   /* OS9 Clear receive buffer   */
   char t;
#ifdef OSK
   while(getstat(1,ttyfd) > 0){
#else
   while(getstat(1,ttyfd) >= 0){
#endif
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
   printf("Usage:   kermit c[le line esc.char]         (connect mode)\n");
   printf("or:      kermit s[difl line] file ...       (send mode)\n");
   printf("or:      kermit r[difl line]                (receive mode)\n");
   printf("or:      kermit h[difl line]                (Host server mode)\n");
   printf("or:      kermit g[difl line] file ...       (get file from server)\n");
   printf("or:      kermit q[diful line]               (Quit remote Host server\n");
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
   if (!remot)
   {
      printf("Kermit: ");
      printf(fmt,a1,a2,a3,a4,a5);
      printf("\n");
      fflush(stdout);             /* force output (UTS needs it) */
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

   if (remot || server)
   {
      sprintf(msg,fmt,a1,a2,a3,a4,a5); /* Make it a string */
      len = strlen(msg);
      spack('E',n,len,msg);       /* Send the error packet */
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
