*****
*
* Configuration Module
*
 nam Init
 ttl Configuration Module

 use defsfile

 mod INITEND,INITNAM,SYSTM,REENT+1
 fcb $0B    Top of free RAM high byte
 fdb $FFFF     Top of free RAM
 fcb 14        IRQ polling slots
 fcb 14        System device slots

 fdb SYSGO     Initial module name
 fdb SYSDEV    system device (sysdev)
 fdb SYSTERM
 fdb BOOTST    bootstrap module (bootst)
 fdb ERRMSG

INITNAM  fcs   "Init"
SYSGO    fcs   "SysGo"
SYSDEV   fcs   "/D0"
SYSTERM  fcs   "/term"
BOOTST   fcs   "Boot"
ERRMSG   fcs   "errmsg"

         emod
INITEND  equ   *
