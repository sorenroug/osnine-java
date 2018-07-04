/*
**  programs in DATABASE.C
*/
#include "advent.h"
/*
**  Routine to fill travel array
**  for a given location.
*/
gettrav(loc)
int loc;
   {
   int opt;
   char atrav[20];
   fseek(fd[3], idx3[(loc - 1) / 10], 0);
   rdskip(fd[3], '#', (loc - 1) % 10 + 1);
   rdskip(fd[3], '\n', 1);
   for(opt = 0; opt < MAXTRAV; ++opt)
      {
      rdupto(fd[3], '\n', atrav);
      if (atrav[0] == '#')
            {
            travel[opt].tdest = -1;
            return;
            }
      travel[opt].tcond = 0;
      matoi(atrav, &travel[opt]);
      if (dbgflg & SHOTRAV)
            printf("gettrav = %d %d %d \n",
                travel[opt].tdest,
                travel[opt].tverb,
                travel[opt].tcond);
      }
   bug(33);
   }
/*
**   Routine to request a yes or no answer
**   to a question.
*/
yes(msg1, msg2, msg3)
int msg1, msg2, msg3;
   {
   char answer[80];
   if (msg1)
         rspeak(msg1);                             /* prompt message */
   printf("> ");
   gets(answer);
   if (tolower(answer[0]) == 'n')
         {
         if (msg3)
               rspeak(msg3);            /* possible response to "no" */
         return (0);
         }
   if (msg2)
         rspeak(msg2);                          /* response to "yes" */
   return (1);
   }
/*page*/
/*
**   Function to scan a file up to a specified
**   point and either print or return a string.
**  Print it if "*string" is null.
*/
rdupto(buff, delim, string)
FILE  *buff;
char  delim, *string;
   {
   int c;
   while ((c = getc(buff)) != delim)
      {
      if (c == EOF)
            return (0);
      if (string == 0)
            putchar(c);
         else
            if (c != '\n')
                  *string++ = c;
      }
   if (string)
         *string = '\0';
   return (1);
   }
/*
**   Function to read a file skipping
**   a given character a specified number
**   of times, with or without repositioning
**   the file.
*/
rdskip(buff, x, n)
FILE  *buff;
char  x;
int n;
   {
   int c;
   while (n--)
      while ((c = getc(buff)) != x)
         if (c == EOF)
               bug(32);
   }
/*page*/
/*
**   Print a random message from database 6
*/
rspeak(msg)
int msg;
   {
   if (msg == 54)
         {
         printf("ok.\n");
         return;
         }
   fseek(fd[6], idx6[(msg - 1) / 10], 0);
   rdskip(fd[6], '#', (msg - 1) % 10 + 1);
   rdskip(fd[6], '\n', 1);
   rdupto(fd[6], '#', 0);
   }
/*
**   Routine to print the message
**   for an item in a given state.
*/
pspeak(item, state)
int item, state;
   {
   fseek(fd[5], 0l, 0);
   rdskip(fd[5], '#', item);
   rdskip(fd[5], '/', state + 2);
   rdupto(fd[5], '/', 0);
   }
/*
**   Print the long description of a location
*/
desclg(loc)
int loc;
   {
   fseek(fd[1], idx1[(loc - 1) / 10], 0);
   rdskip(fd[1], '#', (loc - 1) % 10 + 1);
   rdskip(fd[1], '\n', 1);
   rdupto(fd[1], '#', 0);
   }
/*
**   Print the short description of a location
*/
descsh(loc)
int loc;
   {
   fseek(fd[2], idx2[(loc - 1) / 10], 0);
   rdskip(fd[2], '#', (loc - 1) % 10 + 1);
   rdskip(fd[2], '\n', 1);
   rdupto(fd[2], '#', 0);
   }
/*page*/
/*
**   routine to look up a vocabulary word.
**   word is the word to look up.
**   val  is the minimum acceptable value, if != 0 return  % 1000
**    else return key value of verb (except -1 for error)
*/
vocab(word, val)
char *word;
int val;
   {
   char vword[WORDSIZE];
   int v;
   char *wptr;
   int wval;
   wval = 0;
   wptr = fastverb;
   while (*wptr)
      {
      if (!strncmp(word, wptr, 5))
            {
            v = fastvval[wval];
            if (!val)
                  return (v);
            if (val <= v)
                  return (v % 1000);
         }
      while (*wptr++)
         ;
      ++wval;
      }
   /* reposition file */
   if (fseek(fd[4], fastvseek, 0) == -1)
         bug(21);
   while(1)
      {
      if (!rdupto(fd[4], ',', vword))                  /* get a word */
            return (-1);
      if (!strncmp(word, vword, 5))      /* now compare to our word */
            {
            if (!rdupto(fd[4], '\n', vword))           /* get number */
                  bug(30);
            v = atoi(vword);                            /* de-ascify */
            if (!val)
                  return (v);
            if (val <= v)
                  return (v % 1000);
            }
      rdskip(fd[4], '\n', 1);
      }
   }
