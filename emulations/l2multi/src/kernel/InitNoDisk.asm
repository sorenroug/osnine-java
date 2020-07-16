*
* OS9 init module with no system device
*
 nam   Init
 ttl   os9 system module

 use defsfile

 mod   INITEND,INITNAM,Systm,ReEnt+1

 fcb   $0B         Top of free RAM high byte
 fdb   $FFFF     Top of free RAM
 fcb   14        IRQ polling slots
 fcb   14        System device slots

 fdb   sysgo
 fdb   0      system device (sysdev)
 fdb   systerm   system terminal
 fdb   DefBoot   bootstrap module

INITNAM  fcs   "Init"
sysgo    fcs   "SysGo"
SysDev   fcs   "/D0"
systerm  fcs   "/Term"
DefBoot  fcs   "Boot"
         emod
INITEND      equ   *

