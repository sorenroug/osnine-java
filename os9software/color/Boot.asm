 opt l
 nam TRS-80 Coco controller boot source

 opt -c

 use defsfile

 ttl Boot Module

NMIVec equ $109

V.SEL equ    $FF40 Drive select reg addr.
V.CMDR equ   $FF48 Status/command register
V.TRKR equ $FF49 Track register
V.SECR equ   $FF4A Sector register
V.DATR equ   $FF4B Data register

***************************************************************
*
* Disk Boot Module Header
*
*
 mod BTEND,BTNAM,SYSTM+OBJCT,REENT+1,BTENT,BTSTA
BTNAM fcs "Boot"
 fcb 0 Edition

V.DRV rmb 1 Drive select reg save
V.TMP rmb 1 Temporary save byte
V.BUF rmb 2 Local buffer addr
V.TRCK rmb 1 Current track
BTSTA equ . Total static requirement

*
* WD1793 Commands
*
F.REST equ $00
F.SEEK equ $10
F.STEP equ $28
F.STPI equ $40
F.READ equ $88 Read sector command
F.WRIT equ $A8 Write sector command
F.TYP1 equ $D0 Force type 1 status
F.WRTR equ $F0 Write track command
STEPRATE equ 3

DRIVE1   equ %00000001
DRIVE2   equ %00000010
DRIVE3   equ %00000100
MOTORON  equ %00001000
PRECOMP  equ %00010000
DDENS    equ %00100000 Double density enable
DRIVE4   equ %01000000
WAITENBL equ %10000000 Wait enable

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
 ldx #V.SEL
 leax V.CMDR-V.SEL,x Address of command register
 lda #F.Typ1
 sta 0,x Inz controller chip
 lbsr DELAY1
 lda 0,x Read controller status to clear it.
 lda #$FF
 sta V.TRCK,U Inz to high track count
 leax NMISVC,pcr
 stx NMIVec+1
 lda #$7E Store JMP command
 sta NMIVec
         lda   #$08
         sta   >V.SEL
         ldd   #50000
L0042    nop
         nop
         subd  #1
         bne   L0042
         pshs  u,x,b,a
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
BOOT2 clrb CLEAR Carry
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
RESTR2 ldb #F.STPI+STEPRATE Step in command
 pshs A
 lbsr WCR0 Issue command, delay & wait for done.
 puls A
 deca DONE Stepping?
 bne RESTR2 ...no; step again.
 ldb #F.REST+STEPRATE Restore command
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
 bsr RDSK3 Read sector into buffer
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
READSC    bsr   PHYSIC
 bcs Retrn1
 ldx V.BUF,u Point to buffer
 orcc #IRQMask+FIRQMask Disable interrupts
         pshs  y
         ldy   #$FFFF
         ldb   #WAITENBL
         stb   >V.CMDR
         ldb   #$39
         stb   >V.SEL
         lbsr  DELAY1
         ldb   #$B9
         lda   #$02
L00FB    bita  >V.CMDR
         bne   L010D
         leay  -1,y
         bne   L00FB
         lda   #$09
         sta   >V.SEL
         puls  y
         bra   RDERR
L010D    lda   >V.DATR
         sta   ,x+
         stb   >V.SEL
         bra   L010D

NMISVC leas R$Size,s
 puls y
 ldb >V.CMDR
 bitb #$04
 lbeq STCK

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

PHYSIC    clr   V.Drv,u
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
         beq   PHYSC7
         clr   ,-s
         bra   PHYSC4
PHYSC2    inc   ,s
PHYSC4    subd  #$0012
         bcc   PHYSC2
         addb  #$12
         puls  a
PHYSC7    incb
         stb   >V.SECR
         ldb   V.TRCK,u
         stb   >V.TRKR
         cmpa  V.TRCK,u
         beq   SETRK9
         sta   V.TRCK,u
         sta   >V.DATR
 ldb #F.SEEK+STEPRATE
         bsr   WCR0
 pshs x
 ldx #$222E delay loop
SETRK8 leax -1,x
 bne SETRK8
 puls x
SETRK9    clrb
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
STCK bitb #%10011000
 bne RDERR
 clrb
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

WCR0 bsr WCR Issue command & delay
WCR02 ldb >V.CMDR
 bitb #%00000001 Busy?
 bne WCR02
 rts

WCR03 lda #MOTORON+DRIVE1
 sta >V.SEL Select drive
 stb >V.CMDR Issue command
 rts

WCR bsr WCR03
DELAY1    lbsr  DELAY2
DELAY2    lbsr  DELAY4
DELAY4    rts

 emod

BTEND equ *

 end
