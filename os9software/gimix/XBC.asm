         nam   XBC
         ttl   Driver Module

*       OS-9 XBC Winchester Disk Driver Module Source Code
*
*           Software For GIMIX/XEBEC Winchester Controller

         ifp1
         use   defsfile
         endc

 mod DSKEND,DSKNAM,DRIVR+OBJCT,REENT+1,DSKENT,DSKSTA
 fcb DIR.+SHARE.+PREAD.+PWRIT.+UPDAT.+EXEC.+PEXEC.
DSKNAM fcs "XBC"
 fcb 3 Edition telltale byte

HDCnt equ 2
 pag
*********************************************************************
*
* Static Storage
*
*
 org Drvbeg
 rmb Drvmem*HDCnt
u005B    rmb   1
CURDRV    rmb   1
CURTBL    rmb   2
u005F    rmb   1
u0060    rmb   1
V.DCB0    rmb   1
V.DCB1    rmb   1
V.BUF    rmb   1
u0064    rmb   1
u0065    rmb   1
DRVSLCT    rmb   1
u0067    rmb   2
u0069    rmb   1
u006A    rmb   1
u006B    rmb   1
u006C    rmb   1
u006D    rmb   4

DSKSTA     equ   .

DSKENT lbra INIDSK Initialize i/o
 lbra READSK Read sector
 lbra WRTDSK Write sector
 lbra GETSTA Get status call
 lbra PUTSTA
 lbra TERMNT Terminate device use

HDMASK fcb 0 no flip bits
 fcb $80 Irq polling mask
 fcb $01 Priority

* XEBEC S-1410 opcodes
F.DRVRDY equ $00  Test drive ready command
F.STATUS equ $03 Status sense command
F.FORMAT equ $04 Format command
F.READ equ $08 Read sectors command
F.WRIT equ $0A Write sectors command
F.SEEK equ $0B Seek command
F.INITL equ $0C Initialize disk size command

RPORT0 equ $00
RPORT1 equ $01
RPORT2 equ $02
RPORT3 equ $03
WPORT0 equ $00
WPORT1 equ $01
WPORT2 equ $02
WPORT3 equ $03


DRIVE0 equ $00
DRIVE1 equ $20

****************************************************************
*
* Initialize The I/O Port
*
*  Input: (U)= Pointer To Global Storage
*
INIDSK ldx V.PORT,U Point to i/o port
 clra
         sta   WPORT0,x
         sta   <u005F,u
         sta   <V.DCB1,u
         sta   <u0060,u
         ldb   #$80
         stb   WPORT0,x
         sta   WPORT0,x
 leay DRVBEG,U Point to first drive table
 lda #HDCnt
 sta V.NDRV,U Inz number of drives
 ldb #$FF
 stb CURDRV,u
INILUP stb DD.TOT,y Inz to non-zero
 stb V.TRAK,Y Inz to high track count
 leay DRVMEM,Y Point to next drive table
 deca DONE
 bne INILUP ...no; inz more.
 leay ,x Point to i/o port
 tfr y,d
 leax  >HDMASK,pcr
 leay  >IRQSVC,pcr
 os9 F$IRQ
 bcs RETRN1
 clrb
RETRN1 rts

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
READSK tstb Could this be sector zero?
 bne RDDSK3 No.. too high
 cmpx #0 Is this sector zero?
 bne RDDSK3
 bsr RDDSK3
 bcs WRERR9
 pshs y,x
 ldx V.BUF,u
 ldy CURTBL,U
 ldb #DD.SIZ-1
READ01 lda B,X
 sta B,Y
 decb
 bpl READ01
 clrb
 puls y,x
WRERR9 rts

RDDSK3 bsr SELECT
 bcs WRERR9
 lda #F.READ   Read command
 lbra  L0134

WRTDSK    bsr   SELECT
         bcs   WRERR9
         lda   #F.WRIT   Write command
         lbra  L0134
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
 lbhs ERUNIT ..no; report error.
 pshs y,x,b
 ldx PD.BUF,y
 stx V.BUF,U Save for future use
 cmpa CURDRV,u
 beq   L00EC Already current drive
 sta CURDRV,U
 leax DRVBEG,U Table beginning
 ldb #DRVMEM
 mul OFFSET For this drive
 leax D,X
 stx <CURTBL,u
         clr   V.TRAK,x
         ldb   <$23,y
         pshs  b
         andb  #DRIVE1
         stb   <DRVSLCT,u
         puls  b
         andb  #$1F
         stb   <V.DCB0,u
         bitb  <u005F,u
         bne   L00EC
         lda   #F.INITL   Init drive
         leax  >DRVCHRS,pcr
         bsr   L0134
         bcc   L00E1
         puls  x,a
         bra   L0126

L00E1    ldb   <$23,y
         andb  #$1F
         orb   <u005F,u
         stb   <u005F,u
L00EC    puls  x,b
         ldy   <CURTBL,u
         cmpb  ,y
         bcs   L00FF
         cmpx  $01,y
         bcs   L00FF
         coma
         ldb   #E$Sect
         bra   L0126
L00FF    lda   #$01
         sta   <u0069,u
         lda   #$04
         sta   <u006A,u
         lda   <V.DCB0,u
         ora   #$60
         sta   <V.DCB0,u
         ldy   ,s
         pshs  b
         ldb   <$23,y
         andb  #DRIVE1
         orb   ,s
         stb   <DRVSLCT,u
         puls  b
         clra
         stx   <u0067,u
L0126    puls  pc,y


ERUNIT comb
 ldb #E$UNIT Error: illegal unit (drive)
 rts

* Drive characteristics
DRVCHRS fdb $0132  Number of cylinders
 fcb 6     Number of heads
 fdb $0132  Starting reduced write current cylinder
 fdb $0132  Starting write precompensation cylinder
 fcb 11     Maximum error burst length

* Send command to disk
L0134 pshs y,x
 ldy V.PORT,U Point to i/o port
         sta   <u0065,u
         cmpa  #F.STATUS
         beq   L0148
         cmpa  #F.INITL
         bcs   L016C
         cmpa  #$0D
         bne   L0157
L0148    inc   <u0060,u
         bsr   L0188
         clr   <u0060,u
         ldx   ,s
         lbsr  L01D7
         bra   L0167
* Initialize drive
L0157    cmpa  #F.INITL
         bne   L016C
         inc   <u0060,u
         bsr   L0188
         clr   <u0060,u
         ldx   ,s
         bsr   L01C6
L0167    lbsr  L01E9
         bra   L017C

L016C    lda   V.BUSY,u
         sta   V.WAKE,u
         bsr   L0188
L0172    ldx   #0
         os9   F$Sleep
         lda   V.WAKE,u
         bne   L0172
L017C    lda   #$02
         bita  <u005B,u
         beq   L0186
         lbsr  L01FB
L0186    puls  pc,y,x

L0188    ldd   <V.DCB1,u
         sta   $01,y
         stb   $02,y
         lda   <u0064,u
         sta   $03,y
         lda   <V.DCB0,u
         sta   WPORT0,y
         leax  <u0065,u
         ldb   #$04
L019E    bsr   L01E2
         lda   ,x+
         sta   $04,y
         decb
         bpl   L019E
         bsr   L01E2
         lda   ,x+
         tst   <u0060,u
         bne   L01C3
L01B0    ldb   <u006A
         beq   L01C0
         pshs  x
         ldx   #1
         os9   F$Sleep
         puls  x
         bra   L01B0

L01C0    incb
         stb   <u006A
L01C3    sta   $04,y
         rts
L01C6    bsr   L01E2
         bita  #$14
         bne   L01C6
L01CC    lda   ,x+
         sta   $04,y
         bsr   L01E2
         bita  #$04
         beq   L01CC
         rts

L01D7    lda   $04,y
         sta   ,x+
         bsr   L01E2
         bita  #$04
         beq   L01D7
         rts

* Wait for status
L01E2    lda   ,y
         bita  #$01
         beq   L01E2
         rts

L01E9    bsr   L01E2
         ldb   $04,y
         stb   <u005B,u
L01F0    bsr   L01E2
         bita  #$01
         beq   L01F0
         lda   $04,y
         bitb  #$02
         rts

L01FB    ldb   #$03
         stb   <u0065,u
         ldb   <V.DCB0,u
         andb  #$1F
         stb   <V.DCB0,u
         inc   <u0060,u
         lbsr  L0188
         clr   <u0060,u
L0211    bsr   L01E2
         bita  #$10
         beq   L0211
         leax  <u006B,u
         bsr   L01D7
         bsr   L01E9
         beq   L0225
         ldb   #$3F
         stb   <u006B,u
L0225    lda   <u006B,u
         anda  #$3F
         beq   L023F
         cmpa  #$18    Correctable data error
         beq   L023F
         leay  >ERRTBL,pcr
L0234    cmpa  ,y++
         beq   L023C
         tst   ,y
         bpl   L0234
L023C    comb
         ldb   -1,y
L023F    rts

***************
* process interrupt from controller
* Passed: (U)=Static Storage addr
*         (X)=Port address
*         (A)=polled status
* Returns: Nothing
*
IRQSVC ldy V.PORT,U Point to i/o port
         ldb   RPORT0,y
         bitb  #$40
         beq   L0269
         lda   V.WAKE,u
         beq   L0268
         ldb   <V.DCB0,u
         andb  #$1F
         stb   WPORT0,y
         tst   <u0060,u
         bne   L025B
         clr   <u006A
L025B    pshs  a
         bsr   L01E9
         puls  a
         ldb   #1
         clr   V.WAKE,u
         os9   F$Send
L0268    clrb
L0269    rts

ERRTBL   fcb   $01,E$NotRdy
         fcb   $02,E$Seek    No seek complete from disk drive
         fcb   $03,E$Write   Write fault from disk drive
         fcb   $04,E$NotRdy  Drive not ready after it was selected
         fcb   $06,E$Seek    Track 00 not found
         fcb   $10,E$Read    ID field read error
         fcb   $11,E$Read    Uncorrectable data error
         fcb   $12,E$Seek    Address mark not found
         fcb   $14,E$Seek    Target sector not found
         fcb   $19,E$Seek    Bad track flag detected
         fcb   $1A,E$BTyp    Format error
         fcb   $20,E$Unit    Invalid command
         fcb   $21,E$Sect    Illegal disk address
         fcb   $30,E$Write   Ram diagnostic failure
         fcb   $31,E$Read    Program memory checksum error
         fcb   $32,E$CRC     ECC diagnostic failuer
         fcb   $3F,E$DevBsy
         fcb   $FF,E$WP

************************************************************
*
* Put Status Call
* Y = Address of the path descriptor
*
*
PUTSTA ldx PD.RGS,Y Point to parameters
 ldb R$B,x
 cmpb #SS.Reset Restore call?
 beq RESTOR
 cmpb #SS.WTrk Write track call?
 beq WRTTRK
 cmpb #SS.DCmd
 lbeq L032F
GETSTA comb ...NO; Error
 ldb #E$UnkSvc Error code
 rts


RESTOR lbsr SELECT
         lda   <V.DCB0,u
         anda  #$1F
         ora   #$40
         sta   <V.DCB0,u
         lda   #$01
         lbra  L0134
WRTTRK ldd R$U,x Track number
         bne   L032D
         ldb   R$Y,x Side/density
         bne   L032D
         clrb
         ldx   #$0000
         lbsr  SELECT
         bcs   L032E
         lda   <V.DCB0,u
         anda  #$1F
         ora   #$40
         sta   <V.DCB0,u
         ldb   <DRVSLCT,u
         andb  #$E0
         stb   <DRVSLCT,u
         clra
         clrb
         std   <u0067,u
         lda   PD.ILV,y
         ldb   #$04     Step option
         std   <u0069,u Store interleave and stop option
L02E6    lda   #F.FORMAT
         lbsr  L0134
         bcc   L032D
         cmpb  #E$BTyp
         bne   L032E
         clra
         ldd   <u006D,u
         andb  #$E0
         addd  #$0020
         std   <u0067,u
         pshs  b,a
         ldb   <u006C,u
         andb  #$1F
         bcc   L031A
         adcb  #$00
         pshs  b
         lda   <u006C,u
         anda  #$40
         pshs  a
         orb   ,s
         puls  a
         stb   <DRVSLCT,u
         puls  b
L031A    puls  x
         ldy   <CURTBL,u
         cmpb  ,y
         bcs   L02E6
         cmpx  $01,y
         bcs   L02E6
         comb
         ldb   #E$DevBsy
         bra   L032E

L032D    clrb
L032E    rts

* Direct command to disk controller
L032F    pshs  y,x
         ldy   $06,x
         ldb   $05,y
         andb  #$1F
         ldx   $06,y
         ldy   $02,s
         lbsr  SELECT
         puls  y,x
         bcs   L032E
         ldy   $06,x
         ldd   ,y++
         ora   <V.DCB0,u
         std   <V.DCB0,u
         ldd   ,y++
         std   <V.BUF,u
         ldd   ,y++
         pshs  a
         sta   <u0065,u
         leay  $02,y
         ldd   ,y++
         std   <u0069,u
         puls  a
         ldx   $08,x
         lbra  L0134

Termnt ldy V.PORT,U Point to i/o port
 clr   WPORT0,y
 ldx   #0
 os9   F$IRQ
 rts
 emod
DSKEND      equ   *
