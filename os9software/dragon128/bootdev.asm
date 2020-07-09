         nam   bootdev
         ttl   os9 device descriptor

 use defsfile

tylg     set   Devic+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $0F extended controller address
         fdb   $FCE0  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $01 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 drive number
         fcb   $03 step rate
         fcb   $00 drive device type
         fcb   $01 media density:0=single,1=double
         fdb   $0028 number of cylinders (tracks)
         fcb   $02 number of sides
         fcb   $00 verify disk writes:0=on
         fdb   $0010 # of sectors per track
         fdb   $000A # of sectors per track (track 0)
         fcb   $04 sector interleave factor
         fcb   $08 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /bootdev/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /wd2797/
         emod
eom      equ   *
