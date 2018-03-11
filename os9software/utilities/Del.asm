
 nam DEL

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

 ttl OS9 File delete utility
 pag
*****
* Del [-x] <pathname> {<pathname>} [-x]
*
* Author: Kim Kempf

 mod DELEND,DELNAM,PRGRM+OBJCT,REENT+1,DELENT,DELMEM
DELNAM fcs "Del"

 fcb 5 edition number
*****
* REVISION HISTORY
* edition 5: prehistoric
*****

C$SYS set 'X Use execution directory
C$Comma set ',
C$Space set $20
C$Eol set $0D
C$LF set $0A
C$OptDlm set '-

 org 0
DelMode rmb 1
 rmb 250 stack room
 rmb 200 parameter room
DELMEM equ .

UseMsg fcb C$LF
 fcc "Use: Del [-x] <path> {<path>} [-x]"
 fcb C$Eol

DELENT lda 0,X Get the first byte
 cmpa #C$Eol
 beq BadOpt Print the use message
 lda #READ.
 sta DelMode Default to non-sys delete
 bsr PrsOpt Parse options
 leax -1,X Backup to start of names
Del07 lda DelMode
 OS9 I$DeletX
Del08 bcs DelExit Branch if error
 lda 0,X Get next byte
 cmpa #C$Eol End of line?
 bne Del07 Branch if more
 clrb
DelExit OS9 F$EXIT

PrsOpt lda ,X+ Parse parameters
 cmpa #C$Space
 beq PrsOpt Skip spaces
 cmpa #C$Comma
 beq PrsOpt Skip commas
 cmpa #C$OptDlm Option delimiter
 bne Prso20 no, branch
 bsr GetOpt Do option and rts
 leax 1,X adjust pointer
 rts

Prso20 pshs X Save the param ptr
Prso30 lda ,X+
 cmpa #C$Space
 beq Prso30
 cmpa #C$Comma
 beq Prso30
 cmpa #C$OptDlm Option delimiter?
 beq Prso40
 cmpa #C$Eol
 bne Prso30
Prso35 puls X Restore ptr
 rts

Prso40 bsr GetOpt
 lda #C$EOL Get an eol
 sta -2,X ..and blot the options
 bra Prso35

GetOpt lda ,X+ Get the option char
 eora #C$SYS Delete system files?
 anda #$FF-$20 Upper or lower case
 bne BadOpt branch if bad option
 lda #EXEC. Get exec mode
 sta DelMode Save it
 rts

BadOpt leax UseMsg,PCR
 ldy #80
 clra
 os9 I$Writln
 clrb Return no error
 bra DelExit

 emod Module Crc

DELEND equ *

