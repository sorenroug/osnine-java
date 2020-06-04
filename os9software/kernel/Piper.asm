 nam   Piper
 ttl   os9 device driver

 ifp1
 use   os9defs
 endc

 mod   PIPEND,PIPNAM,DRIVR+OBJCT,ReEnt+1,INIPIP,PIPSTA
u0000    rmb   6
PIPSTA equ .

 fcb 3 Edition

PIPNAM fcs "Piper"
 fcb 2

* A device driver normally has six LBRA statements. These take the
* same number of bytes

INIPIP clrb
 rts
 nop

READPIP clrb
 rts
 nop

WRTPIP clrb
 rts
 nop

GETSTA clrb
 rts
 nop

PUTSTA clrb
 rts
 nop

TERMNT clrb
 rts

 emod
PIPEND equ *
