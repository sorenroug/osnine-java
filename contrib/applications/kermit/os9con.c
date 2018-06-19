/*
 * os9con.c connect for os9 kermit
 */

#include "os9inc.h"

/* 06/30/85 ral Adapt for server kermit, improve raw/cooked modes    
 *              and spawning shell
 * 
 * 12/05/85 ral add OSK ifdef's
 *
 * Os9 connect code by Bradley Bosch and Robert Larson  
 */

static struct sgbuf     insave,         /* Input scf save status */
                        outsave;        /* Output scf save status */

int
get_action()
{
        char    chr;
        int     nwrt;

        printmsg(" %c \l", escchr);
        read(0, &chr, 1);
        switch (chr) {
        case '!':
                cook(1,&outsave);       /* restore to cooked mode */
                cook(0,&insave);        /* Must be in reverse order of save */
                if (os9fork("shell", 1, "\n", 1, 1, 0) == -1)
                        printmsg("can't escape to shell.");
                else
                        wait(0);
                raw(0,&insave);         /* put it back to raw for packets */
                raw(1,&outsave);
                return (0);
        case 'q':
        case 'c':
        case 'C':
                return (1);
        default :
                /* case escchr: */
                if (chr == escchr)
                        write (ttyfd, &escchr, 1);
                return (0);
        }
}

/*
 *  c o n n e c t
 *
 *  Establish a virtual terminal connection with the remote host, over an
 *  assigned tty line. 
 */

connect()
{
        /* Two processes cannot do I/O to the  */
        /* same port at the same time in OS-9, */
        /* so we do some strange things here.  */
        char    cbuf[256];
        char    *buf = cbuf;
        int     cnt;
        int     flag;
        int     i;

        if (remot) {           /* Nothing to connect to in remote mode */
                printmsg("No line specified for connection.");
                return;
        }
        raw(0,&insave);                 /* Put input in raw mode */
        raw(1,&outsave);                /* Put output in raw mode */
        printmsg("connected escchr=%c ...\r\l", escchr);
        for (;;) {
#ifdef OSK
                while ((cnt=getstat(1, ttyfd)) > 0){
#else
                while ((cnt=getstat(1, ttyfd)) >= 0){
#endif
                    if(cnt > 1) {
#ifdef OSK   /* impossible for cnt to exceed 255 on os9/6809 */
                        if(cnt > 255) cnt = 255;
#endif
                        if((cnt=read(ttyfd, buf, cnt)) != -1) {
                            for(i=0; i<cnt;)
                                buf[i++] &= 0177;
                            write(1, buf, cnt);
                        }
                    } else {
                        if(read(ttyfd, buf, 1) != -1){
                            buf[0] &= 0177;         /* mask off high bit */
                            write(1, buf, 1);
                        }
                    }
                }
#ifdef OSK
                if ( getstat(1, 0) > 0 ) {
#else
                if ( getstat(1, 0) >= 0 ) {
#endif
                        cnt = read(0, cbuf, 1);
                        if (((*cbuf) & 0177) != escchr)
                                write(ttyfd, cbuf, cnt);
                        else if (get_action())
                                break; 
                }
                tsleep(1);              /* give the other processes a chance */
        } 

        cook(1, &outsave);              /* restore scf status */
        cook(0, &insave);               /* Must be done in opposite order! */
        printmsg("disconnected.");
}
