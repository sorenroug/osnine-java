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

IRQIN equ %10000000 input IRQ enable
IRQOUT equ %00100000 output IRQ enable

INPERR set PARITY+OVERUN+FRAME+NOTCTS+DCDLST

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

* HALTED state conditions
H.XOFF equ 1 V.XOFF char has been received; awaiting V.XON
H.EMPTY equ 2 Output buffer is empty

***************
* Module Header
 mod ACIEND,ACINAM,DRIVR+OBJCT,REENT+1,ACIENT,ACIMEM

 fcb UPDAT.
ACINAM fcs "ACIA"
         fcb 3

ACIENT lbra INIT
 lbra READ
 lbra WRITE
 lbra GETSTA
 lbra PUTSTA
 lbra TRMNAT

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
 ldb #H.EMPTY
 stb HALTED,U output IRQ's disabled; buffer empty
         clr   <u0024,u
         lda   <$11,y
         cmpa  #$1B
         bcs   INIT05
         ldb   <$2C,y
         stb   <u0024,u
INIT05 cmpa #PD.PAR-PD.OPT acia control value given?
 blo INIT10 ..no; default $15
 ldb PD.PAR-PD.OPT+M$DTYP,Y
 bne INIT20
INIT10 ldb #$15 default acia control
INIT20 stb V.TYPE,U save device type
 stb 0,X init acia
 lda 1,X
 lda 1,X remove any interrupts
 tst 0,X interrupt gone?
 lbmi ErrNtRdy ..No; abort
 clra
 clrb
 std INXTI,U Initialize buffer ptrs
 std ONXTI,U
 sta INHALT,U flag input not halted
 sta INCNT,U clear in char count
         sta   <u0026,u
         lda   #$01
         sta   <u0025,u
 ldd V.PORT,U
 leax ACMASK,PCR
 leay ACIRQ,PCR address of interrupt service routine
 OS9 F$IRQ Add to IRQ polling table
 bcs INIT9 Error - return it
 ldx V.PORT,U
 ldb V.TYPE,U
 orb #IRQIN enable acia input interrupts
 stb 0,X initialize acia for input interrupts
 clrb
INIT9 rts


***************
* Read
*   return One Byte of input from the Acia
*
* Passed: (Y)=Path Descriptor
*         (U)=Static Storage address
* returns: (A)=input Byte (carry clear)
*     or   CC=Set, B=Error code if error
*
READ00 bsr ACSLEP
READ lda INHALT,U is input halted?
 ble Read.a branch if not
 ldb INCNT,U get input character count
 cmpb #10 less than 10 chars in buffer?
 bhi Read.a branch if not
 ldb V.XON,U get X-ON char
 orb #Sign set sign bit
 stb INHALT,U flag input resume
 ldb V.TYPE,U get control value
 orb #IRQIN!IRQOUT enable input & output IRQs
 stb [V.PORT,U] set control register
Read.a ldb INXTO,U (input buffer) next-out ptr
 leax INPBUF,U address of input buffer
 orcc #IntMasks calm interrupts
 cmpb INXTI,U any data available?
 beq READ00
 abx
 lda 0,X the char
 dec INCNT,U decrement char count
 incb ADVANCE Next-out ptr
 cmpb #INPSIZ-1 end of circular buffer?
 bls READ10 ..no
 clrb reset ptr to start of buffer
READ10 stb INXTO,U save updated buffer ptr
 ldb INCNT,U get input character count
 cmpb #10 less than 10 chars in buffer?
         bhi   L00E7
         ldb   V.XON,u
         orb   V.XOFF,u
         bne   L00E7
         tst   <u0024,u
         beq   L00E7
         ldb   V.TYPE,u
         orb   #IRQIN
         stb   <u0025,u
         tst   <u0026,u
         beq   L00E4
         orb   #IRQOUT
L00E4    stb   [V.PORT,U]
L00E7    clrb
 ldb V.ERR,U Transmission error?
 beq READ90 ..no; return
 stb PD.ERR,Y return error bits in pd
 clr V.ERR,U
 comb return carry set
 ldb #E$Read signal read error
READ90 andcc #^IntMasks enable IRQ requests
 rts

**********
* Acslep - Sleep for I/O activity
*  This version Hogs Cpu if signal pending
*
* Passed: (cc)=Irq's Must be disabled
*         (U)=Global Storage
*         V.Busy,U=current proc id
* Destroys: possibly Pc
ACSLEP pshs D,X
 lda V.BUSY,U get current process id
 sta V.Wake,U arrange wake up signal
 andcc #^IntMasks interrupts ok now
 ldx #0
 OS9 F$Sleep wait for input data
 ldx D.Proc
 ldb P$Signal,X signal present?
 beq ACSL90 ..no; return
 cmpb #S$Intrpt Deadly signal?
 bls ACSLER ..yes; return error
ACSL90 clra clear carry
 lda P$State,X check process state flags
 bita #Condem has process died?
 bne ACSLER ..Yes; return error
 puls D,X,PC return

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
WRIT00 bsr ACSLEP sleep a bit
WRITE leax OUTBUF,U output buffer address
 ldb ONXTI,U (output) next-out ptr
 abx
 sta 0,X Put char in buffer
 incb ADVANCE the ptr
 cmpb #OUTSIZ-1 end of circular buffer?
 bls WRIT10 ..no
 clrb reset ptr to start of buffer
WRIT10 orcc #IntMasks disable interrupts
 cmpb ONXTO,U buffer full?
 beq WRIT00 ..yes; sleep and retry
 stb ONXTI,U save updated next-in ptr
 lda HALTED,U output already enabled?
 beq Write80 ..yes; don't re-enable
 anda #^H.EMPTY no longer halted due to empty
 sta HALTED,U
 bne Write80 ..Still HALTED; don't enable IRQ
 lda V.TYPE,U Parity control
         ora   #IRQIN
         sta   <u0026,u
         tst   <u0025,u
         beq   L0154
         ora   #IRQOUT
         bra   L0156
L0154    ora   #$40
L0156    sta [V.PORT,U] Enable output interrupts
Write80 andcc #^IntMasks enable IRQs
Write90 clrb (return carry clear)
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
TRMN00 bsr ACSLEP wait for I/O activity
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
 bne InIRQ ..yes; go get it
* Fall Through to Do output

****************
* OutIRQ
*   output to Acia Interrupt Routine
*
* Passed: (A)=Acia Status Register Contents
*         (X)=Acia port address
*         (U)=Static Storage address

OutIRQ lda INHALT,U send X-ON or X-OFF?
 bpl OutI.a branch if not
 anda #^Sign clear sign bit
 sta 1,X send character
 eora V.XON,U get zero if X-ON
 sta INHALT,U mark it sent
 lda HALTED,U is output halted?
 bne OutIRQ3 branch if so
 clrb clear carry
 rts
OutI.a    leay  <OUTBUF,u
 ldb ONXTO,U (output) next-out ptr
 cmpb ONXTI,U output buffer already empty?
 beq OutIRQ2 ..yes; disable output IRQ, return
 clra
 lda D,Y next output char
 incb ADVANCE Next-out ptr
 cmpb #OUTSIZ-1 end of circular buffer?
 bls OutIRQ1 ..no
 clrb
OutIRQ1 stb ONXTO,U save updated next-out ptr
 sta 1,X Write the char
 cmpb ONXTI,U last char in output buffer?
 bne WAKEUP ..no
OutIRQ2 lda HALTED,U
 ora #H.EMPTY
 sta HALTED,U
         clr   <u0026,u
OutIRQ3 ldb V.TYPE,U
 orb #IRQIN disable output IRQs
         tst   <u0025,u
         bne   L01EE
         orb   #$40
L01EE    stb   ,x

WAKEUP ldb #S$Wake Wake up signal
 lda V.Wake,U Owner waiting?
Wake10 beq Wake90 ..no; return
 OS9 F$Send send signal
Wake90 clr V.Wake,U
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
InIRQ ldb 1,X Read input char
         bita  #$04
         bne   WAKEUP
         tfr   b,a
 andb #$7F clear b7
         beq   InIRQ1
         cmpb  V.XOFF,u
         lbeq  InXOFF
         cmpb  V.XON,u
         lbeq  InXON
 cmpb V.INTR,U keyboard Interrupt?
 beq InAbort ..Yes
 cmpb V.QUIT,U keyboard Quit?
 beq InQuit ..Yes
 cmpb V.PCHR,U keyboard Pause?
 beq InPause ..Yes

InIRQ1 leax INPBUF,U input buffer
 ldb INXTI,U (input) next-in ptr
 abx
 sta 0,X save char in buffer
         inc   <INCNT,u
 incb update Next-in ptr
 cmpb #INPSIZ-1 end of circular buffer?
 bls InIRQ2 ..no
 clrb
InIRQ2 cmpb INXTO,U input overrun?
 bne InIRQ30 ..no; good
         dec   <INCNT,u
 ldb #OVERUN mark overrun error
 orb V.ERR,U
 stb V.ERR,U
 bra WakeUp throw away character

InIRQ30 stb INXTI,U update next-in ptr
         ldb   <INCNT,u
         cmpb  #$46
         bcs   WAKEUP
         lda   V.XOFF,u
         ora   V.XON,u
         bne   InIRQ4
         tst   <u0024,u
         beq   WAKEUP
         lda   V.TYPE,u
         ora   #$C0
         sta   [V.PORT,U]
         clr   <u0025,u
         bra   WAKEUP

InIRQ4 lda V.XOFF,U get X-OFF char
 beq WakeUp branch if not enabled
 ldb INHALT,U have we sent XOFF?
 bne WAKEUP yes then don't send it again
 anda #^Sign insure sign clear
 sta V.XOFF,U
 ora #Sign set sign bit
 sta INHALT,U flag input halt
 ldb V.TYPE,U get control value
 orb #IRQIN!IRQOUT enable input & output IRQs
 stb [V.PORT,U]
 lbra WakeUp

InAbort ldb #S$Intrpt keyboard INTERRUPT signal
 bra InQuit10

InQuit ldb #S$Abort Abort signal
InQuit10 pshs A save input char
 lda V.LPRC,U last process id
 lbsr Wake10 Send error signal
 puls A restore input char
 bra InIRQ1 buffer char, exit

***************
* Control character routines

InPause ldx V.DEV2,U get echo device static ptr
 beq InIRQ1 ..None; buffer char, exit
 sta V.PAUS,X request pause
 bra InIRQ1 buffer char, exit

InXOFF lda HALTED,U
 bne InXOFF10 ..already halted, continue
 ldb V.TYPE,U get acia control code
 orb #IRQIN enable only input IRQs
 stb 0,X
InXOFF10 ora #H.XOFF
 sta HALTED,U restrict output
 clrb
 rts

InXON lda HALTED,U
 anda #^H.XOFF
 sta HALTED,U enable output
 bne InXON99 ..exit if otherwise disabled
 lda V.TYPE,U parity control
 ora #IRQIN!IRQOUT enable input & output IRQs
 sta 0,X
InXON99 clrb
 rts

 emod Module Crc
ACIEND equ *
