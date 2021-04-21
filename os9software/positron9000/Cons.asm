         nam   Cons
         ttl   os9 device driver

PORTADDR equ $E801

         use  defsfile
tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $02
         mod   eom,name,tylg,atrv,start,size

**********
* Static storage offsets
*
 org V.SCF room for scf variables
INXTI    rmb   1
INXTO    rmb   1
u001F    rmb   1
u0020    rmb   1
u0021    rmb   2
u0023    rmb   1
u0024    rmb   1
u0025    rmb   1
u0026    rmb   1
u0027    rmb   1
u0028    rmb   1
u0029    rmb   1
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   1
u002E    rmb   1
u002F    rmb   1
u0030    rmb   1
u0031    rmb   1
u0032    rmb   1
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
u0036    rmb   1
u0037    rmb   1
u0038    rmb   1
INPBUF    rmb   100
u009D    rmb   10
u00A7    rmb   4
u00AB    rmb   14
u00B9    rmb   1
u00BA    rmb   15
u00C9    rmb   7
u00D0    rmb   2
u00D2    rmb   2
u00D4    rmb   2
u00D6    rmb   7
u00DD    rmb   12
u00E9    rmb   192
size     equ   .
name     equ   *
         fcs   /Cons/
start    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT

CONSMASK fcb 0 no flip bits
 fcb $04
 fcb $80

INIT    lda   #$03
         sta   <$33,u
         lda   #$80
         sta   <u002B,u
         orcc #IntMasks disable interrupts
         ldx   #$0300
         ldy   >DAT.Regs
         stx   >DAT.Regs
         ldx   #$0000
         ldb   #$0E
         cmpb  ,x
         bne   L0046
         incb
L0046    stb   ,x
         cmpb  ,x
         beq   L0057
         sty   >DAT.Regs
         andcc #^IntMasks enable IRQs
         comb
         ldb   #E$Unit
         bra   L00B0
L0057    ldx   #$0028
         ldb   #$0E
         cmpb  ,x
         bne   L0061
         incb
L0061    stb   ,x
         lda   #$50
         cmpb  ,x
         beq   L006E
         clr   <u002B,u
         lda   #$28
L006E    sta   <u0023,u
         deca
         sta   <u0024,u
         ldx   #$0304
         stx   >DAT.Regs
         lda   >$0000
         ora   <u002B,u
         sta   >$0000
         ldd   #$3A96
         ldx   #$0340
         stx   >DAT.Regs
         ldx   #$0000
         std   $06,x
         ldb   #$52
         stb   ,x
         ldb   #$01
         stb   $01,x
         clr   ,x
         sty   >DAT.Regs
         andcc #^IntMasks enable IRQs
         ldd   #PORTADDR
         leay  >CONSIRQ,pcr
         leax  >CONSMASK,pcr
         os9   F$IRQ
L00B0    rts

L00B1    bsr   ACSLEP
READ    ldb   <INXTO,u
         leax  <INPBUF,u
         orcc #IntMasks disable interrupts
         cmpb  <INXTI,u
         beq   L00B1
         abx
         lda   ,x
         incb
         cmpb  #99
         bls   L00C9
         clrb
L00C9    stb   <INXTO,u
         clrb
         ldb   V.ERR,u
         beq   L00D9
         stb   <$3A,y
         clr   V.ERR,u
         comb
         ldb   #$F4
L00D9    andcc #^IntMasks enable IRQs
         rts

* Sleep for I/O activity
ACSLEP    pshs  x,b,a
 lda V.BUSY,U get current process id
 sta V.Wake,U arrange wake up signal
 andcc #^IntMasks interrupts ok now
 ldx #0
 OS9 F$Sleep wait for input data
 ldx D.Proc
 ldb P$Signal,X signal present?
 beq ACSL90 ..no; return
 cmpb #S$Intrpt Deadly signal?
 bls ACSLER ..yes; return error
ACSL90 clrb
 puls D,X,PC return

ACSLER leas 6,S Exit to caller's caller
 coma return carry set
 rts


***************
* Write
*   Write char Through Acia
*
* Passed: (A)=char to write
*         (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: CC=Set If Busy (output buffer Full)
*
WRITE    ldb   <u0027,u
         beq   L0130
         tst   <$22,y
         bne   L0110
         clr   <u0027,u
         cmpa  #$08
         bne   L0130
         lbra  L0272
L0110    dec   <u0027,u
         decb
         cmpb  #$04
         beq   L0122
         cmpb  #$01
         beq   L0122
         cmpa  #$08
         bne   L012D
         bra   L0126
L0122    cmpa  #$20
         bne   L012D
L0126    cmpb  #$02
         bhi   L0130
         lbra  L0272
L012D    clr   <u0027,u
L0130    cmpa  #$1B
         bne   L013A
         inc   <u0028,u
         lbra  L0272
L013A    lbsr  L0406
         tst   <u0028,u
         beq   L0148
         lbsr  L0447
         lbra  L026C
L0148    cmpa  #$20
         lbcc  L021F
         cmpa  #$0D
         bne   L0158
         clr   <u0020,u
         lbra  L026C
L0158    cmpa  #$0A
         bne   L016D
         tst   <u0025,u
         bne   L0167
         lbsr  L0376
         lbsr  L0274
L0167    clr   <u0025,u
         lbra  L026C
L016D    cmpa  <$33,y
         lbeq  L026C
         cmpa  #$16
         bne   L0190
         lda   <u001F,u
         cmpa  #$17
         beq   L018D
         tst   <u0025,u
         bne   L018A
         lbsr  L0376
         inc   <u001F,u
L018A    clr   <u0025,u
L018D    lbra  L026C
L0190    clr   <u0025,u
         cmpa  #$0B
         bne   L01A9
         lda   <u001F,u
         beq   L01A1
         lbsr  L0391
         bra   L01A6
L01A1    lda   #$17
         sta   <u001F,u
L01A6    lbra  L026C
L01A9    cmpa  #$0C
         bne   L01D5
         ldd   <u001F,u
         cmpb  <u0024,u
         beq   L01B8
         incb
         bra   L01C7
L01B8    lbsr  L0376
         cmpa  #$17
         beq   L01CC
         inc   <u0025,u
         ldd   <u001F,u
         clrb
         inca
L01C7    std   <u001F,u
         bra   L01D2
L01CC    lbsr  L0274
         clr   <u0020,u
L01D2    lbra  L026C
L01D5    cmpa  #$1E
         bne   L01E2
         ldx   #$0000
         stx   <u001F,u
         lbra  L026C
L01E2    cmpa  #$02
         bne   L01EC
         inc   <u0026,u
         lbra  L026C
L01EC    cmpa  #$08
         bne   L021F
         ldd   <u001F,u
         tstb
         beq   L01F9
         decb
         bra   L0209
L01F9    tsta
         beq   L0201
         lbsr  L0391
         bra   L0206
L0201    lda   #$17
         sta   <u001F,u
L0206    ldb   <u0024,u
L0209    stb   <u0020,u
         lbsr  L03EF
         anda  #$7F
         beq   L021C
         cmpa  #$20
         bcc   L021C
         lda   #$05
         sta   <u0027,u
L021C    lbra  L026C
L021F    clr   <u0025,u
         ldb   <u0026,u
         beq   L0235
         clr   <u0026,u
         suba  #$40
         cmpa  #$0D
         bne   L0235
         lbsr  L0351
         bra   L0253
L0235    lbsr  L0308
         tst   <u0037,u
         bne   L0253
         cmpa  #$60
         bne   L0245
         lda   #$23
         bra   L0253
L0245    cmpa  #$5F
         bne   L024D
         lda   #$60
         bra   L0253
L024D    cmpa  #$23
         bne   L0253
         lda   #$5F
L0253    lbsr  L03D5
         ldb   <u0020,u
         inc   <u0020,u
         cmpb  <u0024,u
         bne   L026C
         clr   <u0020,u
         inc   <u0025,u
         lbsr  L0376
         bsr   L0274
L026C    ldx   <u001F,u
         lbsr  L0427
L0272    clrb
         rts

L0274    ldb   <u001F,u
         cmpb  #$17
         lbne  L0304
         ldd   #$0300
         std   <u0030,u
         ldy   #$0000
         ldb   #$17
L0289    lda   <u0023,u
         asra
         cmpb  #$10
         beq   L0295
         cmpb  #$08
         bne   L02C4
L0295    inc   <u0031,u
         ldy   #$0700
         ldx   <u0030,u
         pshs  u,cc
         orcc #IntMasks disable interrupts
         ldu   >DAT.Regs
         stx   >DAT.Regs
L02A9    ldx   >-$0700,y
         dec   >DAT.Regs+1
         stx   ,y++
         inc   >DAT.Regs+1
         deca
         bne   L02A9
         stu   >DAT.Regs
         puls  u,cc
         ldy   #$0000
         decb
         bra   L0289
L02C4    ldx   <u0030,u
         pshs  u,y,cc
         orcc #IntMasks disable interrupts
         ldu   >DAT.Regs
         stx   >DAT.Regs
L02D1    ldx   >$0100,y
         stx   ,y++
         deca
         bne   L02D1
         stu   >DAT.Regs
         puls  u,y,cc
         leay  >$0100,y
         decb
         bne   L0289
L02E6    lda   <u0023,u
         asra
         ldx   <u0030,u
         pshs  u,cc
         orcc #IntMasks disable interrupts
         ldu   >DAT.Regs
         stx   >DAT.Regs
         ldx   #$0000
L02FA    stx   ,y++
         deca
         bne   L02FA
         stu   >DAT.Regs
         puls  pc,u,cc
L0304    inc   <u001F,u
         rts
L0308    pshs  u,a
         clr   <u0036,u
         clr   <u0037,u
         lbsr  L03BA
         lda   <u0021,u
         clrb
         tfr   d,y
         orcc #IntMasks disable interrupts
L031B    ldu   >DAT.Regs
         stx   >DAT.Regs
         lda   ,y+
         stu   >DAT.Regs
         ldu   $01,s
         anda  #$7F
         cmpa  #$20
         bcc   L0346
         clrb
         bita  #$08
         bne   L033D
         bita  #$10
         beq   L0338
         comb
L0338    stb   <u0037,u
         bra   L0346
L033D    cmpa  #$0D
         bne   L0346
         ldb   #$01
         stb   <u0036,u
L0346    tfr   y,d
         cmpb  <u0020,u
         bcs   L031B
         andcc #^IntMasks enable IRQs
         puls  pc,u,a
L0351    pshs  b,a
         ldd   <u001F,u
         cmpa  #$17
         bne   L0374
         pshs  b
         ldb   <u0023,u
         stb   <u0020,u
         bsr   L0308
         puls  b
         stb   <u0020,u
         tst   <u0036,u
         bne   L0374
         lbsr  L0274
         dec   <u001F,u
L0374    puls  pc,b,a
L0376    ldb   <u0020,u
         pshs  b
         ldb   <u0023,u
         stb   <u0020,u
         bsr   L0308
         puls  b
         stb   <u0020,u
         tst   <u0036,u
         beq   L0390
         inc   <u001F,u
L0390    rts
L0391    ldd   <u001F,u
         cmpa  #$02
         bcs   L03B6
         deca
         deca
         sta   <u001F,u
         pshs  b
         ldb   <u0023,u
         stb   <u0020,u
         lbsr  L0308
         puls  b
         stb   <u0020,u
         tst   <u0036,u
         bne   L03B5
         inc   <u001F,u
L03B5    rts
L03B6    dec   <u001F,u
         rts
L03BA    pshs  b,a
         ldx   #$0302
         ldd   <u001F,u
         cmpa  #$10
         bcc   L03CE
         leax  -$01,x
         cmpa  #$08
         bcc   L03CE
         leax  -$01,x
L03CE    anda  #$07
         std   <u0021,u
         puls  pc,b,a
L03D5    bsr   L03BA
         ora   <u002D,u
         pshs  u,cc
         ldy   <u0021,u
         ldu   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
         sta   ,y
         stu   >DAT.Regs
         puls  pc,u,cc
L03EF    bsr   L03BA
         pshs  u,cc
         ldy   <u0021,u
         ldu   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
         lda   ,y
         stu   >DAT.Regs
         puls  pc,u,cc
L0406    bsr   L03BA
         pshs  y,cc
         orcc #IntMasks disable interrupts
         ldy   >DAT.Regs
         stx   >DAT.Regs
         ldx   <u0021,u
         ldb   ,x
         andb  #$7F
         beq   L041F
         orb   <u002D,u
L041F    stb   ,x
         sty   >DAT.Regs
         puls  pc,y,cc
L0427    tst   <u002F,u
         bne   L0446
         bsr   L03BA
         orcc #IntMasks disable interrupts
         ldy   >DAT.Regs
         stx   >DAT.Regs
         ldx   <u0021,u
         lda   ,x
         ora   #$80
         sta   ,x
         sty   >DAT.Regs
         andcc #^IntMasks enable IRQs
L0446    rts
L0447    tst   <u0029,u
         bne   L04A1
         tst   <u002C,u
         lbne  L05FC
         tst   <u002E,u
         lbne  L067D
         leax  >L047C,pcr
         ldb   #$0B
L0460    cmpa  ,x
         beq   L046B
         leax  $03,x
         decb
         bne   L0460
         bra   L0478
L046B    clr   <u0025,u
         ldd   $01,x
         leax  >L047C,pcr
         leax  d,x
         jmp   ,x
L0478    clr   <u0028,u
         rts

* Jump table here
L047C    fcb '=
         fdb L049D-L047C
         fcb '*
         fdb L04D0-L047C
         fcb '+
         fdb L04D0-L047C
         fcb 't,$00,$93
         fcb 'T,$00,$93
         fcb 'y,$00,$BA
         fcb 'Y,$00,$BA
         fcb 'R,$00,$E9
         fcb 'E
         fdb L0589-L047C
         fcb 'G
         fdb L05F8-L047C
         fcb '.
         fdb  L0679-L047C

L049D    inc   <u0029,u
         rts

L04A1    ldb   <u0029,u
         cmpb  #$01
         bne   L04B9
         inc   <u0029,u
         suba  #$20
         cmpa  #$17
         bhi   L04B5
         sta   <u002A,u
         rts

L04B5    com   <u0029,u
         rts

L04B9    clr   <u0029,u
         tstb
         bmi   L04CE
         suba  #$20
         cmpa  <u0023,u
         bcc   L04CE
         tfr   a,b
         lda   <u002A,u
         std   <u001F,u
L04CE    bra   L0478

L04D0    pshs  u
         clr   <u001F,u
         clr   <u0020,u
         lda   <u0024,u
         ldx   #$0300
         ldu   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
L04E6    ldx   #$0000
L04E9    tfr   a,b
L04EB    clr   b,x
         decb
         bpl   L04EB
         leax  >$0100,x
         cmpx  #$0800
         bne   L04E9
         ldb   >DAT.Regs+1
         cmpb  #$02
         beq   L0505
         inc   >DAT.Regs+1
         bra   L04E6
L0505    stu   >DAT.Regs
         andcc #^IntMasks enable IRQs
         puls  u
         lbra  L0478
L050F    lbsr  L03BA
         pshs  u
         ldy   <u0021,u
         tfr   y,d
         comb
         addb  <u0023,u
         clra
         ldu   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
L0527    sta   ,y+
         decb
         bpl   L0527
         stu   >DAT.Regs
         andcc #^IntMasks enable IRQs
         puls  u
         lbra  L0478
         bsr   L050F
         ldd   <u001F,u
         cmpa  #$17
         lbeq  L0478
         pshs  b,a
         inca
         clrb
         std   <u001F,u
         lbsr  L03BA
         puls  b,a
         std   <u001F,u
         ldy   <u0021,u
         lda   <u0024,u
         pshs  u
         ldu   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
         tfr   y,x
         bra   L04E9
         lbsr  L03BA
         stx   <u0030,u
         ldd   <u0021,u
         clrb
         tfr   d,y
         ldb   #$17
         cmpb  <u001F,u
         bne   L057D
         lbsr  L02E6
         bra   L0583
L057D    subb  <u001F,u
         lbsr  L0289
L0583    clr   <u0020,u
         lbra  L0478

L0589    ldd   #$0302
         std   <u0030,u
         ldb   #$18
         ldy   #$0700
L0595    decb
         cmpb  <u001F,u
         beq   L05F2
         leay  >-$0100,y
         lda   <u0023,u
         asra
         cmpb  #$10
         beq   L05AB
         cmpb  #$08
         bne   L05D5
L05AB    dec   <u0031,u
         ldy   #$0700
         ldx   <u0030,u
         pshs  u,y,cc
         orcc #IntMasks disable interrupts
         ldu   >DAT.Regs
         stx   >DAT.Regs
L05BF    ldx   ,y++
         inc   >DAT.Regs+1
         stx   >-$0702,y
         dec   >DAT.Regs+1
         deca
         bne   L05BF
         stu   >DAT.Regs
         puls  u,y,cc
         bra   L0595
L05D5    ldx   <u0030,u
         pshs  u,y,cc
         orcc #IntMasks disable interrupts
         ldu   >DAT.Regs
         stx   >DAT.Regs
L05E2    ldx   ,y++
         stx   >$00FE,y
         deca
         bne   L05E2
         stu   >DAT.Regs
         puls  u,y,cc
         bra   L0595
L05F2    lbsr  L02E6
         lbra  L0478

L05F8    inc   <u002C,u
         rts

L05FC    cmpa  #$30
         beq   L0615
         cmpa  #$34
         bne   L060B
         lda   #$80
         sta   <u002D,u
         bra   L0618
L060B    cmpa  #$35
         beq   L061E
         cmpa  #$36
         beq   L0649
         bra   L0618
L0615    clr   <u002D,u
L0618    clr   <u002C,u
         lbra  L0478
L061E    lda   #$28
         sta   <u0023,u
         deca
         sta   <u0024,u
         clr   <u001F,u
         clr   <u0020,u
         ldx   #$0304
         ldy   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
         lda   >$0000
         anda  #$7F
         sta   >$0000
         sty   >DAT.Regs
         andcc #^IntMasks enable IRQs
         bra   L0618
L0649    tst   <u002B,u
         beq   L0615
         lda   #$50
         sta   <u0023,u
         deca
         sta   <u0024,u
         clr   <u001F,u
         clr   <u0020,u
         ldx   #$0304
         ldy   >DAT.Regs
         orcc #IntMasks disable interrupts
         stx   >DAT.Regs
         lda   >$0000
         ora   #$80
         sta   >$0000
         sty   >DAT.Regs
         andcc #^IntMasks enable IRQs
         bra   L0618

L0679    inc   <u002E,u
         rts
L067D    cmpa  #$30
         beq   L068A
         cmpa  #$32
         bne   L068F
         clr   <u002F,u
         bra   L068F
L068A    lda   #$01
         sta   <u002F,u
L068F    clr   <u002E,u
         lbra  L0478

***************
* Getsta/Putsta
*   Get/Put Acia Status
*
* Passed: (A)=Status Code
*         (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: varies
GETSTA cmpa #SS.Ready Ready status?
         bne   GETS10
         lda   <INXTO,u
         suba  <INXTI,u
         bne   L06A9
         comb
         ldb   #E$NotRdy
         rts

GETS10 cmpa #SS.EOF End of file?
         bne   L06AB
L06A9    clrb
         rts

L06AB    cmpa  #$80  Unknown SS code
         bne   ErUnkSvc
         ldx   PD.RGS,y
         ldd   R$Y,x
         cmpd  #$000B
         bhi   ErUnkSvc
         leay  >u00B9,u
         lda   #$14
         mul
         leay  d,y
         ldu   D.Proc
         ldb   V.TYPE,u
         lda   <u00D0
         tfr   y,u
         ldx   $04,x
         exg   u,x
         ldy   #$0014
         os9   F$Move
         rts

PUTSTA    cmpa  #$80  Unknown SS code
         bne   ErUnkSvc
         ldx   PD.RGS,y
         ldd   R$Y,x
         cmpd  #$000B
         bhi   ErUnkSvc
         leay  >u00B9,u
         lda   #$14
         mul
         leay  d,y
         ldu   D.Proc
         lda   V.TYPE,u
         ldb   <u00D0
         ldx   $04,x
         tfr   y,u
         ldy   #$0014
         os9   F$Move
         rts

ErUnkSvc    comb
         ldb   #E$UnkSvc
         rts

TRMNAT    ldx   D.Proc
         lda   ,x
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldx   #$0000
         os9   F$IRQ
         rts

CONSIRQ  ldx   #$0340
         ldy   >DAT.Regs
         stx   >DAT.Regs
         ldx   <$06
         sty   >DAT.Regs
         lbsr  L07F4
         leax  >u009D,u
         leay  >u00AB,u
         clrb
L072E    lda   b,x
         cmpa  b,y
         beq   L0739
         lbsr  L0814
         bra   L07A9
L0739    incb
         cmpb  #$0E
         bne   L072E
         lda   <u0038,u
         bne   L075D
         clr   <u0032,u
         ldb   >u00A7,u
         bitb  #$40
         beq   L07A9
         tfr   b,a
         anda  #$1F
         ora   #$20
         lslb
         andb  #$40
         pshs  b
         adda  ,s+
         bra   L076A
L075D    tst   <u0032,u
         beq   L0776
         ldb   >u009D,u
         bitb  #$02
         beq   L07A9
L076A    dec   <u0033,u
         bne   L07A9
         ldb   #$03
         stb   <u0033,u
         bra   L0779
L0776    com   <u0032,u
L0779    bita  #$80
         beq   L07A7
         cmpa  #$8B
         bhi   L079D
         suba  #$80
         ldb   #$14
         mul
         leay  >u00B9,u
         leay  d,y
         ldb   #$14
L078E    lda   ,y+
         beq   L07A9
         pshs  y,b
         bsr   L07AB
         puls  y,b
         decb
         bne   L078E
         bra   L07A9
L079D    pshs  a
         lda   #$02
         bsr   L07AB
         puls  a
         anda  #$7F
L07A7    bsr   L07AB
L07A9    clrb
         rts

L07AB    leax  <INPBUF,u
         ldb   <INXTI,u
         abx
         sta   ,x
         incb
         cmpb  #$63
         bls   L07BA
         clrb
L07BA    cmpb  <INXTO,u
         bne   L07C5
         ldb   #$20
         stb   V.ERR,u
         bra   L07C8
L07C5    stb   <INXTI,u
L07C8    anda  #$7F
         beq   L07E8
         cmpa  V.PCHR,u
         bne   L07D8
         ldx   V.DEV2,u
         beq   L07E8
         sta   $08,x
         bra   L07E8
L07D8    ldb   #$03
         cmpa  V.INTR,u
         beq   InAbort
         ldb   #$02
         cmpa  V.QUIT,u
         bne   L07E8
InAbort    lda   V.LPRC,u
         bra   L07EC
L07E8    ldb   #$01
         lda   V.WAKE,u
L07EC    beq   L07F1
         os9   F$Send
L07F1    clr   V.WAKE,u
         rts

L07F4    leay  >u00AB,u
         ldx   #$0000
         pshs  u
         ldu   >DAT.Regs
L0800    ldd   #$0306
         std   >DAT.Regs
         lda   ,x+
         stu   >DAT.Regs
         sta   ,y+
         cmpx  #$000E
         bne   L0800
         puls  pc,u
L0814    bcs   L0834
         cmpb  <u0034,u
         lbne  L08E5
         lda   b,x
         eora  b,y
         cmpa  <u0035,u
         lbne  L08E5
         clr   <u0038,u
         clr   <u0034,u
         clr   <u0035,u
         lbra  L08E5
L0834    lda   b,x
         eora  b,y
         tstb
         bne   L0858
         bita  #$FA
         lbne  L08E5
         clr   <u0032,u
         sta   <u0035,u
         stb   <u0034,u
         bita  #$01
         beq   L0853
         lda   #$0D
         lbra  L08E2
L0853    lda   #$1B
         lbra  L08E2
L0858    cmpb  #$0A
         bne   L0883
         bita  #$40
         lbne  L08E5
         bita  #$80
         beq   L0880
         clr   <u0032,u
         sta   <u0035,u
         stb   <u0034,u
         ldb   b,y
         tfr   b,a
         anda  #$1F
         ora   #$20
         lslb
         andb  #$40
         pshs  b
         adda  ,s+
         bra   L08E2
L0880    clra
         bra   L08E2
L0883    clr   <u0032,u
         sta   <u0035,u
         stb   <u0034,u
         decb
         lslb
         lslb
         lslb
L0890    asra
         bcs   L0896
         incb
         bra   L0890
L0896    lda   ,y
         bne   L089E
         lda   $0A,y
         beq   L08A8
L089E    lda   <u0034,u
         lda   a,x
         beq   L08A8
         clra
         bra   L08E2
L08A8    leay  >L08F8,pcr
         lda   >u00AB,u
         bita  #$70
         beq   L08B8
         leay  >L0950,pcr
L08B8    cmpb  #$50
         bcs   L08C2
         subb  #$08
         lda   b,y
         bra   L08E2
L08C2    lda   b,y
         ldb   >u00AB,u
         bitb  #$08
         beq   L08D0
         anda  #$1F
         bra   L08E2
L08D0    ldb   >u00AB,u
         bitb  #$80
         beq   L08E2
         cmpa  #$61
         bcs   L08E2
         cmpa  #$7A
         bhi   L08E2
         suba  #$20
L08E2    sta   <u0038,u
L08E5    leax  >u009D,u
         leay  >u00AB,u
         clrb
L08EE    lda   b,y
         sta   b,x
         incb
         cmpb  #$0E
         bne   L08EE
         rts

L08F8 fcb $0C,$08,$0A,$0B,$18,$00,$00,$00
      fcb $30,$31,$32,$33,$34,$35,$36,$37
      fcb $38,$39,$3A,$3B,$2C,$3D,$2E,$2F
      fcb $40,$61,$62,$63,$64,$65,$66,$67
      fcb $68,$69,$6A,$6B,$6C,$6D,$6E,$6F
      fcb $70,$71,$72,$73,$74,$75,$76,$77
      fcb $78,$79,$7A,$5B,$5C,$5D,$5E,$20
      fcb $00,$C1,$C2,$C3,$C4,$C5,$C6,$C7
      fcb $C8,$CD,$DA,$DD,$DE,$00,$00,$00
      fcb $30,$31,$32,$33,$34,$35,$36,$37
      fcb $38,$39,$2A,$23,$00,$00,$00,$00

L0950 fcb $0C,$08,$0A,$0B,$18,$00,$00,$00
      fcb $23,$21,$22,$60,$24,$25,$26,$27
      fcb $28,$29,$2A,$2B,$3C,$2D,$3E,$3F
      fcb $5F,$41,$42,$43,$44,$45,$46,$47
      fcb $48,$49,$4A,$4B,$4C,$4D,$4E,$4F
      fcb $50,$51,$52,$53,$54,$55,$56,$57
      fcb $58,$59,$5A,$7B,$7C,$7D,$7E,$20
      fcb $00,$D1,$D2,$D3,$D4,$D5,$D6,$D7
      fcb $C9,$CC,$D9,$DC,$DF,$00,$00,$00
      fcb $8A,$80,$81,$82,$83,$84,$85,$86
      fcb $87,$88,$89,$8B,$00,$00,$00,$00

         emod
eom      equ   *
