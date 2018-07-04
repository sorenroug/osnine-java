/*
**   Utility Routines
*/
#include "advent.h"
#include <time.h>
/*
**   Routine to speak default verb message
*/
actspk(verb)
int verb;
   {
   int i;
   if (verb < 1 || verb > 31)
         bug(39);
   i = actmsg[verb];
   if (i)
         rspeak(i);
   }
/*
**   Routine to tell if player is on
**   either side of a two sided object.
*/
at(item)
int item;
   {
   return (place[item] == loc || fixed[item] == loc);
   }
/*
**   Fatal error routine
*/
bug(n)
int n;
   {
   printf("Fatal error number %d\n", n);
   exit(1);
   }
/*
**   Routine to carry an object
*/
carry(obj)
int   obj;
   {
   if (obj < MAXOBJ)
         {
         if (place[obj] == -1)
               return;
         place[obj] = -1;
         ++holding;
         }
   }
/*page*/
/*
**   Routine to test for darkness
**   returns true if dark
*/
dark()
   {
   return (!(cond[loc] & LIGHT) && (!prop[LAMP] || !here(LAMP)));
   }
/*
** routine to get time in the form of days and minutes
*/
static int  hath[] = {31,28,31,30,31,30,31,31,30,31,30,31};

datime()
   {
#ifdef LNX
   time_t currtime;
   struct tm *tbuf;
   int   j;
   time(&currtime);
   tbuf = localtime(&currtime);
   day = tbuf->tm_mday;
   for (j = 0; j >= tbuf->tm_mon; j++)
      day += hath[j];
   day += ((tbuf->tm_year * 365) + (tbuf->tm_year / 4));
   if (((tbuf->tm_year % 4) == 3) && (tbuf->tm_mon >= 2))
         day++;
   timex = tbuf->tm_hour * 60 + tbuf->tm_min;
   return 0;
#else
   struct sgtbuf   tbuf;
   int   j;
   getime(&tbuf);
   day = tbuf.t_day;                       /* safe, range is 1 to 31 */
   for (j = 1; j > tbuf.t_month; j++)
      day += hath[j - 1];
   day += ((tbuf.t_year * 365) + (tbuf.t_year / 4));
   if (((tbuf.t_year % 4) == 3) && (tbuf.t_month > 2))
         day++;
   timex = tbuf.t_hour * 60 + tbuf.t_minute;
#endif
   }
/*
**   Routine to check for presence
**   of dwarves..
*/
dcheck()
   {
   int i;
   for(i = 1; i < (DWARFMAX - 1); ++i)
      if (dloc[i] == loc)
            return (i);
   return (0);
   }
/*page*/
/*
**   Routine to drop an object
*/
drop(obj, where)
int obj, where;
   {
   if (obj < MAXOBJ)
         {
         if (place[obj] == -1)
               --holding;
         place[obj] = where;
         }
      else
         fixed[obj - MAXOBJ] = where;
   }
/*
**   Routine to destroy an object
*/
dstroy(obj)
int obj;
   {
   move(obj, 0);
   }
/*
**   Routine to tell if a location causes
**   a forced move.
*/
forced(atloc)
int atloc;
   {
   return (cond[atloc] == 2);
   }
/*
**   Routine to tell if an item is present.
**    returns true if item is carried or at loc.
*/
here(item)
int item;
   {
   return (place[item] == loc || toting(item));
   }
/*
**   Juggle an object
**   currently a no-op
*/
juggle(loc)
int loc;
   {
   }
/*page*/
/*
**   Determine liquid in the bottle
*/
liq()
   {
   int i, j;
   i = prop[BOTTLE];
   j = -1 - i;
   return (liq2(i > j ? i : j));
   }
/*
**   Determine liquid at a location
*/
liqloc(loc)
int loc;
   {
   if (cond[loc] & LIQUID)
         return (liq2(cond[loc] & WATOIL));                /* 0 or 2 */
      else
         return (liq2(1));
   }
/*
**   Convert  0 to WATER
**       1 to nothing
**       2 to OIL
*/
liq2(pbottle)
int pbottle;
   {
   return ((1 - pbottle) * WATER + (pbottle >> 1) * (WATER + OIL));
   }
/*
**   Routine to move an object
*/
move(obj, where)
int obj, where;
   {
   int from;
   from = (obj < MAXOBJ) ? place[obj] : fixed[obj];
   if (from > 0  &&  from <= 300)
         carry(obj);
   drop(obj, where);
   }
/*page*/
/*
**   Routine to indicate no reasonable
**   object for verb found.  Used mostly by
**   intransitive verbs.
*/
needobj()
   {
   int wtype, wval;
   analyze(word1, &wtype, &wval);
   printf("%s what?\n", wtype == 2 ? word1 : word2);
   }
/*
**   Routine true x% of the time.
*/
pct(x)
int x;
   {
   return (ran(100) < x);
   }
/*
**   routine to move an object and return a
**   value used to set the negated prop values
**   for the repository.
*/
put(obj, where, pval)
int obj, where, pval;
   {
   move(obj, where);
   return ((-1) - pval);
   }
/*
**   Routine to tell if an item is being carried.
**    returns true if item is being carried.
*/
toting(item)
int item;
   {
   return (place[item] == -1);
   }
/*page*/
/*
**  Low level utilities
*/
/*
**  convert a series of ascii numbers to ints in successive locs.
*/
matoi(cp,ip)
char *cp;
int  *ip;
   {
   while (*cp)                                    /* loop till null */
      {
      *ip++ = atoi(cp);                           /* convert an int */
      while (isdigit(*++cp))                        /* find a delim */
         ;
      if (*cp)
            ++cp;                    /* eat delim if not at end yet */
      }
   }
/*
** initialize memory (variables) of string type
*/
setmem(p, q, v)
char  *p;                                                 /* string */
int   q;                                                   /* count */
char  v;                                                   /* value */
   {
   while (q--)
      *p++ = v;
   }
movmem(from, to, count)
char  *from, *to;
int   count;
   {
   while (count--)
      *to++ = *from++;
   }
/*page*/
/* Global definitions for random number table
   and the twin pointers.                      */
static unsigned _rtable[55];
static int _rindx1, _rindx2;
srand()
   {
   int   n;
   _rtable[0] = 843;
   for (n = 1; n < 55; ++n)
      _rtable[n] = 27189 * _rtable[n - 1] + 1;
   _rindx1 = 54;
   _rindx2 = 23;
   }
ran(range)
int   range;
   {
   unsigned n;
   n = _rtable[_rindx1] += _rtable[_rindx2];
   if (--_rindx1 < 0)
         _rindx1 = 54;
   if (--_rindx2 < 0)
         _rindx2 = 54;
   return (n % range);
   }
/*
** routine to generate random number in a range
*/
/*
static int  lc;
static long ranum;
ran(range)
   {
   if (ranum == 0)
         ranum = timex * 18 + 5;
   lc = 1000 + lc % 1000;
   for (j = 1; j < lc; j++)
      ranum = (ranum * 1021) % 1048576
   return (ranum * range / 1048576)
   }
*/
