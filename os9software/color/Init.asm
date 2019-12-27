* OS9 standard init modul.
 nam   Init
 ttl   os9 system module

 use defsfile

 mod   INITEND,INITNAM,SYSTM,REENT+1
 fcb   0           Top of free RAM high byte
 fdb   $F800       Top of free RAM
 fcb   12         IRQ polling slots
 fcb   12        System device slots

 fdb   SYSGO
 fdb   SYSDEV      system device (sysdev)
 fdb   SYSTERM
 fdb   BOOTST      bootstrap module (bootst)
INITNAM  fcs   "Init"
SYSGO    fcs   "SysGo"
SYSDEV   fcs   "/D0"
SYSTERM  fcs   "/Term"
BOOTST   fcs   "Boot"
         emod
INITEND equ *
