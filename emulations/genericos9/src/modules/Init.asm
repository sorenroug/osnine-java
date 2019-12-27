*
* OS9 init module with virtual disk
         nam   Init
         ttl   os9 system module

         ifp1
         use   os9defs
         endc
null     set   $0000
tylg     set   Systm+$00
atrv     set   ReEnt+rev
rev      set   $01

         mod   eom,initnam,tylg,atrv
         fcb   0         Top of free RAM high byte
         fdb   $F800     Top of free RAM
         fcb   12        IRQ polling slots
         fcb   12        System device slots
         fdb   sysgo
         fdb   SysDev      system device (sysdev)
         fdb   systerm   system terminal
         fdb   DefBoot   bootstrap module
initnam  fcs   "Init"

sysgo    fcs   "SysGo"
SysDev   fcs   "/D0"
systerm  fcs   "/Term"
DefBoot  fcs   "Boot"
         emod
eom      equ   *

