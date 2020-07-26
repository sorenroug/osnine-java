 nam TERM
 ttl Device Descriptor for terminal

 use   defsfile

 mod   TrmEnd,TrmNam,DEVIC+OBJCT,REENT+1,mgrnam,drvnam
 fcb UPDAT. mode
 fcb $F extended controller address
 fdb A.TERM port address
 fcb   initsize-*-1  initilization table size
 fcb   $00 device type:0=scf,1=rbf,2=pipe,3=scf

* DEFAULT PARAMETERS

 fcb   0 case:0=up&lower,1=upper only
 fcb   1 backspace:0=bsp,1=bsp then sp & bsp
 fcb   0 delete:0=bsp over line,1=return
 fcb   1 echo:0=no echo
 fcb   1 auto line feed:0=off
 fcb   0 end of line null count
 fcb   1 pause:0=no end of page pause
 fcb   24 lines per page
 fcb   C$BSP backspace character
 fcb   C$DEL delete line character
 fcb   $0D end of record character
 fcb   $1B end of file character
 fcb   $04 reprint line character
 fcb   C$RPET duplicate last line character
 fcb   C$PAUS pause character
 fcb   $03 interrupt character
 fcb   $05 quit character
 fcb   $08 backspace echo character
 fcb C$BELL line overflow char
 fcb A.T.init ACIA initialization
 fcb   $00 baud rate
 fdb   TrmNam copy of descriptor name address
 fcb   $11 acia xon char
 fcb   $13 acia xoff char
 fcb   80 number of columns for display
 fcb   $00   No-edit flag?
initsize equ   *
 fcb   $00 Lead-in character for input
 fcb   $1B Lead-in character for output
 fcb   $CB Move left code
 fcb   $C3 Move right code
 fcb   $B4 Move left key
 fcb   $B6 Move right key
 fcb   $AA Delete chr under cursor key
 fcb   $A3 Delete to end of line key

TrmNam fcs /Term/
mgrnam fcs /SCF/
drvnam fcs /ACIA/
 emod
TrmEnd equ *
