#include <time.h>

/*
 * https://code.woboq.org/userspace/glibc/time/mktime.c.html
 *
 */

#define EPOCH_YEAR 1970
#define TM_YEAR_BASE 1900

static int _mon_yday[2][13] =
   {
    /* Normal years.  */
    { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
    /* Leap years.  */
    { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
   };

static int
leapyear (year)
    int year;
{
  return
    ((year & 3) == 0
     && (year % 100 != 0 || ((year / 100) & 3) == 0));
/*   && (year % 100 != 0 || ((year / 100) & 3) == (0 - (TM_YEAR_BASE / 100) & 3))); */
}

/*
 * Convert OS-9 time struct to seconds since Unix epoch.
 * We ignore leap seconds and time zones.
 */
long mktime(tp)
    struct sgtbuf *tp;
{
    int i;
    long secs_epoch = 0L; /* Seconds since epoch */
    int days = 0;
    char year;

    if (tp == 0 || tp->t_year == '\0') return -1L; /* Clock is not started */

    year = tp->t_year - (char)70;
    for (i = 0; i < year; i++) {
        days += (leapyear(i + EPOCH_YEAR))?366:365;
    }
    days += _mon_yday[leapyear(year)][tp->t_month - 1];
    days += tp->t_day - 1;
    secs_epoch += (long)days * 86400L;
    secs_epoch += (long)tp->t_hour * 3600L;
    secs_epoch += (long)tp->t_minute * 60L;
    secs_epoch += (long)tp->t_second;
    return secs_epoch;
}

long time(tloc)
    long *tloc;
{
    long res;
    struct sgtbuf timebuf;

    getime(&timebuf);
    if (timebuf.t_year == 0) {
        return -1L;
    }
    res = mktime(&timebuf);
    if (tloc) *tloc = res;
    return res;
}
