         nam   Init
         ttl   os9 system module    

 use defsfile

 mod   INITEND,INITNAM,Systm,ReEnt+1

 fcb $7F    Top of free RAM high byte
 fdb $FFFF  Top of free RAM
 fcb 14         IRQ polling slots
 fcb 14        System device slots

 fdb SYSGO    InitStr - offset $0E
 fdb D4      system device (SysStr) offset $10
 fdb T1      Standard I/O Pathlist (StdStr) offset $12
 fdb $0000      bootstrap module (BootStr)  offset $14
 fdb term    Console  offset $16

INITNAM  fcs   /Init/
sysgo fcs "SysGo"
d4 fcs "/D4"
d5 fcs "/D5"
d6 fcs "/D6"
d7 fcs "/D7"
d0 fcs "/D0"
d2 fcs "/D2"
 fcb   $00 
t1 fcs "/T1"
term fcs "/Term"

 emod
INITEND equ *
