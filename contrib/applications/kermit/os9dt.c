/* dterm.c */
/* dumb terminal program by Robert A. Larson */
/* designed to capture kermit for better file transfer */

/* use: dterm device [filename]... */
/* where device is the device to use, i.e. /t2 */
/* files greater than MAXCAPTURE characters will cause problems without warning */
/* FLAG is a rarly used character, (^J) used to give commands to dterm */
/* FLAG b will begin the file capture */
/* FLAG e will end the file capture and write the file "captured" to the disk */
/* FLAG c will exit dterm */
/* FLAG FLAG will send itself */

#define MAXCAPTURE 40000 /* maximum size of file to capture */
#define FLAG 10
#define LF 10

#include <sgstat.h>

main(argc,argv)
int argc;
char **argv;
{
  char c;
  int pn, pnc;
  struct sgbuf sgold, sgnew;
  int capture;
  static char buf[MAXCAPTURE];
  char *bufp;
  argc-=2;
  pn=open(*++argv,3);
  getstat(0,0,&sgold); /* save status */
  /* set stdin to not treat anything specially */
  getstat(0,0,&sgnew);
  sgnew.sg_backsp=0;
  sgnew.sg_delete=0;
  sgnew.sg_echo=0;
  sgnew.sg_alf=0;
  sgnew.sg_pause=0;
  sgnew.sg_bspch=0;
  sgnew.sg_dlnch=0;
  sgnew.sg_psch=0;
  sgnew.sg_kbich=0;
  sgnew.sg_kbach=0;
  sgnew.sg_bsech=0;
  setstat(0,0,&sgnew);
  capture=0;
  bufp=&buf[0];
  for(;;){
    if(!getstat(1,pn)){
      read(pn,&c,1);
      c &= 0177;
      if(c && capture && (c!=LF)) *bufp++=c;
      write(1,&c,1);
    }
    if(!getstat(1,0)){
      read(0,&c,1);
      c &= 0177;
      if(c==FLAG){
        read(0,&c,1);
        c &= 0177;
        if(c=='c')break;
        if(c=='b' && argc){
          --argc;
          pnc=creat(*++argv,3);
          capture=1;
          continue;
        }
        if(c=='e'){
          capture=0;
          write(pnc,&buf[0],bufp-&buf[0]);
          close(pnc);
          continue;
        }
      }
      write(pn,&c,1);
    }
  }
  close(pn);
  setstat(0,0,&sgold);
}
