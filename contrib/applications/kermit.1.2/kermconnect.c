/*
 *  c o n n e c t
 *
 *  Establish a virtual terminal connection with the remote host, over an
 *  assigned tty line. 
 */

connect()
{
    int pid,            /* Holds process id of child */
   connected;         /* Boolean connect flag */
    char bel = '\07',
   c;

    struct sgttyb
   rawmode,         /* Controlling tty raw mode */
   cookedmode;         /* Controlling tty cooked mode */

printmsg("NOT IMPLEMENTED YET.....");
return;
    if (remote)            /* Nothing to connect to in remote */
    {               /* mode, so just return */
   printmsg("No line specified for connection.");
   return;
    }

    gtty(0,&cookedmode);      /* Save current mode so we can */
    gtty(0,&rawmode);         /* restore it later */
    rawmode.sg_flags |= (RAW|TANDEM);
    rawmode.sg_flags &= ~(ECHO|CRMOD);
    stty(0,&rawmode);         /* Put tty in raw mode */

/*    UNIX Call not avail in OS9   */
/*    pid = fork();   Start fork to get typeout from remote host */

    if (pid)             /* Parent: send type-in to remote host */
    {
   printmsg("connected...\r");
   connected = TRUE;      /* Put us in "connect mode" */
   while (connected)
   {
       read(0,&c,1);      /* Get a character */
       if ((c&0177) == escchr)   /* Check for escape character */
       {
      read(0,&c,1);
      if ((c&0177) == escchr)
          write(ttyfd,&c,1);
      else
      switch (c&0177)
      {
          case 'c':
          case 'C':
          case '.':
         connected = FALSE;
         write(0,"\r\n",2);
         break;

          case 'h':
          case 'H':
         write(0,"\r\nYes, I'm still here...\r\n",26);
         break;

          default:
         write(0,&bel,1);
         break;
      }
       }
       else
       {            /* If not escape charater, */
      write(ttyfd,&c,1);   /* write it out */
      c = NULL;      /* Nullify it (why?) */
       }
   }
   kill(pid,9);         /* Done, kill the child */
   wait(0);         /* and bury him */
   stty(0,&cookedmode);      /* Restore tty mode */
   printmsg("disconnected.");
   return;            /* Done */
    }
    else        /* Child does the reading from the remote host */
    {
   while(1)         /* Do this forever */
   {
       read(ttyfd,&c,1);
       write(1,&c,1);
   }
    }
}
