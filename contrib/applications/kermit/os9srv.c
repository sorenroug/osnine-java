/*
 * os9srv.c server functions for os9 kermit
 */

#include "os9inc.h"

/*
 *      Kermit Host Server Function
 *
 *	11/03/86 ral fix no space alloacated for filnam bug.
 *
 *     File: kermserv.c
 *     04/08/85
 *        3/22  restructure and Directory option
 *        4/08  add test case for rpack return of False
 *        3/12  add I type
 */
servsw()
{
        int     len, num;
        char    rstate;
	char	filnam1[94];

        server = TRUE;
        state = 'W';    /* wait initial command from remote */
        n = 0;          /* Initialize packet counter     */
        numtry = 0;     /* Reset retry count      */

        for (;;) {
                if (debug)
                        printf("Server State: %c\n",state);
                rstate = rpack(&len, &num, packet);
                if (debug)
                        printf("Server Received State: %c\n", rstate);

                switch (rstate) {
                case FALSE:  
                        break;          /* Bad packet received.   */
                case 'I':
                        rpar(packet);   /*  Get parameters  */
                        spar(packet);   /*  Return Parameters  */
                        spack('Y', n, 6, packet);
                        numtry = 0;
                        break;

                case 'S':               /*  Receive File   */
                        state = recsw(); 
                        break;
                case 'R':               /*  Send File       */
                        if(debug)
                                printf("filename len of %d, name %s\n",
                                        len, packet);

			filnam = filnam1;	/* get somewhere to put name! */
                        strcpy(filnam, packet); /* Get file to send	*/
                        oldtry = numtry;        /* Reset counters	*/
                        fp = NULL;
                        filecount = 0;          /* One file at a time	*/
                        rstate = sendsw();      /* Go send file		*/
                        break;                  /* Done with the pass	*/

                case 'G':              		/* Generic Command Processor */
                        state = packet[0];      /* Get generic Command	*/

                        if (debug)
                                printf("Generic state request %c\n", state);

                        switch(state) {
                        case 'F':               /* Finish		*/
                        case 'L':               /* Logout (default Finish) */
                                /* Tell master I quit	*/
                                spack('Y', n, 0, packet);
                                return(TRUE);
                        }
                }
                state = 'W';
        }
}
