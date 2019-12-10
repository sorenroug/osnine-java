 opt l
 nam GIMIX G68 controller boot source

 opt -c

 use   defsfile

 ttl Boot Module
 pag

***************************************************************
*
* Disk Boot Module Header
*
*
 mod BTEND,BTNAM,SYSTM+OBJCT,REENT+1,BTENT,BTSTA
BTNAM fcs "Boot"
 fcb 0 Edition telltale byte

*********************************************************************
*
* Static Storage
*
*
 org 0
V.SEL rmb 2 Drive select reg addr.
u0002    rmb   2
u0004    rmb   2
u0006    rmb   2
V.TRKR    rmb   2
V.SECR    rmb   2
V.DATR    rmb   2
V.SIDE    rmb   1
u000F    rmb   4
u0013    rmb   1
u0014    rmb   1
V.EFLG    rmb   1
V.BUF    rmb   2
V.TRCK    rmb   1
V.DRV    rmb   1
BTSTA equ . Total static requirement


         fcc   "(C)1981Microware"
L0022    fcb   $00
P.T0S    fcb   10  Sectors in Track 0?
P.SCT    fcb   16  Sectors per track?

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
         leax  $01,x
         stx   u0002,u
         leax  $01,x
         stx   u0004,u
         leax  $02,x
 lda #F.Typ1
 sta 0,x Inz controller chip
         stx   u0006,u
 leax 1,X Address of track register
 stx V.TRKR,U
 leax 1,X Address of sector register
 stx V.SECR,U
 leax 1,X Address of data register
 stx V.DATR,U
 lda #$FF
 sta V.TRCK,U Inz to high track count
         lda   [V.SEL,u]
         anda  #$01
         sta   <u0013,u

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
RESTOR    lda   #1
 sta V.DRV,u
 clr V.TRCK,U Old track = 0
 lda #5 Repeat five times
RESTR2 ldb #F.STPI Step in command
 pshs A
         eorb  >L0022,pcr
         clr   <u0014,u
 lbsr WCR0 Issue command, delay & wait for done.
 puls A
 deca DONE Stepping?
 bne RESTR2 ...no; step again.
 ldb #F.REST Restore command
         eorb  >L0022,pcr
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
*
* Fall Through To Try One Last Time
*
READSC bsr PHYSIC Move head to track
 bcs Retrn1
 ldx V.BUF,u Point to buffer
         lda   #$10
         sta   <u0014,u
 ldb #F.READ Read sector command
 lbsr WCR0 Issue command
         lbra  L01FE
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

PHYSIC    lda   #$01
         sta   <V.DRV,u
         lda   #$20
         sta   u000F,u
 clr V.SIDE,u
 tstb CHECK Sector bounds
 bne PHYERR  msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes; skip conversion.
 cmpd DD.TOT+1,Y Too high sector number?
         bcc   PHYERR
         tst   <u0013,u
         bne   L014A
         subb  >P.T0S,pcr
         sbca  #$00
         bcc   L0159
         clra
         addb  >P.T0S,pcr
         bra   PHYSC7
L014A    subb  >P.SCT,pcr
         sbca  #$00
         bcc   L0159
         clra
         addb  >P.SCT,pcr
         bra   PHYSC7
L0159    stb   <u0014,u
         clrb
         pshs  b
         ldb   <$10,y
         lsrb
         ldb   <u0014,u
         bcc   L0176
PHYSC3 com V.SIDE,U Switch sides
 bne PHYSC4 Skip track inc if side 1
 inc 0,S
PHYSC4 subb DD.TKS,Y
 sbca #0
         bcc   PHYSC3
         bra   L017E
L0176    inc   ,s
         subb  $03,y
         sbca  #$00
         bcc   L0176
L017E    lda   <$10,y
         bita  #$02
         beq   L0187
         clr   u000F,u
L0187    puls  a
         addb  $03,y
PHYSC7 stb [V.SECR,U] Put sector (b) in sector reg
         ldb   u000F,u
         orb   <V.DRV,u
         stb   <V.DRV,u
         ldb   <V.TRCK,u
         stb   [<V.TRKR,u]
L019C    ldb   [V.SEL,u]
         bitb  #$20
         bne   L019C
         cmpa  <V.TRCK,u
         beq   SETRK9
 sta V.TRCK,U Update with new track
 sta [V.DATR,U] Put new trk in data reg
 ldb #F.SEEK Command
         eorb  >L0022,pcr
         clr   <u0014,u
 bsr WCR0 Issue command
 lda #4
 sta V.EFLG,U
Setrk9 clrb
 rts
 pag
WCR0    stx   [<u0004,u]
         lda   <V.DRV,u
         tst   <u0013,u
         beq   L01CC
         ora   #$C0
L01CC    sta   [V.SEL,u]
         lda   <u0014,u
         tst   V.SIDE,u
         beq   L01D7
         ora   #$40
L01D7    ora   #$80
         sta   [<u0002,u]
         tst   <u0014,u
         beq   L01ED
         orb   <V.EFLG,u
         clr   <V.EFLG,u
         tst   V.SIDE,u
         beq   L01ED
         orb   #$02
L01ED    stb   [<u0006,u]
L01F0    lda   [V.SEL,u]
         bita  #$40
         beq   L01F0
         lda   [<u0006,u]
         rts

         bita  #$40
         bne   ERRWP
L01FE    bita  #$04
         bne   L0218
 bita #%00001000 Check sum ok?
 bne ERRCRC ..no; return error
 bita #%00010000 Seek error?
 bne ERSEEK ..yes; return error
 bita #%10000000 Drive ready?
 bne ERNRDY ..no; error
 clrb
 rts

ERRCRC comb
 ldb #E$CRC Error: bad check sum
 rts

ERSEEK comb
 ldb   #E$Seek
 rts

L0218    ldb   <u0014,u
         bitb  #$20
         bne   RDERR
         comb
         ldb   #E$Write
         rts

RDERR comb
 ldb   #E$Read
 rts

ERNRDY comb
 ldb   #E$NotRdy
 rts

ERRWP comb
 ldb   #E$WP
 rts

         emod
BTEND      equ   *
