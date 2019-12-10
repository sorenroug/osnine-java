         nam   G68
         ttl   os9 device driver

         ifp1
         use   defsfile
         endc
tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   DSKEND,DSKNAM,tylg,atrv,DSKENT,DSKSTA
u0000    rmb   1
u0001    rmb   3
u0004    rmb   1
u0005    rmb   1
u0006    rmb   2
u0008    rmb   7
u000F    rmb   49
u0040    rmb   42
u006A    rmb   61
u00A7    rmb   2
u00A9    rmb   1
u00AA    rmb   2
u00AC    rmb   2
u00AE    rmb   2
u00B0    rmb   2
u00B2    rmb   2
u00B4    rmb   2
u00B6    rmb   2
u00B8    rmb   1
u00B9    rmb   1
u00BA    rmb   1
u00BB    rmb   2
u00BD    rmb   1
u00BE    rmb   1
u00BF    rmb   2
u00C1    rmb   1
u00C2    rmb   1

DSKSTA     equ   .
         fcb   $FF
DSKNAM     equ   *
         fcs   /G68/
         fcb   $05

******************************************************************
*
* Branch Table
*
DSKENT lbra INIDSK Initialize i/o
         lbra  READSK
         lbra  WRTDSK
         lbra  Getsta
         lbra  PUTSTA
         lbra  Termnt

L0024    fcb   $00
         fcb   $40
         fcb   $01

PUTSTA ldx PD.RGS,Y Point to parameters
         ldb   $02,x
         cmpb  #$03
         lbeq  RESTOR
         cmpb  #$04
         lbeq  L040A
         cmpb  #$0A
         beq   SETFRZ
         cmpb  #$0B
         beq   SETSPT
GETSTA comb ...NO; Error
 ldb #E$UnkSvc Error code
 rts

SETFRZ    ldb   #$FF
         stb   >u00C2,u
         clrb
         rts

SETSPT    lbsr  SELECT
         ldd   $04,x
         ldx   >u00A7,u
         stb   $03,x
         clrb
         rts

INIDSK    ldx   u0001,u
         stx   >u00AA,u
         leax  $01,x
         stx   >u00AC,u
         leax  $01,x
         stx   >u00AE,u
         leax  $02,x
         lda   #$D0
         sta   ,x
         stx   >u00B0,u
         leax  $01,x
         stx   >u00B2,u
         leax  $01,x
         stx   >u00B4,u
         leax  $01,x
         stx   >u00B6,u
         lda   #$FF
         ldb   #$04
         stb   u0006,u
         leax  u000F,u
L008E    sta   ,x
         sta   <$15,x
         leax  <$26,x
         decb
         bne   L008E
 ldd #256 "d" passes memory req size
 pshs U Save "u" we need it later
 OS9 F$SRqMem Request 1 pag of mem
 tfr U,X
 puls U
         bcs   RETRN1
         stx   >u00BF,u
         ldd   >u00AA,u
         leax  >L0024,pcr
         leay  <L00BD,pcr
         os9   F$IRQ
         bcs   RETRN1
         clrb
RETRN1    rts
L00BD    ldb   [>u00B0,u]
         coma
         lda   u0005,u
         beq   L00DA
         tst   >u00BD,u
         beq   L00CE
         clr   <u006A
L00CE    stb   >u00BB,u
         ldb   #$01
         clr   u0005,u
         os9   F$Send
         clrb
L00DA    rts
RESTOR    lbsr  SELECT
         bcs   RETRN1
         ldx   >u00A7,u
         clr   <$15,x
         lda   #$05
L00E9    pshs  a
         ldb   <$22,y
         andb  #$03
         eorb  #$4B
         clr   >u00BD,u
         bsr   L0156
         puls  a
         deca
         bne   L00E9
         ldb   <$22,y
         andb  #$03
         eorb  #$0B
         bra   L0156
***************************************************************
*
* Write Sector Command
*
* Input:
*   B = Msb Of Logical Sector Number
*   X = Lsb'S Of Logical Sector Number
*   Y = Ptr To Path Descriptor
*   U = Ptr To Global Storage
*
*
* Error:
*   Carry Set
*   B = Error Code
*
WRTDSK lda #$91 Error retry code
L0108    pshs  x,b,a
         bsr   L013B
         bcc   L011E
         cmpb  #$F6
         beq   L0151
         cmpb  #$F2
         beq   L0151
         tst   ,s
         beq   L0151
         puls  x,b,a
         bra   L0130
L011E    tst   ,s
         lbeq  L03AD
         puls  x,b,a
         tst   <$28,y
         bne   RETRN1
         lbsr  L0449
         bcc   RETRN1
L0130    lsra
         bcc   L0108
         pshs  x,b,a
         bsr   RESTOR
         puls  x,b,a
         bra   L0108
L013B    lbsr  L0225
         lbcs  RETRN1
         ldx   $08,y
         lda   #$30
         sta   >u00BD,u
         ldb   #$A8
         bsr   L0156
         lbra  L0387
L0151    stb   $01,s
         comb
         puls  pc,x,b,a
L0156    lda   >u00BD,u
         beq   L016E
         stx   [>u00AE,u]
L0160    lda   <u006A
         beq   L016C
         ldx   #$0001
         os9   F$Sleep
         bra   L0160
L016C    inc   <u006A
L016E    lda   >u00A9,u
         bmi   L017E
         tst   <$22,y
         bpl   L017E
         tstb
         bmi   L017E
         ora   #$C0
L017E    tst   >u00BA,u
         bne   L0186
         ora   #$10
L0186    sta   [>u00AA,u]
         lda   >u00BD,u
         tst   >u00B8,u
         beq   L0196
         ora   #$40
L0196    ora   #$80
         sta   [>u00AC,u]
         tst   >u00BD,u
         beq   L01B2
         orb   >u00BE,u
         clr   >u00BE,u
         tst   >u00B8,u
         beq   L01B2
         orb   #$02
L01B2    lda   u0004,u
         sta   u0005,u
         stb   [>u00B0,u]
L01BA    ldx   #$0032
         os9   F$Sleep
         tst   [>u00B2,u]
         lda   u0005,u
         bne   L01BA
         lda   >u00BB,u
         tst   <$22,y
         bpl   L01E2
         tstb
         bmi   L01E2
         lda   >u00A9,u
         sta   [>u00AA,u]
         bsr   L01E3
         lda   [>u00B0,u]
L01E2    rts
L01E3    ldb   #$17
L01E5    decb
         bne   L01E5
         rts
READSK    lda   #$91
         cmpx  #$0000
         bne   L01FC
         lbra  L03BD
L01F3    bcc   L01FC
         pshs  x,b,a
         lbsr  RESTOR
         puls  x,b,a
L01FC    pshs  x,b,a
         bsr   L020D
         bcc   L0221
         cmpb  #$F6
         lbeq  L0151
         puls  x,b,a
         lsra
         bne   L01F3
L020D    bsr   L0225
         bcs   L01E2
         ldx   $08,y
         lda   #$10
         sta   >u00BD,u
         ldb   #$88
         lbsr  L0156
         lbra  L038B
L0221    leas  $04,s
         clrb
         rts
L0225    bsr   SELECT
         bcs   L028F
         bsr   L0294
         bcs   L028F
         lbra  L02F4
SELECT    lda   <$21,y
         cmpa  u0006,u
         bcc   L028C
         clr   >u00C1,u
         pshs  x,b,a
         leax  u000F,u
         ldb   #$26
         mul
         leax  d,x
         cmpx  >u00A7,u
         beq   L0268
         com   >u00C1,u
         stx   >u00A7,u
         clr   [>u00AA,u]
         lda   [>u00B2,u]
         sta   [>u00B6,u]
         clra
         sta   >u00BD,u
         ldb   #$13
         lbsr  L0196
L0268    puls  a
         leax  <L0290,pcr
         ldb   <$23,y
         andb  #$01
         beq   L0276
         ldb   #$C0
L0276    orb   a,x
         stb   [>u00AA,u]
         stb   >u00A9,u
         clr   >u00B8,u
         lda   #$20
         sta   >u00B9,u
         puls  pc,x,b
L028C    comb
         ldb   #$F0
L028F    rts
L0290    fcb   $01
         fcb   $02
         lsr   <u0008
L0294    tstb
         bne   L02F0
         tfr   x,d
         cmpd  #$0000
         beq   L02EA
         ldx   >u00A7,u
         cmpd  $01,x
         bcc   L02F0
         subd  <$2B,y
         bcc   L02B2
         addd  <$2B,y
         bra   L02EA
L02B2    stb   >u00BD,u
         clrb
         pshs  b
         ldb   <$10,x
         lsrb
         ldb   >u00BD,u
         bcc   L02D3
L02C3    com   >u00B8,u
         bne   L02CB
         inc   ,s
L02CB    subb  $03,x
         sbca  #$00
         bcc   L02C3
         bra   L02DB
L02D3    inc   ,s
         subb  $03,x
         sbca  #$00
         bcc   L02D3
L02DB    lda   <$10,x
         bita  #$02
         beq   L02E6
         clr   >u00B9,u
L02E6    puls  a
         addb  $03,x
L02EA    stb   [>u00B4,u]
         clrb
         rts
L02F0    comb
         ldb   #$F1
         rts
L02F4    pshs  a
         ldb   >u00B9,u
         orb   >u00A9,u
         stb   >u00A9,u
         stb   [>u00AA,u]
         ldx   >u00A7,u
         ldb   <$15,x
         pshs  b
         ldb   <$10,x
         lsrb
         eorb  <$24,y
         bitb  #$02
         beq   L031D
         lsla
         lsl   ,s
L031D    puls  b
         stb   [>u00B2,u]
         ldb   [>u00B0,u]
         bpl   L0353
         clr   [>u00AA,u]
         ldb   >u00A9,u
         stb   [>u00AA,u]
         lbsr  L01E3
         ldx   #$0FA0
L033B    ldb   [>u00B0,u]
         bpl   L0353
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
         leax  -$01,x
         bne   L033B
         leas  $01,s
         bra   L03B5
L0353    tst   >u00C1,u
         bne   L0360
         ldb   ,s
         cmpb  <$15,x
         beq   L0378
L0360    sta   [>u00B6,u]
         ldb   <$22,y
         andb  #$03
         eorb  #$1B
         clr   >u00BD,u
         lbsr  L0156
         lda   #$04
         sta   >u00BE,u
L0378    puls  a
         ldx   >u00A7,u
         sta   <$15,x
         sta   [>u00B2,u]
         clrb
         rts
L0387    bita  #$40
         bne   L03B9
L038B    bita  #$04
         bne   L03A5
         bita  #$08
         bne   L039D
         bita  #$10
         bne   L03A1
         bita  #$80
         bne   L03B5
         clrb
         rts
L039D    comb
         ldb   #$F3
         rts
L03A1    comb
         ldb   #$F7
         rts
L03A5    ldb   >u00BD,u
         bitb  #$20
         bne   L03B1
L03AD    comb
         ldb   #$F5
         rts
L03B1    comb
         ldb   #$F4
         rts
L03B5    comb
         ldb   #$F6
L03B8    rts
L03B9    comb
         ldb   #$F2
         rts
L03BD    lbsr  L01FC
         bcs   L03B8
         ldx   $08,y
         pshs  y,x
         tst   >u00C2,u
         bne   L03F3
         ldy   >u00A7,u
         ldb   #$14
L03D3    lda   b,x
         sta   b,y
         decb
         bpl   L03D3
         lda   <$10,y
         ldy   $02,s
         ldb   <$24,y
         bita  #$02
         beq   L03EB
         bitb  #$01
         beq   L0405
L03EB    bita  #$04
         beq   L03F3
         bitb  #$02
         beq   L0405
L03F3    bita  #$01
         beq   L03FE
         lda   <$27,y
         suba  #$02
         bcs   L0405
L03FE    clr   >u00C2,u
         clrb
         puls  pc,y,x
L0405    comb
         ldb   #$F9
         puls  pc,y,x
L040A    lbsr  SELECT
         bcs   L03B8
         lda   $09,x
         ldb   $07,x
         ldx   >u00A7,u
         stb   <$10,x
         bitb  #$01
         beq   L0422
         com   >u00B8,u
L0422    bitb  #$02
         beq   L042A
         clr   >u00B9,u
L042A    lbsr  L02F4
         ldx   $06,y
         ldx   $04,x
         ldb   #$F4
         lda   #$30
         sta   >u00BD,u
         lbsr  L0156
         ldb   [>u00AA,u]
         bitb  #$08
         beq   L0446
         lda   #$80
L0446    lbra  L0387
L0449    pshs  x,b,a
         ldx   $08,y
         pshs  x
         ldx   >u00BF,u
         stx   $08,y
         ldx   $04,s
         lbsr  READSK
         puls  x
         stx   $08,y
         bcs   L0480
         pshs  u,y
         ldy   >u00BF,u
         tfr   x,u
         clra
         ldb   #$80
         leay  d,y
         leau  d,u
L0470    ldx   a,y
         cmpx  a,u
         bne   L047C
         suba  #$02
         bne   L0470
         bra   L047E
L047C    orcc  #$01
L047E    puls  u,y
L0480    puls  pc,x,b,a

Termnt    clr   [>u00AC,u]
         ldx   #$0000
         os9   F$IRQ
         ldu   >u00BF,u
 ldd #256
 OS9 F$SRtMem Return local buffer to free mem
         rts
         emod
DSKEND      equ   *
