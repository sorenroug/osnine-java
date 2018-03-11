
 nam Rename Utility
 ttl Module Header & data definitions

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!
*

 use defsfile

********************
*
*  Rename Utility
*
Type set PRGRM+OBJCT
Revs set REENT+1

 mod RenEnd,RenNam,Type,Revs,Rename,RenMem
RenNam fcs /Rename/

 fcb 6 Edition number
*****
* REVISION HISTORY
* edition 5: prehistoric
* edition 6: copyright notice removed from object;
*            stack and param space reserved
*****

*
* Data Storage Definitions
*
DRCTRY rmb 2 Directory name ptr
OLDNAM rmb 2 Old file name ptr
OLDSIZ rmb 1 Old file name size
NEWNAM rmb 2 New file name ptr
NEWSIZ rmb 2 New file name size
 rmb 256 stack space
 rmb 200 room for params
RenMem equ .

 ttl Main Routine
 page
*****
*
*  Rename Utility
*
* Rewrites File Name in Directory
*
Rename cmpd #4 Sufficient parameters?
 lbcs BADREN Branch if not
 stx DRCTRY Set directory name ptr
* find file
 lda #WRITE. Write permitted?
 OS9 I$OPEN Try to open file
 bcc RENM10 Branch if successful
 cmpb #E$FNA File not accessible?
 bne RENXIT Branch if not
 ldx DRCTRY Get file name ptr
 lda #DIR.+WRITE. Is it directory?
 OS9 I$OPEN Try to open file
 bcs RENXIT Brnach if not successful
RENM10 stx NEWNAM Save new name ptr
* get options
 ldb #SS.OPT Get path options
 leax PD.OPT,U Get direct page option ptr
 OS9 I$GetStt Get file status
 bcs RENXIT Branch if error
 OS9 I$Close Close file
 bcs RENXIT Branch if error
 ldb PD.DTP Get device type
 cmpb #DT.RBF Rbf type device?
 bne BADREN Branch if not
 bsr PFNS Process file names
 bcs RENXIT Branch if error
* move data directory to file's directory
 ldx OLDNAM Get old name ptr
 lda #$0D Get carriage return
 sta -1,X Terminate directory name
 ldx DRCTRY Get directory name ptr
 lda #UPDAT. Change data directory
 OS9 I$ChgDir Change directory
 bcs RENXIT Branch if errors
 ldx NEWNAM Get new name ptr
 ldb NEWSIZ+1 Get new name size
 decb Get Name end offset
 lda B,X Get last name byte
 ora #$80 Set sign
 sta B,X Update byte
 incb Re-adjust Name size
 cmpb OLDSIZ Names same size?
 bne RENM20 Branch if not
 leay 0,X Copy new name ptr
 ldx OLDNAM Get old name ptr
 OS9 F$CmpNam Compare names
 bcc RENM30 Branch if the same
RENM20 ldx NEWNAM Get new name ptr
 lda #READ.
 OS9 I$OPEN Try to open file
 bcc BADREN Err: name in use
 cmpb #E$PNNF Path name not in use?
 bne BADREN Branch if not
RENM30 leax <CurDir,PCR Get current directory name ptr
 lda #DIR.+UPDAT. Open directory for update
 OS9 I$OPEN Open file
 bcs RENXIT Branch if error
 ldx PD.DCP Get file name directory position
 ldu PD.DCP+2
 OS9 I$SEEK Seek to position
 bcs RENXIT
 ldx NEWNAM Get new name ptr
 ldy NEWSIZ Get new name size
 OS9 I$Write Write new name
 bcs RENXIT
 OS9 I$Close Close directory
 bcs RENXIT
 clrb
RENXIT OS9 F$EXIT

BADREN ldb #E$BPNam Err: bad path name
 bra RENXIT


CurDir fcb '.,$0D Current directory name


PFNS ldx DRCTRY Get directory name ptr
 bsr RBFPNam Parse name
 ldu DRCTRY Get directory name ptr
 lda 0,U Get first byte
 cmpa #PDELIM Is it pathlist delimiter?
 beq PFNS10 Branch if so
 lda 0,Y Get next byte
 cmpa #PDELIM Is it pathlist delimiter?
 beq PFNS10 Branch if so
 leau <CurDir,PCR Get directory name ptr
 stu DRCTRY Set directory name ptr
 bra PFNS20
PFNS10 leax 0,Y Move to next name
 bsr RBFPNam Parse name
 bcs PFNERR Branch if error
PFNS20 stx OLDNAM Set beginning of last name
 stb OLDSIZ Set old name size
 leax 0,Y Get beginning of next name
 bsr RBFPNam Parse name
 bcc PFNS20 Branch if good name
 ldb OLDSIZ was last name '.' type?
 beq PFNERR branch if so
 ldx NEWNAM get new name ptr
 OS9 F$PrsNam Parse name
 bcs PFNERR Branch if error
 lda 0,Y Get next byte
 cmpa #PDELIM Is it pathlist delimiter?
 beq PFNERR Branch if so
 cmpb #30 Is name too big?
 bcc PFNERR Branch if so
 stx NEWNAM Save new name ptr
 clra
 std NEWSIZ Save new name size
 rts

PFNERR comb
 ldb #E$BPNam Err: bad path name
 rts


RBFPNam OS9 F$PrsNam Is there normal name?
 bcc RBFPN50 Branch if so
 clrb CLEAR Byte count
 leau 0,X Copy pathlist ptr
RBFPN10 lda ,U+ Get next character
 bpl RBFPN20 Branch if not last character
 incb COUNT Character
 cmpa #PDIR+$80 is it directory name?
 bne RBFPN30 branch if not
RBFPN20 incb count character
 cmpa #PDIR is it directory name?
 beq RBFPN10 branch if so
RBFPN30 decb UNCOUNT Last character
 beq RBFPN40 Branch if no name
 leay -1,U Get end-of-name ptr
 cmpb #3 Legal directory name?
 bcc RBFPN40 Branch if not
 clrb clear carry
 bra RBFPN50
RBFPN40 coma SET Carry
RBFPN50 rts

 emod Module Crc

RenEnd equ *


 end
