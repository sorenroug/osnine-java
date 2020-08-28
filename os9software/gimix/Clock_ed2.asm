
 nam Clock Module

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

* Clock module for GIMIX system. Implements M58167 clock chip
* Identical to the Clock source in os9software except for edition number.

CPort    equ $E220

         ifp1
         use   /dd/defs/os9defs
         endc

CLOCK set $FFE0
 opt c
 ttl Definitions
 page
*****
*
*  Clock Module
*

tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,ClkNam,tylg,atrv,ClkEnt,CPORT

ClkNam fcs   /Clock/
         fcb   $02 

CLKPRT equ M$Mem Stack has clock port address

TIMSVC   fcb   F$Time
         fdb   TIME-*-2
         fcb   $80

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

*****
*
*  Clock Interrupt Service Routine
*
NOTCLK jmp [D.SvcIRQ] Go to interrupt service

CLKSRV ldx TICKVEC-*-1,PCR
 lda Status,X Get status/clear interrupt
 beq NOTCLK Branch if not clock
 clra
 tfr a,dp
TICKVEC jmp [CLOCK] Go to system clock routine

*****
*
*  Clock Initialization Entry
*
ClkEnt pshs DP save direct page
 clra clear Dp
 tfr A,DP
 pshs CC save interrupt masks
 lda #10 Set ticks / second
 sta D.TSEC
 sta D.Tick
 lda #1 Set ticks / time-slice
 sta D.TSlice
 sta D.Slice
 orcc #IRQMask+FIRQMask Set intrpt masks
 leax CLKSRV,PCR Get service routine
 stx D.IRQ Set interrupt vector
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
 puls CC retrieve masks
 leay TIMSVC,PCR
 OS9 F$SSVC Set time sevice routine
 puls DP,PC

CNVBB lda ,X+ Get binary byte
 ldb #$FA Init bcd byte
CNVB10 addb #$10 Count ten
 suba #10 Is there a ten?
 bcc CNVB10 Branch if so
CNVB20 decb Count Unit
 inca Is there a unit?
 bne CNVB20 Branch if so
 rts

*****
*
*  Subroutine Time
*
* Return Time Of Day
*
TIME equ *
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
eom      equ   *
