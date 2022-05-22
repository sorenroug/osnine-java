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
 ifeq ClocType-MC6840
* Initialize 6840 Timer Chip For 50Ms Intervals
 endc
 ifeq ClocType-VIA
 endc
 ifeq ClocType-M58167
* Initialize M58167 Clock Chip For 100Ms Intervals
 endc
 ifeq ClocType-MC146818
 endc
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
 ifeq (ClocType-MC6840)*(ClocType-VIA)
TCKCNT set 10000 #of mpu cycles/tick
 endc
 ifne (ClocType-M58167)*(ClocType-MC146818)



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
*************************************************************
*
*     Non-Clock Interrupt Service
*
NOTCLK ldd D.Poll get polling routine ptr
 lbra TICK50


*************************************************************
*
*     Clock Interrupt Service routine
*
* NOTE: the stack pointer is invalid when this routine is
*       entered. It must not be used, but it must not be 
*       lost.
*
CLKSRV ldx CLKPRT,PCR GET CLOCK ADDRESS
 ifeq ClocType-MC6840
 lda 1,x
 anda #2 Is it clock?
 beq NOTCLK Branch if not
 ldd 4,X Clear intrpt (must be 16-bit)
 endc
 ifeq ClocType-VIA
 endc
 ifeq (ClocType-M58167)*(ClocType-MC146818)
 lda Status,X Get status/clear interrupt
 beq NOTCLK Branch if not clock
 endc
 ifeq CPUType-DRG128
 lda 1,x get CRA of 6821
 ifne Cx2Int
 bita #$40 test Cx2 interrupt flag
 beq NOTCLK not a clock interrupt
 else
 endc
 sta D.LtPen save reg for light pen flag
 lda ,x clear the interrupt
 endc

Tick equ *
 ifne (ClocType-M58167)*(ClocType-MC146818)
*
* UPDATE CURRENT TIME
*
 dec D.Tick COUNT TICK
 bne Tick40 BRANCH IF NOT END OF SECOND
 ldd D.MIN GET MINUTE & SECOND
 incb COUNT SECOND
 cmpb #60 END OF MINUTE?
 bcs TICK35 BRANCH IF NOT
 inca COUNT MINUTE
 cmpa #60 END OF HOUR?
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
 lda #TickSec Get ticks presecond
 else
 endc
 endc
 sta D.Tick
 else
* M58167 code here. Probably:
Tick40 equ *
 endc
 ifne TimePoll
Tick40 leau ,s copy sp
 ldx D.SysIRQ in system mode?
 cmpx D.XIRQ
 beq Tick41 ..yes; no switch required

 lds D.SysStk get system stack
 ldd D.SysSvc set system service table
 std D.XSWI2

Tick41 pshs u save the sp as was

 ldx D.TimTbl get timer polling table pointer
 beq Tick47 ..there isn't one
 ldb #64 max entries
 pshs x,dp,b save regs
Tick42 ldy ,x++ get routine address
 beq Tick45 ..no more
 ldu ,x++ get static
 stx 2,s save ptr
 jsr ,y call routine
 ldx 2,s retrieve ptr
 dec ,s all done?
 bne Tick42 ..no
Tick45 puls x,dp,b restore regs
Tick47 ldd D.Clock get clock routine ptr
 puls u retrieve saved sp
 leas ,u restore it
 else
TICK40 ldd D.Clock get clock routine ptr
 endc
TICK50 std D.SvcIRQ set IRQ service routine
 jmp [D.XIRQ] enter system
 endc
*****
*
*  CLOCK INITIALIZATION ENTRY
*
ClkEnt equ *
 ifne TimePoll
 clrb clear carry
 ldx D.TimTbl table already exists?
 bne ClkEnt3 ..yes; skip initialisation
 endc
 ifne ClocType
 pshs CC save interrupt masks
 ifeq (ClocType-MC6840)*(ClocType-VIA)*(ClocType-VSYNC)
 ifne (CPUType-Profitel)
 lda #TickSec get ticks per second
 else
 endc
 endc
 ifeq ClocType-M58167 M58167 CLOCK CHIP
 lda #TickSec get ticks per second
 endc
 ifeq ClocType-MC146818 MC146818 Clock chip
 endc
 sta D.Tick
 lda #TickSec/10 set ticks/time slice
 sta D.TSlice
 sta D.Slice
 ifne TimePoll
 ldd #256 allocate memory for timer polling table
 pshs u
 os9 F$SRqMem
 bcs ClkEnt2 ..none
 stu D.TimTbl save table address
 ldy #0 clear it out
 ldb #64*2 number of entries*2 (4 bytes/entry)
ClkEnt1 sty ,u++
 decb
 bne ClkEnt1
ClkEnt2 puls u
 endc
 orcc #IntMasks set interrupt masks
 leax CLKSRV,pcr GET SERVICE ROUTINE
 stx D.IRQ SET INTERRUPT VECTOR
 ifeq ClocType-MC6840 M6840 TIMER CHIP
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
 ifeq ClocType-VIA
 endc
 ifeq ClocType-VSYNC
 ldx CLKPRT,pcr get PIA address
 lda ,x clear any current interrupts
 lda 1,x get Control register
 ifne Cx2Int
 ora #$18 positive edge interrupt on CA2 (CB2)
 else
 endc
 sta 1,x set control register
 endc
 ifeq ClocType-M58167 M58167 CLOCK CHIP
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
 ifeq ClocType-MC146818 MC146818 Clock chip
 endc
 puls CC retrieve masks
 endc
 leay TIMSVC,PCR
 OS9 F$SSVC SET TIME SERVICE ROUTINE
ClkEnt3 rts

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
 ifne TimePoll
****************************************
*
* Install caller in timer polling table
*
Install pshs cc save interrupt masks
 orcc #IntMasks mask interrupts
 ldx D.TimTbl get table pointer
 ldb #64 max entries
 ldy R$X,u get routine address
 beq Remove skip for remove
Install1 ldy ,x this one free?
 beq Install2 ..yes
 leax 4,x move to next
 decb table full?
 bne Install1 ..no

InsErr puls cc retrieve masks
 comb error -
 ldb #E$Poll polling table full
 rts

Install2 ldy R$X,u get routine address
 sty ,x++ set it
 ldy R$U,u get static storage
Install3 sty ,x set it
Install4 puls cc retrieve masks
 clrb no error
 rts

Remove ldy R$U,u get user's static
Remove1 cmpy 2,x found it?
 beq Remove2 ..yes
 leax 4,x move to next
 decb all searched?
 bne Remove1 ..no
 bra Install4 ..exit; can't find

Remove2 decb number to copy over
 beq Remove4 ..none
Remove3 ldy 4,x copy down next entry
 beq Remove4 skip if empty; end of entries
 sty ,x++ copy down
 ldy 4,x and static
 sty ,x++
 decb ..all done?
 bne Remove3
Remove4 ldy #0 delete this entry
 sty ,x++
 bra Install3 and exit

 endc
 page
*************************************************************
*
*     Subroutine Time
*
*   Time of Day service routine
*
TIME equ *
 ifeq (ClocType-M58167)
 ldx CLKPRT,PCR Get clock port address
 pshs CC Save masks
 orcc #IntMasks Set interrupt masks
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
 lda D.SysTsk get system task number
 ldx D.Proc get process ptr
 ldb P$Task,x get process task number
 ldx #D.Time get source ptr
 ldy #6 get byte count
 ldu R$X,u get specified location
 os9 F$Move move time to user
 rts

 emod
ClkEnd equ *

 opt c
 end
