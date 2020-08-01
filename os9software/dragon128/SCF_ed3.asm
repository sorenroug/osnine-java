 nam   SCF
 ttl   Sequential Character file manager

* This is a LEVEL 2 module
* Originally from Dragon 128

 use defsfile

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   SCFEnd,SCFNam,tylg,atrv,SCFEnt,0

SCFNam   equ   *
         fcs   /SCF/
         fcb   3

SCFEnt   equ   *
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

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
Open
Create   ldx   PD.DEV,y
         stx   <$3D,y
         ldu   PD.RGS,y
         pshs  y
         ldx   R$X,u
         os9   F$PrsNam
         lbcs  L00D3
         tsta
         bmi   L0054
         leax  ,y
         os9   F$PrsNam
         bcc   L00D3
L0054    sty   R$X,u        Save updated name pointer to caller
         puls  y
         ldd   #$0200     Specific for DRG128
         os9   F$SRqMem
         bcs   L00D8
         stu   PD.BUF,y

 ifeq CPUType-DRG128
         clr   >$0100,u
         clr   >$0103,u
 endc
         clrb
         bsr   L008E

* cute message:
* "by K.Kaplan, L.Crane, R.Doggett"
         fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
         fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
         fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
L008E    puls  x
         clra
L0091    eora  ,x+
         sta   ,u+
         decb
         cmpa  #$0D
         bne   L0091
L009A    sta   ,u+
         decb
         bne   L009A

         ldu   PD.DEV,y     Get device table entry address
         beq   MakDir
         ldx   V$STAT,u
         lda   PD.PAG,y  Get lines per page
         sta   V.LINE,x
         ldx   V$DESC,u
         ldd   PD.D2P,y
         beq   Seek
         leax  d,x
         lda   PD.MOD,y
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
         bcs   L00D8
         stu   PD.FST,y

* seek/delete routine
Seek
Delete   clra
         rts

L00D3    puls  pc,y

* ChgDir/MakDir entry
ChgDir
MakDir    comb
         ldb   #E$BPNam
L00D8    rts

Term     pshs  cc
         orcc  #$50
         ldx   PD.DEV,y
         bsr   L00FE
         ldx   PD.FST,y
         bsr   L00FE
         puls  cc
         tst   PD.CNT,y
         bne   L00FC
         ldu   PD.FST,y
         beq   L00F2
         os9   I$Detach
L00F2    ldu   PD.BUF,y
         beq   L00FC
         ldd   #$0200     Specific for DRG128
         os9   F$SRtMem
L00FC    clra
         rts

L00FE    leax  ,x
         beq   L00FC
         ldx   V$STAT,x
         ldb   ,y
         lda   PD.CPR,y
         pshs  y,x,b,a
         cmpa  V.LPRC,x
         bne   L0147
         ldx   D.Proc
         leax  <$30,x
         clra
L0114    cmpb  a,x
         beq   L0147
         inca
         cmpa  #$10
         bcs   L0114
         pshs  y
         ldd   #$1B0C
         lbsr  L0223
         puls  y
         ldx   D.Proc
         lda   $01,x
         sta   ,s
         os9   F$GProcP
         leax  <$30,y
         ldb   $01,s
         clra
L0136    cmpb  a,x
         beq   L0141
         inca
         cmpa  #$10
         bcs   L0136
         clr   ,s
L0141    lda   ,s
         ldx   $02,s
         sta   $03,x
L0147    puls  pc,y,x,b,a

  ifeq CPUType-DRG128
* Set macro
L0149    lda   $06,u
         beq   L019A
         bsr   L01A4
         ldb   $07,u
         beq   L019A
         ldx   PD.BUF,y
         leax  >$0200,x
         pshs  x
         leax  >-$00FD,x
L015F    lda   ,x+
         beq   L016C
         ldb   ,x+
         abx
         cmpx  ,s
         bcc   L019E
         bra   L015F
L016C    ldb   $07,u
         pshs  x
         abx
         leax  $01,x
         cmpx  $02,s
         bhi   L019C
         beq   L017B
         clr   ,x
L017B    puls  x
         stb   ,x+
         clra
         pshs  y,b,a
         lda   $06,u
         sta   -$02,x
         ldy   D.Proc
         lda   $06,y
         ldb   D.SysTsk
         ldu   $04,u
         exg   x,u
         puls  y
         os9   F$Move
         puls  y
         leas  $02,s
L019A    clrb
         rts
L019C    leas  $02,s
L019E    leas  $02,s
         comb
         ldb   #E$MemFul
         rts

* Clear macro
L01A4    ldx   PD.BUF,y
         leax  >$0100,x
         lda   $06,u
         beq   L01F3
         leax  >$0100,x
         pshs  x
         leax  >-$00FD,x
L01B8    cmpa  ,x
         beq   L01C9
         tst   ,x+
         beq   L01EF
         ldb   ,x+
         abx
         cmpx  ,s
         bcs   L01B8
         bra   L01EF
L01C9    ldb   $01,x
         pshs  y
         tfr   x,y
         abx
         leax  $02,x
L01D2    cmpx  $02,s
         bcc   L01EB
         tst   ,x
         beq   L01EB
         lda   ,x+
         sta   ,y+
         ldb   ,x+
         stb   ,y+
L01E2    lda   ,x+
         sta   ,y+
         decb
         bne   L01E2
         bra   L01D2
L01EB    clr   ,y
         puls  y
L01EF    leas  $02,s
         clrb
         rts
L01F3    clr   $03,x
         rts
  endc

* Scan for macro codes
* If not found then set carry
L01F6    ldx   PD.BUF,y
         leax  >$0200,x
         pshs  x
         leax  >-$00FD,x
L0202    tst   ,x+
         beq   L0211
         ldb   ,x+
         cmpa  -$02,x
         beq   L0212
         abx
         cmpx  ,s
         bcs   L0202
L0211    comb
L0212    leas  $02,s
         rts

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
GetStat  ldx   PD.RGS,y
         lda   R$B,x
 ifeq CPUType-DRG128
         cmpa  #SS.Edit   $1C
         beq   L026B
 endc
         cmpa  #$00
         beq   L026A
         ldb   #D$GSTA $09
L0223    pshs  a
         clra
         ldx   PD.DEV,y
         ldu   V$STAT,x
         ldx   V$DRIV,x
         addd  M$Exec,x
         leax  d,x
         puls  a
         jmp   0,x    Call device driver

PutStat  lbsr  L0753
         bsr   L0240
         pshs  b,cc
         lbsr  L06FD
         puls  pc,b,cc

L0240    lda   R$B,u
  ifeq CPUType-DRG128
         cmpa  #SS.SMac $1D
         lbeq  L0149
         cmpa  #SS.CMac  $1E
         lbeq  L01A4
 endc
         ldb   #D$PSTA   $0C
         cmpa  #SS.Opt   $00
         bne   L0223
         pshs  y
         ldx   D.Proc
         lda   P$Task,x
         ldb   D.SysTsk
         ldx   $04,u
         leau  PD.OPT,y
         ldy   #$001C
         os9   F$Move
         puls  y
L026A    rts

  ifeq CPUType-DRG128
L026B    lbsr  L0753
         bcs   L026A
         ldx   $06,u
         lbeq  L034A
         tst   $06,u
         beq   L027D
         ldx   #$0100
L027D    pshs  y,x
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         ldx   $04,u
         ldu   PD.BUF,y
         ldy   ,s
         os9   F$Move
         puls  y,x
         tfr   u,d
         leax  d,x
         pshs  x
         lbsr  L0615
         ldu   $06,y
         lda   $09,u
         pshs  b
         cmpa  ,s+
         bcs   L02A6
         tfr   b,a
L02A6    pshs  a
         subb  ,s+
         pshs  b
         tfr   a,b
         clra
         addd  $08,y
         tfr   d,u
         ldb   ,s+
         beq   L02B9
         bsr   L02BC
L02B9    lbra  L03B8
L02BC    pshs  b
         lbra  L05B1
 endc

Read     lbsr  L0753
         bcs   L026A
         inc   $0C,y
         ldx   $06,u
         lbeq  L0351
         pshs  x
         ldu   PD.BUF,y
         ldx   #$0000

 ifeq CPUType-DRG128
* Start test for macros - lead-in
         pshs  x,a
         ldx   >$0101,u
         ldb   >$0100,u
         bne   L0354
         puls  x,a
* End test for macros
 endc

         lbsr  L0688
         bcs   L02F2
         tsta
         beq   L0339
         cmpa  PD.EOF,y
         bne   L030A
L02F0    ldb   #E$EOF
L02F2    leas  $02,s
         pshs  b
         bsr   L034A
         comb
         puls  pc,b

L02FB    tfr   x,d
         tstb
         bne   L0305
         lbsr  L06D5
         ldu   PD.BUF,y
L0305    lbsr  L0688
         bcs   L02F2

L030A

 ifeq CPUType-DRG128
* Start test for macros
         pshs  x,a
         pshs  y
         lbsr  L0432
         bcs   L0326
         cmpa  <$1C,y
         bne   L0326
         ldy   ,s
         lbsr  L0688
         ora   #$80
         bcc   L0326
         leas  $05,s
         bra   L02F2

L0326    puls  y
         sta   ,s
         lbsr  L01F6
         bcc   L0354
         puls  x,a
* End test for macros
 endc
         tst   PD.EKO,y
         beq   L0339
         lbsr  L07FC Print character
L0339    leax  $01,x
         sta   ,u+
         beq   L0344
         cmpa  PD.EOR,y
         beq   L0348
L0344    cmpx  ,s
         bcs   L02FB
L0348    leas  $02,s
L034A    lbsr  L06D5
         ldu   $06,y
         stx   $06,u
L0351    lbra  L06FD

 ifeq CPUType-DRG128
* Start test for macros
L0354    leas  $01,s
         pshs  x,b
L0358    ldx   $01,s
         lda   ,x+
         sta   ,u+
         stx   $01,s
         dec   ,s
         tst   PD.EKO,y
         beq   L036A
         lbsr  L07FC Print character
L036A    ldx   $03,s
         leax  $01,x
         stx   $03,s
         cmpx  $05,s
         bcc   L0387
         tfr   x,d
         tstb
         bne   L037E
         lbsr  L06D5
         ldu   PD.BUF,y
L037E    tst   ,s
         bne   L0358
         leas  $05,s
         lbra  L0305
L0387    ldx   PD.BUF,y
         puls  b
         stb   >$0100,x
         puls  b,a
         std   >$0101,x
         puls  x
         bra   L0348
* End test for macros
 endc

* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
ReadLn   lbsr  L0753        Go wait for device to be ready for us
         lbcs  L026A
         ldx   R$Y,u        Get character count
         beq   L034A
         tst   R$Y,u               Past 256 bytes?
         beq   L03AB
         ldx   #$0100       Get new character count
L03AB    tfr   x,d
         addd  PD.BUF,y
         pshs  b,a
         lbsr  L0571
 ifeq CPUType-DRG128
         clr   >$0100,u   Buffer for lead-in match?
 endc
L03B8    lbsr  L0688
         lbcs  L049C
         tsta
         beq   L03F9
         ldb   #PD.BSP Test special characters
L03C4    cmpa  b,y
         beq   L0418
         incb
         cmpb  #PD.QUT
         bls   L03C4

 ifeq CPUType-DRG128
* Start test for macros
         pshs  y
         bsr   L0432
         bcs   L03F4
         cmpa  <$1C,y
         bne   L03E6
         pshs  y
         ldy   $02,s
         lbsr  L0688
         puls  y
         bcs   L0411
         ora   #$80
L03E6    ldb   #$32
         leay  <$20,y
L03EB    cmpa  ,y+
         beq   L0416
         incb
         cmpb  #$35
         bls   L03EB
L03F4    puls  y
         lbra  L0623
* End test for macros
 endc

L03F9    leax  1,x
         cmpx  ,s
         leax  -1,x
         bcs   L0409
L0401    lda   PD.OVF,y
         lbsr  L0590 Print character
         bra   L03B8

L0409    lbsr  L06A9
         lbsr  L05E0
         bra   L03B8
L0411    puls  y
         lbra  L049C

L0416    puls  y
L0418    pshs  pc,x
         leax  >L044A,pcr    Point to branch table
         subb  #$29
         pshs  a
         lslb
         ldd   b,x
         leax  d,x
         puls  a
         stx   $02,s
         puls  x
         jsr   [,s++]       Execute routine
         lbra  L03B8

* Process "Edit" character
* Sets Y
L0432    pshs  a
         lda   <$3B,y   PD.Edit,y
         pshs  a
         ldy   PD.DEV,y
         ldy   V$DESC,y
         leay  <$12,y
         coma
         lda   ,s+     No-edit flag set?
         bne   L0448  ..yes
         clra    Clear carry
L0448    puls  pc,a

L044A
 fdb L0576-L044A        Process PD.BSP
 fdb L04A8-L044A        Process PD.DEL
 fdb L0464-L044A        Process PD.EOR
 fdb L048E-L044A        Process PD.EOF
 fdb L060C-L044A        Process PD.RPR
 fdb L0615-L044A        Process PD.DUP
 fdb L04D7-L044A        Process PD.PSC
 fdb L04A8-L044A   Process PD.INT
 fdb L04A8-L044A   Process PD.QUT
 fdb L055A-L044A   $0110
 fdb L0543-L044A   $00F9
 fdb L05BA-L044A   $0170
 fdb L04EC-L044A   $00A2



* Process PD.EOR character
L0464    leas  $02,s
         bsr   L0482
         lbsr  L06B9
         ldu   $06,y
         bsr   L047B
         leax  $01,x
         stx   $06,u
         lbsr  L06D5
         leas  $02,s
         lbra  L06FD
L047B    exg   x,d
         subd  $08,y
         exg   d,x
         rts

L0482    lda   #$0D
         sta   ,x
         rts

L0487    pshs  x
         cmpu  ,s
         puls  pc,x

* Process PD.EOF
L048E    leas  $02,s
         cmpx  PD.BUF,y
         lbne  L03F9
         ldx   #$0000
         lbra  L02F0

L049C    pshs  b
         bsr   L0482
         lbsr  L0607
         puls  b
         lbra  L02F2

* Process interrupt
L04A8    tfr   u,d
         subd  PD.BUF,y
         beq   L04D7
         pshs  b
         pshs  b
         pshs  b
         pshs  y
         ldy   PD.BUF,y
         bsr   L0487
         bcc   L04C7
L04BD    lda   ,u+
         sta   ,y+
         inc   $04,s
         bsr   L0487
         bcs   L04BD
L04C7    leax  ,y
         puls  y
         ldu   PD.BUF,y
         tst   PD.DLO,y
         beq   L04D8
         leas  $03,s
         lbra  L0607
L04D7    rts

L04D8    bsr   L050E
         dec   ,s
         bne   L04D8
         lbsr  L05CA
L04E1    bsr   L0509
         dec   $01,s
         bne   L04E1
         leas  $02,s
         lbra  L05B1

L04EC    clr   ,-s
         pshs  u,x
         leax  ,u
L04F2    cmpu  ,s
         beq   L04FF
         leau  $01,u
         bsr   L0509
         inc   $04,s
         bra   L04F2
L04FF    puls  u,b,a
         tst   ,s
         lbne  L05B1
         puls  pc,b
L0509    lda   #$20
         lbra  L06B9

L050E    pshs  y
         lbsr  L0432
         bcs   L0519
         ldb   #$1E
         bra   L0527

L0519    puls  y
         lbra  L058D

L051E    pshs  y
         ldb   #$1F
         lbsr  L0432
         bcs   L0541
L0527    pshs  x
         leax  ,y
         ldy   $02,s
         lda   b,x
         bpl   L053F
         anda  #$7F
         pshs  a
         lda   <$1D,x
         beq   L053D
         bsr   L0590 Print lead-out character
L053D    puls  a
L053F    bsr   L0590 Print character
L0541    puls  pc,y,x

L0543    bsr   L0593
         bcc   L054E
         bsr   L051E
         bcs   L054D
         leau  $01,u
L054D    rts
L054E    tfr   u,d
         subd  $08,y
         beq   L054D
         pshs  b
         ldu   $08,y
         bra   L05B1

L055A    cmpu  $08,y
         beq   L0566
         bsr   L050E
         bcs   L0565
         leau  -$01,u
L0565    rts

L0566    bsr   L0593
         beq   L0570
         leau  $01,u
         bsr   L051E
         bcc   L0566
L0570    rts

L0571    ldx   PD.BUF,y
         tfr   x,u
         rts

* Process PD.BSP 
L0576    cmpu  PD.BUF,y  Empty buffer?
         beq   L0570 ..yes
         bsr   L0593
         bne   L0596
         leau  -1,u
         leax  -1,x
         tst   PD.BSO,y
         beq   L058D
         bsr   L058D   Print backspace char
         lbsr  L0509   Print space
L058D    lda   PD.BSE,y
L0590    lbra  L06CA Print character

L0593    lbra  L0487

L0596    lbsr  L050E
         leau  -1,u
L059B    pshs  u
L059D    lda   1,u
         sta   ,u+
         bsr   L0593
         bcs   L059D
         puls  u
         leax  -1,x
         bsr   L05CA
L05AB    incb
         pshs  b
         lbsr  L0509
L05B1    lbsr  L050E
         dec   ,s
         bne   L05B1
         puls  pc,a

L05BA    bsr   L0593
         bcc   L05C9
         leax  -$01,x
         clrb
         bsr   L0593
         bcc   L05AB
         leax  $01,x
         bra   L059B
L05C9    rts

L05CA    clrb
         pshs  u,b
L05CD    bsr   L0593
         bcc   L05DE
         lda   ,u+
         cmpa  #$0D Stop at carriage return
         beq   L05DE
         lbsr  L06B9
         inc   ,s
         bra   L05CD
L05DE    puls  pc,u,b

L05E0    bsr   L0593
         bcs   L05EB
         sta   ,u+
         leax  $01,x
         lbra  L06B9
L05EB    pshs  u
         leau  ,x
L05EF    ldb   ,-u
         stb   $01,u
         cmpu  ,s
         bne   L05EF
         leas  $02,s
         sta   ,u
         leax  $01,x
         bsr   L05CA
         leau  $01,u
         decb
         pshs  b
         bra   L05B1
L0607    lda   #$0D
         lbra  L06CA Print character

L060C    lbsr  L0482
         lbsr  L0571
         lbsr  L06BE
L0615    ldx   $02,s
         bsr   L05CA
         clra
         pshs  u
         addd  ,s++
         tfr   d,x
         leau  ,x
         rts

 ifeq CPUType-DRG128
* Start test for macros
L0623    pshs  x,a
         lbsr  L01F6
         bcc   L062F
         puls  x,a
         lbra  L03F9
* End test for macros
 endc

L062F    leas  $01,s
         pshs  x,b
         ldx   $03,s
         abx
         cmpx  $05,s
         bcs   L0641
         leas  $03,s
         puls  x
         lbra  L0401
L0641    pshs  u
         cmpu  $05,s
         bcc   L0659
         ldu   $05,s
         tfr   u,d
         subd  ,s
L064E    lda   ,-u
         sta   ,-x
         decb
         bne   L064E
         ldu   ,s
         ldb   $02,s
L0659    ldx   $03,s
L065B    lda   ,x+
         sta   ,u+
         decb
         bne   L065B
         ldx   $05,s
         ldb   $02,s
         abx
         stu   $03,s
         ldu   ,s
         lbsr  L05CA
         subb  $02,s
         beq   L0674
         bsr   L067B
L0674    ldu   $03,s
         leas  $07,s
         lbra  L03B8
L067B    pshs  b
         lbra  L05B1

L0680    pshs  u,y,x
         ldx   PD.FST,y
         ldu   PD.DEV,y
         bra   L0690

L0688    pshs  u,y,x
         ldx   PD.DEV,y
         ldu   PD.FST,y
         beq   L0697
L0690    ldu   $02,u
         ldb   PD.PAG,y
         stb   V.LINE,u
L0697    leax  ,x
         beq   L06A7
         tfr   u,d
         ldu   V$STAT,x
         std   V.DEV2,u
         ldu   #D$READ
         lbsr  L0865
L06A7    puls  pc,u,y,x

* Check for forced uppercase
L06A9    tst   PD.UPC,y
         beq   L06B8
         cmpa  #'a
         bcs   L06B8
         cmpa  #'z
         bhi   L06B8
         suba  #$20
L06B8    rts

* Check for printable character
L06B9    tst   PD.EKO,y       Echo turned on?
         beq   L06B8
L06BE    cmpa  #$7F
         bcc   L06CD
         cmpa  #$20
         bcc   L06CA Print character
         cmpa  #$0D
         bne   L06CD
L06CA    lbra  L07FC Print character

* Non-printable character
L06CD    pshs  a              Save code
         lda   #'.
         bsr   L06CA Print character
         puls  pc,a

L06D5    pshs  y,x
         ldd   ,s
         beq   L06FB
         tstb
         bne   L06DF
         deca
L06DF    clrb
         ldu   $06,y
         ldu   $04,u
         leau  d,u
         clra
         ldb   $01,s
         bne   L06EC
         inca
L06EC    pshs  b,a
         lda   D.SysTsk
         ldx   D.Proc
         ldb   $06,x
         ldx   $08,y
         puls  y
         os9   F$Move
L06FB    puls  pc,y,x
L06FD    ldx   D.Proc
         lda   ,x
         ldx   $03,y
         bsr   L0707
         ldx   $0A,y
L0707    beq   L0711
         ldx   $02,x
         cmpa  $04,x
         bne   L0711
         clr   $04,x
L0711    rts

L0712    pshs  x,a
         ldx   $02,x
         lda   $04,x
         beq   L0734
         cmpa  ,s
         beq   L0750
         pshs  a
         bsr   L06FD
         puls  a
         os9   F$IOQu
         inc   $0F,y
         ldx   D.Proc
         ldb   P$Signal,X
         puls  x,a
         beq   L0712
         coma
         rts

L0734    lda   ,s
         sta   $04,x
         sta   $03,x
         lda   <$2F,y
         sta   $0D,x
         ldd   <$30,y
         std   $0B,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   L0750
         sta   $06,x
L0750    clra
         puls  pc,x,a

* Wait for device ?
L0753    ldx   D.Proc Get current process ID
         lda   P$ID,x         Get process ID #
         clr   $0F,y
         ldx   $03,y
         bsr   L0712
         bcs   L076D
         ldx   $0A,y
         beq   L0767
         bsr   L0712
         bcs   L076D
L0767    tst   $0F,y
         bne   L0753
         clr   $0C,y
L076D    ldu   $06,y
         rts

WriteLn  bsr   L0753
         bra   L0778

Write    bsr   L0753
         inc   $0C,y
L0778    ldx   $06,u
         beq   L07F1
         pshs  x
         ldx   #$0000
         bra   L0788
L0783    tfr   u,d
         tstb
         bne   L07BA
L0788    pshs  y,x
         ldd   ,s
         ldu   $06,y
         ldx   $04,u
         leax  d,x
         ldd   $06,u
         subd  ,s
         cmpd  #$0020
         bls   L079F
         ldd   #$0020
L079F    pshs  b,a
         ldd   $08,y
         inca
         subd  ,s
         tfr   d,u
         lda   #$0D
         sta   -1,u
         ldy   D.Proc
         lda   P$Task,y
         ldb   D.SysTsk
         puls  y
         os9   F$Move
         puls  y,x
L07BA    lda   ,u+
         tst   $0C,y
         bne   L07D4
         lbsr  L06A9
         cmpa  #$0A
         bne   L07D4
         lda   #$0D
         tst   <$25,y
         bne   L07D4
         bsr   L080C
         bcs   L07F4
         lda   #$0A
L07D4    bsr   L080C
         bcs   L07F4
         leax  $01,x
         cmpx  ,s
         bcc   L07EB
         lda   -$01,u
         beq   L0783
         cmpa  <$2B,y
         bne   L0783
         tst   $0C,y
         bne   L0783
L07EB    leas  $02,s
L07ED    ldu   $06,y
         stx   $06,u
L07F1    lbra  L06FD
L07F4    leas  $02,s
         pshs  b,cc
         bsr   L07ED
         puls  pc,b,cc

* Print character
L07FC    pshs  u,x,a
         ldx   $0A,y
         beq   L085C
         tst   $0C,y
         bne   L085E
         cmpa  #$0D
         bne   L085E
         bra   L083B
L080C    pshs  u,x,a
         ldx   $03,y
         tst   $0C,y
         bne   L085E
         cmpa  #$0D
         bne   L085E
         ldu   $02,x
         tst   V.PAUS,u
         bne   L0829
         tst   PD.PAU,y
         beq   L083B
         dec   V.LINE,u
         bne   L083B
         bra   L0833
L0829    lbsr  L0680
         bcs   L0833
         cmpa  PD.PSC,y
         bne   L0829
L0833    lbsr  L0680
         cmpa  PD.PSC,y
         beq   L0833
L083B    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   L0862
         ldb   PD.NUL,y
         pshs  b
         tst   PD.ALF,y  Add linefeed?
         beq   L0853
         lda   #$0A
L084F    bsr   L0862
         bcs   L085A
L0853    lda   #$00
         dec   ,s
         bpl   L084F
         clra
L085A    leas  1,s
L085C    puls  pc,u,x,a

L085E    bsr   L0862
         puls  pc,u,x,a

* Call device driver routines
L0862    ldu   #D$WRIT
L0865    pshs  u,y,x,a
         ldu   V$STAT,x
         clr   V.WAKE,u
         ldx   V$DRIV,x
         ldd   M$Exec,x
         addd  $05,s
         leax  d,x
         lda   ,s+
         jsr   ,x
         puls  pc,u,y,x
         emod
SCFEnd      equ   *
