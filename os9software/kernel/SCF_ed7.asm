*
* Original edition from GMX 1.2
* Header for:  SCF
* Module size: $0419    #1049
* Module CRC:  $04D9E6 (Good)
* Hdr parity:  $F5
* Edition:     $07      #7
* Ty/La At/Rv: $D1 $81
* File Man mod, 6809 obj, re-en, R/O

         nam   SCF
         ttl   os9 file manager

 use defsfile

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   0
size     equ   .
name     equ   *
         fcs   /SCF/
         fcb   $07
start    equ   *
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
Create    ldx   $03,y
         stx   <$3B,y
         ldu   $06,y
         ldx   $04,u
         pshs  y
         os9   F$PrsNam
         bcs   L00C7
         lda   -$01,y
         bmi   L0053
         leax  ,y
         os9   F$PrsNam
         bcc   L00C7
L0053    sty   $04,u
         puls  y
         lda   #$01
         bita  $01,y
         beq   L009C
         ldd   #$0001
         os9   F$SRqMem
         bcs   L00CC
         stu   $08,y
         clrb
         bsr   L008B

* cute message:
* "by K.Kaplan, L.Crane, R.Doggett"
         fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
         fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
         fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
L008B    puls  x                       get PC into X
         clra
L008E    eora  ,x+
         sta   ,u+
         decb
         cmpa  #$0D
         bne   L008E
L0097    sta   ,u+
         decb
         bne   L0097
L009C    ldu   $03,y
         beq   MakDir
         ldx   $02,u
         lda   <$28,y
         sta   $07,x
         ldx   $04,u
         ldd   <$36,y
         beq   Seek
         leax  d,x
         lda   $01,y
         anda  #$02
         asra
         pshs  a
         lda   $01,y
         anda  #$01
         lsla
         ora   ,s+
         os9   I$Attach
         bcs   L00CC
         stu   $0A,y
* seek/delete routine
Seek
Delete    clra
         rts
L00C7    puls  pc,y

* ChgDir/MakDir entry
ChgDir
MakDir   comb
         ldb   #$D7
L00CC    rts
Term    tst   $02,y
         bne   L00E3
         ldu   $0A,y
         beq   L00D8
         os9   I$Detach
L00D8    ldu   $08,y
         beq   L00E2
         ldd   #$0001
         os9   F$SRtMem
L00E2    clra
L00E3    rts

GetStat    ldx   $06,y
         lda   $02,x
         cmpa  #$00
         beq   L011C
         pshs  a
         ldd   #$0009
L00F1    ldx   $03,y
         ldu   $02,x
         ldx   ,x
         addd  $09,x
         leax  d,x
         puls  a
         jmp   ,x
PutStat    ldx   $06,y
         lda   $02,x
         cmpa  #$00
         beq   L010E
         pshs  a
         ldd   #$000C
         bra   L00F1
L010E    ldx   $04,x
         leay  <$20,y
         ldb   #$1A
L0115    lda   ,x+
         sta   ,y+
         decb
         bne   L0115
L011C    clrb
         rts
         comb
         ldb   #$D0
L0121    rts

Read    lbsr  L0328
         bcs   L0121
         inc   $0C,y
         ldx   $06,u
         beq   L016A
         pshs  x
         ldx   #$0000
         ldu   $04,u
         lbsr  L027F
         bcs   L0143
         tsta
         beq   L0159
         cmpa  <$2C,y
         bne   L0151
L0141    ldb   #$D3
L0143    leas  $02,s
         pshs  b
         bsr   L016A
         comb
         puls  pc,b
L014C    lbsr  L027F
         bcs   L0143
L0151    tst   <$24,y
         beq   L0159
         lbsr  L0399
L0159    leax  $01,x
         sta   ,u+
         beq   L0164
         cmpa  <$2B,y
         beq   L0168
L0164    cmpx  ,s
         bcs   L014C
L0168    leas  $02,s
L016A    ldu   $06,y
         stx   $06,u
         lbra  L02D2
ReadLn    lbsr  L0328
         bcs   L0121
         ldx   $06,u
         beq   L016A
         tst   $06,u
         beq   L0181
         ldx   #$0100
L0181    pshs  x
         ldd   #$FFFF
         std   $0D,y
         lbsr  L0232
L018B    lbsr  L027F
         lbcs  L0218
         anda  #$7F
         beq   L01A1
         ldb   #$29
L0198    cmpa  b,y
         beq   L01CA
         incb
         cmpb  #$31
         bls   L0198
L01A1    cmpx  $0D,y
         bls   L01A7
         stx   $0D,y
L01A7    leax  $01,x
         cmpx  ,s
         bcs   L01B7
         lda   <$33,y
         lbsr  L0250
         leax  -$01,x
         bra   L018B
L01B7    lbsr  L02A0
         sta   ,u+
         cmpa  #$0A
         bra   L01C5
         lbsr  L0252
         lda   #$0A
L01C5    lbsr  L02B0
         bra   L018B
L01CA    pshs  pc,x
         leax  >L01DD,pcr
         subb  #$29
         lslb
         leax  b,x
         stx   $02,s
         puls  x
         jsr   [,s++]
         bra   L018B
L01DD    bra   L0238
         bra   L0227
         bra   L01EF
         bra   L020E
         bra   L0256
         bra   L025F
         puls  pc
         bra   L0227
         bra   L0227
L01EF    leas  $02,s
         sta   ,u
         lbsr  L02B0
         ldu   $06,y
         leax  $01,x
         stx   $06,u
         ldx   $04,u
         ldu   $08,y
L0200    lda   ,u+
         sta   ,x+
         cmpa  <$2B,y
         bne   L0200
         leas  $02,s
         lbra  L02D2
L020E    leas  $02,s
         leax  ,x
         lbeq  L0141
         bra   L01A1
L0218    pshs  b
         lda   #$0D
         sta   ,u
         bsr   L0252
         puls  b
         lbra  L0143
L0225    bsr   L0238
L0227    leax  ,x
         beq   L0232
         tst   <$23,y
         beq   L0225
         bsr   L0252
L0232    ldx   #$0000
         ldu   $08,y
         rts
L0238    leax  ,x
         lbeq  L02BE
         leau  -$01,u
         leax  -$01,x
         tst   <$22,y
         beq   L024D
         bsr   L024D
         lda   #$20
         bsr   L0250
L024D    lda   <$32,y
L0250    bra   L02C7
L0252    lda   #$0D
         bra   L02C7
L0256    lda   <$2B,y
         sta   ,u
         bsr   L0232
L025D    bsr   L02BF
L025F    cmpx  $0D,y
         beq   L0276
         leax  $01,x
         cmpx  $02,s
         bcc   L0274
         lda   ,u+
         beq   L025D
         cmpa  <$2B,y
         bne   L025D
         leau  -$01,u
L0274    leax  -$01,x
L0276    rts
L0277    pshs  u,y,x
         ldx   $0A,y
         ldu   $03,y
         bra   L0287
L027F    pshs  u,y,x
         ldx   $03,y
         ldu   $0A,y
         beq   L028E
L0287    ldu   $02,u
         ldb   <$28,y
         stb   $07,u
L028E    leax  ,x
         beq   L029E
         tfr   u,d
         ldu   $02,x
         std   $09,u
         ldu   #$0003
         lbsr  L0402
L029E    puls  pc,u,y,x
L02A0    tst   <$21,y
         beq   L02AF
         cmpa  #$61
         bcs   L02AF
         cmpa  #$7A
         bhi   L02AF
         suba  #$20
L02AF    rts
L02B0    tst   <$24,y
         bne   L02BF
         cmpa  #$0D
         bne   L02BE
         tst   <$25,y
         bne   L02BF
L02BE    rts
L02BF    cmpa  #$20
         bcc   L02C7
         cmpa  #$0D
         bne   L02CA
L02C7    lbra  L0399
L02CA    pshs  a
         lda   #$2E
         bsr   L02C7
         puls  pc,a
L02D2    ldx   D.Proc
         lda   ,x
         ldx   $03,y
         bsr   L02DC
         ldx   $0A,y
L02DC    beq   L02E6
         ldx   $02,x
         cmpa  $04,x
         bne   L02E6
         clr   $04,x
L02E6    rts
L02E7    pshs  x,a
         ldx   $02,x
         lda   $04,x
         beq   L0309
         cmpa  ,s
         beq   L0325
         pshs  a
         bsr   L02D2
         puls  a
         os9   F$IOQu
         inc   $0F,y
         ldx   D.Proc
         ldb   <$36,x
         puls  x,a
         beq   L02E7
         coma
         rts
L0309    lda   ,s
         sta   $04,x
         sta   $03,x
         lda   <$2F,y
         sta   $0D,x
         ldd   <$30,y
         std   $0B,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   L0325
         sta   $06,x
L0325    clra
         puls  pc,x,a
L0328    ldx   D.Proc
         lda   ,x
         clr   $0F,y
         ldx   $03,y
         bsr   L02E7
         bcs   L0342
         ldx   $0A,y
         beq   L033C
         bsr   L02E7
         bcs   L0342
L033C    tst   $0F,y
         bne   L0328
         clr   $0C,y
L0342    ldu   $06,y
         rts

WriteLn    bsr   L0328
         bra   L034D
Write    bsr   L0328
         inc   $0C,y
L034D    ldx   $04,u
         ldu   $06,u
         beq   L0390
L0353    lda   ,x+
         tst   $0C,y
         bne   L036F
         anda  #$7F
         lbsr  L02A0
         cmpa  #$0A
         bne   L036F
         lda   #$0D
         tst   <$25,y
         bne   L036F
         bsr   L03A5
         bcs   L0393
         lda   #$0A
L036F    bsr   L03A5
         bcs   L0393
         leau  -$01,u
         cmpu  #$0000
         bls   L0390
         lda   -$01,x
         beq   L0353
         cmpa  <$2B,y
         bne   L0353
         tst   $0C,y
         bne   L0353
L0388    ldu   $06,y
         tfr   x,d
         subd  $04,u
         std   $06,u
L0390    lbra  L02D2
L0393    pshs  b,cc
         bsr   L0388
         puls  pc,b,cc
L0399    pshs  u,x,a
         ldx   $0A,y
         beq   L03F9
         cmpa  #$0D
         bne   L03FB
         bra   L03D4
L03A5    pshs  u,x,a
         ldx   $03,y
         cmpa  #$0D
         bne   L03FB
         ldu   $02,x
         tst   $08,u
         bne   L03BE
         tst   <$27,y
         beq   L03D4
         dec   $07,u
         bne   L03D4
         bra   L03CA
L03BE    lbsr  L0277
         bcs   L03CA
         anda  #$7F
         cmpa  <$2F,y
         bne   L03BE
L03CA    lbsr  L0277
         anda  #$7F
         cmpa  <$2F,y
         beq   L03CA
L03D4    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   L03FF
         tst   $0C,y
         bne   L03F9
         ldb   <$26,y
         pshs  b
         tst   <$25,y
         beq   L03F0
         lda   #$0A
L03EC    bsr   L03FF
         bcs   L03F7
L03F0    lda   #$00
         dec   ,s
         bpl   L03EC
         clra
L03F7    leas  $01,s
L03F9    puls  pc,u,x,a
L03FB    bsr   L03FF
         puls  pc,u,x,a
L03FF    ldu   #$0006
L0402    pshs  u,y,x,a
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
eom      equ   *
