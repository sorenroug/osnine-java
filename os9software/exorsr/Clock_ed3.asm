
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

* CLOCK is defined in os9defs
* CLOCK set $FFE0
 opt c
 ttl Definitions
 page

Revs set ReEnt+2
ClkMod mod ClkEnd,ClkNam,Systm+Objct,Revs,ClkEnt,0

ClkNam fcs /Clock/
 fcb 3 Edition number

CLKPRT equ M$STAK Stack has clock port address


TIMSVC fcb F$TIME
 fdb TIME-*-2
 fcb $80

TCKCNT set 25000 #of mpu cycles/tick

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
*****
*
*  Clock Interrupt Service Routine
*
NOTCLK jmp [D.ISVC] Go to interrupt service

CLKSRV ldx CLKPRT,PCR Get clock address
 beq NOTCLK Branch if not
         lda 1,x
         anda #4
 beq NOTCLK Branch if not clock
         ldd 6,x Clear intrpt (M6840)
TICK clra SET Direct page
 tfr A,DP
 dec D.TIC Count tick
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
 ldb D.MNTH Get month
 cmpb #2 Is it february?
 bne TICK10 Branch if not
 ldb D.YEAR Get year
 beq TICK10 Branch if even hundred
 andb #3 Is it leap year?
 bne TICK10 Branch if not
 deca ADD Feb 29
TICK10 ldb D.MNTH Get month
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
 sta D.Tic

TICK50
 jmp [CLOCK] Go to system clock routine


*****
*
*  Clock Initialization Entry
*
ClkEnt pshs DP save direct page
 clra clear Dp
 tfr A,DP
 pshs CC save interrupt masks
 lda #5 Set ticks/second
 sta D.TSEC
 sta D.Tic
 lda #1 Set ticks / time-slice
 sta D.TSLC
 sta D.Slic
 orcc #IRQM+FIRQM Set intrpt masks
 leax CLKSRV,PCR Get service routine
 stx D.IRQ Set interrupt vector
 ldx CLKPRT,PCR get clock address
 ldd #TCKCNT-1 Get tick count (M6840)
         std   6,x
         ldb   #$53 Constant for control reg. (M6840)
         stb   ,x
         ldb   #$01
         stb 1,x
         clr 0,x
 puls CC retrieve masks
 leay TIMSVC,PCR
 OS9 F$SSVC Set time service routine
 puls DP,PC

TIME equ *
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
