
 nam Printerr

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 English error message printing utility
 pag
**********
* Printerr
*   Translate OS-9 error numbers to English messages
* Author: Bob Doggett

* Replaces OS-9 Prterr service routine.
* Note: once this is done, there is no provision
* for returning to OS-9's original error routine.

* Speed could be improved, using fixed-length
* random file.  The text file format used by this
* version may be edited, and is shorter than
* a random file would be.

* Caution: this version uses quite a chunk of
*  User's stack, and may be unsuitable for some
*  processes.

 mod PEREND,PERNAM,PRGRM+OBJCT,REENT+1,PRTERR,PERMEM
PERNAM fcs "Printerr"

 fcb 6 edition number

*********************
* Edition History
*
* Ed  5 - Beginning of history
*
* Ed  6 - Conditionals added for LI, LII assembly  WGP  12/2/82

 pag

BUFSIZ set 80 Errmsg file max rcd length
C$CR set $0D

* Execution-Time Stack temporary storage
 org 0
PRTPTH rmb 1 User's std error path
ERRPTH rmb 1 Errmsg path number
ERRNUM rmb 1 Error number
BUFPTR rmb 2 Line buffer ptr
IOBUFF rmb BUFSIZ Line buffer
 rmb 1 anonymous scratch
PERMEM equ .

ERRFIL fcc "/D0/"
 fcc "SYS/"
 fcc "ERRMSG"
 fcb C$CR
 fcc ",,,,,,,,,,,," room for name patch
ERRMSG fcc "Error #"
 fcb -1

SVCTBL equ * Replacement for sys call vector
 fcb F$PERR
 fdb PERROR-*-2
 fcb $80 end of table

 pag
**********
* Printerr
*   Translate OS-9 errors to English messages
*   using message strings in Errmsg file
*
* Format of Errmsg file:
*  Number   (0-3)   Ascii error number (0-255)
*  Delim       1    Any byte <= $2F
*  Message  (0-n)   Variable length message string

PRTERR clra
 leax <PERNAM,PCR
 OS9 F$LINK Link to self
 bcs EXIT ..error; fail
 leay <SVCTBL,PCR
 OS9 F$SSVC redirect system prterr routine
 clrb
EXIT OS9 F$Exit

PERROR ldx D.Proc
 lda P$PATH+2,X Get user's std error path
 beq PERR99 ..none; exit

 ifgt LEVEL-2
 pshs X save current process ptr
 ldx D.SysPrc
 stx D.Proc make System process current
 endc

 leas -PERMEM,S chop out temp storage
 ldb R$B,U
 leau 0,S
 sta PRTPTH,U
 stb ERRNUM,U save error number
 bsr PRTNUM print "error #n"
 lda #READ.
 leax ERRFIL,PCR Errmsg file name
 OS9 I$Open
 sta ERRPTH,U save path number
 bcs PERR90 ..error; exit
 bsr SEARCH find error in errmsg file
 bcs PERR80 ..Error; exit
 bne PERR80 ..not found; exit
PERR20 bsr PRTLIN print error message
 bsr READRCD get next record
 bcs PERR80 ..Error; exit
 ldb 0,X
 cmpb #'0 does it begin with a delimiter?
 blo PERR20 ..Yes; keep printing

PERR80 lda ERRPTH,U
 OS9 I$Close close errmsg file
PERR90 leas PERMEM,S

 ifgt LEVEL-2
 puls X
 stx D.Proc restore user's process ptr
 endc

PERR99 clrb return carry clear
 rts

SEARCH bsr READRCD get next Errmsg Record
 bcs SEAR90 ..error; exit
 bsr GETNUM get number in i/o buffer
 cmpa #'0 Followed by separator?
 bhs SEARCH ..no; skip this record
 cmpb ERRNUM,U Is this the error number?
 bne SEARCH ..no; repeat
SEAR90 rts RETURN

READRCD lda ERRPTH,U
 leax IOBUFF,U
 ldy #BUFSIZ
 OS9 I$ReadLn read one errmsg rcd
 rts

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*
PRTNUM leax ERRMSG,PCR ptr to "error #"
 leay IOBUFF,U
 lda ,X+
PRTN05 sta ,Y+
 lda ,X+
 bpl PRTN05

 ldb ERRNUM,U
 lda #'0-1
PRTN10 inca form hundreds digit
 subb #100
 bcc PRTN10
 sta ,Y+ Put hundreds digit in buffer
 lda #'9+1
PRTN20 deca form tens digit
 addb #10
 bcc PRTN20
 sta ,Y+ Put tens digit in buffer
 tfr B,A
 adda #'0 form units digit
 ldb #C$CR
 std ,Y+ Put units digit in buffer
 leax IOBUFF,U

PRTLIN ldy #80
PRINT lda PRTPTH,U Print to std error path
 OS9 I$WritLn
 rts

GETNUM clrb
GETN10 lda ,X+
 suba #'0
 cmpa #9 Numeric character?
 bhi GETN90 ..no; done
 pshs A save digit
 lda #10
 mul multiply partial result by 10
 addb ,S+ add in next digit
 bcc GETN10 ..continue until overflow
GETN90 lda -1,X retreive separator character
 rts

 emod Module Crc

PEREND equ *
