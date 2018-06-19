/*
 * os9get.c
 */

#include "os9inc.h"

/*
 *    Kermit Get File from server function
 *
 *    Implemented by W.G. Seaton, NASA SC-LPS-32   KSC,Fl
 *     File: kermget.c
 *     12/11/84
 */

getsw()
{
        int     len, num, retries;
        char    rstate, sfile();

        do {
                state = 'R';    /* Issue receive from host server */
                fp = NULL;
                for     (retries = 0;
                        (rstate = sfile()) == FALSE && retries < MAXTRY;
                         retries++)
                        ;
                if (rstate == FALSE)
                        return(FALSE);
                state = recsw();
        } while (gnxtfl());

        return(state);  /* task  completed  */

}
