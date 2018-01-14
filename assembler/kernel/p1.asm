 nam p1
 use ../DEFS/os9defs
 ttl Device Descriptor for the Serial Port

***************
* /p1 module - serial port
* for use as a printer port.
*
***************

Type set DEVIC+OBJCT
Revs set REENT+1

 mod P1End,P1Nam,Type,Revs,P1Mgr,P1Drv
 fcb UPDAT. attributes
 fcb $FF high byte of 24-bit address
 fdb $FF04 port address
 fcb DD.Parms-*-1 option byte count
OptStrt fcb DT.SCF SCF type device

* Default path options

 fcb 0 case=UPPER and lower
 fcb 0 backspace=BS only
 fcb 0 delete=backspace over line
 fcb 0 auto echo OFF
 fcb 1 auto line feed ON
 fcb 0 number of NULLS after CR
 fcb 0 end of page pause OFF
 fcb 66 lines per page
 fcb 0 backspace key
 fcb 0 delete line key
 fcb 0 end of record key
 fcb 0 end of file key
 fcb 0 redisplay the line
 fcb 0 repeat the line
 fcb 0 pause key
 fcb 0 Keyboard Interrupt key
 fcb 0 Keyboard Quit key
 fcb 0 backspace echo character
 fcb 0 line overflow character
 fcb 0 no parity specified
 fcb 3 baud rate = 1200
 fdb P1Nam offset to pause device name
 fcb $11 XON
 fcb $13 XOFF
DD.Parms equ *

P1Nam fcs 'P1' device name
P1Mgr fcs 'scf' file manager
P1Drv fcs 'acia51' device driver

 emod

P1End equ *

 end

