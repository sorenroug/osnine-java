         nam   Term
         use defsfile
         ttl Device Descriptor for the Motorola 6847 chip


tylg     set   Devic+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $03 mode byte
         fcb   $FF extended controller address
         fdb   $C000  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   0 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   1 case:0=up&lower,1=upper only
         fcb   1 backspace:0=bsp,1=bsp then sp & bsp
         fcb   0 delete:0=bsp over line,1=return
         fcb   1 echo:0=no echo
         fcb   1 auto line feed:0=off
         fcb   0 end of line null count
         fcb   1 pause:0=no end of page pause
         fcb   16 lines per page
         fcb   8 backspace character
         fcb   $18 delete line character
         fcb   $0D end of record character
         fcb   $1B end of file character
         fcb   $04 reprint line character
         fcb   $01 duplicate last line character
         fcb   $17 pause character
         fcb   $03 interrupt character
         fcb   $05 quit character
         fcb   $08 backspace echo character
         fcb   $07 line overflow character (bell)
         fcb   0 init value for dev ctl reg
         fcb   0 baud rate
         fdb   name copy of descriptor name address
         fcb   0 acia xon char
         fcb   0 acia xoff char
initsize equ   *

name     equ   *
         fcs   /TERM/
mgrnam   equ   *
         fcs   /SCF/
drvnam   equ   *
         fcs   /KBVDIO/
         emod
eom      equ   *
