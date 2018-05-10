         nam t1
         use os9defs
         use SCFDefs
         ttl Device Descriptor for telnet from a Linux client.

***************
* /t1 module - serial port
* for use as a terminal port.
*
***************

Type     set DEVIC+OBJCT
Revs     set REENT+1

         mod T1End,T1Nam,Type,Revs,T1Mgr,T1Drv
         fcb UPDAT. attributes
         fcb $FF high byte of 24-bit address
         fdb $FF04 port address
         fcb DD.Parms-*-1 option byte count
OptStrt  fcb DT.SCF SCF type device

* Default path options

         fcb 0 case=UPPER and lower
         fcb 1 backspace=BS,SP,BS
         fcb 0 delete=backspace over line
         fcb 1 auto echo ON
         fcb 1 auto line feed ON
         fcb 0 number of NULLS after CR
         fcb false end of page pause ON
         fcb 24 lines per page
         fcb C$BSP backspace key
         fcb $15 delete line key (ctrl-u - Linux convention)
         fcb C$CR end of record key
         fcb $04 end of file key (ctrl-d - Linux convention)
         fcb $12 redisplay the line (ctrl-r - Linux convention)
         fcb C$RPET repeat the line (ctrl-a)
         fcb C$PAUS pause key (ctrl-w)
         fcb C$INTR Keyboard Interrupt key (ctrl-c)
         fcb C$QUIT Keyboard Quit key (ctrl-e)
         fcb C$BSP backspace echo character
         fcb C$BELL line overflow character
         fcb 0 no parity specified
         fcb 3 baud rate = 1200
         fdb T1Nam offset to pause device name
         fcb $11 XON
         fcb $13 XOFF
DD.Parms equ *

T1Nam    fcs 'T1' device name
T1Mgr    fcs 'scf' file manager
T1Drv    fcs 'acia' device driver

         emod

T1End    equ *

         end

