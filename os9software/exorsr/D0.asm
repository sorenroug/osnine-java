         nam   d0
         ttl   os9 device descriptor

 use defsfile

         mod   eom,name,Devic+Objct,REENT+3,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $FF extended controller address
         fdb   DPORT  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   1 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   0 drive number
         fcb   2 step rate
         fcb   1 drive device type
         fcb   0 media density:0=single,1=double
         fdb   77 number of cylinders (tracks)
         fcb   2 number of sides
         fcb   1 verify disk writes:0=on
         fdb   16 # of sectors per track
         fdb   16 # of sectors per track (track 0)
         fcb   2 sector interleave factor
         fcb   8 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /d0/
mgrnam   equ   *
         fcs   /rbf/
drvnam   equ   *
         fcs   /EXORdisk3/
         emod
eom      equ   *
