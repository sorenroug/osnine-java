/* btoa: version 4.0
 * stream filter to change 8 bit bytes into printable ascii
 * computes the number of bytes, and three kinds of simple checksums
 * incoming bytes are collected into 32-bit words, then printed in base 85
 * exp(85,5) > exp(2,32)
 * the ASCII characters used are between '!' and 'u'
 * 'z' encodes 32-bit zero; 'x' is used to mark the end of encoded data.
 *
 * Paul Rutter Joe Orost
 *
 * 7/29/90: added input and output file handling so to run on VMS, DOS, etc
            --kang sun (sun@robios.eng.yale.edu)
 */

#include <stdio.h>

#define reg register

#define MAXPERLINE 78

long int Ceor = 0;
long int Csum = 0;
long int Crot = 0;

long int ccount = 0;
long int bcount = 0;
long int word;

FILE *fip, *fop; /* pointer to input and output file */

#define EN(c)	(int) ((c) + '!')

encode(c) reg c;
{
  Ceor ^= c;
  Csum += c;
  Csum += 1;
  if ((Crot & 0x80000000)) {
    Crot <<= 1;
    Crot += 1;
  } 
  else {
    Crot <<= 1;
  }
  Crot += c;

  word <<= 8;
  word |= c;
  if (bcount == 3) {
    wordout(word);
    bcount = 0;
  } 
  else {
    bcount += 1;
  }
}

wordout(word) reg long int word;
{
  if (word == 0) {
    charout('z');
  } 
  else {
    reg int tmp = 0;

    if (word < 0)
    { /* Because some don't support unsigned long */
      tmp = 32;
      word = word - (long)(85L * 85 * 85 * 85 * 32);
    }
    if (word < 0) {
      tmp = 64;
      word = word - (long)(85L * 85 * 85 * 85 * 32);
    }
    charout(EN((word / (long)(85L * 85 * 85 * 85)) + tmp));
    word %= (long)(85L * 85 * 85 * 85);
    charout(EN(word / (85L * 85 * 85)));
    word %= (85L * 85 * 85);
    charout(EN(word / (85L * 85)));
    word %= (85L * 85);
    charout(EN(word / 85));
    word %= 85;
    charout(EN(word));
  }
}

charout(c) {
  putc(c,fop);
  ccount += 1;
  if (ccount == MAXPERLINE) {
    putc('\n',fop);
    ccount = 0;
  }
}

main(argc,argv)
int argc;
char **argv;
{
  reg c;
  reg long int n;
  fip = stdin;
  fop = stdout;

  pflinit();

  switch(argc) {
  case 3: /* both in and out file names are given */
    if ((fop=fopen(argv[2],"w"))==NULL) {
      printf("\tCan't open output file - %s\n",argv[2]);
      exit (1);
    }
  case 2: /* only in file name is given */
    if ((fip=fopen(argv[1],"r"))==NULL) {
      printf("\tCan't open input file - %s\n",argv[1]);
      exit (1);
    }
  case 1: /* neither file name is given */
    break;
  default:
    printf("\tUsage: %s [file1 [file2]]\n",argv[0]);
    exit(0);
    break;
  }
    
  fprintf(fop,"xbtoa Begin\n");
  n = 0;
  while ((c = getc(fip)) != EOF) {
    encode(c);
    n += 1;
  }

  while (bcount != 0) {
    encode(0);
  } /* n is written twice as crude cross check*/

  if (ccount == 0);
  /* ccount == 0 means '\n' just written in charout() */
  /* this avoids bug in BITNET, which changes blank line to spaces */
  else putc('\n',fop);

  fprintf(fop,"xbtoa End N %ld %lx E %lx S %lx R %lx\n", n, n, Ceor, Csum, Crot);

  switch(argc) { /* close all the open files */
  case 3: fclose(fop);
  case 2: fclose(fip);
  default: break;
  }

  exit(0);
}
