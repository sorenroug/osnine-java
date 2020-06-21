         nam   H0
         ttl   os9 device descriptor

* 19 Mbyte 5" Winchester

         ifp1
         use   defsfile
         endc
tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $0F extended controller address
         fdb   $E3B8  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $01 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 drive number
         fcb   $02 step rate
         fcb   $81 drive device type
         fcb   $00 media density:0=single,1=double
         fdb   $0132 number of cylinders (tracks)
         fcb   $06 number of sides
         fcb   $00 verify disk writes:0=on
         fdb   $0020 # of sectors per track
         fdb   $0020 # of sectors per track (track 0)
         fcb   $13 sector interleave factor
         fcb   $08 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /H0/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /XBC/
         emod
eom      equ   *
