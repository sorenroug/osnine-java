 opt l
 nam GIMIX G68 controller boot source

 opt -c

 use defsfile

 ttl Boot Module
 pag


Type set SYSTM+OBJCT
Revs set REENT+2
 mod BTEND,BTNAM,Type,Revs,BTENT,BTSTA

BTNAM fcs "Boot"
 fcb 1
 fcc "(C) 1982 Microware"

*********************************************************************
*
* Static Storage
*
*
 org 0
V.SEL rmb 2 Drive select reg addr.
V.DMACTL rmb 2 DMA control register ptr
V.DMAADR rmb 2 DMA address register ptr
V.CMDR rmb 2 Command/status register ptr
V.TRKR rmb 2 Track register ptr
V.SECR rmb 2 Sector register ptr
V.DATR rmb 2 Data register ptr

V.SIDE rmb 1
V.DENS rmb 1
V.WPROT rmb 1 Software write protection
V.FDSTA rmb 1  FD status
V.EXTDMA rmb 1 Extended DMA address (lower nibble)
V.8INCH rmb 1
V.TMP rmb 1
V.EFLG rmb 1 Set "e" for head settle time
V.BUF rmb 2
V.TRCK rmb 1
V.SELFLG rmb 1 Flags for the select register
V.TOT rmb 2 Total number of sectors on media
V.FMT rmb 1
V.TKS rmb 1
BTSTA equ .

*
* Fd1797 Commands
*

F.REST equ $0B Restore command
F.SEEK equ $1B Seek command
F.STPI equ $4B Step in one track command
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F4 Write track command
 pag

Steprt fcb 0
P.T0S fcb 10
P.SCT fcb 16

BTENT clra
 ldb #BTSTA Get size of needed static
INILUP pshs  a
 decb
 bne INILUP
 tfr s,u Point "u" to static
 ldx #DPort
 stx V.SEL,U Address of drive select reg.
 leax 1,x
 stx V.DMACTL,u
 leax 1,x
 stx V.DMAADR,u
 leax 2,x
 lda #F.Typ1
 sta 0,x Inz controller chip
 stx V.CMDR,u
 leax 1,X Address of track register
 stx V.TRKR,U
 leax 1,X Address of sector register
 stx V.SECR,U
 leax 1,X Address of data register
 stx V.DATR,U
 lda #$FF
 sta V.TRCK,U Inz to high track count
 lda [V.SEL,u]
 anda #1 Check for 8-inch drive
 sta V.8INCH,u

 pshs U,X,D
 ldd #256 Get buffer for LSN 0 read
 os9 F$SRqMem
 bcs BOOTE1 Problem no mem
 tfr U,D
 ldu 4,s Restore "u"
 std V.BUF,u Save buffer addr for use
 clrb
 ldx #0 Get sector zero
 lbsr READSK
 bcs BOOTE1 Branch if can't
 ldy V.BUF,u
 ldd DD.BSZ,Y Get bootstrap size
 std 0,S Return to caller
 beq BOOT2 branch if no boot file
 ldx DD.BT+1,Y Get boot sector
 ldd DD.TOT+1,y get total number of sectors of disk
 std V.TOT,u save it
 lda DD.FMT,y get disk format
 sta V.FMT,u save it
 lda DD.TKS,y get number of sectors per track
 sta V.TKS,u save it
 ldd #256
 ldu V.BUF,u
 os9 F$SRtMem return initial buffer
 ldd 0,s Get bootstrap size
 OS9 F$SRqMem Get boot memory
 bcs BOOTE1 Branch if none
 tfr u,d
 ldu 4,S Get static storage
 std 2,S
 std V.BUF,u save allocated memory
 ldd 0,S
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
 puls b,a
 bra Bootz

BOOTER leas 4,S Return scratch
BOOTE1 leas 2,S Return scratch
Bootz puls x,u
 leas BTSTA,s De-allocate static fm stack
Retrn1 rts

*********************************************************
*
* Restore Drive To Track Zero
*
RESTOR lda #1 Select drive 0
 sta V.SELFLG,u
 clr V.TRCK,U Old track = 0
 lda #5 Repeat five times
RESTR2 ldb #F.STPI Step in command
 pshs A
 eorb STEPRT,pcr
 clr V.TMP,u
 lbsr WCR0 Issue command, delay & wait for done.
 puls A
 deca DONE Stepping?
 bne RESTR2
 ldb #F.REST Restore command
 eorb Steprt,pcr
 lbra  WCR0
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
 bra RDSK3


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
 lda #$10
 sta V.TMP,u
 ldb #F.READ Read sector command
 lbsr WCR0
 lbra READCK

PHYERR comb
 ldb #E$Sect
 rts

**************************************************************
*
* Convert Logical Sector Number
* To Physical Track And Sector
*
*  Input:  B = Msb Of Logical Sector Number
*          X = Lsb'S Of Logical Sector Number

PHYSIC lda #1 select drive 0
 sta V.SELFLG,u
 lda #$20 set single density operation
 sta V.DENS,u
 clr V.SIDE,u
 tstb CHECK Sector bounds
 bne PHYERR msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes; skip conversion.
 cmpd V.TOT,u higher than max for disk?
 bcc PHYERR branch if so
 tst V.8INCH,u
 bne PHYSC0
 subb P.T0S,pcr On side 1 track zero?
 sbca #0
 bcc PHYSC1
 clra
 addb P.T0S,pcr
 bra PHYSC7
* 16 sectors
PHYSC0 subb P.SCT,pcr
 sbca #0
 bcc PHYSC1
 clra
 addb P.SCT,pcr
 bra PHYSC7
* Read track 0
PHYSC1 stb V.TMP,u
 clrb
 pshs B Will be track number
 ldb V.FMT,u Disk format
 lsrb SHIFT Side bit to carry
 ldb V.TMP,u
 bcc PHYSC4
* Double sided read
PHYSC2 com V.SIDE,U Switch sides
 bne PHYSC3 Skip track inc if side 1
 inc 0,S
PHYSC3 subb V.TKS,u
 sbca #0
 bcc PHYSC2 Repeat until less than 1 trk
 bra PHYSC5

* Calculate track for single sided disk
PHYSC4 inc 0,S Increment track number
 subb V.TKS,u
 sbca #0
 bcc PHYSC4
PHYSC5 lda V.FMT,u
 bita #2 Check density
 beq PHYSC6 branch if single track density
 clr V.DENS,u double density
PHYSC6 puls a
 addb V.TKS,u
PHYSC7 stb [V.SECR,u]
 ldb V.DENS,u
 orb V.SELFLG,u set density
 stb V.SELFLG,u
 ldb V.TRCK,u
 stb [V.TRKR,u]
PHYSC8 ldb [V.SEL,u]
 bitb #$20 Motor starting up?
 bne PHYSC8 ..yes; wait for bit to go away
 cmpa V.TRCK,u already on the correct track?
 beq Setrk9 branch if so
 sta V.TRCK,u
 sta [V.DATR,u]
 ldb #F.SEEK Command
 eorb Steprt,pcr
 clr V.TMP,u
 bsr WCR0 Issue command
 lda #4
 sta V.EFLG,u
Setrk9 clrb
 rts

****************************************************************
*
*
* Write Command Register
*
* Level 2: Set the DMA extended address from logical address
*
* Input: (X)=logical address
*        (B)=FDC command
WCR0 equ *

 ifeq LEVEL-2
 pshs B
 tfr X,D
 anda #$F0
 lsra Shift block number to lower nibble
 lsra
 lsra
 ldy D.SysDAT Get system DAT
 ldd A,Y get block number
 clra
 lsrb set the DMA extended bits
 rora
 lsrb
 rora
 lsrb
 rora
 lsrb
 rora
 stb V.EXTDMA,u
 pshs A make copy of block number
 pshs X
 lda 0,S
 anda #$0F
 ora 2,S load the high nibble of block
 sta 0,S
 puls X
 puls A,B
 endc

 stx [V.DMAADR,u] Set buffer address
 lda V.SELFLG,u
 tst V.8INCH,u
 beq WCR00
 ora #$C0 Select 8" drive
WCR00 sta [V.SEL,u]
 lda V.TMP,u
 ifeq LEVEL-2
 ora V.EXTDMA,u add in the extended bank address
 endc
 tst V.SIDE,u
 beq WCR01
 ora #$40 Select side one
WCR01 sta [V.DMACTL,u]
 tst V.TMP,u
 beq WCR
 orb V.EFLG,u
 clr V.EFLG,u
 tst V.SIDE,u
 beq WCR
 orb #$02 Select side 1
WCR stb [V.CMDR,u] Issue command
WCR1 lda [V.SEL,u] Get status
 bita #$40 Ready?
 beq WCR1 ..no; check again
 lda [V.CMDR,u] Get status and clear interrupt
 rts

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
 bne RDWRER
 bita #%00001000 Check sum ok?
 bne ERRCRC
 bita #%00010000 Seek error?
 bne ERSEEK
 bita #%10000000 Drive ready?
 bne ERNRDY ..no; error
 clrb
 rts

ERRCRC comb
 ldb #E$CRC Error: bad check sum
 rts

ERSEEK comb
 ldb #E$Seek Error: seek error
 rts

RDWRER ldb V.TMP,u
 bitb  #%00100000  Write fault?
 bne RDERR
WRERR comb
 ldb #E$Write
 rts
RDERR comb
 ldb #E$Read
 rts

ERNRDY comb
 ldb #E$NotRdy Error: drive not ready
 rts

WPERR comb
 ldb #E$WP
 rts
 emod
BTEND equ *
