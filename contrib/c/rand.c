/*
 * Returns a uniform random deviate between 0.0 and 1.0.
 * Set idum to any negative value to initialize or reinitialize the sequence.
 */
#include <stdio.h>
#include <time.h>

#define MBIG 4.0e6
#define MSEED 1618033.0
#define MZ 0.0
#define FAC 2.5e-7  /* 1/MBIG */
#define MASIZE 55

static int idum = -1;
static int ran3inext, ran3extp;
static double ran3ma[MASIZE];

/*
 * Initialize the storage for the random generator
 * and randomize based on system time.
 */
randomize()
{
    struct sgtbuf timebuf;

    idum = -1;
    getime(&timebuf);
    if (timebuf.t_year != 0) {
        idum = -timebuf.t_hour * 1330 + timebuf.t_minute * 30 + timebuf.t_second;
    }
}



/* Returns a random number between 0.0 <= x < 1.0 */
double drand()
{

  /*
   * MBIG=1000000000;MSEED=161803398;MZ=0;FAC=1.0e-9;
   * long int mj,mk;
   */

    int i,ii,k;
    double mj,mk;

    if (idum < 0) {
        mj = MSEED + idum;
        if (mj >= 0.0) {
           mj = mj - MBIG * (int) (mj/MBIG);
        } else {
             mj = MBIG - abs(mj) + MBIG * (int) (abs(mj)/MBIG);
  /*         mj = mj % MBIG; */
        }
        ran3ma[54] = mj;
        mk = 1;
        for (i = 0; i < 54; i++) {
            ii = 21 * i % MASIZE;
            ran3ma[ii] = mk;
            mk = mj - mk;
            if (mk < MZ) mk = mk + MBIG;
            mj = ran3ma[ii];
        }
        for (k = 0; k < 4; k++) {
             for (i = 0; i < MASIZE; i++) {
                  ran3ma[i] = ran3ma[i] - ran3ma[((i+30) % MASIZE)];
                  if (ran3ma[i] < MZ) {
                      ran3ma[i] = ran3ma[i] + MBIG;
                  }
              }
        }
        ran3inext = -1;
        ran3extp = 31;
        idum = 1;
    }

    ran3inext = ran3inext + 1;
    if (ran3inext == MASIZE) {
        ran3inext = 0;
    }
    ran3extp = ran3extp + 1;
    if (ran3extp == MASIZE) {
        ran3extp = 0;
    }

    mj = ran3ma[ran3inext] - ran3ma[ran3extp];
    if (mj < MZ) {
        mj = mj + MBIG;
    }
    ran3ma[ran3inext] = mj;

    return mj * FAC;
}

int irand(maxval)
    int maxval;
{
    return (int) (drand() * maxval);
}
