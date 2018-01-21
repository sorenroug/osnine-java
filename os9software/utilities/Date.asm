
 nam DATE

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 Current date utility
 pag
 mod DATEND,DATNAM,PRGRM+OBJCT,REENT+1,DATE,DATMEM
DATNAM fcs "Date"

 fcb 4 edition number
*******************
* REVISION HISTORY
* edition 3: prehistoric
* edition 4: copyright notice removed from object 
*            stack and param space reserved
*******************



C$TIME set 'T (print) time option

C$COMA set ',
C$COLN set ':
C$CR set $0D
C$SPAC set $20

 org 0
SYSDAT equ .
S.YR rmb 1 System year
S.MO rmb 1 System month
S.DY rmb 1 System day
S.HH rmb 1 System hour
S.MM rmb 1 System minute
S.SS rmb 1 System second

DATLIN rmb 2 addr of datbuf
DATBUF rmb 40 output buffer
 rmb 200 Room for stack
 rmb 200 room for params
DATMEM equ .

DATSEP fcs ", 19"

MONTHS fcs "??? "
 fcs "January "
 fcs "February "
 fcs "March "
 fcs "April "
 fcs "May "
 fcs "June "
 fcs "July "
 fcs "August "
 fcs "September "
 fcs "October "
 fcs "November "
 fcs "December "

 pag
*****
* Date [t]
*   Print: month-name Dd, 19Yy  Hh:Mm:Ss
*
DATE pshs X save param ptr
 leax SYSDAT,U
 leau DATBUF,U
 stu DATLIN
 OS9 F$TIME
 bsr PRTDAT
 lda [,S++] check for time param
 eora #C$TIME
 anda #$FF-$20 Time param specified?
 bne DATE20 ..no; exit

 ldd #C$SPAC*256+C$SPAC
 std ,U++ two spaces
 bsr PRTIME Print time
DATE20 lda #C$CR
 sta ,U+
 lda #1 write to std output
 ldx DATLIN
 ldy #40
 OS9 I$WritLn
 bcs DATE90 ..return any error code
 clrb
DATE90 OS9 F$EXIT Exit

*****
* Prtime
*   Print "Hh:Mm:Ss"
*
PRTIME ldb S.HH
 bsr PRTNUM Print hour
 ldb S.MM
 bsr PRTI10 Print :minute
 ldb S.SS Print :second
PRTI10 lda #C$COLN
 sta ,U+
 bra PRTNUM

*****
* Prtdat
*   Print "month-name Dd, 19Yy"
*
PRTDAT leay MONTHS,PCR Ptr to month names
 ldb S.MO get month number
 beq PRTD30 ..too small; print "???"
 cmpb #12
 bhi PRTD30 ..too big; print "???"
PRTD10 lda ,Y+ skip over month name
 bpl PRTD10
PRTD20 decb month found?
 bne PRTD10 ..repeat until found
PRTD30 bsr PRTNAM Print month name
 ldb S.DY
 bsr PRTNUM Print day
 leay DATSEP,PCR
 bsr PRTNAM Print ", 19"
 ldb S.YR Print year

*****
* Prtnum
*   Print 8-bit Ascii number
*
* Passed: (B)=Number To Print
* Destroys: (D)
*
PRTNUM lda #'0-1
PRTN10 inca form hundred's digit
 subb #100
 bcc PRTN10
 sta ,U+
 cmpa #'0 zero?
 bne PRTN15 ..yes; don't print
 leau -1,U
PRTN15 lda #'9+1
PRTN20 deca form ten's digit
 addb #10
 bcc PRTN20
 sta ,U+ print
 addb #'0 form unit's digit
 stb ,U+ print
 rts

**********
* Prtnam
*   Print Ascii string, high bit set
*   on terminating character
*
* Passed: (Y)=String Addr
* Destroys: A,Cc
*
PRTNAM lda 0,Y
 anda #$7F Strip high bit
 sta ,U+
 lda ,Y+
 bpl PRTNAM
 rts

 emod Module Crc

DATEND equ *

