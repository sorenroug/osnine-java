         nam p
         use os9defs
         use SCFDefs
         ttl Device Descriptor for the Serial Port

***************
* /P module - serial port for use as a printer
*
***************

Type     set DEVIC+OBJCT
Revs     set REENT+1

         mod TermEnd,TermNam,Type,Revs,TermMgr,TermDrv
         fcb UPDAT. attributes
         fcb   $0F extended controller address
         fdb   $FFD8  physical controller address
         fcb DD.Parms-*-1 option byte count
OptStrt  fcb DT.SCF SCF type device

* Default path options

         fcb 0 case=UPPER and lower
         fcb 0 backspace=BS
         fcb 0 delete=backspace over line
         fcb false       auto echo ON
         fcb true       auto line feed ON
         fcb 0 number of NULLS after CR
         fcb false  end of page pause OFF
         fcb 66 lines per page
         fcb 0 no backspace key
         fcb 0 no delete line key
         fcb C$CR end of record key
         fcb C$EOF end of file key
         fcb 0 no reprint line char
         fcb 0 no dup last line char
         fcb 0 no pause key
         fcb 0 no keyboard Interrupt key
         fcb 0 no keyboard Quit key
         fcb C$BSP backspace echo character
         fcb C$BELL line overflow character
         fcb   $15 init value for dev ctl reg
         fcb 0 baud rate
         fdb TermNam offset to pause device name
         fcb   $00 acia xon char
         fcb   $00 acia xoff char
DD.Parms equ *

TermNam    fcs 'P' device name
TermMgr    fcs 'SCF' file manager
TermDrv    fcs 'ACIA' device driver

         emod

TermEnd    equ *

         end

