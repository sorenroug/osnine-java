         nam t1
         use os9defs
         use SCFDefs
         ttl Device Descriptor for the Serial Port

***************
* /T1 module - serial port
* for use as a terminal port.
*
***************

Type     set DEVIC+OBJCT
Revs     set REENT+1

         mod TermEnd,TermNam,Type,Revs,TermMgr,TermDrv
         fcb UPDAT. attributes
         fcb   $0F extended controller address
         fdb   $FFD6  physical controller address
         fcb DD.Parms-*-1 option byte count
OptStrt  fcb DT.SCF SCF type device

* Default path options

         fcb 0 case=UPPER and lower
         fcb 1 backspace=BS,SP,BS
         fcb 0 delete=backspace over line
         fcb true       auto echo ON
         fcb true       auto line feed ON
         fcb 0 number of NULLS after CR
         fcb true  end of page pause ON
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
         fcb   $15 init value for dev ctl reg
         fcb 0 baud rate
         fdb TermNam offset to pause device name
         fcb   $00 acia xon char
         fcb   $00 acia xoff char
DD.Parms equ *

TermNam    fcs 'T1' device name
TermMgr    fcs 'SCF' file manager
TermDrv    fcs 'ACIA' device driver

         emod

TermEnd    equ *

         end

