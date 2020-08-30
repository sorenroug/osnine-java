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

CPORT equ $FD38
 use defsfile
*************************************************************
*
*  MODULE HEADER
*
Type set SYSTM+OBJCT
Revs set REENT+1
 mod ClkEnd,ClkNam,Type,Revs,ClkEnt,CPORT
ClkNam fcs /Clock/
 fcb 11

 fcc "FM11l2(C)SEIKOU"

*
* CLOCK DATA DEFINITIONS
*
TIMSVC fcb F$Time
 fdb TIME-*-2
 fcb $80 

CLKPRT equ M$Mem Stack has clock port address

*
*  DAYS IN MONTHS TABLE
*
MONTHS fcb 29 Uninitialized month
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

NOTCLK    lda   >$FD03
         bita  #$40
         beq   L00A5
         ldd   >$FD00
         std   <$0094
         lsra  
         bcc   L009F
         cmpb  >$FC69
         bne   L009F
         tst   >$FC60
         bne   L00A5
L004C    lda   >$FD05
         bmi   L004C
         lda   #$80

         sta   >$FD05
L0056    lda   >$FD05
         bpl   L0056
         lda   #$0A
         sta   >$FC82
         clr   >$FD05
L0063    lda   >$FD05
         bmi   L0063
         lda   #$80
         sta   >$FC60
         sta   >$FD05
L0070    lda   >$FD05

         bpl   L0070
         ldy   >$FC83
         lda   >$FC80
         ora   #$80
         sta   >$FC80
         clr   >$FD05
         clr   >$FC60
         ldx   <$0092
         sty   <-$20,x
L008D    leax  $02,x
         cmpx  #$FC60
         bcc   L009A

         tst   ,x
         bne   L009D
         bra   L008D

L009A    ldx   #$FC40
L009D    stx   <$0092
L009F    ldx   <$0092
         lda   #$40
         sta   $01,x
L00A5    ldd   D.Poll
         lbra  TICK50

* Read the control register. If the clock didn't cause the
* interrupt then exit.
CLKSRV   ldx   >CLKPRT,pcr
         lda   $01,x
         bita  #$04
         lbeq  NOTCLK

* Handle the interrupt
         ldd   $06,x
*
* UPDATE CURRENT TIME
*
         dec   D.Tick
         lbne  Tick47
         lda   <$0096
         beq   L00CF
         deca  
         sta   <$0096
         bne   L00E0
         lda   >$FD1D
         ora   #$C0
         sta   >$FD1D
L00CF    lda   <$009A
         beq   L00E0
         deca  
         sta   <$009A
         bne   L00E0
         lda   >$FD1D
         anda  #$7F
         sta   >$FD1D
L00E0    lda   <$0097
         beq   L00F1
L00E4    deca  
         sta   <$0097
         bne   L0102
         lda   >$FD35
         ora   #$40
         sta   >$FD35
L00F1    lda   <$009B
         beq   L0102
         deca  
         sta   <$009B
         bne   L0102
         lda   >$FD35
         ora   #$C0
         sta   >$FD35
L0102    ldd   D.Min
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
         clrb  
         bra   TICK12

TICK10    ldb   D.Month
TICK12 cmpa B,X End of month?
 bls TICK20 Branch if not
 ldd D.YEAR Get year & month
 incb COUNT Month
         cmpb  #12
         bls   TICK15
         inca  
         ldb   #$01
TICK15 std D.YEAR Update year & month
 lda #1 New day
TICK20 clrb NEW Hour
TICK25 std D.DAY Update day & hour
 clra NEW Minute
TICK30 clrb NEW Second
TICK35 std D.MIN Update minute & second
         lda   #100
         sta   D.Tick
Tick47 ldd D.Clock get clock routine ptr
TICK50 std D.SvcIRQ set IRQ service routine
 jmp [D.XIRQ] enter system

*****
*
*  Clock Initialization Entry
*
ClkEnt    equ   *
         pshs  dp
         clra  
         tfr   a,dp
         pshs  cc
         lda   >$FC61
         ora   #$10
         sta   >$FC61
         sta   >$FD02
         lda   #100
 sta D.Tick
         lda   #2   #TickSec/10 set ticks/time slice
 sta D.TSlice
 sta D.Slice
 orcc #IntMasks set interrupt masks
 leax CLKSRV,pcr GET SERVICE ROUTINE
 stx D.IRQ SET INTERRUPT VECTOR
         ldx   >CLKPRT,pcr
         ldd   #$0009
         std   $02,x
         clra  
         clrb  
         std   $04,x
         ldd   #$00BF
         std   $06,x
         clr   $01,x
         lda   #$40
         sta   ,x
         lda   #$01
         sta   $01,x
         lda   #$80
         sta   ,x
 puls cc retrieve masks
 leay TIMSVC,PCR
 OS9 F$SSVC SET TIME SERVICE ROUTINE
 puls pc,dp

 page
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
