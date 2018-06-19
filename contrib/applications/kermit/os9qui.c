/*
 * os9qui.c quit to host server for os9 kermit
 */

#include "os9inc.h"

/*
 *      Kermit Quit to Host Server Function
 *
 *      by W. G. Seaton   NASA SC-LPS-32    11/15/84
 *
 * 07/01/85 ral add error handling 
 */

quitsw()
{            
        int     len, num;
        int     retries;

        for (retries = 0; retries < MAXTRY; retries++) {     
                packet[0] = 'F';        /* Generic command of Finish  */
                spack('G', 0, 1, packet);     /* Send Generic command  */
                switch(state = rpack(&len, &num, packet)) { /* get response  */
                case 'Y':
                        if (num == 0) {
                                puts("Remote Host Server Process Terminated.");
                                return(TRUE);
                        }
                        break;  /* not the ack for this packet */
                case 'N':       /* remote NAKed packet */
                case FALSE:     /* timeout or bad packet */
                        break;
                case 'E':
                        prerrpkt(packet);
                        return(FALSE);
                default:
                        if (debug)
                                printf("Remote Host responded to quit with packet type %c\n", state);
                        break;        
                }
        }
        printf("Remote Host failed to acknowledge Quit command\n");
        return(FALSE);
}
