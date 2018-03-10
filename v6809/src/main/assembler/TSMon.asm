 nam TSMON

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Timesharing terminal monitor
 pag
*****
* Tsmon [<pathname>]
*
* Timesharing monitor utility.
* Author: Robert Doggett

* Wait for activity (Cr) on Std Input,
* then Forks to Login for user verification.
* If a pathname is specified, it is opened
* for update, and used as Std Input, Std Output
* and Std Error.

 mod TSMEND,TSMNAM,PRGRM+OBJCT,REENT+1,TSMON,TSMMEM
TSMNAM fcs "Tsmon"

 fcb 6 edition number
*********************
* Edition History
*
* Ed  4 - Beginning of history
*
* Ed  5 - file downcased and translated to new defs  WGP  12/2/82
*
* Ed  6 - changed loc of buffer for readline to stack  WGP  12/3/82

 org 0
TSPROC rmb 1 Child process id
LINPTR rmb 2 Command line pointer
LINLEN rmb 2 Command line length
 rmb 250 Stack space
 rmb 200 room for params
TSMMEM equ .

LOGIN fcc "LOGIN"
TSMEOL fcb C$CR
TSMRTI rti

**********
* Tsmon
*   Follow Activity On Input Port
TSMON stx LINPTR Save command line ptr
 std LINLEN Save command line length
TSMON2 cmpd #2 null parameter?
 blo TSMON4 ..no; use parent's std i/o
 lda 0,X parameter given?
 cmpa #C$CR
 beq TSMON4 ..no; use parent's std i/o
 clra
 OS9 I$Close close std input
 inca
 OS9 I$Close close std output
 inca
 OS9 I$Close close std error
 lda #UPDAT.
 OS9 I$OPEN Open new std input
 bcs TSEXIT
 OS9 I$DUP Dup  new std output
 bcs TSEXIT
 OS9 I$DUP Dup  new std error
 bcs TSEXIT
TSMON4 leax <TSMRTI,PCR
 OS9 F$ICPT set up dummy intercept

TSMON6 clra
 leax ,-S
 ldy #1
 OS9 I$ReadLn wait for terminal activity
 leas 1,S
 bcs TSMON6 ..error; retry
 lda #OBJCT
 clrb
 leax <LOGIN,PCR
 leau <TSMEOL,PCR
 ldy #0
 OS9 F$FORK start login
 bcs TSMON6 Error; restart
 sta TSPROC save process id
TSMON8 OS9 F$WAIT Wait for death
 cmpa TSPROC Child go away?
 bne TSMON8
 ldx LINPTR Reset line pointer
 ldd LINLEN Reset line length
 bra TSMON2 ..restart

TSEXIT OS9 F$EXIT Error exit

 emod Module Crc

TSMEND equ *

