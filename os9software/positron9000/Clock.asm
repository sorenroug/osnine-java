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

 use defsfile

*************************************************************
*
*  MODULE HEADER
*
Type set SYSTM+OBJCT
Revs set REENT+1
 mod ClkEnd,ClkNam,Type,Revs,ClkEnt,CPORT

ClkNam fcs /Clock/
 fcb 2 Edition number
*
* CLOCK DATA DEFINITIONS
*
TIMSVC fcb F$TIME
 fdb TIME-*-2
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

*************************************************************
*
*     Non-Clock Interrupt Service
*
NOTCLK ldd D.Poll get polling routine ptr
 lbra TICK50

CLKSRV ldx CLKPRT,PCR GET CLOCK ADDRESS
 lda 1,x
 anda  #2
 beq NOTCLK
*
* UPDATE CURRENT TIME
*
 ldd 4,x
 dec D.Tick COUNT TICK
 bne Tick47
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
 lda #TickSec Get ticks presecond
 sta D.Tick
Tick47 ldd D.Clock get clock routine ptr
TICK50 std D.SvcIRQ set IRQ service routine
 jmp [D.XIRQ] enter system

ClkEnt    equ   *
 pshs CC save interrupt masks
 lda #TickSec get ticks per second
 sta D.Tick
         lda   #$02
 sta D.TSlice
 sta D.Slice
 orcc #IntMasks set interrupt masks
 leax CLKSRV,pcr GET SERVICE ROUTINE
 stx D.IRQ SET INTERRUPT VECTOR
         ldx   >CLKPRT,pcr
         ldd  #9999
         std 4,x
         ldb   #$53
         stb 1,x
         clr 0,x
 puls cc retrieve masks
 leay TIMSVC,PCR
 OS9 F$SSVC SET TIME SERVICE ROUTINE
 rts

*************************************************************
*
*     Subroutine Time
*
*   Time of Day service routine
*
TIME equ *
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
