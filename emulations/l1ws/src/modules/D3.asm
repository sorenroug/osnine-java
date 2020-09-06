********************************************************************
* disk device descriptor
*
         nam   D3
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
         fdb   $FFD1  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   1 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   3 drive number
         fcb   0 step rate
         fcb   $20 drive device type
         fcb   1 media density:0=single,1=double
         fdb   40 number of cylinders (tracks)
         fcb   1 number of sides
         fcb   0 verify disk writes:0=on
         fdb   18 # of sectors per track
         fdb   18 # of sectors per track (track 0)
         fcb   2 sector interleave factor
         fcb   8 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /D3/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /VDisk/
         emod
eom      equ   *
