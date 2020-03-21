         nam   Init
         ttl   os9 system module

 use defsfile

         mod   INITEND,INITNAM,SYSTM,REENT+1
 fcb   $0B    Top of free RAM high byte
 fdb   $FFFF
         fcb   $0E
         fcb   $0E
 fdb   SYSGO
 fdb   SYSDEV      system device (sysdev)
 fdb   SYSTERM
 fdb   BOOTST      bootstrap module (bootst)
 fdb   ERRMSG

INITNAM  fcs   "Init"
SYSGO    fcs   "SysGo"
SYSDEV   fcs   "/D0"
SYSTERM  fcs   "/term"
BOOTST   fcs   "Boot"
ERRMSG   fcs   "errmsg"

         emod
INITEND  equ   *
