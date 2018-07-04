/*
** VERB.C 
*/
#include "advent.h"
/*
**   Routine to process a transitive verb
*/
trverb()
   {
   switch (verb)
      {
      case CALM:
      case WALK:
      case QUIT:
      case SCORE:
      case FOO:
      case BRIEF:
      case SUSPEND:
      case HOURS:
         actspk(verb);
         break;
      case TAKE:
         vtake();
         break;
      case DROP:
         vdrop();
         break;
      case OPEN:
      case LOCK:
         vopen();
         break;
      case SAY:
         vsay();
         break;
      case NOTHING:
         rspeak(54);                                         /* "OK" */
         break;
      case ON:
         von();
         break;
      case OFF:
         voff();
         break;
      case WAVE:
         vwave();
         break;
      case KILL:
         vkill();
         break;
      case POUR:
         vpour();
         break;
      case EAT:
         veat();
         break;
      case DRINK:
         vdrink();
         break;
      case RUB:
         if (object != LAMP)
               rspeak(76);                      /* "nothing happens" */
            else
               actspk(RUB);
         break;
      case THROW:
         vthrow();
         break;
      case FEED:
         vfeed();
         break;
      case FIND:
      case INVENTORY:
         vfind();
         break;
      case FILL:
         vfill();
         break;
      case READ:
         vread();
         break;
      case BLAST:
         vblast();
         break;
      case BREAK:
         vbreak();
         break;
      case WAKE:
         vwake();
         break;
      default:
         printf("This verb is not implemented yet.\n");
      }
   }
/*
**   CARRY TAKE etc.
*/
vtake()
   {
   int msg;
   int i;
   if (toting(object))
         {
         actspk(verb);
         return;
         }
   /*
   special case objects and fixed objects
   */
   msg = 25;                               /* "you can't be serious" */
   if (object == PLANT && prop[PLANT] <= 0)
         msg = 115;                              /* "cant get plant" */
   if (object == BEAR && prop[BEAR] == 1)
         msg = 169;                     /* "bear is chained to wall" */
   if (object == CHAIN && prop[BEAR] != 0)
         msg = 170;                       /* "chain is still locked" */
   if (fixed[object])
         {
         rspeak(msg);
         return;
         }
   /*
   special case for liquids
   */
   if (object == WATER || object == OIL)
         {
         if (!here(BOTTLE) || liq() != object)
               {
               object = BOTTLE;
               if (toting(BOTTLE) && prop[BOTTLE] == 1)
                     {
                     vfill();
                     return;
                     }
               if (prop[BOTTLE] != 1)
                     msg = 105;                  /* "bottle is full" */
               if (!toting(BOTTLE))
                     msg = 104;        /* "nothing to carry it with" */
               rspeak(msg);
               return;
               }
         object = BOTTLE;
         }
   if (holding >= 7)
         {
         rspeak(92);                           /* "can't carry more" */
         return;
         }
   /*
   special case for bird.
   */
   if (object == BIRD && prop[BIRD] == 0)
         {
         if (toting(ROD))
               {
               rspeak(26);                       /* "bird is scared" */
               return;
               }
         if (!toting(CAGE))
               {
               rspeak(27);           /* "can catch, but can't carry" */
               return;
               }
         prop[BIRD] = 1;
         }
   if ((object == BIRD || object == CAGE) && prop[BIRD] != 0)
         carry((BIRD + CAGE) - object);
   carry(object);
   /*
   handle liquid in bottle
   */
   i = liq();
   if (object == BOTTLE && i != 0)
         place[i] = -1;
   rspeak(54);                                               /* "OK" */
   }
/*
**   DROP etc.
*/
vdrop()
   {
   int i;
   /*
   check for dynamite
   */
   if (toting(ROD2) && object == ROD && !toting(ROD))
         object = ROD2;
   if (!toting(object))
         {
         actspk(verb);
         return;
         }
   /*
   snake and bird
   */
   if (object == BIRD && here(SNAKE))
         {
         rspeak(30);                     /* "bird chases snake away" */
         if (closed)
               dwarfend();
         dstroy(SNAKE);
         prop[SNAKE] = -1;
         }
      else         /* coins and vending machine */
         if (object == COINS && here(VEND))
               {
               dstroy(COINS);
               drop(BATTERIES, loc);
               pspeak(BATTERIES, 0);
               return;
               }
            else        /* bird and dragon */
               if (object == BIRD && at(DRAGON) && prop[DRAGON] == 0)
                     {
                     rspeak(154);              /* "bird gets killed" */
                     dstroy(BIRD);
                     prop[BIRD] = 0;
                     if (place[SNAKE] != 0)
                           ++tally2;
                     return;
                     }
   if (object == BEAR && at(TROLL))  /* bear and troll */
         {
         rspeak(163);                         /* "bear chases troll" */
         move(TROLL, 0);
         move((TROLL + MAXOBJ), 0);
         move(TROLL2, 117);
         move((TROLL2 + MAXOBJ), 122);
         juggle(CHASM);
         prop[TROLL] = 2;
         }
      else         /* vase */
         if (object == VASE)
               {
               if (loc == 96)
                     rspeak(54);                             /* "OK" */
                  else
                     {
                     prop[VASE] = at(PILLOW) ? 0 : 2;
                     pspeak(VASE, prop[VASE] + 1);
                     if (prop[VASE] != 0)
                           fixed[VASE] = -1;
                     }
               }
   i = liq();         /* liquids and bottle */
   if (i == object)
         object = BOTTLE;
   if (object == BOTTLE && i != 0)
         place[i] = 0;
   if (object == CAGE && prop[BIRD] != 0)  /* bird and cage */
         drop(BIRD, loc);
   if (object == BIRD)
         prop[BIRD] = 0;
   drop(object, loc);
   }
/*
**   LOCK, UNLOCK, OPEN, CLOSE etc.
*/
vopen()
   {
   char oyclam;
   int msg;
   switch (object)
      {
      case CLAM:
      case OYSTER:
         oyclam = (object == OYSTER ? 1 : 0);
         if (verb == LOCK)
               msg = 61;                                  /* "what?" */
            else 
               if (!toting(TRIDENT))
                     msg = 122 + oyclam;      /* "not strong enough" */
                  else 
                     if (toting(object))
                           msg = 120 + oyclam;   /* "put down first" */
                        else
                           {
                           msg = 124 + oyclam;       /* pearl or not */
                           dstroy(CLAM);
                           drop(OYSTER, loc);
                           drop(PEARL, 105);
                           }
         break;
      case DOOR:
         msg = (prop[DOOR] == 1 ? 54 : 111);          /* ok or rusty */
         break;
      case CAGE:
         msg = 32;                               /* "it has no lock" */
         break;
      case KEYS:
         msg = 55;                        /* "can't unlock the keys" */
         break;
      case CHAIN:
         if (!here(KEYS))
               msg = 31;                       /* "you have no keys" */
            else 
               if (verb == LOCK)
                     {
                     if (prop[CHAIN] != 0)
                           msg = 34;      /* "it was already locked" */
                        else 
                           if (loc != 130)
                                 msg = 173;/* nothing to unlock with */
                              else
                                 {
                                 prop[CHAIN] = 2;
                                 if (toting(CHAIN))
                                       drop(CHAIN, loc);
                                 fixed[CHAIN] =  -1;
                                 msg = 172;            /* now locked */
                                 }
                     }
                  else
                     {
                     if (prop[BEAR] == 0)
                           msg = 41;      /* no way to get past bear */
                        else 
                           if (prop[CHAIN] == 0)
                                 msg = 37;       /* already unlocked */
                              else
                                 {
                                 prop[CHAIN] = 0;
                                 fixed[CHAIN] = 0;
                                 if (prop[BEAR] != 3)
                                       prop[BEAR] = 2;
                                 fixed[BEAR] = 2 - prop[BEAR];
                                 msg = 171;          /* now unlocked */
                                 }
                     }
         break;
      case GRATE:
         if (!here(KEYS))
               msg = 31;                         /* you have no keys */
            else 
               if (closing)
                     {
                     if (!panic)
                           {
                           clock2 = 15;
                           ++panic;
                           }
                     msg = 130;     /* exit closed - use main office */
                  }
                  else
                     {
                     msg = 34 + prop[GRATE];   /* locked or unlocked */
                     prop[GRATE] = (verb == LOCK ? 0 : 1);
                     msg += 2 * prop[GRATE];
                     }
         break;
      default:
         msg = 33;       /* dont know to lock or unlock such a thing */
      }
   rspeak(msg);
   }
/*
**   SAY etc.
*/
vsay()
   {
   int wtype, wval;
   analyze(word1, &wtype, &wval);
   printf("Okay.\n%s\n", wval == SAY ? word2 : word1);
   }
/*
**   ON etc.
*/
von()
   {
   if (!here(LAMP))
         actspk(verb);
      else 
         if (limit < 0)
               rspeak(184);                  /* lamp is out of power */
            else
               {
               prop[LAMP] = 1;
               rspeak(39);                         /* lamp is now on */
               if (wzdark)
                     {
                     wzdark = 0;
                     describe();
                     }
               }
   }
/*
**   OFF etc.
*/
voff()
   {
   if (!here(LAMP))
         actspk(verb);
      else
         {
         prop[LAMP] = 0;
         rspeak(40);                              /* lamp is now off */
         }
   }
/*
**   WAVE etc.
*/
vwave()
   {
   if (!toting(object) && (object != ROD || !toting(ROD2)))
         rspeak(29);                       /* you aren't carrying it */
      else 
         if (object != ROD || !at(FISSURE) || !toting(object) || closing)
               actspk(verb);
            else
               {
               prop[FISSURE] = 1 - prop[FISSURE];
               pspeak(FISSURE, 2 - prop[FISSURE]);
               }
   }
/*
   ATTACK, KILL etc.
*/
vkill()
   {
   int msg;
   int i;
   switch (object)
      {
      case BIRD:
         if (closed)
               msg = 137;                    /* leave the bird alone */
            else
               {
               dstroy(BIRD);
               prop[BIRD] = 0;
               if (place[SNAKE] == 19)
                     ++tally2;
               msg = 45;                             /* bird is dead */
               }
         break;
      case 0:
         msg = 44;                         /* nothing here to attack */
         break;
      case CLAM:
      case OYSTER:
         msg = 150;                 /* shell is impervious to attack */
         break;
      case SNAKE:
         msg = 46;                   /* attacking snake doesn't work */
         break;
      case DWARF:
         if (closed)
               dwarfend();
         msg = 49;                                     /* with what? */
         break;
      case TROLL:
         msg = 157;                         /* attack not hurt troll */
         break;
      case BEAR:
         msg = 165 + (prop[BEAR] + 1) / 2;     /* how - freind - etc */
         break;
      case DRAGON:
         if (prop[DRAGON] != 0)
               {
               msg = 167;                            /* already dead */
               break;
               }
         if (!yes(49, 0, 0))
               break;
         pspeak(DRAGON, 1);
         prop[DRAGON] = 2;
         prop[RUG] = 0;
         move((DRAGON + MAXOBJ), -1);
         move((RUG + MAXOBJ), 0);
         move(DRAGON, 120);
         move(RUG, 120);
         for (i = 1; i < MAXOBJ; ++i)
            if (place[i] == 119 || place[i] == 121)
                  move(i, 120);
         newloc = 120;
         return;
      default:
         actspk(verb);
         return;
      }
   rspeak(msg);
   }
/*
**   POUR
*/
vpour()
   {
   if (object == BOTTLE || object == 0)
         object = liq();
   if (object == 0)
         {
         needobj();
         return;
         }
   if (!toting(object))
         {
         actspk(verb);
         return;
         }
   if (object != OIL && object != WATER)
         {
         rspeak(78);                              /* can't pour that */
         return;
         }
   prop[BOTTLE] = 1;
   place[object] = 0;
   if (at(PLANT))
         {
         if (object != WATER)
               rspeak(112);              /* plant doesn't like water */
            else
               {
               pspeak(PLANT, prop[PLANT] + 1);
               prop[PLANT] = (prop[PLANT] + 2) % 6;
               prop[PLANT2] = prop[PLANT] / 2;
               describe();
               }
         }
      else 
         if (at(DOOR))
               {
               prop[DOOR] = (object == OIL ? 1 : 0);
               rspeak(113 + prop[DOOR]);  /* hinges do or don't work */
               }
            else
               rspeak(77);               /* bottle empty, ground wet */
   }
/*
**   EAT
*/
veat()
   {
   int msg;
   switch (object)
      {
      case FOOD:
         dstroy(FOOD);
         msg = 72;                                  /* was delicious */
         break;
      case BIRD: 
      case SNAKE: 
      case CLAM: 
      case OYSTER:
      case DWARF: 
      case DRAGON: 
      case TROLL: 
      case BEAR:
         msg = 71;                             /* just lost appetite */
         break;
      default:
         actspk(verb);
         return;
      }
   rspeak(msg);
   }
/*
**   DRINK
*/
vdrink()
   {
   if (object != WATER)
         rspeak(110);                         /* don't be ridiculous */
      else 
         if (liq() != WATER || !here(BOTTLE))
               actspk(verb);
            else
               {
               prop[BOTTLE] = 1;
               place[WATER] = 0;
               rspeak(74);                    /* bottle is now empty */
               }
   }
/*
**   THROW etc.
*/
vthrow()
   {
   int msg;
   int i;
   if (toting(ROD2) && object == ROD && !toting(ROD))
         object = ROD2;
   if (!toting(object))
         {
         actspk(verb);
         return;
         }
   /*      treasure to troll   */
   if (at(TROLL) && object >= 50 && object < MAXOBJ)
         {
         rspeak(159);        /* troll catches treasure and goes away */
         drop(object, 0);
         move(TROLL, 0);
         move((TROLL + MAXOBJ), 0);
         drop(TROLL2, 117);
         drop((TROLL2 + MAXOBJ), 122);
         juggle(CHASM);
         return;
         }
   /*      feed the bears...   */
   if (object == FOOD && here(BEAR))
         {
         object = BEAR;
         vfeed();
         return;
         }
   /*      if not axe, same as drop...   */
   if (object != AXE)
         {
         vdrop();
         return;
         }
   /*      AXE is THROWN   */
   if (i = dcheck())   /* at a dwarf */
         {
         msg = 48;                            /* dwarf dodges attack */
         if (pct(33))
               {
               dseen[i] = dloc[i] = 0;
               msg = 47;                             /* killed dwarf */
               ++dkill;
               if (dkill == 1)
                     msg = 149;                      /* killed dwarf */
               }
         }
      else    /* at a dragon */
         if (at(DRAGON) && prop[DRAGON] == 0)
               msg = 152;                  /* axe bounces off dragon */
            else   /* at the troll */
               if (at(TROLL))
                     msg = 158;                 /* troll catches axe */
                  else   /* at the bear */
                     if (here(BEAR) && prop[BEAR] == 0)
                           {
                           rspeak(164);                /* axe misses */
                           drop(AXE, loc);
                           fixed[AXE] = -1;
                           prop[AXE] = 1;
                           juggle(BEAR);
                           return;
                           }
                        else  /* it is an attack */
                           {
                           verb = KILL;
                           object = 0;
                           itverb();
                           return;
                           }
   /*      handle the left over axe...   */
   rspeak(msg);
   drop(AXE, loc);
   describe();
   }
/*
**   INVENTORY, FIND etc.
*/
vfind()
   {
   int msg;
   if (toting(object))
         msg = 24;                            /* already carrying it */
      else
         if (closed)
               msg = 138;             /* it is around here somewhere */
            else
               if (dcheck() && dflag >= 2 && object == DWARF)
                     msg = 94;        /* what you want is right here */
                  else 
                     if (at(object) ||
                        (liq() == object && here(BOTTLE)) ||
                        object == liqloc(loc))
                           msg = 94;  /* what you want is right here */
                        else
                           {
                           actspk(verb);
                           return;
                           }
   rspeak(msg);
   }
/*
**   FILL
*/
vfill()
   {
   int msg;
   int i;
   switch (object)
      {
      case BOTTLE:
         if (liq() != 0)
               msg = 105;                  /* bottle is already full */
            else 
               if (liqloc(loc) == 0)
                     msg = 106;         /* nothing here to fill with */
                  else
                     {
                     prop[BOTTLE] = cond[loc] & WATOIL;
                     i = liq();
                     if (toting(BOTTLE))
                           place[i] = -1;
                     msg = (i == OIL ? 108 : 107);/* now have water/oil */
                     }
         break;
      case VASE:
         if (liqloc(loc) == 0)
               {
               msg = 144;           /* nothing here to fill the vase */
               break;
               }
         if (!toting(VASE))
               {
               msg = 29;                   /* you aren't carrying it */
               break;
               }
         rspeak(145);              /* temperature change breaks vase */
         vdrop();
         return;
      default:
         msg = 29;                         /* you aren't carrying it */
      }
   rspeak(msg);
   }
/*
**   FEED
*/
vfeed()
   {
   int msg;
   switch (object)
      {
      case BIRD:
         msg = 100;                              /* it is not hungry */
         break;
      case DWARF:
         if (!here(FOOD))
               {
               actspk(verb);
               return;
               }
         ++dflag;
         msg = 103;                         /* dwarves only eat coal */
         break;
      case BEAR:
         if (!here(FOOD))
               {
               if (prop[BEAR] == 0)
                     msg = 102;      /* nothing here he wants to eat */
                  else
                     if (prop[BEAR] == 3)
                           msg = 110;         /* don't be rigiculous */
                        else
                           {
                           actspk(verb);
                           return;
                           }
               break;
               }
         dstroy(FOOD);
         prop[BEAR] = 1;
         fixed[AXE] = 0;
         prop[AXE] = 0;
         msg = 168;                   /* bear eats and gets friendly */
         break;
      case DRAGON:
         msg = (prop[DRAGON] != 0 ? 110 : 102);   /* silly - not eat */
         break;
      case TROLL:
         msg = 182;                    /* gluttony not vice of troll */
         break;
      case SNAKE:
         if (closed || !here(BIRD))
               {
               msg = 102;                 /* nothing he wants to eat */
               break;
               }
         msg = 101;                               /* snake eats bird */
         dstroy(BIRD);
         prop[BIRD] = 0;
         ++tally2;
         break;
      default:
         msg = 14;                            /* care to explain how */
      }
   rspeak(msg);
   }
/*
**   READ etc.
*/
vread()
   {
   int msg;
   msg = 0;
   if (dark())
         {
         printf("I see no %s here.\n", probj(object));
         return;
         }
   switch (object)
      {
      case MAGAZINE:
         msg = 190;               /* magazine is written in dwarvish */
         break;
      case TABLET:
         msg = 196;          /* you brought light into the dark room */
         break;
      case MESSAGE:
         msg = 191;               /* not the maze where pirate hides */
         break;
      case OYSTER:
         if (!toting(OYSTER) || !closed)
               break;
         yes(192, 193, 54);
         return;
      default:
         ;
      }
   if (msg)
         rspeak(msg);
      else
         actspk(verb);
   }
/*
**   BLAST etc.
*/
vblast()
   {
   if (prop[ROD2] < 0 || !closed)
         actspk(verb);
      else
         {
         bonus = 133;            /* explosion, hole in wall, success */
         if (loc == 115)
               bonus = 134;        /* explosion, hole in wall, lava! */
         if (here(ROD2))
               bonus = 135;      /* explosion, splashed across walls */
         rspeak(bonus);
         normend();
         }
   }
/*
**   BREAK etc.
*/
vbreak()
   {
   int msg;
   if (object == MIRROR)
         {
         msg = 148;                           /* too far up to reach */
         if (closed)
               {
               rspeak(197);                  /* you proke the mirror */
               dwarfend();
               }
         }
      else 
         if (object == VASE && prop[VASE] == 0)
               {
               msg = 198;                        /* have broken vase */
               if (toting(VASE))
                     drop(VASE, loc);
               prop[VASE] = 2;
               fixed[VASE] = -1;
               }
            else
               {
               actspk(verb);
               return;
               }
   rspeak(msg);
   }
/*
**   WAKE etc.
*/
vwake()
   {
   if (object != DWARF || !closed)
         actspk(verb);
      else
         {
         rspeak(199);      /* prod dwarf, who wakes up and grabs axe */
         dwarfend();
         }
   }