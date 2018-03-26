
 nam PIA
 ttl Parallel Interface driver

Excluded equ 0
Included equ 1
PiaInput equ excluded

***************
* Copyright 1981 Microware Systems Corporation
* Edition History:

*  # Edition     Change(s) made                                     By
* -- -------- ---------------------------------------------------- ---
* 04          Pre-historic
* 05 82/12/07 Bug in terminate could leave PIA on polling table.   RFD
* 05 82/12/07 Sleep routines did not check for Condemned state.   RFD

Edition equ 5 current edition

***************
*
*     Pia Device Driver
*
 mod PIASIZ,PIANAM,DRIVR+OBJCT,REENT+1,PIAENT,PIAMEM
 fcb EXEC.+UPDAT.
PIANAM fcs "PIA" Module name
 fcb Edition revision number

PIAType set 0
 use defsfile

 org V.SCF Static storage
V.Ready rmb 1 Pia ready flag
V.Drctn rmb 1 current i/o direction
V.Auto rmb 1 auto latching flag
V.BufPtr rmb 2 I/o buffer ptr
V.BufEnd rmb 2 end of buffer ptr
V.NxtIn rmb 2 next in ptr
V.NxtOut rmb 2 next out ptr
V.Data rmb 1 data in buffer flag
V.Buffer equ . beginning of buffer
PIAMEM equ 256 Total static storage

ALatch1 equ %00100000 C2 auto-latch mode 1
ALatch2 equ %00101000 C2 auto-latch mode 2
MLatch equ %00110000 C2 manual latch mode
MLatFlag equ %00001000 C2 manual latch flag
DataReg equ %00000100 Pia data register select
C1IntPos equ %00000010 C1 interrupt on positive transition
C1IntEnb equ %00000001 C1 interrupt enable
MPL2in equ %00001100 Set both a and b side for input
MPL2out equ %00001111 Set both a and b side for output
CardType equ %11000000 Mask to test for Pia card type
MPL2 equ %01000000 Swtpc mpl2 Pia card type

* Pia Type bit definitions
*     Two high order bits used for defining card type
*           Bit-7   Bit-6
*             0       0     plain 6820/21 no buffers
*             0       1     Swtpc Mpl2 w/buffer dir latch
*             1       0     unused - default to 0 0
*             1       1       "        "      "  "

 pag
***************
*
*     Entry Branch Table
*
PIAENT lbra PIAInit initialization routine
 lbra PIARead read routine
 lbra PIAWrite write routine
 lbra PIARts get status routine
 lbra PIARts set status routine
 lbra PIATerm terminate routine



*
*     Irq Polling Parameters
*
PPMASK fcb 0 Flip (none)
 fcb $80 Irq polling mask
 fcb 4 (low) priority

 pag
***************
*
*     Subroutine Piainit

* Passed: (U)=Static storage
*         (Y)=Initial Device Descriptor

PIAInit leax V.Buffer,U get buffer ptr
 stx V.Bufptr,U set buffer ptr
 stx V.NxtIn,U set next in ptr
 stx V.NxtOut,U set next out ptr
 leax PIAMEM,U get end of buffer ptr
 stx V.BufEnd,U set end ptr
 ldx V.Port,U get Pia port addr
 lda M$OPT,Y get option byte count
 cmpa #PD.PAR-PD.OPT Pia side given?
 blo PPIN15 ..no; default b-side
 ldb PD.PAR-PD.OPT+M$DTYP,Y
 bra PPIN20
PPIN15 ldb #MLatch+C1IntPos get default type
PPIN20 andb #^C1IntEnb insure interrupts disabled
 orb #DataReg insure data regs selected
 stb V.TYPE,U save Pia type
 clr 1,X reset pia
 leax 1,X make polling ptr
 tfr x,d copy it
 leax PPMASK,PCR
 leay PIAIRQ,PCR addr of service routine
 OS9 F$IRQ Add to irq polling table
 bcs PPIN90 ..error; return it
 lda #$FF set Pia for output
 sta V.Drctn,U set direction flag
 ldb V.Type,U get control code
 ldx V.Port,U get Pia ptr
 pshs cc save interrupt masks
 orcc #IntMasks disable interrupts
 std 0,X Initialize pia
PPCLRQ lda 0,X Clear irqs
 clr V.Ready,U set Pia ready
 puls cc retrieve interrupt masks
 andb #MLatch get c2 mode
 cmpb #MLatch is it manual latch?
 bne PPIN85 branch if not
 ldb #MLatFlag set manual latch mode
 stb V.Auto,u
PPIN85 lda #1 Call for output set
 tfr x,y
 lbsr TYPECHK call for any special setup of Pia card
PIARts clrb
PPIN90 rts

 ifeq PiaInput-Included
 pag
***************
*
*     Subroutine Piaread
*

* Passed: (U)=Static Storage
*         (Y)=Path Descriptor
*         (A)=char to write to Pia
* Returns: Cc,B set if Error

PIAR.A bsr PSleep Sleep until PIA ready
 bcs PIAR.Z abort if signal error
PIARead ldy V.Port,U get Pia ptr
 pshs cc save interrupt masks
 orcc #IntMasks set interrupt masks
 ldb V.Drctn,U Pia set for input?
 beq PIAR.D branch if so
 ldb V.Data,U is buffer empty?
 bne PIAR.A branch if so
 ldb V.Ready,U is Pia ready?
 beq PIAR.C branch if so
 ldb 1,Y is Pia ready?
 bpl PIAR.A branch if not
 ldb 0,Y clear ready
PIAR.C ldb V.Type,U get control code
 andb #^DataReg set direction register select
 stb 1,Y select direction register
 clrb set direction to input
 stb 0,Y set direction register
 stb V.Drctn,U set direction flag
 clra call for set to input
 lbsr TYPECHK check card type, set input if needed
 ldb V.Type,U get control code
 orb #C1IntEnb set interrupt enable
 stb 1,Y enable interrupts
 bra PIAR.E
PIAR.D ldb V.Ready,U is buffer full?
 bne PIAR.F branch if not
 ldb V.Auto,U is Pia auto latching?
 beq PIAR.E branch if so
 eorb V.Type,U get control code, flipping flag
 stb 1,Y change flag
 eorb #MLatFlag+C1IntEnb flip flag & set interrupt enable
 stb 1,Y reset flag & enable interrupts
PIAR.E ldb #1
 stb V.Ready,U mark Pia ready
PIAR.F lbsr BuffOut get byte out of buffer
 bcc PIAR.G branch if successful
 ldb 1,Y is Pia ready?
 bpl PIAR.A branch if not
 lda 0,Y get byte & clear flag
 ldb V.Auto,U is it auto latching?
 beq PIAR.G branch if so
 eorb V.Type,U get control, flipping flag
 stb 1,Y change flag
 eorb #MLatFlag+C1IntEnb reset flag & set interrupt enable
 stb 1,Y reset flag
PIAR.G puls cc retrieve interrupt masks
 else
PIARead equ *
 endc
 clrb clear carry
PIAR.Z rts

 pag
***************
* Subroutine PSleep
*   Sleep until PIA is ready

* Passed: CC pushed on stack before return
* Returns: CC=Set if signal error
* Destroys: B,X

PSleep ldb V.Busy,U get process id
PSleep.A stb V.Wake,U set wake-up call
 puls X return addr
 puls cc retrieve interrupt masks
 pshs A,X save (A), PC
 ldx #0 wait for signal
 OS9 F$Sleep
 ldx D.Proc get process ptr
 ldb P$Signal,X signal waiting?
 beq PSleep.B ..No; check status
 cmpb #S$Intrpt deadly signal?
 bls PSleep.C ..Yes; return error
PSleep.B clra clear carry
 lda P$State,X check process state flags
 bita #Condem has process died?
 beq PSleep.D ..No; exit
PSleep.C coma return signal as error
PSleep.D puls A,PC return

 pag
***************
* Subroutine PIAWrite
*   Write one byte to PIA

* Passed: (U)=Static Storage
*         (Y)=Path Descriptor
*         (A)=char to write to Pia
* Returns: CC,B set if Error

PIAW.A bsr PSleep wait for PIA
 bcs PIAW.Z abort if error
PIAWrite ldy V.Port,U get Pia ptr
 pshs cc save interrupt masks
 orcc #IntMasks set interrupt masks
 ldb V.Drctn,U Pia set for output?
 bne PIAW.D branch if so
 ldb V.Data,U is buffer empty?
 bne PIAW.Err ..No; abort
 clr V.Ready,U set Pia ready
 ldb V.Type,U get control code
 andb #^DataReg set direction register select
 stb 1,Y select direction register
 ldb #$FF set direction to output
 stb 0,Y set direction register
 stb V.Drctn,U set direction flag
 ldb V.Type,U get control code
 stb 1,Y select data register
 pshs A save output char
 lda #1 call for output set
 lbsr TYPECHK check card type, set output if needed
 puls A retrieve output char
PIAW.D ldb V.Ready,U is Pia ready?
 beq PIAW.G branch if so
 ldb V.Data,U is data in buffer?
 bne PIAW.E branch if so
 ldb 1,Y is Pia ready?
 bmi PIAW.F branch if so
 ldb V.Type,U get control code
 orb #C1IntEnb set interrupt enable
 stb 1,Y enable interrupts
PIAW.E bsr BuffIn put byte in buffer
 bcs PIAW.A branch if not successful
 puls cc retrieve interrupt masks
 clrb clear carry
 rts

PIAW.F ldb 0,Y clear flag
PIAW.G ldb #1
 stb V.Ready,U set Pia not ready
 puls cc retrieve interrupt masks
 sta 0,Y write byte
 ldb V.Auto,U is it auto latching?
 beq PIAW.H branch if so
 eorb V.Type,U get control, flipping flag
 stb 1,Y change flag
 eorb #MLatFlag flip flag
 stb 1,Y reset flag
PIAW.H clrb clear carry
PIAW.Z rts

PIAW.Err puls cc retrieve interrupt masks
 comb set carry
 ldb #E$Write err: write error
 rts

 pag
***************
*   Process Pia Interrupt

* Passed: (A)=Pia Status Reg

PIAIRQ ldy V.Port,U Pia port addr
 ldb V.Drctn,U get Pia direction
 bne PIAOut branch if output

 ifeq PiaInput-Included
PIAInp lda 0,Y clear interrupt
 bsr BuffIn put byte in buffer
 cmpx V.NxtOut,U buffer full?
 beq PIAIRQ.A branch if so
 bsr PIAIRQ.B latch
 bmi PIAInp repeat if more bytes available
 rts
 endc

PIAOut lda 0,Y clear interrupt
 bsr BuffOut get byte from buffer
 bcs PIAIRQ.A branch if empty
 sta 0,Y write it
 bsr PIAIRQ.B latch
 bmi PIAOut repeat if already gone
 rts

PIAIRQ.A ldb V.Type,U get Pia control
 stb 1,Y disable interrupts
 clr V.Ready,U set Pia not ready
 bra PIAIRQ.C

PIAIRQ.B ldb V.Auto,U is Pia auto latching?
 beq PIAIRQ.C ..Yes
 eorb V.Type,U get control code, flipping flag
 stb 1,Y change Pia flag
 eorb #MLatFlag+C1IntEnb flip flag & set enable
 stb 1,Y reset Pia flag & enable interrupts
PIAIRQ.C lda V.Wake,U is there waiting process?
 beq PIAIRQ.D ..no; return
 ldb #S$WAKE (wake up)
 OS9 F$SEND
 clr V.WAKE,U
PIAIRQ.D clrb clear carry
 ldb 1,Y return Pia ready status
 rts

 pag
***************
*
*     Subroutines Buffin & Buffout
*
*   Data buffering routines
*
BuffIn ldx V.NxtIn,U get next in ptr
 ldb V.Data,U already data in buffer?
 beq BufI.A branch if not
 cmpx V.NxtOut,U is buffer full?
 bne BufI.B branch if not
 comb set carry
 rts
BufI.A ldb #1
 stb V.Data,U set data in buffer flag
BufI.B sta ,x+ put byte in buffer
 cmpx V.BufEnd,U end of buffer?
 bcs BufI.C branch if not
 ldx V.BufPtr,U get buffer ptr
BufI.C stx V.NxtIn,U update next in ptr
 clrb clear carry
 rts


BuffOut ldb V.Data,U is there data in buffer?
 bne BufO.A branch if so
 comb set carry
 rts
BufO.A ldx V.NxtOut,U get next out ptr
 lda ,x+ get byte from buffer
 cmpx V.BufEnd,U end of buffer?
 bcs BufO.B branch if not
 ldx V.BufPtr,U reset next out ptr
BufO.B stx V.NxtOut,U update next out ptr
 cmpx V.NxtIn,U is buffer empty?
 bne BufO.C branch if not
 clr V.Data,U clear data in buffer flag
BufO.C clrb clear carry
 rts

 pag
***************
*
* Subroutine Typechk
*
*  Checks type byte for Pia card type
*  Does any special set up for direction switch of card
*
*  Passed: (A)= 0 - set input  1 - set output

TYPECHK pshs Y save port address
 ldb V.Type,U get control code
 andb #CardType Mask out irrelevant bits
 beq TYPEC.G bra if nothing to do
 cmpb #MPL2 Is it swtpc?
 bne TYPEC.G bra if not
 ldb #MPL2in preset for input
 tsta is it input?
 beq TYPEC.B bra if so
 ldb #MPL2out set for output
TYPEC.B pshs B save reg
 tfr Y,D get port address in d
 andb #$F0
 orb #$E force address $xxxe
 tfr D,Y put addr back in y
 puls B retrieve reg
 stb 0,Y store direction in latch
TYPEC.G puls Y,PC

 pag
***************
* Subroutine Piaterm
*   Terminate PIA processing

PIAT.A ldx D.Proc get process ptr
 ldb P$ID,X get process id
 lbsr PSleep.A wait for PIA ready
PIATerm ldy V.Port,U get Pia port address
 ldb V.Drctn,U get Pia direction
 beq PIAT.C branch if input
 pshs cc save interrupt masks
 orcc #IntMasks set interrupt masks
 ldb V.Data,U is buffer empty?
 bne PIAT.A ..No; Wait
 puls cc retrieve interrupt masks
PIAT.C clr 1,Y reset pia
 ldx #0
 OS9 F$IRQ remove Pia from polling tbl
 rts

 emod

PIASIZ equ *

