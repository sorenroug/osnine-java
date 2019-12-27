         nam term
         use os9defs
         use SCFDefs
         ttl Device Descriptor for the Serial Port

***************
* /term module - serial port
* for use as a terminal port.
*
***************

Type     set DEVIC+OBJCT
Revs     set REENT+1

         mod TermEnd,TermNam,Type,Revs,TermMgr,TermDrv
         fcb UPDAT. attributes
         fcb $FF high byte of 24-bit address
         fdb $FF04 port address
         fcb DD.Parms-*-1 option byte count
OptStrt  fcb DT.SCF SCF type device

* Default path options

         fcb 0 case=UPPER and lower
         fcb 1 backspace=BS,SP,BS
         fcb 0 delete=backspace over line
         fcb false      auto echo ON
         fcb true auto line feed ON
         fcb 0 number of NULLS after CR
         fcb false end of page pause OFF
         fcb 24 lines per page
         fcb C$BSP backspace key
         fcb C$DEL delete line key
         fcb C$CR end of record key
         fcb C$EOF end of file key
         fcb C$RPRT redisplay the line
         fcb C$RPET repeat the line
         fcb C$PAUS pause key
         fcb C$INTR Keyboard Interrupt key
         fcb C$QUIT Keyboard Quit key
         fcb C$BSP backspace echo character
         fcb C$BELL line overflow character
         fcb 0 no parity specified
         fcb 3 baud rate = 1200
         fdb TermNam offset to pause device name
         fcb $11 XON
         fcb $13 XOFF
DD.Parms equ *

TermNam    fcs 'Term' device name
TermMgr    fcs 'scf' file manager
TermDrv    fcs 'acia51' device driver

         emod

TermEnd    equ *

         end

