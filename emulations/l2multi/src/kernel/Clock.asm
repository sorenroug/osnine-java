 nam   Clock module for hosted OS
 ttl   Definitions

***************************

* ****************               PRIMARY COPY
* This is a Level 2 module
***************************

 use defsfile

Type set   Systm+Objct   
Revs set   ReEnt+1

clockctl set A.Clock

 mod ClkEnd,ClkNam,Type,Revs,ClkEnt,0

ClkNam fcs /Clock/
 fcb 2  edition

TkPerSec set 50


TIMSVC   fcb   F$Time
         fdb   TIME-*-2
         fcb   $80 

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

* Read the control register. If the clock didn't cause the
* interrupt then exit.
CLKSRV lda   >clockctl   Read the control register.
 bne TICK  If there is an interrupt then check devices.
 ldd D.Poll
 lbra  TICK55

TICK clra SET Direct page
 tfr A,DP
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
 lda #TkPerSec  Get ticks/second
 sta D.Tick
TICK50 ldd D.Clock
TICK55 std D.SvcIRQ
 jmp [D.XIRQ]

*****
*
*  Clock Initialization Entry
*
ClkEnt pshs  dp,cc
 clra clear Dp
 tfr A,DP
 lda #TkPerSec
 sta D.Tick
 lda #TkPerSec/10
 sta D.TSlice
 sta D.Slice
 orcc #IRQMask+FIRQMask Set intrpt masks
 leax  >CLKSRV,pcr
 stx D.IRQ
* install system calls
 leay TIMSVC,PCR
 OS9 F$SSVC Set time sevice routine

* Start the heart beat every 20 milliseconds.
 lda   #1000/TkPerSec
 sta   >clockctl

 puls  pc,dp,cc

 page
*****
*
*  Subroutine Time
*
* Return Time Of Day
*
TIME     lda   D.SysTsk
         ldx   D.Proc
         ldb   P$Task,x
         ldx   #D.Year
         ldy   #6
         ldu   R$X,u
         os9   F$Move
         rts   


 emod
ClkEnd equ *
