 nam   XBC
 ttl   Driver Module

*       OS-9 XBC Winchester Disk Driver Module Source Code
*
*           Software For GIMIX/XEBEC Winchester Controller

 use defsfile

 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+1,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
DSKNAM fcs "XBC"
 fcb 3 Edition telltale byte

HDCnt equ 2
 pag
*********************************************************************
*
* Static Storage
*
*
 org Drvbeg
 rmb Drvmem*HDCnt
u005B    rmb   1
CURDRV    rmb   1
CURTBL    rmb   2
V.DRVNUM    rmb   1
V.USEDMA rmb 1  Use DMA
V.DCB0    rmb   1
V.DMAADR    rmb   3
V.CMD    rmb   1
V.LUN    rmb   1 Logical Unit number in bits 5-7
u0067    rmb   2
u0069    rmb   1
u006A    rmb   1
u006B    rmb   1
u006C    rmb   1
u006D    rmb   4

DSKSTA     equ   .

DSKENT lbra INIDSK Initialize i/o
 lbra READSK Read sector
 lbra WRTDSK Write sector
 lbra GETSTA Get status call
 lbra PUTSTA
 lbra TERMNT Terminate device use

HDMASK fcb 0 no flip bits
 fcb $80 Irq polling mask
 fcb 1 Priority

* XEBEC S-1410 opcodes
F.DRVRDY equ $00  Test drive ready command
F.STATUS equ $03 Status sense command
F.FORMAT equ $04 Format command
F.READ equ $08 Read sectors command
F.WRIT equ $0A Write sectors command
F.SEEK equ $0B Seek command
F.INITL equ $0C Initialize disk size command

* SASI card port addresses
*
R.STAT equ 0 Status register
R.DATA equ 4 SASI data port
W.CTRL equ 0 Control register
W.ADDR16 equ 1 DMA address register (A19-A16)
W.ADDR8 equ 2 DMA address register (A15-A8)
W.ADDR0 equ 3 DMA address register (A7-A0)
W.DATA equ 4 SASI data port

* Control register bitmasks
C.RST equ %10000000 reset SASI
C.INTE equ %1000000 enable interrupts
C.DMA equ %100000 enable DMA transfer
C.SELMSK equ %11111 select controller mask

* Status register bitmasks
S.REQ equ %1 request for data transfer
S.MSG equ %10 second byte of command status waiting
S.CD equ %100 command block being sent or received
S.BUSY equ %1000 external controller busy
S.IO equ %10000 data from SASI to host
S.DMA equ %100000 DMA transfer enabled
S.INTE equ %1000000 Interrupts to host enabled
S.INT equ %10000000 command complete

****************************************************************
*
* Initialize The I/O Port
*
*  Input: (U)= Pointer To Global Storage
*
INIDSK ldx V.PORT,U Point to i/o port
 clra
 sta W.CTRL,x
         sta V.DRVNUM,u clear drive number
         sta V.DMAADR,u
         sta V.USEDMA,u
 ldb #C.RST
 stb W.CTRL,x reset SASI
 sta W.CTRL,x clear reset
 leay DRVBEG,U Point to first drive table
 lda #HDCnt
 sta V.NDRV,U Inz number of drives
 ldb #$FF
 stb CURDRV,u
INILUP stb DD.TOT,y Inz to non-zero
 stb V.TRAK,Y Inz to high track count
 leay DRVMEM,Y Point to next drive table
 deca DONE
 bne INILUP ...no; inz more.
 leay ,x Point to i/o port
 tfr y,d
 leax HDMASK,pcr
 leay IRQSVC,pcr
 os9 F$IRQ
 bcs RETRN1
 clrb
RETRN1 rts

*************************************************************
*
* Read Sector Command
*
* Input: B = Msb Of Logical Sector Number
*        X = Lsbs Of Logical Sector Number
*        Y = Ptr To Path Descriptor
*        U = Ptr To Global Storage
*
* Output: 256 Bytes Of Data Returned In Buffer
*
* Error: Cc=Set, B=Error Code
*
READSK tstb Could this be sector zero?
 bne RDDSK3 No.. too high
 cmpx #0 Is this sector zero?
 bne RDDSK3
 bsr RDDSK3
 bcs WRERR9
 pshs y,x
 ldx V.DMAADR+1,u
 ldy CURTBL,U
 ldb #DD.SIZ-1
READ01 lda B,X
 sta B,Y
 decb
 bpl READ01
 clrb
 puls y,x
WRERR9 rts

RDDSK3 bsr SELECT
 bcs WRERR9
 lda #F.READ   Read command
 lbra WCR

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
WRTDSK    bsr   SELECT
         bcs   WRERR9
         lda   #F.WRIT   Write command
         lbra  WCR
***************************************************************
*
* Select Drive
*
*  Input: (U)= Pointer To Global Storage
*
* Output: Curtbl,U=Current Drive Tbl
*         Curdrv,U=Drive Number
*
SELECT lda PD.DRV,Y Get drive number
 cmpa V.NDRV,U Drive num ok?
 lbhs ERUNIT ..no; report error.
 pshs y,x,b
 ldx PD.BUF,y

 ifge LEVEL-2
* Register X is modified here to calculate the extended address
* This must then be stored in V.DMAADR,U and the high nibble in X
* changed to block number
* This code can definitely be optimized
 pshs A save drive number
 tfr X,D
 anda #$F0
 lsra Shift block number to lower nibble
 lsra
 lsra
 pshs X put X on stack for later manipulation
 ldx D.SysDAT Get system DAT
 ldd A,X get block number
 clra
 lsrb set the DMA extended bits
 rora
 lsrb
 rora
 lsrb
 rora
 lsrb
 rora
 stb V.DMAADR,u
 pshs A make copy of block number
 lda 1,S load high byte of X
 anda #$0F
 ora 0,S load the high nibble of block
 sta 1,S
 puls A
 puls X
 puls A
 endc

 stx V.DMAADR+1,U store LSBs of DMA address
 cmpa CURDRV,u
 beq SELCT2 Already current drive
 sta CURDRV,U
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
 stx <CURTBL,u
         clr   V.TRAK,x
         ldb   PD.TYP,y
         pshs  b
         andb  #S.DMA
         stb   <V.LUN,u
         puls  b
         andb  #C.SELMSK reset IRQ, DMA
         stb   V.DCB0,u
         bitb  V.DRVNUM,u Drive number set?
         bne   SELCT2 ..yes
         lda   #F.INITL   Init drive
         leax DRVCHRS,pcr get drive characteristics
         bsr   WCR
         bcc   SELCT1
         puls  x,a
         bra   SELCT4

SELCT1    ldb   PD.TYP,y
         andb  #C.SELMSK
         orb   V.DRVNUM,u
         stb   V.DRVNUM,u
SELCT2 puls x,b
 ldy CURTBL,u
 cmpb DD.TOT,y Too high sector number?
 bcs SELCT3 .. no
 cmpx DD.TOT+1,Y Too high sector number?
 bcs SELCT3 .. no
 coma
 ldb #E$Sect
 bra SELCT4

SELCT3    lda   #$01
         sta   <u0069,u
         lda   #$04
         sta   <u006A,u
         lda   V.DCB0,u
         ora   #$60
         sta   V.DCB0,u
         ldy   ,s
         pshs  b
         ldb   PD.TYP,y
         andb  #S.DMA
         orb   ,s
         stb   <V.LUN,u
         puls  b
         clra
         stx   <u0067,u
SELCT4 puls  pc,y


ERUNIT comb
 ldb #E$UNIT Error: illegal unit (drive)
 rts

* Drive characteristics
DRVCHRS fdb $0132  Number of cylinders
 fcb 6     Number of heads
 fdb $0132  Starting reduced write current cylinder
 fdb $0132  Starting write precompensation cylinder
 fcb 11     Maximum error burst length

***********************************************************
* Send command to disk
*
* Input: (A) = command to controller
*
WCR pshs y,x
 ldy V.PORT,U Point to i/o port
         sta   V.CMD,u
         cmpa  #F.STATUS is it a status check?
         beq   WCRSTAT ..yes
         cmpa  #F.INITL code lower than F.INITL?
         bcs   L016C ..yes
         cmpa  #$0D
         bne   L0157

WCRSTAT    inc   V.USEDMA,u
         bsr   WRTCMD
         clr   V.USEDMA,u
         ldx   ,s
         lbsr  RDSASI
         bra   L0167

* Initialize drive
L0157    cmpa  #F.INITL Is it initialize disk size command?
         bne   L016C ..no
         inc   V.USEDMA,u
         bsr   WRTCMD
         clr   V.USEDMA,u
         ldx   ,s
         bsr   WRTSASI
L0167    lbsr  L01E9
         bra   L017C

* Use DMA for these opcodes
L016C    lda   V.BUSY,u
         sta   V.WAKE,u
         bsr   WRTCMD
L0172    ldx   #0
         os9   F$Sleep
         lda   V.WAKE,u
         bne   L0172
L017C    lda   #$02
         bita  <u005B,u
         beq   L0186
         lbsr  L01FB
L0186    puls  pc,y,x

* Reserve DMA and send command
WRTCMD    ldd  V.DMAADR,u
         sta   W.ADDR16,y
         stb   W.ADDR8,y
         lda   V.DMAADR+2,u
         sta   W.ADDR0,y
         lda   V.DCB0,u
         sta   W.CTRL,y
         leax  V.CMD,u
         ldb   #4 send four bytes to SASI
L019E    bsr   WAITSASI
         lda   ,x+
         sta   W.DATA,y
         decb
         bpl   L019E
         bsr   WAITSASI
         lda   ,x+
         tst   V.USEDMA,u
         bne   L01C3
L01B0    ldb   D.DMAReq Wait for other DMA to finish
         beq   L01C0
         pshs  x
         ldx   #1
         os9   F$Sleep
         puls  x
         bra   L01B0
L01C0    incb
         stb   D.DMAReq reserve DMA
L01C3    sta W.DATA,y
         rts

* Write data to SASI controller without DMA
WRTSASI    bsr   WAITSASI
         bita  #S.IO+S.CD
         bne   WRTSASI
WRTSASI1    lda   ,x+
         sta   W.DATA,y
         bsr   WAITSASI
         bita  #S.CD
         beq   WRTSASI1
         rts

* Read data from SASI controller without DMA
*
* Input: X = ptr to data buffer
*
RDSASI    lda R.DATA,y
         sta   ,x+
         bsr   WAITSASI
         bita  #S.CD
         beq   RDSASI
         rts

* Wait for transfer request
WAITSASI    lda  R.STAT,y
         bita  #S.REQ SASI requesting more data?
         beq   WAITSASI ..no
         rts

L01E9    bsr   WAITSASI
         ldb   $04,y
         stb   <u005B,u
L01F0    bsr   WAITSASI
         bita  #S.REQ
         beq   L01F0
         lda   $04,y
         bitb  #$02
         rts

L01FB    ldb   #F.STATUS
         stb   V.CMD,u
         ldb   V.DCB0,u
         andb  #C.SELMSK
         stb   V.DCB0,u
         inc   V.USEDMA,u
         lbsr  WRTCMD set DMA address
         clr   V.USEDMA,u
L0211    bsr   WAITSASI
         bita  #S.IO SASI sending data?
         beq   L0211 branch is so
         leax  <u006B,u
         bsr   RDSASI
         bsr   L01E9
         beq   L0225
         ldb   #$3F
         stb   <u006B,u
L0225    lda   <u006B,u
         anda  #$3F
         beq   L023F
         cmpa  #$18    Correctable data error
         beq   L023F
         leay ERRTBL,pcr
L0234    cmpa  ,y++
         beq   L023C
         tst   ,y
         bpl   L0234
L023C    comb
         ldb   -1,y
L023F    rts

***************
* process interrupt from controller
* Passed: (U)=Static Storage addr
*         (X)=Port address
*         (A)=polled status
* Returns: Nothing
*
IRQSVC ldy V.PORT,U Point to i/o port
         ldb   R.STAT,y
         bitb  #$40
         beq   L0269
         lda   V.WAKE,u
         beq   L0268
         ldb   V.DCB0,u
         andb  #C.SELMSK
         stb   W.CTRL,y
         tst   V.USEDMA,u
         bne   L025B
         clr   D.DMAReq
L025B    pshs  a
         bsr   L01E9
         puls  a
 ldb #S$Wake
 clr V.WAKE,u
 os9 F$Send
L0268    clrb
L0269    rts

ERRTBL   fcb   $01,E$NotRdy
         fcb   $02,E$Seek    No seek complete from disk drive
         fcb   $03,E$Write   Write fault from disk drive
         fcb   $04,E$NotRdy  Drive not ready after it was selected
         fcb   $06,E$Seek    Track 00 not found
         fcb   $10,E$Read    ID field read error
         fcb   $11,E$Read    Uncorrectable data error
         fcb   $12,E$Seek    Address mark not found
         fcb   $14,E$Seek    Target sector not found
         fcb   $19,E$Seek    Bad track flag detected
         fcb   $1A,E$BTyp    Format error
         fcb   $20,E$Unit    Invalid command
         fcb   $21,E$Sect    Illegal disk address
         fcb   $30,E$Write   Ram diagnostic failure
         fcb   $31,E$Read    Program memory checksum error
         fcb   $32,E$CRC     ECC diagnostic failuer
         fcb   $3F,E$DevBsy
         fcb   $FF,E$WP

************************************************************
*
* Put Status Call
* Y = Address of the path descriptor
*
*
PUTSTA ldx PD.RGS,Y Point to parameters
 ldb R$B,x
 cmpb #SS.Reset Restore call?
 beq RESTOR
 cmpb #SS.WTrk Write track call?
 beq WRTTRK
 cmpb #SS.DCmd
 lbeq DCMD
GETSTA comb ...NO; Error
 ldb #E$UnkSvc Error code
 rts


RESTOR lbsr SELECT
         lda   V.DCB0,u
         anda  #C.SELMSK
         ora   #$40
         sta   V.DCB0,u
         lda   #$01
         lbra  WCR

WRTTRK ldd R$U,x Track number
         bne   L032D
         ldb   R$Y,x Side/density
         bne   L032D
         clrb
         ldx   #$0000
         lbsr  SELECT
         bcs   L032E
         lda   V.DCB0,u
         anda  #C.SELMSK
         ora   #$40
         sta   V.DCB0,u
         ldb   <V.LUN,u
         andb  #$E0
         stb   <V.LUN,u
         clra
         clrb
         std   <u0067,u
         lda   PD.ILV,y
         ldb   #$04     Step option
         std   <u0069,u Store interleave and step option
L02E6    lda   #F.FORMAT
         lbsr  WCR
         bcc   L032D
         cmpb  #E$BTyp
         bne   L032E
         clra
         ldd   <u006D,u
         andb  #$E0
         addd  #$0020
         std   <u0067,u
         pshs  b,a
         ldb   <u006C,u
         andb  #$1F
         bcc   L031A
         adcb  #$00
         pshs  b
         lda   <u006C,u
         anda  #$40
         pshs  a
         orb   ,s
         puls  a
         stb   <V.LUN,u
         puls  b
L031A    puls  x
         ldy   CURTBL,u
         cmpb  DD.TOT,y
         bcs   L02E6
         cmpx  DD.TOT+1,y
         bcs   L02E6
         comb
         ldb   #E$DevBsy
         bra   L032E

L032D    clrb
L032E    rts

* Direct command to disk controller
* X = Address of register stack
DCMD    pshs  y,x
         ldy   R$Y,x
         ldb   $05,y
         andb  #$1F
         ldx   $06,y
         ldy   $02,s
         lbsr  SELECT
         puls  y,x
         bcs   L032E
         ldy   R$Y,x
         ldd   ,y++
         ora   V.DCB0,u
         std   V.DCB0,u
         ldd   ,y++
         std   V.DMAADR+1,u
         ldd   ,y++
         pshs  a
         sta   V.CMD,u
         leay  $02,y
         ldd   ,y++
         std   <u0069,u
         puls  a
         ldx   $08,x
         lbra  WCR

Termnt ldy V.PORT,U Point to i/o port
 clr   W.CTRL,y
 ldx   #0
 os9   F$IRQ
 rts
 emod
DSKEND      equ   *
