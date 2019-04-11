
* Header for : Basic09
* Module size: $5ACC  #23244
* Module CRC : $C5054F (Good)
* Hdr parity : $A8
* Exec. off  : $07C1  #1985
* Data size  : $1000  #4096
* Edition    : $16  #22
* Ty/La At/Rv: $11 $81
* Prog mod, 6809 Obj, re-ent, R/O

Y2K equ 0
B09EXEC equ 1

       org 1
TANDY  rmb 1
DRAGON  rmb 1
OTHER   rmb 1

RESELLER equ TANDY

 use basic09.asm
