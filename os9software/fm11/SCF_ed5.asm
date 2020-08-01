         nam   SCF
         ttl   os9 file manager

* This is a LEVEL 2 module

 use defsfile

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   SCFEnd,SCFNam,tylg,atrv,SCFEnt,0

SCFNam     equ   *
         fcs   /SCF/
         fcb   5

SCFEnt    equ   *
         lbra  Create
         lbra  Open
         lbra  MakDir
         lbra  ChgDir
         lbra  Delete
         lbra  Seek
         lbra  Read
         lbra  Write
         lbra  ReadLn
         lbra  WriteLn
         lbra  GetStat
         lbra  PutStat
         lbra  Term

* Open/Create entry
Open
Create    ldx   PD.DEV,y
         stx   <$3B,y
         ldu   PD.RGS,y
         pshs  y
         ldx   R$X,u
         os9   F$PrsNam
         lbcs  L00CB
         tsta
         bmi   L0054
         leax  ,y
         os9   F$PrsNam
         bcc   L00CB
L0054    sty   $04,u
         puls  y
         ldd   #$0100
         os9   F$SRqMem
         bcs   L00D0
         stu   $08,y
         clrb
         bsr   L0086

* cute message:
* "by K.Kaplan, L.Crane, R.Doggett"
         fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
         fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
         fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
L0086    puls  x
         clra
L0089    eora  ,x+
         sta   ,u+
         decb
         cmpa  #$0D
         bne   L0089
L0092    sta   ,u+
         decb
         bne   L0092
         ldu   $03,y
         beq   MakDir
         ldx   $02,u
         lda   <$28,y
         sta   $07,x
         ldx   $04,u
         ldd   <$36,y
         beq   Seek
         leax  d,x
         lda   $01,y
         lsra
         rorb
         lsra
         rolb
         rola
         rorb
         rola
         pshs  y
         ldy   D.Proc
         ldu   D.SysPrc
         stu   D.Proc
         os9   I$Attach
         sty   D.Proc
         puls  y
         bcs   L00D0
         stu   PD.FST,y

* seek/delete routine
Seek
Delete    clra
         rts
L00CB    puls  pc,y

* ChgDir/MakDir entry
ChgDir
MakDir    comb
         ldb   #E$BPNam
L00D0    rts

Term    pshs  cc
         orcc  #$50
         ldx   PD.DEV,y
         bsr   L00F6
         ldx   PD.FST,y
         bsr   L00F6
         puls  cc
         tst   $02,y
         bne   L00F4
         ldu   PD.FST,y
         beq   L00EA
         os9   I$Detach
L00EA    ldu   PD.BUF,y
         beq   L00F4
         ldd   #$0100
         os9   F$SRtMem
L00F4    clra
         rts

L00F6    leax  ,x
         beq   L00F4
         ldx   $02,x
         ldb   ,y
         lda   $05,y
         pshs  y,x,b,a
         cmpa  $03,x
         bne   L013E
         ldx   D.Proc
         leax  <$30,x
         clra
L010C    cmpb  a,x
         beq   L013E
         inca
         cmpa  #$10
         bcs   L010C
         pshs  y
         ldd   #$1B0C
         bsr   L014E
         puls  y
         ldx   D.Proc
         lda   $01,x
         sta   ,s
         os9   F$GProcP
         leax  <$30,y
         ldb   $01,s
         clra
L012D    cmpb  a,x
         beq   L0138
         inca
         cmpa  #$10
         bcs   L012D
         clr   ,s
L0138    lda   ,s
         ldx   $02,s
         sta   $03,x
L013E    puls  pc,y,x,b,a

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
GetStat  ldx   PD.RGS,y
         lda   R$B,x
         cmpa  #$00
         beq   L018D
* Special for FM-11
         cmpa  #$25
         beq   L018E
*
         ldb   #D$GSTA $09
L014E    pshs  a
         clra
         ldx   $03,y
         ldu   $02,x
         ldx   ,x
         addd  M$Exec,x
         leax  d,x
         puls  a
         jmp   0,x

PutStat    lbsr  L04B1
         bsr   L016B
         pshs  b,cc
         lbsr  L0453
         puls  pc,b,cc

L016B    lda   R$B,u
         ldb   #D$PSTA   $0C
         cmpa  #$25
         beq   L01BC
         cmpa  #SS.Opt   $00
         bne   L014E
         pshs  y
         ldx   D.Proc
         lda   $06,x
         ldb   <D.SysTsk
         ldx   $04,u
         leau  <$20,y
         ldy   #$001A
         os9   F$Move
         puls  y
L018D    rts

L018E    ldb   $07,u
         beq   L01B7
         clra
         pshs  b,a
         ldy   $03,y
         ldy   $02,y
         lda   <$11,y
         sta   $01,u
         beq   L01B5
         ldx   D.Proc
         ldb   $06,x
         lda   <D.SysTsk
         ldx   <$12,y
         leax  $05,x
         ldu   $04,u
         ldy   ,s
         os9   F$Move
L01B5    leas  $02,s
L01B7    rts

L01B8    fcb   $4B,$53,$79,$f3

L01BC lda   $09,u
         pshs  u,y,a
         ldx   $03,y
         ldy   $02,x
         tsta
         beq   L0225
         tst   <$11,y
         bne   L0207
         ldd   #$0100
         os9   F$SRqMem
         bcs   L0223
         stu   <$12,y
         pshs  u
         clrb
L01DB    clr   ,u+
         decb
         bne   L01DB
         puls  u
         leax  >L03D2,pcr
         stx   ,u
         leax  >L055A,pcr
         stx   $02,u
         ldx   D.Proc
         pshs  y,x
         ldx   D.SysPrc
         stx   D.Proc
         leax  <L01B8,pcr
         lda   #$C1
         os9   F$Link
         puls  y,x
         stx   D.Proc
         bcs   L0223
         stu   <$14,y
L0207    lda   ,s
         sta   <$11,y
         ldx   D.Proc
         lda   $06,x
         ldb   <D.SysTsk
         ldu   <$12,y
         leau  $05,u
         ldx   $03,s
         ldy   $06,x
         beq   L0223
         ldx   $04,x
         os9   F$Move
L0223    puls  pc,u,y,a
L0225    lda   <$11,y
         beq   L025A
         ldu   D.Proc
         pshs  u
         ldu   D.SysPrc
         stu   D.Proc
         tsta
         bpl   L023D
         ldx   <$12,y
         lda   $04,x
         os9   I$Close
L023D    ldu   <$14,y
         beq   L0245
         os9   F$UnLink
L0245    puls  u
         stu   D.Proc
         ldu   <$12,y
         ldd   #$0100
         os9   F$SRtMem
         clra
         clrb
         std   <$14,y
         clr   <$11,y
L025A    puls  pc,u,y,a


Read    lbsr  L04B1
         bcs   L02B6
         inc   $0C,y
         ldx   $06,u
         beq   L02B3
         pshs  x
         lbsr  L0374
         lbsr  L03B9
         bcs   L027B
         tsta
         beq   L029B
         cmpa  PD.EOF,y
         bne   L0293
L0279    ldb   #E$EOF
L027B    leas  $02,s
         pshs  b
         bsr   L02AC
         comb
         puls  pc,b

L0284    tfr   x,d
         tstb
         bne   L028E
         lbsr  L042B
         ldu   $08,y
L028E    lbsr  L03B9
         bcs   L027B
L0293    tst   PD.EKO,y
         beq   L029B
         lbsr  L055A Print character
L029B    leax  $01,x
         sta   ,u+
         beq   L02A6
         cmpa  PD.EOR,y
         beq   L02AA
L02A6    cmpx  ,s
         bcs   L0284
L02AA    leas  $02,s
L02AC    lbsr  L042B
         ldu   $06,y
         stx   $06,u
L02B3    lbra  L0453
L02B6    rts


ReadLn    lbsr  L04B1
         bcs   L02B6
         ldx   $06,u
         beq   L02AC
         tst   $06,u
         beq   L02C7
         ldx   #$0100
L02C7    pshs  x
         ldd   #$FFFF
         std   $0D,y
         lbsr  L0374
L02D1    lbsr  L03B9
         lbcs  L035A
         tsta
         beq   L02F6
         ldb   #$29
L02DD    cmpa  b,y
         beq   L0316
         incb
         cmpb  #$31
         bls   L02DD
* Special for FM-11 start
         cmpa  #$0C
         beq   L0311
         cmpa  #$0B
         beq   L0311
         cmpa  #$15
         beq   L0311
         cmpa  #$16
         beq   L0311
L02F6    cmpx  $0D,y
         bls   L02FC
         stx   $0D,y
* Special for FM-11 end
L02FC    leax  $01,x
         cmpx  ,s
         bcs   L030C
         lda   <$33,y
         lbsr  L0390
         leax  -$01,x
         bra   L02D1
L030C    lbsr  L03F3
         sta   ,u+
L0311    lbsr  L0403
         bra   L02D1
L0316    pshs  pc,x
         leax  >L0329,pcr
         subb  #$29
         lslb
         leax  b,x
         stx   $02,s
         puls  x
         jsr   [,s++]
         bra   L02D1

L0329    bra   L037A
         bra   L0369
         bra   L033B
         bra   L0350
         bra   L0398
         bra   L03A1
         puls  pc
         bra   L0369
         bra   L0369

L033B    leas  $02,s
         sta   ,u
         lbsr  L0403
         ldu   $06,y
         leax  $01,x
         stx   $06,u
         lbsr  L042B
         leas  $02,s
         lbra  L0453
L0350    leas  $02,s
         leax  ,x
         lbeq  L0279
         bra   L02F6
L035A    pshs  b
         lda   #$0D
         sta   ,u
         bsr   L0393
         puls  b
         lbra  L027B
L0367    bsr   L037A
L0369    leax  ,x
         beq   L0374
         tst   <$23,y
         beq   L0367
         bsr   L0393
L0374    ldx   #$0000
         ldu   $08,y
         rts
L037A    leax  ,x
         beq   L03B8
         leau  -$01,u
         leax  -$01,x
         tst   <$22,y
         beq   L038D
         bsr   L038D
         lda   #$20
         bsr   L0390
L038D    lda   <$32,y
L0390    lbra  L0420
L0393    lda   #$0D
         lbra  L0420
L0398    lda   <$2B,y
         sta   ,u
         bsr   L0374
L039F    bsr   L0408
L03A1    cmpx  $0D,y
         beq   L03B8
         leax  $01,x
         cmpx  $02,s
         bcc   L03B6
         lda   ,u+
         beq   L039F
         cmpa  <$2B,y
         bne   L039F
         leau  -$01,u
L03B6    leax  -$01,x
L03B8    rts

L03B9    pshs  u,y,x
         ldx   $03,y
         ldu   $02,x
         ldx   <$14,u
         beq   L03D4
         ldd   $09,x
         jsr   d,x
         puls  pc,u,y,x

L03CA    pshs  u,y,x
         ldx   $0A,y
         ldu   $03,y
         bra   L03DA
L03D2    pshs  u,y,x
L03D4    ldx   $03,y
         ldu   $0A,y
         beq   L03E1
L03DA    ldu   $02,u
         ldb   <$28,y
         stb   $07,u
L03E1    leax  ,x
         beq   L03F1
         tfr   u,d
         ldu   $02,x
         std   $09,u
         ldu   #$0003
         lbsr  L05C3
L03F1    puls  pc,u,y,x

* Check for forced uppercase
L03F3    tst   <$21,y
         beq   L0402
         cmpa  #$61
         bcs   L0402
         cmpa  #$7A
         bhi   L0402
         suba  #$20
L0402    rts

* Check for printable character
L0403    tst   <$24,y
         beq   L0402
L0408    cmpa  #$20
         bcc   L0420
         cmpa  #$0C
         beq   L0420
         cmpa  #$0B
         beq   L0420
         cmpa  #$15
         beq   L0420
         cmpa  #$16
         beq   L0420
         cmpa  #$0D
         bne   L0423
L0420    lbra  L055A Print character

* Non-printable character
L0423    pshs  a
         lda   #'.
         bsr   L0420
         puls  pc,a

L042B    pshs  y,x
         ldd   ,s
         beq   L0451
         tstb
         bne   L0435
         deca
L0435    clrb
         ldu   $06,y
         ldu   $04,u
         leau  d,u
         clra
         ldb   $01,s
         bne   L0442
         inca
L0442    pshs  b,a
         lda   <D.SysTsk
         ldx   D.Proc
         ldb   $06,x
         ldx   $08,y
         puls  y
         os9   F$Move
L0451    puls  pc,y,x
L0453    ldx   D.Proc
         lda   ,x
         ldx   $03,y
         bsr   L045D
         ldx   $0A,y
L045D    beq   L0467
         ldx   $02,x
         cmpa  $04,x
         bne   L0467
         clr   $04,x
L0467    rts

L0468    pshs  x,a
         ldx   $02,x
         pshs  cc
         orcc  #$50
         lda   $04,x
         beq   L0490
         cmpa  $01,s
         beq   L04AC
         puls  cc
         pshs  a
         bsr   L0453
         puls  a
         os9   F$IOQu
         inc   $0F,y
         ldx   D.Proc
         ldb   P$Signal,X
         puls  x,a
         beq   L0468
         coma
         rts

L0490    lda   $01,s
         sta   $04,x
         sta   $03,x
         lda   <$2F,y
         sta   $0D,x
         ldd   <$30,y
         std   $0B,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   L04AC
         sta   $06,x
L04AC    puls  cc
         clra
         puls  pc,x,a

* Wait for device 
L04B1    ldx   D.Proc Get current process ID
         lda   P$ID,x         Get process ID #
         clr   $0F,y
         ldx   $03,y
         bsr   L0468
         bcs   L04CB
         ldx   $0A,y
         beq   L04C5
         bsr   L0468
         bcs   L04CB
L04C5    tst   $0F,y
         bne   L04B1
         clr   $0C,y
L04CB    ldu   $06,y
         rts

WriteLn    bsr   L04B1
         bra   L04D6

Write    bsr   L04B1
         inc   $0C,y
L04D6    ldx   $06,u
         beq   L054F
         pshs  x
         ldx   #$0000
         bra   L04E6
L04E1    tfr   u,d
         tstb
         bne   L0518
L04E6    pshs  y,x
         ldd   ,s
         ldu   $06,y
         ldx   $04,u
         leax  d,x
         ldd   $06,u
         subd  ,s
         cmpd  #$0020
         bls   L04FD
         ldd   #$0020
L04FD    pshs  b,a
         ldd   $08,y
         inca
         subd  ,s
         tfr   d,u
         lda   #$0D
         sta   -$01,u
         ldy   D.Proc
         lda   $06,y
         ldb   D.SysTsk
         puls  y
         os9   F$Move
         puls  y,x
L0518    lda   ,u+
         tst   $0C,y
         bne   L0532
         lbsr  L03F3
         cmpa  #$0A
         bne   L0532
         lda   #$0D
         tst   <$25,y
         bne   L0532
         bsr   L0566
         bcs   L0552
         lda   #$0A
L0532    bsr   L0566
         bcs   L0552
         leax  $01,x
         cmpx  ,s
         bcc   L0549
         lda   -$01,u
         beq   L04E1
         cmpa  <$2B,y
         bne   L04E1
         tst   $0C,y
         bne   L04E1
L0549    leas  $02,s
L054B    ldu   $06,y
         stx   $06,u
L054F    lbra  L0453
L0552    leas  $02,s
         pshs  b,cc
         bsr   L054B
         puls  pc,b,cc

* Print character
L055A    pshs  u,x,a
         ldx   $0A,y
         beq   L05BA
         cmpa  #$0D
         bne   L05BC
         bra   L0595
L0566    pshs  u,x,a
         ldx   $03,y
         cmpa  #$0D
         bne   L05BC
         ldu   $02,x
         tst   $08,u
         bne   L0583
         tst   <$27,y
         beq   L0595
         tst   $0C,y
         bne   L0595
         dec   $07,u
         bne   L0595
         bra   L058D
L0583    lbsr  L03CA
         bcs   L058D
         cmpa  <$2F,y
         bne   L0583
L058D    lbsr  L03CA
         cmpa  <$2F,y
         beq   L058D
L0595    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   L05C0
         tst   $0C,y
         bne   L05BA
         ldb   <$26,y
         pshs  b
         tst   <$25,y
         beq   L05B1
         lda   #$0A
L05AD    bsr   L05C0
         bcs   L05B8
L05B1    lda   #$00
         dec   ,s
         bpl   L05AD
         clra
L05B8    leas  $01,s
L05BA    puls  pc,u,x,a

L05BC    bsr   L05C0
         puls  pc,u,x,a

L05C0    ldu   #$0006
L05C3    pshs  u,y,x,a
         ldu   $02,x
         clr   $05,u
         ldx   ,x
         ldd   $09,x
         addd  $05,s
         leax  d,x
         lda   ,s+
         jsr   ,x
         puls  pc,u,y,x
         emod
SCFEnd      equ   *
