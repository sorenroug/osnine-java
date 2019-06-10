 nam DIR

 use defsfile

 ttl OS9 Dir utility

REV set $01

 mod DIREND,DIRNAM,PRGRM+OBJCT,REENT+REV,DIRENT,DIRMEM

 ifeq Screen-small
MARGIN set 20 Output line margin
 else
MARGIN set 64 Output line margin
 endc

C$SLSH set '/
C$COLN set ':
C$SPAC set $20 Space

DIRPATH rmb 2
DirPN rmb 1
Extended rmb 1
ExeDir rmb 1
DISKPN rmb 1 Path number to disk
SUPZER rmb 1 Suppress leading zeroes if blank
BufPtr rmb 2
DATEBUF rmb 6
DIRREC rmb 29
LSN1 rmb 1
LSN2 rmb 1
LSN3 rmb 1
OPTBUF rmb 32
FileDesc rmb 13
Buffer rmb 280
DIRMEM equ .

*****
* REVISION HISTORY
* edition 3: Original Coco/Dragon edition
* edition 4: Not used
* edition 5: Show 2-digit year for year >= 100

DIRNAM fcs /Dir/
 fcb 5 edition number

DirOf fcb C$LF
 fcs " Directory of "

DEFDIR fcc "."
 fcb C$CR

Header fcb C$LF
 ifeq Screen-small
 fcc "CREATED ON   OWNER   NAME"
 fcb C$LF
 fcc "  ATTR     START      SIZE"
 fcb C$LF
 fcc "==============================="
 else
 fcc "Attr    Owner  Created on      Start      Size  Name"
 fcb C$LF
 fcc "===================================================="
 endc
 fcb C$CR
HeadEnd  equ   *

DIRENT leay <Buffer,u
 sty <BufPtr
 clr <ExeDir
 clr <Extended
 lbsr ParsOpts
 lda ,-x
 cmpa #C$CR End of argument string?
 bne DIRENT10 ..no
 leax >DEFDIR,pcr
DIRENT10 stx <DIRPATH
 lda #DIR.+READ.
 ora <ExeDir
 os9 I$Open
 lbcs Exit
 sta <DirPN
 pshs x
 leay >DirOf,pcr
 lbsr WrString
 ldx <DIRPATH
DIRENT20 lda ,x+ Print directory path name
 lbsr OUTCHR
 cmpx ,s
 bcs DIRENT20
 leas $02,s
 lbsr ParsOpts
 lbsr OUTSPC
 lbsr OUTSPC
 leax DATEBUF,u
 os9 F$Time
 leax DATEBUF+3,u
 lbsr PRTIME
 lbsr WrLine
 tst <Extended
 beq BEGIN ..no
 lda <DirPN
 ldb #SS.OPT
 leax <OPTBUF,u
 os9 I$GetStt
 lbcs Exit
 ldx OPTBUF+PD.DTB
 ldx $04,x
 ldd $04,x
 leay d,x   Get path of disk
 lda #'/
 lbsr OUTCHR
 lbsr WrString
 lda #'@
 lbsr OUTCHR
 lbsr OUTSPC
 leax <Buffer,u
 stx <BufPtr
 lda #READ.
 os9 I$Open Open entire disk
 lbcs  Exit
 sta <DISKPN
 leax >Header,pcr
 ldy #HeadEnd-Header
 lda #1
 os9 I$WritLn

BEGIN lda <DirPN
 ldx #0
 pshs u
 ldu #DIR.SZ*2
 os9 I$Seek
 puls u
 bra NEXTENT

PRENT tst <DIRREC Deleted entry?
 beq NEXTENT ..yes
 tst <Extended
 bne LSTEXT ..yes

* Multi-column listing
 leay DIRREC,u
 lbsr WrString
PRENT10 lbsr OUTSPC
 ldb <BufPtr+1
 subb #Buffer
 cmpb #MARGIN Space for more on line?
 bhi NEWLINE ..no
PRENT20 subb #10
 bhi PRENT20
 bne PRENT10
 bra NEXTENT

* Extended listing
* Read file descriptor of file
LSTEXT pshs u
 lda LSN3
 clrb
 tfr d,u
 ldx LSN1
 lda <DISKPN
 os9 I$Seek
 puls u
 bcs Exit
 leax <FileDesc,u
 ldy #13
 os9 I$Read
 bcs Exit

* Print extended entry
 ifeq Screen-small
 lbsr PRTDAT
 ldd <FileDesc+FD.OWN
 clr <SUPZER
 bsr HEXWORD
 bsr OUTSPC
 leay DIRREC,u
 lbsr WrString
 lbsr WrLine
 lbsr ATTRS
 bsr OUTSPC
 bsr OUTSPC
 bsr WrStart
 bsr WrSize
 else
 lbsr ATTRS
 bsr OUTSPC
 ldd <FileDesc+FD.OWN
 clr <SUPZER
 bsr HEXWORD
 bsr OUTSPC
 lbsr PRTDAT
 bsr OUTSPC
 bsr WrStart
 bsr WrSize
 bsr OUTSPC
 leay DIRREC,u   File name
 lbsr WrString
 endc
NEWLINE lbsr WrLine
NEXTENT leax DIRREC,u
 ldy #DIR.SZ
 lda <DirPN
 os9 I$Read
 bcc PRENT
 cmpb #E$EOF
 bne Exit
 clrb
Exit bsr WrLine
 os9 F$Exit

WrStart lda <LSN1
 bsr OUTHEX10
 ldd <LSN2
HEXWORD bsr OUTHEX20
 tfr b,a
 bsr OUTHEX
 inc <SUPZER
 bsr OUTHEX30
 bra OUTSPC

WrSize ldd <FileDesc+FD.SIZ
 bsr OUTHEX10
 tfr b,a
 bsr OUTHEX20
 bsr OUTSPC
 ldd <FileDesc+FD.SIZ+2
 bra HEXWORD

***************
* Subroutines
*
OUTHEX pshs A (a)=char to print in hex
 lsra
 lsra
 lsra
 lsra SHIFT High nibble down
 bsr OUTHEX40
 puls pc,a

*****
* Print number in hex
*
OUTHEX10 clr <SUPZER Suppress zeroe
OUTHEX20 bsr OUTHEX
OUTHEX30 anda #$0F Strip of ms nibble
OUTHEX40 tsta Is zero
 beq OUTHEX50 ..yes
 sta   <SUPZER Don't suppress zeroes now
OUTHEX50 tst <SUPZER suppres zero?
 bne OUT1HX ..no
 lda #C$SPAC
 bra OUTCHR
OUT1HX adda #'0 Convert to ascii
 cmpa #'9
 bls OUTCHR
 adda #'A-'9-1
 bra OUTCHR

OUTSPC lda #C$SPAC
OUTCHR pshs x
 ldx <BufPtr
 sta ,x+
 stx <BufPtr
 puls pc,x

PermFlgs fcc "dsewrewr"
 fcb $FF Stop byte

ATTRS ldb <FileDesc
 leax <PermFlgs,pcr
 lda ,x+
ATTRS10 lslb
 bcs ATTRS20
 lda #'-
ATTRS20 bsr OUTCHR
 lda ,x+
 bpl ATTRS10
 rts

WrString lda ,y
 anda #$7F  Strip high-order bit
 bsr OUTCHR
 lda ,y+
 bpl WrString
 rts

WrLine pshs  y,x,a
 lda #C$CR
 bsr OUTCHR
 leax <Buffer,u
 stx <BufPtr
 ldy #80
 lda #1
 os9 I$WritLn
 puls pc,y,x,a

*****
* Prtdat
*   Print "YY/MM/DD"
*
PRTDAT leax FileDesc+FD.DAT,u
 bsr PRTNUM
 bsr PRSLSH
 bsr PRSLSH
 bsr OUTSPC
 bsr PRTNUM
 bsr PRTNUM
 bra OUTSPC

PRSLSH lda #C$SLSH
 bra PRTI20

*****
* Prtime
*   Print "HH:MM:SS"
*
PRTIME bsr PRTNUM
 bsr PRTI10
PRTI10 lda #C$COLN
PRTI20 bsr OUTCHR

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*   Only used for date and time
PRTNUM ldb ,X+
PRTN10 subb #100 Remove any hundreds
 bcc PRTN10
PRTN20 lda #'9+1
PRTN30 deca Form Tens digit
 addb #10
 bcc PRTN30
 lbsr OUTCHR
 tfr b,a
 adda #'0  Form units digit
 lbra OUTCHR

ParsOpts  ldd   ,x+
 cmpa #$20    Space
 beq ParsOpts
 cmpa #$2C    Comma
 beq ParsOpts
 eora #'E
 anda #$DF
 bne PARSE10
 cmpb #$30
 bcc PARSE10
 inc <Extended
 bra ParsOpts
PARSE10 lda -$01,x
 eora #'X
 anda #$DF
 bne PARSE20
 cmpb #'0 followed by a letter?
 bcc PARSE20
 lda #EXEC.
 sta <ExeDir
 bra ParsOpts
PARSE20 rts
 emod

DIREND equ *
