         nam   Clock
         ttl   os9 system module    


 use defsfile

CPORT equ $FCC2

Type set SYSTM+OBJCT
Revs set REENT+1
 mod ClkEnd,ClkNam,Type,Revs,ClkEnt,CPORT

ClkNam fcs /Clock/
 fcb 3 Edition number


CLKPRT equ M$Mem Stack has clock port address

TIMSVC fcb F$Time
 fdb TIME-*-2
 fcb F$Timer+$80
 fdb TIMER-*-2
 fcb $80

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

NOTCLK ldd   D.Poll
         lbra  L00B6

CLKSRV   ldx   >CLKPRT,pcr
 lda 1,X Get control register
         bita  #$40
         beq   NOTCLK
         sta   D.LtPen
         lda   ,x
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
 lda   #50  Get ticks/second

 sta D.Tick
TICK50   leau  0,s
         ldx   D.SysIRQ
         cmpx  D.XIRQ
         beq   L0093
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
L0093    pshs  u
         ldx   D.TimTbl
         beq   L00B0
         ldb   #$40
         pshs  x,dp,b
L009D    ldy   ,x++
         beq   L00AE

         ldu   ,x++
         stx   $02,s
         jsr   ,y
         ldx   $02,s
         dec   ,s
         bne   L009D
L00AE    puls  x,dp,b
L00B0    ldd   D.Clock
         puls  u
         leas  ,u
L00B6    std   D.SvcIRQ
         jmp   [>D.XIRQ]

*****
*
*  Clock Initialization Entry
*
ClkEnt   clrb  
         ldx   D.TimTbl
         bne   L0104
         pshs  cc
         lda   #50
         sta   D.Tick
         lda   #$05
         sta   D.TSlice
         sta   D.Slice
         ldd   #$0100
         pshs  u
         os9   F$SRqMem 
         bcs   L00E5
         stu   D.TimTbl
         ldy   #$0000
         ldb   #$80
L00DF    sty   ,u++
         decb  
         bne   L00DF
L00E5    puls  u
 orcc #IRQMask+FIRQMask Set intrpt masks
         leax  >CLKSRV,pcr
         stx   D.IRQ
         ldx   >CLKPRT,pcr
         lda   0,x
         lda   1,x
         ora   #$18
         sta   1,x
         puls  cc
 leay TIMSVC,PCR
 OS9 F$SSVC Set time service routine
L0104    rts   


TIMER    pshs  cc
 orcc #IRQMask+FIRQMask Set intrpt masks
         ldx   D.TimTbl
         ldb   #$40
         ldy   R$X,u
         beq   L0132
L0112    ldy   ,x
         beq   L0122
         leax  $04,x
         decb  
         bne   L0112
         puls  cc
         comb  
         ldb   #E$Poll
         rts   

L0122    ldy   R$X,u
         sty   ,x++
         ldy   R$U,u
L012B    sty   ,x
L012E    puls  cc
         clrb  
         rts   

L0132    ldy   R$U,u
L0135    cmpy  $02,x
         beq   L0141
         leax  $04,x
         decb  
         bne   L0135
         bra   L012E
L0141    decb  
         beq   L0155
L0144    ldy   $04,x
         beq   L0155
         sty   ,x++
         ldy   $04,x
         sty   ,x++
         decb  
         bne   L0144
L0155    ldy   #$0000
         sty   ,x++
         bra   L012B


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
