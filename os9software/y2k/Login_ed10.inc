 nam LOGIN

* Copyright 1980 by Microware Systems Corp.,

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!
*

 use defsfile

**********
* Login [<username> [,<password>] ]
*
*   Process user identification to Os-9
*    Consult Os-9 User's Guide for instructions
*

 ttl OS9 Login utility
 pag

 mod LOGEND,LOGNAM,PRGRM+OBJCT,REENT+1,LOGIN,LOGMEM
LOGNAM fcs "Login"

 fcb 10 edition number

*********************
* Edition History
*
* Ed  7 - Beginning of history
*
* Ed  8 - Conditionals added for LI, LII assembly  WGP 12/02/82
*
* Ed  9 - Optimized MOTD code for LI               KKK 12/03/82
*
* Ed 10 - Y2K compliant

MAXTRY set 3 Num of login attempts permitted
LINSIZ set 80 Input line buffer size
* normal equ 0 normal screen size
* small equ 1 small screen size
* Screen equ normal normal screen size
PSWBSZ equ 128 Password file max rcd length
C$CR set $0D
C$LF set $0A
C$SPAC set $20
C$PWDL set ', Password rcd field delimiter
C$SLSH set '/
C$COLN set ':

 org 0
PSWPTH rmb 1
MTDPTH rmb 1
RETRY rmb 1
USRNUM rmb 1 User's process id
BUFPTR rmb 2 Password file buffer ptr
LINPTR rmb 2 Input line buffer ptr
CENTURY rmb 1 Century flag
DATE rmb 3 System date
TIME rmb 3 System time
 rmb 250 System stack
STKTOP equ .
PSWBUF rmb PSWBSZ Password file buffer
LINBUF rmb LINSIZ Input line buffer
StatBuf rmb PD.OPT buffer for terminal path options
LOGMEM equ .

**********
* Password Record Format
*
* User name (comma delimiter)
* Password
* User Id (decimal 0-65535)
* Priority (decimal, 1-255 high)
* Execution Directory
* Data directory
* Execution Command
*
* Maximum Record Size = PSWBSZ (128)
**********

 pag
PSWFIL fcc "SYS/"
 fcc "PASSWORD"
 fcb C$CR
 fcc ",,,,,,,,,,,,,,," room for password name patching
TSMSG fcb C$LF,C$LF
 ifeq Screen-small
 fcc "OS-9 "
 else
 fcc "OS-9 Timesharing system   "
 endc
 ifeq LEVEL-1
 fcc "Level I   V1.2"
 else
 fcc "Level II  V1.1"
 endc
 ifeq Screen-small
 fcb C$LF
 endc
TSMSZ equ *-TSMSG
NAMPMT fcb C$LF
 fcc "User name?: "
NAMPSZ equ *-NAMPMT
DR.MSG fcc "Who?"
 fcb C$CR
PSWPMT fcc "Password: "
PSWPSZ equ *-PSWPMT
PSWERR fcc "Invalid password."
 fcb C$CR
USRMSG fcb C$LF
 fcc "Process #"
USRMSZ equ *-USRMSG
LOGMSG fcc " logged on "
 ifeq Screen-small
 fcb C$LF
 endc
LOGMSZ equ *-LOGMSG
WELCOM fcc "Welcome!"
 fcb C$CR
SPACES fcc "     "
DIRERR fcc "Directory not found."
 fcb C$CR
FILERR fcb C$LF
 fcc "Syntax Error in password file"
SORRY fcb C$LF
 fcc "It's been nice communicating with you."
 fcb C$LF
 fcc "Better luck next time."
 fcb C$CR
MOTDFL fcc "SYS/"
 fcc "MOTD"
 fcb C$CR
ROOT fcc "../../../../.." path to root
 fcb C$SPAC
pag
**********
* Login
*   Login New User, Establishing (From Password File)
*   User-Id, Priority, Exec-Dir, Data-Dir, Shell-Program

LOGIN leas STKTOP,U move stack to relative safety
 leay LINBUF,U
 sty LINPTR
 std ,--S save param size
 beq LOG04 ..zero; don't copy param
LOG03 lda ,x+
 sta ,y+
 cmpa #$D
 bne LOG03
LOG04 lda #READ.
 leax ROOT,PCR Get root pathlist
 OS9 I$ChgDir and change data dir
 lda #READ.
 leax PSWFIL,PCR Password file name
 OS9 I$Open
 lbcs LOG90 ..error; exit
 sta PSWPTH Save password path number
 lda #MAXTRY Max # of bad password tries
 sta RETRY
 ldd ,S++ Any parameter given?
 beq LOG05 ..no
 ldx LINPTR
 lda 0,X Any parameter given?
 cmpa #C$CR
 bne LOG15 ..yes; don't print header prompt
LOG05 leax TSMSG,PCR Get timesharing header
 ldy #TSMSZ
 lbsr MSGTIM Print timeshare header, time
LOG10 dec RETRY
 leax SORRY,PCR
 lbmi TOOB10 ..yes; print error, exit
 leax LINBUF,U
 stx LINPTR
 leax NAMPMT,PCR
 ldy #NAMPSZ
 lbsr INPLIN Print "user name: ", get input
 bcs LOG20
LOG15 lbsr SEARCH Find name in password file
 bcc LOG30 ..found; continue
LOG20 leax DR.MSG,PCR
LOG25 lbsr PRTLIN Print "who?"
 bra LOG10

LOG30 lbsr CHKNAM Password given?
 bcc LOG40 ..yes; continue
 ldx LINPTR
 lda 0,X
 cmpa #C$CR end of line?
 bne LOG35
 lda #C$PWDL
 sta ,x+
 stx LINPTR
 leax PSWPMT,PCR
 ldy #PSWPSZ
 lbsr EchoOFF disable terminal echo
 lbsr INPLIN Print "password: ", get input
 lbsr EchoON
 bcs LOG25 ..error; retry
 lbsr CHKNAM Valid password?
 bcc LOG40 ..yes; continue
LOG35 leax LINBUF,U
 stx LINPTR
 lbsr SEAR10 Maybe another user has same name?
 bcc LOG30 ..yes; check this password
 leax PSWERR,PCR
 bra LOG25 Print "try again", restart

LOG40 lda PSWPTH
 OS9 I$Close Close password file
 lbsr GETNUM User number from password file

 ifeq LEVEL-1
***** Illegal Oper *****
 ldy >D.PROC
 std P$USER,Y Save new user number
***** End Ill Oper *****
 else
 tfr D,Y
 OS9 F$SUser Set new User Index
 endc

 lbsr GETNUM Priority from password file
 tsta Less Than 256?
 lbne TOOBAD ..no; password file error
 tstb
 lbeq TOOBAD
 OS9 F$ID Get (A)=Process ID
 OS9 F$SPrior Set Priority
 sta USRNUM Save user ID
 lda #READ.
 leax MOTDFL,PCR MOTD file name
 OS9 I$Open
 bcc LOG50 ..error
 clra
LOG50 sta MTDPTH Save MOTD path number
 lda #EXEC.
 bsr CHGDIR set user's execution dir
 lda #READ.+WRITE.
 bsr CHGDIR set user's data dir
 leax USRMSG,PCR
 ldy #USRMSZ
 bsr PRINT Print "user # "
 leax USRNUM,U
 lbsr PRTNUM Print number
 leax LOGMSG,PCR
 bsr MSGTIM Print "logged on" (time)
 leax WELCOM,PCR
 bsr PRTLIN print "welcome!"
 lbsr MOTD print message of the day
 clrb return no error
 ldx BUFPTR
 leau 0,X module/path ptr
LOG80 lda ,U+
 cmpa #'0 skip to first separator
 bhs LOG80
 cmpa #C$PWDL
 beq LOG82 skip comma
 leau -1,U
LOG82 lda ,U+
 cmpa #C$SPAC
 beq LOG82 skip spaces
 leau -1,U
 pshs U save param ptr
 ldy #0
LOG85 lda ,U+
 leay 1,Y update param size
 cmpa #C$CR
 bne LOG85
 puls U
 ldd #OBJCT*256
 OS9 F$Chain Chain to user's shell
 OS9 F$PERR
LOG90 OS9 F$EXIT Exit if error

CHGDIR ldx BUFPTR
 OS9 I$ChgDir Change directory
 bcs CHDERR
 ldx BUFPTR
CHGD10 lda ,X+ skip over dir name
 cmpa #C$CR end of line?
 beq TOOBAD ..yes; syntax error
 cmpa #C$PWDL delimeter (comma)?
 bne CHGD10 ..no; skip
 lda #C$SPAC
CHGD20 cmpa ,X+ also skip any spaces
 beq CHGD20
 leax ,-X back up to non-blank
 stx BUFPTR
 rts

CHDERR leax DIRERR,PCR
 bra TOOB10

TOOBAD leax FILERR,PCR
TOOB10 bsr PRTLIN
 clrb return No error
 OS9 F$EXIT

PRTLIN ldy #256
PRINT lda #1 Print to std output path
 OS9 I$WritLn
 rts

MSGTIM bsr PRINT Print message
 leax SPACES,PCR
 ldy #3
 bsr PRINT Print spaces
 lbra DATIME Print date,time

INPLIN bsr PRINT Print prompt
 ldx LINPTR
 ldy #LINSIZ
 clra
 OS9 I$ReadLn
 rts

EchoOFF pshs D,X save regs
 leax StatBuf,U ptr to options buffer
 ldb #SS.OPT read the options
 clra of standard input path
 OS9 I$GetStt
 bcs EchoOF90 ..Error; don't modify options
 lda PD.DTP-PD.OPT,X get device type
 cmpa #DT.SCF is this an scf (terminal) type device?
 bne EchoOF90 ..No; don't modify options
 lda PD.EKO-PD.OPT,X get echo option
 pshs A save echo option
 clr PD.EKO-PD.OPT,X disable SCF's Auto-Echo
 bsr EchoON re-write path options
 puls a restore Echo control
 sta PD.EKO-PD.OPT,X
 puls D,X,PC return

EchoOF90 lda #$FF
 sta PD.DTP-PD.OPT,X set unknown device type
 Puls D,X,PC return

EchoON pshs CC,D,X save regs
 leax StatBuf,U
 lda PD.DTP-PD.OPT,X
 cmpa #DT.SCF SCF device?
 bne EchoON90 ..No; exit
 ldb #SS.OPT re-write options
 clra on std input file
 OS9 I$SetStt
EchoON90 puls CC,D,X,PC return

SEARCH pshs U
 lda PSWPTH
 ldx #0
 leau 0,X
 OS9 I$Seek Reset password file
 puls U
SEAR10 lda PSWPTH
 leax PSWBUF,U
 ldy #PSWBSZ
 OS9 I$ReadLn Read one password rcd
 bcs SEAR90 ..error; exit
 stx BUFPTR
 bsr CHKNAM Compare names in buffers
 bcs SEAR10 ..not equal; repeat
 stx BUFPTR
SEAR90 rts return

CHKNAM ldx BUFPTR
 ldy LINPTR
CHKN10 lda ,X+ Get next char from passwd rcd
 cmpa #C$PWDL ..field delimiter?
 beq CHKN90 ..yes; return found
 cmpa #C$CR ..end of record?
 beq CHKN80 ..yes; return found
 eora ,Y+
 anda #$FF-$20 Char match?
 beq CHKN10 ..yes; keep looking
CHKNER comb return Error
 rts

CHKN80 leax -1,X
CHKN90 lda ,Y+
 cmpa #C$PWDL
 beq CHKN99 Skip trailing delimiter
 cmpa #'0
 bhs CHKNER ..error if not delimeter
 leay -1,y
CHKN99 lda ,Y+
 cmpa #C$SPAC skip spaces
 beq CHKN99
 leay -1,y
 sty LINPTR Save updated line ptr
 stx BUFPTR
 clrb return Carry clear
 rts

MOTD10 lbsr PRTLIN print the line
MOTD lda MTDPTH MOTD path number
 beq MOTD99 ..sorry
 leax LINBUF,U load MOTD buffer pointer
 ldy #LINSIZ maximum bytes to read
 OS9 I$Readln read a MOTD line
 bcc MOTD10 exit if error
 lda MTDPTH load MOTD path number
 OS9 I$Close close MOTD path
MOTD99 clrb return no error
 rts return

**********
* Getnum
*   Get 16-Bit Ascii Number At Bufptr
*
* Returns: (D)=(Unsigned) Binary Number
*          Bufptr (Updated)
GETNUM ldx BUFPTR
 clra
 clrb
 pshs D,X,Y
GETN10 ldb ,X+ Get next digit
 subb #'0 Convert to binary
 cmpb #9 Numeric?
 bhi GETN90 ..no; exit
 clra
 ldy #10
GETN20 addd 0,S Plus previous sum * 10
 lbcs TOOBAD
 leay -1,Y
 bne GETN20
 std 0,S Save new sum
 bra GETN10 ..repeat

GETN90 lda -1,X
 cmpa #C$PWDL Followed by delimiter?
 lbne TOOBAD
 stx BUFPTR
 puls D,X,Y,PC Return

*****
* Datime
*   Print: Mm/Dd/Yy Hh:Mm:Ss
*
DATIME leax DATE,U
 OS9 F$TIME
 bsr PRTDAT
 lda #C$SPAC
 bsr OUTCHR
 bsr PRTIME Print time
 lda #C$CR
* Fall Through To Outchr


*****
* Outchr
*   Print Character In (A)
*
OUTCHR pshs D,X,Y
 lda #1 To standard output
 ldy #1 Print one char
 leax 0,S Which is on the stack
 OS9 I$WritLn
 puls D,X,Y,PC

*****
* Prtime
*   Print "HH:MM:SS"
*
PRTIME bsr PRTNUM
 bsr PRTI10
PRTI10 lda #C$COLN
 bra PRTD20

*****
* Prtdat
*   Print "YYYY/MM/DD"
*
PRTDAT
 clr CENTURY
 bsr PRTNUM Print year
 inc CENTURY
 bsr PRTD10
PRTD10 lda #C$SLSH
PRTD20 bsr OUTCHR
*      Bra Prtnum

*****
* Prtnum
*   Print 8-Bit Ascii Number In (,X+)
*
PRTNUM ldb ,X+
 lda #'0-1
PRTN10 inca Form Hundreds digit
 subb #100
 bcc PRTN10
 dec CENTURY
 beq SKIPCENT
 bsr PRTCENT
SKIPCENT inc CENTURY
 lda #'9+1
PRTN20 deca Form Tens digit
 addb #10
 bcc PRTN20
 bsr OUTCHR Print
 tfr B,A
 adda #'0 Form units digit
 bra OUTCHR

* Prints 19 if a=0, 20 if a=1, otherwise 21
* Destroys A
PRTCENT cmpa #'0
 beq PR19
 cmpa #'1
 beq PR20
 lda #'2
 bsr OUTCHR
 lda #'1
 bra OUTCHR

PR20 lda #'2
 bsr OUTCHR
 lda #'0
 bra OUTCHR

PR19 lda #'1
 bsr OUTCHR
 lda #'9
 bra OUTCHR

 emod Module Crc
LOGEND equ *

