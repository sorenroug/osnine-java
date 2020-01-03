 opt l
 nam PT FD-2 disk driver source

 opt -c
 use defsfile

************************************************************************
*
*
*           OS-9 FD-2 FLOPPY DISK DRIVER MODULE SOURCE CODE
*
*        SOFTWARE FOR PERIPHERAL TECHNOLOGY FD-2 DISK CONTROLLER
*
*
*                     LAST REVISION BY
*                     FREDERIC C. BROWN
*
*                     MODIFIED TO USE HARDWARE MODS TO READ/WRITE
*                     GIMIX STYLE FORMATTING. BY
*                     JOSEPH M. AULICINO
*
*        THIS CONTROLLER USES THE WD2797 LSI DISK CONTROLLER
*
*
**********************************************************************






***************************************************************
*
* Disk Driver Module Header
*
*
 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+2,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
DSKNAM fcs "FD2"

 fcb 2 Edition telltale byte
*******************
* Revision History
* edition 0 converted DC-3 drivers to double density operation
* edition 1 FD-2 drivers
* edition 2 converted FD-2 drivers to read/write Gimix style disks
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
V.DDEN rmb 1 Double density flag
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
* FD2797 Commands
*
F.REST equ $0B Restore command
F.SEEK equ $1B Seek command
F.STPI equ $4B Step in one track command
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F4 Write track command
F.WRT1 equ $F6 Write track command
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
 clr V.DDEN,U Init Density Flag
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
* Note:  We Are Stepping In One Track Before
*        Issuing The Restore.  As Suggested In The
*        Application Notes.
*
RESTOR lbsr SELECT Select drive
 bcs RETRN1
 ldx CURTBL,U
 clr V.TRAK,X Old track = 0
 ldb #F.STPI Step in command
 lbsr WCR0 Issue command, delay & wait for done.
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
 ldb CURDRV,U
 bitb #%00100000 Check if Gimix bit is set
 beq WRITS2 if not do normal write
 ldb V.SIDE,U
 andb #%00000010 set SSO bit
 orb #F.WRIT set SSO bit in command
 bra WRITS3
WRITS2 ldb #F.WRIT Write function code
 orb V.DDEN,U set density 
WRITS3 ldx PD.BUF,Y Buffer addr
WRITS1 pshs CC Save irq mask info
 orcc #IRQMask+FIRQMask Disable interrupts
 lbsr WCR
 pshs Y,U Save regs
 ldy V.CMDR,U
 leay -4,y change offset to drive select
 ldu V.DATR,U
 pag
**************************************************************
*
* Write Loop
*
WRITE2 lda 0,y get status
 bmi WRITE3 check for DRQ
 beq WRITE2
 bra WRITE4 done, go check for errors

WRITE3 lda ,X+ get data byte
 sta 0,u put in controller
 bra WRITE2 do next byte

WRITE4 ldu 2,s 
 lbsr WCR02 check for busy and error
 
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
WRTTRK lbsr SELECT Select drive
 bcs WRERR9 Error; report it
 lda R$U+1,X Track number
 ldb R$Y+1,X Side/density info
 pshs a,b
 clr V.DDEN,U
 bitb #%00000001 side 1 ?
 beq WRTRK2 yes... bypass change
 com V.EFLG+1,U make side 1

WRTRK2 ldb CURDRV,U
 bitb #%00100000 check if Gimix Format
 bne WRTRK6 if yes, do it.
 lbsr SEEKTR seek track
 puls a,b
 tsta check for track 0
 bne WRTRK5
 tst V.SIDE,U
 beq WRTRK3

WRTRK5 andb #%00000010
 stb V.DDEN,U store in density flag
 beq WRTRK3 go do single density
 ldb #F.WRT1 set for double density
 bra WRTRK4

WRTRK3 ldb #F.WRTR single density write command
WRTRK4 ldx PD.RGS,Y
 ldx R$X,X get buffer address
 clr V.EFLG,U
 lbra WRITS1
WRTRK6 ldb 1,s get side/density byte
 andb #%00000010 mask off side bits
 stb V.DDEN,U store in density flag
 lbsr SEEKTR seek track
 puls a,b
WRTRK7 tst V.SIDE,U test for side
 beq WRTRK3 do side 0
 ldb #F.WRT1 do side 1
 bra WRTRK4
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
READSC lbsr SEEK Move head to track
 lbcs WRERR9
 ldx PD.BUF,Y Point to buffer
 pshs CC Save irq mask info
 orcc #IRQMask+FIRQMask Disable interrupts
 ldb CURDRV,U
 bitb #%00100000 test for Gimix read
 beq READS1 no..do standard read
 ldb V.SIDE,U
 andb #%00000010
 orb #F.READ add command it side bit
 bra READS2
READS1 ldb #F.READ Read sector command
 orb V.DDEN,U set density
READS2 lbsr WCR Issue command
 pshs Y,U Save regs
 ldy V.CMDR,U
 leay -4,y
 ldu V.DATR,U
 pag
************************************************************
*
* Read Loop
*
READ2 lda 0,y get drive status
 bmi READ3 check for DRQ 
 beq READ2
 bra READ4 done, check for errors

READ3 lda 0,u get data byte
 sta ,X+ put in buffer
 bra READ2

READ4 ldu 2,s
 lbsr WCR02 check for errors
 
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
 pshs A
 lda PD.TYP,Y
 anda #%00100000 get gimix bit
 ora CURDRV,U add to drive select
 sta CURDRV,U store updated drive select
 puls A
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
 cmpx CURTBL,U New device call?
 beq SELCT5 ...no; don't force seek
 com V.DOSK,U Set force seek flag
 stx CURTBL,U Current table ptr
SELCT5 clr V.SIDE,U Default to side zero
 clr V.DDEN,U Init Density Flag
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
 subd #10 subtract 10 sectors
 bcc PHYSC1
 addd #10
 bra PHYSC7
PHYSC1 stb V.TMP,U Save (B)
 clrb
 pshs b Will Be Track Number
 ldb DD.FMT,x
 lsrb Shift Side Bit To Carry
 ldb V.TMP,U Restore (B)
 bcc PHYSC4 Branch If Single Sided
 spc 1
* DOUBLE SIDED TRACK/SECTOR CALCULATIONS
 spc 1
PHYSC2 com V.SIDE,U Switch Sides
 bne PHYSC3 Don't inc Track for Side 1 to 2 Switch
 inc 0,s Increment Track
PHYSC3 subb DD.TKS,X Subtrack One Track Of Sectors
 sbca #0
 bcc PHYSC2 Continue Until Less than One Track of Sectors
 bra PHYSC5 Exit and Clean Up
 spc 1
* SINGLE SIDED TRACK/SECTOR CALCULATIONS
 spc 1
PHYSC4 inc 0,s Increment Track Count
 subb DD.TKS,X Subtrack One Track Of Sectors
 sbca #0
 bcc PHYSC4 Continue Until Less Than One Track Left
 spc 1
* SET DENSITY,PUT SECTOR IN SECTOR REGISTER, TRACK IN A
 spc 1
PHYSC5 lda DD.FMT,X
 anda #2 Double Density?
 beq PHYSC6 No
 sta V.DDEN,U Set Double Density Flag
PHYSC6 puls a Get Track
 addb DD.TKS,X Add Back For Sector Number
PHYSC7 stb [V.SECR,U] Put Sector (B) In Sector Register
 clrb Clear Carry; A=Track
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
*   B = Contents Of WD2797 Status Reg
*   A,X = Destroyed
*
Settrk pshs a
 ldb CURDRV,U
 bitb #%00100000 check gimix bit
 beq Setrk1 if not gimix
 tst V.DDEN,U
 beq Setrk5
 ldb #%01000000
 bra Setrk2
Setrk1 ldb V.SIDE,U Get side info
 andb #%01000000 Mask all but needed bit
Setrk2 orb CURDRV,U Mask into drive select
 stb CURDRV,U Save it
Setrk5 ldx CURTBL,U Point to drive table
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
 lbsr WCR Put it in 2797 and delay
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
*  Input: (B)= Status Of WD2797
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
 beq READ02 no, skip to test dbl trk
 bitb #%00000001 Drive dden?
 beq Typerr Yes; ....no can do.
READ02 bita #%00000100 Media dbl track dens?
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

WRTVFY pshs D,X
 ldx PD.BUF,Y Save present buffer addr
 pshs X On stack
 ldx V.BUF,U Point to local buffer
 stx PD.BUF,Y
 ldx 4,S Restore (x)
 lbsr READSK
 puls X
 stx PD.BUF,Y Restore buffer pointer
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
