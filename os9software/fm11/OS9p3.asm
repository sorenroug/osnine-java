         nam   OS9p3
         ttl   os9 system module


         ifp1
         use   defsfile
         endc
tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,0

name     fcs   /OS9p3/
         fcb   $03

L0013    fcc   "@(C)SEIKOU"

L001D    fcb   $00
         fcb   $83
         fcb   $00

SVCTBL   fcb   F$Ctime
         fdb CTIME-*-2
         fcb   F$Cstime
         fdb CSTIME-*-2
         fcb   $27
         fdb XXX-*-2
         fcb   $80

start    leay  <SVCTBL,pcr
         os9   F$SSvc
         bcs   L003F
         ldd   #$FD04
         leax  <L001D,pcr
         leay  >L0112,pcr
         os9   F$IRQ
L003F    rts

L0040    pshs  x
         ldb   $04,s
         os9   F$LDABX
         leax  $01,x
         pshs  a
         ldb   $05,s
         os9   F$LDABX
         tfr   a,b
         puls  a
         puls  pc,x
L0056    pshs  b,a
         ldb   $04,s
         lda   ,s
         os9   F$STABX
         leax  $01,x
         ldb   $04,s
         lda   $01,s
         os9   F$STABX
         leax  $01,x
         puls  pc,b,a

CTIME    pshs  a
         ldx   R$X,u
         lda   R$A,u
         bmi   L0085
         lsra
         tfr   x,d
         bcs   L007D
         bsr   L00E9
         bra   L007F
L007D    bsr   L00B2
L007F    bcs   L00AE
         std   R$X,u
         puls  pc,a

L0085    ldy   D.Proc
         ldb   $06,y
         stb   ,s
         ldy   $06,u
         lsra
         bcs   L00A0
L0092    bsr   L0040
         bsr   L00E9
         bcs   L00AE
         bsr   L0056
         leay  -$01,y
         bne   L0092
         puls  pc,a
L00A0    bsr   L0040
         bsr   L00B2
         bcs   L00AE
         bsr   L0056
         leay  -$01,y
         bne   L00A0
         puls  pc,a
L00AE    ldb   #$43
         puls  pc,a
L00B2    cmpa  #$80
         bls   L00CE
         cmpa  #$A0
         bcs   L00C2
         cmpa  #$DF
         bls   L00CE
         cmpa  #$FD
         bcc   L00CE
L00C2    cmpb  #$3F
         bls   L00CE
         cmpb  #$FD
         bcc   L00CE
         cmpb  #$7F
         bne   L00D0
L00CE    comb
         rts
L00D0    cmpa  #$9F
         bls   L00D6
         suba  #$40
L00D6    lsla
         adda  #$1F
         tstb
         bmi   L00DD
         incb
L00DD    subb  #$20
         cmpb  #$7E
         bls   L00E6
         subb  #$5E
         inca
L00E6    andcc #$FE
         rts
L00E9    cmpa  #$20
         bls   L00F9
         cmpa  #$7F
         bcc   L00F9
         cmpb  #$20
         bls   L00F9
         cmpb  #$7F
         bcs   L00FB
L00F9    comb
         rts
L00FB    inca
         lsra
         bcc   L0101
         addb  #$5E
L0101    addb  #$20
         tstb
         bmi   L0107
         decb
L0107    adda  #$70
         cmpa  #$9F
         bls   L010F
         adda  #$40
L010F    andcc #$FE
         rts
L0112    lda   >$FD04
         bita  #$02
         bne   L0112
         bita  #$01
         beq   L0120
         sta   >$FD04
L0120    clrb
         rts

L0122    fcb $7e,$39

CSTIME   ldx   D.Proc
         leay  P$DatIMG,x
         ldx   R$X,u
         leax  -$0D,x
         ldd   #$0004
         os9   F$LDDDXY
         leax  d,x
L0135    os9   F$LDAXY
         leax  $01,x
         tsta
         bpl   L0135
         lda   >L0013,pcr
         sta   $02,u
         tst   $01,u
         bpl   L0181
         leax  $02,x
         clra
         clrb
         os9   F$LDDDXY
         pshs  x
         coma
         comb
         os9   F$LDDDXY
         eora  #$87
         eorb  #$CD
         pshs  b,a
         comb
         leax  <L0122,pcr
         ldd   ,x
         rolb
         rola
         tfr   d,x
         ldd   ,x
         coma
         comb
         cmpd  ,s++
         puls  x
         beq   L0174
         clrb
         os9   F$Exit

L0174    leax  $03,x
         clra
         clrb
         os9   F$LDDDXY
         coma
         comb
         leax  d,x
         stx   $0A,u
L0181    clrb
         rts

XXX      pshs  u,dp
         ldd   #$103F
         ldx   #$0039
         pshs  x,d
         lda   $01,u
         sta   $02,s
         leas  -$0A,s
         ldx   D.Proc
         lda   P$Task,x
         ldb   D.SysTsk
         ldx   R$X,u
         ldy   #$000A
         leau  ,s
         os9   F$Move
         puls  u,y,x,dp,b,a,cc
         jsr   ,s
         leas  $04,s
         pshs  u,y,x,dp,b,a,cc
         leau  $0A,s
         pulu  dp
         ldu   ,u
         ldx   D.Proc
         lda   D.SysTsk
         ldb   P$Task,x
         ldu   R$X,u
         leax  ,s
         ldy   #$000A
         os9   F$Move
         puls  u,y,x,dp,b,a,cc
         puls  pc,u,dp
         emod
eom      equ   *
