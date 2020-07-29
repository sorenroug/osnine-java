/* atob
 * stream filter to change printable ascii from "btoa" back into 8 bit bytes
 * if bad chars, or Csums do not match: exit(1) [and NO output]
 *
 * Paul Rutter Joe Orost
 *
 * 7/29/90: added input and output file handling so to run on VMS, DOS, etc
 *          add TMPDIR to handle tempory files.
 *          VMS doesn't support unlink, so add a dummy one.
 *           --kang sun (sun@robios.eng.yale.edu)
 */

#include <stdio.h>

#define reg register

#define streq(s0, s1)  strcmp(s0, s1) == 0

#define times85(x)	((((((x<<2)+x)<<2)+x)<<2)+x)

#define TMPDIR ""

FILE *fip, *fop; /* pointer to input and output file */

long int Ceor = 0;
long int Csum = 0;
long int Crot = 0;
long int word = 0;
long int bcount = 0;

fatal() {
  fprintf(stderr, "bad format or Csum to atob\n");
  exit(1);
}

#define DE(c) ((c) - '!')

decode(c) reg c;
{
  if (c == 'z') {
    if (bcount != 0) {
      fatal();
    } 
    else {
      byteout(0);
      byteout(0);
      byteout(0);
      byteout(0);
    }
  } 
  else if ((c >= '!') && (c < ('!' + 85))) {
    if (bcount == 0) {
      word = DE(c);
      ++bcount;
    } 
    else if (bcount < 4) {
      word = times85(word);
      word += DE(c);
      ++bcount;
    } 
    else {
      word = times85(word) + DE(c);
      byteout((int)((word >> 24) & 255));
      byteout((int)((word >> 16) & 255));
      byteout((int)((word >> 8) & 255));
      byteout((int)(word & 255));
      word = 0;
      bcount = 0;
    }
  } 
  else {
    fatal();
  }
}

FILE *tmp_file;

byteout(c) reg c;
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
  putc(c, tmp_file);
}

main(argc, argv) int argc; char **argv;
{
  reg c;
  reg long int i;
  char tmp_name[100];
  char buf[100];
  long int n1, n2, oeor, osum, orot;

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
    printf("\tUsage: atob [file1 [file2]]\n");
    break;
  }

  sprintf(tmp_name, "%satob.tmp", TMPDIR);
  tmp_file = fopen(tmp_name, "w+");
  if (tmp_file == NULL) {
    fatal();
  }

  /*search for header line*/
  for (;;) {
    if (fgets(buf, sizeof buf, fip) == NULL) {
      fatal();
    }
    if (streq(buf, "xbtoa Begin\n")) {
      break;
    }
  }

  while ((c = getc(fip)) != EOF) {
    if (c == '\n') {
      continue;
    } 
    else if (c == 'x') {
      break;
    } 
    else {
      decode(c);
    }
  }
  if (fscanf(fip,"btoa End N %ld %lx E %lx S %lx R %lx\n", &n1, &n2, &oeor, &osum, &orot) != 5) {
    fatal();
  }
  if ((n1 != n2) || (oeor != Ceor) || (osum != Csum) || (orot != Crot)) {
    fatal();
  } 
  else {
    /* Now that we know everything is OK, copy tmp file to fop */
    fseek(tmp_file, 0L, 0);
    for (i = n1; --i >= 0;) {
      putc(getc(tmp_file),fop);
    }
  }

  switch(argc) { /* close all the open files */
  case 3: fclose(fop);
  case 2: fclose(fip);
  default: break;
  }

  fclose(tmp_file);
  unlink(tmp_name); /* Make file disappear */

  exit(0);
}

