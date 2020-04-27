         nam   Clock
         ttl   Dragon 64 clock module

* The Dragon provides an interrupt request every 20 milliseconds. The role
* played by this interrupt is to update the system clock. The interrupt
* request is removed by reading PIA0's peripheral data register, which is
* mapped through address $FF00. This happens in the keyboard poll routine.

         ifp1
         use   ../DEFS/os9defs
         endc
*****
*
*  Module Header
*
Type set SYSTM+OBJCT
Revs set REENT+1

TkPerSec set   50

ClkMod mod   ClkEnd,ClkNam,Type,Revs,ClkEnt,size

size     equ   .

ClkNam fcs /Clock/
 fcb 2 Edition number
*
* Clock Data Definitions
*
TIMSVC fcb F$TIME
 fdb TIME-*-2
 fcb $80

* table of days of the month
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
 lda D.TSEC Get ticks/second
 sta D.Tick
TICK50    jmp   [D.Clock]

ClkEnt    equ   *
         pshs  dp,cc
         clra  
         tfr   a,dp
         lda   #TkPerSec
         sta   <D.TSec
         sta   <D.Tick
         lda   #TkPerSec/10
         sta   <D.TSlice
         sta   <D.Slice
         orcc  #FIRQMask+IRQMask       mask ints
         leax  >TICK,pcr
         stx   >D.AltIRQ
* install system calls
 leay TIMSVC,PCR
 OS9 F$SSVC Set time sevice routine
         puls  pc,dp,cc

*****
*
*  Subroutine Time
*
* Return Time Of Day
*
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
