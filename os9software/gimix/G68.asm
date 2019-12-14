 nam   G68
 ttl   os9 device driver

 use   defsfile

 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+1,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
DSKNAM fcs "G68"
 fcb 5 Edition

 pag
*********************************************************************
*
* Static Storage
*
*
 org Drvbeg
 rmb Drvmem*DriveCnt

CURTBL rmb 2 Ptr to current drive tbl
CURDRV rmb 1 Drive select bit pattern
V.SEL rmb 2 Drive select reg addr./DMA Status register
V.DMACTL    rmb   2
V.DMAADR rmb 2 DMA address register
V.CMDR    rmb   2
V.TRKR    rmb   2
V.SECR    rmb   2
V.DATR    rmb   2
V.SIDE rmb 1 Current side; 0:=side 0
u00B9    rmb   1
u00BA    rmb   1
V.FDSTA rmb 1  FD status
u00BC  rmb 1
V.TMP rmb 1 Temporary save byte
V.EFLG rmb 1 Set "e" for head settle time
V.BUF rmb 2 Local buffer addr
V.DOSK rmb 1 Force seek flag
V.FREZ rmb 1 Freeze dd. info (for one read0)

DSKSTA     equ   .

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

DMA.INT equ %10000000 Interrupt enable
DMA.SD1 equ %01000000 Side select - side one
DMA.WRI equ %00100000 DMA direction - write
DMA.ENA equ %00010000 DMA enabled

DMA.FLT equ %00001000 DMA Fault flag

F.REST equ $0B Restore command
F.SEEK equ $1B Seek command
F.STPI equ $4B Step in one track command
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F4 Write track command

FDMASK   fcb   $00 no flip bits
         fcb   $40
         fcb   $01

PUTSTA ldx PD.RGS,Y Point to parameters
 ldb R$B,X Get stat call
 cmpb #SS.Reset Restore call?
 lbeq RESTOR ..yes; do it.
 cmpb #SS.WTrk Write track call?
 lbeq WRTTRK ..yes; do it.
 cmpb #SS.FRZ Freeze dd. info?
 beq SETFRZ Yes; ....flag it.
 cmpb #SS.SPT Set sect/trk?
 beq SETSPT Yes; ....set it.
GETSTA comb ...NO; Error
 ldb #E$UnkSvc Error code
 rts

SETFRZ ldb #$FF
 stb V.FREZ,u Set flag
 clrb
 rts


SETSPT lbsr SELECT Find drive table
 ldd R$X,x Get input sect/trk
 ldx CURTBL,u Point to drive table
 stb DD.TKS,x
 clrb
 rts
 pag
****************************************************************
*
* Initialize The I/O Port
*
*  Input: (U)= Pointer To Global Storage
*
*  On Exit: (A) Modified
*           (X) Modified
*           (Y) Unchanged
*           (U) Unchanged
*
INIDSK ldx V.PORT,U Point to i/o port
 stx V.SEL,u
 leax 1,x   DMA Control register
 stx V.DMACTL,u
 leax 1,x   DMA starting address
 stx V.DMAADR,u
 leax 2,x  FD1797 Command/status register
 lda #$D0    Code for clear interrupt
 sta 0,x
 stx V.CMDR,u
 leax 1,x   FD1797 Track register
 stx V.TRKR,u
 leax 1,X   FD1797 sector register
 stx V.SECR,U
 leax 1,x   FD1797 Data register
 stx V.DATR,u
 lda #$FF
 ldb #DriveCnt
 stb V.NDRV,U Inz number of drives
 leax DRVBEG,U Point to first drive table
INILUP sta DD.TOT,x Inz to non-zero
 sta V.TRAK,X Inz to high track count
 leax DRVMEM,X Point to next drive table
 decb DONE
 bne INILUP ...no; inz more.
 ldd #256 "d" passes memory req size
 pshs U Save "u" we need it later
 OS9 F$SRqMem Request 1 pag of mem
 tfr U,X
 puls U
 bcs RETRN1
 stx V.BUF,u
 ldd V.SEL,u
 leax FDMASK,pcr
 leay <IRQSVC,pcr
 os9 F$IRQ
 bcs RETRN1
 clrb
RETRN1 rts

IRQSVC ldb [V.CMDR,u]
 coma
 lda V.WAKE,u
 beq IRQEND Nothing waiting
 tst V.TMP,u
 beq ISVC01
 clr D.DMAReq
ISVC01 stb V.FDSTA,u
 ldb #S$Wake
 clr V.WAKE,u
 os9 F$Send
 clrb
IRQEND rts

 pag
*********************************************************
*
* Restore Drive To Track Zero
*
*  Input: (Y)= Pointer To Path Descriptor
*         (U)= Pointer To Global Storage
*
*  If Error: (B)= Error Code & Carry Is Set
*
* Note:  We Are Stepping In Several Tracks Before
*        Issuing The Restore.  As Suggested In The
*        Application Notes.
*
RESTOR lbsr SELECT Select drive
 bcs RETRN1
 ldx CURTBL,U
 clr V.TRAK,X Old track = 0
 lda #5 Repeat five times
RESTR2 pshs a
 ldb PD.STP,y
 andb #$03
 eorb #F.STPI
 clr V.TMP,u
 bsr WCR0
 puls a
 deca
 bne RESTR2
 ldb PD.STP,y
 andb #$03
 eorb #F.REST
 bra WCR0
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
         lbeq  WRERR
         puls  x,b,a
         tst   PD.VFY,y
         bne   RETRN1
         lbsr  WRTVFY
         bcc   RETRN1
L0130    lsra
         bcc   L0108
         pshs  x,b,a
         bsr   RESTOR
         puls  x,b,a
         bra   L0108

L013B    lbsr  SEEK
         lbcs  RETRN1
         ldx   PD.BUF,y
         lda   #$30
         sta   V.TMP,u
         ldb   #F.WRIT
         bsr   WCR0
         lbra  STCK

L0151    stb   $01,s
         comb
         puls  pc,x,b,a

WCR0 lda V.TMP,u
         beq   L016E
         stx   [V.DMAADR,u]
L0160    lda   D.DMAReq Wait for other DMA to finish
         beq   L016C
         ldx   #1
         os9   F$Sleep
         bra   L0160

L016C    inc   D.DMAReq
L016E    lda   CURDRV,u
         bmi   L017E
         tst   <$22,y
         bpl   L017E
         tstb
         bmi   L017E
         ora   #$C0
L017E    tst   >u00BA,u
         bne   L0186
         ora   #$10  Write enable
L0186    sta   [>V.SEL,u]
         lda   >V.TMP,u
         tst   V.SIDE,u  Is it side 1?
         beq   L0196 .. no
         ora   #DMA.SD1   select side 1
L0196    ora   #DMA.INT   Enable interrupts
         sta   [V.DMACTL,u]
         tst   V.TMP,u
         beq   L01B2
         orb   V.EFLG,u
         clr   V.EFLG,u
         tst   V.SIDE,u
         beq   L01B2
         orb   #$02
L01B2    lda   V.BUSY,u
         sta   V.WAKE,u
         stb   [>V.CMDR,u]
L01BA    ldx   #$0032
         os9   F$Sleep
         tst   [>V.TRKR,u]
         lda   V.WAKE,u
         bne   L01BA
         lda   >V.FDSTA,u
         tst   <$22,y
         bpl   L01E2
         tstb
         bmi   L01E2
         lda   CURDRV,u
         sta   [V.SEL,u]
         bsr   DELAY
         lda   [V.CMDR,u]
L01E2    rts

DELAY ldb #$17
DELAY1 decb
 bne DELAY1
 rts

 pag
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
READSK lda #$91 Error retry code
 cmpx #0 Is this sector zero?
 bne RDDSK3 Branch if not
 lbra READ0 Do read of sector zero


RDDSK1 bcc RDDSK3 Retry without restore
 pshs D,X
 lbsr RESTOR Drive to tr00
 puls D,X
RDDSK3    pshs  x,b,a
         bsr   READSC
         bcc   L0221
         cmpb  #E$NotRdy
         lbeq  L0151
         puls  x,b,a
         lsra
         bne   RDDSK1
READSC    bsr   SEEK
         bcs   L01E2
         ldx   $08,y
         lda   #$10
         sta V.TMP,u
         ldb   #F.READ
         lbsr  WCR0
         lbra  READCK
L0221    leas  $04,s
         clrb
 rts
***************************************************************
*
* Seek A Track
*
* Input:
*   B = Msb Of Logical Sector Number
*   X = Lsb'S Of Logical Sector Number
*
* Output:
*   X = Physical Sector Number
*   A,B = Undefined
*
* Error:
*   Carry Set
*   B = Error Code
*
SEEK bsr SELECT Select drive
 bcs RETRN2 Drive out of range?
 bsr PHYSIC Convert to physical sect + track
 bcs RETRN2 Sector out of range?
 lbra SETTRK Set up for track change

 pag
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
 bhs ERUNIT
         clr   >V.DOSK,u
 pshs X,D Save regs
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
         cmpx  CURTBL,u
         beq   L0268
         com   V.DOSK,u
         stx   CURTBL,u
         clr   [V.SEL,u]
         lda   [V.TRKR,u]
         sta   [V.DATR,u]
         clra
         sta   V.TMP,u
         ldb   #$13
         lbsr  L0196
L0268    puls  a
         leax  <L0290,pcr
         ldb   PD.TYP,y
         andb  #$01
         beq   L0276
         ldb   #$C0
L0276    orb   a,x
         stb   [>V.SEL,u]
         stb   >CURDRV,u
         clr   >V.SIDE,u
         lda   #$20
         sta   >u00B9,u
         puls  pc,x,b


ERUNIT comb
 ldb #E$UNIT Error: illegal unit (drive)
RETRN2 rts

L0290    fcb   1,2,4,8

 pag
**************************************************************
*
* Convert Logical Sector Number
* To Physical Track And Sector
*
*  Input:  B = Msb Of Logical Sector Number
*          X = Lsb'S Of Logical Sector Number
*  Output: A = Physical Track Number
*          Sector Reg = Physical Sector Number
*  Error:  Carry Set & B = Error Code
*
PHYSIC tstb CHECK Sector bounds
 bne PHYERR  msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes; skip conversion.
 ldx CURTBL,U
 cmpd DD.TOT+1,X Too high sector number?
 bhs PHYERR ..yes; sorry
         subd  <$2B,y
         bcc   PHYSC1
         addd  <$2B,y
         bra   PHYSC7
PHYSC1    stb   >V.TMP,u
 clrb
 pshs B Will be track number
 ldb DD.FMT,X
 lsrb SHIFT Side bit to carry
 ldb V.TMP,U Restore (b)
         bcc   PHYSC4
PHYSC2    com   >V.SIDE,u
         bne   PHYSC3
         inc   ,s
PHYSC3 subb DD.TKS,X
 sbca #0
 bcc PHYSC2 Repeat until less than 1 trk
         bra   L02DB
PHYSC4    inc   ,s
 subb DD.TKS,X
 sbca #0
 bcc PHYSC4 Repeat until less than 1 trk
L02DB    lda   DD.FMT,X
         bita  #$02
         beq   L02E6
         clr   >u00B9,u
L02E6    puls  a
         addb  DD.TKS,x
PHYSC7    stb   [>V.SECR,u]
 clrb
 rts

PHYERR comb
 ldb #E$SECT Error: bad sector number
 rts
 pag

Settrk pshs a
         ldb   >u00B9,u
 orb CURDRV,U Mask into drive select
 stb CURDRV,U Save it
 stb [V.SEL,u]
 ldx CURTBL,U Point to drive table
 ldb V.TRAK,X Get old track
 pshs b
 ldb DD.Fmt,x
 lsrb
 eorb Pd.Dns,y
 bitb #%00000010 Drive and media same?
 beq Setrk3
 asla
 asl 0,s
Setrk3 puls b
 stb [V.TRKR,U] Put old track in trk reg
 ldb [V.CMDR,u]
 bpl SETRK6
 clr [V.SEL,u]
 ldb CURDRV,u
 stb [V.SEL,u]
 lbsr DELAY
 ldx #4000 Set delay
SETRK4 ldb [V.CMDR,u]
 bpl   SETRK6
 pshs x
 ldx #1 Give up timeslice
 os9 F$Sleep
 puls  x
 leax -1,x
 bne SETRK4
 leas 1,s
 bra ERNRDY
SETRK6 tst V.DOSK,u Force seek?
 bne SETRK8
 ldb 0,s Get true track number
 cmpb V.TRAK,X Same track?
 beq SETRK9
SETRK8 sta [V.DATR,u] Put new trk in data reg
 ldb PD.STP,y
 andb #$03
 eorb #F.SEEK
 clr V.TMP,u
 lbsr WCR0 Issue command
 lda #4
 sta V.EFLG,U
SETRK9 puls a
 ldx CURTBL,u
 sta V.Trak,x
 sta [V.Trkr,u] Put true track number everywhere
 clrb
 rts
 pag
***********************************************************
*
* Check Status For Error Conditions
*
*  Input: (B)= Status Of Fd1797
*
*  If Error: (B)= Error Code & Carry Is Set
*
*  If No Error: Carry Is Clear
*
STCK bita #%01000000 Write protected?
 bne WPERR
READCK bita #%00000100 Lost data?
 bne   RDWRER
 bita #%00001000 Check sum ok?
 bne ERRCRC
 bita #%00010000
 bne ERSEEK
 bita #%10000000 Drive ready?
 bne ERNRDY ..no; error
 clrb
 rts

ERRCRC comb
 ldb   #E$CRC Error: bad check sum
 rts

ERSEEK comb
 ldb #E$SEEK Error: seek error
 rts

RDWRER ldb V.TMP,u
 bitb  #%00100000  Write fault?
 bne RDERR
WRERR    comb
 ldb   #E$Write
 rts
RDERR    comb
 ldb   #E$Read
 rts
ERNRDY    comb
 ldb   #E$NotRdy
WRERR9 rts

WPERR comb
 ldb #E$WP
 rts
 pag
****************************************************************
*
* Read Logical Sector Zero
*
*
*
READ0 lbsr RDDSK3 Read sector
 bcs WRERR9
 ldx PD.BUF,Y
 pshs X,Y
 tst V.Frez,u Skip copy of dd. info?
 bne Read03 Yes; ....make quick exit
 ldy CURTBL,U
 ldb #DD.SIZ-1
READ01 lda B,X
 sta B,Y
 decb
 bpl READ01
 lda DD.FMT,Y
 ldy 2,S Restore (y)
 ldb Pd.Dns,y Get drive capabilities
 bita #%00000010 Media dden?
 beq   L03EB
 bitb #%00000001 Drive dden?
 beq TYPERR
L03EB bita #%00000100 Media dbl track dens?
 beq Read03
 bitb #%00000010 Drive dbl track dens?
 beq Typerr No; .....incompatible media
Read03 bita #%00000001 Dbl sided?
 beq READ05 ...no; we can handle it.
 lda PD.SID,Y
 suba #2
 bcs TYPERR
READ05 clr V.FREZ,u
 clrb
 puls X,Y,PC

TYPERR comb
 ldb #E$BTYP
 puls X,Y,PC

WRTTRK lbsr SELECT
 bcs WRERR9 Error; report it
 lda R$U+1,X Track number
 ldb R$Y+1,X Side/density info
 ldx Curtbl,u Point to drive table
 stb DD.Fmt,x Update media format byte
 bitb #%00000001 Side zero?
 beq WRTRK2 ..yes; skip side change
 com V.SIDE,U
WRTRK2    bitb  #$02
         beq   L042A
         clr   >u00B9,u
L042A    lbsr  SETTRK
 ldx PD.RGS,Y
 ldx R$X,X Get buffer addr
         ldb   #F.WRTR
         lda   #$30
         sta   V.TMP,u
         lbsr  WCR0
         ldb   [V.SEL,u]
         bitb  #DMA.FLT
         beq   L0446
         lda   #%10000000 Set drive ready status
L0446    lbra  STCK Check status
 pag
*********************************************
*
* Write Verify Routine
*
*
*    Reads back the sector just written
*    Returns carry set if bad sector
*    Compares 'read' data to 'write' data
*    Returns carry set if no compare
*  Note: Only the first 128 bytes are compared
*        assuming that any other error will cause
*        a bad Crc.

WRTVFY pshs D,X
 ldx PD.BUF,Y Save present buffer addr
 pshs X On stack
 ldx V.BUF,U Point to local buffer
 stx PD.BUF,Y
 ldx 4,S Restore (x)
 lbsr READSK
 puls X
 stx PD.BUF,Y Restore buffer pointer
 bcs WRTVF6 Error; ...try again
 pshs  u,y
 ldy V.BUF,u Point "y" to local buffer
 tfr x,u
 clra
 ldb   #$80
 leay  d,y
 leau  d,u Bump both pointers
WRTCHK ldx a,y Get two bytes
 cmpx  a,u Check with 'read data'
 bne   WRTVF2
 suba  #2
 bne WRTCHK No; ....keep checking
 bra WRTVF4
WRTVF2 orcc #%00000001 Set carry
WRTVF4 puls  u,y
WRTVF6 puls  pc,x,d
 pag
**************************************
*
* Terminate use of the disk
*
*
*    Return Local memory to the system
*
*

Termnt clr [V.DMACTL,u]
 ldx   #0
 os9   F$IRQ
 ldu V.BUF,u
 ldd #256
 OS9 F$SRtMem Return local buffer to free mem
 rts
 emod

DSKEND equ *

 end
