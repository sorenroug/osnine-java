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
 fcb 2 Edition number
*
* CLOCK DATA DEFINITIONS
*
TIMSVC fcb F$TIME
 fdb TIME-*-2
 fcb $80
CLKPRT equ M$Mem Memory has Clock port address

Second equ 0
Minute equ 2
Hour equ 4
DayMonth equ 7
Month equ 8
Year equ 9
Status equ 12

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
CLKSRV    ldd   #$9C40
         std   >$EA06
         ldx   >CLKPRT,pcr
 lda Status,X Get status/clear interrupt
 beq NOTCLK Branch if not clock
         bita  #$10
         beq   TICK40
 lda Year,x
 sta D.Year
 lda Month,X get month
 sta D.Month Set month
 lda DayMonth,X Get day
 sta D.DAY Set day
 lda Hour,X Get hour
 sta D.HOUR Set hour
 lda Minute,X get minute
 sta D.MIN Set minute
 lda Second,X get second
 sta D.SEC Set second
TICK40 ldd D.Clock get clock routine ptr
TICK50 std D.SvcIRQ set IRQ service routine
 jmp [D.XIRQ] enter system

*****
*
*  CLOCK INITIALIZATION ENTRY
*
ClkEnt equ *
 pshs CC save interrupt masks
         lda   #TickSec
         sta   D.Tick
 lda #TickSec/64 set ticks/time slice
 sta D.TSlice
 sta D.Slice
         clr   >$EA00
 orcc #IntMasks set interrupt masks
 leax CLKSRV,pcr GET SERVICE ROUTINE
 stx D.IRQ SET INTERRUPT VECTOR
 ldx CLKPRT,PCR get clock address
         lda   $0D,x
         beq   L008D
L006D    lda   $0A,x
         bmi   L006D
         lda   D.Month
         bne   L008D
         lda   Year,x
         sta   D.Year
 lda Month,X get month
 sta D.Month Set month
 lda DayMonth,X Get day
 sta D.DAY Set day
 lda Hour,X Get hour
 sta D.HOUR Set hour
 lda Minute,X get minute
 sta D.MIN Set minute
 lda Second,X get second
 sta D.SEC Set second
L008D    lda   #$86
         sta   $0B,x
         lda   #$0A
         sta   $0A,x
         lda   D.Year
         sta   Year,x
         lda   D.Month
         sta   Month,x
         lda   D.Day
         sta   DayMonth,x
         lda   D.Hour
         sta   Hour,x
         lda   D.Min
         sta   Minute,x
         lda   D.Sec
         sta   Second,x
         lda   Status,x
         lda   #$46
         sta   $0B,x
 puls CC retrieve masks
 leay TIMSVC,PCR
 OS9 F$SSVC SET TIME SERVICE ROUTINE
ClkEnt3 rts

TIME lda D.SysTsk get system task number
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
