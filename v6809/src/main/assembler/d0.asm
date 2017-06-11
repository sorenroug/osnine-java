********************************************************************
* progname - program module
*
* $Id: d0.asm,v 1.2 2002/04/21 21:46:22 roug Exp $
*
* Ed.    Comments                                       Who YY/MM/DD
* ------------------------------------------------------------------
*  -     Original Dragon Data distribution version
*
* $Log: d0.asm,v $
*

         nam   D0
         ttl   40-track floppy disk device descriptor

         ifp1
         use   os9defs
         endc
tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $FF extended controller address
         fdb   $FF40  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $01 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 drive number
         fcb   $00 step rate
         fcb   $20 drive device type
         fcb   $01 media density:0=single,1=double
         fdb   $0028 number of cylinders (tracks)
         fcb   $01 number of sides
         fcb   $00 verify disk writes:0=on
         fdb   $0012 # of sectors per track
         fdb   $0012 # of sectors per track (track 0)
         fcb   $02 sector interleave factor
         fcb   $08 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /D0/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /DDisk/
         emod
eom      equ   *
