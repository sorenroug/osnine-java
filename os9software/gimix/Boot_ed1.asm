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
u0002    rmb   2
u0004    rmb   2
V.CMDR    rmb   2
u0008    rmb   2
u000A    rmb   2
u000C    rmb   2
V.SIDE    rmb   1
u000F    rmb   4
u0013    rmb   1
u0014    rmb   1
V.EFLG    rmb   1
V.BUF    rmb   2
u0018    rmb   1
u0019    rmb   1
u001A    rmb   2
u001C    rmb   1
u001D    rmb   1
BTSTA     equ   .

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
P.T0S    fcb   $0A
P.SCT    fcb   $10

BTENT clra
 ldb #BTSTA Get size of needed static
INILUP pshs  a
 decb
 bne INILUP
 tfr s,u Point "u" to static
 ldx  #DPort
 stx V.SEL,U Address of drive select reg.
         leax  $01,x
         stx   u0002,u
         leax  $01,x
         stx   u0004,u
         leax  $02,x
 lda #F.Typ1
 sta 0,x Inz controller chip
         stx   V.CMDR,u
         leax  $01,x
         stx   u0008,u
         leax  $01,x
         stx   u000A,u
         leax  $01,x
         stx   u000C,u
         lda   #$FF
         sta   <u0018,u
         lda   [,u]
         anda  #$01
         sta   <u0013,u

         pshs  u,x,b,a
         ldd   #$0100
         os9   F$SRqMem
         bcs   BOOTE1
         tfr   u,d
         ldu   $04,s
         std   <V.BUF,u
 clrb
 ldx #0 Get sector zero
         lbsr  READSK
         bcs   BOOTE1
         ldy   <V.BUF,u
 ldd DD.BSZ,Y Get bootstrap size
 std 0,S Return to caller
         beq   BOOT2
 ldx DD.BT+1,Y Get boot sector
 ldd DD.TOT+1,y
         std   <u001A,u
         lda   <$10,y
         sta   <u001C,u
         lda   $03,y
         sta   <u001D,u
         ldd   #$0100
         ldu   <V.BUF,u
         os9   F$SRtMem
         ldd   ,s
         os9   F$SRqMem
         bcs   BOOTE1
         tfr   u,d
         ldu   $04,s
         std   $02,s
         std   <V.BUF,u
         ldd   ,s
BOOT1 pshs D,X Save size, sector number
 clrb
 bsr READSK Read sector
 bcs BOOTER
 puls D,X Retrieve size, sector number
 inc V.BUF,U Move buffer ptr
 leax 1,X Up sector number
 subd #$100 Subtract page read
         bhi   BOOT1
BOOT2    clra
         puls  b,a
         bra   Bootz

BOOTER leas 4,S Return scratch
BOOTE1 leas 2,S Return scratch
Bootz puls x,u
 leas BTSTA,s De-allocate static fm stack
Retrn1    rts

RESTOR    lda   #$01
         sta   <u0019,u
         clr   <u0018,u
 lda #5 Repeat five times
RESTR2 ldb #F.STPI Step in command
 pshs A
         eorb  >Steprt,pcr
         clr   <u0014,u
         lbsr  L01D0
         puls  a
         deca
         bne   RESTR2
         ldb   #F.REST
         eorb  >Steprt,pcr
         lbra  L01D0
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
READSC    bsr   L0128
         bcs   Retrn1
         ldx   <V.BUF,u
         lda   #$10
         sta   <u0014,u
 ldb #F.READ Read sector command
         lbsr  L01D0
         lbra  L020D

PHYERR comb
 ldb #E$Sect
 rts

L0128    lda   #$01
         sta   <u0019,u
         lda   #$20
         sta   u000F,u
         clr   V.SIDE,u
 tstb CHECK Sector bounds
 bne PHYERR  msb must be zero
 tfr X,D Logical sector (os-9)
 cmpd #0 Logical sector zero?
         beq   L019C
         cmpd  <u001A,u
         bcc   PHYERR
         tst   <u0013,u
         bne   L0158
         subb  >P.T0S,pcr
         sbca  #$00
         bcc   L0167
         clra
         addb  >P.T0S,pcr
         bra   L019C
L0158    subb  >P.SCT,pcr
         sbca  #$00
         bcc   L0167
         clra
         addb  >P.SCT,pcr
         bra   L019C
L0167    stb   <u0014,u
         clrb
         pshs  b
         ldb   <u001C,u
         lsrb
         ldb   <u0014,u
         bcc   L0185
PHYSC3 com V.SIDE,U Switch sides
 bne PHYSC4 Skip track inc if side 1
 inc 0,S
PHYSC4    subb  <u001D,u
 sbca #0
 bcc PHYSC3 Repeat until less than 1 trk
         bra   L018E
L0185    inc   ,s
         subb  <u001D,u
         sbca  #$00
         bcc   L0185
L018E    lda   <u001C,u
         bita  #$02
         beq   L0197
         clr   u000F,u
L0197    puls  a
         addb  <u001D,u
L019C    stb   [<u000A,u]
         ldb   u000F,u
         orb   <u0019,u
         stb   <u0019,u
         ldb   <u0018,u
         stb   [<u0008,u]
L01AD    ldb   [,u]
         bitb  #$20
         bne   L01AD
         cmpa  <u0018,u
         beq   Setrk9
         sta   <u0018,u
         sta   [<u000C,u]
 ldb #F.SEEK Command
         eorb  >Steprt,pcr
         clr   <u0014,u
         bsr   L01D0
 lda #4
 sta V.EFLG,u
Setrk9 clrb
 rts

L01D0    stx   [<u0004,u]
         lda   <u0019,u
         tst   <u0013,u
         beq   L01DD
         ora   #$C0
L01DD    sta   [,u]
         lda   <u0014,u
         tst   V.SIDE,u
         beq   L01E8
         ora   #$40
L01E8    sta   [<u0002,u]
         tst   <u0014,u
         beq   L01FC
         orb   <V.EFLG,u
         clr   <V.EFLG,u
         tst   V.SIDE,u
         beq   L01FC
         orb   #$02
L01FC    stb   [V.CMDR,u]
L01FF    lda   [,u]
         bita  #$40
         beq   L01FF
         lda   [V.CMDR,u]
         rts

         bita  #$40
         bne   ERWP
L020D    bita  #$04
         bne   L0227
         bita  #%00001000 Check sum ok?
         bne   ERRCRC
         bita  #%00010000 Seek error?
         bne   ERSEEK
         bita  #%10000000 Drive ready?
         bne   ERNRDY
         clrb
         rts

ERRCRC comb
 ldb #E$CRC Error: bad check sum
 rts

ERSEEK comb
 ldb #E$Seek
 rts

L0227    ldb   <u0014,u
         bitb  #$20
         bne   RDERR
         comb
         ldb   #E$Write
         rts

RDERR comb
 ldb #E$Read
 rts

ERNRDY comb
 ldb #E$NotRdy
 rts

ERWP comb
 ldb #E$WP
 rts
 emod
BTEND equ *
