
* The BASIC09 distributed by Tandy and Dragon Data contains control sequences
* for the 32x16 terminal to clear screen and switch to alpha mode
* These sequences can cause strange behaviour on a VT100. I have therefore
* made an edition without these sequences.

* Header for : Basic09
* Module size: $5A7D  #23165
* Module CRC : $43E7BE (Good)
* Hdr parity : $19
* Exec. off  : $0772  #1906
* Data size  : $1000  #4096
* Edition    : $16  #22
* Ty/La At/Rv: $11 $81
* Prog mod, 6809 Obj, re-ent, R/O

Y2K equ 0

       org 1
TANDY  rmb 1
DRAGON  rmb 1
OTHER   rmb 1

RESELLER equ OTHER

 use basic09.asm
