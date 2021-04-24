
* The BASIC09 distributed by Tandy and Dragon Data contains control sequences
* for the 32x16 terminal to clear screen and switch to alpha mode
* These sequences can cause strange behaviour on a VT100. I have therefore
* made an edition without these sequences.

Y2K equ 0
B09EXEC equ 1
Edition  equ   21

       org 1
TANDY  rmb 1
DRAGON  rmb 1
OTHER   rmb 1

RESELLER equ OTHER

 use basic09.inc
