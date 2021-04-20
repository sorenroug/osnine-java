         nam   MD0
         ttl   os9 device descriptor

* Disassembled 21/04/19 21:13:23 by Disasm v1.5 (C) 1988 by RML

         ifp1
         use   /dd/defs/os9defs
         endc
tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $0A extended controller address
         fdb   $8000  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $01 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 drive number
         fcb   $01 step rate
         fcb   $00 drive device type
         fcb   $00 media density:0=single,1=double
         fdb   $0023 number of cylinders (tracks)
         fcb   $01 number of sides
         fcb   $01 verify disk writes:0=on
         fdb   $000A # of sectors per track
         fdb   $000A # of sectors per track (track 0)
         fcb   $00 sector interleave factor
         fcb   $08 minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /MD0/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /Disk/
         emod
eom      equ   *
