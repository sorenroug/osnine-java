         nam   ACIA
         ttl   os9 device driver


 use defsfile

Edition equ 3 Current Edition

***************
* Interrupt-driven Acia Device Driver

INPSIZ set 80 input  buffer size (<=256)
OUTSIZ set 140 output buffer size (<=256)

IRQReq set %10000000 Interrupt Request
PARITY set %01000000 parity  error bit
OVERUN set %00100000 overrun error bit
FRAME set %00010000 framing error bit
NOTCTS set %00001000 not clear to send
DCDLST set %00000100 data carrier lost


tylg     set   Drivr+Objct
atrv     set   ReEnt+1

         mod   ACIEND,ACINAM,tylg,atrv,ACIENT,ACIMEM

**********
* Static storage offsets
*
 org V.SCF room for scf variables
INXTI    rmb   1
INXTO    rmb   1
INCNT    rmb   1
ONXTI    rmb   1
ONXTO    rmb   1
HALTED   rmb   1
INHALT    rmb   1
u0024    rmb   1
u0025    rmb   1
u0026    rmb   1
INPBUF rmb INPSIZ input  buffer
OUTBUF rmb OUTSIZ output buffer
ACIMEM equ . Total static storage requirement


 fcb UPDAT.
ACINAM     equ   *
         fcs   /ACIA/
         fcb   $03

ACIENT    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT

ACMASK fcb 0 no flip bits
 fcb IRQReq Irq polling mask
 fcb 10 (higher) priority

 ttl INTERRUPT-DRIVEN Acia device routines
 pag
***************
* Init
*   Initialize (Terminal) Acia
*
INIT ldx V.PORT,U I/o port address
 ldb #$03 master reset signal
 stb 0,X reset acia
         ldb   #$02
         stb   HALTED,u
         clr   <u0024,u
         lda   <$11,y
         cmpa  #$1B
         bcs   INIT05
         ldb   <$2C,y
         stb   <u0024,u
INIT05    cmpa  #$14
         bcs   L004C
         ldb   <$26,y
         bne   L004E
L004C    ldb   #$15
L004E    stb   V.TYPE,u
         stb   ,x
         lda   $01,x
         lda   $01,x
         tst   ,x
         lbmi  ErrNtRdy
         clra
         clrb
         std   INXTI,u
         std   ONXTI,u
         sta   <INHALT,u
         sta   <INCNT,u
         sta   <u0026,u
         lda   #$01
         sta   <u0025,u
         ldd   V.PORT,U
         leax  ACMASK,pcr
         leay  ACIRQ,pcr
         os9   F$IRQ
         bcs   L008A
         ldx   V.PORT,U
         ldb   V.TYPE,u
         orb   #$80
         stb   ,x
         clrb
L008A    rts


***************
* Read
*   return One Byte of input from the Acia
*
* Passed: (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: (A)=input Byte (carry clear)
*     or   CC=Set, B=Error code if error
*
L008B    bsr   ACSLEP
READ    lda   <INHALT,u
         ble   Read.a
         ldb   <INCNT,u
         cmpb  #$0A
         bhi   Read.a
         ldb   V.XON,u
         orb   #$80
         stb   <INHALT,u
         ldb   V.TYPE,u
         orb   #$A0
         stb   [V.PORT,U]
Read.a    ldb   <INXTO,u
         leax  <INPBUF,u
         orcc  #$50
         cmpb  INXTI,u
         beq   L008B
         abx
         lda   ,x
         dec   <INCNT,u
         incb
         cmpb  #$4F
         bls   L00C0
         clrb
L00C0    stb   <INXTO,u
         ldb   <INCNT,u
         cmpb  #$0A
         bhi   L00E7
         ldb   V.XON,u
         orb   V.XOFF,u
         bne   L00E7
         tst   <u0024,u
         beq   L00E7
         ldb   V.TYPE,u
         orb   #$80
         stb   <u0025,u
         tst   <u0026,u
         beq   L00E4
         orb   #$20
L00E4    stb   [V.PORT,U]
L00E7    clrb
         ldb   V.ERR,u
         beq   L00F4
         stb   <$3A,y
         clr   V.ERR,u
         comb
         ldb   #$F4
L00F4    andcc #$AF
         rts

ACSLEP    pshs  x,b,a
         lda   V.BUSY,u
         sta   V.WAKE,u
         andcc #$AF
         ldx   #$0000
         os9   F$Sleep
         ldx   D.Proc
         ldb   <$19,x
         beq   L0110
         cmpb  #$03
         bls   ACSLER
L0110    clra
         lda   $0C,x
         bita  #$02
         bne   ACSLER
         puls  pc,x,b,a

ACSLER    leas  $06,s
         coma
         rts

***************
* Write
*   Write char Through Acia
*
* Passed: (A)=char to write
*         (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: CC=Set If Busy (output buffer Full)
*
L011D    bsr   ACSLEP
WRITE    leax  OUTBUF,u
         ldb   ONXTI,u
         abx
         sta   ,x
         incb
         cmpb  #$8B
         bls   L012E
         clrb
L012E    orcc  #$50
         cmpb  ONXTO,u
         beq   L011D
         stb   ONXTI,u
         lda   HALTED,u
         beq   Write80
         anda  #$FD
         sta   HALTED,u
         bne   Write80
         lda   V.TYPE,u
         ora   #$80
         sta   <u0026,u
         tst   <u0025,u
         beq   L0154
         ora   #$20
         bra   L0156
L0154    ora   #$40
L0156    sta   [V.PORT,U]
Write80    andcc #$AF
Write90    clrb
         rts

***************
* Getsta/Putsta
*   Get/Put Acia Status
*
* Passed: (A)=Status Code
*         (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: varies
GETSTA    cmpa  #$01
         bne   L016D
         lda   <INXTO,u
         suba  INXTI,u
         bne   Write90
ErrNtRdy    comb
         ldb   #$F6
         rts

L016D    cmpa  #$06
         beq   Write90

PUTSTA comb return carry set
 ldb #E$UnkSvc Unknown service code
 rts

***************
* Subroutine TRMNAT
*   Terminate Acia processing
*
* Passed: (U)=Static Storage
* returns: Nothing
*
L0175    bsr   ACSLEP
TRMNAT    ldx   D.Proc
         lda   ,x
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldb   ONXTI,u
         orcc  #$50
         cmpb  ONXTO,u
         bne   L0175
         lda   V.TYPE,u
         sta   [V.PORT,U]
         andcc #$AF
         ldx   #$0000
         os9   F$IRQ
         rts


***************
* AcIRQ
*   process Interrupt (input or output) from Acia
*
* Passed: (U)=Static Storage addr
*         (X)=Port address
*         (A)=polled status
* Returns: Nothing
*
ACIRQ    ldx   V.PORT,U
         tfr   a,b
         andb  #$7C
         orb   V.ERR,u
         stb   V.ERR,u
         bita  #$05
         bne   InIRQ

OutIRQ   lda   <INHALT,u
         bpl   OutI.a
         anda  #$7F
         sta   $01,x
         eora  V.XON,u
         sta   <INHALT,u
         lda   HALTED,u
         bne   L01E3
         clrb
         rts
OutI.a    leay  <OUTBUF,u
         ldb   ONXTO,u
         cmpb  ONXTI,u
         beq   L01D8
         clra
         lda   d,y
         incb
         cmpb  #$8B
         bls   OutIRQ1
         clrb
OutIRQ1    stb   ONXTO,u
         sta   $01,x
         cmpb  ONXTI,u
         bne   WAKEUP
L01D8    lda   HALTED,u
         ora   #$02
         sta   HALTED,u
         clr   <u0026,u
L01E3    ldb   V.TYPE,u
         orb   #$80
         tst   <u0025,u
         bne   L01EE
         orb   #$40
L01EE    stb   ,x

WAKEUP    ldb   #$01
         lda   V.WAKE,u
L01F4    beq   L01F9
         os9   F$Send
L01F9    clr   V.WAKE,u
         rts


***************
* Inacia
*   process Acia input Interrupt
*
* Passed: (A)=Acia Status Register data
*         (X)=Acia port address
*         (U)=Static Storage address
*
* Notice the Absence of Error Checking Here
*
InIRQ    ldb   $01,x
         bita  #$04
         bne   WAKEUP
         tfr   b,a
         andb  #$7F
         beq   InIRQ1
         cmpb  V.XOFF,u
         lbeq  L029C
         cmpb  V.XON,u
         lbeq  InXON
         cmpb  V.INTR,u
         beq   L0283
         cmpb  V.QUIT,u
         beq   L0287
         cmpb  V.PCHR,u
         beq   InPause
InIRQ1    leax  <INPBUF,u
         ldb   INXTI,u
         abx
         sta   ,x
         inc   <INCNT,u
         incb
         cmpb  #$4F
         bls   L0233
         clrb
L0233    cmpb  <INXTO,u
         bne   L0243
         dec   <INCNT,u
         ldb   #$20
         orb   V.ERR,u
         stb   V.ERR,u
         bra   WAKEUP

L0243    stb   INXTI,u
         ldb   <INCNT,u
         cmpb  #$46
         bcs   WAKEUP
         lda   V.XOFF,u
         ora   V.XON,u
         bne   L0265
         tst   <u0024,u
         beq   WAKEUP
         lda   V.TYPE,u
         ora   #$C0
         sta   [V.PORT,U]
         clr   <u0025,u
         bra   WAKEUP

L0265    lda   V.XOFF,u
         beq   WAKEUP
         ldb   <INHALT,u
         bne   WAKEUP
         anda  #$7F
         sta   V.XOFF,u
         ora   #$80
         sta   <INHALT,u
         ldb   V.TYPE,u
         orb   #$A0
         stb   [V.PORT,U]
         lbra  WAKEUP
L0283    ldb   #$03
         bra   L0289
L0287    ldb   #$02
L0289    pshs  a
         lda   V.LPRC,u
         lbsr  L01F4
         puls  a
         bra   InIRQ1
InPause    ldx   V.DEV2,u
         beq   InIRQ1
         sta   $08,x
         bra   InIRQ1

L029C    lda   HALTED,u
         bne   L02A7
         ldb   V.TYPE,u
         orb   #$80
         stb   ,x
L02A7    ora   #$01
         sta   HALTED,u
         clrb
         rts

InXON    lda   HALTED,u
         anda  #$FE
         sta   HALTED,u
         bne   L02BE
         lda   V.TYPE,u
         ora   #$A0
         sta   ,x
L02BE    clrb
         rts
         emod
ACIEND      equ   *
