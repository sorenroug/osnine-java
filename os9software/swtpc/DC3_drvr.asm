 opt l
 nam Swtpc DC-3 disk driver source

 opt -c

 use defsfile

 ttl Driver Module
 pag
*******************************************************************
*
*                Microware Systems Corporation
*
*
*       OS-9 MF-68 Floppy Disk Driver Module Source Code
*
*           Software For Swtpc DC-3 Disk Controller
*
*                        Revised By
*                     William G. Phelps
*
*
*       This Controller Uses The FD1771 LSI Disk Controller
*
**********************************************************************






***************************************************************
*
* Disk Driver Module Header
*
*
 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+1,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
DSKNAM fcs "DC3"

 fcb 5 Edition telltale byte
*******************
* Revision History
* edition 4: prehistoric
* edition 5: all use statements converted to use defsfile
*            copyright removed from object file
*******************

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
V.SEL rmb 2 Drive select reg addr.
V.CMDR rmb 2
V.TRKR rmb 2
V.SECR rmb 2
V.DATR rmb 2
V.EFLG rmb 1 Set "e" for head settle time
V.SIDE rmb 1 Current side; 0:=side 0
V.TMP rmb 1 Temporary save byte
V.DOSK rmb 1 Force seek flag
V.BUF rmb 2 Local buffer addr
V.FREZ rmb 1 Freeze dd. info (for one read0)
DSKSTA equ . Total static requirement



******************************************************************
*
* Branch Table
*
DSKENT lbra INIDSK Initialize i/o
 lbra READSK Read sector
 lbra WRTDSK Write sector
 lbra Getsta Get status call
 lbra PUTSTA
 lbra Termnt Terminate device use



*
* Fd1771 Commands
*
F.REST equ $0B Restore command
F.SEEK equ $1B Seek command
F.STPI equ $4B Step in one track command
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F4 Write track command
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
 stx V.SEL,U Address of drive select reg.
 leax 4,X Address of command register
 stx V.CMDR,U
 leax 1,X Address of track register
 stx V.TRKR,U
 leax 1,X Address of sector register
 stx V.SECR,U
 leax 1,X Address of data register
 stx V.DATR,U
 lda #$FF
 ldb #DriveCnt
 stb V.NDRV,U Inz number of drives
 leax DRVBEG,U Point to first drive table
INILUP sta DD.TOT+2,X Inz to non-zero
 sta V.TRAK,X Inz to high track count
 leax DRVMEM,X Point to next drive table
 decb DONE
 bne INILUP ...no; inz more.
 ldd #256 "d" passes memory req size
 pshs U Save "u" we need it later
 OS9 F$SRqMem Request 1 pag of mem
 tfr U,X
 puls U
 bcs RETRN1 ..oh ..oh; no mem available
 stx V.BUF,U Save for future use
 clrb
RETRN1 rts
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
RESTR2 ldb #F.STPI Step in command
 pshs A
 lbsr WCR0 Issue command, delay & wait for done.
 puls A
 deca DONE Stepping?
 bne RESTR2 ...no; step again.
 ldb #F.REST Restore command
 lbra WCR0
 pag
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
 bne RETRN1 ...no; all is well.
 lbsr Wrtvfy Go verify sector
 bcc Wrerr9 All clear; ....return
WRTDS3 lsra
 beq Wrerr Retries done; ...exit
 bcc WRTDS1 Retry without restore
 pshs D,X
 bsr RESTOR Restore drive
 puls D,X
 bra WRTDS1 Retry after restore



WRITSC lbsr SEEK
 bcs WRERR9
 ldb #F.WRIT Write function code
 ldx PD.BUF,Y Buffer addr
WRITS1 pshs CC Save irq mask info
 orcc #IRQMask+FIRQMask Disable interrupts
 lbsr WCR
 pshs Y,U Save regs
 ldy V.CMDR,U
 ldu V.DATR,U
 bra WRITE3
 pag
**************************************************************
*
* Write Loop
*
WRITE2 sta ,U Write it
WRITE3 lda ,X+ Get data
WRITE4 ldb ,Y Get status
 bitb #%00000010 Data req?
 bne WRITE2 ..yes; honor it
 bitb #%00000001 Done?
 bne WRITE4 ...no; test again.


 puls Y,U
 puls CC Restore irq mask info
 bitb #%01000000 Write protected?
 bne WPERR ..yes; return error
 bitb #%00000100 Lost data?
 bne WRERR ..yes; return error.
 lbra STCK


WPERR comb
 ldb #E$WP
 rts
WRERR comb
 ldb #E$Write
WRERR9 rts





*****************************************************************
*
* Write Full Track
*  Input: (A)=Track
*         (Y)=Path Descriptor
*         (U)=Global Storage
*
WRTTRK bsr SELECT Select drive
 bcs WRERR9 Error; report it
 lda R$U+1,X Track number
 ldb R$Y+1,X Side/density info
 ldx Curtbl,u Point to drive table
 stb DD.Fmt,x Update media format byte
 bitb #%00000001 Side zero?
 beq WRTRK2 ..yes; skip side change
 com V.SIDE,U
WRTRK2 lbsr SEEKTR Seek to track
 ldb #F.WRTR
 ldx PD.RGS,Y
 ldx R$X,X Get buffer addr
 clr V.Eflg,u
 bra WRITS1
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
RDDSK3 pshs D,X
 bsr READSC Read sector
 puls D,X
 bcc WRERR9 Return if no error
 lsra DONE?
 bne RDDSK1 ...no; retry.
*
* Fall Through To Try One Last Time
*
READSC bsr SEEK Move head to track
 bcs WRERR9
 ldx PD.BUF,Y Point to buffer
 pshs CC Save irq mask info
 orcc #IRQMask+FIRQMask Disable interrupts
 ldb #F.READ Read sector command
 lbsr WCR Issue command
 pshs Y,U Save regs
 ldy V.CMDR,U
 ldu V.DATR,U
 bra READS3
 pag
************************************************************
*
* Read Loop
*
READS2 lda ,U Get data
 sta ,X+ Store it
READS3 ldb ,Y Get status
 bitb #%00000010 Data req?
 bne READS2 ..yes; honor it.
 bitb #%00000001 Done?
 bne READS3 ...no; try again.


 puls Y,U Restore regs
 puls CC Restore irq mask info
 bitb #%00000100 Lost data?
 bne RDERR ..yes; return it.
 lbra STCK



RDERR comb
 ldb #E$Read
 rts
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
 bhs ERUNIT ..no; report error.
 clr V.DOSK,U Default to poss skip seek
 pshs B,X Save regs
 sta CURDRV,U
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
 cmpx CURTBL,U New device call?
 beq SELCT5 ...no; don't force seek
 com V.DOSK,U Set force seek flag
 stx CURTBL,U Current table ptr
SELCT5 clr V.SIDE,U Default to side zero
 puls B,X,PC Return (carry clear)


ERUNIT comb
 ldb #E$UNIT Error: illegal unit (drive)
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
SEEKTR bra SETTRK Set up for track change
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
 stb V.TMP,U Save (b)
 clrb
 pshs B Will be track number
 ldb DD.FMT,X
 lsrb SHIFT Side bit to carry
 ldb V.TMP,U Restore (b)
 bcs PHYSC4 Bra if double sided
 dec 0,S
PHYSC2 inc 0,S
 subb DD.TKS,X Subtract one track worth of sectors
 sbca #0
 bcc PHYSC2 Repeat until less than 1 track size
 bra PHYSC5
PHYSC3 com V.SIDE,U Switch sides
 bne PHYSC4 Skip track inc if side 1
 inc 0,S
PHYSC4 subb DD.TKS,X
 sbca #0
 bcc PHYSC3 Repeat until less than 1 trk
PHYSC5 addb DD.TKS,X Add back for sector number
 puls A Desired track.
PHYSC7 stb [V.SECR,U] Put sector (b) in sector reg
 clrb
RETRN2 rts


PHYERR comb
 ldb #E$SECT Error: bad sector number
 rts
 pag
**************************************************************
*
* Move Head To New Track
*
* Update Track Table With
* The Current Track
*
* Load The Track Register With The
* Old Track
*
* Input:
*   A = New Track
*   B = Seek Function Code (F.Seek)
* Output:
*   B = Contents Of Fd1771 Status Reg
*   A,X = Destroyed
*
Settrk pshs a
 ldb V.SIDE,U Get side info
 andb #%01000000 Mask all but needed bit
 orb CURDRV,U Mask into drive select
 stb CURDRV,U Save it
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
 ldb #F.TYP1
 pshs A Save track
 lbsr WCR Put it in 1771 and delay
 lda [V.CMDR,U] Get type 1 status
 bita #%00100000 Is head loaded?
 puls A
 beq SETRK4 ...no;don't skip the seek
 tst V.DOSK,U Force seek?
 bne SETRK4 ..yes; do it.
 ldb 0,s Get true track number
 cmpb V.TRAK,X Same track?
 beq SETRK9 ..yes; skip seek.
SETRK4 sta [V.DATR,U] Put new trk in data reg
 ldb #F.SEEK Command
 bsr WCR0 Issue command
 lda #4
 sta V.EFLG,U
Setrk9 puls a
 ldx Curtbl,u
 sta V.Trak,x
 sta [V.Trkr,u] Put true track number everywhere
 clrb
 rts
 pag
***********************************************************
*
* Check Status For Error Conditions
*
*  Input: (B)= Status Of Fd1771
*
*  If Error: (B)= Error Code & Carry Is Set
*
*  If No Error: Carry Is Clear
*
STCK bitb #%10000000 Drive ready?
 bne ERNRDY ..no; error
 bitb #%00010000 Seek error?
 bne ERSEEK ..yes; return error
 bitb #%00001000 Check sum ok?
 bne ERRCRC ..no; return error
 clrb
 rts



ERNRDY comb
 ldb #E$NotRdy Error: drive not ready
 rts

ERSEEK comb
 ldb #E$SEEK Error: seek error
 rts

ERRCRC comb
 ldb #E$CRC Error: bad check sum
 rts
 pag
****************************************************************
*
* Read Logical Sector Zero
*
*
*
READ0 lbsr RDDSK3 Read sector
 bcs DELAY4
 ldx PD.BUF,Y
 pshs X,Y
 tst V.Frez,u Skip copy of dd. info?
 bne Read05 Yes; ....make quick exit
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
 bne TYPERR ..yes; report error.
 bitb #%00000001 Drive dden?
 bne Typerr Yes; ....no can do.
 bita #%00000100 Media dbl track dens?
 beq Read03 No; ....all's well
 bitb #%00000010 Drive dbl track dens?
 beq Typerr No; .....incompatible media
Read03 bita #%00000001 Dbl sided?
 beq READ05 ...no; we can handle it.
 lda PD.SID,Y
 suba #2
 bcs TYPERR
READ05 clrb
 puls X,Y,PC


TYPERR comb
 ldb #E$BTYP
 puls X,Y,PC
 pag
****************************************************************
*
*
* Write Command Register
*
*
*   1 - Will Add Step Rate To Seek Commands When Wcr0 Called
*   2 - Issues Command To Controller Chip
*   3 - Will Wait For Status "Not Busy" If Wcr0 Called
*
*
WCR0 eorb PD.STP,Y Add step rate to command

 bsr WCR Issue command & delay
WCR02 ldb [V.CMDR,U] Get status
 bitb #%00000001 Busy?
 bne WCR02 ..yes; wait for it.
 rts



WCR lda CURDRV,U
 sta [V.SEL,U] Select drive
 orb V.EFLG,U
 clr V.EFLG,U
 stb [V.CMDR,U] Issue command


DELAY bsr DELAY1
DELAY1 bsr DELAY2
DELAY2 bsr DELAY4
DELAY4 nop
 rts
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
*  Note: Only 2 bytes out of every 8 is compared
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
**************************************
*
* Terminate use of the disk
*
*
*    Return Local memory to the system
*
*

TERMNT ldu V.BUF,u Point to memory for return
 ldd #256
 OS9 F$SRtMem Return local buffer to free mem
 clrb
 rts


 emod

DSKEND equ *

 end
