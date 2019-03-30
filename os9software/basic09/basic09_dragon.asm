
* Header for : Basic09
* Module size: $5AB5  #23221
* Module CRC : $E3C48D (Good)
* Hdr parity : $D1
* Exec. off  : $07AA  #1962
* Data size  : $1000  #4096
* Edition    : $16  #22
* Ty/La At/Rv: $11 $81
* Prog mod, 6809 Obj, re-ent, R/O

       org 1
TANDY  rmb 1
DRAGON  rmb 1
OTHER   rmb 1

RESELLER equ DRAGON

 use basic09.asm
