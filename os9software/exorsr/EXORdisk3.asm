 nam   EXORdisk3
 ttl   os9 device driver

 use defsfile

Edition equ 4 Current Edition

***************************************************************
*
* Disk Driver Module Header
*
*
 mod DSKEND,DSKNAM,Drivr+Objct,ReEnt+3,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.

DriveCnt equ 4

 org $15
* use of direct page space in kernel
ILVSTAT    rmb   2 Points to next sector number in interleave table
u0017    rmb   1 retry counter
u0018    rmb   1
u0019    rmb   1
u001A    rmb   1
u001B    rmb   1
DMA.STAK    rmb   2 Stack pointer
ORG.NMI    rmb   2

 org Drvbeg
 rmb Drvmem*DriveCnt

CURDRV rmb 1 Drive select bit pattern
X.CURLSN    rmb   2
X.SIZE    rmb   2
V.BUF    rmb   2
V.ERRCD    rmb   1 Some sort of error code returned by EXORctlr
u006F rmb 4 Unused here
u0073    rmb   1
u0074    rmb   1
X.ORGNMI rmb 2
X.STACK rmb 2 $77
X.TRAK    rmb   1 $79 Current track number
u007A rmb 2
I.DELAY    rmb   1  $7C inner delay value
u007D    rmb   1
X.STAT    rmb   1
CURTBL    rmb   2 $7F
X.DELAY    rmb   2  $81
X.INIT    rmb   2 init routine
X.RDSK    rmb   2 read sector routine
u0087    rmb   2
CTLRADDR    rmb   2
DSKSTA     equ   .

*
* Registers for a Motorola 6843 FDC
*
FD.DOR equ 0 Data Output Register (write only)
FD.DIR equ 0 Data Input Register (read only)
FD.CTAR equ 1 Current Track Address Register (read/write)
FD.CMR equ 2 Command Register (write only)
FD.ISR equ 2 Interrupt Status Register (read only)
FD.SUR equ 3 Setup Register (write only)
FD.STRA equ 3 Status Register A (read only)
FD.SAR equ 4 Sector Address Register (write only)
FD.STRB equ 4 Status Register B (read only)
FD.GCR equ 5 General Count Register (write only)
FD.CCR equ 6 CRC Control Register (write only)
FD.LTAR equ 7 Logical Track Address Register (write only)

* FD macro commands
CMD.STZ equ $2
CMD.SEK equ $3
CMD.SSR equ $4
CMD.SSW equ $5
CMD.RCR equ $6
CMD.SWD equ $7
CMD.FFR equ $A
CMD.FFW equ $B
CMD.MSR equ $C
CMD.MSW equ $D

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

L0032    fcb 15,10,6,3 Step delays

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
         stx   >X.INIT,u
         leax  $03,x
         stx   >X.RDSK,u
         leax  $03,x
         stx   >u0087,u
         lda   <$13,y  IT.DRV
         sta   CURDRV,u
         lda   <$14,y  IT.STP
         anda  #$03
         leay  <L0032,pcr
         lda   a,y
         ldb   #$27
         mul
         std   >X.DELAY,u
         ldy   V.PORT,u
         leax  DRVBEG,u
         stx   CURTBL,u
         jsr   [>X.INIT,u]
         ldb   #$04
         stb   <X.STAT,u
         jsr   [>u0087,u]
         lda   <I.DELAY,u
         cmpa  #$02
         bne   L009E
         ldx   #$2001  BRA +1
         stx   >L03C0,pcr remove delay loop
         stx   >L03DD,pcr remove delay loop
L009E    suba  #$04
         bcs   L00BA
         suba  #$03
         bcc   L00AB
         ldx   #$3084
         bra   L00B6
L00AB    leax  >L0387,pcr
         stx   >L0312,pcr
         ldx   #$12BD  NOP,JSR?
L00B6    stx   >L0310,pcr
L00BA    ldx   CURTBL,u
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
L00F6    ldb   <I.DELAY,u
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
         lda   PD.DRV,y
         cmpa  CURDRV,u
         beq   L010F
         bsr   L00F1
L010F    lda   #$80
         tst   PD.VFY,y
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
L011E    jsr   [X.RDSK,u]
         bcs   WRERR9
         ldd   <X.CURLSN,u
         bne   RDDSK3
         bsr   RDDSK3 read LSN 0
         bcs   WRERR9
 ldx PD.BUF,Y Point to buffer
         pshs  y,x
         ldy   CURTBL,u
         ldb   DD.FMT,x
         bitb  #$06
         bne   L018E
         ldd   DD.DSK,x
         cmpd  DD.DSK,y was disk changed?
         beq   READ02 ..no
 ldb #DD.SIZ-1 copy disk descriptor
READ01 lda B,X
 sta B,Y
 decb
 bpl READ01
READ02 clrb
 puls  pc,y,x

RDDSK3    pshs  y,x
         ldy   V.PORT,u
         jsr   [>u0087,u]
         bcc   EXITXX
         ldb   <X.STAT,u
         pshs  b
         ldb   #$08
         stb   <X.STAT,u
         jsr   [>u0087,u]
         puls  a
         sta   <X.STAT,u
         bcs   L0187
         puls  y,x
         pshs  y,x
         ldd   PD.BUF,y
         std   <V.BUF,u
         ldd   #$0001
         std   <X.SIZE,u
         ldy   V.PORT,u
         jsr   [>u0087,u]
         bcc   EXITXX
L0187    ldb   <V.ERRCD,u
         coma
EXITXX    puls  y,x
WRERR9    rts

L018E    comb
         ldb   #E$BTyp
         puls  pc,y,x

GETSTA clrb
 rts

PUTSTA    ldx PD.RGS,y
         ldb  R$B,x
         cmpb  #SS.RST $03 Device Restore
         beq   RESTOR
         cmpb  #SS.WTK $04 Device Write Track
         beq   WRTTRK
         comb
         ldb   #E$USvc Unknown Service request
         rts

* Restore head to track 0
RESTOR    pshs  y,x
         clrb
         ldx   #$0000
         lda   #$08
         jsr   [>X.RDSK,u]
         bcs   WRERR9
         ldy   V.PORT,u
         jsr   [>u0087,u]
         bcs   L0187
         puls  pc,y,x

* Format track
WRTTRK    pshs  y,x
         ldb   <$2A,y
         tst   <u0073,u
         bmi   L01CB
         addb  <$2A,y
L01CB    lda   $09,x
         bne   L01F6
         pshs  x,b,a
         ldx   CURTBL,u
         clr   DD.FMT,x
         clr   DD.DSK,x
         clr   DD.DSK+1,x
         lda PD.SID,y
         cmpa  #1
         beq   L01E5
         inc   DD.FMT,x set two-sided disk
L01E5    ldb   PD.CYL,y
         mul
         lda   PD.SCT+1,y
         mul
         subd  #1
         std   DD.TOT+1,x
         clr   ,x
         puls  x,b,a
L01F6    mul
         pshs  b,a
         clrb
         lda   DD.BIT+1,x
         anda  #$01
         beq   L0203
         ldb   PD.SCT+1,y
L0203    clra
         addd  ,s++
         tfr   d,x
         clrb
         lda   #$10
         jsr   [>X.RDSK,u]
         lbcs  EXITXX
         ldy   V.PORT,u
         jsr   [>u0087,u]
         lbcs  EXITXX
         ldy 2,s get ptr to path descriptor
         bsr   INTERLV
         lbcs  EXITXX
         leax  <L0246,pcr
         stx   <V.BUF,u
         ldd   #$0010
         std   <X.SIZE,u
         ldb   #$C2
         stb   <X.STAT,u
         ldy   V.PORT,u
         jsr   [>u0087,u]
         lbcs  L0187
         clrb
         puls  pc,y,x

L0246    fdb $E5E5

**************************************
*
* Terminate use of the disk
*
*
TRMNAT    ldx   V.PORT,u
         lda   0,x
         ora   #$10
         sta   0,x
         clra
         clrb
         std   2,x
         std   0,x
         pshs  u
         ldu   >CTLRADDR,u
         os9   F$UnLk
         clrb
         puls  pc,u

* Determine interleave to use
INTERLV    leax  >ILVTBL,pcr
         lda   PD.ILV,y   
         anda  #%11
         deca
         ldb   #16  Number of sectors on a track
         mul
         leax  d,x
         stx   <ILVSTAT
         clra
         sta   <u0017
         lda   <u007D,u
         sta   <u0018
         lda   <u0074,u
         sta   <u001A
         lda   #$05
         sta   <u001B
         lda   <X.TRAK,u
         sta   <u0019
         ldy   V.PORT,u
         pshs  u
         sts   <DMA.STAK
         ldb   FD.DIR,y
         orb   #$04
         cmpa  #$2B
         bls   L029B
         andb  #$FB
L029B    stb   FD.DOR,y
         lda   FD.CTAR,y
         ora   #$40
         tst   <u001A
         beq   L02A9
         anda  #$20
         ora   #$03
L02A9    sta   FD.CTAR,y
L02AB    lbsr  NMIINSRT
         ldx   #$001E
         lda   <u0018
L02B3    deca
         bpl   L02B3
         ldu   #$C0DA
         stu  FD.SAR,y
         ldu   #$C1FF
         stu  FD.SAR,y
         ldu   #$8270
         stu  FD.SAR,y
         lda   FD.CTAR,y
         anda  #$F2
         sta   FD.CTAR,y
         eora  #$00
         bita  #$10
         bne   L02D9
         lbsr  NMIRESET
         comb
         ldb   #E$WP
         puls  pc,u

L02D9    anda  #$60
         sta   FD.CTAR,y
L02DD    lda   $03,y
         bpl   L02DD
         ldu   #$8210
         stu  FD.SAR,y
         lbsr  L03B8
         ldu   #$83F7
         stu  FD.SAR,y
         lda   #$7A
         sta   FD.GCR,y
         ldu   #$81FF
         stu  FD.SAR,y
         ldx   #$000C
L02FA    lda   #$18
         ldu   #$8210
         stu  FD.SAR,y
L0301    bita FD.STRB,y
         beq   L0301
         sta   FD.GCR,y
L0307    bita FD.STRB,y
         beq   L0307
         ldu   #$C270
         stu  FD.SAR,y
L0310    bita  #$00
L0312    lda   #$82
         inc   FD.CTAR,y
         sta  FD.SAR,y
         lbsr  L03B8
         dec   FD.CTAR,y
         ldu   #$83F5
         stu  FD.SAR,y
         ldb   #$7E
         lda   #$40
         stb   FD.GCR,y
L0328    bita FD.STRB,y
         beq   L0328
         ldb   <u0019
         stb   FD.GCR,y
         ldb   <u001A
         stb   FD.GCR,y
         ldu   <ILVSTAT
L0336    bita FD.STRB,y
         beq   L0336
         ldb   ,u+
         stb   FD.GCR,y
         ldb   #$01
         stb   FD.GCR,y
         stu   <ILVSTAT
L0344    bita FD.STRB,y
         beq   L0344
         clrb
         stb   FD.GCR,y
L034B    bita FD.STRB,y
         beq   L034B
         ldb   FD.CTAR,y
         orb   #$08
         stb   FD.CTAR,y
         stb   FD.GCR,y
L0357    bita FD.STRB,y
         beq   L0357
         lda   #$FF
         sta   FD.GCR,y
         lda   #$40
L0361    bita FD.STRB,y
         beq   L0361
         andb  #$60
         stb   FD.CTAR,y
         ldu   #$81FF
         stu  FD.SAR,y
         ldx   #$011D
         lda   <u0017
         inca
         sta   <u0017
         cmpa  #$10
         bne   L02FA
L037A    lda   $03,y
         bpl   L037A
         dec   FD.CTAR,y
         dec   FD.CTAR,y
         bsr   NMIRESET
         clrb
         puls  pc,u

L0387    lda   #$82
         bita  <u0019
         rts

* Insert own NMI routine
NMIINSRT    pshs  x
         orcc  #$50
         ldx   <D.NMI
         stx   <ORG.NMI
         leax  <NMISVC,pcr
         stx   <D.NMI
         lda   #$36
         sta   FD.SUR,y
         lda   #$3E
         sta   FD.SUR,y
         ldb   FD.DIR,y
         deca
         sta   $02,y
         puls  pc,x

NMIRESET    pshs  x
         lda   #$3C   DMA on, Multi-sector read
         sta   FD.CMR,y
         lda   FD.DIR,y
         ldx   ORG.NMI
         stx   D.NMI
         andcc #$AF
         puls  pc,x

L03B8    lda   #$18
L03BA    bita FD.STRB,y
         beq   L03BA
         ldb   <u0018
* delay loop
L03C0    decb
         bne   L03C0

         sta   FD.GCR,y
         leax  -1,x
         bne   L03BA
         ldu   #$81AA
         ldb   #$05
         nop
         nop
         stu  FD.SAR,y
         ldu   #$8210
         stu  FD.SAR,y
L03D7    bita FD.STRB,y
         beq   L03D7
         lda   <u0018

* delay loop
L03DD    deca
         bne   L03DD

         lda   #$18
         sta   FD.GCR,y
         decb
         bne   L03D7
         rts

* NMI interrupt routine
NMISVC   lds DMA.STAK
         bsr   NMIRESET
         dec   FD.CTAR,y
         dec   FD.CTAR,y double step
         dec   <u001B
         lbne  L02AB
         comb
         ldb   #E$Wr Write Error
         puls  pc,u

ILVTBL   fcb $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
         fcb $00,$08,$01,$09,$02,$0A,$03,$0B,$04,$0C,$05,$0D,$06,$0E,$07,$0F
         fcb $00,$0B,$06,$01,$0C,$07,$02,$0D,$08,$03,$0E,$09,$04,$0F,$0A,$05

 emod
DSKEND equ  *
