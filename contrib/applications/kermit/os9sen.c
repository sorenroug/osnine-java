/*
 * os9sen.c  send file routines of os9 kermit
 */

#include "os9inc.h"

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

        state = 'S';    /* Send initiate is the start state */
        n = 0;          /* Initialize message number */
        numtry = 0;     /* Say no tries yet */
        for (;;) {      /* Do this as long as necessary */
                if (debug)
                        printf("sendsw state: %c, Packet # %d\n",state,n);
                if ((!remot) && (!debug)) 
                        if (n % 10 == 0)
                                printmsg("Status: Sending Packet # %d",n);

                switch(state) {
                case 'S':
                        state = sinit(); break; /* Send-Init */
                case 'F':
                        state = sfile(); break; /* Send-File */
                case 'D':
                        state = sdata(); break; /* Send-Data */
                case 'Z':
                        state = seof(); break;  /* Send-End-of-File */
                case 'B':
                        state = sbreak(); break;/* Send-Break */
                case 'C':   
                        return (TRUE);          /* Complete */
                case 'A':   
                        return (FALSE);         /* "Abort" */
                default:   
                        return (FALSE);         /* Unknown, fail */
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
        int num, len;           /* Packet number, length */

        if (numtry++ > MAXTRY)
                return('A');    /* If too many tries, give up */
        spar(packet);           /* Fill up init info packet */

        flushinput();           /* Flush pending input */

        spack('S', n, 6, packet);      /* Send an S packet */
        switch(rpack(&len, &num, recpkt)) {  /* What was the reply? */
        case 'N':  
                return(state);   /* NAK, try it again */

        case 'Y':         /* ACK */
                if (n != num)      /* If wrong ACK, stay in S state */
                        return(state);      /* and try again */
                rpar(recpkt);      /* Get other side's init info */

                if (eol == 0) eol = '\n';   /* Check and set defaults */
                if (quote == 0) quote = '#';

                numtry = 0;             /* Reset try counter */
                n = (n + 1) % 64;       /* Bump packet count */
                return('F');            /* OK, switch state to F */

        case 'E':         /* Error packet received */
                prerrpkt(recpkt);       /* Print it out and */
                return('A');            /* abort */

        case FALSE: 
                return(state);          /* Receive failure, try again */

        default: 
                return('A');            /* Anything else, just "abort" */
        }
}

/*
 *  s f i l e
 *
 *  Send File Header.
 */

char sfile()
{
        int     num, len;       /* Packet number, length */
        char    filnam1[50],    /* Converted file name */
                *newfilnam,     /* Pointer to file name to send */
                *cp;            /* char pointer */

        if (numtry++ > MAXTRY)
                return('A');    /* If too many tries, give up */

        if (gflg == 0) {          /* If Get mode just send name  */
                if (fp == NULL) {        /* If not already open, */
                        if (debug)
                                printf("   Opening %s for sending.\n",filnam);
                        /* open the file to be sent */
                        fp = fopen(filnam,"r");
                        if (fp == NULL) {
                                /* bad file pointer, give up */
                                error("Cannot open file %s",filnam);
                                return('A');
                        }
                }
        }

        strcpy(filnam1, filnam);      /* Copy file name */
        newfilnam = cp = filnam1;
        if (!gflg)                    /* if not in get routine */
                while (*cp != '\0')   /* Strip off all leading directory */
                        if (*cp++ == '/')   /* names (ie. up to the last /). */
                                newfilnam = cp;

        if (filnamcnv)                /* Convert lower case to upper   */
                for (cp = newfilnam; *cp != '\0'; cp++)
                        if (*cp >= 'a' && *cp <= 'z')
                                *cp ^= 040;

        len = cp - newfilnam;      /* Compute length of new filename */

        if (gflg == 0) {     /*  If not Get function   */
                printmsg("Sending %s as %s", filnam, newfilnam);
                spack('F', n, len, newfilnam);   /* Send an F packet */
        } else {
                spack('R', n, len, newfilnam);   /* Send Get file packet */
                return('R');
        }

        switch(rpack(&len, &num, recpkt)) {       /* What was the reply? */
        case 'N':                         /* NAK, just stay in this state, */
                num = (--num<0 ? 63:num); /* unless it's NAK for next packet */
                if (n != num)             /* which is just like an ACK for */ 
                        return(state);    /* this packet so fall thru to... */

        case 'Y':                       /* ACK */
                if (gflg != 0)          /* Test if get function  */
                        return('D');    /* If so no number check, Done */
                if (n != num)
                        return(state);  /* If wrong ACK, stay in F state */
                numtry = 0;             /* Reset try counter */
                n = (n + 1) % 64;       /* Bump packet count */
                size = bufill(packet);  /* Get first data from file */
                return('D');            /* Switch state to D */

        case 'E':                       /* Error packet received */
                prerrpkt(recpkt);       /* Print it out and */
                return('A');            /* abort */

        case FALSE:
                return(state);          /* Receive failure, stay in F state */

        default: 
                return('A');            /* Something else, just "abort" */
        }
}

/*
 *  s d a t a
 *
 *  Send File Data
 */

char sdata()
{
        int     num, len;         /* Packet number, length */

        if (numtry++ > MAXTRY)
                return('A'); /* If too many tries, give up */

        spack('D', n, size, packet);      /* Send a D packet */
        switch (rpack(&len, &num, recpkt)) {   /* What was the reply? */
        case 'N':         /* NAK, just stay in this state, */
                num = (--num<0 ? 63:num);   /* unless it's next packet's NAK */
                if (n != num)               /* which is just like an ACK for */
                        return(state);      /* this packet so fall thru to... */

        case 'Y':         /* ACK */
                if (n != num)
                        return(state);  /* If wrong ACK, fail */
                numtry = 0;             /* Reset try counter */
                n = (n+1)%64;           /* Bump packet count */
                if ((size = bufill(packet)) == EOF) /* Get data from file */
                        return('Z');    /* If EOF set state to that */
                return('D');            /* Got data, stay in state D */

        case 'E':         /* Error packet received */
                prerrpkt(recpkt);       /* Print it out and */
                return('A');            /* abort */

        case FALSE: 
                return(state);   /* Receive failure, stay in D */

        default:    
                return('A');   /* Anything else, "abort" */
        }
}

/*
 *  s e o f
 *
 *  Send End-Of-File.
 */

char
seof()
{
        int     num, len;         /* Packet number, length */

        if (numtry++ > MAXTRY)
                return('A'); /* If too many tries, "abort" */

        spack('Z', n, 0, packet);      /* Send a 'Z' packet */
        switch(rpack(&len, &num, recpkt)) {   /* What was the reply? */
        case 'N':         /* NAK, just stay in this state, */
                num = (--num<0 ? 63:num);   /* unless it's next packet's NAK, */
                if (n != num)               /* which is just like an ACK for */
                        return(state);      /* this packet so fall thru to... */

        case 'Y':         /* ACK */
                if (n != num)
                        return(state);  /* If wrong ACK, hold out */
                numtry = 0;             /* Reset try counter */
                n = (n+1)%64;           /* and bump packet count */
                if (debug)
                        printf("     Closing input file %s, ",filnam);
                fclose(fp);             /* Close the input file */
                fp = NULL;              /* Set flag indicating no file open */


                if (debug)
                        printf("looking for next file...\n");
                if (gnxtfl() == FALSE)  /* No more files go? */
                        return('B');    /* if not, break, EOT, all done */
                if (debug)
                        printf("     New file is %s\n",filnam);
                return('F');            /* More files, switch state to F */

        case 'E':         /* Error packet received */
                prerrpkt(recpkt);       /* Print it out and */
                return('A');            /* abort */

        case FALSE: 
                return(state);          /* Receive failure, stay in Z */

        default:    
                return('A');            /* Something else, "abort" */
        }
}

/*
 *  s b r e a k
 *
 *  Send Break (EOT)
 */

char sbreak()
{
        int     num, len;         /* Packet number, length */

        if (numtry++ > MAXTRY)
                return('A'); /* If too many tries "abort" */

        spack('B', n, 0, packet);      /* Send a B packet */
        switch (rpack(&len, &num, recpkt)) {  /* What was the reply? */
        case 'N':
                /* NAK, just stay in this state, */
                num = (--num<0 ? 63:num);   /* unless previous packet's NAK, */
                if (n != num)               /* which is just like an ACK for */
                        return(state);      /* this packet so fall thru to... */

        case 'Y':         /* ACK */
                if (n != num)
                        return(state);  /* If wrong ACK, fail */
                numtry = 0;             /* Reset try counter */
                n = (n+1)%64;           /* and bump packet count */
                return('C');            /* Switch state to Complete */

        case 'E':         /* Error packet received */
                prerrpkt(recpkt);       /* Print it out and */
                return('A');            /* abort */

        case FALSE: 
                return(state);          /* Receive failure, stay in B */

        default:    
                return ('A');           /* Other, "abort" */
        }
}
