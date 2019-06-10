/*
 *    Kermit Get File from server function
 *
 *    Implemented by W.G. Seaton, NASA SC-LPS-32   KSC,Fl
 *     File: kermget.c
 *     12/11/84
 */
 getsw()
 {
 int len,num;
 char rstate,sfile();
    state='R';      /* Issue receive from host server */
     fp=NULL;
     rstate=sfile();
     state=recsw();
    return(TRUE);    /* task  completed  */
 }
