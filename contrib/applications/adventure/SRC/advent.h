#define TRUE 1
#define FALSE 0
#include <errno.h>

#ifdef LNX
#define direct
#endif
/*
**     Object definitions
*/
#define  KEYS       1
#define  LAMP       2
#define  GRATE      3
#define  CAGE       4
#define  ROD        5
#define  ROD2       6
#define  STEPS      7
#define  BIRD       8
#define  DOOR       9
#define  PILLOW     10
#define  SNAKE      11
#define  FISSURE    12
#define  TABLET     13
#define  CLAM       14
#define  OYSTER     15
#define  MAGAZINE   16
#define  DWARF      17
#define  KNIFE      18
#define  FOOD       19
#define  BOTTLE     20
#define  WATER      21
#define  OIL        22
#define  MIRROR     23
#define  PLANT      24
#define  PLANT2     25
#define  AXE        28
#define  DRAGON     31
#define  CHASM      32
#define  TROLL      33
#define  TROLL2     34
#define  BEAR       35
#define  MESSAGE    36
#define  VEND       38
#define  BATTERIES  39
#define  NUGGET     50
#define  COINS      54
#define  CHEST      55
#define  EGGS       56
#define  TRIDENT    57
#define  VASE       58
#define  EMERALD    59
#define  PYRAMID    60
#define  PEARL      61
#define  RUG        62
#define  SPICES     63
#define  CHAIN      64
/*page*/
/*
**      Verb definitions
*/
#define  NULLX      21
#define  BACK       8
#define  LOOK       57
#define  CAVE       67
#define  ENTRANCE   64
#define  DEPRESSION 63
/*
**      Action verb definitions
*/
#define  TAKE       1
#define  DROP       2
#define  SAY        3
#define  OPEN       4
#define  NOTHING    5
#define  LOCK       6
#define  ON         7
#define  OFF        8
#define  WAVE       9
#define  CALM       10
#define  WALK       11
#define  KILL       12
#define  POUR       13
#define  EAT        14
#define  DRINK      15
#define  RUB        16
#define  THROW      17
#define  QUIT       18
#define  FIND       19
#define  INVENTORY  20
#define  FEED       21
#define  FILL       22
#define  BLAST      23
#define  SCORE      24
#define  FOO        25
#define  BRIEF      26
#define  READ       27
#define  BREAK      28
#define  WAKE       29
#define  SUSPEND    30
#define  HOURS      31
#define  LOG        32
/*page*/
/*
**     Bits of array cond
**     indicating location status
*/
#define  LIGHT      1
#define  WATOIL     2
#define  LIQUID     4
#define  NOPIRAT    8
#define  HINTC      16
#define  HINTB      32
#define  HINTS      64
#define  HINTM      128
#define  HINTD      256
#define  HINTW      512
#define  HINT       HINTC+HINTB+HINTS+HINTM+HINTD+HINTW
/*
**  general constants
*/
#define  PIRATE     6                               /* special dwarf */
#define  MAXLOC     150
#define  MAXOBJ     100
#define  WORDSIZE   20
#define  MAXTRAV    20
#define  DWARFMAX   7
#define  MAXDIE     3
#define  MAXTRS     79
#define  MAXVFAST   1600
#define  MAXVVAL    300
/*
** word types
*/
#define  MOTION     0
#define  OBJECT     1
#define  ACTVERB    2
#define  SPLVERB    3
/*
** debug constants
*/
#define  SHOTURN    1
#define  SHOLOC     2
#define  SHOMOV     4
#define  SHOTRAV    8
/*page*/
#include <stdio.h>
#include <ctype.h>
#ifdef MAIN
#define QQ
#else
#define QQ  extern
#endif
/*
**     English variables
*/
QQ direct int  verb, object, motion;
/*
        Play variables
*/
#ifdef MAIN
direct int  turns = 0;                             /* turns counter */
direct int  loc = 1;                          /* location variables */
direct int  oldloc = 1;
direct int  oldloc2 = 1;
direct int  newloc = 1;
direct int  tally = 15;               /* count of unfound treasures */
direct int  tally2 = 0;                  /* count of lost treasures */
direct int  limit = 330;                              /* time limit */
direct int  lmwarn = 0;                        /* lamp warning flag */
direct char wzdark = 0;                     /* if last loc was dark */
direct char closing = 0;                 /* if stage one of closing */
direct char closed = 0;                  /* if stage two of closing */
direct int  holding = 0;                     /* count of held items */
direct int  detail = 0;                               /* LOOK count */
direct int  knfloc = 0;                           /* knife location */
direct int  clockx = 30;      /* turns from last treasure till close */
direct int  clock2 = 50;     /* turns from final warinig till flash */
direct int  panic = 0;                         /* if he has paniced */
direct char dflag = 0;                                /* dwarf flag */
direct int  daltloc = 18;                   /* alternate appearance */
direct char dkill = 0;                            /* dwarves killed */
direct int  chloc = 114;                          /* chest location */
direct int  chloc2 = 140;               /* alternate chest location */
direct int  bonus = 0;                            /* to pass to end */
direct int  numdie = 0;                         /* number of deaths */
direct int  object1 = 0;                        /* to help intrans. */
direct char gaveup = 0;                       /* 1 if he quit early */
direct int  foobar = 0;                       /* fie fie foe foo... */
direct char saveflg = 0;                     /* if game being saved */
direct char dbgflg = 0;                    /* if game is in restart */
direct unsigned savday = 0;                   /* when game was saved */
direct unsigned savtime = 0;
/*endglobal*/
/*page*/
#else
extern direct int  turns;
extern direct int  loc;
extern direct int  oldloc;
extern direct int  oldloc2;
extern direct int  newloc;
extern direct int  tally;
extern direct int  tally2;
extern direct int  limit;
extern direct int  lmwarn;
extern direct char wzdark;
extern direct char closing;
extern direct char closed;
extern direct int  holding;
extern direct int  detail;
extern direct int  knfloc;
extern direct int  clockx;
extern direct int  clock2;
extern direct int  panic;
extern direct char dflag;
extern direct int  daltloc;
extern direct char dkill;
extern direct int  chloc;
extern direct int  chloc2;
extern direct int  bonus;
extern direct int  numdie;
extern direct int  object1;
extern direct char gaveup;
extern direct int  foobar;
extern direct char saveflg;
extern direct char dbgflg;
extern direct unsigned savday, savtime;
extern direct int  lastsimp;
/*endglobal*/
#endif
#define  BLK1SIZ  56         /* don't know any way but to count them */
/*page*/
/* array variables */
#ifdef MAIN
int  cond[MAXLOC] =                              /* location status */
   {0,5,1,5,5,1,1,5,17,1,0,0,0,32,0,0,2,0,0,64,
    2,2,2,0,6,0,2,0,0,0,0,2,2,0,0,0,0,0,4,0,
    2,0,128,128,128,128,136,136,136,128,128,0,128,136,128,136,0,8,0,2,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    128,128,136,0,0,8,136,0,0,2,2,0,0,0,0,4,0,0,0,256,
    257,256,0,0,0,0,0,0,512,0,0,0,0,4,0,1,1,0,0,0,
    0,0,8,8,8,8,9,8,8,8,8};
int  place[MAXOBJ] =                             /* object location */
   {0,3,3,8,10,11,0,14,13,94,96,19,17,101,103,0,106,0,0,3,
    3,0,0,109,25,23,111,35,0,97,0,119,117,117,0,130,0,126,140,0,
    96,0,0,0,0,0,0,0,0,0,18,27,28,29,30,0,92,95,97,100,
    101,0,119,127,130};
int  fixed[MAXOBJ] =                           /* second object loc */
   {0,0,0,9,0,0,0,15,0,-1,0,-1,27,-1,0,0,0,-1,0,0,
    0,0,0,-1,-1,67,-1,110,0,-1,-1,121,122,122,0,-1,-1,-1,-1,0,
    -1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,121,0,-1};
int  dloc[DWARFMAX] = {0,19,27,33,44,64,114};    /* dwarf locations */
char dseen[DWARFMAX] = {0,0,0,0,0,0,0};          /* dwarf seen flag */
int  odloc[DWARFMAX] = {0,0,0,0,0,0,0};      /* dwarf old locations */
#else
extern int  cond[MAXLOC];
extern int  place[MAXOBJ];
extern int  fixed[MAXOBJ];
extern int  dloc[DWARFMAX];
extern char dseen[DWARFMAX];
extern int  odloc[DWARFMAX];
#endif
#define  BLK2SIZ  MAXLOC*2+MAXOBJ*4+DWARFMAX*5    /* still  counting */
/*page*/
QQ char visited[MAXLOC];                     /* >0 if has been here */
QQ int  prop[MAXOBJ];                           /* status of object */
#define  BLK3SIZ  MAXLOC+MAXOBJ*2
QQ unsigned day, timex;         /* place to put current date and time */
QQ FILE *fd[7];
struct trav {
        int tdest;
        int tverb;
        int tcond;
   } ;
QQ struct trav  travel[MAXTRAV];
#ifdef MAIN
int  actmsg[32] =                                /* action messages */
   {0,24,29,0,33,0,33,38,38,42,14,43,110,29,110,73,75,29,13,59,
    59,174,109,67,13,147,155,195,146,110,13,13};
#else
extern int  actmsg[32];
#endif
QQ long idx1[MAXLOC/10];
QQ long idx2[MAXLOC/10];
QQ long idx3[MAXLOC/10];
QQ long idx6[30];
QQ char fastverb[MAXVFAST];
QQ int  fastvval[MAXVVAL];
QQ long fastvseek;
QQ char word1[WORDSIZE], word2[WORDSIZE];
