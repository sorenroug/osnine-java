
 nam Clock Module

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

CLOCK set $FFE0
 opt c
 ttl Definitions
 page
*****
*
*  Clock Module
*
 ifeq ClocType-MPT
* Initialize Swtc Timer Board For 100Ms Intervals
 endc
 ifeq ClocType-MC6840
* Initialize 6840 Timer Chip For 50Ms Intervals
 endc
 ifeq ClocType-M58167
* Initialize M58167 Clock Chip For 100Ms Intervals
 endc
*    And Sets Irq Polling Routine
*
*****
*
*  Module Header
*
Type set SYSTM+OBJCT
Revs set REENT+1
ClkMod mod ClkEnd,ClkNam,Type,Revs,ClkEnt,CPORT
ClkNam fcs /Clock/
 fcb 3 Edition number
*********************
* Edition history
*
* Ed.  1 - prehistoric times                           12/08/82 WGP
*
* Ed.  2 - file set up for LI V1.2                     12/08/82 WGP
*
* Ed.  3 - conditionals added for 6840 time fix of     12/15/82 WGP
*          IRQ mask problem
*          set up to use defsfile in assembly directory
*

CLKPRT equ M$Mem Stack has clock port address
*
* Clock Data Definitions
*
TIMSVC fcb F$TIME
 fdb TIME-*-2
 fcb $80

 ifeq ClocType-MC6840
TCKCNT set 50000 #of mpu cycles/tick
 endc

 ifne ClocType-M58167
*
*  Days In Months Table
*
MONTHS fcb 0 Uninitialized month
 fcb 31 January
 fcb 28 February
 fcb 31 March
 fcb 30 April
 fcb 31 May
 fcb 30 June
 fcb 31 July
 fcb 31 August
 fcb 30 September
 fcb 31 October
 fcb 30 November
 fcb 31 December
 else
SecMilli equ 0
SecTenth equ 1
Second equ 2
Minute equ 3
Hour equ 4
DayWeek equ 5
DayMonth equ 6
Month equ 7
Status equ 16
Control equ 17
CountRst equ 18
LatchRst equ 19
RollOver equ 20
Go equ 21
 endc
 page
 ifne ClocType
*****
*
*  Clock Interrupt Service Routine
*
NOTCLK jmp [D.SvcIRQ] Go to interrupt service

CLKSRV ldx CLKPRT,PCR Get clock address
 ifeq ClocType-MPT Swtc mp-t board
 lda 1,X Get control register
 bita #$80 Is it clock?
 beq NOTCLK Branch if not
 lda 0,X Clear clock interrupt
 endc
 ifeq ClocType-MC6840 M6840 timer chip
 lda 1,X
 anda #2 Is it clock?
 beq NOTCLK Branch if not
 ldd 4,X Clear intrpt (must be 16-bit)
 endc
 ifeq ClocType-M58167 M58167 clock chip
 lda Status,X Get status/clear interrupt
 beq NOTCLK Branch if not clock
 endc

TICK clra SET Direct page
 tfr A,DP
 ifne ClocType-M58167
*
* Update Current Time
*
 ifeq ClocType-MC6840
 ifeq M6840Typ-Missed
 ldd 6,X get count of missed ticks
 pshs B save on stack
 ldd #90
 std 6,X reset missed tick counter
 subb ,S+ find actual number of missed ticks
TICKLOOP pshs B save on the stack
 endc
 endc
 dec D.Tick Count tick
 bne TICK50 Branch if not end of second
 ldd D.MIN Get minute & second
 incb COUNT Second
 cmpb #60 End of minute?
 bcs TICK35 Branch if not
 inca COUNT Minute
 cmpa #60 End of hour?
 bcs TICK30 Branch if not
 ldd D.DAY Get day & hour
 incb COUNT Hour
 cmpb #24 End of day?
 bcs TICK25 Branch if not
 inca COUNT Day
 leax MONTHS,PCR Get days/month table
 ldb D.Month Get month
 cmpb #2 Is it february?
 bne TICK10 Branch if not
 ldb D.YEAR Get year
 beq TICK10 Branch if even hundred
 andb #3 Is it leap year?
 bne TICK10 Branch if not
 deca ADD Feb 29
TICK10 ldb D.Month Get month
 cmpa B,X End of month?
 bls TICK20 Branch if not
 ldd D.YEAR Get year & month
 incb COUNT Month
 cmpb #13 End of year?
 bcs TICK15 Branch if not
 inca COUNT Year
 ldb #1 New month
TICK15 std D.YEAR Update year & month
 lda #1 New day
TICK20 clrb NEW Hour
TICK25 std D.DAY Update day & hour
 clra NEW Minute
TICK30 clrb NEW Second
TICK35 std D.MIN Update minute & second
 lda D.TSEC Get ticks/second
 sta D.Tick
 endc
 ifeq ClocType-MC6840
 ifeq M6840Typ-Missed
TICK50 ldb ,S+
 beq TICK60 bra if done
 decb count down
 bne TICKLOOP bra if not done
TICK60
 else
TICK50
 endc
 else
TICK50
 endc
 jmp [CLOCK] Go to system clock routine



 endc
*****
*
*  Clock Initialization Entry
*
ClkEnt pshs DP save direct page
 ifne ClocType
 clra clear Dp
 tfr A,DP
 pshs CC save interrupt masks
 ifeq ClocType-MPT Swtc mp-t board
 lda #10 Set ticks / second
 endc
 ifeq ClocType-MC6840 M6840 timer chip
 ifeq CPUSpeed-OneMHz   if 1 mhz cpu
 ifeq M6840Typ-Missed
 lda #10 Set tick/second
 else
 lda #20 Set ticks/second
 endc
 endc
 ifeq CPUSpeed-TwoMHz   if 2 mhz cpu
 ifeq M6840Typ-Missed
 lda #20 Set ticks/second
 else
 lda #40 Set ticks/second
 endc
 endc
 endc
 ifeq ClocType-M58167 M58167 clock chip
 lda #10 Set ticks / second
 endc
 sta D.TSEC
 sta D.Tick
 ifeq ClocType-MC6840
 ifeq CPUSpeed-TwoMHz
 lda #2 Set ticks/time-slice
 else
 lda #1 Set ticks / time-slice
 endc
 else
 lda #1 Set ticks / time-slice
 endc
 sta D.TSlice
 sta D.Slice
 orcc #IRQMask+FIRQMask Set intrpt masks
 leax CLKSRV,PCR Get service routine
 stx D.IRQ Set interrupt vector
 ifeq ClocType-MPT Swtc mp-t board
 ldx CLKPRT,PCR get clock address
 clra
 clrb
 std 0,X Clear pia regs.
 ldd #$FF3D Initialize clock board
 std 0,X
 ldd #$8005
 sta 0,X
 stb 0,X
 lda 0,X Clear any interrupts
 endc
 ifeq ClocType-MC6840 M6840 timer chip
 ldx CLKPRT,PCR get clock address
 ldd #TCKCNT-1 Get tick count
 ifeq M6840Typ-Missed
 std 2,X store count in timer #1
 ldd #1
 std 4,X inz timer #2
 ldb #$50 constant for control reg
 stb 1,X put it there
 ldd #90 max count of missed ticks
 std 6,X store it
 clr 0,X constant for C3
 ldb #$51 constant for C2
 stb 1,X store it
 ldb #$92 constant for C1
 stb 0,X enable timer operation
 else
 std 4,X Store in timer #2 count
 ldb #$53 Constant for control reg.
 stb 1,X Put it there.
 clr 0,X Enable timer operation
 endc
 endc
 ifeq ClocType-M58167 M58167 clock chip
 leas -5,S get scratch
 ldx #D.Month Get month ptr
 bsr CNVBB Convert binary to bcd
 stb 0,S save month
 bsr CNVBB Convert
 stb 1,S save day
 bsr CNVBB Convert
 stb 2,S save hour
 bsr CNVBB Convert
 stb 3,S save minute
 bsr CNVBB Convert
 stb 4,S save second
 ldx CLKPRT,PCR get clock address
 ldd #$FF02
 sta LatchRst,X Reset latches
 lda Status,X Clear any interrupt
 stb Control,X enable 100 millisec line
 lda 0,S retrieve month
 beq SkipSet
 sta Month,X set clock chip
 lda 1,S retrieve day
 beq SkipSet
 sta DayMonth,X
 lda 2,S retrieve hour
 sta Hour,X Set clock chip
 ldd 3,S retrieve minute & second
 sta Minute,X set clock chip
 clr Go,X reset seconds
 stb Second,X
SkipSet leas 5,S return scratch
 endc
 puls CC retrieve masks
 endc
 leay TIMSVC,PCR
 OS9 F$SSVC Set time sevice routine
 puls DP,PC
 ifeq ClocType-M58167

CNVBB lda ,X+ Get binary byte
 ldb #$FA Init bcd byte
CNVB10 addb #$10 Count ten
 suba #10 Is there a ten?
 bcc CNVB10 Branch if so
CNVB20 decb Count Unit
 inca Is there a unit?
 bne CNVB20 Branch if so
 rts
 endc
 page
*****
*
*  Subroutine Time
*
* Return Time Of Day
*
TIME equ *
 ifeq ClocType-M58167
 ldx CLKPRT,PCR Get clock port address
 pshs CC Save masks
 orcc #IRQMask+FIRQMask Set interrupt masks
TIME10 lda Second,X get second
 sta D.SEC Set second
 lda Minute,X get minute
 sta D.MIN Set minute
 lda Hour,X Get hour
 sta D.HOUR Set hour
 lda DayMonth,X Get day
 sta D.DAY Set day
 lda Month,X get month
 sta D.Month Set month
 lda RollOver,X Check for rollover
 rora
 bcs TIME10 Branch if so
 puls CC Retrieve interrupt masks
 ldx #D.Month Get date ptr
TIME20 lda 0,X Get bcd byte
 anda #$F0 Get msn
 tfr A,B Copy it
 eora 0,X Get lsn
 sta 0,X Save it
 lsrb ADJUST Msn
 lsrb
 lsrb
 lsrb
 lda #10
 mul
 addb 0,X Add lsn
 stb ,X+ Save converted byte
 cmpx #D.SEC+1
 bcs TIME20
 endc
 ldx R$X,U Get specified location
 ldd D.YEAR Get year & month
 std 0,X
 ldd D.DAY Get day & hour
 std 2,X
 ldd D.MIN Get minute & second
 std 4,X
 clrb Clear Carry
 rts


 emod
ClkEnd equ *

 opt c
 end
