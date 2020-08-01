         nam   RBF
         ttl   os9 file manager

         use defsfile

tylg     set   FlMgr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,0

name     equ   *
         fcs   /RBF/
         fcb   $10

L0011    fcb   $26

* All routines are entered with
* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
start    equ   *
         lbra  Create
         lbra  Open
         lbra  MakDir
         lbra  ChgDir
         lbra  Delete
         lbra  L0397
         lbra  L0442
         lbra  L04F3
         lbra  L03B9
         lbra  L04CC
         lbra  GetStat
         lbra  PutStat
         lbra  Close

********************************************************************
Create    pshs  y
         leas  -$05,s
         lda   $02,u
         anda  #$7F
         sta   $02,u
         lbsr  L0688
         bcs   L004A
         ldb   #$DA
L004A    cmpb  #$D8
         bne   L0070
         cmpa  #$2F
         beq   L0070
         pshs  x
         ldx   $06,y
         stu   $04,x
         ldb   <$16,y
         ldx   <$17,y
         lda   <$19,y
         ldu   <$1A,y
         pshs  u,x,b,a
         clra
         ldb   #$01
         lbsr  L0C2F
         bcc   L0075
         leas  $08,s
L0070    leas  $05,s
         lbra  L029C
L0075    std   $0B,s
         ldb   <$16,y
         ldx   <$17,y
         stb   $08,s
         stx   $09,s
         puls  u,x,b,a
         stb   <$16,y
         stx   <$17,y
         sta   <$19,y
         stu   <$1A,y
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  L0801
         bcs   L00A7
L009E    tst   ,x
         beq   L00B9
         lbsr  L07EC
         bcc   L009E
L00A7    cmpb  #$D3
         bne   L0070
         ldd   #$0020
         lbsr  L052C
         bcs   L0070
         lbsr  L0260
         lbsr  L0801
L00B9    leau  ,x
         lbsr  L0161
         puls  x
         os9   F$PrsNam
         bcs   L0070
         cmpb  #$1D
         bls   L00CB
         ldb   #$1D
L00CB    clra
         tfr   d,y
         lbsr  L055E
         tfr   y,d
         ldy   $05,s
         decb
         lda   b,u
         ora   #$80
         sta   b,u
         ldb   ,s
         ldx   $01,s
         stb   <$1D,u
         stx   <$1E,u
         lbsr  L1018
         bcs   L0149
         ldu   $08,y
         bsr   L0168
         lda   #$04
         sta   $0A,y
         ldx   $06,y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   $08,x
         std   $01,u
         lbsr  GETDATE
         ldd   $03,u
         std   $0D,u
         ldb   $05,u
         stb   $0F,u
         ldb   #$01
         stb   $08,u
         ldd   $03,s
         subd  #$0001
         beq   L0128
         leax  <$10,u
         std   $03,x
         ldd   $01,s
         addd  #$0001
         std   $01,x
         ldb   ,s
         adcb  #$00
         stb   ,x
L0128    ldb   ,s
         ldx   $01,s
         lbsr  L101A
         bcs   L0149
         lbsr  L0918
         stb   <$34,y
         stx   <$35,y
         lbsr  L08B2
         leas  $05,s
         ldx   <$30,y
         lda   #$04
         sta   $07,x
         lbra  L01C9
L0149    puls  u,x,a
         sta   <$16,y
         stx   <$17,y
         clr   <$19,y
         stu   <$1A,y
         pshs  b
         lbsr  L0E52
         puls  b
L015E    lbra  L029C
L0161    pshs  u,x,b,a
         leau  <$20,u
         bra   L016E
L0168    pshs  u,x,b,a
         leau  >$0100,u
L016E    clra
         clrb
         tfr   d,x
L0172    pshu  x,b,a
         cmpu  $04,s
         bhi   L0172
         puls  pc,u,x,b,a

********************************************************************
Open    pshs  y
         lbsr  L0688
         bcs   L015E
         ldu   $06,y
         stx   $04,u
         ldd   <$35,y
         bne   L01B8
         lda   <$34,y
         bne   L01B8
         ldb   $01,y
         andb  #$80
         lbne  L029A
         std   <$16,y
         sta   <$18,y
         std   <$13,y
         sta   <$15,y
         ldx   <$1E,y
         lda   $02,x
         std   <$11,y
         sta   <$1B,y
         ldd   ,x
         std   $0F,y
         std   <$19,y
         puls  pc,y
L01B8    lda   $01,y
         lbsr  L0865
         bcs   L015E
         bita  #$02
         beq   L01C9
         lbsr  GETDATE
         lbsr  L1010
L01C9    puls  y
L01CB    clra
         clrb
         std   $0B,y
         std   $0D,y
         std   <$13,y
         sta   <$15,y
         sta   <$19,y
         lda   ,u
         sta   <$33,y
         ldd   <$10,u
         std   <$16,y
         lda   <$12,u
         sta   <$18,y
         ldd   <$13,u
         std   <$1A,y
         ldd   $09,u
         ldx   $0B,u
         ldu   <$30,y
         cmpu  $05,u
         beq   L0206
         ldu   $05,u
         ldu   $01,u
         ldd   $0F,u
         ldx   <$11,u
L0206    std   $0F,y
         stx   <$11,y
         clr   $0A,y
         rts

********************************************************************
MakDir    lbsr  Create
         bcs   MKDIRERR
         lda   <$33,y
         ora   #$40
         lbsr  L0865
         bcs   MKDIRERR
         ldd   #$0040
         std   <$11,y
         bsr   L0270
         bcs   MKDIRERR
         lbsr  L0AF1
         bcs   MKDIRERR
         ldu   $08,y
         lda   ,u
         ora   #$80
         sta   ,u
         bsr   L0260
         bcs   MKDIRERR
         lbsr  L0168
         ldd   #$2EAE
         std   ,u
         stb   <$20,u
         lda   <$37,y
         sta   <$1D,u
         ldd   <$38,y
         std   <$1E,u
         lda   <$34,y
         sta   <$3D,u
         ldd   <$35,y
         std   <$3E,u
         lbsr  L1018
MKDIRERR    bra   L029F

L0260    lbsr  L0FAD
         ldx   $08,y
         ldd   $0F,y
         std   $09,x
         ldd   <$11,y
         std   $0B,x
         clr   $0A,y
L0270    lbra  L1010

Close    clra
         tst   $02,y
         bne   CLOSE20
         lbsr  L1048
         bcs   L029F
         ldb   $01,y
         bitb  #$02
         beq   L029F
         ldd   <$34,y
         bne   L028D
         lda   <$36,y
         beq   L029F
L028D    bsr   L0260
         lbsr  L0578
         bcc   L029F
         lbsr  L0D84
         bra   L029F
CLOSE20    rts

L029A    ldb   #$D6
L029C    coma

L029D    puls  y
L029F    pshs  b,cc
         ldu   $08,y
         beq   L02BA
         ldd   #$0100
         os9   F$SRtMem
         ldx   <$30,y
         beq   L02BA
         lbsr  L0918
         lda   ,x
         ldx   D.PthDBT
         os9   F$Ret64
L02BA    puls  pc,b,cc

GETDATE  lbsr  L0FAD
         ldu   $08,y
         lda   $08,u
         ldx   D.Proc
         pshs  x,a
         ldx   D.SysPrc
         stx   D.Proc
         leax  $03,u
         os9   F$Time
         puls  x,a
         stx   D.Proc
         sta   $08,u
         rts

********************************************************************
ChgDir    pshs  y
         lda   $01,y
         ora   #$80
         sta   $01,y
         lbsr  Open
         bcs   L029D
         ldx   D.Proc
         lda   <$21,y
         ldu   <$35,y
         ldb   $01,y
         bitb  #$03
         beq   L02FB
         ldb   <$34,y
         std   <$22,x
         stu   <$24,x
L02FB    ldb   $01,y
         bitb  #$04
         beq   L030A
         ldb   <$34,y
         std   <$28,x
         stu   <$2A,x
L030A    clrb
         bra   L029D

********************************************************************
Delete    pshs  y
         lbsr  L0688
         bcs   L029D
         ldd   <$35,y
         bne   L0320
         tst   <$34,y
         lbeq  L029A
L0320    lda   #$42
         lbsr  L0865
         bcs   L0394
         ldu   $06,y
         stx   $04,u
         lbsr  L0FAD
         bcs   L0394
         ldx   $08,y
         dec   $08,x
         beq   L033B
         lbsr  L1010
         bra   L0361
L033B    clra
         clrb
         std   $0F,y
         std   <$11,y
         lbsr  L0D84
         bcs   L0394
         ldb   <$34,y
         ldx   <$35,y
         stb   <$16,y
         stx   <$17,y
         ldx   $08,y
         ldd   <$13,x
         addd  #$0001
         std   <$1A,y
         lbsr  L0E52
L0361    bcs   L0394
         lbsr  L1048
         lbsr  L0918
         lda   <$37,y
         sta   <$34,y
         ldd   <$38,y
         std   <$35,y
         lbsr  L08B2
         lbsr  L0FAD
         bcs   L0394
         lbsr  L01CB
         ldd   <$3A,y
         std   $0B,y
         ldd   <$3C,y
         std   $0D,y
         lbsr  L0801
         bcs   L0394
         clr   ,x
         lbsr  L1018
L0394    lbra  L029D
L0397    ldb   $0A,y
         bitb  #$02
         beq   L03B0
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L03AB
         lda   $04,u
         sbca  $0B,y
         beq   L03B4
L03AB    lbsr  L1048
         bcs   L03B8
L03B0    ldd   $04,u
         std   $0B,y
L03B4    ldd   $08,u
         std   $0D,y
L03B8    rts
L03B9    bsr   L03FC
         beq   L03DF
         bsr   L03E0
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #$0D
L03C9    leay  $01,y
         cmpa  ,x+
         beq   L03D2
         decb
         bne   L03C9
L03D2    ldx   $06,s
         bsr   L0434
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
L03DF    rts
L03E0    lbsr  L046C
         leax  -$01,x
         lbsr  L0829
         cmpa  #$0D
         beq   L03F2
         ldd   $02,s
         lbne  L0472
L03F2    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         bra   L0459
L03FC    ldd   $06,u
         lbsr  L0994
         bcs   L0430
         ldd   $06,u
         bsr   L040C
         bcs   L0430
         std   $06,u
         rts
L040C    pshs  b,a
         ldd   <$11,y
         subd  $0D,y
         tfr   d,x
         ldd   $0F,y
         sbcb  $0C,y
         sbca  $0B,y
         bcs   L042D
         bne   L042A
         tstb
         bne   L042A
         cmpx  ,s
         bcc   L042A
         stx   ,s
         beq   L042D
L042A    clrb
         puls  pc,b,a
L042D    comb
         ldb   #$D3
L0430    leas  $02,s
         bra   L045E
L0434    pshs  x
         ldx   D.Proc
         lda   D.SysTsk
         ldb   $06,x
         puls  x
         os9   F$Move
         rts
L0442    bsr   L03FC
         beq   L0454
         bsr   L0455
L0448    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   L0434
         puls  u,y,x,b,a
         leax  d,x
L0454    rts
L0455    bsr   L046C
         bne   L0472
L0459    clrb
L045A    leas  -$02,s
L045C    leas  $0A,s
L045E    pshs  b,cc
         lda   $01,y
         bita  #$02
         bne   L0469
         lbsr  L098A
L0469    puls  b,cc
         rts
L046C    ldd   $04,u
         ldx   $06,u
         pshs  x,b,a
L0472    lda   $0A,y
         bita  #$02
         bne   L0492
         tst   $0E,y
         bne   L048D
         tst   $02,s
         beq   L048D
         leax  >L0504,pcr
         cmpx  $06,s
         bne   L048D
         lbsr  L0F22
         bra   L0490
L048D    lbsr  L1067
L0490    bcs   L045A
L0492    ldu   $08,y
         clra
         ldb   $0E,y
         leau  d,u
         negb
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   L04A5
         ldd   $02,s
L04A5    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   L04C3
         lbsr  L1048
         inc   $0D,y
         bne   L04C1
         inc   $0C,y
         bne   L04C1
         inc   $0B,y
L04C1    bcs   L045C
L04C3    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]
L04CC    pshs  y
         clrb
         ldy   $06,u
         beq   L04F1
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,u
L04DA    leay  -$01,y
         beq   L04F1
         os9   F$LDABX
         leax  $01,x
         cmpa  #$0D
         bne   L04DA
         tfr   y,d
         nega
         negb
         sbca  #$00
         addd  $06,u
         std   $06,u
L04F1    puls  y
L04F3    ldd   $06,u
         lbsr  L0994
         bcs   L052B
         ldd   $06,u
         beq   L052A
         bsr   L052C
         bcs   L052B
         bsr   L0515
L0504    pshs  y,b,a
         tfr   d,y
         bsr   L055E
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts
L0515    lbsr  L046C
         lbne  L0472
         leas  $08,s
         ldy   <$30,y
         lda   #$01
         lbsr  L0959
         ldy   $01,y
L052A    clrb
L052B    rts
L052C    addd  $0D,y
         tfr   d,x
         ldd   $0B,y
         adcb  #$00
         adca  #$00
L0536    cmpd  $0F,y
         bcs   L052A
         bhi   L0542
         cmpx  <$11,y
         bls   L052A
L0542    pshs  u
         ldu   <$11,y
         stx   <$11,y
         ldx   $0F,y
         std   $0F,y
         pshs  u,x
         lbsr  L0AF1
         puls  u,x
         bcc   L055C
         stx   $0F,y
         stu   <$11,y
L055C    puls  pc,u
L055E    pshs  x
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         puls  x
         os9   F$Move
         rts

********************************************************************
GetStat    ldb   $02,u
         cmpb  #$00
         beq   L0592
         cmpb  #$06
         bne   L057E
         clr   $02,u
L0578    clra
         ldb   #$01
         lbra  L040C

L057E    cmpb  #$01
         bne   L0585
         clr   $02,u
         rts
L0585    cmpb  #$02
         bne   L0593
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
L0592    rts
L0593    cmpb  #$05
         bne   L05A0
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts
L05A0    cmpb  #$0F
         bne   L05BA
         lbsr  L0FAD
         bcs   L0592
         ldu   $06,y
         ldd   $06,u
         tsta
         beq   L05B3
         ldd   #$0100
L05B3    ldx   $04,u
         ldu   $08,y
         lbra  L0448
L05BA    lda   #$09
         lbra  L0FC6

PutStat  ldb   $02,u
         cmpb  #$00
         bne   L05D3
         ldx   $04,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  L055E
L05D3    cmpb  #$02
         bne   L0615
         ldd   <$35,y
         bne   L05E3
         tst   <$34,y
         lbeq  L0684
L05E3    lda   $01,y
         bita  #$02
         beq   L0611
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L05FC
         bne   L05F9
         cmpx  <$11,y
         bcs   L05FC
L05F9    lbra  L0536
L05FC    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  L0D84
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts
L0611    comb
         ldb   #$CB
         rts

L0615    cmpb  #$0F
         bne   L0653
         lda   $01,y
         bita  #$02
         beq   L0611
         lbsr  L0FAD
         bcs   L0687
         pshs  y
         ldx   $04,u
         ldu   $08,y
         ldy   D.Proc
         ldd   $08,y
         bne   L0636
         ldd   #$0102
         bsr   L0645
L0636    ldd   #$0305
         bsr   L0645
         ldd   #$0D03
         bsr   L0645
         puls  y
         lbra  L1010
L0645    pshs  u,x
         leax  a,x
         leau  a,u
         clra
         tfr   d,y
         lbsr  L055E
         puls  pc,u,x
L0653    cmpb  #$11
         bne   L0672
         ldd   $08,u
         ldx   $04,u
         cmpx  #$FFFF
         bne   L066F
         cmpx  $08,u
         bne   L066F
         ldu   <$30,y
         lda   $07,u
         ora   #$02
         sta   $07,u
         lda   #$FF
L066F    lbra  L09A3
L0672    cmpb  #$10
         bne   L067F
         ldd   $04,u
         ldx   <$30,y
         std   <$12,x
         rts
L067F    lda   #$0C
         lbra  L0FC6

L0684    comb
         ldb   #$D0
L0687    rts

* Create buffer
L0688    ldd   #$0100
         stb   $0A,y
         os9   F$SRqMem
         bcs   L0687
         stu   $08,y
         leau  ,y
         ldx   D.PthDBT
         os9   F$All64
         exg   y,u
         bcs   L0687
         stu   <$30,y
         sty   $01,u
         stu   <$10,u
         ldx   $06,y
         ldx   $04,x
         pshs  u,y,x
         leas  -$04,s
         clra
         clrb
         sta   <$34,y
         std   <$35,y
         std   <$1C,y
         lbsr  L0829
         sta   ,s
         cmpa  #$2F
         bne   L06D4
         lbsr  L0834
         sta   ,s
         lbcs  L07B7
         leax  ,y
         ldy   $06,s
         bra   L06F7
L06D4    anda  #$7F
         cmpa  #$40
         beq   L06F7
         lda   #$2F
         sta   ,s
         leax  -$01,x
         lda   $01,y
         ldu   D.Proc
         leau  <$20,u
         bita  #$24
         beq   L06ED
         leau  $06,u
L06ED    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y
L06F7    ldu   $03,y
         stu   <$3E,y
         lda   <$21,y
         ldb   >L0011,pcr
         mul
         addd  $02,u
         addd  #$000F
         std   <$1E,y
         lda   ,s
         anda  #$7F
         cmpa  #$40
         bne   L0718
         leax  $01,x
         bra   L073A
L0718    lbsr  L0F9A
         lbcs  L07BF
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L073A
         lda   <$34,y
         bne   L073A
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y
L073A    stx   $04,s
         stx   $08,s
L073E    lbsr  L1048
         lbsr  L08B2
         bcs   L07BF
         lda   ,s
         cmpa  #$2F
         bne   L07A1
         clr   $02,s
         clr   $03,s
         lda   $01,y
         ora   #$80
         lbsr  L0865
         bcs   L07B7
         lbsr  L01CB
         ldx   $08,s
         leax  $01,x
         lbsr  L0834
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   L07B7
         lbsr  L0801
         bra   L0778
L0774    bsr   L07C2
L0776    bsr   L07EC
L0778    bcs   L07B7
         tst   ,x
         beq   L0774
         leay  ,x
         ldx   $04,s
         ldb   $01,s
         clra
         os9   F$CmpNam
         ldx   $06,s
         exg   x,y
         bcs   L0776
         bsr   L07D0
         lda   <$1D,x
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  L0918
         bra   L073E
L07A1    ldx   $08,s
         tsta
         bmi   L07AE
         os9   F$PrsNam
         leax  ,y
         ldy   $06,s
L07AE    stx   $04,s
         clra
L07B1    lda   ,s
         leas  $04,s
         puls  pc,u,y,x
L07B7    cmpb  #$D3
         bne   L07BF
         bsr   L07C2
         ldb   #$D8
L07BF    coma
         bra   L07B1
L07C2    pshs  b,a
         lda   $04,s
         cmpa  #$2F
         beq   L07EA
         ldd   $06,s
         bne   L07EA
         puls  b,a
L07D0    pshs  b,a
         stx   $06,s
         lda   <$34,y
         sta   <$37,y
         ldd   <$35,y
         std   <$38,y
         ldd   $0B,y
         std   <$3A,y
         ldd   $0D,y
         std   <$3C,y
L07EA    puls  pc,b,a

L07EC    ldb   $0E,y
         addb  #$20
         stb   $0E,y
         bcc   L0801
         lbsr  L1048
         inc   $0D,y
         bne   L0801
         inc   $0C,y
         bne   L0801
         inc   $0B,y
L0801    ldd   #$0020
         lbsr  L040C
         bcs   L0828
         ldd   #$0020
         lbsr  L0994
         bcs   L0828
         lda   $0A,y
         bita  #$02
         bne   L0821
         lbsr  L0F22
         bcs   L0828
         lbsr  L1067
         bcs   L0828
L0821    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb
L0828    rts

L0829    pshs  u,x,b
         ldu   D.Proc
         ldb   $06,u
         os9   F$LDABX
         puls  pc,u,x,b
L0834    os9   F$PrsNam
         pshs  x
         bcc   L0863
         clrb
L083C    pshs  a
         anda  #$7F
         cmpa  #$2E
         puls  a
         bne   L0857
         incb
         leax  $01,x
         tsta
         bmi   L0857
         bsr   L0829
         cmpb  #$03
         bcs   L083C
         lda   #$2F
         decb
         leax  -$03,x
L0857    tstb
         bne   L085F
         comb
         ldb   #$D7
         puls  pc,x
L085F    leay  ,x
         andcc #$FE
L0863    puls  pc,x
L0865    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  L0FAD
         bcs   L0894
         ldu   $08,y
         ldx   D.Proc
         ldd   $08,x
         beq   L087D
         cmpd  $01,u
L087D    puls  a
         beq   L0884
         lsla
         lsla
         lsla
L0884    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   L089D
         ldb   #$D6
L0894    leas  $02,s
         coma
         puls  pc,x
L0899    ldb   #$FD
         bra   L0894
L089D    ldb   $01,s
         orb   ,u
         bitb  #$40
         beq   L08B0
         ldx   <$30,y
         cmpx  $05,x
         bne   L0899
         lda   #$02
         sta   $07,x
L08B0    puls  pc,x,b,a

L08B2    pshs  u,y,x
         clra
         clrb
         std   $0B,y
         std   $0D,y
         sta   <$19,y
         std   <$1A,y
         ldb   <$34,y
         ldx   <$35,y
         pshs  x,b
         ldu   <$1E,y
         ldy   <$30,y
         sty   $05,y
         leau  <$15,u
         bra   L08D9
L08D7    ldu   $03,u
L08D9    ldx   $03,u
         beq   L0907
         ldx   $01,x
         ldd   <$34,x
         cmpd  ,s
         bcs   L08D7
         bhi   L0907
         ldb   <$36,x
         cmpb  $02,s
         bcs   L08D7
         bhi   L0907
         ldx   <$30,x
         lda   $07,y
         bita  #$02
         bne   L0913
         sty   $03,y
         ldd   $05,x
         std   $05,y
         sty   $05,x
         bra   L090E
L0907    ldx   $03,u
         stx   $03,y
         sty   $03,u
L090E    clrb
L090F    leas  $03,s
         puls  pc,u,y,x
L0913    comb
         ldb   #$FD
         bra   L090F
L0918    pshs  u,y,x,b,a
         ldu   <$1E,y
         leau  <$15,u
         ldx   <$30,y
         leay  ,x
         bsr   L0957
         bra   L092D
L0929    ldx   $05,x
         beq   L0952
L092D    cmpy  $05,x
         bne   L0929
         ldd   $05,y
         std   $05,x
         bra   L093A
L0938    ldu   $03,u
L093A    ldd   $03,u
         beq   L0952
         cmpy  $03,u
         bne   L0938
         ldx   $03,y
         cmpy  $05,y
         beq   L0950
         ldx   $05,y
         ldd   $03,y
         std   $03,x
L0950    stx   $03,u
L0952    sty   $05,y
         puls  pc,u,y,x,b,a
L0957    lda   #$07
L0959    pshs  u,y,x,b,a
         bita  $07,y
         beq   L0968
         coma
         anda  $07,y
         sta   $07,y
         bita  #$02
         bne   L0985
L0968    leau  ,y
L096A    ldx   <$10,u
         cmpy  <$10,u
         beq   L0982
         stu   <$10,u
         leau  ,x
         lda   <$14,u
         ldb   #$01
         os9   F$Send
         bra   L096A
L0982    stu   <$10,u
L0985    puls  pc,u,y,x,b,a
L0987    comb
         ldb   #$FD
L098A    pshs  y,b,cc
         ldy   <$30,y
         bsr   L0957
         puls  pc,y,b,cc
L0994    ldx   #$0000
         bra   L09A3
L0999    ldu   <$30,y
         lda   <$15,u
         sta   $07,u
         puls  u,y,x,b,a
L09A3    pshs  u,y,x,b,a
         ldu   <$30,y
         lda   $07,u
         sta   <$15,u
         lda   ,s
         lbsr  L0A3A
         bcc   L0A1D
         ldu   D.Proc
         lda   <$14,x
L09B9    os9   F$GProcP
         bcs   L09CB
         lda   <$1E,y
         beq   L09CB
         cmpa  ,u
         bne   L09B9
         ldb   #$FE
         bra   L0A1A
L09CB    lda   <$14,x
         sta   <$1E,u
         bsr   L0A1F
         ldy   $04,s
         ldu   <$30,y
         ldd   <$10,x
         stu   <$10,x
         std   <$10,u
         ldx   <$12,u
         os9   F$Sleep
         pshs  x
         leax  ,u
         bra   L09F1
L09EE    ldx   <$10,x
L09F1    cmpu  <$10,x
         bne   L09EE
         ldd   <$10,u
         std   <$10,x
         stu   <$10,u
         puls  x
         ldu   D.Proc
         clr   <$1E,u
         lbsr  L0EDE
         bcs   L0A1A
         leax  ,x
         bne   L0999
         ldu   <$30,y
         ldx   <$12,u
         beq   L0999
         ldb   #$FC
L0A1A    coma
         stb   $01,s
L0A1D    puls  pc,u,y,x,b,a
L0A1F    pshs  y,x
         ldy   D.Proc
         bra   L0A33
L0A26    clr   <$10,y
         ldb   #$01
         os9   F$Send
         os9   F$GProcP
         clr   $0F,y
L0A33    lda   <$10,y
         bne   L0A26
         puls  pc,y,x
L0A3A    std   -$02,s
         bne   L0A45
         cmpx  #$0000
         lbeq  L098A
L0A45    bsr   L0A5D
         lbcs  L0987
         pshs  u,y,x
         ldy   <$30,y
         lda   #$01
         lbsr  L0959
         ora   $07,y
         sta   $07,y
         clrb
         puls  pc,u,y,x
L0A5D    pshs  u,y,b,a
         leau  ,y
         ldy   <$30,y
         subd  #$0001
         bcc   L0A6C
         leax  -$01,x
L0A6C    addd  $0D,u
         exg   d,x
         adcb  $0C,u
         adca  $0B,u
         bcc   L0A7B
         ldx   #$FFFF
         tfr   x,d
L0A7B    std   $0C,y
         stx   $0E,y
         cmpd  $0F,u
         bcs   L0A93
         bhi   L0A8B
         cmpx  <$11,u
         bcs   L0A93
L0A8B    lda   $07,y
         ora   #$04
         sta   $07,y
         bra   L0A9C
L0A93    lda   #$04
         bita  $07,y
         beq   L0A9C
         lbsr  L0959
L0A9C    ldd   $0B,u
         ldx   $0D,u
         std   $08,y
         stx   $0A,y
         lda   $05,u
         sta   <$14,y
         leax  ,y
L0AAB    cmpy  $05,x
         beq   L0AEF
         ldx   $05,x
         ldb   <$14,y
         cmpb  <$14,x
         beq   L0AAB
         lda   $07,x
         beq   L0AAB
         ora   $07,y
         bita  #$02
         bne   L0AEE
         lda   $07,x
         anda  $07,y
         bita  #$04
         bne   L0AEE
         ldd   $08,x
         cmpd  $0C,y
         bhi   L0AAB
         bcs   L0ADE
         ldd   $0A,x
         cmpd  $0E,y
         bhi   L0AAB
         beq   L0AEE
L0ADE    ldd   $0C,x
         cmpd  $08,y
         bcs   L0AAB
         bhi   L0AEE
         ldd   $0E,x
         cmpd  $0A,y
         bcs   L0AAB
L0AEE    comb
L0AEF    puls  pc,u,y,b,a
L0AF1    pshs  u,x
L0AF3    bsr   L0B53
         bne   L0B03
         cmpx  <$1A,y
         bcs   L0B4A
         bne   L0B03
         lda   <$12,y
         beq   L0B4A
L0B03    lbsr  L0FAD
         bcs   L0B47
         ldx   $0B,y
         ldu   $0D,y
         pshs  u,x
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  L0F3C
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         bcc   L0B4A
         cmpb  #$D5
         bne   L0B47
         bsr   L0B53
         bne   L0B33
         tst   <$12,y
         beq   L0B36
         leax  $01,x
         bne   L0B36
L0B33    ldx   #$FFFF
L0B36    tfr   x,d
         tsta
         bne   L0B43
         cmpb  <$2E,y
         bcc   L0B43
         ldb   <$2E,y
L0B43    bsr   L0B89
         bcc   L0AF3
L0B47    coma
         puls  pc,u,x
L0B4A    lbsr  L0F22
         bcs   L0B47
         bsr   L0B61
         puls  pc,u,x
L0B53    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
         rts
L0B61    clra
         ldb   #$02
         pshs  u,x
         ldu   <$30,y
         bra   L0B7F
L0B6B    ldu   $01,u
         ldx   $0F,y
         stx   $0F,u
         ldx   <$11,y
         stx   <$11,u
         bitb  $01,y
         beq   L0B7C
         inca
L0B7C    ldu   <$30,u
L0B7F    ldu   $05,u
         cmpy  $01,u
         bne   L0B6B
         tsta
         puls  pc,u,x
L0B89    pshs  u,x
         lbsr  L0C2F
         bcs   L0BC8
         lbsr  L0FAD
         bcs   L0BC8
         ldu   $08,y
         clra
         clrb
         std   $09,u
         std   $0B,u
         leax  <$10,u
         ldd   $03,x
         beq   L0C10
         ldd   $08,y
         inca
         pshs  b,a
         bra   L0BB8
L0BAB    clrb
         ldd   -$02,x
         beq   L0BC4
         addd  $0A,u
         std   $0A,u
         bcc   L0BB8
         inc   $09,u
L0BB8    leax  $05,x
         cmpx  ,s
         bcs   L0BAB
         lbsr  L0E52
         comb
         ldb   #$D9
L0BC4    leas  $02,s
         leax  -$05,x
L0BC8    bcs   L0C2D
         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   L0C10
         cmpd  <$17,y
         bne   L0C10
         ldu   <$1E,y
         ldd   $06,u
         ldu   $08,y
         subd  #$0001
         coma
         comb
         pshs  b,a
         ldd   -$05,x
         eora  <$16,y
         eorb  <$17,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         anda  ,s+
         andb  ,s+
         std   -$02,s
         bne   L0C10
         ldd   -$02,x
         addd  <$1A,y
         bcs   L0C10
         std   -$02,x
         bra   L0C1F
L0C10    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L0C1F    ldd   $0A,u
         addd  <$1A,y
         std   $0A,u
         bcc   L0C2A
         inc   $09,u
L0C2A    lbsr  L1010
L0C2D    puls  pc,u,x
L0C2F    pshs  u,y,x,b,a
         ldb   #$0D
L0C33    clr   ,-s
         decb
         bne   L0C33
         ldx   <$1E,y
         ldd   $04,x
         std   $05,s
         ldd   $06,x
         std   $03,s
         std   $0B,s
         ldx   $03,y
         ldx   $04,x
         leax  <$12,x
         subd  #$0001
         addb  $0E,x
         adca  #$00
         bra   L0C57
L0C55    lsra
         rorb
L0C57    lsr   $0B,s
         ror   $0C,s
         bcc   L0C55
         std   $01,s
         ldd   $03,s
         std   $0B,s
         subd  #$0001
         addd  $0D,s
         bcc   L0C71
         ldd   #$FFFF
         bra   L0C71
L0C6F    lsra
         rorb
L0C71    lsr   $0B,s
         ror   $0C,s
         bcc   L0C6F
         cmpa  #$08
         bcs   L0C7E
         ldd   #$0800
L0C7E    std   $0D,s
         lbsr  L0EC4
         lbcs  L0D78
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L0CB0
         lda   <$1C,x
         cmpa  $04,x
         bne   L0CB0
         ldd   $0D,s
         cmpd  $01,s
         bcs   L0CBD
         lda   <$1D,x
         cmpa  $04,x
         bcc   L0CB0
         sta   $07,s
         nega
         adda  $05,s
         sta   $05,s
         bra   L0CBD
L0CB0    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
L0CBD    inc   $07,s
         ldb   $07,s
         lbsr  L0F0C
         lbcs  L0D78
         ldd   $05,s
         tsta
         beq   L0CD0
         ldd   #$0100
L0CD0    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra
         clrb
         os9   F$SchBit
         pshs  b,a,cc
         tst   $03,s
         bne   L0CEB
         cmpy  $04,s
         bcs   L0CEB
         lda   $0A,s
         sta   $03,s
L0CEB    puls  b,a,cc
         bcc   L0D1E
         cmpy  $09,s
         bls   L0CFD
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L0CFD    ldy   <$11,s
         tst   $05,s
         beq   L0D09
         dec   $05,s
         bra   L0CBD
L0D09    ldb   $08,s
         beq   L0D76
         clra
         cmpb  $07,s
         beq   L0D17
         stb   $07,s
         lbsr  L0F0C
L0D17    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L0D1E    std   $0B,s
         sty   $09,s
         os9   F$AllBit
         ldy   <$11,s
         ldb   $07,s
         lbsr  L0EF4
         bcs   L0D78
         lda   ,s
         beq   L0D3C
         ldx   <$1E,y
         deca
         sta   <$1D,x
L0D3C    lda   $07,s
         deca
         clrb
         lsla
         rolb
         lsla
         rolb
         lsla
         rolb
         stb   <$16,y
         ora   $0B,s
         ldb   $0C,s
         ldx   $09,s
         ldy   <$11,s
         std   <$17,y
         stx   <$1A,y
         ldd   $03,s
         bra   L0D6C
L0D5D    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L0D6C    lsra
         rorb
         bcc   L0D5D
         clrb
         ldd   <$1A,y
         bra   L0D80
L0D76    ldb   #$F8
L0D78    ldy   <$11,s
         lbsr  L0EFB
         coma
L0D80    leas  $0F,s
         puls  pc,u,y,x
L0D84    clra
         lda   $01,y
         bita  #$80
         bne   L0DF5
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         ldd   #$FFFF
         tfr   d,x
         lbsr  L09A3
         bcs   L0DF4
         lbsr  L0B61
         bne   L0DF5
         lbsr  L0F3C
         bcc   L0DAC
         cmpb  #$D5
         bra   L0DED
L0DAC    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0DBB
         subd  #$0001
L0DBB    pshs  b,a
         ldu   <$1E,y
         ldd   $06,u
         subd  #$0001
         coma
         comb
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0DEF
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0DE5
         inc   <$16,y
L0DE5    bsr   L0E52
         bcc   L0DF6
         leas  $04,s
         cmpb  #$DB
L0DED    bne   L0DF4
L0DEF    lbsr  L0FAD
         bcc   L0DFF
L0DF4    coma
L0DF5    rts
L0DF6    lbsr  L0FAD
         bcs   L0E4F
         puls  x,b,a
         std   $03,x
L0DFF    ldu   $08,y
         ldd   <$11,y
         std   $0B,u
         ldd   $0F,y
         std   $09,u
         tfr   x,d
         clrb
         inca
         leax  $05,x
         pshs  x,b,a
         bra   L0E3A
L0E14    ldd   -$02,x
         beq   L0E47
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   L0E52
         bcs   L0E4F
         stx   $02,s
         lbsr  L0FAD
         bcs   L0E4F
         ldx   $02,s
         clra
         clrb
         std   -$05,x
         sta   -$03,x
         std   -$02,x
L0E3A    lbsr  L1010
         bcs   L0E4F
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0E14
L0E47    clra
         clrb
         sta   <$19,y
         std   <$1A,y
L0E4F    leas  $04,s
         rts
L0E52    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0E7A
         inc   <$16,y
         bra   L0E7A
L0E6B    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0E7A    lsra
         rorb
         bcc   L0E6B
         clrb
         ldd   <$1A,y
         beq   L0EC2
         ldd   <$16,y
         lsra
         rorb
         lsra
         rorb
         lsra
         rorb
         tfr   b,a
         ldb   #$DB
         cmpa  $04,x
         bhi   L0EC1
         cmpa  <$1D,x
         bcc   L0E9D
         sta   <$1D,x
L0E9D    inca
         sta   ,s
L0EA0    bsr   L0EC4
         bcs   L0EA0
         ldb   ,s
         bsr   L0F0C
         bcs   L0EC1
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <$1A,y
         os9   F$DelBit
         ldy   $03,s
         ldb   ,s
         bsr   L0EF4
         bcc   L0EC2
L0EC1    coma
L0EC2    puls  pc,u,y,x,a
L0EC4    lbsr  L1048
         bra   L0ECE
L0EC9    os9   F$IOQu
         bsr   L0EDE
L0ECE    bcs   L0EDD
         ldx   <$1E,y
         lda   <$17,x
         bne   L0EC9
         lda   $05,y
         sta   <$17,x
L0EDD    rts
L0EDE    ldu   D.Proc
         ldb   <$19,u
         cmpb  #$01
         bls   L0EEB
         cmpb  #$03
         bls   L0EF2
L0EEB    clra
         lda   $0C,u
         bita  #$02
         beq   L0EF3
L0EF2    coma
L0EF3    rts
L0EF4    clra
         tfr   d,x
         clrb
         lbsr  L101A
L0EFB    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0F0A
         clr   <$17,x
L0F0A    puls  pc,cc
L0F0C    clra
         tfr   d,x
         clrb
         lbra  L0FC4
         pshs  u,x
         lbsr  L1018
         bcs   L0F20
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0F20    puls  pc,u,x
L0F22    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0F3A
         bhi   L0F3C
         cmpx  <$1A,y
         bcc   L0F3C
L0F3A    clrb
         rts
L0F3C    pshs  u
         bsr   L0FAD
         bcs   L0F96
         clra
         clrb
         std   <$13,y
         stb   <$15,y
         ldu   $08,y
         leax  <$10,u
         lda   $08,y
         ldb   #$FC
         pshs  b,a
L0F55    ldd   $03,x
         beq   L0F7A
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0F87
         bne   L0F6E
         cmpu  $0C,y
         bhi   L0F87
L0F6E    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   L0F55
L0F7A    clra
         clrb
         sta   <$19,y
         std   <$1A,y
         comb
         ldb   #$D5
         bra   L0F96
L0F87    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0F96    leas  $02,s
         puls  pc,u
L0F9A    pshs  x,b
         lbsr  L1048
         bcs   L0FA9
         clrb
         ldx   #$0000
         bsr   L0FC4
         bcc   L0FAB
L0FA9    stb   ,s
L0FAB    puls  pc,x,b
L0FAD    ldb   $0A,y
         bitb  #$04
         bne   L0F3A
         lbsr  L1048
         bcs   L1030
         ldb   $0A,y
         orb   #$04
         stb   $0A,y
         ldb   <$34,y
         ldx   <$35,y
L0FC4    lda   #$03
L0FC6    pshs  u,y,x,b,a
         lda   $0A,y
         ora   #$20
         sta   $0A,y
         ldu   $03,y
         ldu   $02,u
         bra   L0FD7
L0FD4    os9   F$IOQu
L0FD7    lda   $04,u
         bne   L0FD4
         lda   $05,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   L0FFE
         puls  u
         ldy   $04,s
         pshs  cc
         lda   $0A,y
         anda  #$DF
         sta   $0A,y
         clr   $04,u
         puls  cc
         bcc   L0FFC
         stb   $01,s
L0FFC    puls  pc,u,y,x,b,a
L0FFE    pshs  pc,x,b,a
         ldx   $03,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a
L1010    ldb   <$34,y
         ldx   <$35,y
         bra   L101A
L1018    bsr   L1031
L101A    lda   #$06
         pshs  x,b,a
         ldd   <$1C,y
         beq   L1029
         ldx   <$1E,y
         cmpd  $0E,x
L1029    puls  x,b,a
         beq   L0FC6
         comb
         ldb   #$FB
L1030    rts
L1031    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         exg   d,x
         addd  <$17,y
         exg   d,x
         adcb  <$16,y
         rts
L1048    clrb
         pshs  u,x
         ldb   $0A,y
         andb  #$06
         beq   L1065
         tfr   b,a
         eorb  $0A,y
         stb   $0A,y
         andb  #$01
         beq   L1065
         eorb  $0A,y
         stb   $0A,y
         bita  #$02
         beq   L1065
         bsr   L1018
L1065    puls  pc,u,x
L1067    pshs  u,x
         lbsr  L0F22
         bcs   L10D0
         bsr   L1048
         bcs   L10D0
L1072    ldb   $0B,y
         ldu   $0C,y
         leax  ,y
         ldy   <$30,y
L107C    ldx   <$30,x
         cmpy  $05,x
         beq   L10BF
         ldx   $05,x
         ldx   $01,x
         cmpu  $0C,x
         bne   L107C
         cmpb  $0B,x
         bne   L107C
         lda   $0A,x
         bita  #$20
         bne   L109D
         bita  #$02
         beq   L107C
         bra   L10AC
L109D    lda   $05,x
         ldy   $01,y
         os9   F$IOQu
         lbsr  L0EDE
         bcc   L1072
         bra   L10D0
L10AC    ldy   $01,y
         ldd   $08,x
         ldu   $08,y
         std   $08,y
         stu   $08,x
         lda   $0A,x
         sta   $0A,y
         clr   $0A,x
         puls  pc,u,x
L10BF    ldy   $01,y
         lbsr  L1031
         lbsr  L0FC4
         bcs   L10D0
         lda   $0A,y
         ora   #$02
         sta   $0A,y
L10D0    puls  pc,u,x
         emod
eom      equ   *
