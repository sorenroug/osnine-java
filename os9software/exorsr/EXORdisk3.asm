 nam   EXORdisk3
 ttl   os9 device driver

 use defsfile

Edition equ 4 Current Edition

 mod DSKEND,DSKNAM,Drivr+Objct,ReEnt+3,DSKENT,DSKSTA

DriveCnt equ 4
 org DRVBEG
 rmb Drvmem*DriveCnt

 org $15

u0015    rmb   2
u0017    rmb   1
u0018    rmb   1
u0019    rmb   1
u001A    rmb   1
u001B    rmb   1
u001C    rmb   2
u001E    rmb   24
u0036    rmb   49
X.CURDRV    rmb   1
u0068    rmb   2
u006A    rmb   2
X.BUFADR    rmb   2
u006E    rmb   5
u0073    rmb   1
u0074    rmb   5
u0079    rmb   3
u007C    rmb   1
u007D    rmb   1
u007E    rmb   1
X.DRVTBL    rmb   2
u0081    rmb   2
u0083    rmb   2
u0085    rmb   2
u0087    rmb   2
CTLRADDR    rmb   2
DSKSTA     equ   .
         fcb   $FF

DSKNAM     equ   *
         fcs   /EXORdisk3/
         fcb   Edition

DSKENT    equ   *
         lbra  INIT
         lbra  READSK
         lbra  WRTDSK
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT

CTLRNAME    fcs "EXORctlr"

L0032    fcb $0F,$0A,$06,$03

 pag
****************************************************************
*
* Initialize The I/O Port
*
*  Input: (U)= Pointer To Global Storage
*
INIT    pshs  u,y
         lda   #Drivr
         leax  <CTLRNAME,pcr
         os9   F$Link
         tfr   u,x
         puls  u,y
         lbcs  L00F0
         stx   >CTLRADDR,u
         ldd   M$Exec,x
         leax  d,x
         stx   >u0083,u
         leax  $03,x
         stx   >u0085,u
         leax  $03,x
         stx   >u0087,u
         lda   <$13,y  IT.DRV
         sta   X.CURDRV,u
         lda   <$14,y  IT.STP
         anda  #$03
         leay  <L0032,pcr
         lda   a,y
         ldb   #$27  This is not DRVMEM
         mul
         std   >u0081,u
         ldy   V.PORT,u
         leax  DRVBEG,u
         stx   X.DRVTBL,u
         jsr   [>u0083,u]
         ldb   #$04
         stb   <u007E,u
         jsr   [>u0087,u]
         lda   <u007C,u
         cmpa  #$02
         bne   L009E
         ldx   #$2001
         stx   >L03C0,pcr
         stx   >L03DD,pcr
L009E    suba  #$04
         bcs   L00BA
         suba  #$03
         bcc   L00AB
         ldx   #$3084
         bra   L00B6
L00AB    leax  >L0387,pcr
         stx   >L0312,pcr
         ldx   #$12BD
L00B6    stx   >L0310,pcr
L00BA    ldx   X.DRVTBL,u
         lda   #DriveCnt
         sta   V.NDRV,u
         deca
         pshs  a
L00C4    bsr   L00CF
         leax  <$18,x
         dec   ,s
         bne   L00C4
         leas  $01,s
L00CF    ldd   #$099F
         std   $01,x
         ldd   #$0134
         std   $04,x
         ldd   #$0001
         std   $06,x
         lda   #$FF
         sta   $0D,x
         lda   #$FF
         sta   <$15,x
         ldd   #$0010
         stb   $03,x
         std   <$11,x
         clrb
L00F0    rts

* Insert delay
L00F1    pshs  x,b
         ldx   #$0360
L00F6    ldb   <u007C,u
L00F9    decb
         bne   L00F9
         leax  -1,x
         bne   L00F6
         puls  pc,x,b

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
WRTDSK    tst   [<V.PORT,u]
         lda   <$21,y
         cmpa  X.CURDRV,u
         beq   L010F
         bsr   L00F1
L010F    lda   #$80
         tst   <$28,y
         bne   L0118
         lda   #$C0
L0118    bra   L011E

*************************************************************
*
* Read Sector Command
*
* Input: B = Msb Of Logical Sector Number
*        X = Lsb'S Of Logical Sector Number
*        Y = Ptr To Path Descriptor
*        U = Ptr To Global Storage
*
* Output: 256 Bytes Of Data Returned In Buffer
*
* Error: Cc=Set, B=Error Code
*
READSK    tst   [<V.PORT,u]
         clra
L011E    jsr   [>u0085,u]
         bcs   L018D
         ldd   <u0068,u
         bne   L014F
         bsr   L014F
         bcs   L018D
         ldx   $08,y
         pshs  y,x
         ldy   X.DRVTBL,u
         ldb   <$10,x
         bitb  #$06
         bne   L018E
         ldd   $0E,x
         cmpd  $0E,y
         beq   L014C
         ldb   #$14
L0145    lda   b,x
         sta   b,y
         decb
         bpl   L0145
L014C    clrb
         puls  pc,y,x
L014F    pshs  y,x
         ldy   V.PORT,u
         jsr   [>u0087,u]
         bcc   L018B
         ldb   <u007E,u
         pshs  b
         ldb   #$08
         stb   <u007E,u
         jsr   [>u0087,u]
         puls  a
         sta   <u007E,u
         bcs   L0187
         puls  y,x
         pshs  y,x
         ldd   $08,y
         std   <X.BUFADR,u
         ldd   #$0001
         std   <u006A,u
         ldy   V.PORT,u
         jsr   [>u0087,u]
         bcc   L018B
L0187    ldb   <u006E,u
         coma
L018B    puls  y,x
L018D    rts
L018E    comb
         ldb   #E$BTyp
         puls  pc,y,x

GETSTA    clrb
         rts

PUTSTA    ldx PD.RGS,y
         ldb  R$B,x
         cmpb  #SS.RST $03 Device Restore
         beq   L01A5
         cmpb  #SS.WTK $04 Device Write Track
         beq   L01BE
         comb
         ldb   #E$USvc Unknown Service request
         rts

* Restore head to track 0
L01A5    pshs  y,x
         clrb
         ldx   #$0000
         lda   #$08
         jsr   [>u0085,u]
         bcs   L018D
         ldy   V.PORT,u
         jsr   [>u0087,u]
         bcs   L0187
         puls  pc,y,x

* Format track
L01BE    pshs  y,x
         ldb   <$2A,y
         tst   <u0073,u
         bmi   L01CB
         addb  <$2A,y
L01CB    lda   $09,x
         bne   L01F6
         pshs  x,b,a
         ldx   X.DRVTBL,u
         clr   <$10,x
         clr   $0E,x
         clr   $0F,x
         lda   <$27,y
         cmpa  #$01
         beq   L01E5
         inc   <$10,x
L01E5    ldb   <$25,y
         mul
         lda   <$2A,y
         mul
         subd  #$0001
         std   $01,x
         clr   ,x
         puls  x,b,a
L01F6    mul
         pshs  b,a
         clrb
         lda   $07,x
         anda  #$01
         beq   L0203
         ldb   <$2A,y
L0203    clra
         addd  ,s++
         tfr   d,x
         clrb
         lda   #$10
         jsr   [>u0085,u]
         lbcs  L018B
         ldy   V.PORT,u
         jsr   [>u0087,u]
         lbcs  L018B
         ldy   $02,s
         bsr   L0262
         lbcs  L018B
         leax  <L0246,pcr
         stx   <X.BUFADR,u
         ldd   #$0010
         std   <u006A,u
         ldb   #$C2
         stb   <u007E,u
         ldy   V.PORT,u
         jsr   [>u0087,u]
         lbcs  L0187
         clrb
         puls  pc,y,x

L0246    fcb $E5,$E5

TRMNAT    ldx   V.PORT,u
         lda   ,x
         ora   #$10
         sta   ,x
         clra
         clrb
         std   $02,x
         std   ,x
         pshs  u
         ldu   >CTLRADDR,u
         os9   F$UnLk
         clrb
         puls  pc,u

L0262    leax  >L03FC,pcr
         lda   <$2D,y   PD.ILV
         anda  #$03
         deca
         ldb   #$10  Number of sectors on a track
         mul
         leax  d,x
         stx   <u0015
         clra
         sta   <u0017
         lda   <u007D,u
         sta   <u0018
         lda   <u0074,u
         sta   <u001A
         lda   #$05
         sta   <u001B
         lda   <u0079,u
         sta   <u0019
         ldy   V.PORT,u
         pshs  u
         sts   <u001C
         ldb   ,y
         orb   #$04
         cmpa  #$2B
         bls   L029B
         andb  #$FB
L029B    stb   ,y
         lda   $01,y
         ora   #$40
         tst   <u001A
         beq   L02A9
         anda  #$20
         ora   #$03
L02A9    sta   $01,y
L02AB    lbsr  L038C
         ldx   #$001E
         lda   <u0018
L02B3    deca
         bpl   L02B3
         ldu   #$C0DA
         stu   $04,y
         ldu   #$C1FF
         stu   $04,y
         ldu   #$8270
         stu   $04,y
         lda   $01,y
         anda  #$F2
         sta   $01,y
         eora  #$00
         bita  #$10
         bne   L02D9
         lbsr  L03A8
         comb
         ldb   #E$WP
         puls  pc,u

L02D9    anda  #$60
         sta   $01,y
L02DD    lda   $03,y
         bpl   L02DD
         ldu   #$8210
         stu   $04,y
         lbsr  L03B8
         ldu   #$83F7
         stu   $04,y
         lda   #$7A
         sta   $05,y
         ldu   #$81FF
         stu   $04,y
         ldx   #$000C
L02FA    lda   #$18
         ldu   #$8210
         stu   $04,y
L0301    bita  $04,y
         beq   L0301
         sta   $05,y
L0307    bita  $04,y
         beq   L0307
         ldu   #$C270
         stu   $04,y
L0310    bita  #$00
L0312    lda   #$82
         inc   $01,y
         sta   $04,y
         lbsr  L03B8
         dec   $01,y
         ldu   #$83F5
         stu   $04,y
         ldb   #$7E
         lda   #$40
         stb   $05,y
L0328    bita  $04,y
         beq   L0328
         ldb   <u0019
         stb   $05,y
         ldb   <u001A
         stb   $05,y
         ldu   <u0015
L0336    bita  $04,y
         beq   L0336
         ldb   ,u+
         stb   $05,y
         ldb   #$01
         stb   $05,y
         stu   <u0015
L0344    bita  $04,y
         beq   L0344
         clrb
         stb   $05,y
L034B    bita  $04,y
         beq   L034B
         ldb   $01,y
         orb   #$08
         stb   $01,y
         stb   $05,y
L0357    bita  $04,y
         beq   L0357
         lda   #$FF
         sta   $05,y
         lda   #$40
L0361    bita  $04,y
         beq   L0361
         andb  #$60
         stb   $01,y
         ldu   #$81FF
         stu   $04,y
         ldx   #$011D
         lda   <u0017
         inca
         sta   <u0017
         cmpa  #$10
         bne   L02FA
L037A    lda   $03,y
         bpl   L037A
         dec   $01,y
         dec   $01,y
         bsr   L03A8
         clrb
         puls  pc,u

L0387    lda   #$82
         bita  <u0019
         rts
L038C    pshs  x
         orcc  #$50
         ldx   <u0036
         stx   <u001E
         leax  <L03E8,pcr
         stx   <u0036
         lda   #$36
         sta   $03,y
         lda   #$3E
         sta   $03,y
         ldb   ,y
         deca
         sta   $02,y
         puls  pc,x
L03A8    pshs  x
         lda   #$3C
         sta   $02,y
         lda   ,y
         ldx   <u001E
         stx   <u0036
         andcc #$AF
         puls  pc,x

L03B8    lda   #$18
L03BA    bita  $04,y
         beq   L03BA
         ldb   <u0018
L03C0    decb
         bne   L03C0
         sta   $05,y
         leax  -$01,x
         bne   L03BA
         ldu   #$81AA
         ldb   #$05
         nop
         nop
         stu   $04,y
         ldu   #$8210
         stu   $04,y
L03D7    bita  $04,y
         beq   L03D7
         lda   <u0018
L03DD    deca
         bne   L03DD
         lda   #$18
         sta   $05,y
         decb
         bne   L03D7
         rts

L03E8    lds   <u001C
         bsr   L03A8
         dec   $01,y
         dec   $01,y
         dec   <u001B
         lbne  L02AB
         comb
         ldb   #E$Wr Write Error
         puls  pc,u

L03FC    fcb $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
         fcb $00,$08,$01,$09,$02,$0A,$03,$0B,$04,$0C,$05,$0D,$06,$0E,$07,$0F
         fcb $00,$0B,$06,$01,$0C,$07,$02,$0D,$08,$03,$0E,$09,$04,$0F,$0A,$05

 emod
DSKEND equ  *
