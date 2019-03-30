/*
 *      Kermit Quit to Host Server Function
 *
 *      by W. G. Seaton   NASA SC-LPS-32    11/15/84
 */
 quitsw()
 {
 int len,num;
 packet[0]='F';        /* Generic command of Finish  */
 spack('G',0,1,packet);     /* Send Generic command  */
 if (rpack(&len,&num,packet) == 'Y') /* get responce  */
 {
   printf("Remote Host Server Process Terminated.\n");
   return(TRUE);
  }
 else
 {
   printf("Remote Host failed and responded with %c\n",state);
   return(FALSE);
 }
 }
