         nam   PRINTER
         ttl   Standard printer driver for OS9

         ifp1
         use   ../DEFS/os9defs
         use   ../DEFS/scfdefs
         endc
pia0a    equ   $FF00
pia0b    equ   $FF02
pia1a    equ   $FF20
pia1b    equ   $FF22
tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   PEND,PNAM,tylg,atrv,PENT,size
         rmb   29
size     equ   .
         fcb   READ.+WRITE.

PNAM     fcs   /PRINTER/
         fcb   $01     Revision

PENT     lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TERM
**************
* INIT
INIT     pshs  cc
         orcc  #IntMasks
         ldx   #pia1a
         ldb   $01,x
         clr   $01,x
         lda   #$FE
         sta   ,x
         stb   $01,x
         ldx   #pia1b
         ldb   $01,x
         clr   $01,x
         lda   ,x
         anda  #$FE
         sta   ,x
         stb   $01,x
         puls  cc
         clrb
         rts
**************
* READ
*   This module doesn't do reads
*
READ     ldb   #E$BMode
         orcc  #Carry
         rts
**************
* WRITE
*
WRITE    pshs  a
L0053    ldb   #$08
L0055    lda   >pia1b
         lsra
         bcc   L006C
         nop
         nop
         decb
         bne   L0055
         pshs  x
         ldx   #$0001
         os9   F$Sleep    sleep for one clock tick
         puls  x
         bra   L0053
L006C    puls  a
         pshs  cc
         orcc  #IntMasks
         sta   >pia0b
         lda   >pia1a
         ora   #$02
         sta   >pia1a
         anda  #$FD
         sta   >pia1a
         puls  pc,cc
**************
* GETSTA
*
GETSTA   cmpa  #SS.Ready
         bne   chkeof
allok    clrb
         rts
chkeof   cmpa  #SS.EOF
         beq   allok
**************
* PUTSTA
*
PUTSTA   comb
         ldb   #E$UnkSvc
         rts
**************
* TERM
*   Terminate driver
*
TERM     rts
         emod
PEND     equ   *

