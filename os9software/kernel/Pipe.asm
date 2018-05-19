         nam   Pipe
         ttl   os9 device descriptor

         ifp1
         use   os9defs
         endc
tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $03 mode byte
         fcb   $00 extended controller address
         fdb   $0000  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $02 device type:0=scf,1=rbf,2=pipe,3=scf
initsize equ   *
name     equ   *
         fcs   /Pipe/
mgrnam   equ   *
         fcs   /PipeMan/
drvnam   equ   *
         fcs   /Piper/
         emod
eom      equ   *
