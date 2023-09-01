 nam ACIA
 ttl Interrupt-Driven Acia driver

 use defsfile

IRQReq set %10000000 Interrupt Request

INPSIZ set 200 input  buffer size (<=256)
OUTSIZ set 100 output buffer size (<=256)

IRQReq set %10000000 Interrupt Request
PARITY set %01000000 parity  error bit
OVERUN set %00100000 overrun error bit
FRAME  set %00010000 framing error bit

IRQIN equ %10000000 input IRQ enable
IRQOUT equ %00100000 output IRQ enable

INPERR set PARITY+OVERUN+FRAME

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $07
         mod   ACIEND,ACINAM,tylg,atrv,ACIENT,ACIMEM
u0000    rmb   1
u0001    rmb   2
u0003    rmb   1
u0004    rmb   1
u0005    rmb   1
Xu0006    rmb   3
u0009    rmb   1
u000A    rmb   1
u000B    rmb   1
u000C    rmb   1
u000D    rmb   1
u000E    rmb   1
Xu000F    rmb   1
Xu0010    rmb   1 V.XOFF
Xu0016    rmb   12
INXTI    rmb   1
INXTO    rmb   1
ONXTI    rmb   1
ONXTO    rmb   1
HALTED   rmb   1
INCNT    rmb   1
u0023    rmb   1
INHALT    rmb   1
u0025    rmb   1
u0026    rmb   1
u0027    rmb   3
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   1
u002E    rmb   1
INPBUF    rmb   INPSIZ
OUTBUF    rmb   OUTSIZ
ACIMEM     equ   .

* HALTED state conditions
H.XOFF equ 1 V.XOFF char has been received; awaiting V.XON
H.EMPTY equ 2 Output buffer is empty

 fcb UPDAT.
ACINAM     equ   *
         fcs   /acia/

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

INIT lbsr  L03C5
         clr   <u002A,u
 ldx V.PORT,U I/o port address
 ldb #$03 master reset signal
 stb 0,X reset acia
 ldb #H.EMPTY
 stb HALTED,U output IRQ's disabled; buffer empty
         clr   <u0025,u
         lda   <$11,y
         cmpa  #$1B
         bcs   INIT05
         ldb   <$2D,y
         stb   <u0025,u
INIT05    cmpa  #$1A
         bcs   L0056
         ldb   <$2C,y
         beq   L0056
         com   <u002A,u
         bsr   L009E
L0056    cmpa  #$14
         bcs   INIT10
         ldb   <$26,y
         bne   INIT20
INIT10    ldb   #$15
INIT20    stb   V.TYPE,u
         stb   ,x
         lda   $01,x
         lda   $01,x
         tst   ,x
         lbmi  ErrNtRdy
         clra
         clrb
         std   INXTI,U
         std   ONXTI,U
         sta   INHALT,U
         sta   INCNT,U
         sta   <u0026,u
         lda   #$01
         sta   <u0023,u
 ldd V.PORT,U
 leax ACMASK,PCR
 leay ACIRQ,PCR address of interrupt service routine
 OS9 F$IRQ Add to IRQ polling table
 bcs INIT9 Error - return it
 ldx V.PORT,U
 ldb V.TYPE,U
         orb   #$80
         stb   ,x
         clrb
INIT9    rts

L009E    pshs  y,b,a
         clr   <u0027,u
         clr   >$C190
         leay  >L00BA,pcr
         lbsr  L048D
         clra
         clrb
         std   >$C140
         ldd   #$0FFF
         std   >$C160
         puls  pc,y,b,a

L00BA    fcb $40,$80,$32,$00,$33,$12,$31,$03,$0C,$40,$00,$0C
         fcb $05,$3A,$01,$3B,$F0,$35,$06,$37,$14,$31,$01,$77

READ00   bsr ACSLEP
READ    lda   INHALT,U
         ble   Read.a
         ldb   INCNT,U
         cmpb  #$0A
         bhi   Read.a
         ldb   V.XON,U
         orb   #$80
         stb   INHALT,U
         ldb   V.TYPE,u
         orb   #$A0
         stb   [<V.PORT,U]
Read.a    ldb   INXTO,U
         leax  INPBUF,u
 orcc #IntMasks calm interrupts
 cmpb INXTI,U any data available?
 beq READ00
 abx
 lda 0,X the char
         dec   INCNT,U
 incb ADVANCE Next-out ptr
 cmpb #INPSIZ-1 end of circular buffer?
         bls   READ10
         clrb
READ10    stb   INXTO,U
         ldb   INCNT,U
         cmpb  #$0A
         bhi   L012E
         ldb   V.XON,U
         orb   V.XOFF,U
         bne   L012E
         tst   <u0025,u
         beq   L012E
         ldb   V.TYPE,u
         orb   #$80
         stb   <u0023,u
         tst   <u0026,u
         beq   L012B
         orb   #$20
L012B    stb   [<V.PORT,U]
L012E    clrb
         ldb   u000E,u
         beq   L013B
         stb   <$3C,y
         clr   u000E,u
         comb
         ldb   #$F4
L013B    andcc #$AF
         rts


**********
* Acslep - Sleep for I/O activity
*  This version Hogs Cpu if signal pending
*
* Passed: (cc)=Irq's Must be disabled
*         (U)=Global Storage
*         V.Busy,U=current proc id
* Destroys: possibly Pc
ACSLEP    pshs  x,b,a
         lda   u0004,u
         sta   u0005,u
         andcc #$AF
         ldx   #$0000
         os9   F$Sleep
         ldx   D.Proc
         ldb   <$36,x
         beq   L0157
         cmpb  #$03
         bls   ACSLER
L0157    clra
         lda   $0D,x
         bita  #$02
         bne   ACSLER
         puls  pc,x,b,a

ACSLER    leas  $06,s
         coma
         rts

WRIT00    bsr   ACSLEP
WRITE    tst   <u002A,u
         bpl   L0170
         lbsr  L0322
         bra   Write90
L0170    leax  >OUTBUF,u
         ldb   ONXTI,U
         abx
         sta   ,x
         incb
         cmpb  #OUTSIZ-1
         bls   WRIT10
         clrb
WRIT10 orcc #IntMasks disable interrupts
         cmpb  ONXTO,U
         beq   WRIT00
         stb   ONXTI,U
         lda   HALTED,U
         beq   L01AB
         anda  #$FD
         sta   HALTED,U
         bne   L01AB
         lda   V.TYPE,u
         ora   #$80
         sta   <u0026,u
         tst   <u0023,u
         beq   L01A6
         ora   #$20
         bra   L01A8
L01A6    ora   #$40
L01A8    sta   [<V.PORT,U]
L01AB    andcc #$AF
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
GETSTA cmpa #SS.Ready Ready status?
 bne GETS10 ..no
 lda   INXTO,U
 suba  INXTI,U get input character count
 bne   Write90

ErrNtRdy comb
 ldb #E$NotRdy
 rts

GETS10 cmpa #SS.EOF End of file?
 beq Write90 ..yes; return carry clear


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
TRMN00 lbsr ACSLEP wait for I/O activity
TRMNAT ldx D.Proc
 lda P$ID,X
 sta V.BUSY,U
 sta V.LPRC,U
 ldb ONXTI,U
 orcc #IntMasks disable interrupts
 cmpb ONXTO,U output done?
 bne TRMN00 ..no; sleep a bit
 lda V.TYPE,U
 sta [V.PORT,U] disable acia interrupts
 andcc #^IntMasks enable interrupts
 ldx #0
 OS9 F$IRQ remove acia from polling tbl
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
ACIRQ ldx V.PORT,U get port address
 tfr A,B copy status
 andb #INPERR mask status error bits
 orb V.ERR,U
 stb V.ERR,U update cumulative errors
 bita #5 input ready (or carrier lost)?
         bne   InIRQ
         lda   INHALT,U
         bpl   L020D
         anda  #$7F
         sta   $01,x
         eora  V.XON,U
         sta   INHALT,U
         lda   HALTED,U
         bne   L0237
         clrb
         rts
L020D    leay  >OUTBUF,u
         ldb   ONXTO,U
         cmpb  ONXTI,U
         beq   L022C
         clra
         lda   d,y
         incb
         cmpb  #$63
         bls   L0222
         clrb
L0222    stb   ONXTO,U
         sta   $01,x
         cmpb  ONXTI,U
         bne   WAKEUP
L022C    lda   HALTED,U
         ora   #$02
         sta   HALTED,U
         clr   <u0026,u
L0237    ldb   V.TYPE,u
         orb   #$80
         tst   <u0023,u
         bne   L0242
         orb   #$40
L0242    stb   ,x

WAKEUP ldb #S$Wake Wake up signal
 lda V.Wake,U Owner waiting?
Wake10 beq Wake90 ..no; return
 OS9 F$Send send signal
Wake90 clr V.Wake,U
 rts

InIRQ    tfr   a,b
         lda   $01,x
         bitb  #$04
         bne   WAKEUP
         tfr   a,b
         andb  #$7F
         beq   InIRQ1
         cmpb  #$20
         bcc   InIRQ1
         tst   u000E,u
         bne   InIRQ1
         cmpb  V.XOFF,U
         lbeq  InXOFF
         cmpb  V.XON,U
         lbeq  InXON
         cmpb  u000B,u
         beq   InAbort
         cmpb  u000C,u
         beq   InQuit
         cmpb  u000D,u
         beq   InPause
InIRQ1    leax  INPBUF,u
         ldb   INXTI,U
         abx
         sta   ,x
         inc   INCNT,U
         incb
         cmpb  #$C7
         bls   L0291
         clrb
L0291    cmpb  INXTO,U
         bne   L02A1
         dec   INCNT,U
         ldb   #$20
         orb   u000E,u
         stb   u000E,u
         bra   WAKEUP
L02A1    stb   INXTI,U
         ldb   INCNT,U
         cmpb  #$BE
         bcs   WAKEUP
         lda   V.XOFF,U
         ora   V.XON,U
         bne   L02C3
         tst   <u0025,u
         beq   WAKEUP
         lda   V.TYPE,u
         ora   #$C0
         sta   [<V.PORT,U]
         clr   <u0023,u
         bra   WAKEUP
L02C3    lda   V.XOFF,U
         lbeq  WAKEUP
         ldb   INHALT,U
         lbne  WAKEUP
         anda  #$7F
         sta   V.XOFF,U
         ora   #$80
         sta   INHALT,U
         ldb   V.TYPE,u
         orb   #$A0
         stb   [<V.PORT,U]
         lbra  WAKEUP
InAbort    ldb   #$03
         bra   InQuit10

InQuit    ldb   #$02
InQuit10    pshs  a
         lda   u0003,u
         lbsr  Wake10
         puls  a
         bra   InIRQ1

***************
* Control character routines

InPause ldx V.DEV2,U get echo device static ptr
 beq InIRQ1 ..None; buffer char, exit
 sta V.PAUS,X request pause
 bra InIRQ1 buffer char, exit

InXOFF    lda   HALTED,U
         bne   L0309
         ldb   V.TYPE,u
         orb   #$80
         stb   ,x
L0309    ora   #$01
         sta   HALTED,U
         clrb
         rts

InXON    lda   HALTED,U
         anda  #$FE
         sta   HALTED,U
         bne   L0320
         lda   V.TYPE,u
         ora   #$A0
         sta   ,x
L0320    clrb
         rts

L0322    anda  #$7F
         lbsr  L04CC
         tst   <u002B,u
         bne   L0374
         cmpa  #$20
         bcc   L0351
         cmpa  #$1B
         bne   L0337
         sta   <u002B,u
L0337    cmpa  #$0D
         lbeq  L03FC
         cmpa  #$0A
         lbeq  L0472
         cmpa  #$0C
         lbeq  L0405
         cmpa  #$08
         lbeq  L0410
         bra   L0369
L0351    leay  >L036D,pcr
         lbsr  L048D
         lbsr  L04D9
         ldx   >$C178
         cmpx  #$01FE
         bcs   L0369
         lbsr  L0438
         lbsr  L042F
L0369    lbsr  L04C6
         rts

L036D    fcb $00,$0A
         fcb   $01
         fcb $03,$16
         fcb   $02,$77

L0374    tst   <$2C,u
         bne   L0386
         cmpa  #$54

         beq   L03D2
         sta   <u002C,u
         bra   L0369
L0386    tst   <u002D,u
         bne   L038C
         sta   <u002D,u
         bra   L0369
L038C    sta   <u002E,u
         lda   <u002C,u
         cmpa  #$3D
         bne   L03C0
         lda   <u002D,u
         suba  #$20
         sta   <u002D,u
L039E    lda   #$18
         suba  <u002D,u
         bmi   L0369
         ldb   #$14
         mul
         addd  #$0010
         lbsr  L04DC
         std   >$C17A
         lda   <u002E,u
         suba  #$20
         cmpa  #$54
         bhi   L03C0
         ldb   #$06
         mul
         std   >$C178
L03C0    bsr   L03C5
         lbra  L0369
L03C5    clr   <u002B,u
         clr   <u002C,u
         clr   <u002D,u
         clr   <u002E,u
         rts
L03D2    lbsr  L04DC
         ldd   >$C178
         pshs  b,a
         clra
         lbsr  L04D9
L03DE    lda   #$0A
         lbsr  L04D9
         ldd   >$C178
         cmpd  #$01FE
         bcs   L03DE
         puls  b,a
         std   >$C178
         lda   #$01
         lbsr  L04D9
         lbsr  L03C5
         lbra  L0369
L03FC    lbsr  L04DC
         lbsr  L04D9
         lbra  L0369
L0405    ldx   >$C178
         leax  $06,x
         stx   >$C178
         lbra  L0369
L0410    ldx   >$C178
         beq   L041D
         leax  -$06,x
         stx   >$C178
         lbra  L0369
L041D    ldx   >$C17A
         leax  <$14,x
         stx   >$C17A
         ldd   #$01F8
         std   >$C178
         lbra  L0369
L042F    lbsr  L04DC
         lda   #$0D
         lbsr  L04D9
         rts
L0438    lbsr  L04DC
         ldd   >$C17A
         cmpd  #$0010
         bhi   L0486
         ldd   #$01EC
         std   >$C17A
         ldd   >$C178
         pshs  b,a
         clra
         clrb
         std   >$C178
         leay  >L0477,pcr
         lbsr  L048D
         puls  b,a
         std   >$C178
         lda   <u0027,u
         suba  #$05
         sta   <u0027,u
         sta   >$C180
         ldd   #$0010
         std   >$C17A
         rts
L0472    bsr   L0438
         lbra  L0369

L0477    fcb $00,$33,$05,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$01,$33,$12,$77

L0486    subd  #$0014
         std   >$C17A
         rts

L048D    pshs  u,x,b,a
         ldx   #$C170
L0492    clrb
         lda   ,y+
         cmpa  #$20
         bcs   L04AF
         cmpa  #$7F
         bhi   L04AF
         tfr   a,b
         anda  #$F0
         cmpa  #$30
         beq   L04AB
         cmpa  #$40
         beq   L04B9
         puls  pc,u,x,b,a
L04AB    andb  #$0F
L04AD    lda   ,y+
L04AF    sta   b,x
L04B1    lda   $0F,x
         bita  #$04
         beq   L04B1
         bra   L0492
L04B9    ldb   #$10
         bra   L04AD

L04BD    fcb $03,$8C,$02,$10,$03,$16,$8A,$02,$77

L04C6    pshs  x,d
         lda   #$01
         bra   L04CF
L04CC    pshs  x,b,a
         clra
L04CF    bsr   L04D9
         leay  >L04BD,pcr
         bsr   L048D
         puls  pc,x,b,a
L04D9    sta   >$C170
L04DC    pshs  a
L04DE    lda   >$C170
         bita  #$04
         beq   L04DE
         puls  pc,a
         emod
ACIEND      equ   *
