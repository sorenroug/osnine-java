/*
 * os9rec.c receive file routines for os9 kermit
 */

#include "os9inc.h"

/*
 * r e c s w
 *
 * This is the state table switcher for receiving files.
 */

recsw()
{
        char    rinit(), rfile(), rdata();        /* Use these procedures */

        state = 'R';    /* Receive-Init is the start state */
        n = 0;          /* Initialize message number */
        numtry = 0;     /* Say no tries yet */

/*
 * We are commenting out code that automatically NAKed
 * in case the sender started first; this may be the reason
 * that this Kermit gets out of whack.  The original code
 * said
 *      if (gflg == FALSE)
 *              spack('N', n, 0, 0);
 */

        for (;;) {
                if (debug)
                        printf(" recsw state: %c\n",state);
                switch(state) {       /* Do until done */
                case 'R':   
                        state = rinit(); break; /* Receive-Init */
                case 'F':   
                        state = rfile(); break; /* Receive-File */
                case 'D':   
                        state = rdata(); break; /* Receive-Data */
                case 'C':   
                        return(TRUE);           /* Complete state */
                case 'A':   
                        return(FALSE);          /* "Abort" state */
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
        int     len, num;       /* Packet length, number */
        char    sfile();        /* routine used for get command */

        if (numtry++ > MAXTRY)
                return('A');    /* If too many tries, "abort" */

        switch(rpack(&len, &num, packet)) {  /* Get a packet */
        case 'S':         /* Send-Init */
                rpar(packet);           /* Get the other side's init data */
                spar(packet);           /* Fill up packet with my init info */
                spack('Y', n, 6, packet);   /* ACK with my parameters */
                oldtry = numtry;        /* Save old try count */
                numtry = 0;             /* Start a new counter */
                n = (n + 1) % 64;       /* Bump packet number, mod 64 */
                return('F');            /* Enter File-Receive state */

        case 'E':         /* Error packet received */
                prerrpkt(packet);      /* Print it out and */
                return('A');      /* abort */

        case FALSE:         /* Didn't get packet */
        case 'N':           /* or got a NAK */
                if (gflg)
                        sfile();                /* request file again */
                else
                        spack('N', n, 0, 0);      /* Return a NAK */
                return(state);      /* Keep trying */

        case 'Y':
                return(state);          /* Ignore leftover ACK */
                /* (or incorrect ACK of 'R' packet) */

        default:     
                return('A');   /* Some other packet type, "abort" */
        }
}

/*
 *  r f i l e
 *
 *  Receive File Header
 */

char rfile()
{
        int     num, len;       /* Packet number, length */
        char    filnam1[50];    /* Holds the converted file name */

        if (numtry++ > MAXTRY)
                return('A');    /* "abort" if too many tries */

        switch (rpack(&len, &num, packet)) {  /* Get a packet */
        case 'S':         /* Send-Init, maybe our ACK lost */
                if (oldtry++ > MAXTRY)
                        return('A'); /* If too many tries "abort" */
                if (num != ((n == 0) ? 63 : n - 1))
                        return('A');      /* Not previous packet, "abort" */
                /* Previous packet, mod 64; ack with our */
                /* Send-Init parameters */
                spar(packet);
                spack('Y', num, 6, packet);
                numtry = 0;      /* Reset try counter */
                return(state);      /* Stay in this state */

        case 'Z':         /* End-Of-File */
                if (oldtry++ > MAXTRY)
                        return('A');
                if (num != ((n==0) ? 63:n-1))
                        return('A');      /* Not previous packet, "abort" */
                spack('Y',num,0,0);
                numtry = 0;
                return(state);      /* Stay in this state */

        case 'F':         /* File Header (just what we want) */
                if (num != n)
                        return('A');   /* The packet number must be right */
                strcpy(filnam1, packet);   /* Copy the file name */

                if (filnamcnv) {      /* Convert upper case to lower */
                        for (filnam = filnam1; *filnam != '\0'; filnam++)
                                if (*filnam >= 'A' && *filnam <= 'Z')
                                        *filnam |= 040;
                }

                /* Try to open a new file */

                if ((fp = fopen(filnam1, "w")) == NULL)  {
                        error("Cannot create %s", filnam1);
                        return('A');    /* Give up */
                }

                /* OK, give message */
                printmsg("Receiving %s as %s", packet, filnam1);

                spack('Y', n, 0, 0);    /* Acknowledge the file header */
                oldtry = numtry;        /* Reset try counters */
                numtry = 0;             /* ... */
                n = (n + 1) % 64;       /* Bump packet number, mod 64 */
                return('D');            /* Switch to Data state */

        case 'B':         /* Break transmission (EOT) */
                if (num != n)
                        return ('A');   /* Need right packet number here */
                spack('Y', n, 0, 0);    /* Say OK */
                return('C');            /* Go to complete state */

        case 'E':         /* Error packet received */
                prerrpkt(packet);       /* Print it out and */
                return('A');            /* abort */

        case FALSE:         /* Didn't get packet */
                spack('N', n, 0, 0);    /* Return a NAK */
                return(state);          /* Keep trying */

        default:    
                return ('A');   /* Some other packet, "abort" */
        }
}

/*
 *  r d a t a
 *
 *  Receive Data
 */

char rdata()
{
        int     num, len;         /* Packet number, length */

        if (numtry++ > MAXTRY)
                return('A'); /* "abort" if too many tries */

        switch (rpack(&len, &num, packet)) {   /* Get packet */
        case 'D':         /* Got Data packet */
                if (num != n) {      /* Right packet? */
                        /* No! */
                        if (oldtry++ > MAXTRY ||        /* too many tries */
                            (num != ((n==0) ? 63:n-1))) /* not prev. packet */
                                return('A');
                        spack('Y', num, 6, packet);     /* Yes, re-ACK it */
                        numtry = 0;                     /* Reset try counter */
                        return(state);                  /* Don't write data! */
                }
                /* Got data with right packet number */
#ifdef nooverlap
                /* Cannot handle concurrent disk and serial i/o, so delay ACK */
                /* until file written */
                bufemp(packet, len);    /* Write the data to the file */
                spack('Y', n, 0, 0);    /* Acknowledge the packet */
#else
                /* ACK before file write to overlap disk and serial i/o */
                spack('Y', n, 0, 0);    /* Acknowledge the packet */
                bufemp(packet, len);    /* Write the data to the file */
#endif
                oldtry = numtry;        /* Reset the try counters */
                numtry = 0;             /* ... */
                n = (n + 1) % 64;       /* Bump packet number, mod 64 */
                return('D');            /* Remain in data state */

        case 'F':         /* Got a File Header */
                if (oldtry++ > MAXTRY ||        /* too many tries */
                    (num != ((n==0) ? 63:n-1))) /* not prev. packet */
                        return('A');
                spack('Y', num, 0, 0);  /* ACK it again */
                numtry = 0;             /* Reset try counter */
                return(state);          /* Stay in Data state */

        case 'Z':         /* End-Of-File */
                if (num != n)
                        return('A');   /* Must have right packet number */
#ifdef nooverlap
                /* can't handle disk and serial i/o at the same time */
                fclose(fp);             /* close the file */
                spack('Y', n, 0, 0);    /* Ack the 'Z' packet */
#else
                /* ACK before close to allow i/o overlap */
                spack('Y', n, 0, 0);    /* OK, ACK it. */
                fclose(fp);             /* Close the file */
#endif
                n = (n + 1) % 64;      /* Bump packet number */
                return('F');            /* Go back to Receive File state */

        case 'E':         /* Error packet received */
                prerrpkt(packet);      /* Print it out and */
                return('A');            /* abort */

        case FALSE:         /* Didn't get packet */
                spack('N', n, 0, 0);      /* Return a NAK */
                return(state);      /* Keep trying */

        default:     
                return('A');   /* Some other packet, "abort" */
        }
}
