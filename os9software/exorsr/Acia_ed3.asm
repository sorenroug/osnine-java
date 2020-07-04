 nam ACIA
 ttl Interrupt-Driven Acia driver

* Copyright 1982 by Microware Systems Corporation
* Reproduced Under License

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!

 use defsfile

***************
* Edition History

*  #   date    Comments
* -- -------- ----------------------------------------------------
*  3          Special edition for EXORciser

Edition equ 3 Current Edition

***************
* Interrupt-driven Acia Device Driver

INPSIZ set 100 input  buffer size (<=256)
OUTSIZ set 40 output buffer size (<=256)

IRQReq set %10000000 Interrupt Request

IRQIN equ %10000000 input IRQ enable
IRQOUT equ %00100000 output IRQ enable

**********
* Static storage offsets
*
 org V.SCF room for scf variables
u000F    rmb   2
u0011    rmb   2
u0013    rmb   2
u0015    rmb   2
u0017    rmb   2
u0019    rmb   2
INPBUF rmb INPSIZ input  buffer
OUTBUF rmb OUTSIZ output buffer
ACIMEM equ . Total static storage requirement

***************
* Module Header
 mod ACIEND,ACINAM,DRIVR+OBJCT,REENT+3,ACIENT,ACIMEM
 fcb UPDAT.
ACINAM fcs /acia/
 fcb Edition Current Revision

ACIENT lbra INIT
 lbra READ
 lbra WRITE
 lbra GETSTA
 lbra PUTSTA
 lbra TRMNAT

ACMASK fcb 0 no flip bits
 fcb IRQReq Irq polling mask
 fcb 5 (higher) priority


***************
* AcIRQ
*   process Interrupt (input or output) from Acia
*
* Passed: (U)=Static Storage addr
*         (X)=Port address
*         (A)=polled status
* Returns: Nothing
*
ACIRQ    ldy   V.PORT,u
         anda  #$7C
         ora   V.ERR,u
         sta   V.ERR,u
         lda   ,y
         bita  #$01
         bne   L0062
         ldx   <u0015,u
         cmpx  <u0013,u
         beq   L0053
         lda   ,x+
         cmpx  <u0019,u
         bcs   L0049
         leax  <OUTBUF,u
L0049    stx   <u0015,u
         sta   $01,y
         cmpx  <u0013,u
         bne   L0056
L0053    lbsr  L00E1
L0056    ldb   #$01
         lda   V.Wake,u
L005A    beq   L005F
         os9   F$Send
L005F    clr   V.Wake,u
         rts
L0062    lda   $01,y
         ldx   u000F,u
         sta   ,x+
         cmpx  <u0017,u
         bcs   L0070
         leax  <INPBUF,u
L0070    cmpx  <u0011,u
         bne   L007D
         ldb   #$20
         orb   V.ERR,u
         stb   V.ERR,u
         bra   L007F
L007D    stx   u000F,u
L007F    anda  #$7F
         beq   L0056
         cmpa  V.PCHR,u
         bne   L008F
         ldx   V.DEV2,u
         beq   L0056
         sta   $08,x
         bra   L0056
L008F    ldb   #$03
         cmpa  V.INTR,u
         beq   L009B
         ldb   #$02
         cmpa  V.QUIT,u
         bne   L0056
L009B    lda   V.LPRC,u
         bra   L005A

 ttl INTERRUPT-DRIVEN Acia device routines
 pag
***************
* Init
*   Initialize (Terminal) Acia
*
INIT ldx V.PORT,U I/o port address
 ldb #$03 master reset signal
 stb 0,X reset acia
 lda M$OPT,Y option byte count
 cmpa #PD.PAR-PD.OPT acia control value given?
 blo INIT10 ..no; default $15
 ldb PD.PAR-PD.OPT+M$DTYP,Y
 bne INIT20
INIT10    ldb   #$15
INIT20    stb   V.TYPE,u
 ldd V.PORT,U
 leax ACMASK,PCR
 leay ACIRQ,PCR address of interrupt service routine
 OS9 F$IRQ Add to IRQ polling table
         bcs   INIT9
         leax  <INPBUF,u
         stx   u000F,u
         stx   <u0011,u
         leax  INPSIZ,x
         stx   <u0017,u
         leax  <OUTBUF,u
         stx   <u0013,u
         stx   <u0015,u
         leax  OUTSIZ,x
         stx   <u0019,u
L00E1    ldb   V.TYPE,u
 orb #IRQIN enable acia input interrupts
         stb   [<V.PORT,u]
INIT9    rts

***************
* Read
*   return One Byte of input from the Acia
*
* Passed: (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: (A)=input Byte (carry clear)
*     or   CC=Set, B=Error code if error
*
READ00    bsr   ACSLEP
READ    ldx   <u0011,u
         orcc  #$10
         cmpx  u000F,u
         beq   READ00
         lda   ,x+
         cmpx  <u0017,u
         bcs   L00FE
         leax  <INPBUF,u
L00FE    stx   <u0011,u
         clrb
         ldb   V.ERR,u
         beq   READ90
         stb   <$3A,y
         clr   V.ERR,u
 comb return carry set
 ldb #E$RD signal read error
READ90 andcc #^IRQM
 rts

**********
* Acslep - Sleep for I/O activity
*  This version Hogs Cpu if signal pending
*
* Passed: (cc)=Irq's Must be disabled
ACSLEP    pshs  x,b,a
         lda   V.BUSY,u
         sta   V.Wake,u
         andcc #$EF
         ldx   #$0000
         os9   F$Slep
         ldx   D.Proc
         ldb   <$36,x
         beq   ACSL90
         cmpb  #$03
         bls   ACSLER
ACSL90    clrb
         puls  pc,x,b,a

ACSLER leas 6,S Exit to caller's caller
 coma return carry set
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
WRIT00    bsr   ACSLEP
WRITE    ldx   <u0013,u
         sta   ,x+
         cmpx  <u0019,u
         bcs   WRIT10
         leax  <OUTBUF,u
WRIT10    orcc  #$10
         cmpx  <u0015,u
         beq   WRIT00
         stx   <u0013,u
         andcc #$EF
         lda   V.TYPE,u
         ora #IRQIN!IRQOUT enable input & output IRQs
         sta   [<V.PORT,u]
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
         bne   L016E
         ldd   u000F,u
         subd  <u0011,u
         beq   L016A
         bcc   L0165
         addd  #$0064
L0165    ldx   $06,y
         std   $01,x
         rts

L016A    comb
         ldb   #$F6
         rts

L016E    cmpa  #$06
         beq   Write90

PUTSTA    comb
         ldb   #$D0
         rts


***************
* Subroutine TRMNAT
*   Terminate Acia processing
*
* Passed: (U)=Static Storage
* returns: Nothing
*
TRMN00    bsr   ACSLEP
TRMNAT    ldx   D.Proc
 lda P$ID,X
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldx   <u0013,u
         orcc  #$10
         cmpx  <u0015,u
         bne   TRMN00
         lda   #$03
         sta   [<V.PORT,u]
         andcc #$EF
 ldx #0
 OS9 F$IRQ remove acia from polling tbl
 rts

         emod
ACIEND      equ   *
