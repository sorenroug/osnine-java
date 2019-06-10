********************************************************************
* disk device descriptor
*
         nam   D1
         ttl   320-track disk device descriptor

         ifp1
         use   defsfile
         endc
harddisk equ   %10000000
bit5on   equ   %00100000

tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $FF mode byte
         fcb   $FF extended controller address
         fdb   $FF44  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   DT.RBF
         fcb   $00 drive number
         fcb   $00 step rate
         fcb   harddisk+bit5on   drive device type
         fcb   $01               media density:0=single,1=double
         fdb   320               number of cylinders (tracks) 
         fcb   2                 number of sides
         fcb   $00               verify disk writes:0=on
         fdb   96                number of sectors per track
         fdb   96                number of sectors per track (track 0)
         fcb   $02               sector interleave factor
         fcb   $08               minimum size of sector allocation
initsize equ   *
name     equ   *
         fcs   /D1/
mgrnam   equ   *
         fcs   /RBF/
drvnam   equ   *
         fcs   /VDisk/
         emod
eom      equ   *
