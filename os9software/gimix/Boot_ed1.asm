 opt l
 nam GIMIX G68 controller boot source

 opt -c

 use defsfile

 ttl Boot Module
 pag


tylg     set   Systm+Objct
atrv     set   ReEnt+rev
rev      set   $02
         mod   BTEND,BTNAM,tylg,atrv,BTENT,BTSTA
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
V.DMACTL rmb 2
V.DMAADR rmb 2
V.CMDR rmb 2
V.TRKR rmb 2
V.SECR rmb 2
V.DATR rmb 2
V.SIDE rmb 1
V.DENS rmb 1
u0010 rmb 3
u0013 rmb 1
V.TMP rmb 1
V.EFLG rmb 1
V.BUF rmb 2
V.TRCK rmb 1
u0019 rmb 1   FM-flag?
V.TOT rmb 2 Total number of sectors on media
V.FMT rmb 1
V.TKS rmb 1
BTSTA equ .

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
         lda   [V.SEL,u]
         anda  #$01
         sta   <u0013,u

         pshs  u,x,D
         ldd   #256
         os9   F$SRqMem
         bcs   BOOTE1
         tfr   u,d
         ldu   $04,s
         std V.BUF,u
 clrb
 ldx #0 Get sector zero
         lbsr  READSK
         bcs   BOOTE1
         ldy V.BUF,u
 ldd DD.BSZ,Y Get bootstrap size
 std 0,S Return to caller
         beq   BOOT2
 ldx DD.BT+1,Y Get boot sector
 ldd DD.TOT+1,y get total number of sectors
 std V.TOT,u save it
         lda DD.FMT,y
         sta V.FMT,u
         lda DD.TKS,y
         sta V.TKS,u
         ldd #256
         ldu V.BUF,u
         os9 F$SRtMem
         ldd 0,s Get bootstrap size
 OS9 F$SRqMem Get boot memory
 bcs BOOTE1 Branch if none
         tfr   u,d
         ldu   4,s
         std   2,s
         std V.BUF,u
         ldd   0,s
BOOT1 pshs D,X Save size, sector number
 clrb
 bsr READSK Read sector
 bcs BOOTER
 puls D,X Retrieve size, sector number
 inc V.BUF,U Move buffer ptr
 leax 1,X Up sector number
 subd #$100 Subtract page read
 bhi BOOT1
BOOT2 clra
 puls b,a
 bra Bootz

BOOTER leas 4,S Return scratch
BOOTE1 leas 2,S Return scratch
Bootz puls x,u
 leas BTSTA,s De-allocate static fm stack
Retrn1    rts

*********************************************************
*
* Restore Drive To Track Zero
*
RESTOR    lda   #$01
         sta   <u0019,u
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
         bra   RDSK3

RDSK1    bcc   RDSK3
         pshs  x,b,a
         bsr   RESTOR
         puls  x,b,a
RDSK3    pshs  x,b,a
         bsr   READSC
         puls  x,b,a
         bcc   Retrn1
         lsra
         bne   RDSK1
*
* Fall Through To Try One Last Time
*
READSC    bsr   PHYSIC
         bcs   Retrn1 Sector out of range?
         ldx V.BUF,u
         lda #$10
         sta V.TMP,u
 ldb #F.READ Read sector command
         lbsr  WCR0
         lbra  READCK

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
PHYSIC    lda   #$01
         sta   <u0019,u
         lda   #$20
         sta   V.DENS,u
         clr   V.SIDE,u
 tstb CHECK Sector bounds
 bne PHYERR msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
 beq PHYSC7 ..yes
 cmpd V.TOT,u higher than max for disk?
         bcc PHYERR branch if so
         tst   u0013,u
         bne PHYSC0
         subb P.T0S,pcr On side 1 track zero?
         sbca #0
         bcc PHYSC1
         clra
         addb P.T0S,pcr
         bra PHYSC7

PHYSC0 subb P.SCT,pcr
         sbca #0
         bcc PHYSC1
         clra
         addb P.SCT,pcr
         bra PHYSC7
PHYSC1    stb V.TMP,u
         clrb
 pshs B Will be track number
         ldb V.FMT,u Disk format
 lsrb SHIFT Side bit to carry
         ldb V.TMP,u
         bcc PHYSC4
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
         sbca  #$00
         bcc   PHYSC4
PHYSC5    lda V.FMT,u
         bita  #$02 Check density
         beq   PHYSC6
         clr   V.DENS,u
PHYSC6    puls  a
         addb V.TKS,u
PHYSC7    stb   [V.SECR,u]
         ldb   V.DENS,u
         orb   <u0019,u
         stb   <u0019,u
         ldb   V.TRCK,u
         stb [V.TRKR,u]
L01AD    ldb [V.SEL,u]
         bitb #$20
         bne L01AD
         cmpa V.TRCK,u
         beq   Setrk9
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
WCR0    stx   [V.DMAADR,u]
         lda   <u0019,u
         tst   <u0013,u
         beq   L01DD
         ora   #$C0
L01DD    sta   [V.SEL,u]
         lda V.TMP,u
         tst   V.SIDE,u
         beq   L01E8
         ora   #$40
L01E8    sta   [V.DMACTL,u]
         tst   <V.TMP,u
         beq   L01FC
         orb   V.EFLG,u
         clr   V.EFLG,u
         tst   V.SIDE,u
         beq   L01FC
         orb   #$02
L01FC    stb   [V.CMDR,u]
L01FF    lda   [V.SEL,u]
         bita  #$40 Ready?
         beq   L01FF
         lda   [V.CMDR,u] Get status
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
 bne   RDWRER
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
 ldb #E$Seek
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
ERNRDY comb
 ldb #E$NotRdy
 rts

WPERR comb
 ldb #E$WP
 rts
 emod
BTEND equ *
