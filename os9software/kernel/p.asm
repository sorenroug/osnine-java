 nam P
 ttl Device Descriptor for "P" (parallel printer)



************************************************************
*
*     P Module, SCF/PIA device
*

 use defsfile

 mod PRTEND,PRTNAM,DEVIC+OBJCT,1,PRTMGR,PRTDRV
 fcb Updat. mode
 fcb $F port bank
 fdb A.P port address
 fcb PRTNAM-*-1 option byte count
 fcb DT.SCF Device Type: SCF

* Default path options

 fcb 0 case=UPPER and lower
 fcb 0 backspace=BS char only
 fcb 1 delete=CRLF
 fcb 0 no auto echo
 fcb 1 auto line feed on
 fcb 0 no nulls after CR
 fcb 0 no page pause
 fcb 66 lines per page
 fcb 0 no backspace char
 fcb 0 no delete line char
 fcb C$CR end of record char
 fcb C$EOF end of file char
 fcb 0 no reprint line char
 fcb 0 no dup last line char
 fcb 0 no pause char
 fcb 0 no abort character
 fcb 0 no interrupt character
 fcb '_ backspace echo char
 fcb 0 no line overflow char
 ifeq PIAType-REGULAR
 fcb $3E PIA type normal
 else
 fcb $7E PIA type swt mp-l2
 endc
 fcb 0 undefined baud rate
 fdb 0 no echo device
PRTNAM fcs "P" device name
 fcs "0" spare byte for P name change
PRTMGR fcs "SCF" file manager
PRTDRV fcs "PIA" driver

 emod

PRTEND EQU *

