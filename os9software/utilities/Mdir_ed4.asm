         nam   Mdir
         ttl   program module
 use defsfile

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   2
u0002    rmb   2
u0004    rmb   2
u0006    rmb   1
u0007    rmb   1
u0008    rmb   1
u0009    rmb   3
u000C    rmb   3
u000F    rmb   530
size     equ   .
name     equ   *
         fcs   /Mdir/
         fcb   4

HEADER    fcb   $0A
         fcc "   module directory at "
HEADEND  equ *-HEADER
L002A    fcb   $0A
         fcc "Addr Size typ rev attr use module name"
         fcb   $0A
         fcc "---- ---- --- --- ---- --- ------------"
         fcb   $0D

start    equ   *
         stx   <u0004
         leax  <HEADER,pcr
         ldy   #HEADEND
         lda   #1
         os9   I$WritLn
         leax  u0009,u
         os9   F$Time
         leax  u000F,u
         stx   <u0007
         leax  u000C,u
         lbsr  L01A1
         lbsr  L018E
         ldx   >$0026
         stx   <u0000
         ldd   >$0028
         std   <u0002
         leax  -$04,x
         ldy   <u0004
         lda   ,y+
         eora  #$45
         anda  #$DF
         bne   L00E3
         leax  >L002A,pcr
         ldy   #$0050
         lda   #$01
         os9   I$WritLn
         ldx   <u0000
         bra   L0137

L00C1    ldy   ,x
         beq   L00E8
         ldd   $04,y
         leay  d,y
         lbsr  L0183
L00CD    lbsr  L0170
         ldb   <u0008
         subb  #$0F
         cmpb  #$30
         bhi   L00E0
L00D8    subb  #$0C
         bhi   L00D8
         bne   L00CD
         bra   L00E8
L00E0    lbsr  L018E
L00E3    leay  u000F,u
         sty   <u0007
L00E8    leax  $04,x
         cmpx  <u0002
         bcs   L00C1
         lbsr  L018E
         bra   L013B
L00F3    leay  u000F,u
         sty   <u0007
         ldy   ,x
         beq   L0135
         ldd   ,x
         bsr   L013F
         ldd   $02,y
         bsr   L013F
         bsr   L0170
         lda   $06,y
         bsr   L0147
         bsr   L0170
         lda   $07,y
         anda  #$0F
         bsr   L0147
         ldb   $07,y
         lda   #$72
         bsr   L017C
         lda   #$3F
         bsr   L017C
         lda   #$3F
         bsr   L017C
         lda   #$3F
         bsr   L017C
         bsr   L0170
         bsr   L0170
         lda   $02,x
         bsr   L0147
         ldd   $04,y
         leay  d,y
         bsr   L0183
         bsr   L018E
L0135    leax  $04,x
L0137    cmpx  <u0002
         bcs   L00F3
L013B    clrb
         os9   F$Exit

L013F    bsr   L014B
         tfr   b,a
         bsr   L014D
         bra   L0170
L0147    bsr   L014B
         bra   L0170
L014B    clr   <u0006
L014D    pshs  a
         lsra
         lsra
         lsra
         lsra
         bsr   L0159
         lda   ,s+
         anda  #$0F
L0159    tsta
         beq   L015E
         sta   <u0006
L015E    tst   <u0006
         bne   L0166
         lda   #$20
         bra   L0172
L0166    adda  #$30
         cmpa  #'9
         bls   L0172
         adda  #$07
         bra   L0172
L0170    lda   #$20
L0172    pshs  x
         ldx   <u0007
         sta   ,x+
         stx   <u0007
         puls  pc,x
L017C    rolb
         bcs   L0172
         lda   #$2E
         bra   L0172
L0183    lda   ,y
         anda  #$7F
         bsr   L0172
         lda   ,y+
         bpl   L0183
         rts
L018E    pshs  y,x,a
         lda   #$0D
         bsr   L0172
         leax  u000F,u
         ldy   #$0050
         lda   #$01
         os9   I$WritLn
         puls  pc,y,x,a
L01A1    bsr   L01A9
         bsr   L01A5
L01A5    lda   #$3A
         bsr   L0172
L01A9    ldb   ,x+
         lda   #$2F
L01AD    inca
         subb  #$64
         bcc   L01AD
         cmpa  #$30
         beq   L01B8
         bsr   L0172
L01B8    lda   #$3A
L01BA    deca
         addb  #$0A
         bcc   L01BA
         bsr   L0172
         tfr   b,a
         adda  #$30
         bra   L0172
         emod
eom      equ   *
