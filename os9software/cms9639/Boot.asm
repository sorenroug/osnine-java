         nam   Boot
         ttl   os9 system module

         use   defsfile

tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   BootEnd,name,tylg,atrv,start,0

name     equ   *
         fcs   /Boot/
         fcb   $05

L0012    fcb   $02
         fcb   $00
         fcb   $21
         fcb   $01
         fcb   $01
         fcb   $04
         fcb   $02
         fcb   $64
         fcb   $02
         fcb   $65
         fcb   $02
         fcb   $65
         fcb   $00
         fcb   $00
L0020    fcb   $00
         fcb   $00
         fcb   $21
         fcb   $01
         fcb   $01
         fcb   $02
         fcb   $FF
         fcb   $FF
         fcb   $FF
         fcb   $FF
         fcb   $FF
         fcb   $FF
         fcb   $00
         fcb   $00

L002E    lda   >$FF80
         orcc  #$01
         bita  #$40
         bne   L0046
         stx   <$18,u
         sty   <$1A,u
         stb   <$1D,u
         stb   >$FF80
         andcc #$FE
L0046    rts

L0047    lda   >$FF80
         bmi   L0052
         bita  #$40
         bne   L0047
         bra   L0062
L0052    tfr   a,b
         bita  #$40
         beq   L0071
         anda  #$07
         leax  >L0074,pcr
         lda   a,x
         jsr   a,x
L0062    tst   <$1D,u
         bne   L0047
         lda   <$1C,u
         bita  #$02
         bne   L0071
         andcc #$FE
         rts

L0071    orcc  #$01
         rts

L0074    fcb   L008F-L0074  0
         fcb   L00A2-L0074  1
         fcb   L007C-L0074  2
         fcb   L00B3-L0074  3
         fcb   RETRN-L0074  4
         fcb   RETRN-L0074  5
         fcb   RETRN-L0074  6
         fcb   L00BA-L0074  7

L007C    ldx   <$18,u
L007F    lda   ,x+
         sta   >$FF81
L0084    brn   L0084
         cmpb  >$FF80
         beq   L007F
         stx   <$18,u
RETRN    rts

* Copy to drive
L008F    ldx   <$1A,u
L0092    lda   ,x+
         sta   >$FF81
L0097    brn   L0097
         cmpb  >$FF80
         beq   L0092
         stx   <$1A,u
         rts

* Copy from drive
L00A2    ldx   <$1A,u
L00A5    lda   >$FF81
         sta   ,x+
         cmpb  >$FF80
         beq   L00A5
         stx   <$1A,u
         rts

L00B3    lda   >$FF81
         sta   <$1C,u
         rts

L00BA    tst   >$FF81
         clr   <$1D,u
         rts

L00C1    pshs  y,x,b,a
         sta   <$14,u
         stx   <$12,u
         clrb
         lda   >$FF80
         bita  #$10
         bne   L00D3
         ldb   #$40
L00D3    orb   $01,s
         stb   <$11,u
         clr   <$15,u
         puls  pc,y,x,b,a

L00DD    pshs  y,x,b,a
         leax  <$10,u
         ldy   <$16,u
         bsr   L00EE
         bcc   L00EC
         stb   $01,s
L00EC    puls  pc,y,x,b,a

L00EE    ldb   #$01
         lbsr  L002E
         bcs   L00EE
         lbsr  L0047
         bcc   L00FC
         ldb   #E$Read
L00FC    rts

L00FD    pshs  u,y,x,b,a
         sta   <$1E,u
         lda   #$01
         bsr   L00C1
         clr   <$10,u
L0109    bsr   L00DD
         bcs   L0109
         lda   #$08
         sta   <$10,u
L0112    leax  <$10,u
         ldy   <$1A,u
         bsr   L00EE
         bcs   L0135
         ldd   <$12,u
         addd  #$0001
         std   <$12,u
         ldb   #$00
         adcb  <$11,u
         stb   <$11,u
         dec   <$1E,u
         bne   L0112
         bra   L0137
L0135    stb   $01,s
L0137    puls  pc,u,y,x,b,a

* Delay
L0139    pshs  b,a,cc
         ldd   #$1BE6
L013E    subd  #$0001
         bne   L013E
         puls  pc,b,a,cc

start    equ   *
         pshs  u,y,x,b,a
         leas  <-$20,s
         ldd   #$0100
         os9   F$SRqMem
         lbcs  L01CD
         stu   <$16,s Store allocated buffer
         leau  ,s
         lda   #$10
         sta   >$FF80
         bsr   L0139
         lda   >$FF80
         leay  >L0012,pcr
         clrb
         clr   <$1F,u
         bita  #$10
         bne   L0175
         leay  >L0020,pcr
         ldb   #$40
L0175    stb   <$11,u
         lda   #$C4
         leax  <$10,u
         sta   ,x
         clr   <$15,u
         pshs  y,x
         lbsr  L00EE
         puls  y,x
         lbsr  L00EE
         ldd   #$0100
         ldx   #$0000   LSN 0
         lbsr  L00FD
         bcs   L01CD
         ldx   <$16,u
         ldy   <DD.BSZ,x
         beq   L01CA    No boot file?
         sty   <$20,s
         ldb   <DD.BT,x
         leau  ,x
         ldx   <DD.BT+1,x
         pshs  y,x,b
         ldd   #$0100
         os9   F$SRtMem  Return memory boot sector
         ldd   $03,s
         os9   F$SRqMem
         puls  y,x,b
         stu   <$16,s
         stu   <$22,s
         leau  ,s
         lbsr  L00FD
         bcc   L01D0
         bcs   L01CD
L01CA    comb
         ldb   #E$BTyp
L01CD    stb   <$21,s
L01D0    leas  <$20,s
         puls  pc,u,y,x,b,a
         emod

BootEnd      equ   *
