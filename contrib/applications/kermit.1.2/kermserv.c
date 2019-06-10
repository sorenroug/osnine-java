/*
 *      Kermit Host Server Function
 *
 *     File: kermserv.c
 *     12/07/84
 */
servsw()
 {
 int len,num;
 char rstate;
 server=TRUE;
 state='W';        /* wait inital command from remote */
 n=0;             /* Initialize packet counter  */
 numtry=0;        /* Reset retry count   */

 while(TRUE)
 {
  if (debug) printf("Server State: %c\n",state);
  rstate=rpack(&len,&num,packet);
  if (debug) printf("Server Received State: %c\n",rstate);
  switch (rstate)
  {
   case 'S': state=recsw(); break;  /*  Receive File   */
   case 'R':                        /*  Send File      */
     if(debug) printf("filename len of %d, name %s\n",len,packet);
     strcpy(filnam,packet);    /* Get file to send     */
     oldtry=numtry;            /* Reset counters       */
     fp=NULL;
       filecount=0;            /* One file at a time   */
       rstate=sendsw();        /* Go send file         */
     break;                    /* Done with the pass   */

    case 'G':                  /* Gernic Command Processor  */
     state=packet[0];
     if (debug) printf("Generic state request %c\n",state);

     if ((state == 'L') || (state == 'F'))  /* Finish or Logout */
      {
       spack('Y',n,0,packet);               /* Tell master I quit */
       return(TRUE);
      }
   }
   state = 'W';
  }
 }
