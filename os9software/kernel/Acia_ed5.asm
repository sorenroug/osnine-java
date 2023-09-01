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
*  3 83/02/11  Add X-ON/X-OFF generation code
*  4 83/03/10  Getstat Ready returns (B)=bytecount
*  4 83/03/17  Putstat Release removes SS.SSIG if necessary
*  4 83/03/25  INCNT was counting chars even if buffer overrun.
*  5 83/06/01  Modified to use Suspend process state instead
*              of F$Send during IRQ.

Edition equ 5 Current Edition

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
INXTI rmb 1 input  buffer next-in  ptr
INXTO rmb 1 input  buffer next-out ptr
INCNT rmb 1 input char count
ONXTI rmb 1 output buffer next-in  ptr
ONXTO rmb 1 output buffer next-out ptr
HALTED rmb 1 output IRQ's disabled when non-zero
INHALT rmb 1 input halted
SIGPRC rmb 2 Process to signal and code
V.Bit7 rmb 1 'mask bit 7' flag
 ifeq CPUType-DRG128
V.Baud rmb 1 baud rate selection
 endc
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

 fcb Edition Current Revision

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
 lda M$OPT,Y option byte count
INIT05 cmpa #PD.PAR-PD.OPT acia control value given?
 blo INIT10 ..no; default $15
 ldb PD.PAR-PD.OPT+M$DTYP,Y
 bne INIT20
INIT10 ldb #$15 default acia control
INIT20 tstb 7-bit data?
 bpl INIT22 ..no
 inc V.Bit7,u set flag
INIT22 andb #$1F ensure valid type
 stb V.TYPE,U save device type
 stb 0,X init acia
 ifeq CPUType-DRG128
 ldb PD.BAU-PD.OPT+M$DTYP,y get baud rate selection
 stb V.Baud save it
 endc
 lda 1,X
 lda 1,X remove any interrupts
 tst 0,X interrupt gone?
 bmi ErrNtRdy ..No; abort
 clra
 clrb
 std INXTI,U Initialize buffer ptrs
 std ONXTI,U
 sta INHALT,U flag input not halted
 sta INCNT,U clear in char count
 ldd V.PORT,U
 leax ACMASK,PCR
 leay ACIRQ,PCR address of interrupt service routine
 OS9 F$IRQ Add to IRQ polling table
 bcs INIT9 Error - return it
 ifeq CPUType-DRG128
 lbsr SetBaud set the baud rate and control reg
 else
 ldx V.PORT,U
 ldb V.TYPE,U
 orb #IRQIN enable acia input interrupts
 stb 0,X initialize acia for input interrupts
 endc
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
Read.a tst SIGPRC,U a process waiting for device?
 bne ErrNtRdy ..Yes; return dormant terminal error
 ldb INXTO,U (input buffer) next-out ptr
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
 clrb
 ldb V.ERR,U Transmission error?
 beq READ90 ..no; return
 stb PD.ERR,Y return error bits in pd
 clr V.ERR,U
 comb return carry set
 ldb #E$Read signal read error
READ90 andcc #^IntMasks enable IRQ requests
 rts

ErrNtRdy comb
 ldb #E$NotRdy
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
 lda D.Proc get current process ptr
 sta V.Wake,U arrange wake up signal
 ldx D.Proc get process ptr
 lda P$State,x get process state
 ora #Suspend set suspend bit
 sta P$State,x put it in descriptor
 andcc #^IntMasks interrupts ok now
 ldx #1
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
 ora #IRQIN!IRQOUT enable input & output IRQs
 sta [V.PORT,U] Enable output interrupts
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
 ldb INCNT,U get input character count
 beq ErrNtRdy ..No; return not ready error
 ldx PD.RGS,Y
 stb R$B,X return bytecount to caller (!)
STATUS99 clrb
 rts

GETS10 cmpa #SS.EOF End of file?
 beq Write90 ..yes; return carry clear

Unknown comb return carry set
 ldb #E$UnkSvc Unknown service code
 rts

PUTSTA cmpa #SS.SSIG signal process when ready?
 bne PUTS.A
 lda PD.CPR,Y get process id
 ldx PD.RGS,Y
 ldb R$X+1,X get signal code
 orcc #IntMasks disable IRQs
 tst INCNT,U any data available?
 bne PUTS10 yes, data ready
 std SIGPRC,U save the signal data
 bra Write80 exit

PUTS10 andcc #^IntMasks enable IRQs
 lbra SendSig send the signal

PUTS.A cmpa #SS.Relea Release Device?
 ifeq CPUType-DRG128
 beq PUTS.B ..yes
 cmpa #SS.Baud set baud rate?
 endc
 bne Unknown bra if not
 ifeq CPUType-DRG128
 ldx PD.RGS,y get user regs ptr
 lda R$X+1,x get requested baud rate
 sta V.Baud,u save it
 bra SetBaud set it
 endc

 ifeq CPUType-DRG128
***************
* Implement baud rate selection
*
* For the on-board ACIA, the following codes apply:
*
* Code  Baud Rate
*  0     150
*  1     300
*  2     600
*  3    1200
*  4    2400
*  5    4800
*  6    9600
*  7    9600
*
* This differs marginally from the OS-9 standard, which
* uses 0 for 110, and 7 for 19200.
SetBaud lda V.Baud,u get the baud rate selection
 pshs x save x
 ldx V.Port,u get port address
 cmpx #A.T1 on-board ACIA?
 bne SetB1 ..no
 anda #$07 ensure valid selection
 leax BaudTabl,PCR point at translation table
 lsla two bytes per entry
 leax a,x point at the entry
 lda ,x+ get the required port bits
 lsla shift to b2-b5
 lsla
 pshs a,cc save setting and masks
 orcc #IntMasks set masks
 lda D.Baud get the present port setting
 anda #$C3 remove the baud rate
 ora 1,s add in new
 sta D.Baud save it
 sta >A.Baud set it
 lda V.Type,u get the present type selection
 anda #$1C remove the division ratio
 ora ,x add in the new divsion ratio
 sta V.Type,u save the new control value
 ora #IRQIN allow input interrupts
 tst HALTED,u output IRQs on?
 bne SetB2 ..no
 ora #IRQOUT allow output interrupts
SetB2 sta [V.Port,u] set the new control reg
 puls a,cc restore masks
SetB1 equ *
 clrb no error
 puls x,pc

NEWBOARD set 0
 ifne NEWBOARD
 else
BaudTabl fcb 15,2,7,2,15,1,7,1,3,1,1,1,0,1,0,1
 endc
 endc

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
OutI.a leay OUTBUF,U output buffer ptr
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
 bne WakeUp ..no
OutIRQ2 lda HALTED,U
 ora #H.EMPTY
 sta HALTED,U
OutIRQ3 ldb V.TYPE,U
 orb #IRQIN disable output IRQs
 stb 0,X

WAKEUP lda V.Wake,U Owner waiting?
 beq Wake90 ..no; return
 clrb
 stb V.Wake,U
 tfr d,x get ptr to process desc
 lda P$State,x
 anda #^Suspend clear suspend state
 sta P$State,x put it in proc desc
Wake90 clrb return carry clear
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
InIRQ lda 1,X Read input char
 tst V.Bit7,u 7-bit only?
 beq InIRQ3 ..no; leave 8-bit
 anda #$7F clear b7
InIRQ3 tsta
 beq InIRQ1 ..NULL, impossible Ctl Chr
 cmpa V.INTR,U keyboard Interrupt?
 beq InAbort ..Yes
 cmpa V.QUIT,U keyboard Quit?
 beq InQuit ..Yes
 cmpa V.PCHR,U keyboard Pause?
 beq InPause ..Yes
 cmpa V.XON,U X-ON continue?
 beq InXON ..Yes
 cmpa V.XOFF,U X-OFF Immediate Pause request?
 lbeq InXOFF ..Yes

InIRQ1 leax INPBUF,U input buffer
 ldb INXTI,U (input) next-in ptr
 abx
 sta 0,X save char in buffer
 incb update Next-in ptr
 cmpb #INPSIZ-1 end of circular buffer?
 bls InIRQ2 ..no
 clrb
InIRQ2 cmpb INXTO,U input overrun?
 bne InIRQ30 ..no; good
 ldb #OVERUN mark overrun error
 orb V.ERR,U
 stb V.ERR,U
 bra WakeUp throw away character

InIRQ30 stb INXTI,U update next-in ptr
 inc INCNT,U
 tst SIGPRC,Y any process to notify?
 beq InIRQ4 ..no
 ldd SIGPRC,U get process to signal
 clr SIGPRC,U disable signal sending
SendSig OS9 F$Send send signal
 clrb return carry clear
 rts

InIRQ4 lda V.XOFF,U get X-OFF char
 beq WakeUp branch if not enabled
 ldb INCNT,U get input count
 cmpb #INPSIZ-10 is buffer almost full?
 blo WAKEUP bra if not
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

***************
* Control character routines

InPause ldx V.DEV2,U get echo device static ptr
 beq InIRQ1 ..None; buffer char, exit
 sta V.PAUS,X request pause
 bra InIRQ1 buffer char, exit

InAbort ldb #S$Intrpt keyboard INTERRUPT signal
 bra InQuit10

InQuit ldb #S$Abort Abort signal
InQuit10 pshs A save input char
 lda V.LPRC,U last process id
 beq InQuit30 bra if no place to send
 clr V.Wake,u
 bsr SendSig
InQuit30 puls A restore input char
 bra InIRQ1 buffer char, exit

InXON lda HALTED,U
 anda #^H.XOFF
 sta HALTED,U enable output
 bne InXON99 ..exit if otherwise disabled
 lda V.TYPE,U parity control
 ora #IRQIN!IRQOUT enable input & output IRQs
 sta 0,X
InXON99 clrb
 rts

InXOFF lda HALTED,U
 bne InXOFF10 ..already halted, continue
 ldb V.TYPE,U get acia control code
 orb #IRQIN enable only input IRQs
 stb 0,X
InXOFF10 ora #H.XOFF
 sta HALTED,U restrict output
 clrb
 rts

 emod Module Crc
ACIEND equ *

