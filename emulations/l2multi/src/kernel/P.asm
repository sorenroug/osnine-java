 nam P
 ttl Device Descriptor for the Serial Port

 use defsfile

***************
* /P module - serial port for use as a printer
*
***************


 mod TrmEnd,TrmNam,DEVIC+OBJCT,REENT+1,TrmMgr,TrmDrv
 fcb UPDAT. attributes
 fcb IOBlock/DAT.BlCt port bank
 fdb A.P  physical controller address
 fcb initsize-*-1  initilization table size
OptStrt fcb DT.SCF SCF type device

* DEFAULT PARAMETERS

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
 fcb A.T.init ACIA initialization
 fcb 0 baud rate
 fdb TrmNam offset to pause device name
 fcb $00 acia xon char
 fcb $00 acia xoff char
 fcb 80 number of columns for display
 fcb $04 No-edit flag
initsize equ *
 fcb $00 Lead-in character for input
 fcb $1B Lead-in character for output
 fcb $CB Move left code
 fcb $C3 Move right code
 fcb $B4 Move left key
 fcb $B6 Move right key
 fcb $AA Delete chr under cursor key
 fcb $A3 Delete to end of line key

TrmNam fcs 'P' device name
TrmMgr fcs 'SCF' file manager
TrmDrv fcs 'ACIA' device driver

 emod Module CRC

TrmEnd equ *

 end
