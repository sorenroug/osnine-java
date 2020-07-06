         nam   Boot
         ttl   os9 system module
 use defsfile

 ttl Boot Module

NMIVec equ $109

V.SEL equ    $FF40 Drive select reg addr.

 mod   BTEND,BTNAM,SYSTM+OBJCT,REENT+1,BTENT,BTSTA

BTNAM fcs "Boot"
 fcb 1 Edition

V.DRV rmb 1 Drive select reg save
V.TMP rmb 1 Temporary save byte
V.BUF    rmb   1
u0003    rmb   1
V.TRCK    rmb   1
BTSTA     equ   .

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
 lda #F.Typ1
 sta 0,x Inz controller chip
 lbsr DELAY1
 lda 0,x Read controller status to clear it.
         lda   >$FF22
         lda   #$FF
         sta   V.TRCK,u
 leax NMISVC,pcr
 stx NMIVec+1
 lda #$7E Store JMP command
 sta NMIVec
         lda   #$04
         sta   >$FF48
         ldd   #$C350
L0043    nop
         nop
         subd  #$0001
         bne   L0043
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
RESTR2    ldb   #$43
         pshs  a
         bsr   RESTR9
         puls  a
         deca
         bne   RESTR2
         ldb   #$03
RESTR9    lbra  WCR0

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
         bcs   Retrn1
         ldx   V.BUF,u
         orcc  #$50
         pshs  y,dp,cc
         lda   #$FF
         tfr   a,dp
         lda   #$34
         sta   <$03  ($FF03)
         lda   #$37
         sta   <$23
         lda   <$22
         ldb   #$88
         stb   <$40
         ldb   #$24
         stb   <$48
L00FC    sync
         lda   <$43
         ldb   <$22
         sta   ,x+
         bra   L00FC

NMISVC leas R$Size,s
         lda   #$04
         sta   <$48
         lda   #$34
         sta   <$23
         ldb   <$40
         puls  y,dp,cc
         bitb  #$04
         beq   STCK

RDERR    comb
         ldb   #$F4
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
PHYSC8    stb   >$FF42
         bsr   DELAY1
         cmpb  >$FF42
         bne   PHYSC8
         ldb   V.TRCK,u
         stb   >$FF41
         cmpa  V.TRCK,u
         beq   L015C
         sta   V.TRCK,u
         sta   >$FF43
         ldb   #$13
         bsr   WCR0
         pshs  x
         ldx   #$222E
SETRK8    leax  -$01,x
         bne   SETRK8
         puls  x
L015C    clrb
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
L0166    ldb   >$FF40
         lsrb
         bcs   L0166
         rts
L016D    lda   #$04
         sta   >$FF48
         stb   >$FF40
         rts

WCR    bsr   L016D
DELAY1    lbsr  DELAY2
DELAY2    lbsr  DELAY4
DELAY4    rts
         emod
BTEND      equ   *
