/*
**  ENGLISH.C 
*/
#include "advent.h"
/*
**   Analyze a two word sentence
**    get a line from user.  Return 0 if error or invalid, else
**    set motion, verb, object.
*/
english()
   {
   char *msg;
   int type1, type2, val1, val2;
   verb = object = motion = 0;
   type2 = val2 = -1;
   type1 = val1 = -1;
   msg = "bad grammar...";
   getin();                /* get a line from user */
   if (!analyze(word1, &type1, &val1))
         return (0);
   if (type1 == ACTVERB && val1 == SAY)
         {
         verb = SAY;
         object = 1;
         return (1);
         }
   if (strcmp(word2, ""))
         if (!analyze(word2, &type2, &val2))
               return (0);
   /* check his grammar */
   if (type1 == SPLVERB)
         {
         rspeak(val1);
         return (0);
         }
      else 
         if (type2 == SPLVERB)
               {
               rspeak(val2);
               return (0);
               }
            else 
               if (type1 == MOTION)
                     {
                     if (type2 == MOTION)
                           {
                           printf("%s\n", msg);
                           return (0);
                           }
                        else
                           motion = val1;
                     }
                  else
                     if (type2 == MOTION)
                           motion = val2;
                        else 
                           if (type1 == OBJECT)
                                 {
                                 object = val1;
                                 if (type2 == ACTVERB)
                                       verb = val2;
                                       if (type2 == OBJECT)
                                             {
                                             printf("%s\n", msg);
                                             return (0);
                                             }
                                 }
                              else 
                                 if (type1 == ACTVERB)
                                       {
                                       verb = val1;
                                       if (type2 == OBJECT)
                                             object = val2;
                                       if (type2 == ACTVERB)
                                             {
                                             printf("%s\n", msg);
                                             return (0);
                                             }
                                       }
                                    else
                                       bug(36);
   return (1);
   }
/*
**  Routine to analyze a word.
**    set type = key value / 1000
**       value = key value % 1000
**    ret 0 on error, else 1
*/
analyze(word, type, value)
char *word;
int *type, *value;
   {
   int wordval, msg, i;
   /* make sure I understand */
   if ((wordval = vocab(word, 0)) == -1)
         {
         switch (ran(4))
            {
            case 0:                               /* 25% of the time */
               msg = 13;                         /* don't understand */
               break;
            case 1:                               /* 25% of the time */
               msg = 61;                                    /* what? */
               break;
            default:                              /* 50% of the time */
               msg = 60;                     /* don't know that word */
            }
         rspeak(msg);
         return (0);
         }
   *type = wordval / 1000;
   *value = wordval % 1000;
   return (1);
   }
/*page*/
/*
**   routine to get two words of input
**   and convert them to lower case
*/
getin()
   {
   char *cptr, *bptr;
   char linebuff[65];
   printf("> ");
   word1[0] = word2[0] = '\0';
   bptr = linebuff;
   gets(linebuff);
   printf("\n");
   skipspc(&bptr);
   getword(&bptr, word1);
   if (!*bptr)
         return;
   while (!isspace(*bptr))
      {
      if (!*bptr++)
            return;
      }
   skipspc(&bptr);
   getword(&bptr, word2);
   }
/*
**   Routine to extract one word from a buffer
*/
getword(buff, word)
char **buff, *word;
   {
   int i;
   for (i = 0;i < WORDSIZE;++i)
      {
      if (!**buff || isspace(**buff))
            {
            *word = '\0';
            return;
            }
      *word++ = tolower(*(*buff)++);
      }
   *(--word) = '\0';
   }
/*
**   Routine to skip spaces
*/
skipspc(buff)
char **buff;
   {
   while (isspace(**buff)) 
      ++(*buff);
   }
