* OS9 standard init modul.
         nam   Init
         ttl   os9 system module

         ifp1
         use   ../DEFS/os9defs
         endc
null     set   $0000
tylg     set   Systm+$00
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,initnam,tylg,atrv
         fcb   0           Top of free RAM high byte
         fdb   $F800       Top of free RAM
         fcb   $0C         IRQ polling slots
         fcb   $0C
         fdb   sysgo
         fdb   sysdev      system device (sysdev)
         fdb   systerm
         fdb   bootst      bootstrap module (bootst)
initnam  fcs   "Init"
sysgo    fcs   "SysGo"
sysdev   fcs   "/D0"
systerm  fcs   "/Term"
bootst   fcs   "Boot"
         emod
eom      equ   *

