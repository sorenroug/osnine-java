 ttl Device Descriptor for terminal

**************************
*  termINAL device module

 mod TrmEnd,TrmNam,DEVIC+OBJCT,REENT+1,TrmMgr,TrmDrv
 fcb UPDAT. mode
 fcb IOBlock/DAT.BlCt port bank
 fdb $FC00 port address -must be in I/O region
 fcb OptEnd-*-1  option byte count
 fcb DT.SCF Device Type: SCF

* DEFAULT PARAMETERS

 fcb 0 case=UPPER and lower
 fcb 1 backspace:0=bsp,1=bsp then sp & bsp
 fcb 0 delete:0=bsp over line,1=return
 fcb 1 echo:0=no echo
 fcb 1 auto line feed:0=off
 fcb 0 end of line null count
 fcb 1 pause:0=no end of page pause
 fcb 24 lines per page
 fcb C$BSP backspace character
 fcb '9+$80 delete line character
 fcb C$CR end of record character
 fcb C$EOF end of file character
 fcb C$RPRT reprint line character
 fcb '7+$80 duplicate last line character
 fcb C$PAUS pause character
 fcb C$INTR interrupt character
 fcb C$QUIT quit character
 fcb C$BSP backspace echo character
 fcb C$BELL line overflow char
 fcb A.T.init ACIA initialization
 fcb 0 reserved
 fdb TrmNam offset of echo device
 fcb C$XON Transmit Enable char
 fcb C$XOFF Transmit Disable char
OptEnd set *
 ifne EXTEND
 fcb 80 number of columns for display
 fcb 0 Has extended editing
 fcb 0 Lead-in character for input
 fcb $1B Lead-in chr for output
 fcb $80+'K Move left code
 fcb $80+'C Move right code
 fcb $80+'4 Move left key
 fcb $80+'6 Move right key
 fcb $80+'* Delete chr under cursor key
 fcb $80+'# Delete to end of line key
 endc
TrmNam fcs "term"
TrmMgr fcs "SCF"
TrmDrv fcs "screen"

 emod Module CRC

TrmEnd set *

Pass set 0
TPort set A.T1
TName set '1
 use txdesc.asm
