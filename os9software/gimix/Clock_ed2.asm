
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
         sta   D.TSec
         sta   D.Tick
         lda #1 Set ticks / time-slice
         sta   D.TSlice
         sta   D.Slice
         orcc #IRQMask+FIRQMask Set intrpt masks
         leax  >CLKSRV,pcr
 stx D.IRQ Set interrupt vector
 leas -5,S get scratch
 ldx #D.Month Get month ptr
         bsr   CNVBB
         stb   ,s
         bsr   CNVBB
         stb   $01,s
         bsr   CNVBB
         stb   $02,s
         bsr   CNVBB
         stb   $03,s
         bsr   CNVBB
         stb   $04,s
         ldx   >CLKPRT,pcr
         ldd   #$FF02
 sta LatchRst,X Reset latches
 lda Status,X Clear any interrupt
 stb Control,X enable 100 millisec line
 lda 0,S retrieve month
         beq   SkipSet
         sta   $07,x
         lda   $01,s
         beq   SkipSet
         sta   $06,x
         lda   $02,s
         sta   $04,x
         ldd   $03,s
         sta   $03,x
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
         pshs  cc
 orcc #IRQMask+FIRQMask Set interrupt masks
TIME10    lda   $02,x
         sta   D.Sec
         lda   $03,x
         sta   D.Min
         lda   $04,x
         sta   D.Hour
         lda   $06,x
         sta   D.Day
         lda   $07,x
         sta   D.Month
         lda   <$14,x
         rora  
         bcs   TIME10
         puls  cc
 ldx #D.Month Get date ptr
TIME20 lda 0,X Get bcd byte
         anda  #$F0
         tfr   a,b
         eora  ,x
         sta   ,x
         lsrb  
         lsrb  
         lsrb  
         lsrb  
 lda #10
 mul
 addb 0,X Add lsn
 stb ,X+ Save converted byte
 cmpx #D.SEC+1
 bcs TIME20

         ldx   4,u
         ldd   D.Year
         std   ,x
         ldd   D.Day
         std   $02,x
         ldd   D.Min
         std   $04,x
         clrb  
         rts   

         emod
eom      equ   *
