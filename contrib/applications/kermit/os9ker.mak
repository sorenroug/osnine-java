* makefile for os9/68k kermit
* 12/05/85 ral
CFILES = os9ker.c os9con.c os9rec.c os9sen.c os9raw.c os9get.c os9qui.c \
         os9srv.c os9utl.c
RFILES = os9ker.r os9con.r os9rec.r os9sen.r os9raw.r os9get.r os9qui.r \
         os9srv.r os9utl.r
kermit: $(RFILES)
  cc $(RFILES) -f=kermit
* QT+ needs nooverlap for floppys, other compilation switches should be
* put on the following cc line, if only the -d compiler option worked.
* (see os9ker.bwr)
$(RFILES): os9inc.h
  cc -r -t=/r0 $*.c
