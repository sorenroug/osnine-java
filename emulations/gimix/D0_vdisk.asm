********************************************************************
* disk device descriptor
*
         nam   D0
         ttl   80-track floppy disk device descriptor

         ifp1
         use   /D0/DEFS/os9defs
         endc
tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $0F extended controller address
         fdb   $E040  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $01 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 drive number
         fcb   $83 step rate
         fcb   $00 drive device type
         fcb   $03 media density:0=single,1=double
         fdb   80 number of cylinders (tracks)
         fcb   $02 number of sides
         fcb   $00 verify disk writes:0=on
         fdb   16    # of sectors per track
         fdb   10    # of sectors per track (track 0)
         fcb   $02 sector interleave factor
         fcb   $08 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /D0/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /VDisk/
         emod
eom      equ   *
