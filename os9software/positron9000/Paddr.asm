         nam   Paddr
         ttl   os9 device descriptor


 use defsfile

tylg     set   Devic+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
 fcb UPDAT.

         fcb   $0A extended controller address
         fdb   $0000  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $00 device type:0=scf,1=rbf,2=pipe,3=scf
initsize equ   *
name     equ   *
         fcs   /Paddr/
mgrnam   equ   *
         fcs   /SCF/
drvnam   equ   *
         fcs   /PADDER/
         emod
eom      equ   *
