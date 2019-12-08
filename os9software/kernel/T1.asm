 nam T1
 ttl Device Descriptor for terminal

 use defsfile

**************************
*  TERMINAL device module

 mod TrmEnd,TrmNam,DEVIC+OBJCT,REENT+1,TrmMgr,TrmDrv
 fcb UPDAT. mode
 fcb $F port bank
 fdb A.T1 port address
 fcb TrmNam-*-1 option byte count
 fcb DT.SCF Device Type: SCF

* DEFAULT PARAMETERS

 fcb 0 case=UPPER and lower
 fcb 1 backspace=BS,SP,BS
 fcb 0 delete=backspace over line
 fcb 1 auto echo on
 fcb 1 auto line feed on
 fcb 0 null count
 fcb 1 end of page pause on
 fcb 24 lines per page
 fcb C$BSP backspace char
 fcb C$DEL delete line char
 fcb C$CR end of record char
 fcb C$EOF end of file char
 fcb C$RPRT reprint line char
 fcb C$RPET dup last line char
 fcb C$PAUS pause char
 fcb C$INTR Keyboard Interrupt char
 fcb $11 Keyboard Quit char
 fcb C$BSP backspace echo char
 fcb C$BELL line overflow char
 fcb A.T.init ACIA initialization
 fcb 0 reserved
 fdb TrmNam offset of echo device
 fcb 0 Transmit Enable char
 fcb 0 Transmit Disable char
TrmNam fcs "T1" device name
TrmMgr fcs "SCF"  file manager
TrmDrv fcs "ACIA" device driver

 emod Module CRC

TrmEnd EQU *

