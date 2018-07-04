/*
**  program ADVENT.C
*/
#define MAIN 1
#include "advent.h"

#ifdef LNX
char *defdrive()
{
    return "..";
}
#endif

int   newlim = 0;
main(argc, argv)
int argc;
char **argv;
   {
   int   rflag = 0;                   /* user restore request option */
   char  *rpnt = NULL;
   setbuf(stdout, 0);
   while (--argc > 0)
      {
      ++argv;
      if (**argv != '-')
            {
            rpnt = *argv;
            continue;
            }
      switch(tolower(argv[0][1]))
         {
         case 'r':
            ++rflag;
            continue;
         case 'd':
            dbgflg = atoi(&argv[0][3]);
            continue;
         case 'l':
            newlim = atoi(&argv[0][3]);
            break;
         default:
            printf("unknown flag: %c\n", argv[0][1]);
            continue;
         }
      }
   init(rflag, rpnt);
   if (newlim)
         limit = newlim;
      else
         if (yes(65, 1, 0))
               limit = 1000;
   while (!saveflg)
      turn();
   if (saveflg)
         saveadv();
   }
/*page*/
/*
** Initialization
*/
static char *misc = "/GAMES/ADVENT";
static char *dat  = ".dat";
static char *name = "/advent";
init(rflag, rpnt)
int   rflag;
char  *rpnt;
   {
   int   c;
   int   i, j, n, offset, wval;
   int   error = 0;
   int   trying = TRUE;
   char  *p, *wptr, *wordptr, word[WORDSIZE], buf[40];
   printf("Go read a book while I get my act together...\n");
   /* initialize various flags and other variables */
   setmem(visited, MAXLOC, 0);
   setmem(prop, sizeof(int) * 51, 0);
   setmem(&prop[50], sizeof(int) * (MAXOBJ-50), 0xff);
   /* clear disk index arrays */
   for (i = 0; i < MAXLOC / 10; ++i)
      idx1[i] = idx2[i] = idx3[i] = 0;
   for (i = 0; i < 30; ++i)
      idx6[i] = 0;
   strcpy(buf, defdrive());
   strcat(buf, misc);                            /* default location */
   strcat(buf, name);                                /* add "advent" */
   n = strlen(buf);                            /* find end of string */
   while (trying)
      {
      for (i = 1; i < 7; i++)
         {
         buf[n] = i + '0';                    /* add database number */
         buf[n + 1] = '\0';                          /* terminate it */
         strcat(buf, dat);                         /* add extenstion */
         if ((fd[i] = fopen(buf, "r")) == 0)
               if (error++)
                     {
                     printf("can't open %s\n", buf);
                     bug(errno);             /* second time is fatal */
                     }
                  else
                     {
                     printf("Can't find data.  Where is it? ");
                     gets(buf);                    /* get his answer */
                     strcat(buf, name);              /* add "advent" */
                     n = strlen(buf);               /* recompute EOS */
                     break;                        /* and start over */
                     }
         } /* end of for */
      if (error == 0)
            trying = FALSE;               /* break out if successful */
      }
/*page*/
/* read data 1,2,3 and build index to every 10th entry */
   for (i = 1; i <= 3; ++i)
      {
      if (fseek(fd[i], 0l, 0) == -1)
            bug(42);
      offset = 0;
      for (j = 0; j < 141; ++j)
         {
         while ((c = getc(fd[i])) != '#')
            {
            if (c == EOF)
                  bug(40);
            ++offset;
            }
         if (j % 10 == 0)
               {
               switch (i)
                  {
                  case 1:
                     idx1[j / 10] = offset;
                     break;
                  case 2:
                     idx2[j / 10] = offset;
                     break;
                  case 3:
                     idx3[j / 10] = offset;
                     break;
                  default:
                     break;
                  }
               }
         ++offset;
         }
      }
/* read data 6 and build index to every 10th entry */
   offset = 0;
   if (fseek(fd[6], 0l, 0) == -1)
         bug(43);
   for (j = 0; j < 201; ++j)
      {
      while ((c = getc(fd[6]))!='#')
         {
         if (c == EOF)
               bug(41);
         ++offset;
         }
      if (j % 10 == 0)
            {
            idx6[j / 10] = offset;
            }
      ++offset;
      }
/*page*/
   /*
      initialize fast verb arrays
   */
   if (fseek(fd[4], 0l, 0) == -1)
         bug(46);
   fastvseek = 0;
   wptr = fastverb;
   wval = 0;
   while (n = fgets(p = buf, 38, fd[4]))
      {
      if (wptr > &fastverb[MAXVFAST - 6] || wval > MAXVVAL)
            bug(45);                            /* out of room error */
      while (*p != ',')
         *wptr++ = *p++;              /* copy text portion to memory */
      *wptr++ = 0;                               /* terminate string */
      fastvval[wval++] = atoi(++p);   /* convert the numeric portion */
      }
   srand();
   start(rflag, rpnt);
   }
/*page*/
/*
** start routine
**  checks to see if it is ok to play and handles restart
*/
start(rflag, rpnt)
int   rflag;
char  *rpnt;
   {
   if (rpnt || rflag)
         restore(rpnt);
   datime();
   if (((day - savday) * 1440 + (timex - savtime)) < 90)
         {
         printf("Only wizards can restart a game this soon");
         exit (0);
         }
   }
/*page*/
/*
   restore saved game handler
*/
static   char  *aext = ".adv";
static   char  *opnerr = "Can't open %s\n";
static   char  *readerr = "Can't read %s\n";
static   char  *writerr = "Can't write %s\n";
static   char  *clozerr = "Can't close %s\n";
restore(rpnt)
char  *rpnt;
   {
   char username[13];
   char *sptr;
   int   c, r1, r2, r3;
   if (rpnt)
         strcpy(username, rpnt);
      else
         {
         printf("Saved game name? ");
         gets(username);
         }
   strcat(username, aext);
   if ((fd[0] = fopen(username, "r")) == -1)
         {
         printf(opnerr, username);
         exit(errno);
         }
   r1 = fread(&turns, 1, BLK1SIZ, fd[0]);
   r2 = fread(&cond[0], 1, BLK2SIZ, fd[0]);
   r3 = fread(&visited[0], 1, BLK3SIZ, fd[0]);
   if (!r3 || !r2 || !r1)
         {
         printf(readerr, username);
         exit (errno);
         }
   if (fclose(fd[0]) == -1)
         printf(clozerr, username);
   saveflg = 0;
   }
/*page*/
/*
**   save adventure game
*/
saveadv()
   {
   char username[13];
   char *sptr;
   int   r1, r2, r3;
   printf("What do you want to call the saved game? ");
   gets(username);
   strcat(username, aext);
   if ((fd[0] = fopen(username, "w")) == -1)
         {
         printf(opnerr, username);
         exit (errno);
         }
   r1 = fwrite(&turns, 1, BLK1SIZ, fd[0]);
   r2 = fwrite(&cond[0], 1, BLK2SIZ, fd[0]);
   r3 = fwrite(&visited[0], 1, BLK3SIZ, fd[0]);
   if (!r3 || !r2 || !r1)
         {
         printf(writerr, username);
         exit (errno);
         }
   if (fclose(fd[0]) == -1)
         {
         printf(clozerr, username);
         exit (errno);
         }
   printf("OK -- \"C\" you later...\n");
   }
