 nam   DDisk
***********************************************
*
* Original edition from Dragon Data OS-9 system disk
*
* Header for : DDisk
* Module size: $31C  #796
* Module CRC : $E01A55 (Good)
* Hdr parity : $C4
* Exec. off  : $0014  #20
* Data size  : $00AF  #175
* Edition    : $02  #2
* Ty/La At/Rv: $E1 $81
* Device Driver mod, 6809 Obj, re-ent, R/O

* Known bugs: Unable to use two-sided disks

 use   defsfile

 ttl   Driver Module
 pag
*******************************************************************
*
*                Microware Systems Corporation
*
*******************************************************************

NMIVec equ $109
DriveCnt equ 4

P1PDRB equ $FF22
P1PCRB equ $FF23
P0PCRB equ $FF03
ACIAStat equ $FF05
ACIACmnd equ $FF06

* Disk port locations
V.SEL equ    $FF48 Drive select reg addr.
V.CMDR equ   $FF40
V.TRKR equ   $FF41
V.SECR equ   $FF42
V.DATR equ   $FF43

***************************************************************
*
* Disk Driver Module Header
*
*
 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+1,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
DSKNAM fcs "DDisk"

 fcb 2 Edition telltale byte
*******************
* Revision History
* edition 2: prehistoric

 pag
*********************************************************************
*
* Static Storage
*
*
 org Drvbeg
 rmb Drvmem*DriveCnt

CURTBL rmb 2 Ptr to current drive tbl
CURDRV rmb 1
V.DOSK rmb 1
V.PIA rmb 1
V.ACIA rmb 1
V.BUF rmb 2 Local buffer addr
DSKSTA equ . Total static requirement



******************************************************************
*
* Branch Table
*
DSKENT lbra INIDSK Initialize i/o
 lbra READSK Read sector
 lbra WRTDSK Write sector
 lbra GETSTA Get status call
 lbra PUTSTA
 lbra TERMNT Terminate device use

*
* WD2797 Commands
*
F.REST equ $00
F.SEEK equ $10
F.STPI equ $40
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F0 Write track command
SID2 equ $2

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
INIDSK clra
 sta >D.DskTmr
 sta >V.SEL
 ldx #V.CMDR
 lda #F.TYP1
 sta 0,x Send to command register
 lbsr DELAY1
 lda 0,x
 lda #$FF
 ldb #DriveCnt
 leax DRVBEG,U Point to first drive table
INILUP sta 0,x
 sta V.TRAK,X Inz to high track count
 leax DRVMEM,X Point to next drive table
 decb DONE
 bne INILUP ...no; inz more.
 leax >NMISVC,pcr
 stx >NMIVec+1
 lda #$7E Store JMP command
 sta >NMIVec
 ldd #256 "d" passes memory req size
 pshs U Save "u" we need it later
 OS9 F$SRqMem Request 1 pag of mem
 tfr U,X
 puls U
 bcs RETRN1 ..oh ..oh; no mem available
 stx V.BUF,U Save for future use
 clrb
RETRN1 rts

TERMNT
GETSTA clrb
 rts
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
 bsr RDDSK3
 bcs WRERR9
 ldx PD.BUF,Y Point to buffer
 pshs X,Y
 ldy CURTBL,u
 ldb #DD.SIZ-1
READ01 lda B,X
 sta B,Y
 decb
 bpl READ01
 clrb
 puls pc,y,x

WRERR9 rts

RDDSK1 bcc RDDSK3 Retry without restore
 pshs D,X
 lbsr RESTOR Drive to tr00
 puls D,X
RDDSK3 pshs D,X
 bsr READSC Read sector
 puls D,X
 bcc WRERR9 Return if no error
 lsra DONE?
 bne RDDSK1 ...no; retry.
*
* Fall Through To Try One Last Time
*
READSC lbsr SEEK Move head to track
 bcs WRERR9
 ldx PD.BUF,Y Point to buffer
 pshs y,dp,cc
 ldb #F.READ Read sector command
 bsr READS3
READS1 lda <P1PCRB
 bmi READS2
 leay -$01,y
 bne   READS1
         bsr   RECPER
 puls  y,dp,cc
 lbra  RDERR
SYNCWAIT sync
READS2 lda <V.DATR
 ldb <P1PDRB
 sta ,X+ Store it
 bra SYNCWAIT
READS3 lda #$FF
 tfr a,dp Set DP to $FF
 lda <ACIACmnd
 sta >V.ACIA,u
 anda #$FE
 sta <ACIACmnd
 bita  #%01000000
 beq   READS5
READS4 lda <ACIAStat
 bita  #%00010000 Transmit register empty?
 beq READS4
READS5 orcc #IRQMask+FIRQMask Disable interrupts
 lda <P0PCRB
 sta >V.PIA,u
 lda #$34
 sta <P0PCRB
 lda <ACIACmnd
 anda #$FE
 sta <ACIACmnd
 lda <P1PCRB
 ora #$03
 sta <P1PCRB
 lda <P1PDRB
 ldy #$FFFF
 lda #$24 Enable NMI and motor on
 ora >CURDRV,u
 stb <V.CMDR
 sta <V.SEL
 rts

RECPER lda >CURDRV,u
 ora #$04   motor on
 sta <V.SEL
 lda >V.PIA,u
 sta <P0PCRB
 lda <P1PCRB
 anda #$FC
 sta <P1PCRB
 lda >V.ACIA,u
 sta <ACIACmnd
 rts


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
WRTDS1 pshs D,X Save regs
 bsr WRITSC Write sector
 puls D,X Restore regs
 bcs WRTDS3 Write error; try again.
 tst PD.VFY,Y Verify desired?
 bne WRTDS2 ...no; all is well.
 lbsr Wrtvfy Go verify sector
 bcs WRTDS3 ...verify failed
WRTDS2 clrb
 rts

WRTDS3 lsra
 lbeq Wrerr Retries done; ...exit
 bcc WRTDS1 Retry without restore
 pshs D,X
 lbsr  RESTOR Restore drive
 puls D,X
 bra WRTDS1 Retry after restore



WRITSC lbsr SEEK
 lbcs WRERR9
 ldx PD.BUF,Y Buffer addr
 pshs y,dp,cc
 ldb #F.WRIT Write function code
WRITS1 lbsr READS3
 lda ,x+
WRITS2 ldb <P1PCRB
 bmi WRITS4
 leay -1,y
 bne WRITS2
 bsr RECPER
 puls y,dp,cc
 lbra WRERR
WRITS3 lda ,x+
 sync
WRITS4 sta <V.DATR
 ldb <P1PDRB
 bra WRITS3

NMISVC leas R$Size,s
 bsr RECPER
 puls y,dp,cc
 ldb >V.CMDR
 bitb #$04
 lbne RDERR
 lbra STCK

*********************************************
*
* Write Verify Routine
*
*
*    Reads back the sector just written
*    Returns carry set if bad sector
*    Compares 'read' data to 'write' data
*    Returns carry set if no compare
*  Note: Only 2 bytes out of every 8 is compared
*        assuming that any other error will cause
*        a bad Crc.

WRTVFY pshs D,X
 ldx PD.BUF,Y Save present buffer addr
 pshs X On stack
 ldx V.BUF,U Point to local buffer
 stx PD.BUF,Y
 ldx 4,S Restore (x)
 lbsr READSC
 puls X
 stx PD.BUF,Y Restore buffer pointer
 bcs WRTVF6 Error; ...try again
 lda #32 Test 32 places in buffer
 pshs a,y,u
 ldy V.BUF,u Point "y" to local buffer
 tfr x,u
WRTCHK ldx 0,u Get two bytes
 cmpx 0,y Check with 'read data'
 bne WRTVF2 Error; ...return carry set
 leau 8,u
 leay 8,y Bump both pointers
 dec 0,s Done yet?
 bne WRTCHK No; ....keep checking
 bra WRTVF4
WRTVF2 orcc #%00000001 Set carry
WRTVF4 puls a,y,u
WRTVF6 puls d,x,pc
 pag
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
SEEK clr >V.DOSK,u
 bsr SELECT Select drive
 tstb CHECK Sector bounds
 bne PHYERR  msb must be zero
 tfr X,D Logical sector (os-9)
 ldx CURTBL,u
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes; skip conversion.
 cmpd DD.TOT+1,X Too high sector number?
 bcs PHYSC1 ..no
PHYERR comb
 ldb #E$SECT Error: bad sector number
 rts

PHYSC1 clr ,-s
 bra PHYSC5
PHYSC2 inc 0,S
PHYSC5 subd #18 Subtract one track worth of sectors
 bcc PHYSC2 Repeat until less than 1 track size
 addb #18 Add back for sector number
 puls A Desired track.
 cmpa  #$10
 bls PHYSC7
 pshs a
 lda >CURDRV,u
 ora #$10 wpc enable
 sta >CURDRV,u
 puls a
PHYSC7 incb
 stb V.SECR Put sector (b) in sector reg
SETRK3 ldb <V.Trak,x
 stb >V.TRKR
 tst V.DOSK,U Force seek?
 bne SETRK4 ..yes; do it.
 cmpa V.TRAK,X Same track?
 beq SETRK9 ..yes; skip seek.
SETRK4 sta V.Trak,x
 sta >V.DATR Put new trk in data reg
 ldb #F.SEEK+SID2 Command
 bsr WCR0 Issue command
 pshs x
 ldx #$222E  delay loop
SETRK8 leax -1,x
 bne SETRK8
 puls  x
SETRK9 clrb
 rts

SELECT lbsr STARTMOT
 lda PD.DRV,Y Get drive number
 cmpa  #4 Drive num ok?
 bcs SELCT3 ..yes
 comb
 ldb #E$UNIT Error: illegal unit (drive)
 rts

SELCT3 pshs X,D
 sta CURDRV,U
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
 cmpx CURTBL,U New device call?
 beq SELCT5 ...no; don't force seek
 stx CURTBL,U Current table ptr
 com V.DOSK,U Set force seek flag
SELCT5 puls pc,x,b,a

STCK bitb #%11111000 Any error codes set?
 beq NOERR
 bitb #%10000000 Drive ready?
 bne ERNRDY ..no; error
 bitb #%01000000 Write protected?
 bne WPERR ..yes; return error
 bitb  #%00100000 Head loaded?
 bne WRERR ..yes; return error.
 bitb #%00010000 Seek error?
 bne ERSEEK ..yes; return error
 bitb #%00001000 Check sum ok?
 bne ERRCRC ..no; return error
NOERR clrb
 rts


ERNRDY comb
 ldb #E$NotRdy Error: drive not ready
 rts

WPERR comb
 ldb #E$WP
 rts
WRERR    comb
 ldb #E$Write
 rts
ERSEEK comb
 ldb #E$SEEK Error: seek error
 rts

ERRCRC comb
 ldb #E$CRC Error: bad check sum
 rts

RDERR comb
 ldb #E$Read
 rts

WCR0 bsr DELAY
WCR02 ldb   >V.CMDR
 bitb #%00000001 Busy?
 beq DELAY4 ..yes; wait for it.
 lda #$F0
 sta >D.DskTmr
 bra WCR02
WCR lda #$04  motor on
 ora >CURDRV,u
 sta >V.SEL
 stb >V.CMDR
 rts
DELAY bsr WCR
DELAY1 lbsr DELAY2
DELAY2 lbsr DELAY4
DELAY4 rts

 pag
************************************************************
*
* Put Status Call
*
*
*
PUTSTA ldx PD.RGS,Y Point to parameters
 ldb R$B,X Get stat call
 cmpb #SS.Reset Restore call?
 beq RESTOR ..yes; do it.
 cmpb #SS.WTrk Write track call?
 beq WRTTRK ..yes; do it.
 comb ...NO; Error
 ldb #E$UnkSvc Error code
RETRN2    rts


*****************************************************************
*
* Write Full Track
*  Input: (A)=Track
*         (Y)=Path Descriptor
*         (U)=Global Storage
*
WRTTRK lbsr SELECT Select drive
 lda R$U+1,X Track number
 cmpa #$10
 bls WRTRK2
 ldb CURDRV,u
 orb #$10  wpc enable
 stb CURDRV,u
WRTRK2 ldx Curtbl,u Point to drive table
 lbsr SETRK3
 bcs RETRN2
 ldx PD.RGS,Y
 ldx R$X,X Get buffer addr
 ldb #F.WRTR
 pshs y,dp,cc
 lbra WRITS1
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
 ldx CURTBL,U
 clr V.TRAK,X Old track = 0
 lda #5 Repeat five times
RESTR2 ldb #F.STPI+SID2
 pshs A
 lbsr WCR0 Issue command, delay & wait for done.
 puls A
 deca DONE Stepping?
 bne RESTR2 ...no; step again.
 ldb #F.REST+SID2 Restore command
 bra WCR0

* Start Drive Motors and wait for them if necessary
STARTMOT pshs  X,D
 lda >D.DskTmr
 bne START10
 lda #$04
 sta >V.SEL
 ldx #$A000
WAITLOOP nop
 nop
 leax  -$01,x
 bne WAITLOOP
START10 lda #$F0
 sta >D.DskTmr
 puls pc,X,D

 emod

DSKEND equ *

 end
