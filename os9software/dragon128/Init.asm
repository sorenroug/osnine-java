 nam Init
 ttl OS-9 Configuration Module

************************************************************
*
*     Configuration Module
*

 use defsfile

 mod ConEnd,ConNam,systm,reent+1

*
* configuration constants
*
TopRAM1 equ $0B Top of RAM MSB
TopRAM2 equ $FF Top of RAM middle byte
TopRAM3 equ $FF Top of RAM LSB
SizPoll equ 14 irq polling table size
SizDevic equ 14 device table size

*
* configuration module body
*
 fcb TopRam1,TopRam2,TopRam2
 fcb SizPoll irq polling table size
 fcb SizDevic device table size
 fdb RunMod first executable module
 fdb DefDir default directory
 fdb StdIO standard path
 fdb BootMod bootstrap module
 ifne EXTERR
 fdb ErrNam error messages path name
 endc

ConNam fcs "Init"
RunMod fcs "SysGo"
DefDir fcs "/D0"
StdIO  fcs "/term"
BootMod fcs "Boot"
 ifne EXTERR
ErrNam fcs "errmsg"
 endc
 emod end of configuration module

ConEnd  equ   *
