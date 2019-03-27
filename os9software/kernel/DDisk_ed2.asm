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

         nam   DDisk
         TTL   Dragon Disk Driver

         ifp1
         use   defsfile
         endc

NMIVec   EQU   $109
DriveCnt  EQU   4
DensMask EQU   %00000001
T80Mask  EQU   %00000010

P1PDRB   EQU   $FF22
P1PCRB   EQU   $FF23
P0PCRB   EQU   $FF03
ACIAStat EQU   $FF05
ACIACmnd EQU   $FF06

* SelReg Masks
NMIEn    EQU   %00100000
WPCEn    EQU   %00010000
MotorOn  EQU   %00000100
SDensEn  EQU   %00001000

* Disk port locations
SelReg   EQU   $FF48
CmndReg  EQU   $FF40
TrkReg   EQU   $FF41
SecReg   EQU   $FF42
DataReg  EQU   $FF43

*
* WD2797 Commands
*
F.REST EQU   %00000010
F.STPI EQU   %01000010
F.SEEK EQU   %00010010
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
Sid2Sel  EQU   %00000010
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F0 Write track command

* Disk Status Bits
BusyMask EQU   %00000001
LostMask EQU   %00000100
ErrMask  EQU   %11111000
CRCMask  EQU   %00001000
RNFMask  EQU   %00010000
RTypMask EQU   %00100000
WPMask   EQU   %01000000
NotRMask EQU   %10000000

***************************************************************
*
* Disk Driver Module Header
*
*
 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+1,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.

 pag
*********************************************************************
*
* Static Storage
*
*
 org Drvbeg
 rmb Drvmem*DriveCnt

CURTBL rmb 2 Ptr to current drive tbl
CURDRV    rmb   1
V.DOSK    rmb   1
u00AB    rmb   1
u00AC    rmb   1
V.BUF rmb 2 Local buffer addr
DSKSTA equ . Total static requirement


DSKNAM fcs "DDisk"
 fcb 2 Edition telltale byte


******************************************************************
*
* Branch Table
*
DSKENT lbra INIDSK Initialize i/o
 lbra READSK Read sector
 lbra WRTDSK Write sector
 lbra  NoErr
 lbra  PUTSTA
 lbra  NoErr


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
INIDSK    clra
         sta   >D.DskTmr
         sta   >SelReg
         ldx   #CmndReg
         lda   #F.TYP1
         sta   ,x
         lbsr  L02A3
         lda   ,x
         lda   #$FF
 ldb #DriveCnt
 leax DRVBEG,U Point to first drive table
INILUP    sta   ,x
 sta V.TRAK,X Inz to high track count
 leax DRVMEM,X Point to next drive table
 decb DONE
 bne INILUP ...no; inz more.
         leax  >NMISVC,pcr
         stx   >NMIVec+1
         lda   #$7E
         sta   >NMIVec
 ldd #256 "d" passes memory req size
 pshs U Save "u" we need it later
 OS9 F$SRqMem Request 1 pag of mem
 tfr U,X
 puls U
 bcs RETRN1 ..oh ..oh; no mem available
 stx V.BUF,U Save for future use
 clrb
RETRN1 rts

NoErr    clrb
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
         bsr   RDDSK3
         bcs   WRERR9
 ldx PD.BUF,Y Point to buffer
         pshs  y,x
         ldy   >CURTBL,u
         ldb   #$14
L0082    lda   b,x
         sta   b,y
         decb
         bpl   L0082
         clrb
         puls  pc,y,x
WRERR9    rts

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
         pshs  y,dp,cc
 ldb #F.READ Read sector command
         bsr   L00C6
L00AE    lda   <$23
         bmi   L00BE
         leay  -$01,y
         bne   L00AE
         bsr   L0107
         puls  y,dp,cc
         lbra  RDERR
L00BD    sync
L00BE    lda   <$43
         ldb   <$22
         sta   ,x+
         bra   L00BD
L00C6    lda   #$FF
         tfr   a,dp
         lda   <$06
         sta   >u00AC,u
         anda  #$FE
         sta   <$06
         bita  #$40
         beq   L00DE
L00D8    lda   <$05
         bita  #$10
         beq   L00D8
L00DE    orcc #IRQMask+FIRQMask Disable interrupts
         lda   <$03
         sta   >u00AB,u
         lda   #$34
         sta   <$03
         lda   <$06
         anda  #$FE
         sta   <$06
         lda   <$23
         ora   #$03
         sta   <$23
         lda   <$22
         ldy   #$FFFF
         lda   #$24
         ora   >CURDRV,u
         stb   <CmndReg
         sta   <$48
         rts
L0107    lda   >CURDRV,u
         ora   #$04
         sta   <$48
         lda   >u00AB,u
         sta   <$03
         lda   <$23
         anda  #$FC
         sta   <$23
         lda   >u00AC,u
         sta   <$06
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
L0155    lbsr  L00C6
         lda   ,x+
L015A    ldb   <$23
         bmi   L016C
         leay  -$01,y
         bne   L015A
         bsr   L0107
         puls  y,dp,cc
         lbra  WRERR
L0169    lda   ,x+
         sync
L016C    sta   <$43
         ldb   <$22
         bra   L0169

NMISVC    leas  $0C,s
         bsr   L0107
         puls  y,dp,cc
         ldb   >CmndReg
         bitb  #$04
         lbne  RDERR
         lbra  L0252
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
         beq   L01FB
         cmpd  $01,x
         bcs   L01DA
PHYERR comb
 ldb #E$SECT Error: bad sector number
 rts

L01DA    clr   ,-s
         bra   L01E0
PHYSC2 inc 0,S
L01E0 subd #18 Subtract one track worth of sectors
 bcc PHYSC2 Repeat until less than 1 track size
         addb  #18  Add back for sector number
 puls A Desired track.
         cmpa  #$10
         bls   L01FB
         pshs  a
         lda   >CURDRV,u
         ora   #$10
         sta   >CURDRV,u
         puls  a
L01FB    incb
         stb   >SecReg
L01FF    ldb   <$15,x
         stb   >TrkReg
         tst   >V.DOSK,u
         bne   L0210
         cmpa  <$15,x
         beq   L0225
L0210    sta   <$15,x
         sta   >DataReg
         ldb   #F.SEEK
         bsr   WCR0
         pshs  x
         ldx   #$222E
L021F    leax  -$01,x
         bne   L021F
         puls  x
L0225    clrb
         rts

SELECT    lbsr  L02FD
         lda   <$21,y
         cmpa  #$04
         bcs   L0235
         comb
         ldb   #$F0
         rts
L0235    pshs  x,b,a
 sta CURDRV,U
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
 cmpx CURTBL,U New device call?
         beq   SELCT5
 stx CURTBL,U Current table ptr
         com   >V.DOSK,u
SELCT5 puls pc,x,b,a

L0252    bitb  #$F8
         beq   L026A
         bitb  #$80
         bne   ERNRDY
         bitb  #$40
         bne   WPERR
         bitb  #$20
         bne   WRERR
 bitb #%00010000 Seek error?
 bne ERSEEK ..yes; return error
 bitb #%00001000 Check sum ok?
 bne ERRCRC ..no; return error
L026A    clrb
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

WCR0    bsr   L02A1
L0286    ldb   >CmndReg
         bitb  #$01
         beq   DELAY4
         lda   #$F0
         sta   >D.DskTmr
         bra   L0286
L0294    lda   #$04
         ora   >CURDRV,u
         sta   >SelReg
         stb   >CmndReg
         rts
L02A1    bsr   L0294
L02A3    lbsr  L02A6
L02A6    lbsr  DELAY4
DELAY4    rts

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
L02B9    rts


*****************************************************************
*
* Write Full Track
*  Input: (A)=Track
*         (Y)=Path Descriptor
*         (U)=Global Storage
*
WRTTRK lbsr SELECT Select drive
         lda   $09,x
         cmpa  #$10
         bls   L02CD
         ldb   >CURDRV,u
         orb   #$10
         stb   >CURDRV,u
L02CD    ldx   >CURTBL,u
         lbsr  L01FF
         bcs   L02B9
 ldx PD.RGS,Y
 ldx R$X,X Get buffer addr
 ldb #F.WRTR
         pshs  y,dp,cc
         lbra  L0155
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
RESTR2 ldb #F.STPI
 pshs A
 lbsr WCR0 Issue command, delay & wait for done.
 puls A
 deca DONE Stepping?
 bne RESTR2 ...no; step again.
 ldb #F.REST Restore command
 bra WCR0

* Start Drive Motors and wait for them if necessary
L02FD    pshs  x,b,a
         lda   >D.DskTmr
         bne   L0312
         lda   #$04
         sta   >SelReg
         ldx   #$A000
L030C    nop
         nop
         leax  -$01,x
         bne   L030C
L0312    lda   #$F0
         sta   >D.DskTmr
         puls  pc,x,b,a

 emod

DSKEND equ *

 end
