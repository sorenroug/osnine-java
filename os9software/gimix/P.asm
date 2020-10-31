 nam   P
 ttl   os9 device descriptor

 use defsfile

tylg     set   Devic+Objct   
atrv     set   $00+rev
rev      set   $01
         mod   eom,name,tylg,atrv,mgrnam,drvnam
         fcb   $03 mode byte
         fcb   $0F extended controller address
         fdb   $E042  physical controller address
         fcb   initsize-*-1  initilization table size
         fcb   $00 device type:0=scf,1=rbf,2=pipe,3=scf
         fcb   $00 case:0=up&lower,1=upper only
         fcb   $00 backspace:0=bsp,1=bsp then sp & bsp
         fcb   $01 delete:0=bsp over line,1=return
         fcb   $00 echo:0=no echo
         fcb   $01 auto line feed:0=off
         fcb   $00 end of line null count
         fcb   $00 pause:0=no end of page pause
         fcb   $42 lines per page
         fcb   $00 backspace character
         fcb   $00 delete line character
         fcb   $0D end of record character
         fcb   $1B end of file character
         fcb   $00 reprint line character
         fcb   $00 duplicate last line character
         fcb   $00 pause character
         fcb   $00 interrupt character
         fcb   $00 quit character
         fcb   $5F backspace echo character
         fcb   $00 line overflow character (bell)
         fcb   $3E init value for dev ctl reg
         fcb   $00 baud rate
         fdb   0   copy of descriptor name address
initsize equ   *

name  fcs  "P"
mgrnam fcs "SCF"
drvnam fcs "PIA"
         emod
eom      equ   *
