 opt l
 nam Swtpc Dc-3 controller boot source

 opt -c

 use defsfile

 ttl Boot Module
 pag
*******************************************************************
*
*                 Microware Systems Corporation
*
*
*       Os-9 Swtpc Dc-3 Disk Boot Module
*
*       Software To Boot Swtpc Dc-2, And Dc-3 Disk Controllers
*
*                         Revised By
*                     William G. Phelps
*
*
*       This Controller Uses The Fdc1 1771 Lsi Disk Controller
*
**********************************************************************






***************************************************************
*
* Disk Boot Module Header
*
*
 mod BTEND,BTNAM,SYSTM+OBJCT,REENT+1,BTENT,BTSTA
BTNAM fcs "Boot"

 fcb 1 Edition telltale byte
*******************
* Revision History
* edition 0: prehistoric
* edition 1: all use statements converted to use defsfile
*            copyright removed from object file
*            disktype set Dc3 added
*******************

 pag
Steprt fcb 0

*********************************************************************
*
* Static Storage
*
*
 org 0
V.SEL rmb 2 Drive select reg addr.
V.CMDR rmb 2
V.TRKR rmb 2
V.SECR rmb 2
V.DATR rmb 2
V.EFLG rmb 1 Set "e" for head settle time
V.SIDE rmb 1 Current side; 0:=side 0
V.TMP rmb 1 Temporary save byte
V.BUF rmb 2 Local buffer addr
V.TRCK rmb 1 Current track
V.DRV rmb 1 Drive select reg save
BTSTA equ . Total static requirement


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
BTENT clra
 ldb #BTSTA Get size of needed static
INILUP pshs a
 decb
 bne INILUP
 tfr s,u Point "u" to static
 ldx #DPORT Point to controller addr
 stx V.SEL,U Address of drive select reg.
 leax 4,X Address of command register
 stx V.CMDR,U
 lda #F.Typ1
 sta 0,x Inz controller chip
 lbsr Delay Wait for 1771
 lda 0,x Read controller status to clear it.
 leax 1,X Address of track register
 stx V.TRKR,U
 leax 1,X Address of sector register
 stx V.SECR,U
 leax 1,X Address of data register
 stx V.DATR,U
 lda #$FF
 sta V.TRCK,U Inz to high track count

*        Fall thru to do the boot
 pag
*******************************************************************
*
* Bootstrap System From Disk
*
*         (U)= Pointer Global Storage
*
*  Output: (D)= Length Of Bootstrap Data
*          (X)= Address Of Start Of Boot Data
*          (Y) Unchanged
*          (U) Unchanged
*
LBOOT pshs D,X,U Save registers
 clra
 clrb
 ldy #1
 ldx D.FMBM
 ldu D.FMBM+2
 OS9 F$SchBit Search for buffer spot
 bcs BOOTE1 Problem no mem
 exg a,b Convert page no. to addr
 ldu 4,s Restore "u"
 std V.BUF,u Save buffer addr for use
 clrb
 ldx #0 Get sector zero
 bsr READSK
 bcs BOOTE1 Branch if can't
 ldd DD.BSZ,Y Get bootstrap size
 std 0,S Return to caller
 OS9 F$SRqMem Get boot memory
 bcs BOOTE1 Branch if none
 stu 2,S Return to caller
 ldu 4,S Get static storage
 ldx 2,s Get mem addr
 stx V.BUF,u
 ldx DD.BT+1,Y Get boot sector
 ldd DD.BSZ,Y Get boot size
 beq BOOT2
BOOT1 pshs D,X Save size, sector number
 clrb
 bsr READSK Read sector
 bcs BOOTER
 puls D,X Retrieve size, sector number
 inc V.BUF,U Move buffer ptr
 leax 1,X Up sector number
 subd #$100 Subtract page read
 bhi BOOT1 Branch if more
BOOT2 clra CLEAR Carry
 puls d
 bra Bootz


BOOTER leas 4,S Return scratch
BOOTE1 leas 2,S Return scratch
Bootz puls x,u
 leas BTSTA,s De-allocate static fm stack
 rts
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
RESTOR clr V.Drv,u
 clr V.TRCK,U Old track = 0
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
 bne RDSK3 Branch if not
Read0 bsr RDSK3 Read sector into buffer
 bcs Retrn1
 ldy V.BUF,u Point "y" to dd. info
 clrb
Retrn1 rts


RDSK1 bcc RDSK3 Retry without restore
 pshs D,X
 bsr RESTOR Drive to tr00
 puls D,X
RDSK3 pshs D,X
 bsr READSC Read sector
 puls D,X
 bcc Retrn1 Return if no error
 lsra DONE?
 bne RDSK1 ...no; retry.
*
* Fall Through To Try One Last Time
*
READSC bsr PHYSIC Move head to track
 bcs Retrn1
 ldx V.BUF,u Point to buffer
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
 bitb #%00000100 Lost data?
 bne RDERR ..yes; return it.
 bra STCK


RDERR comb
 ldb #E$Read
 rts
 pag
**************************************************************
*
* Convert Logical Sector Number To Physical Track And Sector
*
*  Input:  B = Msb Of Logical Sector Number
*          X = Lsb'S Of Logical Sector Number
*  Output: A = Physical Track Number
*          Sector Reg = Physical Sector Number
*  Error:  B = Error Code, W/Carry Set
*

PHYERR comb
 ldb #E$SECT Error: bad sector number
 rts

PHYSIC clr V.DRV,u
 clr V.SIDE,u
 tstb CHECK Sector bounds
 bne PHYERR  msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes; skip conversion.
 cmpd DD.TOT+1,Y Too high sector number?
 bhs PHYERR ..yes; sorry
 stb V.TMP,U Save (b)
 clrb
 pshs B Will be track number
 ldb DD.FMT,Y
 lsrb SHIFT Side bit to carry
 ldb V.TMP,U Restore (b)
 bcs PHYSC4 Bra if double sided
 dec 0,S
PHYSC2 inc 0,S
 subb DD.TKS,Y Subtract one track worth of sectors
 sbca #0
 bcc PHYSC2 Repeat until less than 1 track size
 bra PHYSC5
PHYSC3 com V.SIDE,U Switch sides
 bne PHYSC4 Skip track inc if side 1
 inc 0,S
PHYSC4 subb DD.TKS,Y
 sbca #0
 bcc PHYSC3 Repeat until less than 1 trk
PHYSC5 addb DD.TKS,Y Add back for sector number
 puls A Desired track.
PHYSC7 stb [V.SECR,U] Put sector (b) in sector reg
* Fall thru to do actual seek
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

SETTRK ldb V.SIDE,U Get side info
 andb #%01000000 Mask all but needed bit
 orb V.DRV,U Mask into drive select
 stb V.DRV,U Save it
 ldb V.TRCK,U Get old track
 stb [V.TRKR,U] Put old track in trk reg
 cmpa V.TRCK,U Same track?
 beq SETRK9 ..yes; skip seek.
 sta V.TRCK,U Update with new track
 sta [V.DATR,U] Put new trk in data reg
 ldb #F.SEEK Command
 bsr WCR0 Issue command
 lda #4
 sta V.EFLG,U
Setrk9 clrb
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
*
* Write Command Register
*
*
*   1 - Will Add Step Rate To Seek Commands When Wcr0 Called
*   2 - Issues Command To Controller Chip
*   3 - Will Wait For Status "Not Busy" If Wcr0 Called
*
*

WCR0 eorb Steprt,pcr Add step rate to command
 bsr WCR Issue command & delay
WCR02 ldb [V.CMDR,U] Get status
 bitb #%00000001 Busy?
 bne WCR02 ..yes; wait for it.
 rts



WCR lda V.DRV,U
 sta [V.SEL,U] Select drive
 orb V.EFLG,U
 clr V.EFLG,U
 stb [V.CMDR,U] Issue command


DELAY bsr DELAY1
DELAY1 bsr DELAY2
DELAY2 bsr DELAY4
DELAY4 nop
 rts

 emod

BTEND equ *

 end
