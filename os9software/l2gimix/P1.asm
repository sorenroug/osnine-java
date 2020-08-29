 nam   P1
 ttl   os9 device descriptor


 use defsfile

**********
*  P module - Serial Printer
*
 mod PSEND,PSNAM,DEVIC+OBJCT,REENT+1,PSMGR,PSDRV
 fcb UPDAT. mode
 fcb IOBlock/DAT.BlCt port bank
 fdb A.P1 port address
 fcb PSNAM-*-1 option byte count
 fcb DT.SCF Device Type: SCF

* Default path options

 fcb 0 case=UPPER and lower
 fcb 0 backspace:0=bsp,1=bsp then sp & bsp
 fcb 1 delete:0=bsp over line,1=return
 fcb 0 no auto echo
 fcb 1 auto line feed
 fcb 0 end of line null count
 fcb 0 no end of page pause
 fcb 66 lines per page
 fcb 0 no backspace char
 fcb 0 no delete line char
 fcb C$CR end of record character
 fcb C$EOF end of file character
 fcb 0 no reprint line character
 fcb 0 no  duplicate last line character
 fcb 0 no  pause character
 fcb 0 no  interrupt character
 fcb 0 no  quit character
 fcb 0 no  backspace echo character
 fcb 0 no  line overflow character (bell)
 fcb A.T.init init value for dev ctl reg
 fcb 0 undefined baud rate
 fdb 0 no pause device
 fcb C$XON transmit enable
 fcb C$XOFF transmit disable

PSNAM equ *
 fcs /P1/
PSMGR equ *
 fcs /SCF/
PSDRV equ *
 FCS "ACIA" driver

 emod
PSEND equ *
