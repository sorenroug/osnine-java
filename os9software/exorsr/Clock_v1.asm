 nam CLOCK
 ttl Clock Device Driver for Special ASM Clock
 spc 2
*************************************************************************
*                                                                       *
*              Clock Module for Special ASM Clock                       *
*                                                                       *
*              (C) 1982  Advanced Semiconductor Materials               *
*                                                                       *
*************************************************************************
 spc 2
 ifp1
 use os9defs
 use systype
 endc
 spc 1
*            Clock Module Header
 spc 1
ModType set SYSTM+OBJCT
Version set REENT+1
 mod ClkEnd,ClkNam,ModType,Version,ClkEnt,CPORT
ClkNam fcs "Clock"
 spc 1
ClkPrt equ M$STAK Stack has Clock's Port Address
INTVAL set 2 Ticks per Second
 spc 2
*            Static Data Definitions
 spc 1
TIMSVC equ *
 fcb F$TIME
 fdb TIME-*-2
 fcb $80
 spc 2
*            Calander Table
 spc 1
Months equ *
 fcb 0 Uninialized Month
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
 page
*           Clock Interrupt Service Routine
 spc 2
NotClk equ *
 jmp [D.ISVC] Go to normal I/O interrupt service handler
 spc 1
ClkSrv equ *
 ldx <ClkPrt,pcr Get port address of the Clock
 lda ,x Get contents of control/status register
 bmi NotClk Not clock's interrupt
Tick equ *
 clra Set Direct Page to O/S
 tfr a,dp
 spc 1
*          Update Current Time of Day
 spc 1
 dec D.TIC Decrement timeslice ticker
 bne Tick50 Branch if not end-of-second
 ldd D.MIN Get minutes and seconds
 incb Increment seconds
 cmpb #60 End of minute?
 blo Tick35 ..No; just update seconds
 inca ..Yes; count minute
 cmpa #60 End of hour?
 blo Tick30 ..No; just update minutes and possibly seconds
 ldd D.DAY Get Day and Hour
 incb Now count hour
 cmpb #24 End of Day?
 blo Tick25 ..No; just update hour and possily rest of clock
 inca Count Day
 leax <Months,pcr Point to calander of days
 ldb D.MNTH Get current month
 cmpb #2 Is this February
 bne Tick10 ..No; skip
 ldb D.YEAR Get Year for leap year check
 beq Tick10 ..Skip if even hundred year
 andb #3 Is it leap year?
 bne Tick10 ..No; skip
 deca ..Yes; account for February having 29 days
Tick10 equ *
 ldb D.MNTH Get month back
 cmpa b,x End of Month?
 bls Tick20 ..No; skip
 ldd D.YEAR ..Yes; Get year and month
 incb and count month
 cmpb #13 End of Year?
 blo Tick15 ..No; skip
 inca ..Yes; count Year
 ldb #1 and reset month to January
Tick15 equ *
 std D.YEAR Update new Year and Month
 lda #1 and reset to new Day
Tick20 equ *
 clrb Reset to new Hour
Tick25 equ *
 std D.DAY Store new Day and Hour
 clra Reset to new Minutes
Tick30 equ *
 clrb Reset to new Seconds
Tick35 equ *
 std D.MIN Store new Minutes and Seconds
 lda D.TSEC Get Ticks/Second
 sta D.TIC Reset Time/Slice
Tick50 equ *
 jmp $E1DA Go to system clock routine in EXORciser version
*jmp [CLOCK] Go to System Clock Routine
 page
*            Clock Module Initialization Routine
 spc 2
ClkEnt equ *
 pshs dp Save Direct Page
 clra Set Direct Page to
 tfr a,dp O/S Direct Page
 pshs cc Save Interrupt Masks
 lda #INTVAL Set Ticks/Second
 sta D.TSEC
 sta D.TIC
 lda #1 Set Ticks/Time slice
 sta D.TSLC
 sta D.SLIC
 orcc #IRQM+FIRQM Disallow interrupts
 leax ClkSrv,pcr and set address for service routine
 stx D.IRQ such that that clock always has highest priority
 leay TimSvc,pcr Set the SETIME service routine's address
 os9 F$SSVC
 ldx ClkPrt,pcr Get Clock's Port Address
 clr ,x Reset the clock
 lda #$FF Start the clock ticking
 sta ,x
 tst ,x Clear initial interrupt
 puls cc Recover original interrupt mask
 puls dp,pc Restore and return
 page
*          Return Time-of-Day Routine
 spc 2
Time equ *
 ldx R$X,u Get address for returned data
 ldd D.YEAR Get Year and Month
 std ,x++
 ldd D.DAY Get Day and Hour
 std ,x++
 ldd D.MIN Get Minutes and Seconds
 std ,x
 clrb Indicate no errors
 rts
 spc 2
 emod
ClkEnd equ *
 page
 end
