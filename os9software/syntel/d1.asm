 nam   d1
 ttl   os9 device descriptor

 use defsfile

tylg     set   Devic+Objct
atrv     set   ReEnt+1

         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   0 extended controller address
         fdb   $C000  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   1 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   1 drive number
         fcb   0 step rate
         fcb   $40 drive device type
         fcb   1 media density:0=single,1=double
         fdb   80 number of cylinders (tracks)
         fcb   1 number of sides
         fcb   1 verify disk writes:0=on
         fdb   16 # of sectors per track
         fdb   16 # of sectors per track (track 0)
         fcb   3 sector interleave factor
         fcb   8 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /d1/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /fcm1/
         emod
eom      equ   *
