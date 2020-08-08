 nam Clock Module
 ttl Module Header
* opt -c

************************************************************
*                                                          *
*     Clock Module                                         *
*                                                          *
* Copyright 1982 by Microware Systems Corporation          *
* Reproduced Under License                                 *
*                                                          *
* This source code is the proprietary confidential prop-   *
* erty of Microware Systems Corporation, and is provided   *
* to the licensee solely for documentation and educational *
* purposes. Reproduction, publication, or distribution in  *
* any form to any party other than the licensee is         *
* is strictly prohibited !!!                               *
*                                                          *
************************************************************
 ifne TimePoll
************************************************************
*
* This version maintains a time polling table. Device
* drivers may install themselves in the table via a
* F$Timer request. They are then called at every tick.
* This necessitates the Clock tick routine duplicating
* some of the User/System switching normally done in
* UserIRQ in OS9p1, to allow the routines to use
* system calls such as F$Send.
*
*************************************************************
 endc
*
 ifeq CPUType-DRG128
*   Initialise PIA for VSYNC interrupts,
 endc
 ifne TimePoll
*   Set up Timer Polling Table, for device drivers needing to
*   run a timing routine every tick,
 endc
*   and take control of IRQ vector
*
*   Edition 3 - time polling table added.  Vivaway Ltd  83/11/07 PSD
*

CPORT set A.Clock
 use defsfile
*************************************************************
*
*  MODULE HEADER
*
Type set SYSTM+OBJCT
Revs set REENT+1
 mod ClkEnd,ClkNam,Type,Revs,ClkEnt,CPORT
ClkNam fcs /Clock/
 fcb 3 Edition number
*
* CLOCK DATA DEFINITIONS
*
TIMSVC fcb F$TIME
 fdb TIME-*-2
 ifne TimePoll
 fcb F$Timer+SysState
 fdb Install-*-2
 endc
 fcb $80
CLKPRT equ M$Mem Memory has Clock port address

*
*  DAYS IN MONTHS TABLE
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

 ifne ClocType
*************************************************************
*
*     Non-Clock Interrupt Service
*
NOTCLK ldd D.Poll
 lbra  TICK50

CLKSRV ldx CLKPRT,pcr
 ifeq CPUType-DRG128
 lda 1,X get CRA of 6821
 bita #$40 test Cx2 interrupt flag
 beq NOTCLK
 sta D.LtPen save reg for light pen flag
 lda ,x clear the interrupt
 endc

Tick equ *
 ifne (ClocType-M58167)*(ClocType-MC146818)
*
* UPDATE CURRENT TIME
*
 dec D.Tick Count tick
 bne Tick40 Branch if not end of second
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
 ifeq (ClocType-MC6840)*(ClocType-VIA)*(ClocType-VSYNC)
 ifne (CPUType-Profitel)
 lda   #50  Get ticks/second
 else
 endc
 endc
 sta D.Tick
 else
 endc
 ifne TimePoll
Tick40 leau  0,s
 ldx   D.SysIRQ
 cmpx  D.XIRQ
 beq   Tick41
 lds   D.SysStk
 ldd   D.SysSvc
 std   D.XSWI2

Tick41 pshs  u

 ldx D.TimTbl
 beq Tick47
 ldb #64
 pshs x,dp,b
Tick42 ldy ,x++
 beq Tick45

 ldu ,x++
 stx 2,s
 jsr ,y
 ldx 2,s
 dec ,s
 bne Tick42
Tick45 puls x,dp,b
Tick47 ldd D.Clock
 puls u
 leas ,u
 else
 endc
TICK50 std D.SvcIRQ
 jmp [D.XIRQ]

*****
*
*  CLOCK INITIALIZATION ENTRY
*
ClkEnt equ *
 ifne TimePoll
 clrb
 ldx   D.TimTbl
 bne   ClkEnt3
 endc
 ifne ClocType
 pshs  cc
 ifeq (ClocType-MC6840)*(ClocType-VIA)*(ClocType-VSYNC)
 ifne (CPUType-Profitel)
 lda   #TickSec
 else
 endc
 endc
 sta D.Tick
 lda #TickSec/10 set ticks/time slice
 sta D.TSlice
 sta D.Slice
 ifne TimePoll
 ldd #256
 pshs u
 os9 F$SRqMem
 bcs ClkEnt2
 stu D.TimTbl
 ldy #0
 ldb #64*2
ClkEnt1 sty ,u++
 decb
 bne ClkEnt1
ClkEnt2 puls  u
 endc
 orcc #IntMasks set interrupt masks
 leax  CLKSRV,pcr GET SERVICE ROUTINE
 stx   D.IRQ SET INTERRUPT VECTOR
 ifeq ClocType-VSYNC
 ldx CLKPRT,pcr
 lda 0,x
 lda 1,x
 ifne Cx2Int
 ora #$18 positive edge interrupt on CA2 (CB2)
 else
 endc
 sta 1,x
 endc
 puls  cc
 leay TIMSVC,PCR
 OS9 F$SSVC SET TIME SERVICE ROUTINE
ClkEnt3    rts

 ifeq ClocType-M58167
 endc
 ifne TimePoll
****************************************
*
* Install caller in timer polling table
*
Install pshs cc
 orcc #IRQMask+FIRQMask Set intrpt masks
 ldx D.TimTbl
 ldb #$40
 ldy R$X,u
 beq Remove
Install1 ldy ,x
 beq Install2
 leax $04,x
 decb
 bne Install1

InsErr puls  cc
 comb
 ldb #E$Poll
 rts

Install2 ldy R$X,u
 sty ,x++
 ldy R$U,u
Install3    sty   ,x
Install4    puls  cc
 clrb
 rts

Remove    ldy   R$U,u
Remove1    cmpy  $02,x
 beq   Remove2
 leax  $04,x
 decb
 bne   Remove1
 bra   Install4

Remove2 decb
 beq Remove4
Remove3 ldy 4,x
 beq Remove4
 sty ,x++
 ldy 4,x
 sty ,x++
 decb
 bne Remove3
Remove4 ldy #0 delete this entry
 sty ,x++
 bra Install3
 endc

 page
*****
*
*  Subroutine Time
*
* Return Time Of Day
*
TIME equ *
 ifeq (ClocType-M58167)
 endc
 lda D.SysTsk
 ldx D.Proc
 ldb P$Task,x
 ldx #D.Time
 ldy #6
 ldu R$X,u
 os9 F$Move
 rts

 emod
ClkEnd equ *
