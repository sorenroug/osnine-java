********************************************************************
* RunB - Basic09 Runtime
*
*
* Edt/Rev  YYYY/MM/DD  Modified by
* Comment
* ------------------------------------------------------------------
*  22      2002/12/26  Boisy G. Pitre
* Acquired Tandy/Microware version.
*
*          2003/05/13  Robert Gault
* Tables L000D, L00EC removed some UNID, translated jump
* vectors L00DC, L0442.
*
* 06/07/14 - Minor change to Date$ to accommodate F$Time Y2K changes. RG
         nam   RunB
         ttl   Basic09 Runtime

         ifp1
         use   defsfile
         endc

tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
edition  set   22

L0000    mod   eom,name,tylg,atrv,start,dsize

membase  rmb   2          Start of data memory / DP pointer
memsize  rmb   2
moddir   rmb   4
restop   rmb   2                        top of reserved space
u000A    rmb   1
u000B    rmb   1
FREEMEM  rmb   2
table1   rmb   2
table2   rmb   2
table3   rmb   2
u0014    rmb   2
u0016    rmb   1
u0017    rmb   1
u0018    rmb   1
u0019    rmb   2
u001B    rmb   1
u001C    rmb   2
u001E    rmb   1
u001F    rmb   2
u0021    rmb   1
u0022    rmb   2
u0024    rmb   2
u0026    rmb   1
u0027    rmb   1
u0028    rmb   2
u002A    rmb   3
u002D    rmb   1
errpath  rmb   1
pgmaddr  rmb   1                        starting address of program
u0030    rmb   1
u0031    rmb   1
u0032    rmb   1
u0033    rmb   1
u0034    rmb   1
u0035    rmb   1
errcode  rmb   3
DATAPtr  rmb   2
u003B    rmb   1
u003C    rmb   2
u003E    rmb   1
u003F    rmb   1
u0040    rmb   2
u0042    rmb   1
u0043    rmb   1
u0044    rmb   2
u0046    rmb   2
u0048    rmb   2
u004A    rmb   1
u004B    rmb   1
u004C    rmb   1
u004D    rmb   1
u004E    rmb   2
u0050    rmb   1
u0051    rmb   1
u0052    rmb   1
u0053    rmb   1
u0054    rmb   1
u0055    rmb   1
u0056    rmb   1
u0057    rmb   1
u0058    rmb   1
u0059    rmb   1
u005A    rmb   2
u005C    rmb   2
u005E    rmb   1
u005F    rmb   1
u0060    rmb   2
u0062    rmb   2
u0064    rmb   2
u0066    rmb   1
u0067    rmb   1
u0068    rmb   2
u006A    rmb   1
u006B    rmb   1
u006C    rmb   1
u006D    rmb   1
u006E    rmb   2
u0070    rmb   2
u0072    rmb   2
u0074    rmb   1
u0075    rmb   1
u0076    rmb   1
u0077    rmb   1
u0078    rmb   1
u0079    rmb   1
u007A    rmb   1
u007B    rmb   1
u007C    rmb   1
u007D    rmb   1
u007E    rmb   1
u007F    rmb   1
u0080    rmb   1
u0081    rmb   1
u0082    rmb   3
u0085    rmb   1
u0086    rmb   1
u0087    rmb   1
u0088    rmb   1
u0089    rmb   1
u008A    rmb   1
u008B    rmb   1
u008C    rmb   1
u008D    rmb   1
u008E    rmb   2
u0090    rmb   1
u0091    rmb   1
u0092    rmb   1
u0093    rmb   1
u0094    rmb   1
u0095    rmb   1
u0096    rmb   1
u0097    rmb   2
u0099    rmb   1
u009A    rmb   1
u009B    rmb   1
u009C    rmb   1
u009D    rmb   1
u009E    rmb   2
u00A0    rmb   2
u00A2    rmb   1
u00A3    rmb   1
u00A4    rmb   1
u00A5    rmb   1
u00A6    rmb   1
u00A7    rmb   1
u00A8    rmb   1
u00A9    rmb   1
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   1
u00AD    rmb   1
u00AE    rmb   1
u00AF    rmb   2
u00B1    rmb   2
u00B3    rmb   1
u00B4    rmb   3
u00B7    rmb   2
u00B9    rmb   1
u00BA    rmb   1
u00BB    rmb   1
u00BC    rmb   1
u00BD    rmb   1
u00BE    rmb   3
u00C1    rmb   1
u00C2    rmb   2
u00C4    rmb   1
u00C5    rmb   1
u00C6    rmb   3
u00C9    rmb   1
u00CA    rmb   1
u00CB    rmb   1
u00CC    rmb   1
u00CD    rmb   1
u00CE    rmb   1
u00CF    rmb   1
u00D0    rmb   1
u00D1    rmb   1
u00D2    rmb   1
u00D3    rmb   4
u00D7    rmb   2
u00D9    rmb   1
u00DA    rmb   2
u00DC    rmb   1
u00DD    rmb   1
u00DE    rmb   1
u00DF    rmb   1
u00E0    rmb   1
u00E1    rmb   1
u00E2    rmb   3
u00E5    rmb   2
u00E7    rmb   1
u00E8    rmb   2
u00EA    rmb   1
u00EB    rmb   3
u00EE    rmb   3
u00F1    rmb   1
u00F2    rmb   3
u00F5    rmb   4
u00F9    rmb   1
u00FA    rmb   3
u00FD    rmb   1
u00FE    rmb   1
u00FF    rmb   1
u0100    rmb   $100       256 byte temporary buffer for various things
u0200    rmb   $100       ??? ($200-$2ff) built backwards 2 bytes/time
u0300    rmb   $100       BASIC09 stack area ($300-$3ff)
u0400    rmb   $100       List of module ptrs (modules in BASIC09 workspace)
u0500    rmb   $100       I-Code buffer (for running)
u0600    rmb   $1000-.    Default buffer for BASIC09 programs & data
dsize    equ   .

L000D    fdb   L00DC
         fdb   L0468
         fdb   L06D8
         fdb   L31E8      $24 jump vector
         fdb   L3C09      $27 jump vector
         fdb   L5084      $2A jump vector
         fdb   $0000

name     fcs   /RunB/
         fcb   edition
         fcb   $06

         fcb   $0C   Clear screen on 32x16 display
         fcc   "            BASIC09"
         fcb   C$LF
         fcc   "      RS VERSION 01.00.00"
         fcb   C$LF
         fcc   "COPYRIGHT 1980 BY MOTOROLA INC."
         fcb   C$LF
         fcc   "  AND MICROWARE SYSTEMS CORP."
         fcb   C$LF
         fcc   "   REPRODUCED UNDER LICENSE"
         fcb   C$LF
         fcc   "       TO TANDY CORP."
         fcb   C$LF
         fcc   "    ALL RIGHTS RESERVED."
         fcb   $8A

* Jump vector @ $1B goes here
L00DC    pshs  x,d        Preserve regs
         ldb   [<$04,s]   Get function offset
         leax  <L00EC,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  d,x,pc

L00EC    fdb   L03E9-L00EC
         fdb   L040E-L00EC
         fdb   L024E-L00EC
         fdb   L0244-L00EC
         fdb   L0412-L00EC
         fdb   L0365-L00EC
         fdb   BYE-L00EC
         fdb   L0381-L00EC
         fdb   L0433-L00EC

J010A    jsr   <u001E
         fcb   $04
J010D    jsr   <u001E
         fcb   $02
J0110    jsr   <u001E
         fcb   $00
J0113    jsr   <u0021
         fcb   $00
L0107    jsr   <u0024
         fcb   $00
L010A    jsr   <u0024
         fcb   $04
L010D    jsr   <u0024
         fcb   $02
L0110    jsr   <u002A
         fcb   $02

         fcb   $0e    Control code to display alpha
         fcs   "Ready"
         fcs   "What?"
         fcs   " free"
J074F    fcs   "Program"
         fcs   "PROCEDURE"
         fcb   C$CR
         fcb   C$LF
         fcs   "  Name      Proc-Size  Data-Size"
         fcc   "Rewrite?: "
         fcc   "RANGE"
         fcb   $87

         fcb   $0E    Control code to display alpha
         fcs   "BREAK: "
         fcs   "called by"
         fcs   "ok"
         fcs   "D:"
         fcs   "E:"
         fcs   "B:"
         fcs  "can't find:"

* F$Icpt routine
L0189    lda   R$DP,s
         tfr   a,dp
         stb   <u0035
         lsl   <u0034
         coma
         ror   <u0034
         rti

start    pshs  u                        save start of data mem into D
         leau  256,u                    point to end of DP
         clra                           clear all of DP to $00
         clrb
L019D    std   ,--u
         cmpu  ,s
         bhi   L019D
         puls  b,a                      get start of data mem into D
         leau  ,x                       point U to start of parameter area
         std   <membase                 preserve start of data memory ptr
         inca                           point to $100 in data area
         sta   <u00D9                   preserve it
         std   <u0080                   initialize ptr to start of temp buffer
         std   <u0082                   initialize current pos. in temp buffer
         adda  #$02
         std   <u0046
         std   <u0044
         inca
         tfr   d,s
         std   <moddir
         inca
         std   <restop
         std   <u004A
         tfr   u,d
         subd  <membase
         std   <memsize
         clra
         ldb   #$01             default err path
         std   <u002D
         sta   <u00BD
         lda   #$03             close paths 4-16
L01D0    os9   I$Close
         inca
         cmpa  #16
         bcs   L01D0
         lda   #$02
         os9   I$Dup
         sta   <u00BE     Preserve duplicate's path #
         clr   <u0035
         pshs  x
         leax  <L0189,pcr
         os9   F$Icpt
         ldx   <restop
         clra
         clrb
L01ED    std   ,--x
         cmpx  <moddir
         bhi   L01ED
         leax  >L0000,pcr
         pshs  x
         ldx   <membase
         leax  <$1B,x
         leay  >L000D,pcr
L0202    lda   #$7E
         sta   ,x+
         ldd   ,y++
         addd  ,s
         std   ,x++
         ldd   ,y
         bne   L0202
         leas  $02,s
         lbsr  L0107
         puls  y

  ifeq B09EXEC-false
         bsr   L0222
         ldx   <moddir
         ldd   ,x
         std   <pgmaddr
         lbsr  L02B9
L0222    leax  <L025B,pcr
         puls  u
         bsr   L024E
         pshs  u
         clr   <u0034
         ldd   <membase
         addd  <memsize
         subd  <restop
         subd  <u000A
         std   <FREEMEM
         leau  $02,s
         stu   <u0046
         stu   <u0044
         leas  >-$00FE,s
         jmp   [<-2,u]
L0244    lds   <u00B7
         puls  b,a
         std   <u00B7
         lbra  L02AD
L024E    ldd   <u00B7
         pshs  b,a
         sts   <u00B7
         ldd   $02,s
         stx   $02,s
         tfr   d,pc

L025B    bsr   L0222
         lbra  BYE
         ldb   #$2C
L0262    lbsr  L040E
         lbra  L0244
L0268    ldb   #$2B
         bra   L0262
         ldb   ,y+
         cmpb  #$2C
         beq   L0278
         cmpb  #$20
         beq   L0278
         leay  -$01,y
L0278    rts
 endc
L0279    lbsr  J010D
         bne   L028C
         ldy   <pgmaddr
         beq   L0288
         ldd   $04,y
         leay  d,y
         rts
L0288    leay  >J074F,pcr
L028C    rts

L028D    ldu   <u0046
         stu   <u0044
         ldx   <moddir
L0293    ldd   ,x
         beq   L029B
         tfr   x,d
         leax  $02,x
L029B    std   ,--u
         bne   L0293
         stu   <u0044
         lda   ,y
         cmpa  #$0D
         beq   L02A9
         leay  $01,y
L02A9    sty   <u0082
         rts

L02AD    clr   <u007D
         inc   <u007D
         pshs  x
         ldx   <u0080
         stx   <u0082
         puls  pc,x
L02B9    lbsr  J010D
         bne   L02D1
         pshs  y
         lbsr  L0279
         ldx   ,s
L02C5    lda   ,y+
         sta   ,x+
         bpl   L02C5
         lda   #$0D
         sta   ,x
         puls  y
L02D1    lbsr  L03E9
         lbcs  L0268
         ldx   ,x
         stx   <pgmaddr
         lda   $06,x
         beq   L02E8
         anda  #$0F
         cmpa  #$02             Basic09 program?
         bne   L035A
         bra   L02EE

L02E8    lda   <$17,x           Basic09 program has no errors?
         rora
         bcs   L035A            errors, report it
L02EE    lbsr  J0110            check param list
         ldy   <u004A
         ldb   ,y
         cmpb  #$3D
         beq   L035A
         sty   <u005E
         sty   <u005C
         ldx   <u00AB
         stx   <u0060
         stx   <u004A
         ldd   <FREEMEM
         pshs  y,b,a
         lbsr  J0113
         puls  y,b,a
         std   <FREEMEM
         sty   <u004A
         ldx   <pgmaddr
         lda   <$17,x
         rora
         bcs   L035A
         leas  >$0102,s
         ldd   <membase
         addd  <memsize
         tfr   d,y
         std   <u0046
         std   <u0044
         ldu   #$0000
         stu   <u0031
         stu   <u00B3
         inc   <u00B4
         clr   <errcode
         ldd   <u004A
         ldx   <FREEMEM
         pshs  x,b,a
         leax  >L0351,pcr
         lbsr  L024E
         ldx   <u004A
         lbsr  L010A
         lbsr  L02AD
         ldx   <pgmaddr
         lbsr  L010D
         bra   L0357
L0351    puls  x,b,a
         std   <u004A
         stx   <FREEMEM
L0357    lbra  L0244

L035A    ldb   #$33
         lbra  L0262

* System mode - BYE
BYE    bsr   L0381
         clrb
         os9   F$Exit

L0365    lbsr  J010D
         beq   L037D
         lbsr  L03C6
         bcs   L037D
         ldu   <u0046
         clra
         clrb
         pshu  x,b,a
         inca
         sta   <u0035
         bsr   L0391
         clr   <u0035
         rts

L037D    comb
         ldb   #E$UnkPrc
         rts

L0381    ldy   <u0082
         lda   #$2A
         sta   ,y
         sta   <u0035
         lbsr  L028D
         clr   <pgmaddr
         clr   <u0030
L0391    ldu   <u0046
         stu   <u0044
         bra   L03A7
L0397    ldx   ,x
         pshs  u
         leau  ,x
         os9   F$UnLink
         puls  u

         ldd   #$FFFF
         std   [,u]
L03A7    ldx   ,--u
         bne   L0397
         ldx   <moddir
         tfr   x,y
L03AF    ldd   ,x++
         cmpd  #$FFFF
         beq   L03AF
L03B7    std   ,y++
         bne   L03AF
         cmpd  ,y
         bne   L03B7
         rts

L03C1    ldb   #E$MFull
         lbra  L0262

L03C6    pshs  u,y
         ldx   <moddir
L03CA    ldy   ,s
         ldu   ,x++
         beq   L03E6
         ldd   4,u
         leau  d,u
L03D5    lda   ,y+
         eora  ,u+
         anda  #$DF
         bne   L03CA
         clra
         tst   -1,u
         bpl   L03D5
L03E2    leax  -$02,x
         puls  pc,u,b,a
L03E6    coma
         bra   L03E2
L03E9    bsr   L03C6
         bcs   L03EE
         rts
L03EE    pshs  u,y,x
         ldb   $01,s
         cmpb  #$FE
         beq   L03C1
         leax  ,y
         clra
         clrb
         os9   F$Link
         bcc   L0408
         ldx   $02,s
         clra
         clrb
         os9   F$Load
         bcs   L040C
L0408    stx   $02,s
         stu   [,s]
L040C    puls  pc,u,y,x

L040E    os9   F$PErr
         rts

UNID1
L0412    pshs  b,a
         bra   L0426
L0416    pshs  y,x
L0418    lda   ,x+
         cmpa  #$FF
         beq   L042E
         cmpa  ,y+
         beq   L0418
         puls  y,x
         leay  $01,y
L0426    cmpy  ,s
         bls   L0416
         coma
         puls  pc,b,a
L042E    puls  y,x
         clra
L0431    puls  pc,b,a      this probably does not need lable
L0433    pshs  x,b,a
L0435    leax  <L0442,pcr
         lda   ,y+
L043A    cmpa  ,x++
         bcs   L043A
         ldb   ,-x
         jmp   b,x

*embedded jumptable            second value
L0442    fcb   $f2
         fcb   L045A-*  *$17
L0444    fcb   $92
         fcb   L045E-*  *$19
L0446    fcb   $91
         fcb   L045A-*  *$13
L0448    fcb   $90
         fcb   L0460-*  *$17
L044A    fcb   $8f
         fcb   L0458-*  *$0D
L044C    fcb   $8e
         fcb   L045A-*  *$0D
L044E    fcb   $8d
         fcb   L045C-*  *$0D
L0450    fcb   $55
         fcb   L045A-*  *$09
L0452    fcb   $4b
         fcb   L045E-*  *$0B
L0454    fcb   $3e
         fcb   L0466-*  *$11
L0456    fcb   $00
         fcb   L045E-*  *$07
L0458    leay  $03,y
L045A    leay  $01,y
L045C    leay  $01,y
L045E    bra   L0435
L0460    tst   ,y+
         bpl   L0460
         bra   L0435
L0466    puls  pc,x,b,a

L0468    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L0478,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L0478    fdb   LAX1-L0478
         fdb   LAX2-L0478
         fdb   L06A8-L0478
         fdb   L0686-L0478

L0480    jsr   <u001B
         fcb   $02
L0483    jsr   <u001B
         fcb   $04
L0486    jsr   <u001B
         fcb   $06
L0489    jsr   <u002A
         fcb   $00
         fdb   $0007
         fcb   $03
L048F    fcb   $cb
         fdb   $4b0c,$accb,$4d0c,$a8cb,$4e0c,$a9d4,$890c,$ae21
         fdb   $9006,$a200,$9106,$a4cb,$3f02
         fcb   $8d

L04AB    lda   <u000B
L04AD    pshs  a
         ldx   <u00A7
         lda   #$0D
L04B3    lsl   ,x
         lsr   ,x
         cmpa  ,x+
         bne   L04B3
         ldx   <u00A7
         bsr   PrintErr
         ldd   <u00B9
         subd  <u00A7
         pshs  b
         ldx   <u00AF
         stx   <u00AB
         ldy   <u00A7
         lda   #$3D
         lbsr  L0607
         lda   #$3F
         lbsr  L0607
         lda   #$20
         ldx   <u0080
L04DA    sta   ,x+
         dec   ,s
         bpl   L04DA
         ldd   #$5E0D
         std   -$01,x
         ldx   <u0080
         bsr   PrintErr
         puls  b,a
         lbsr  L0480
         ldx   <u0046
         stx   <u0044
         lbra  L0486

PrintErr ldy   #$0100
         lda   <errpath
         os9   I$WritLn
         rts

**** decode passed parameters ****
L04FF    sty   <u00A7
         ldx   <u004A
         stx   <u00AF
         stx   <u00AB
         clr   <u00BB
         clr   <u00BC
         rts

LAX1     bsr   L04FF
         inc   <u00A0
         lbsr  L0542
         bsr   L0523
         clr   <u00A0
         lda   <u00A3
         cmpa  #$3F
         lbne  L04AB
L0520    lbra  L0607
L0523    cmpa  #$4D
         bne   L0541
L0527    bsr   L0520
         ldd   <u00AB
         lbsr  L056B
         ldb   <u00A4
         cmpb  #$06
         bne   L0541
         lbsr  L0542
         lbsr  L054C
         beq   L0527
         pshs  a
         lbra  L055D
L0541    rts
L0542    lbsr  L056B
         ldx   <u00AD
         stx   <u00AB
         lda   <u00A3
         rts
L054C    lda   <u00A3
         cmpa  #$4B
         rts
L0551    rts
L0552    lda   <u00A3
         cmpa  #$4E
         beq   L0551
         lda   #$25
L055A    lbra  L04AD
L055D    bsr   L0552
         puls  a
         lbsr  L0607
         lbra  L0542
L0567    lda   #$0A
         bra   L055A
L056B    ldd   <u00AB
         std   <u00AD
         lbsr  SkipSpac
         sty   <u00B9
         lda   ,y
         lbsr  IsNum
         bcc   L05A0
         leax  >L048F,pcr
         lda   #$80
         lbsr  L06A8
         beq   L0567
         ldb   ,x
         leau  <L05C3,pcr
         jmp   b,u
L058E    ldd   $01,x
         stb   <u00A4
         sta   <u00A3
         lbra  L0607
         lda   ,y
         lbsr  IsNum
         bcs   L058E
         leay  -$01,y
L05A0    bsr   L05CC
         bne   L05B5
         ldd   #$8F05
L05A7    sta   <u00A3
L05A9    bsr   L05FC
         lda   ,x+
         decb
         bpl   L05A9
         lda   #$06
         sta   <u00A4
         rts
L05B5    ldd   #$8E02
         tst   ,x
         bne   L05A7
         ldd   #$8D01
         leax  $01,x
         bra   L05A7
L05C3    leay  -$01,y
         bsr   L05CC
         ldd   #$9102
         bra   L05A7
L05CC    lbsr  SkipSpac
         leax  ,y
         ldy   <u0044
         lbsr  L0489
         exg   x,y
         bcs   L05E0
         lda   ,x+
         cmpa  #$02
         rts
L05E0    lda   #$16
         bra   L0600
         bsr   L058E
         bra   L05EA
L05E8    bsr   L0607
L05EA    lda   ,y+
         cmpa  #$0D
         beq   L05FE
         cmpa  #$22
         bne   L05E8
         cmpa  ,y+
         beq   L05E8
         leay  -$01,y
         lda   #$FF
L05FC    bra   L0607
L05FE    lda   #$29
L0600    lbra  L04AD
         lda   #$31
         bra   L0600
L0607    pshs  x,b,a
         ldx   <u00AB
         sta   ,x+
         stx   <u00AB
         ldd   <u00AB
         subd  <u004A
         cmpb  #$FF
         bcc   L061A
         clra
         puls  pc,x,b,a
L061A    lda   #$0D
         lbsr  L0480
         lbra  L0486

LAX2     bsr   SkipSpac
         pshs  y
         ldb   #$02
         stb   <u00A5
         clrb
         bsr   IsAlpha
         bcs   L064B
         leay  $01,y
L0631    incb
         lda   ,y+
         bsr   L246A
         bcc   L0631
         cmpa  #$24
         bne   L0643
         incb
         leay  $01,y
         lda   #$04
         sta   <u00A5
L0643    leay  -$01,y
         lda   #$80
         ora   -$01,y
         sta   -$01,y
L064B    stb   <u00A6
         puls  pc,y

SkipSpac lda   ,y+
         cmpa  #C$SPAC
         beq   SkipSpac
         cmpa  #C$LF
         beq   SkipSpac
         leay  -$01,y
         rts

L246A    bsr   IsAlpha
         bcc   L2493
IsNum    cmpa  #$30             0??
         bcs   L2493
         cmpa  #$39             0??
         bls   L2491
         bra   L248E

IsAlpha  anda  #$7F
         cmpa  #$41
         bcs   L2493
         cmpa  #$5A
         bls   L2491
         cmpa  #$5F
         beq   L2493
         cmpa  #$61
         bcs   L2493
         cmpa  #$7A
         bls   L2491
L248E    orcc  #Carry           no
         rts
L2491    andcc #^Carry          yes
L2493    rts

L0686    pshs  x,b,a
         leax  d,u
         pshs  x
L068C    bitb  #$03
         beq   L069D
         lda   ,u+
         sta   ,y+
         decb
         bra   L068C
L0697    pulu  x,b,a
         std   ,y++
         stx   ,y++
L069D    cmpu  ,s
         bcs   L0697
         clr   ,s++
         puls  pc,x,b,a
         lda   #$20
L06A8    pshs  u,y,x,a
         ldu   -$03,x
         ldb   -$01,x
L06AE    stx   $01,s
         cmpu  #$0000
         beq   L06D6
         leau  -1,u
         ldy   $03,s
         leax  b,x
L06BD    lda   ,x+
         eora  ,y+
         beq   L06CF
         cmpa  ,s
         beq   L06CF
         leax  -$01,x
L06C9    lda   ,x+
         bpl   L06C9
         bra   L06AE
L06CF    tst   -$01,x
         bpl   L06BD
         sty   $03,s
L06D6    puls  pc,u,y,x,a
L06D8    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L06E8,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a
L06E8    neg   <memsize
         rts

* START SHARE WITH BASIC09

* Called by <$24 JMP vector
* Entry: X=byte after the last vector installed ($2D)
*        D=Last vector offset from start of BASIC09's module header
* Based on function code following the JMP that came here, this routine
*  modifies the return address to 1 of 7 routines
UNID2
L31E8    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L31F8,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L31F8    fdb   UNK5-L31F8
         fdb   UNK6-L31F8
         fdb   UNK7-L31F8
         fdb   UNK8-L31F8
         fdb   UNK9-L31F8
         fdb   UNK10-L31F8
         fdb   UNK11-L31F8

L3206    jsr   <u001B
         fcb   $06
L3209    jsr   <u001B
         fcb   $0C
L320C    jsr   <u001B
         fcb   $0E
L320F    jsr   <u001B
         fcb   $02
L3212    jsr   <u001B
         fcb   $00
L3215    jsr   <u001B
         fcb   $0A
L3218    jsr   <u001B
         fcb   $10
L321B    jsr   <u001E
         fcb   $06
L321E    jsr   <u0027
         fcb   $04
L3221    jsr   <u0027
         fcb   $0A
L3224    jsr   <u0027
         fcb   $02
L3227    jsr   <u0027
         fcb   $0C
L322A    jsr   <u0027
         fcb   $0E
L322D    jsr   <u0027
         fcb   $00
L3230    jsr   <u002A     Use module header jump vector #6
         fcb   $02        Function code

L323F    fdb   L3A51-L323F
         fdb   L3A51-L323F              PARAM
         fdb   L3A51-L323F              TYPE
         fdb   L3A51-L323F              DIM
         fdb   L3A51-L323F              DATA
         fdb   STOP-L323F
         fdb   UNK1-L323F
         fdb   L0F3F-L323F
         fdb   L0F49-L323F
         fdb   PAUSE-L323F
         fdb   DEG-L323F
         fdb   RAD-L323F
         fdb   RETURN-L323F
         fdb   L33AE-L323F
         fdb   LET-L323F
         fdb   POKE-L323F
         fdb   IF-L323F
         fdb   GOTO-L323F               ELSE
         fdb   ENDIF-L323F
         fdb   FOR-L323F
         fdb   NEXT-L323F
         fdb   UNTIL-L323F              WHILE
         fdb   GOTO-L323F               ENDWHILE
         fdb   L33AE-L323F
         fdb   UNTIL-L323F
         fdb   L33AE-L323F              LOOP
         fdb   GOTO-L323F               ENDLOOP
         fdb   UNTIL-L323F              EXITIF
         fdb   GOTO-L323F               ENDEXIT
         fdb   ON-L323F
         fdb   ERROR-L323F
         fdb   ERRS51-L323F
         fdb   GOTO-L323F
         fdb   ERRS51-L323F
         fdb   GOSUB-L323F
         fdb   RUN-L323F
         fdb   KILL-L323F
         fdb   INPUT-L323F
         fdb   PRINT-L323F
         fdb   CHD-L323F
         fdb   CHX-L323F
         fdb   CREATE-L323F
         fdb   OPEN-L323F
         fdb   SEEK-L323F
         fdb   READ-L323F
         fdb   WRITE-L323F
         fdb   GET-L323F
         fdb   PUT-L323F
         fdb   CLOSE-L323F
         fdb   RESTORE-L323F
         fdb   DELETE-L323F
         fdb   CHAIN-L323F
         fdb   SHELL-L323F
         fdb   BASE0-L323F
         fdb   BASE1-L323F
         fdb   UNK4-L323F               REM
         fdb   UNK4-L323F
         fdb   END-L323F
         fdb   L33AC-L323F
         fdb   L33AC-L323F
         fdb   UNK3-L323F
         fdb   ERRS51-L323F
         fdb   L33AB-L323F              RTS
         fdb   L33AB-L323F
         fdb   CpMbyte-L323F
         fdb   CpMint-L323F
         fdb   CpMreal-L323F
         fdb   CpMbyte-L323F
         fdb   CpMstrin-L323F
         fdb   CpMarray-L323F

L32CB    fcc   "STOP Encountered"
         fcb   C$LF,$ff

UNK6
L32DD    lda   <$17,x
         bita  #1
         beq   L32E8
         ldb   #$33
         bra   L3304

L32E8    tfr   s,d
         subd  #$0100
         cmpd  <u0080
         bcc   L32F6
         ldb   #$39
         bra   L3304
L32F6    ldd   <FREEMEM
         subd  $0B,x
         bcs   L3302
         cmpd  #$0100
         bcc   L3307
L3302    ldb   #$20
L3304    lbra  L39FB
L3307    std   <FREEMEM
         tfr   y,d
         subd  $0B,x
         exg   d,u
         sts   5,u
         std   7,u
         stx   3,u
L3316    ldd   #$0001
         std   <u0042
         sta   1,u
         sta   <$13,u
         stu   <$14,u
         bsr   L3351
         ldd   <$13,x
         beq   L332C
         addd  <u005E
L332C    std   <DATAPtr
         ldd   $0B,x
         leay  d,u
         pshs  y
         ldd   <$11,x
         leay  d,u
         clra
         clrb
         bra   L333F
L333D    std   ,y++
L333F    cmpy  ,s
         bcs   L333D
         leas  $02,s
         ldx   <pgmaddr
         ldd   <u005E
         addd  <$15,x
         tfr   d,x
         bra   L3391
L3351    stx   <pgmaddr
         stu   <u0031
         ldd   $0D,x
         addd  <pgmaddr
         std   <u0062
         ldd   $0F,x
         addd  <pgmaddr
         std   <u0066
         std   <u0060
         ldd   $09,x
         addd  <pgmaddr
         std   <u005E
         ldd   <$14,u
         std   <u0046
         std   <u0044
         rts
L3371    stx   <u005C


*** MAIN LOOP
         lda   <u0034           check if signal received
* DIFFERENCE
         beq   L338F            no, execute next instruction
         bpl   L338F            else flag signal received
         anda  #$7F
         sta   <u0034
         ldb   <u0035
         bra   L3304            process it
* END DIFFERENCE
L338F    bsr   L33AE
L3391    cmpx  <u0060
         bcs   L3371
         bra   L33A1

END      ldb   ,x
         lbsr  NextInst
         beq   L33A1
         lbsr  PRINT
L33A1    lbsr  L0F49
         ldu   <u0031
         lds   5,u
         ldu   7,u
L33AB    rts

L33AC    leax  $02,x
UNK9
L33AE    ldb   ,x+
         bpl   L33B4
         addb  #$40
L33B4    lslb
         clra
         ldu   <table1
         ldd   d,u
         jmp   d,u              go to instruction

IF       jsr   <u0016           if...
         tst   $02,y
         beq   GOTO             = FALSE
         leax  $03,x            THEN
         ldb   ,x
         cmpb  #$3B
         bne   L33AB
         leax  $01,x            ELSE

GOTO     ldd   ,x
         addd  <u005E
         tfr   d,x
         rts

ENDIF    leax  $01,x
         rts

UNTIL    jsr   <u0016
         tst   $02,y
         beq   GOTO             = FALSE
         leax  $03,x
         rts

L33DF    fdb   INTStp1P-L33DF
         fdb   INTStpXP-L33DF
         fdb   REALSt1P-L33DF
         fdb   REALStXP-L33DF

NEXT     leay  <L33DF,pcr
L33EA    ldb   ,x+
         lslb
         ldd   b,y
         ldu   <u0031
         jmp   d,y

INTStp1  ldd   ,x
         leay  d,u
         bra   L3410

INTStpX  ldd   ,x
         leay  d,u
         ldd   $04,x
         lda   d,u
         bpl   L3410
         bra   L3430

* FOR .. NEXT / INTEGER
INTStp1P
         ldd   ,x               offset counter
         leay  d,u              address counter
         ldd   ,y
         addd  #$0001           increment counter
         std   ,y
L3410    ldd   $02,x            offset target
         leax  $06,x
         ldd   d,u              target value
         cmpd  ,y
         bge   GOTO             loop again
         leax  $03,x
         rts

* FOR .. NEXT .. STEP / INTEGER
INTStpXP
         ldd   ,x         Y=ptr to current FOR/NEXT INTEGER value
         leay  d,u
         ldd   $04,x
         ldd   d,u
         pshs  a
         addd  ,y               update counter
         std   ,y
         tst   ,s+
         bpl   L3410            incrementing
L3430    ldd   $02,x
         leax  $06,x
         ldd   d,u
         cmpd  ,y
         ble   GOTO             loop again
         leax  $03,x
         rts

REALSt1  ldy   <u0046
         clrb
         bsr   L348E
         bra   L347E

REALStX  ldy   <u0046
         clrb
         bsr   L348E
         ldd   $04,x
         addd  #$0004
         ldu   <u0031
         lda   d,u
         lsra                   sign
         bcc   L347E
         bra   L34CC

* FOR .. NEXT / REAL
REALSt1P
         ldy   <u0046
         clrb
         bsr   L348E
         leay  -$06,y
         ldd   #$0180           step 1 (save in temp var)
         std   $01,y
         clra
         clrb
         std   $03,y
         sta   $05,y
         lbsr  L321E
         bsr   L34DC
         ldd   $01,y
         std   ,u
         ldd   $03,y
         std   2,u
         lda   $05,y
         sta   4,u
L347E    ldb   #$02             incrementing
         bsr   L348E
         leax  $06,x
         lbsr  L3221
         lble  GOTO             loop again
         leax  $03,x
         rts

L348E    ldd   b,x              copy number
         addd  <u0031
         tfr   d,u
         leay  -$06,y
         lda   #$02
         ldb   ,u
         std   ,y
         ldd   1,u
         std   $02,y
         ldd   3,u
         std   $04,y
         rts

* FOR .. NEXT .. STEP / REAL
REALStXP ldy   <u0046
         clrb
         bsr   L348E
         stu   <u00D2
         ldb   #$04
         bsr   L348E
         lda   4,u
         sta   <u00D1
         lbsr  L321E            increment counter
         bsr   L34DC
         ldu   <u00D2
         ldd   $01,y
         std   ,u
         ldd   $03,y
         std   2,u
         lda   $05,y
         sta   4,u
         lsr   <u00D1           check sign
         bcc   L347E
L34CC    ldb   #$02             decrementing
         bsr   L348E
         leax  $06,x
         lbsr  L3221
         lbge  GOTO             loop again
         leax  $03,x
         rts

L34DC    ldb   <u0034
         rts

******** table for FOR ********
L34E5    fdb   INTStp1-L34E5
         fdb   INTStpX-L34E5
         fdb   REALSt1-L34E5
         fdb   REALStX-L34E5

FOR      ldb   ,x+
         cmpb  #$82
         beq   L3515
         bsr   CpMint
         bsr   L3508
         ldb   -1,x
         cmpb  #$47
         bne   L34FF
         bsr   L3508

L34FF    lbsr  GOTO
         leay  <L34E5,pcr
         lbra  L33EA
L3508    ldd   ,x++
         addd  <u0031
         pshs  b,a
         jsr   <u0016
         ldd   $01,y
         std   [,s++]
         rts

L3515    bsr   CpMreal
         bsr   L3523
         ldb   -$01,x
         cmpb  #$47
         bne   L34FF
         bsr   L3523
         bra   L34FF

L3523    ldd   ,x++
         addd  <u0031
         pshs  b,a
         jsr   <u0016
         bra   L3579

LET      jsr   <u0016
L352F    cmpa  #$04
         bcs   L3537
         pshs  u
         ldu   <u003E
L3537    pshs  u,a
         leax  $01,x
         jsr   <u0016
L353D    puls  a
         lsla
         leau  <L3545,pcr
         jmp   a,u

L3545    bra   L355B            byte
         bra   L356A            integer
         bra   L3579            real
         bra   L355B            boolean
         bra   L359C            string
         bra   L35C1            array

CpMbyte  ldd   ,x
         addd  <u0031
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L355B    ldb   $02,y
         stb   [,s++]
         rts

CpMint   ldd   ,x
         addd  <u0031
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L356A    ldd   $01,y
         std   [,s++]
         rts

CpMreal  ldd   ,x
         addd  <u0031
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L3579    puls  u
         ldd   $01,y
         std   ,u
         ldd   $03,y
         std   2,u
         lda   $05,y
         sta   4,u
         rts

CpMstrin ldd   ,x
         addd  <u0066
         tfr   d,u
         ldd   ,u
         addd  <u0031
         pshs  b,a
         ldd   2,u
         pshs  b,a
         leax  $03,x
         jsr   <u0016
L359C    puls  u,b,a                    D = Max size of string to copy
         tstb
         bne   L35A2
         deca
L35A2    sta   <u003E
         ldy   $01,y
         sty   <u0048
L35AA    lda   ,y+
         sta   ,u+
         cmpa  #$FF
         beq   L35B9
         decb
         bne   L35AA
         dec   <u003E
         bpl   L35AA
L35B9    clra
         rts

CpMarray lbsr  L3224
         lbra  L352F

L35C1    puls  u,b,a
         cmpd  $03,y
         bls   L35CA
         ldd   $03,y
L35CA    ldy   $01,y
         exg   y,u
         lbra  L321B

POKE     jsr   <u0016
         ldd   $01,y
         pshs  b,a
         jsr   <u0016
         ldb   $02,y
         stb   [,s++]
         rts

STOP     lbsr  PRINT
         lda   <errpath
         sta   <u007F
         leax  >L32CB,pcr
         lbsr  SPRINT
         lbra  L3206                    exit

UNK1     lbra  L3209

PAUSE    lbsr  PRINT
         rts

GOSUB    ldd   ,x
         leax  $03,x
L35FD    ldy   <u0031
         ldu   <$14,y
         cmpu  <u004A
         bhi   L360D
         ldb   #E$SubOvf
         lbra  L39FB

L360D    stx   ,--u
         stu   <$14,y
         stu   <u0046
         addd  <u005E
         tfr   d,x
         rts

RETURN   ldy   <u0031
         cmpy  <$14,y
         bhi   L3627
         ldb   #$36
         lbra  L39FB

L3627    ldu   <$14,y
         ldx   ,u++
         stu   <$14,y
         stu   <u0046
         rts

ON       ldd   ,x
         cmpa  #$1E
         beq   L366D
         jsr   <u0016
         ldd   ,x
         lslb
         rola
         lslb
         rola
         addd  #$0002
         leau  d,x
         pshs  u
         ldd   $01,y
         ble   L366B
         cmpd  ,x++
         bhi   L366B
         subd  #$0001
         lslb
         rola
         lslb
         rola
         addd  #$0001
         ldd   d,x
         pshs  b,a
         ldb   ,x
         cmpb  #$22
         puls  x,b,a
         beq   L35FD
         addd  <u005E
         tfr   d,x
         rts

L366B    puls  pc,x

L366D    ldu   <u0031
         cmpb  #$20
         bne   L3682
         ldd   $02,x
         addd  <u005E
         std   <$11,u
         lda   #$01
         sta   <$13,u
         leax  $05,x
         rts
L3682    clr   <$13,u
         leax  $02,x
         rts

CREATE   bsr   L36A6
         ldb   #PREAD.+UPDAT.
         os9   I$Create
         bra   L3696

OPEN     bsr   L36A6
         os9   I$Open
L3696    lbcs  L39FB
         puls  u,b
         cmpb  #$01
         bne   L36A2
         clr   ,u+
L36A2    sta   ,u
         puls  pc,x
L36A6    leax  $01,x
         lbsr  GETVAR
         leax  $01,x
         jsr   <u0016
         lda   #$03
         cmpb  #$4A
         bne   L36B7
         lda   ,x++
L36B7    ldu   $03,s
         stx   $03,s
         ldx   $01,y
         jmp   ,u

SEEK     lbsr  SETPATH
         jsr   <u0016
         ldb   #$0E
         lbsr  L3230
         lbcs  L39FD
         rts

INPUTPMT fcc   /? /
         fcb   $ff

* Illegal input error message
L36D1    fcc   "** Input error - reenter **"
         fcb   C$CR,$ff

INPUT    lda   <errpath
         lbsr  SETPATH
         lda   #$2C
         sta   <u00DD
         pshs  x

L0BDA    ldx   ,s
         ldb   ,x
         cmpb  #$90
         bne   L0BEA
         jsr   <u0016
         pshs  x
         ldx   $01,y
         bra   L0BEF
L0BEA    pshs  x
         leax  <INPUTPMT,pcr
L0BEF    bsr   SPRINT
         puls  x
         lda   <u007F
         cmpa  <errpath
         bne   L0BFD
         lda   <u002D
         sta   <u007F
L0BFD    ldb   #$06
L0BFF    lbsr  L3230
         bcc   L0C11
         cmpb  #$03
         lbne  L39FD
         lbsr  L3A23
         clr   <errcode
         bra   L0BDA
L0C11    bsr   L0C24
         bcc   L0C1C
         leax  <L36D1,pcr
         bsr   SPRINT
         bra   L0BDA
L0C1C    ldb   ,x+
         cmpb  #$4B
         beq   L0C11
         puls  pc,b,a
L0C24    bsr   GETVAR
         ldb   ,s
         addb  #$07
         ldy   <u0046
         lbsr  L3230
         lbcc  L353D
         lda   ,s
L0C36    cmpa  #$04
         bcs   L0C3C
         leas  $02,s
L0C3C    leas  $03,s
         coma
         rts

* Entry: X = address of string to print
SPRINT   pshs  y
         leas  -$06,s
         leay  ,s
         stx   $01,y
         ldd   <u0080
         std   <u0082
         ldb   #$05
         lbsr  L3230
         ldb   #$00
         lbsr  L3230
         leas  $06,s
         puls  pc,y

GETVAR   lda   ,x+
         cmpa  #$0E
         bne   L0C64
         jsr   <u0016
         bra   L0C89
L0C64    suba  #$80
         cmpa  #$04
         bcs   L0C7F
         beq   L0C71
         lbsr  L3224
         bra   L0C89
L0C71    ldd   ,x++
         addd  <u0066
         tfr   d,u
         ldd   2,u
         std   <u003E
         ldd   ,u
         bra   L0C81
L0C7F    ldd   ,x++
L0C81    addd  <u0031
         tfr   d,u
         lda   -$03,x
         suba  #$80
L0C89    puls  y
         cmpa  #$04
         bcs   L0C93
         pshs  u
         ldu   <u003E
L0C93    pshs  u,a
         jmp   ,y

* set IO path
* called by #path statement
SETPATH  ldb   ,x
         cmpb  #$54
         bne   L0CA9
         leax  $01,x
         jsr   <u0016
         cmpb  #$4B
         beq   L0CA7
         leax  -$01,x
L0CA7    lda   $02,y
L0CA9    sta   <u007F
         rts

READ     ldb   ,x
         cmpb  #$54
         bne   L0CD6
         bsr   SETPATH
         clr   <u00DD
         cmpb  #$4B
         bne   L0CBC
         leax  -$01,x
L0CBC    ldb   #$06
         lbsr  L3230
         bcc   L0CCF
         cmpb  #$E4
         beq   L0CBC
L0CC7    lbra  L39FD
L0CCA    lbsr  L0C24
         bcs   L0CC7
L0CCF    ldb   ,x+
         cmpb  #$4B
         beq   L0CCA
         rts
L0CD6    bsr   NextInst
         beq   L0D13
L0CDA    bsr   L0CE3
         ldb   ,x+
         cmpb  #$4B
         beq   L0CDA
         rts
L0CE3    lbsr  GETVAR
         bsr   L0D15
         lda   ,s
         bne   L0CED
         inca
L0CED    cmpa  ,y
         lbeq  L353D
         cmpa  #$02
         bcs   L0CFD
         beq   L0D09
L0CF9    ldb   #$47
         bra   L0D1D
L0CFD    lda   ,y
         cmpa  #$02
         bne   L0CF9
         lbsr  L3227
         lbra  L353D
L0D09    cmpa  ,y
         bcs   L0CF9
         lbsr  L322A
         lbra  L353D
L0D13    leax  $01,x
L0D15    pshs  x
         ldx   <DATAPtr
         bne   L0D20
         ldb   #E$NoData
L0D1D    lbra  L39FB
L0D20    jsr   <u0016
         cmpb  #$4B
         beq   L384B
         ldd   ,x
         addd  <u005E
         tfr   d,x
L384B    stx   <DATAPtr
         puls  pc,x

* instruction delimiters
NextInst cmpb  #$3F
         beq   L3855
         cmpb  #$3E
L3855    rts

PRINT    lda   <errpath
         lbsr  SETPATH
         ldd   <u0080
         std   <u0082
         ldb   ,x+
         cmpb  #$49             PRINT USING
         beq   L38A3
L3865    bsr   NextInst
         beq   L388B
L3869    cmpb  #$4B
         beq   L387F
         cmpb  #$51
         beq   L3883
         leax  -$01,x
         jsr   <u0016
         ldb   ,y
         addb  #$01
         bsr   L389B
         ldb   -$01,x
         bra   L3865
L387F    ldb   #$0D
         bsr   L389B
L3883    ldb   ,x+
         bsr   NextInst
         bne   L3869
         bra   L388F
L388B    ldb   #$0C
         bsr   L389B
L388F    ldb   #$00
         bsr   L389B
         lda   <u00DE
         clr   <u00DE
         tsta
         bne   L38A0
L0D7B    rts
L389B    lbsr  L3230
         bcc   L0D7B
L38A0    lbra  L39FD
L38A3    jsr   <u0016
         ldd   <u004A
         std   <u008E
         std   <u008C
         ldu   <u0046
         pshs  u,b,a
         clr   <u0094
         ldd   <u0048
         std   <u004A
L38B5    ldb   -$01,x
         bsr   NextInst
         beq   L38D7
         ldb   ,x+
         bsr   NextInst
         beq   L38D2
         leax  -$01,x
         ldb   #$11
         lbsr  L3230
         bcc   L38B5
         puls  u,b,a
         std   <u004A
         stu   <u0046
         bra   L38A0

L38D2    leay  <L388F,pcr
         bra   L38DA
L38D7    leay  <L388B,pcr
L38DA    puls  u,b,a
         std   <u004A
         stu   <u0046
         jmp   ,y

WRITE    lda   <errpath
         lbsr  SETPATH
         ldu   <u0080
         stu   <u0082
         ldb   ,x+
         lbsr  NextInst
         beq   L3914
         cmpb  #$4B             comma separator?
         beq   L3902
         leax  -$01,x
         bra   L3902

L38FA    clra
         ldb   #$12
         lbsr  L3230
         bcs   L38A0
L3902    jsr   <u0016
         ldb   ,y
         addb  #$01
         lbsr  L3230
         bcs   L38A0
         ldb   -$01,x
         lbsr  NextInst
         bne   L38FA
L3914    lbra  L388B

GET      bsr   L0E0B
         os9   I$Read
         bra   L0E04

PUT      bsr   L0E0B
         os9   I$Write
L0E04    leax  ,u
         bcc   L0E2A
L0E08    lbra  L39FB

L0E0B    lbsr  SETPATH
         lbsr  GETVAR
         leau  ,x
         puls  a
         cmpa  #$04
         bcc   L0E24
         leax  >L3B5B,pcr
         ldb   a,x
         clra
         tfr   d,y
         bra   L0E26
L0E24    puls  y
L0E26    puls  x
         lda   <u007F
L0E2A    rts
CLOSE    lbsr  SETPATH
         os9   I$Close
         bcs   L0E08
         cmpb  #$4B
         beq   CLOSE
         rts

RESTORE  ldb   ,x+
         cmpb  #$3B
         beq   L0E48
         ldu   <pgmaddr
         ldd   <$13,u
L0E43    addd  <u005E
         std   <DATAPtr
         rts
L0E48    ldd   ,x
         addd  #$0001
         leax  $03,x
         bra   L0E43

DELETE   jsr   <u0016
         pshs  x
         ldx   $01,y
         os9   I$Delete
L0E5A    bcs   L0E08
         puls  pc,x

CHD      jsr   <u0016
         lda   #UPDAT.
L0E62    pshs  x
         ldx   $01,y
         os9   I$ChgDir
         bra   L0E5A

CHX      jsr   <u0016
         lda   #EXEC.
         bra   L0E62

         lbsr  GETVAR
         ldy   <u0046
         leay  -$06,y
         ldb   <u007F
         clra
         std   $01,y
         lbra  L353D

CHAIN    jsr   <u0016
         ldy   $01,y
         pshs  u,y,x
         lbsr  L320C
         puls  u,y,x
         bsr   L39E0
         sts   <u00B1
         lds   <u0080
         os9   F$Chain
         lds   <u00B1
         bra   L39FB

SHELL    jsr   <u0016
         pshs  u,x
         ldy   $01,y
         bsr   L39E0
         os9   F$Fork
         bcs   L39FB
         pshs  a
L0EAD    os9   F$Wait
         cmpa  ,s
         bne   L0EAD
         leas  $01,s
         tstb
         bne   L39FB
         puls  pc,u,x

L0EBB    fcc   "SHELL"
L0EC0    fcb   C$CR

* Entry: Y=Ptr to parameter area
L39E0    ldx   <u0048
         lda   #C$CR
         sta   -1,x
         tfr   x,d
         leax  >L0EBB,pcr
         leau  ,y
         pshs  y
         subd  ,s++
         tfr   d,y
         clra
         clrb
         rts

ERROR    jsr   <u0016
         ldb   2,y
UNK8
L39FB    stb   <errcode
L39FD    ldu   <u0031
         beq   L3A1B            not running subroutine
         tst   <$13,u
         beq   L3A14            no error trap
         lds   5,u
         ldx   <$11,u
         ldd   <$14,u
         std   <u0046
         lbra  L3371            process error

L3A14    bsr   L3A23
         bsr   L0F49
         lbra  L3206            exit
L3A1B    lbsr  L320F
         lbra  L3206            exit

L3A21    fcb   14,255           Force text mode in VDGINT

L3A23    leax  <L3A21,pcr
* DIFFERENCE FROM BASIC
         lbsr  SPRINT
         lbsr  L320C
         ldb   <errcode
         os9   F$Exit
         rts

BASE0    clrb
         bra   L3A42

BASE1    ldb   #$01
L3A42    clra
         std   <u0042
         leax  $01,x
         rts

* REM/TRON/TROFF/PAUSE/RTS
* Skip # bytes used up by REM text
UNK4     ldb   ,x+
         clra
         leax  d,x
         rts

UNK3     exg   x,pc
         rts

L3A51    leay  ,x
         lbsr  L3218
         leax  ,y
         rts

ERRS51   ldb   #$33
         bra   L39FB

DEG      lda   #$01
         bra   L0F38

RAD      clra
L0F38    ldu   <u0031
         sta   1,u
         leax  $01,x
         rts

UNK10
L0F3F    lda   <u0034
         bita  #$01
         bne   L0F5F
         ora   #$01
         bra   L0F51
UNK11
L0F49    lda   <u0034
         bita  #$01
         beq   L0F5F
         anda  #$FE
L0F51    sta   <u0034
         ldd   <u0017
         pshs  b,a
         ldd   <u0019
         std   <u0017
         puls  b,a
         std   <u0019
L0F5F    rts

RUN      lbsr  L3224
         pshs  x
         ldb   <u00CF
         cmpb  #$A0
         beq   L0F8C
         ldy   <u0048
         ldx   <u003E
L0F70    lda   ,u+
         leax  -$01,x
         beq   L0F7E
         sta   ,y+
         cmpa  #$FF
         bne   L0F70
         lda   ,--y
L0F7E    ora   #$80
         sta   ,y
         ldy   <u0048
         lbsr  L3212
         bcs   L0FCA
         leau  ,x
L0F8C    ldd   ,u
         bne   L0F9E
         ldy   <u00D2
         leay  $03,y
         lbsr  L3212
         bcs   L0FCA
         ldd   ,x
         std   ,u
L0F9E    ldx   ,s
         std   ,s
         ldu   <u0031
         lda   <u0034
         sta   ,u
         ldb   <u0043
         stb   2,u
         ldd   <u004A
         std   $D,u
         ldd   <u0040
         std   $F,u
         ldd   <DATAPtr
         std   9,u
         bsr   L3B5F
         stx   $B,u
         puls  x
         lda   $06,x
         beq   L0FF9
         cmpa  #$22
         beq   L0FF9
         cmpa  #$21
         beq   L0FCF
L0FCA    ldb   #$2B
L0FCC    lbra  L39FB
L0FCF    ldd   5,u
         pshs  b,a
         sts   5,u
         leas  ,y
         ldd   <u0040
         pshs  y
         subd  ,s++
         lsra
         rorb
         lsra
         rorb
         pshs  b,a
         ldd   $09,x
         leay  >L32DD,pcr
         jsr   d,x
         ldu   <u0031
         lds   5,u
         puls  x
         stx   5,u
         bcc   L3B3C
         bra   L0FCC
L0FF9    lbsr  L0F49
         lda   <u0034
         anda  #$7F
         sta   <u0034
         lbsr  L32DD
         lda   ,u
         bita  #$01
         beq   L3B3C
         lbsr  L0F3F
         lda   ,u
         sta   <u0034
L3B3C    ldd   $D,u
         std   <u004A
         ldd   $F,u
         std   <u0040
         ldd   9,u
         std   <DATAPtr
         ldb   2,u
         sex
         std   <u0042
         ldx   3,u
         lbsr  L3351
         ldx   $B,u
         ldd   <u0044
         subd  <u004A
         std   <FREEMEM
         rts

* Table of size of variables
L3B5B    fcb   1          Byte    (type 0)
         fcb   2          Integer (type 1)
         fcb   5          Real    (type 2)
         fcb   1          Boolean (type 3)

* Vector from $31E8
* Entry: U=
*        X=
UNK7
L3B5F    pshs  u
         ldb   ,x+
         clra
         pshs  x,a
         cmpb  #$4D
         bne   L3BE1
         leay  ,s
L3B6C    pshs  y
         ldb   ,x
         cmpb  #$0E
         beq   L3BA3
         jsr   <u0016
         leax  -$01,x
         cmpa  #$02
         beq   L3B86
         cmpa  #$04
         beq   L3B93
         ldd   $01,y
         std   $04,y
         lda   ,y
L3B86    ldb   #$06
         leau  <L3B5B,pcr
         subb  a,u
         leau  b,y
         stu   <u0046
         bra   L3BA7
L3B93    ldu   $01,y
         ldd   <u0048
         subd  <u004A
         std   <u003E
         ldd   <u0048
         std   <u004A
         lda   #$04
         bra   L3BA7
L3BA3    leax  $01,x
         jsr   <u0016
L3BA7    puls  y
         inc   ,y
         cmpa  #$04
         bcs   L3BB3
         pshs  u
         ldu   <u003E
L3BB3    pshs  u,a
         ldb   ,x+
         cmpb  #$4B
         beq   L3B6C
         leax  $01,x
         stx   $01,y
         leax  <L3B5B,pcr
         ldu   <u0046
         stu   <u0040
L3BC6    puls  b
         cmpb  #$04
         bcs   L3BD0
         puls  b,a
         bra   L3BD3
L3BD0    ldb   b,x
         clra
L3BD3    std   ,--u
         puls  b,a
         std   ,--u
         dec   ,y
         bne   L3BC6
         leay  ,u
         bra   L3BE7
L3BE1    ldy   <u0046
         sty   <u0040
L3BE7    tfr   y,d
         subd  <u004A
         lbcs  L3302
         std   <FREEMEM
         puls  pc,u,x,a

KILL     jsr   <u0016
         ldy   $01,y
         pshs  x
         lbsr  L3215
         puls  pc,x

UNK5     lbsr  L322D
         leax  >L323F,pcr
         stx   <table1
         rts

UNID3
L3C09    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L3C19,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L3C19    fdb   UNK12-L3C19
         fdb   L3D80-L3C19
         fdb   RLADD-L3C19 4 Real # add
         fdb   L15A6-L3C19
         fdb   L4234-L3C19
         fdb   RLCMP-L3C19 A Set flags for Real comparison
         fdb   FIX-L3C19 C FIX (Round & convert REAL to INTEGER)
         fdb   FLOAT-L3C19

L3C29    jsr   <u001B     Substr string search
         fcb   $08

L3C2C    jsr   <u0024     Report error
         fcb   $06

L3C2F    jsr   <u002A
         fcb   $02

* DIFFERENCE FROM BASIC09

         fdb   MID$-L3CB5
         fdb   LEFT$-L3CB5
         fdb   RIGHT$-L3CB5
         fdb   CHR$-L3CB5
         fdb   STR$int-L3CB5
         fdb   STR$rl-L3CB5
         fdb   DATE$-L3CB5
         fdb   TAB-L3CB5
         fdb   FIX-L3CB5
         fdb   fixN1-L3CB5
         fdb   fixN2-L3CB5
         fdb   FLOAT-L3CB5
         fdb   FLOAT2-L3CB5
         fdb   LNOTB-L3CB5
         fdb   NEGint-L3CB5
         fdb   NEGrl-L3CB5
         fdb   LANDB-L3CB5
         fdb   LORB-L3CB5
         fdb   LXORB-L3CB5
         fdb   Igt-L3CB5
         fdb   Rgt-L3CB5
         fdb   Sgt-L3CB5
         fdb   Ilo-L3CB5
         fdb   Rlo-L3CB5
         fdb   Slo-L3CB5
         fdb   Ine-L3CB5
         fdb   Rne-L3CB5
         fdb   Sne-L3CB5
         fdb   Bne-L3CB5
         fdb   Ieq-L3CB5
         fdb   Req-L3CB5
         fdb   Seq-L3CB5
         fdb   Beq-L3CB5
         fdb   Ige-L3CB5
         fdb   Rge-L3CB5
         fdb   Sge-L3CB5
         fdb   Ile-L3CB5
         fdb   Rle-L3CB5
         fdb   Sle-L3CB5
         fdb   INTADD-L3CB5
         fdb   RLADD-L3CB5
         fdb   STRconc-L3CB5
         fdb   INTSUB-L3CB5
         fdb   RLSUB-L3CB5
         fdb   INTMUL-L3CB5
         fdb   RLMUL-L3CB5
         fdb   INTDIV-L3CB5
         fdb   RLDIV-L3CB5
         fdb   POWERS-L3CB5
         fdb   POWERS-L3CB5
         fdb   DIM-L3CB5
         fdb   DIM-L3CB5
         fdb   DIM-L3CB5
         fdb   DIM-L3CB5
         fdb   PARAM-L3CB5
         fdb   PARAM-L3CB5
         fdb   PARAM-L3CB5
         fdb   PARAM-L3CB5
         fdb   $0000,$0000,$0000,$0000,$0000,$0000

L3CB5    fdb   BCPVAR-L3CB5 Copy BYTE var to temp pool
         fdb   ICPVAR-L3CB5
         fdb   L3F8D-L3CB5
         fdb   BlCPVAR-L3CB5
         fdb   SCPVAR-L3CB5
         fdb   L3D59-L3CB5
         fdb   L3D59-L3CB5
         fdb   L3D59-L3CB5
         fdb   L3D59-L3CB5
         fdb   L3D68-L3CB5
         fdb   L3D68-L3CB5
         fdb   L3D68-L3CB5
         fdb   L3D68-L3CB5
         fdb   BCPCNST-L3CB5
         fdb   ICPCNST-L3CB5
         fdb   RCPCNST-L3CB5
         fdb   SCPCNST-L3CB5
         fdb   ICPCNST-L3CB5
         fdb   ADDR-L3CB5
         fdb   ADDR-L3CB5
         fdb   SIZE-L3CB5
         fdb   SIZE-L3CB5
         fdb   POS-L3CB5
         fdb   ERR-L3CB5
         fdb   MODint-L3CB5
         fdb   MODrl-L3CB5
         fdb   RND-L3CB5
         fdb   PI-L3CB5
         fdb   SUBSTR-L3CB5
         fdb   SGNint-L3CB5
         fdb   SGNrl-L3CB5
         fdb   L4A82-L3CB5
         fdb   L4AAF-L3CB5
         fdb   L4ABD-L3CB5
         fdb   L4927-L3CB5
         fdb   L4968-L3CB5
         fdb   L4A03-L3CB5
         fdb   EXP-L3CB5
         fdb   ABSint-L3CB5
         fdb   ABSrl-L3CB5
         fdb   LOG-L3CB5
         fdb   LOG10-L3CB5
         fdb   SQRT-L3CB5
         fdb   SQRT-L3CB5
         fdb   FLOAT-L3CB5
         fdb   INTrl-L3CB5
         fdb   L45F0-L3CB5
         fdb   FIX-L3CB5
         fdb   FLOAT-L3CB5
         fdb   L45F0-L3CB5
         fdb   SQint-L3CB5
         fdb   SQrl-L3CB5
         fdb   PEEK-L3CB5
         fdb   LNOTI-L3CB5
         fdb   VAL-L3CB5
         fdb   LEN-L3CB5
         fdb   ASC-L3CB5
         fdb   LANDI-L3CB5
         fdb   LORI-L3CB5
         fdb   LXORI-L3CB5
         fdb   equTRUE-L3CB5
         fdb   equFALSE-L3CB5
         fdb   EOF-L3CB5
         fdb   TRIM$-L3CB5

L3D35    fdb   BtoI-L3D35
         fdb   INTCPY-L3D35
         fdb   RCPVAR-L3D35
         fdb   L4374-L3D35
         fdb   L44D7-L3D35
         fdb   L44F6-L3D35

L1214    ldy   <u0046           = table4
         ldd   <u004A
         std   <u0048           clear expression stack
         bra   L1224

L121D    lslb
         ldu   <table2
         ldd   b,u
         jsr   d,u
L1224    ldb   ,x+
         bmi   L121D            next part
         clra                   clear carry
         lda   ,y
         rts                    instruction done

* get size of DIM array
L3D59    bsr   L3D80

L3D5B    pshs  pc,u
         ldu   <table3
         lsla
         ldd   a,u
         leau  d,u
         stu   $02,s
         puls  pc,u

* Get size of PARAM array
L3D68    bsr   L124B
         bra   L3D5B

DIM      leas  $02,s
         lda   #$F2
         bra   L3D82

PARAM    leas  $02,s
         lda   #$F6
         bra   L124D

L124B    lda   #$89
L124D    sta   <u00A3
         clr   <u003B
         bra   L1259

L3D80    lda   #$85
L3D82    sta   <u00A3
         sta   <u003B
L1259    ldd   ,x++
         addd  <u0062
         std   <u00D2
         ldu   <u00D2
         lda   ,u
         anda  #$E0
         sta   <u00CF
         eora  #$80
         sta   <u00CE
         lda   ,u
         anda  #$07
         ldb   -$03,x
         subb  <u00A3
         pshs  b,a
         lda   ,u
         anda  #$18
         lbeq  L1312
         ldd   1,u
         addd  <u0066
         tfr   d,u
         ldd   ,u
         std   <u003C
         lda   $01,s
         bne   L1297
         lda   #$05
         sta   ,s
         ldd   2,u
         std   <u003E
         clra
         clrb
         bra   L12EA
L1297    leay  -$06,y
         clra
         clrb
         std   $01,y
         leau  4,u
         bra   L12A8
L12A1    ldd   ,u
         std   $01,y
         lbsr  INTMUL
L12A8    ldd   $07,y
         subd  <u0042
         cmpd  ,u++
         bcs   L12B6
         ldb   #$37
         lbra  L3C2C
L12B6    addd  $01,y
         std   $07,y
         dec   $01,s
         bne   L12A1
         lda   ,s
         beq   L12D2
         cmpa  #$02
         bcs   L12D6
         beq   L12DE
         cmpa  #$04
         bcs   L12D2
         ldd   ,u
         std   <u003E
         bra   L12E1
L12D2    ldd   $07,y
         bra   L12DA
L12D6    ldd   $07,y
         lslb
         rola
L12DA    leay  $0C,y
         bra   L12EA
L12DE    ldd   #$0005
L12E1    std   $01,y
         lbsr  INTMUL
         ldd   $01,y
         leay  $06,y
L12EA    tst   <u00CE
         bne   L1306
         pshs  b,a
         ldd   <u003C
         addd  <u0031
         cmpd  <u0040
         bcc   ERR56
         tfr   d,u
         puls  b,a
         cmpd  2,u
         bhi   ERR56
         addd  ,u
         bra   L1346
L1306    addd  <u003C
         tst   <u003B
         bne   L1344
L130C    addd  $01,y
         leay  $06,y
         bra   L1346
L1312    lda   ,s
         cmpa  #$04
         ldd   1,u
         bcs   L1324
         addd  <u0066
         tfr   d,u
         ldd   2,u
         std   <u003E
         ldd   ,u
L1324    tst   <u003B
         beq   L130C
         addd  <u0031
         tfr   d,u
         tst   <u00CE
         bne   L1348
         cmpd  <u0040
         bcc   ERR56
         ldd   <u003E
         cmpd  2,u
         bcs   L1340
         ldd   2,u
         std   <u003E
L1340    ldu   ,u
         bra   L1348
L1344    addd  <u0031
L1346    tfr   d,u
L1348    clra
         puls  pc,b,a

ERR56    ldb   #$38
         lbra  L3C2C

BCPCNST  leau  ,x+
         bra   BtoI

BCPVAR   ldd   ,x++
         addd  <u0031
         tfr   d,u
BtoI     ldb   ,u
         clra
         leay  -$06,y
         std   $01,y
         lda   #$01
         sta   ,y
         rts

* Copy Integer constant to temp pool
ICPCNST  leau  ,x++
         bra   INTCPY

* Copy integer var into temp var
ICPVAR   ldd   ,x++
         addd  <u0031
         tfr   d,u
INTCPY   ldd   ,u
         leay  -$06,y
         std   $01,y
         lda   #$01
         sta   ,y
         rts

NEGint   clra
         clrb
         subd  $01,y
         std   $01,y
         rts

INTADD   ldd   $07,y
         addd  $01,y
         leay  $06,y
         std   $01,y
         rts

INTSUB   ldd   $07,y
         subd  $01,y
         leay  $06,y
         std   $01,y
         rts

INTMUL   ldd   $07,y
         beq   L13CD
         cmpd  #$0002
         bne   L13OO
         ldd   $01,y
         bra   L13AE

L13OO    ldd   $01,y
         beq   L13B0
         cmpd  #$0002
         bne   L13B4
         ldd   $07,y
L13AE    lslb
         rola
L13B0    std   $07,y
         bra   L13CD
L13B4    lda   $08,y
         mul
         sta   $03,y
         lda   $08,y
         stb   $08,y
         ldb   $01,y
         mul
         addb  $03,y
         lda   $07,y
         stb   $07,y
         ldb   $02,y
         mul
         addb  $07,y
         stb   $07,y
L13CD    leay  $06,y
         rts
L13D0    clr   ,y
         ldd   $07,y
         bpl   L13DE
         nega
         negb
         sbca  #$00
         std   $07,y
         com   ,y
L13DE    ldd   $01,y
         bpl   L13EA
         nega
         negb
         sbca  #$00
         std   $01,y
         com   ,y
L13EA    cmpd  #$0002
         rts

INTDIV   bsr   L13D0
         bne   L1401
         ldd   $07,y
         beq   L140E
         asra
         rorb
         std   $07,y
         ldd   #$0000
         rolb
         bra   L1438

L1401    ldd   $01,y
         bne   L140A
         ldb   #E$DivZer
         lbra  L3C2C
L140A    ldd   $07,y
         bne   L1413
L140E    leay  $06,y
         std   $03,y
         rts

L1413    tsta
         bne   L141E
         exg   a,b
         std   $07,y
         ldb   #$08
         bra   L1420
L141E    ldb   #$10
L1420    stb   $03,y
         clra
         clrb
L1424    lsl   $08,y
         rol   $07,y
         rolb
         rola
         subd  $01,y
         bmi   L1432
         inc   $08,y
         bra   L1434
L1432    addd  $01,y
L1434    dec   $03,y
         bne   L1424
L1438    std   $09,y
         tst   ,y
         bpl   L3F79
         nega
         negb
         sbca  #$00
         std   $09,y
         ldd   $07,y
         nega
         negb
         sbca  #$00
         std   $07,y
L3F79    leay  $06,y
         rts

RCPCNST  leay  -$06,y       Make room for temp var
         ldb   ,x+
         lda   #$02
         std   ,y
         ldd   ,x++
         std   $02,y
         ldd   ,x++
         std   $04,y
         rts

* Copy REAL # from variable pool (pointed to by X) into temp var
L3F8D    ldd   ,x++       Get offset into var space for REAL var
         addd  <u0031
         tfr   d,u
* Copy REAL # constant from within BASIC09 (pointed to by U) into temp var
RCPVAR   leay  -$06,y
         lda   #$02
         ldb   ,u
         std   ,y
         ldd   1,u
         std   $02,y
         ldd   3,u
         std   $04,y
         rts

* invert sign of real number
NEGrl    lda   $05,y
         eora  #$01
         sta   $05,y
         rts

RLSUB
L147E    ldb   $05,y
         eorb  #$01
         stb   $05,y

RLADD    pshs  x
         tst   $02,y
         beq   L149A
         tst   $08,y
         bne   L149E
L148E    ldd   $01,y
         std   $07,y
         ldd   $03,y
         std   $09,y
         lda   $05,y
         sta   $0B,y
L149A    leay  $06,y
         puls  pc,x

* compare exponents
L149E    lda   $07,y
         suba  $01,y
         bvc   L14A8
         bpl   L148E
         bra   L149A
L14A8    bmi   L14B0
         cmpa  #$1F
         ble   L14B8
         bra   L149A
L14B0    cmpa  #$E1
         blt   L148E
         ldb   $01,y
         stb   $07,y
L14B8    ldb   $0B,y
         andb  #$01
         stb   ,y
         eorb  $05,y
         andb  #$01
         stb   $01,y
         ldb   $0B,y
         andb  #$FE
         stb   $0B,y
         ldb   $05,y
         andb  #$FE
         stb   $05,y
         tsta
         beq   L1504
         bpl   L14FC
         nega
         leax  $06,y
         bsr   L1555
         tst   $01,y
         beq   L150C
L14DE    subd  $04,y
         exg   d,x
         sbcb  $03,y
         sbca  $02,y
         bcc   L1520
         coma
         comb
         exg   d,x
         coma
         comb
         addd  #$0001
         exg   d,x
         bcc   L14F8
         addd  #$0001
L14F8    dec   ,y
         bra   L1520
L14FC    leax  ,y
         bsr   L1555
         stx   $02,y
         std   $04,y
L1504    ldx   $08,y
         ldd   $0A,y
         tst   $01,y
         bne   L14DE
L150C    addd  $04,y
         exg   d,x
         adcb  $03,y
         adca  $02,y
         bcc   L1520
         rora
         rorb
         exg   d,x
         rora
         rorb
         inc   $07,y
         exg   d,x
L1520    tsta
         bmi   L1533
L1523    dec   $07,y
         lbvs  L15B0
         exg   d,x
         lslb
         rola
         exg   d,x
         rolb
         rola
         bpl   L1523
L1533    exg   d,x
         addd  #$0001
         exg   d,x
         bcc   L1544
         addd  #$0001
         bcc   L1544
         rora
         inc   $07,y
L1544    std   $08,y
         tfr   x,d
         andb  #$FE
         tst   ,y
         beq   L154F
         incb
L154F    std   $0A,y
         leay  $06,y
         puls  pc,x
L1555    suba  #$10
         bcs   L1573
         suba  #$08
         bcs   L1564
         pshs  a
         clra
         ldb   $02,x
         bra   L156A
L1564    adda  #$08
         pshs  a
         ldd   $02,x
L156A    ldx   #$0000
         tst   ,s
         beq   L159C
         bra   L1590
L1573    adda  #$08
         bcc   L1586
         pshs  a
         clra
         ldb   $02,x
         ldx   $03,x
         tst   ,s
         bne   L1592
         exg   d,x
         bra   L159C
L1586    adda  #$08
         pshs  a
         ldd   $02,x
         ldx   $04,x
         bra   L1592
L1590    exg   d,x
L1592    lsra
         rorb
         exg   d,x
         rora
         rorb
         dec   ,s
         bne   L1590
L159C    leas  $01,s
         rts

RLMUL    bsr   L15A6
         lbcs  L3C2C
         rts
L15A6    pshs  x
         lda   $02,y
         bpl   L15B0
         lda   $08,y
         bmi   L15BC
L15B0    clra
         clrb
         std   $07,y
         std   $09,y
         sta   $0B,y
         leay  $06,y
         puls  pc,x
L15BC    lda   $01,y
         adda  $07,y
         bvc   L15C9
L15C2    bpl   L15B0
         comb
         ldb   #$32
         puls  pc,x
L15C9    sta   $07,y
         ldb   $0B,y
         eorb  $05,y
         andb  #$01
         stb   ,y
         lda   $0B,y
         anda  #$FE
         sta   $0B,y
         ldb   $05,y
         andb  #$FE
         stb   $05,y
         mul
         sta   ,-s
         clr   ,-s
         clr   ,-s
         lda   $0B,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L15F3
         inc   ,s
L15F3    lda   $0A,y
         ldb   $05,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L1600
         inc   ,s
L1600    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         lda   $0B,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L1615
         inc   ,s
L1615    lda   $0A,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L1622
         inc   ,s
L1622    lda   $09,y
         ldb   $05,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L162F
         inc   ,s
L162F    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         lda   $0B,y
         ldb   $02,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L1644
         inc   ,s
L1644    lda   $0A,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L1651
         inc   ,s
L1651    lda   $09,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L165E
         inc   ,s
L165E    lda   $08,y
         ldb   $05,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L166B
         inc   ,s
L166B    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         stb   $0B,y
         lda   $0A,y
         ldb   $02,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L1682
         inc   ,s
L1682    lda   $09,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L168F
         inc   ,s
L168F    lda   $08,y
         ldb   $04,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L169C
         inc   ,s
L169C    ldb   $02,s
         ldx   ,s
         stx   $01,s
         clr   ,s
         stb   $0A,y
         lda   $09,y
         ldb   $02,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L16B3
         inc   ,s
L16B3    lda   $08,y
         ldb   $03,y
         mul
         addd  $01,s
         std   $01,s
         bcc   L16C0
         inc   ,s
L16C0    lda   $08,y
         ldb   $02,y
         mul
         addd  ,s
         bmi   L16D5
         lsl   $0B,y
         rol   $0A,y
         rol   $02,s
         rolb
         rola
         dec   $07,y
         bvs   L16EE
L16D5    std   $08,y
         lda   $02,s
         ldb   $0A,y
         addd  #$0001
         bcc   L16F3
         inc   $09,y
         bne   L16F5
         inc   $08,y
         bne   L16F5
         ror   $08,y
         inc   $07,y
         bvc   L16F5
L16EE    leas  $03,s
         lbra  L15C2
L16F3    andb  #$FE
L16F5    orb   ,y
         std   $0A,y
         leay  $06,y
         leas  $03,s
         clrb
         puls  pc,x

RLDIV    bsr   L4234
         lbcs  L3C2C
L4233    rts
L4234    comb
         ldb   #$2D
         tst   $02,y
         beq   L4233
         pshs  x
         tst   $08,y
         lbeq  L15B0
         lda   $07,y
         suba  $01,y
         lbvs  L15C2
         sta   $07,y
         lda   #$21
         ldb   $05,y
         eorb  $0B,y
         andb  #$01
         std   ,y
         lsr   $02,y
         ror   $03,y
         ror   $04,y
         ror   $05,y
         ldd   $08,y
         ldx   $0A,y
         lsra
         rorb
         exg   d,x
         rora
         rorb
         clr   $0B,y
         bra   L426F
L426D    exg   d,x
L426F    subd  $04,y
         exg   d,x
         bcc   L4278
         subd  #$0001
L4278    subd  $02,y
         beq   L42AB
         bmi   L42A7
L427E    orcc  #Carry
L4280    dec   ,y
         beq   L42F8
         rol   $0B,y
         rol   $0A,y
         rol   $09,y
         rol   $08,y
         exg   d,x
         lslb
         rola
         exg   d,x
         rolb
         rola
         bcc   L426D
         exg   d,x
         addd  $04,y
         exg   d,x
         bcc   L42A1
         addd  #$0001
L42A1    addd  $02,y
         beq   L42AB
         bpl   L427E
L42A7    andcc #^Carry
         bra   L4280
L42AB    leax  ,x
         bne   L427E
         ldb   ,y
         decb
         subb  #$10
         blt   L42CD
         subb  #$08
         blt   L42C2
         stb   ,y
         lda   $0B,y
         ldb   #$80
         bra   L42EB
L42C2    addb  #$08
         stb   ,y
         ldd   #$8000
         ldx   $0A,y
         bra   L42ED
L42CD    addb  #$08
         blt   L42DB
         stb   ,y
         ldx   $09,y
         lda   $0B,y
         ldb   #$80
         bra   L42ED
L42DB    addb  #$07
         stb   ,y
         ldx   $08,y
         ldd   $0A,y
         orcc  #Carry
L42E5    rolb
         rola
         exg   d,x
         rolb
         rola
L42EB    exg   d,x
L42ED    andcc #^Carry
         dec   ,y
         bpl   L42E5
         exg   d,x
         tsta
         bra   L42FC
L42F8    ldx   $0A,y
         ldd   $08,y
L42FC    bmi   L430C
         exg   d,x
         rolb
         rola
         exg   d,x
         rolb
         rola
         dec   $07,y
         lbvs  L15B0
L430C    exg   d,x
         addd  #$0001
         exg   d,x
         bcc   L4321
         addd  #$0001
         bcc   L4321
         rora
         inc   $07,y
         lbvs  L15C2
L4321    std   $08,y
         tfr   x,d
         andb  #$FE
         orb   $01,y
         std   $0A,y
         inc   $07,y
         lbvs  L15C2
L4331    leay  $06,y
         clrb
         puls  pc,x

POWERS   pshs  x
         ldd   $07,y
         beq   L4331
         ldx   $01,y
         bne   L434F
         leay  $06,y
L4342    ldd   #$0180
         std   $01,y
         clr   $03,y
         clr   $04,y
         clr   $05,y
         puls  pc,x

L434F    std   $01,y
         stx   $07,y
         ldd   $09,y
         ldx   $03,y
         std   $03,y
         stx   $09,y
         lda   $0B,y
         ldb   $05,y
         sta   $05,y
         stb   $0B,y
         puls  x
         lbsr  LOG
         lbsr  RLMUL
         lbra  L4864

BlCPVAR  ldd   ,x++
         addd  <u0031
         tfr   d,u
L4374    ldb   ,u
         clra
         leay  -$06,y
         std   $01,y
         lda   #$03
         sta   ,y
         rts

LANDB    ldb   $08,y
         andb  $02,y
         bra   L4390

LORB     ldb   $08,y
         orb   $02,y
         bra   L4390

LXORB    ldb   $08,y
         eorb  $02,y
L4390    leay  $06,y
         std   $01,y
         rts

LNOTB    com   $02,y
         rts

StrCMP   pshs  y,x
         ldx   $01,y
         ldy   $07,y
         sty   <u0048
L43A2    lda   ,y+
         cmpa  ,x+
         bne   L43AC
         cmpa  #$FF
         bne   L43A2
L43AC    inca
         inc   -$01,x
         cmpa  -$01,x
         puls  pc,y,x

Slo      bsr   StrCMP
         bcs   L4405
         bra   L4409

Sle      bsr   StrCMP
         bls   L4405
         bra   L4409

Seq      bsr   StrCMP
         beq   L4405
         bra   L4409

Sne      bsr   StrCMP
         bne   L4405
         bra   L4409

Sge      bsr   StrCMP
         bcc   L4405
         bra   L4409

Sgt      bsr   StrCMP
         bhi   L4405
         bra   L4409

Ilo      ldd   $07,y
         subd  $01,y
         blt   L4405
         bra   L4409

Ile      ldd   $07,y
         subd  $01,y
         ble   L4405
         bra   L4409

Ine      ldd   $07,y
         subd  $01,y
         bne   L4405
         bra   L4409

Ieq      ldd   $07,y
         subd  $01,y
         beq   L4405
         bra   L4409

Ige      ldd   $07,y
         subd  $01,y
         bge   L4405
         bra   L4409

Igt      ldd   $07,y
         subd  $01,y
         ble   L4409
L4405    ldb   #$FF
         bra   L440B
L4409    ldb   #$00
L440B    clra
         leay  $06,y
         std   $01,y
         lda   #$03
         sta   ,y
         rts

Beq      ldb   $08,y
         cmpb  $02,y
         beq   L4405
         bra   L4409

Bne      ldb   $08,y
         cmpb  $02,y
         bne   L4405
         bra   L4409

Rlo      bsr   RLCMP
         blt   L4405
         bra   L4409

Rle      bsr   RLCMP
         ble   L4405
         bra   L4409

Rne      bsr   RLCMP
         bne   L4405
         bra   L4409

Req      bsr   RLCMP
         beq   L4405
         bra   L4409

Rge      bsr   RLCMP
         bge   L4405
         bra   L4409

Rgt      bsr   RLCMP
         bgt   L4405
         bra   L4409

RLCMP    pshs  y
         andcc #Entire+FIRQMask+HalfCrry+IRQMask
         lda   $08,y
         bne   L4461
         lda   $02,y
         beq   L445F
L4455    lda   $05,y
L4457    anda  #$01
         bne   L445F
L445B    andcc #Entire+FIRQMask+HalfCrry+IRQMask
         orcc  #Negative
L445F    puls  pc,y
L4461    lda   $02,y
         bne   L446B
         lda   $0B,y
         eora  #$01
         bra   L4457
L446B    lda   $0B,y
         eora  $05,y
         anda  #$01
         bne   L4455
         leau  $06,y
         lda   $05,y
         anda  #$01
         beq   L447D
         exg   u,y
L447D    ldd   1,u
         cmpd  $01,y
         bne   L445F
         ldd   3,u
         cmpd  $03,y
         bne   L4491
         lda   5,u
         cmpa  $05,y
         beq   L445F
L4491    bcs   L445B
         andcc #Entire+FIRQMask+HalfCrry+IRQMask
         puls  pc,y

SCPCNST  clrb
         stb   <u003E
L449A    ldu   <u0048
         leay  -$06,y
         stu   $01,y
         sty   <u0044
L44A3    cmpu  <u0044
         bcc   L44C2
         lda   ,x+
         sta   ,u+
         cmpa  #$FF
         beq   L44BB
         decb
         bne   L44A3
         dec   <u003E
         bpl   L44A3
         lda   #$FF
         sta   ,u+
L44BB    stu   <u0048
         lda   #$04
         sta   ,y
         rts
L44C2    ldb   #E$StrOvf
         lbra  L3C2C

SCPVAR   ldd   ,x++
         addd  <u0066
         tfr   d,u
L44CD    ldd   ,u
         addd  <u0031
         ldu   2,u
         stu   <u003E
         tfr   d,u
L44D7    pshs  x
         ldb   <u003F
         bne   L44DF
         dec   <u003E
L44DF    leax  ,u
         bsr   L449A
         puls  pc,x

STRconc  ldu   $01,y
         leay  $06,y
L44E9    lda   ,u+
         sta   -2,u
         cmpa  #$FF
         bne   L44E9
         leau  -1,u
         stu   <u0048
         rts

L44F6    ldd   <u003E
         leay  -$06,y
         std   $03,y
         stu   $01,y
         lda   #$05
         sta   ,y
         rts

FLOAT    clra
         clrb
         std   $04,y
         ldd   $01,y
         bne   L4512
         stb   $03,y
         lda   #$02
         sta   ,y
         rts
L4512    ldu   #$0210
         tsta
         bpl   L451E
         nega
         negb
         sbca  #$00
         inc   $05,y
L451E    tsta
         bne   L4526
         ldu   #$0208
         exg   a,b
L4526    tsta
         bmi   L452F
L4529    leau  -1,u
         lslb
         rola
         bpl   L4529
L452F    std   $02,y
         stu   ,y
         rts

FLOAT2   leay  $06,y
         bsr   FLOAT
         leay  -$06,y
         rts

FIX      ldb   $01,y
         bgt   L454E
         bmi   L454A
         lda   $02,y
         bpl   L454A
         ldd   #$0001
         bra   L4591

L454A    clra
         clrb
         bra   L4599

L454E    subb  #$10
         bhi   L458C
         bne   L4566
         ldd   $02,y
         ror   $05,y
         bcc   L4599
         cmpd  #$8000
         bne   L458C
         tst   $04,y
         bpl   L4599
         bra   L458C
L4566    cmpb  #$F8
         bhi   L4578
         pshs  b
         ldd   $02,y
         std   $03,y
         clr   $02,y
         puls  b
         addb  #$08
         beq   L4581
L4578    lsr   $02,y
         ror   $03,y
         ror   $04,y
         incb
         bne   L4578
L4581    ldd   $02,y
         tst   $04,y
         bpl   L4591
         addd  #$0001
         bvc   L4591
L458C    ldb   #E$ValRng
         lbra  L3C2C

L4591    ror   $05,y
         bcc   L4599
         nega
         negb
         sbca  #$00
L4599    std   $01,y
         lda   #$01
         sta   ,y
         rts

fixN1    leay  $06,y
         bsr   FIX
         leay  -$06,y
         rts

fixN2    leay  $0C,y
         bsr   FIX
         leay  -$0C,y
         rts

ABSrl    lda   $05,y
         anda  #$FE
         sta   $05,y
         rts

ABSint   ldd   $01,y
         bpl   L45BF
         nega
         negb
         sbca  #$00
         std   $01,y
L45BF    rts

PEEK     clra
         ldb   [<$01,y]
         std   $01,y
         rts

SGNrl    lda   $02,y
         beq   L45DB
         lda   $05,y
         anda  #$01
         bne   L45DE
L45D1    ldb   #$01
         bra   L45E0

SGNint   ldd   $01,y
         bmi   L45DE
         bne   L45D1
L45DB    clrb
         bra   L45E0

L45DE    ldb   #$FF
L45E0    sex
         bra   L45EA

ERR      ldb   <errcode
         clr   <errcode
L45E7    clra
         leay  -$06,y
L45EA    std   $01,y
         lda   #$01
         sta   ,y
L45F0    rts

POS      ldb   <u007D
         bra   L45E7

SQRT
L45F5    ldb   $05,y
         asrb
         lbcs  ERR67
         ldb   #$1F
         stb   <u006E
         ldd   $01,y
         beq   L45F0
         inca
         asra
         sta   $01,y
         ldd   $02,y
         bcs   L4616
         lsra
         rorb
         std   -$04,y
         ldd   $04,y
         rora
         rorb
         bra   L461A
L4616    std   -$04,y
         ldd   $04,y
L461A    std   -$02,y
         clra
         clrb
         std   $02,y
         std   $04,y
         std   -$06,y
         std   -$08,y
         bra   L4638
L4628    orcc  #Carry
         rol   $05,y
         rol   $04,y
         rol   $03,y
         rol   $02,y
         dec   <u006E
         beq   L467A
         bsr   L468F
L4638    ldb   -$04,y
         subb  #$40
         stb   -$04,y
         ldd   -$06,y
         sbcb  $05,y
         sbca  $04,y
         std   -$06,y
         ldd   -$08,y
         sbcb  $03,y
         sbca  $02,y
         std   -$08,y
         bpl   L4628
L4650    andcc #^Carry
         rol   $05,y
         rol   $04,y
         rol   $03,y
         rol   $02,y
         dec   <u006E
         beq   L467A
         bsr   L468F
         ldb   -$04,y
         addb  #$C0
         stb   -$04,y
         ldd   -$06,y
         adcb  $05,y
         adca  $04,y
         std   -$06,y
         ldd   -$08,y
         adcb  $03,y
         adca  $02,y
         std   -$08,y
         bmi   L4650
         bra   L4628
L467A    ldd   $02,y
         bra   L4684
L467E    dec   $01,y
         lbvs  L15B0
L4684    lsl   $05,y
         rol   $04,y
         rolb
         rola
         bpl   L467E
         std   $02,y
         rts

L468F    bsr   L4691
L4691    lsl   -$01,y
         rol   -$02,y
         rol   -$03,y
         rol   -$04,y
         rol   -$05,y
         rol   -$06,y
         rol   -$07,y
         rol   -$08,y
         rts

MODint   lbsr  INTDIV
         ldd   $03,y
         std   $01,y
         rts

MODrl
L46AA    leau  -$0C,y
         pshs  y
L46AE    ldd   ,y++
         std   ,u++
         cmpu  ,s
         bne   L46AE
         leas  $02,s
         leay  -$C,u
         lbsr  RLDIV
         bsr   L46C6
         lbsr  RLMUL
         lbra  L147E

INTrl
L46C6    lda   $01,y
         bgt   L46D3
         clra
         clrb
         std   $01,y
         std   $03,y
         stb   $05,y
L46D2    rts
L46D3    cmpa  #$1F
         bcc   L46D2
         leau  $06,y
         ldb   -1,u
         andb  #$01
         pshs  u,b
         leau  $01,y
L46E1    leau  1,u
         suba  #$08
         bcc   L46E1
         beq   L46F5
         ldb   #$FF
L46EB    lslb
         inca
         bne   L46EB
         andb  ,u
         stb   ,u+
         bra   L46F9
L46F5    leau  1,u
L46F7    sta   ,u+
L46F9    cmpu  $01,s
         bne   L46F7
         puls  u,b
         orb   $05,y
         stb   $05,y
         rts

SQint    leay  -$06,y
         ldd   $07,y
         std   $01,y
         lbra  INTMUL

SQrl     leay  -$06,y
         ldd   $0A,y
         std   $04,y
         ldd   $08,y
         std   $02,y
         ldd   $06,y
         std   ,y
         lbra  RLMUL

VAL      ldd   <u0080
         ldu   <u0082
         pshs  u,b,a
         ldd   $01,y
         std   <u0080
         std   <u0082
         std   <u0048
         leay  $06,y
         ldb   #$09
         lbsr  L3C2F
         puls  u,b,a
         std   <u0080
         stu   <u0082
         lbcs  ERR67
         rts

ADDR     lbsr  L1224
         leay  -$06,y
         stu   $01,y
L4746    lda   #$01
         sta   ,y
         leax  $01,x
         rts

* Table of var type sizes
L474D    fcb   $01        Byte             (type=0)
         fcb   $02        Integer size     (type=1)
         fcb   $05        Real size        (type=2)
         fcb   $01        Boolean          (type=3)

SIZE     lbsr  L1224
         leay  -$06,y
         cmpa  #$04
         bcc   L4763
         leau  >L474D,pcr
         ldb   a,u
         clra
         bra   L4765
L4763    ldd   <u003E
L4765    std   $01,y
         bra   L4746

equTRUE  ldd   #$00FF
         bra   L4771

equFALSE ldd   #$0000
L4771    leay  -$06,y
         std   $01,y
         lda   #$03
         sta   ,y
         rts

LNOTI    com   $01,y
         com   $02,y
         rts

LANDI    ldd   $01,y
         anda  $07,y
         andb  $08,y
         bra   L4795

LXORI    ldd   $01,y
         eora  $07,y
         eorb  $08,y
         bra   L4795

LORI     ldd   $01,y
         ora   $07,y
         orb   $08,y
L4795    std   $07,y
         leay  $06,y
         rts

L479A    fcb   255,222,91,216,170 ??? (.434294482)

LOG10    bsr   LOG
         leau  >L479A,pcr
         lbsr  RCPVAR
         lbra  RLMUL

LOG      pshs  x
         ldb   $05,y
         asrb
         lbcs  ERR67
         ldd   $01,y
         lbeq  ERR67
         pshs  a
         ldb   #$01
         stb   $01,y
         leay  <-$1A,y
         leax  <$1B,y
         leau  ,y
         lbsr  L4BCC
         lbsr  L4CC7
         clra
         clrb
         std   <$14,y
         std   <$16,y
         sta   <$18,y
         leax  >L4C7F,pcr
         stx   <$19,y
         lbsr  L4909
         leax  <$14,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$1A,y
         ldb   #$02
         stb   ,y
         ldb   $05,y
         orb   #$01
         stb   $05,y
         puls  b
         bsr   L480A
         puls  x
         lbra  RLADD

L4805    fcb   $00,$b1,$72,$17,$f8 (.693147181) LOG(2) in REAL format

L480A    sex              Convert to 16 bit number
         bpl   L480E      If positive, skip ahead
         negb
L480E    anda  #$01
         pshs  b,a
         leau  >L4805,pcr
         lbsr  RCPVAR
         ldb   $05,y
         lda   $01,s
         cmpa  #$01
         beq   L485C
         mul
         stb   $05,y
         ldb   $04,y
         sta   $04,y
         lda   $01,s
         mul
         addb  $04,y
         adca  #$00
         stb   $04,y
         ldb   $03,y
         sta   $03,y
         lda   $01,s
         mul
         addb  $03,y
         adca  #$00
         stb   $03,y
         ldb   $02,y
         sta   $02,y
         lda   $01,s
         mul
         addb  $02,y
         adca  #$00
         beq   L4858
L484B    inc   $01,y
         lsra
         rorb
         ror   $03,y
         ror   $04,y
         ror   $05,y
         tsta
         bne   L484B
L4858    stb   $02,y
         ldb   $05,y
L485C    andb  #$FE
         orb   ,s
         stb   $05,y
         puls  pc,b,a

EXP
L4864    pshs  x
         ldb   $01,y
         beq   L4880
         cmpb  #$07
         ble   L4877
         ldb   $05,y
         rorb
         rorb
         eorb  #$80
         lbra  L491C
L4877    cmpb  #$E4
         lble  L4342
         tstb
         bpl   L488A
L4880    clr   ,-s
         ldb   $05,y
         andb  #$01
         beq   L48CD
         bra   L48BB
L488A    lda   #$71
         mul
         adda  $01,y
         ldb   $05,y
         andb  #$01
         pshs  b,a
         eorb  $05,y
         stb   $05,y
         ldb   ,s
L489B    lbsr  L480A
         lbsr  L147E
         ldb   $01,y
         ble   L48AD
         addb  ,s
         stb   ,s
         ldb   $01,y
         bra   L489B
L48AD    puls  b,a
         pshs  a
         tstb
         beq   L48CD
         nega
         sta   ,s
         orb   $05,y
         stb   $05,y
L48BB    leau  >L4805,pcr
         lbsr  RCPVAR
         lbsr  RLADD
         dec   ,s
         ldb   $05,y
         andb  #$01
         bne   L48BB
L48CD    leay  <-$1A,y
         leax  <$1B,y
         leau  <$14,y
         lbsr  L4BCC
         lbsr  L4CC7
         ldd   #$1000
         std   ,y
         clra
         std   $02,y
         sta   $04,y
         leax  >L4C61,pcr
         stx   <$19,y
         bsr   L4909
         leax  ,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$1A,y
         puls  b
         addb  $01,y
         bvs   L491C
         lda   #$02
         std   ,y
         puls  pc,x
L4909    lda   #$01
         sta   <u009A
         leax  >L4D6F,pcr
         stx   <u0095
         leax  >$005F,x
         stx   <u0097
         lbra  L4B97
L491C    leay  -$06,y
         lbpl  L15B0
         ldb   #E$FltOvf
         lbra  L3C2C

L4927    pshs  x
         bsr   L495D
         ldd   $01,y
         lbeq  L4A91
         cmpd  #$0180
         bgt   L4943
         bne   L4946
         ldd   $03,y
         bne   L4943
         lda   $05,y
         lbeq  L4A0E
L4943    lbra  ERR67

L4946    lbsr  L49CB
         leay  <-$14,y
         leax  <$15,y
         leau  ,y
         lbsr  L4BCC
         lbsr  L4CC7
         leax  <$1B,y
         lbra  L4A3E
L495D    ldb   $05,y
         andb  #$01
         stb   <u006D
         eorb  $05,y
         stb   $05,y
         rts

L4968    leau  <L49AB,pcr
         pshs  u,x
         bsr   L495D
         ldd   $01,y
         lbeq  L4A0E
         cmpd  #$0180
         bgt   L4943
         bne   L4995
         ldd   $03,y
         bne   L4943
         lda   $05,y
         bne   L4943
         lda   <u006D
         bne   L498E
         clrb
         std   $01,y
         puls  pc,u,x
L498E    leay  $06,y
         puls  u,x
         lbra  PI
L4995    bsr   L49CB
         leay  <-$14,y
         leax  <$1B,y
         leau  ,y
         lbsr  L4BCC
         lbsr  L4CC7
         leax  <$15,y
         lbra  L4A3E
L49AB    lda   $05,y
         bita  #$01
         beq   L49C5
         ldu   <u0031
         tst   1,u
         beq   L49BF
         leau  <L49C6,pcr
         lbsr  RCPVAR
         bra   L49C2
L49BF    lbsr  PI
L49C2    lbra  RLADD
L49C5    rts

L49C6    fcb   $08,$b4,$00,$00,$00 180

L49CB    lda   <u006D
         pshs  a
         leay  <-$12,y
         ldd   #$0201
         std   $0C,y
         lda   #$80
         clrb
         std   $0E,y
         clra
         std   <$10,y
         ldd   <$12,y
         std   ,y
         std   $06,y
         ldd   <$14,y
         std   $02,y
         std   $08,y
         ldd   <$16,y
         std   $04,y
         std   $0A,y
         lbsr  RLMUL
         lbsr  L147E
         lbsr  L45F5
         puls  a
         sta   <u006D
         rts

L4A03    pshs  x
         lbsr  L495D
         ldb   $01,y
         cmpb  #$18
         blt   L4A17
L4A0E    leay  $06,y
         lbsr  PI
         dec   $01,y
         bra   L4A6A
L4A17    leay  <-$1A,y
         ldd   #$1000
         std   ,y
         clra
         std   $02,y
         sta   $04,y
         ldb   <$1B,y
         bra   L4A34
L4A29    asr   ,y
         ror   $01,y
         ror   $02,y
         ror   $03,y
         ror   $04,y
         decb
L4A34    cmpb  #$02
         bgt   L4A29
         stb   <$1B,y
         leax  <$1B,y
L4A3E    leau  $0A,y
         lbsr  L4BCC
         lbsr  L4CC7
         clra
         clrb
         std   <$14,y
         std   <$16,y
         sta   <$18,y
         leax  >L4C2C,pcr
         stx   <$19,y
         lbsr  L4B89
         leax  <$14,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$1A,y
L4A6A    lda   $05,y
         ora   <u006D
         sta   $05,y
         ldu   <u0031
         tst   1,u
         beq   L4A91
         leau  >L4AFE,pcr
         lbsr  RCPVAR
         lbsr  RLMUL
         bra   L4A91

L4A82    pshs  x
         lbsr  PIX
         leax  $0A,y
         bsr   L4A97
         lda   $05,y
L4A8D    eora  <u009C
L4A8F    sta   $05,y
L4A91    lda   #$02
         sta   ,y
         puls  pc,x

L4A97    leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leay  <$14,y
         leax  >L4D6A,pcr
         leau  $01,y
         lbsr  L4BCC
         lbra  RLMUL

L4AAF    pshs  x
         bsr   PIX
         leax  ,y
         bsr   L4A97
         lda   $05,y
         eora  <u009B
         bra   L4A8F

L4ABD    pshs  x
         bsr   PIX
         leax  $0A,y
         leau  <$1B,y
         lbsr  L4BCC
         lbsr  L4CE1
         leax  ,y
         leay  <$14,y
         leau  $01,y
         lbsr  L4BCC
         lbsr  L4CE1
         ldd   $01,y
         bne   L4AEB
         leay  $06,y
         ldd   #$7FFF
L4AE2    std   $01,y
         lda   #$FF
         std   $03,y
         deca
         bra   L4AF0
L4AEB    lbsr  RLDIV
         lda   $05,y
L4AF0    eora  <u009B
         bra   L4A8D

L4AF4    fcb   $02,$c9,$0f,$da,$a2 PI (3.14159265)

L4AF9    fcb   $fb,$8e,$fa,$35,$12 -1.74532925 E-02  (Degrees)

L4AFE    fcb   $06,$e5,$2e,$e0,$d4 57.2957795 (radians)

PI       leau  >L4AF4,pcr
         lbra  RCPVAR

PIX      ldu   <u0031
         tst   1,u
         beq   L4B1A
         leau  >L4AF9,pcr
         lbsr  RCPVAR      Copy 5 bytes from u to 1,y (0,y=2)
         lbsr  RLMUL
L4B1A    clr   <u009B
         ldb   $05,y
         andb  #$01
         stb   <u009C
         eorb  $05,y
         stb   $05,y
         bsr   PI
         inc   $01,y
         lbsr  RLCMP
         blt   L4B36
         lbsr  L46AA
         bsr   PI
         bra   L4B38
L4B36    dec   $01,y
L4B38    lbsr  RLCMP
         blt   L4B4A
         inc   <u009B
         lda   <u009C
         eora  #$01
         sta   <u009C
         lbsr  L147E
         bsr   PI
L4B4A    dec   $01,y
         lbsr  RLCMP
         ble   L4B64
         lda   <u009B
         eora  #$01
         sta   <u009B
         inc   $01,y
         lda   $0B,y
         ora   #$01
         sta   $0B,y
         lbsr  RLADD
         leay  -$06,y
L4B64    leay  <-$14,y
         leax  >L4C33,pcr
         stx   <$19,y
         leax  <$1B,y
         leau  <$14,y
         bsr   L4BCC
         lbsr  L4CC7
         ldd   #$1000
         std   ,y
         clra
         std   $02,y
         sta   $04,y
         std   $0A,y
         std   $0C,y
         sta   $0E,y
L4B89    leax  >L4D29,pcr
         stx   <u0095
         leax  >$0041,x
         stx   <u0097
         clr   <u009A
L4B97    ldb   #$25
         stb   <u0099
         clr   <u009D
L4B9D    leau  <$1B,y
         ldx   <u0095
         cmpx  <u0097
         bcc   L4BAE
         bsr   L4BCC
         leax  $05,x
         stx   <u0095
         bra   L4BB2
L4BAE    ldb   #$01
         bsr   L4C1E
L4BB2    leax  ,y
         leau  $05,y
         bsr   L4BDE
         tst   <u009A
         bne   L4BC2
         leax  $0A,y
         leau  $0F,y
         bsr   L4BDE
L4BC2    jsr   [<$19,y]
         inc   <u009D
         dec   <u0099
         bne   L4B9D
         rts

L4BCC    pshs  y,x
         lda   ,x
         ldy   $01,x
         ldx   $03,x
         sta   ,u
         sty   1,u
         stx   3,u
         puls  pc,y,x
L4BDE    ldb   ,x
         sex
         ldb   <u009D
         lsrb
         lsrb
         lsrb
         bcc   L4BE9
         incb
L4BE9    pshs  b
         beq   L4BF2
L4BED    sta   ,u+
         decb
         bne   L4BED
L4BF2    ldb   #$05
         subb  ,s+
         beq   L4BFF
L4BF8    lda   ,x+
         sta   ,u+
         decb
         bne   L4BF8
L4BFF    leau  -5,u
         ldb   <u009D
         andb  #$07
         beq   L4C2B
         cmpb  #$04
         bcs   L4C1E
         subb  #$08
         lda   ,x
L4C0F    lsla
         rol   4,u
         rol   3,u
         rol   2,u
         rol   1,u
         rol   ,u
         incb
         bne   L4C0F
         rts
L4C1E    asr   ,u
         ror   1,u
         ror   2,u
         ror   3,u
         ror   4,u
         decb
         bne   L4C1E
L4C2B    rts
L4C2C    lda   $0A,y
         eora  ,y
         coma
         bra   L4C36
L4C33    lda   <$14,y
L4C36    tsta
         bpl   L4C4D
         leax  ,y
         leau  $0F,y
         bsr   L4C8F
         leax  $0A,y
         leau  $05,y
         bsr   L4CAB
         leax  <$14,y
         leau  <$1B,y
         bra   L4C8F
L4C4D    leax  ,y
         leau  $0F,y
         bsr   L4CAB
         leax  $0A,y
         leau  $05,y
         bsr   L4C8F
         leax  <$14,y
         leau  <$1B,y
         bra   L4CAB
L4C61    leax  <$14,y
         leau  <$1B,y
         bsr   L4CAB
         bmi   L4C8F
         bne   L4C79
         ldd   $01,x
         bne   L4C79
         ldd   $03,x
         bne   L4C79
         ldb   #$01
         stb   <u0099
L4C79    leax  ,y
         leau  $05,y
         bra   L4C8F
L4C7F    leax  ,y
         leau  $05,y
         bsr   L4C8F
         cmpa  #$20
         bcc   L4CAB
         leax  <$14,y
         leau  <$1B,y
L4C8F    ldd   $03,x
         addd  3,u
         std   $03,x
         ldd   $01,x
         bcc   L4CA0
         addd  #$0001
         bcc   L4CA0
         inc   ,x
L4CA0    addd  1,u
         std   $01,x
         lda   ,x
         adca  ,u
         sta   ,x
         rts
L4CAB    ldd   $03,x
         subd  3,u
         std   $03,x
         ldd   $01,x
         bcc   L4CBC
         subd  #$0001
         bcc   L4CBC
         dec   ,x
L4CBC    subd  1,u
         std   $01,x
         lda   ,x
         sbca  ,u
         sta   ,x
         rts
L4CC7    ldb   ,u
         clr   ,u
         addb  #$04
         bge   L4CDE
         negb
         lbra  L4C1E
L4CD3    lsl   4,u
         rol   3,u
         rol   2,u
         rol   1,u
         rol   ,u
         decb
L4CDE    bne   L4CD3
         rts
L4CE1    lda   ,u
         bpl   L4CEE
         clra
         clrb
         std   ,u
         std   2,u
         sta   4,u
         rts
L4CEE    ldd   #$2004
L4CF1    decb
         lsl   4,u
         rol   3,u
         rol   2,u
         rol   1,u
         rol   ,u
         bmi   L4D05
         deca
         bne   L4CF1
         clrb
         std   ,u
         rts
L4D05    lda   ,u
         stb   ,u
         ldb   1,u
         sta   1,u
         lda   2,u
         stb   2,u
         ldb   3,u
         addd  #$0001
         andb  #$FE
         std   3,u
         bcc   L4D28
         inc   2,u
         bne   L4D28
         inc   1,u
         bne   L4D28
         ror   1,u
         inc   ,u
L4D28    rts

* Data (all 5 byte entries for real #'s???)
L4D29    fcb   $0c,$90,$fd,$aa,$22 2319.85404
         fcb   $07,$6b,$19,$c1,$58 53.5503032
         fcb   $03,$eb,$6e,$bf,$26 7.35726888
         fcb   $01,$fd,$5b,$a9,$ab -1.97935983
         fcb   $00,$ff,$aa,$dd,$b9
         fcb   $00,$7f,$f5,$56,$ef
         fcb   $00,$3f,$fe,$aa,$b7
         fcb   $00,$1f,$ff,$d5,$56
         fcb   $00,$0f,$ff,$fa,$ab
         fcb   $00,$07,$ff,$ff,$55
         fcb   $00,$03,$ff,$ff,$eb
         fcb   $00,$01,$ff,$ff,$fd
         fcb   $00,$01,$00,$00,$00

L4D6A    fcb   $00,$9b,$74,$ed,$a8 .607252935
L4D6F    fcb   $0b,$17,$21,$7f,$7e 0185.04681
         fcb   $06,$7c,$c8,$fb,$30
         fcb   $03,$91,$fe,$f8,$f3
         fcb   $01,$e2,$70,$76,$e3
         fcb   $00,$f8,$51,$86,$01
         fcb   $00,$7e,$0a,$6c,$3a
         fcb   $00,$3f,$81,$51,$62
         fcb   $00,$1f,$e0,$2a,$6b
         fcb   $00,$0f,$f8,$05,$51
         fcb   $00,$07,$fe,$00,$aa
         fcb   $00,$03,$ff,$80,$15
         fcb   $00,$01,$ff,$e0,$03
         fcb   $00,$00,$ff,$f8,$00
         fcb   $00,$00,$7f,$fe,$00
         fcb   $00,$00,$3f,$ff,$80
         fcb   $00,$00,$1f,$ff,$e0
         fcb   $00,$00,$0f,$ff,$f8
         fcb   $00,$00,$07,$ff,$fe
         fcb   $00,$00,$04,$00,$00

L4DCE    fdb   $0E12,$14A2,$BB40,$E62D,$3619,$62E9


RND      clra
         clrb
         std   <u004C
         std   <u004E
         pshs  a
         lda   $02,y
         beq   L4DFC
         ldb   $05,y
         bitb  #$01
         bne   L4DF0
         com   ,s
         bra   L4DFC

L4DF0    addb  #$FE
         addb  $01,y
         lda   $04,y
         std   <u0052
         ldd   $02,y
         std   <u0050
L4DFC    lda   <u0053
         ldb   <u0057
         mul
         std   <u004E
         lda   <u0052
         ldb   <u0057
         mul
         addd  <u004D
         bcc   L4E0E
         inc   <u004C
L4E0E    std   <u004D
         lda   <u0053
         ldb   <u0056
         mul
         addd  <u004D
         bcc   L4E1B
         inc   <u004C
L4E1B    std   <u004D
         lda   <u0051
         ldb   <u0057
         mul
         addd  <u004C
         std   <u004C
         lda   <u0052
         ldb   <u0056
         mul
         addd  <u004C
         std   <u004C
         lda   <u0053
         ldb   <u0055
         mul
         addd  <u004C
         std   <u004C
         lda   <u0050
         ldb   <u0057
         mul
         addb  <u004C
         stb   <u004C
         lda   <u0051
         ldb   <u0056
         mul
         addb  <u004C
         stb   <u004C
         lda   <u0052
         ldb   <u0055
         mul
         addb  <u004C
         stb   <u004C
         lda   <u0053
         ldb   <u0054
         mul
         addb  <u004C
         stb   <u004C
         ldd   <u004E
         addd  <u005A
         std   <u0052
         ldd   <u004C
         adcb  <u0059
         adca  <u0058
         std   <u0050
         tst   ,s+
         bne   L4E98
         ldd   <u0050
         std   $02,y
         ldd   <u0052
         std   $04,y
         clr   $01,y
L4E78    lda   #$1F
         pshs  a
         ldd   $02,y
         bmi   L4E8E
L4E80    dec   ,s
         beq   L4E8E
         dec   $01,y
         lsl   $05,y
         rol   $04,y
         rolb
         rola
         bpl   L4E80
L4E8E    std   $02,y
         ldb   $05,y
         andb  #$FE
         stb   $05,y
         puls  pc,b

L4E98    ldd   <u0052
         andb  #$FE
         std   ,--y
         ldd   <u0050
         std   ,--y
         clra
         clrb
         std   ,--y
         bsr   L4E78
         lbra  RLMUL

LEN      ldd   <u0048
         ldu   $01,y
         subd  $01,y
         subd  #$0001
         stu   <u0048
L4EB6    std   $01,y
         lda   #$01
         sta   ,y
         rts

ASC      ldd   $01,y
         std   <u0048
         ldb   [<$01,y]
         clra
         bra   L4EB6

CHR$     ldd   $01,y
         tsta
         lbne  ERR67
         ldu   <u0048
         stu   $01,y
         stb   ,u+
         lbsr  L4FEA
         sty   <u0044
         cmpu  <u0044
         lbcc  L44C2
         rts

LEFT$    ldd   $01,y
         ble   IsNull
         addd  $07,y
         tfr   d,u
         cmpd  <u0048
         bcc   L4EF1
         bsr   L4F70
L4EF1    leay  $06,y
         rts

IsNull   leay  $06,y
         ldu   $01,y
         bra   L4F70

RIGHT$   ldd   $01,y
         ble   IsNull
         pshs  x
         ldd   <u0048
         subd  $01,y
         subd  #$0001
         cmpd  $07,y
         bls   L4F1A
         tfr   d,x
         ldu   $07,y
L4F10    lda   ,x+
         sta   ,u+
         cmpa  #$FF
         bne   L4F10
         stu   <u0048
L4F1A    leay  $06,y
         puls  pc,x

MID$     ldd   $01,y                    size of piece
         ble   L4F26
         ldd   $07,y                    starting offset
         bgt   L4F2E
L4F26    ldd   $01,y                    = LEFT$
         leay  $06,y
         std   $01,y
         bra   LEFT$

L4F2E    subd  #$0001
         beq   L4F26
         addd  $0D,y                    start address piece
         cmpd  <u0048
         bcs   L4F3E                    piece exists
         leay  $06,y
         bra   IsNull
L4F3E    pshs  x
         tfr   d,x
         ldb   $02,y
         ldu   $0D,y
L4F46    lda   ,x+
         sta   ,u+
         cmpa  #$FF
         beq   L4F59
         decb
         bne   L4F46
         dec   $01,y
         bpl   L4F46
         lda   #$FF
         sta   ,u+
L4F59    stu   <u0048
         leay  $0C,y
         puls  pc,x

TRIM$    ldu   <u0048
         leau  -1,u
L4F63    cmpu  $01,y
         beq   L4F70
         lda   ,-u
         cmpa  #$20
         beq   L4F63
         leau  1,u
L4F70    lda   #$FF
         sta   ,u+
         stu   <u0048
         rts

SUBSTR   pshs  y,x
         ldd   <u0048
         subd  $01,y
         addd  $07,y
         addd  #$0001
         ldx   $07,y
         ldy   $01,y
         lbsr  L3C29
         bcc   L4F90
         clra
         clrb
         bra   L4F99
L4F90    tfr   y,d
         ldx   $02,s
         subd  $01,x
         addd  #$0001
L4F99    puls  y,x
         std   $07,y
         lda   #$01
         sta   $06,y
         leay  $06,y
         rts

STR$int  ldb   #$02
         bra   L4FAA

STR$rl   ldb   #$03
L4FAA    lda   <u007D
         ldu   <u0082
         pshs  u,x,a
         lbsr  L3C2F
         bcs   ERR67
         ldx   <u0082
         lda   #$FF
         sta   ,x
         ldx   $03,s
         lbsr  SCPCNST
         puls  u,x,a
         sta   <u007D
         stu   <u0082
         rts
ERR67    ldb   #$43
         lbra  L3C2C

TAB      pshs  x
         ldd   $01,y
         blt   ERR67
         sty   <u0044
         ldu   <u0048
         stu   $01,y
         lda   #$20
L4FDB    cmpb  <u007D
         bls   L4FEC
         sta   ,u+
         decb
         cmpu  <u0044
         bcs   L4FDB
         lbra  L44C2
L4FEA    pshs  x
L4FEC    lda   #$FF
         sta   ,u+
         stu   <u0048
         lda   #$04
         sta   ,y
         puls  pc,x

DATE$    pshs  x
         leay  -$06,y
         leax  -$06,y
         ldu   <u0048
         stu   $01,y
         os9   F$Time
         bcs   L4FEC
 ifeq Y2K-true
* Correction for Y2000 changes. RG
         lda   ,x+
         ldb   #'0-1
         cmpa  #100
         blo   Y19
cnty     suba  #100
         bhs   cnty
         adda  #100
Y19      bsr   PRTN10
 else
         bsr   PRTNUM
 endc
         lda   #'/
         bsr   L501F
         lda   #'/
         bsr   L501F
         lda   #$20
         bsr   L501F
         lda   #':
         bsr   L501F
         lda   #':
         bsr   L501F
         bra   L4FEC
L501F    sta   ,u+

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*
PRTNUM   lda   ,x+
         ldb   #'0-1
PRTN10   incb  Form Hundreds digit
         suba  #10
         bcc   PRTN10
         stb   ,u+
         ldb   #'9+1
L502E    decb
         inca
         bne   L502E
         stb   ,u+
         rts

EOF      lda   $02,y
         ldb   #SS.EOF
         os9   I$GetStt
         bcc   L5046
         cmpb  #E$EOF
         bne   L5046
         ldb   #$FF
         bra   L5048
L5046    ldb   #$00
L5048    clra
         std   $01,y
         lda   #$03
         sta   ,y
         rts

UNK12    ldb   #$06       6 2-byte entries to copy
         pshs  y,x,b
         tfr   dp,a
         ldb   #$50
         tfr   d,y
         leax  >L4DCE,pcr
L505E    ldd   ,x++
         std   ,y++
         dec   ,s
         bne   L505E
         leax  >L3CB5,pcr
         stx   <table2
         leax  >L3D35,pcr
         stx   <table3
         lda   #$7E
         sta   <u0016
         leax  >L1214,pcr
         stx   <u0017
         puls  pc,y,x,b

L5084    pshs  x,b,a
         ldb   [<$04,s]
         leax  <L5094,pcr
         ldd   b,x
         leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L5094    fdb   AtoITR-L5094
         fdb   L50A4-L5094

L5098    jsr   <u0027
         fcb   $0C
Flote    jsr   <u0027
         fcb   $0E
L509E    jsr   <u0027
         fcb   $08
L50A1    jsr   <u0027
         fcb   $06

L50A4    pshs  pc,x,d     Make room for new PC, preserve X & Y
         lslb
         leax  <L50B2,pcr
L50AA    ldd   b,x
L50AC    leax  d,x
         stx   $04,s
         puls  pc,x,b,a

L50B2    fdb   WRITLN-L50B2 0
         fdb   PRintg-L50B2
         fdb   PRintg-L50B2
         fdb   PRreal-L50B2
         fdb   PRbool-L50B2
         fdb   PRstring-L50B2
         fdb   READLN-L50B2
         fdb   L530A-L50B2
         fdb   L531D-L50B2
         fdb   L52E7-L50B2
         fdb   L5354-L50B2
         fdb   L5331-L50B2
         fdb   Strterm-L50B2
         fdb   L569B-L50B2
         fdb   SETFP-L50B2
         fdb   ERR48-L50B2
         fdb   L568C-L50B2
         fdb   PRNTUSIN-L50B2 $06ba  11
         fdb   L5614-L50B2
         fdb   L580B-L50B2
L50DA    fdb   L56B4-L50B2 $0602  14

* Table for Integer conversion
L50DC    fdb   10000
         fdb   1000
         fdb   100
         fdb   10

* Table for REAL conversion
L50E4    fcb   $04,$a0,$00,$00,$00 10
         fcb   $07,$c8,$00,$00,$00 100
         fcb   $0a,$fa,$00,$00,$00 1000
         fcb   $0e,$9c,$40,$00,$00 10 thousand
         fcb   $11,$c3,$50,$00,$00 100 thousand
         fcb   $14,$f4,$24,$00,$00 1 million
         fcb   $18,$98,$96,$80,$00 10 million
         fcb   $1b,$be,$bc,$20,$00 100 million
         fcb   $1e,$ee,$6b,$28,$00 1 billion
         fcb   $22,$95,$02,$f9,$00 10 billion
         fcb   $25,$ba,$43,$b7,$40 100 billion
         fcb   $28,$e8,$d4,$a5,$10 1 trillion
         fcb   $2c,$91,$84,$e7,$2a 10 trillion
         fcb   $2f,$b5,$e6,$20,$f4 100 trillion
         fcb   $32,$e3,$5f,$a9,$32 1 quadrillion
         fcb   $36,$8e,$1b,$c9,$c0 10 quadrillion
         fcb   $39,$b1,$a2,$bc,$2e 100 quadrillion
         fcb   $3c,$de,$0b,$6b,$3a 1 quintillion
L513E    fcb   $40,$8a,$c7,$23,$04 10 quintillion

TRUESTR  fcc   "True"
         fcb   $ff
FALSESTR fcc   "False"
         fcb   $ff

AtoITR   pshs  u
         leay  -6,y
         clra
         clrb
         sta   <u0075
         sta   <u0076
         sta   <u0077
         sta   <u0078
         sta   <u0079
         std   $04,y
         std   $02,y
         sta   $01,y
         lbsr  L5390
         bcc   L5172
         leax  -$01,x
         cmpa  #$2C
         bne   err59
         lbra  L51FB

L5172    cmpa  #$24
         lbeq  L52B2
         cmpa  #$2B
         beq   L5182
         cmpa  #$2D
         bne   L5184
         inc   <u0078
L5182    lda   ,x+
L5184    cmpa  #$2E
         bne   L5190
         tst   <u0077
         bne   err59
         inc   <u0077
         bra   L5182
L5190    lbsr  L57DE
         bcs   L51E5
         pshs  a
         inc   <u0076
         ldd   $04,y
         ldu   $02,y
         bsr   L51CB
         std   $04,y
         stu   $02,y
         bsr   L51CB
         bsr   L51CB
         addd  $04,y
         exg   d,u
         adcb  $03,y
         adca  $02,y
         bcs   L51D8
         exg   d,u
         addb  ,s+
         adca  #$00
         bcc   L51BF
         leau  1,u
         stu   $02,y
         beq   L51DA
L51BF    std   $04,y
         stu   $02,y
         tst   <u0077
         beq   L5182
         inc   <u0079
         bra   L5182
L51CB    lslb
         rola
         exg   d,u
         rolb
         rola
         exg   d,u
         bcs   L51D6
         rts
L51D6    leas  $02,s
L51D8    leas  $01,s
L51DA    ldb   #$3C
         bra   L51E0
err59    ldb   #E$IONum
L51E0    stb   <errcode
         coma
         puls  pc,u
L51E5    eora  #$45
         anda  #$DF
         beq   L520E
         leax  -$01,x
         tst   <u0076
         bne   L51F3
         bra   err59
L51F3    tst   <u0077
         bne   L523C
         ldd   $02,y
         bne   L523C
L51FB    ldd   $04,y
         bmi   L523C
         tst   <u0078
         beq   L5207
         nega
         negb
         sbca  #$00
L5207    std   $01,y
L5209    lda   #$01
         lbra  L5295
L520E    lda   ,x
         cmpa  #$2B
         beq   L521A
         cmpa  #$2D
         bne   L521C
         inc   <u0075
L521A    leax  $01,x
L521C    lbsr  L57DC
         bcs   err59
         tfr   a,b
         lbsr  L57DC
         bcc   L522C
         leax  -$01,x
         bra   L5233
L522C    pshs  a
         lda   #$0A
         mul
         addb  ,s+
L5233    tst   <u0075
         bne   L5238
         negb
L5238    addb  <u0079
         stb   <u0079
L523C    ldb   #$20
         stb   $01,y
         ldd   $02,y
         bne   L524D
         cmpd  $04,y
         bne   L524D
         clr   $01,y
         bra   L5293
L524D    tsta
         bmi   L525A
L5250    dec   $01,y
         lsl   $05,y
         rol   $04,y
         rolb
         rola
         bpl   L5250
L525A    std   $02,y
         clr   <u0075
         ldb   <u0079
         beq   L528B
         bpl   L5267
         negb
         inc   <u0075
L5267    cmpb  #$13
         bls   L527B
         subb  #$13
         pshs  b
         leau  >L513E,pcr
         bsr   L529B
         puls  b
         lbcs  L51DA
L527B    decb
         lda   #$05
         mul
         leau  >L50E4,pcr
         leau  b,u
         bsr   L529B
         lbcs  L51DA
L528B    lda   $05,y
         anda  #$FE
         ora   <u0078
         sta   $05,y
L5293    lda   #$02
L5295    sta   ,y
         andcc #^Carry
         puls  pc,u
L529B    leay  -$06,y
         ldd   ,u
         std   $01,y
         ldd   2,u
         std   $03,y
         ldb   4,u
         stb   $05,y
         lda   <u0075
         lbeq  L509E
         lbra  L50A1
L52B2    lbsr  L57DC
         bcc   L52C7
         cmpa  #$61
         bcs   L52BD
         suba  #$20
L52BD    cmpa  #$41
         bcs   L52DC
         cmpa  #$46
         bhi   L52DC
         suba  #$37
L52C7    inc   <u0076
         ldb   #$04
L52CB    lsl   $02,y
         rol   $01,y
         lbcs  L51DA
         decb
         bne   L52CB
         adda  $02,y
         sta   $02,y
         bra   L52B2
L52DC    leax  -$01,x
         tst   <u0076
         lbeq  err59
         lbra  L5209

L52E7    pshs  x
         ldx   <u0082
         lbsr  AtoITR
         bcc   L52F2
L52F0    puls  pc,x
L52F2    cmpa  #$02
         beq   L52F9
         lbsr  Flote
L52F9    lbsr  L5384
         bcs   L5305
         ldb   #E$Illinp
         stb   <errcode
         coma
         puls  pc,x
L5305    stx   <u0082
         clra
         puls  pc,x

L530A    pshs  x
         ldx   <u0082
         lbsr  AtoITR
         bcs   L52F0
         cmpa  #$01
         bne   ERR58
         tst   $01,y
         beq   L52F9
         bra   ERR58

L531D    pshs  x
         ldx   <u0082
         lbsr  AtoITR
         bcs   L52F0
         cmpa  #$01
         beq   L52F9
ERR58    ldb   #E$IOMism
         stb   <errcode
         coma
         puls  pc,x

* verify string
L5331    pshs  u,x
         leay  -$06,y
         ldu   <u004A
         stu   $01,y
         lda   #$04
         sta   ,y
         ldx   <u0082
L533F    lda   ,x+
         bsr   L5396
         bcs   L5349
         sta   ,u+
         bra   L533F

L5349    stx   <u0082
         lda   #$FF
         sta   ,u+
         stu   <u0048
         clra
         puls  pc,u,x

* Boolean -> internal repr.
L5354    pshs  x
         leay  -$06,y
         lda   #$03
         sta   ,y
         clr   $02,y
         ldx   <u0082
         bsr   L5390
         bcs   L537F
         cmpa  #$54
         beq   L5379
         cmpa  #$74
         beq   L5379
         eora  #$46
         anda  #$DF
         beq   L537B
         ldb   #E$IOMism
         stb   <errcode
         coma
         puls  pc,x

L5379    com   $02,y
L537B    bsr   L5384
         bcc   L537B
L537F    stx   <u0082
         clra
         puls  pc,x

* validate characters
L5384    lda   ,x+
         cmpa  #C$SPAC                  space?
         bne   L5396
         bsr   L5390
         bcc   L53A5
         bra   L53A7
L5390    lda   ,x+
         cmpa  #C$SPAC                  space?
         beq   L5390                    skip them
L5396    cmpa  <u00DD
         beq   L53A7
         cmpa  #C$CR                    CR?
         beq   L53A5
         cmpa  #$FF                     end of string?
         beq   L53A5
         andcc #^Carry
         rts
L53A5    leax  -$01,x
L53A7    orcc  #Carry
         rts

* integer to ASCII
L53AA    pshs  u,x
         clra
         sta   $03,y
         sta   <u0076
         sta   <u0078
         lda   #$04
         sta   <u007E
         ldd   $01,y
         bpl   L53C1
         nega
         negb
         sbca  #$00
         inc   <u0078
L53C1    leau  >L50DA,pcr
L53C5    clr   <u007A
         leau  2,u
L53C9    subd  ,u
         bcs   L53D1
         inc   <u007A
         bra   L53C9
L53D1    addd  ,u
         tst   <u007A
         bne   L53DB
         tst   $03,y
         beq   L53E6
L53DB    inc   $03,y
         pshs  a
         lda   <u007A
         lbsr  L54EA
         puls  a
L53E6    dec   <u007E
         bne   L53C5
         tfr   b,a
         lbsr  L54EA
         leay  $06,y
         puls  pc,u,x

RtoA     pshs  u,x
         clr   <u0075
         clr   <u0078
         clr   <u007C
         clr   <u007B
         clr   <u0079
         clr   <u0076
         leau  ,x
         ldd   #$0A30
L5406    stb   ,u+
         deca
         bne   L5406
         ldd   $01,y
         bne   L5413
         inca
         lbra  L54E4
L5413    ldb   $05,y
         bitb  #$01
         beq   L541F
         stb   <u0078
         andb  #$FE
         stb   $05,y
L541F    ldd   $01,y
         bpl   L5426
         inc   <u0075
         nega
L5426    cmpa  #$03
         bls   L5457
         ldb   #$9A
         mul
         lsra
         nop
         nop
         tfr   a,b
         tst   <u0075
         beq   L5437
         negb
L5437    stb   <u0079
         cmpa  #$13
         bls   L544A
         pshs  a
         leau  >L513E,pcr
         lbsr  L529B
         puls  a
         suba  #$13
L544A    leau  >L50E4,pcr
         deca
         ldb   #$05
         mul
         leau  d,u
         lbsr  L529B
L5457    ldd   $02,y
         tst   $01,y
         beq   L5483
         bpl   L546F
L545F    lsra
         rorb
         ror   $04,y
         ror   $05,y
         ror   <u007C
         inc   $01,y
         bne   L545F
         std   $02,y
         bra   L5483
L546F    lsl   $05,y
         rol   $04,y
         rolb
         rola
         rol   <u007B
         dec   $01,y
         bne   L546F
         std   $02,y
         inc   <u0079
         lda   <u007B
         bsr   L54EA
L5483    ldd   $02,y
         ldu   $04,y
L5487    clr   <u007B
         bsr   L54F1
         std   $02,y
         stu   $04,y
         pshs  a
         lda   <u007B
         sta   <u007C
         puls  a
         bsr   L54F1
         bsr   L54F1
         exg   d,u
         addd  $04,y
         exg   d,u
         adcb  $03,y
         adca  $02,y
         pshs  a
         lda   <u007B
         adca  <u007C
         bsr   L54EA
         lda   <u0076
         cmpa  #$09
         puls  a
         beq   L54C1
         cmpd  #$0000
         bne   L5487
         cmpu  #$0000
         bne   L5487
L54C1    sta   ,y
         lda   <u0076
         cmpa  #$09
         bcs   L54E2
         ldb   ,y
         bpl   L54E2
L54CD    lda   ,-x
         inca
         sta   ,x
         cmpa  #$39
         bls   L54E2
         lda   #$30
         sta   ,x
         cmpx  ,s
         bne   L54CD
         inc   ,x
         inc   <u0079
L54E2    lda   #$09
L54E4    sta   <u0076
         leay  $06,y
         puls  pc,u,x
L54EA    ora   #$30
         sta   ,x+
         inc   <u0076
         rts
L54F1    exg   d,u
         lslb
         rola
         exg   d,u
         rolb
         rola
         rol   <u007B
         rts

READLN   pshs  y,x
         ldx   <u0080
         stx   <u0082
         lda   #$01
         sta   <u007D
         ldy   #$0100
         lda   <u007F
         os9   I$ReadLn
         bra   L5524

WRITLN   pshs  y,x
         ldd   <u0082
         subd  <u0080
         beq   L5528
         tfr   d,y
         ldx   <u0080
         stx   <u0082
         lda   <u007F
         os9   I$WritLn
L5524    bcc   L5528
         stb   <errcode
L5528    puls  pc,y,x

SETFP    pshs  u,x
         lda   ,y               type of file pointer
         cmpa  #$02
         beq   L5536            real
         ldu   $01,y            else integer
         bra   L553D

L5536    lda   $01,y            if exponent is <=0, Seek to 0
         bgt   L5542            positive value, go calculate logint for SEEK
         ldu   #$0000
L553D    ldx   #$0000
         bra   L555E

L5542    ldx   $02,y
         ldu   $04,y
         suba  #$20
         bcs   L554F
         ldb   #$4E
         coma
         bra   L5565

L554F    exg   x,d
         lsra
         rorb
         exg   d,u
         rora
         rorb
         exg   d,x
         exg   x,u
         inca
         bne   L554F
L555E    lda   <u007F
         os9   I$Seek
         bcc   L5567
L5565    stb   <errcode
L5567    puls  pc,u,x

* print real numbers
PRreal    pshs  u,x
         leas  -$0A,s
         leax  ,s
         lbsr  RtoA
         pshs  x
         lda   #$09
         leax  $09,x
L5578    ldb   ,-x
         cmpb  #$30
         bne   L5583
         deca
         cmpa  #$01
         bne   L5578
L5583    sta   <u0076
         puls  x
         ldb   <u0079
         bgt   L55AC
         negb
         tfr   b,a
         cmpb  #$09
         bhi   L55C6
         addb  <u0076
         cmpb  #$09
         bhi   L55C6
         pshs  a
         lbsr  L5643
         clra
         bsr   L5612
         puls  b
         tstb
         beq   L55A8
         lbsr  L5634
L55A8    lda   <u0076
         bra   L55BF
L55AC    cmpb  #$09
         bhi   L55C6
         lbsr  L5643
         tfr   b,a
         bsr   L5601
         bsr   L5612
         lda   <u0076
         suba  <u0079
         bls   L55C1
L55BF    bsr   L5601
L55C1    leas  $0A,s
         clra
         puls  pc,u,x
L55C6    bsr   L5643
         lda   #$01
         bsr   L5601
         bsr   L5612
         lda   <u0076
         deca
         bne   L55D4
         inca
L55D4    bsr   L5601
         bsr   L55DA
         bra   L55C1
L55DA    lda   #$45
         bsr   L5614
         lda   <u0079
         deca
         pshs  a
         bpl   L55EB
         neg   ,s
         bsr   L5647
         bra   L55ED
L55EB    bsr   L564B
L55ED    puls  b
         clra
L55F0    subb  #$0A
         bcs   L55F7
         inca
         bra   L55F0
L55F7    addb  #$0A
         bsr   L55FD
         tfr   b,a
L55FD    adda  #$30
         bra   L5614
L5601    tfr   a,b
         tstb
         beq   L560D
L5606    lda   ,x+
         bsr   L5614
         decb
         bne   L5606
L560D    rts

L560E    lda   #$20
         bra   L5614
L5612    lda   #$2E
L5614    pshs  u,a
         leau  <-$40,s
         cmpu  <u0082
         bhi   L562A
         cmpa  #$0D
         beq   L562A
         lda   #$50
         sta   <errcode
         sta   <u00DE
         bra   L5632

L562A    ldu   <u0082
         sta   ,u+
         stu   <u0082
         inc   <u007D
L5632    puls  pc,u,a

L5634    lda   #$30
L5636    tstb                   0 chars?
         beq   L563E            yes, return
L5639    bsr   L5614
         decb
         bne   L5639
L563E    rts

L563F    tst   <u0078
         beq   L560E
L5643    tst   <u0078
         beq   L563E
L5647    lda   #$2D
         bra   L5614

L564B    lda   #$2B
         bra   L5614

Spacing  lda   #C$SPAC
         bra   L5636

L5653    bsr   L5614
L5655    lda   ,x+
         cmpa  #$FF
         bne   L5653
         rts

* print string
PRstring pshs  x
         ldx   $01,y
L5660    bsr   L5655
         clra
         puls  pc,x

* print boolean
PRbool    pshs  x
         leax  >TRUESTR,pcr
         lda   $02,y
         bne   L5660
         leax  >FALSESTR,pcr
         bra   L5660

* print integers
PRintg   pshs  u,x
         leas  -$05,s
         leax  ,s
         lbsr  L53AA
         bsr   L5643
         lda   <u0076
         leax  ,s
         lbsr  L5601
         leas  $05,s
         clra
         puls  pc,u,x

* <u002A Function 2, sub-function $10 - Add B spaces to temp buffer
* Entry: A=# spaces to append to temp buffer
L568C    tfr   a,b        Move byte we are working with to B
L568E    pshs  u          Preserve U
         ldu   <u0082
         subb  <u007D
         bls   L5698
         bsr   Spacing
L5698    clra
         puls  pc,u

L569B    lbsr  L560E
L569E    lda   <u007D
         anda  #$0F
         cmpa  #$01
         beq   L56B2
         lbsr  L560E
         bra   L569E

* terminate string
Strterm  lda   #C$CR
         clr   <u007D
         lbsr  L5614
L56B2    clra
         rts

L56B4    pshs  u
         lda   #$04
         leau  ,y
         tst   ,u
         bne   L56C1
         asra
         leau  1,u
L56C1    sta   <u0086
         tfr   a,b
         asrb
         lbsr  L585D
         puls  pc,u
L56CB    clrb
         stb   <u0087
         cmpa  #$3C
         beq   L56DE
         cmpa  #$3E
         bne   L56D9
         incb
         bra   L56DE
L56D9    cmpa  #$5E
         bne   L56E2
         decb
L56DE    stb   <u0087
         lda   ,x+
L56E2    cmpa  #$2C
         beq   L571E
         cmpa  #$FF
         bne   L56FC
         lda   <u0094
         beq   L56F2
         leax  -$01,x
         bra   L5707
L56F2    ldx   <u008E
         tst   <u00DC
         beq   L5700
         clr   <u00DC
         bra   L571E
L56FC    cmpa  #$29
         beq   L5703
L5700    orcc  #Carry
         rts

L5703    lda   <u0094
         beq   L5700
L5707    dec   <u0092
         bne   L571C
         ldu   <u0046
         pulu  y,a
         sta   <u0092
         sty   <u0090
         stu   <u0046
         lda   ,x+
         dec   <u0094
         bra   L56E2
L571C    ldx   <u0090
L571E    stx   <u008C
         andcc #^Carry
         rts

* Print USING format specifiers
L5723    fcb   'I                       Integer
         fdb   ARGUS1-L5723
L5726    fcb   'H                       Hexadecimal
         fdb   ARGUS1-L5726
L5729    fcb   'R                       Real
         fdb   ARGUS2-L5729
L572C    fcb   'E                       Exponential
         fdb   ARGUS2-L572C
L572F    fcb   'S                       String
         fdb   ARGUS1-L572F
L5732    fcb   'B                       Boolean
         fdb   ARGUS1-L5732
L5735    fcb   'T                       Tab
         fdb   ARGUS3-L5735
L5738    fcb   'X                       Space
         fdb   ARGUS4-L5738
L573B    fcb   ''                       Literal string
         fdb   ARGUS5-L573B
         fcb   $00

* Tab function
ARGUS3   bsr   L56E2
         bcs   L57A7
         ldb   <u0086
         lbsr  L568E
         bra   L5772

* print spaces (X)
ARGUS4   bsr   L56E2
         bcs   L57A7
         ldb   <u0086
         lbsr  Spacing
         bra   L5772

* print literal string
ARGUS5
L5755    cmpa  #$FF                     end of string?
         beq   L57A7
         cmpa  #$27
         bne   L5765
         lda   ,x+
         bsr   L56E2
         bcs   L57A7
         bra   L5772

L5765    lbsr  L5614
         lda   ,x+
         bra   L5755

PRNTUSIN pshs  y,x
         clr   <u00DC
         inc   <u00DC
L5772    ldx   <u008C
         bsr   L57C2
         bcs   L5791
         cmpa  #$28
         bne   L57AB
         lda   <u0092
         stb   <u0092
         beq   L57AB
         inc   <u0094
         ldu   <u0046
         ldy   <u0090
         pshu  y,a
         stu   <u0046
         stx   <u0090
         lda   ,x+
L5791    leay  >L5723,pcr
         clrb
L5796    pshs  a
         eora  ,y
         anda  #$DF
         puls  a
         beq   L57B2
         leay  $03,y
         incb
         tst   ,y
         bne   L5796
L57A7    ldb   #$3F
         bra   L57AD
L57AB    ldb   #E$IOFRpt
L57AD    stb   <errcode
         coma
         puls  pc,y,x

L57B2    stb   <u0085
         ldd   $01,y
         leay  d,y
         bsr   L57C2
         bcc   L57BE
         ldb   #$01
L57BE    stb   <u0086
         jmp   ,y

L57C2    bsr   L57DC
         bcs   L57EB
         tfr   a,b
         bsr   L57DC
         bcs   L57E8
         bsr   L57EE
         bsr   L57DC
         bcs   L57E8
         bsr   L57EE
         tsta
         beq   L57D8
         clrb
L57D8    lda   ,x+
         bra   L57E8

L57DC    lda   ,x+
L57DE    cmpa  #'0
         bcs   L57EB
         cmpa  #'9
         bhi   L57EB
         suba  #'0
L57E8    andcc #^Carry
         rts
L57EB    orcc  #Carry
         rts

L57EE    pshs  a
         lda   #10
         mul
         addb  ,s+
         adca  #$00
         rts

ARGUS2   cmpa  #$2E
         bne   L57A7
         bsr   L57C2
         bcs   L57A7
         stb   <u0089

ARGUS1   lbsr  L56CB                    Int, Hex, String, Boolean
         bcs   L57A7
         puls  y,x
         inc   <u00DC
L580B    ldb   <u0085
         lbeq  FMTint
         decb
         beq   L5826
         decb
         lbeq  L5969
         decb
         lbeq  FMTexp
         decb
         lbeq  FMTstr
         lbra  FMTbool

L5826    jsr   <u0016
         cmpa  #$04
         bcs   L583C
         ldu   $01,y
         clrb
L582F    lda   ,u+
         cmpa  #$FF
         beq   L5838
         incb
         bne   L582F
L5838    ldu   $01,y
         bra   L585D
L583C    leau  $01,y
         lda   ,y
         cmpa  #$02
         bne   L5848
         ldb   #$05
         bra   L585D
L5848    cmpa  #$01
         bne   L5852
         ldb   #$02
         cmpb  <u0086
         bcs   L5856
L5852    ldb   #$01
         leau  1,u
L5856    tfr   b,a
         lsla
         cmpa  <u0086
         bhi   L5893
L585D    tst   <u0087
         beq   L5889
         bmi   L5870
         pshs  b
         lslb
         pshs  b
         ldb   <u0086
         subb  ,s+
         bcs   L5887
         bra   L587C
L5870    pshs  b
         lslb
         pshs  b
         ldb   <u0086
         subb  ,s+
         bcs   L5887
         asrb
L587C    pshs  b
         lda   <u0086
         suba  ,s+
         sta   <u0086
         lbsr  Spacing
L5887    puls  b
L5889    lda   ,u
         lsra
         lsra
         lsra
         lsra
         bsr   L58A3
         beq   L58A1
L5893    lda   ,u+
         bsr   L58A3
         beq   L58A1
         decb
         bne   L5889
         ldb   <u0086
         lbsr  Spacing
L58A1    clra
         rts

L58A3    anda  #$0F
         cmpa  #$09
         bls   L58AB
         adda  #$07
L58AB    lbsr  L55FD
         dec   <u0086
         rts

L58B1    coma
         rts

FMTint   jsr   <u0016
         cmpa  #$02
         bcs   L58BE
         bne   L58B1                    wrong var type
         lbsr  L5098
L58BE    pshs  u,x
         leas  -$05,s
         leax  ,s
         lbsr  L53AA
         ldb   <u0086
         decb
         subb  <u0076
         bpl   L58D5
         leas  $05,s
         puls  u,x
         lbra  Overflow

L58D5    tst   <u0087
         beq   L58E3                    left justify
         bmi   L58F4                    leading zeros
         lbsr  Spacing                  right justify
         lbsr  L563F
         bra   L58FA

L58E3    lbsr  L563F
         pshs  b
         lda   <u0076
         lbsr  L5601
         puls  b
         lbsr  Spacing
         bra   L58FF

L58F4    lbsr  L563F
         lbsr  L5634
L58FA    lda   <u0076
         lbsr  L5601
L58FF    leas  $05,s
         clra
         puls  pc,u,x

FMTbool  jsr   <u0016
         cmpa  #$03
         bne   L58B1                    wrong type
         pshs  u,x
         leax  >TRUESTR,pcr
         ldb   #$04
         lda   $02,y
         bne   L5932
         leax  >FALSESTR,pcr
         ldb   #$05
         bra   L5932

FMTstr   jsr   <u0016
         cmpa  #$04
         bne   L58B1                    wrong type
         pshs  u,x
         ldx   $01,y
         ldd   <u0048
         subd  $01,y
         subd  #$0001
         tsta
         bne   L5936
L5932    cmpb  <u0086
         bls   L5938
L5936    ldb   <u0086
L5938    tfr   b,a
         negb
         addb  <u0086
         tst   <u0087
         beq   L594F                    left justify
         bmi   L5953                    center text
         pshs  a                        right justify
         lbsr  Spacing
         puls  a
         lbsr  L5601
         bra   L5966
L594F    pshs  b
         bra   L595E
L5953    lsrb
         bcc   L5957
         incb
L5957    pshs  b,a
         lbsr  Spacing
         puls  a
L595E    lbsr  L5601
         puls  b
         lbsr  Spacing
L5966    clra
         puls  pc,u,x

L5969    jsr   <u0016
         cmpa  #$02
         beq   L5976
         lbcc  L58B1
         lbsr  Flote
L5976    pshs  u,x
         leas  -$0A,s
         leax  ,s
         lbsr  RtoA
         lda   <u0079
         cmpa  #$09
         bgt   L5996
         lbsr  L5A6A
         lda   <u0086
         suba  #$02
         bmi   L5996
         suba  <u0089
         bmi   L5996
         suba  <u008A
         bpl   L599C
L5996    leas  $0A,s
         puls  u,x
         bra   Overflow

L599C    sta   <u0088
         leax  ,s
         ldb   <u0087
         beq   L59AC                    left justify
         bmi   L59B2                    fin. format
         bsr   L59E9                    right justify
         bsr   L59BE
         bra   L59B9
L59AC    bsr   L59BE
         bsr   L59E9
         bra   L59B9
L59B2    bsr   L59E9
         bsr   L59C1
         lbsr  L563F
L59B9    leas  $0A,s
         clra
         puls  pc,u,x
L59BE    lbsr  L563F
L59C1    lda   <u008A
         lbsr  L5601
         lbsr  L5612
         ldb   <u0079
         bpl   L59F9
         negb
         cmpb  <u0089
         bls   L59D4
         ldb   <u0089
L59D4    pshs  b
         lbsr  L5634
         ldb   <u0089
         subb  ,s+
         stb   <u0089
         lda   <u008B
         cmpa  <u0089
         bls   L59E7
         lda   <u0089
L59E7    bra   L59FB

L59E9    ldb   <u0088
         lbra  Spacing
L59EE    lbsr  L563F
         lda   <u008A
         lbsr  L5601
         lbsr  L5612
L59F9    lda   <u008B
L59FB    lbsr  L5601
         ldb   <u0089
         subb  <u008B
         ble   L5A0F
         lbra  L5634

Overflow ldb   <u0086
         lda   #'*
         lbsr  L5636
         clra
L5A0F    rts

FMTexp   jsr   <u0016
         cmpa  #$02
         beq   L5A1D
         lbcc  L58B1                    wrong type
         lbsr  Flote
L5A1D    pshs  u,x
         leas  -$0A,s
         leax  ,s
         lbsr  RtoA
         lda   <u0079
         pshs  a
         lda   #$01
         sta   <u0079
         bsr   L5A6A
         puls  a
         ldb   <u0079
         cmpb  #$01
         beq   L5A39
         inca
L5A39    ldb   #$01
         stb   <u008A
         sta   <u0079
         lda   <u0086
         suba  #$06
         bmi   L5A4D
         suba  <u0089
         bmi   L5A4D
         suba  <u008A
         bpl   L5A53
L5A4D    leas  $0A,s
         puls  u,x
         bra   Overflow
L5A53    sta   <u0088
         ldb   <u0087
         beq   L5A62
         bsr   L59E9
         bsr   L59EE
         lbsr  L55DA
         bra   L5A67
L5A62    bsr   L59EE
         lbsr  L55DA
L5A67    lbra  L59B9
L5A6A    pshs  x
         lda   <u0079
         adda  <u0089
         bne   L5A78
         lda   ,x
         cmpa  #$35
         bcc   L5A8F
L5A78    deca
         bmi   L5AAB
         cmpa  #$07
         bhi   L5AAB
         leax  a,x
         ldb   $01,x
         cmpb  #$35
         bcs   L5AAB
L5A87    inc   ,x
         ldb   ,x
         cmpb  #$39
         bls   L5AAB
L5A8F    ldb   #$30
         stb   ,x
         leax  -$01,x
         cmpx  ,s
         bcc   L5A87
         ldx   ,s
         leax  $08,x
L5A9D    lda   ,-x
         sta   $01,x
         cmpx  ,s
         bhi   L5A9D
         lda   #$31
         sta   ,x
         inc   <u0079
L5AAB    puls  x
         lda   <u0079
         bpl   L5AB2
         clra
L5AB2    sta   <u008A
         nega
         adda  #$09
         bpl   L5ABA
         clra
L5ABA    cmpa  <u0089
         bls   L5AC0
         lda   <u0089
L5AC0    sta   <u008B
         rts

ERR48    ldb   #E$NoRout        Unimplemented routine error
         stb   <errcode
         coma
         rts

         emod
eom      equ   *
         end

* END SHARE
