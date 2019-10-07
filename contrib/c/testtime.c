#include <time.h>
#include <stdio.h>

#define time_t long
extern time_t mktime();
extern time_t time();

main()
{
    struct sgtbuf timebuf;
    time_t res, delta;
    int y;

    pflinit();

    timebuf.t_year = '\0';
    timebuf.t_month = '\0';
    timebuf.t_day = '\0';
    timebuf.t_hour = '\0';
    timebuf.t_minute = '\0';
    timebuf.t_second = '\0';

    res = mktime(0);
    printf("No buffer given: %ld\n", res);
    if (res != -1L)  printf("Assertion failure 1\n");

    res = mktime(&timebuf);
    printf("Time not set: %ld\n", res);
    if (res != -1L)  printf("Assertion failure 2\n");

    timebuf.t_month = (char)1;
    timebuf.t_day = (char)1;
    delta = 0L;

    for (y = 70; y < 110; y++) {
        timebuf.t_year = (char)y;
        res = mktime(&timebuf);
        printf("%d: %10ld, delta: %ld\n", y + 1900, res, res - delta);
        delta = res;
    }

    res = time(&timebuf);
    printf("Now: %ld\n", res);

}
