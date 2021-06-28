         nam   Padder
         ttl   os9 device driver


 use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
**********
* Static storage offsets
*
 org V.SCF room for scf variables
u001D    rmb   1
u001E    rmb   1
u001F    rmb   1
u0020    rmb   1
u0021    rmb   1
u0022    rmb   1
size     equ   .

 fcb UPDAT.

name fcs   /Padder/
         fcb 1

start    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT

INIT    clrb
        rts

READ    tst   <u001E,u
         bne   L004E
         tst   <u001D,u
         bne   L004E
         ldb   <u001F,u
         cmpb  #$04
         bne   L004E
         lbsr  L0103
         pshs  u,cc
         ldu   DAT.Regs
         orcc  #$50
         stx   DAT.Regs
         lda   ,y
         stu   DAT.Regs
         puls  u,cc
L004E    clr   <u001F,u
         clr   <u001E,u
         clrb
         rts

WRITE    ldb   <u001F,u
         inc   <u001F,u
         tstb
         beq   L006D
         cmpb  #$01
         beq   L007B
         cmpb  #$02
         beq   L008B
         cmpb  #$03
         beq   L0090
         bra   L0095
L006D    cmpa  #$01
         bhi   L0076
         sta   <u001D,u
         bra   L00B8
L0076    clr   <u001F,u
         bra   L00B8
L007B    cmpa  #$0F
         bhi   L0084
         sta   <u0020,u
         bra   L00B8

L0084    lda   #$01
         sta   <u001E,u
         bra   L00B8

L008B    sta   <u0021,u
         bra   L00B8

L0090    sta   <u0022,u
         bra   L00B8

L0095    tst   <u001E,u
         bne   L00B2
         tst   <u001D,u
         beq   L00B2
         bsr   L0103
         pshs  u,cc
         ldu   DAT.Regs
         orcc  #$50
         stx   DAT.Regs
         sta   ,y
         stu   DAT.Regs
         puls  u,cc
L00B2    clr   <u001E,u
         clr   <u001F,u
L00B8    clrb
         rts

GETSTA    cmpa  #SS.Ready
         beq   TRMNAT
         cmpa  #SS.EOF
         beq   TRMNAT

PUTSTA    cmpa  #$80
         bne   L00FD
         orcc  #$50
         ldu   >$FFBC
         pshs  u
         ldu   >$FFBE
         ldy   #$01FA
         sty   >$FFBC
         leay  $01,y
         sty   >$FFBE
         ldd   >$FC00
         cmpd  #$464C
         bne   L00F3
         ldd   >$FC02
         cmpd  #$4558
         bne   L00F3
         jmp   >$FE18
L00F3    stu   >$FFBE
         puls  u
         stu   >$FFBC
         andcc #$50
L00FD    comb
         ldb   #E$UnkSvc
         rts

TRMNAT   clrb
         rts

*
* Subroutine dealing with memory block computation
*
L0103    pshs  a
         ldb   <u0021,u
         lsrb
         lsrb
         lsrb
         clra
         tfr   d,x
         lda   <u0020,u
         beq   L0119
L0113    leax  <$20,x
         deca
         bne   L0113
L0119    leax  >$0200,x
         ldd   <u0021,u
         anda  #$07
         tfr   d,y
         puls  pc,a
         emod
eom      equ   *
