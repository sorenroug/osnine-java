 nam   Init
 ttl   os9 system module

 use defsfile

 mod   INITEND,INITNAM,Systm,ReEnt+2

 fcb $7F    Top of free RAM high byte
 fdb $FFFF  Top of free RAM
 fcb 14         IRQ polling slots
 fcb 14        System device slots
 fdb SYSGO    InitStr - offset $0E
 fdb SYSDEV      system device (SysStr) offset $10
 fdb TERM      Standard I/O Pathlist (StdStr) offset $12
 fdb 0      bootstrap module (BootStr)  offset $14
 fdb TERM    Console  offset $16

INITNAM fcs /Init/
SYSGO fcs "SysGo"

SYSDEV fcs "/D0"
BOOTMOD fcb 0
TERM fcs "/T1"

 emod
INITEND      equ   *

 end
