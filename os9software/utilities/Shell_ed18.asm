
 nam OS9 User interface: shell
 ttl Definitions

 use defsfile

**********
* Shell module
*
* User interface to OS-9 functions
*
*   Consult OS-9 User's Guide for complete
*   details of syntax and use.
*
* Author: Robert Doggett

************
* Edition History

* Edition      Change Made                                  By
* -- --------  -------------------------------------------- ---
* 17 01/20/83  Fix RESET to properly DUP paths on errors    KKK

Edition equ 18 current edition

 mod SHLEND,SHLNAM,PRGRM+OBJCT,REENT+1,SHELL,SHLMEM
SHLNAM fcs "Shell"

 fcb Edition 

Yes set 1
NO set 0
PIPES set YES

BUFSIZ set 200 Input line buffer size
C$MEM set '# set memory size char
C$COMT set '* Comment parameter
C$LF set $0A
C$SPAC set $20
C$COMA set ',
C$DEAD set '-
C$LPAR set '( Shell recursion rsetest
C$RPAR set ') ..end recursion
C$CR set $0D Carriage return
C$PIPE set '! pipeline separator
C$CURR set '& Concurrent execution separator
C$SEQ set '; Seqential excution separator
C$RINP set '< Redirect input char
C$ROUT equ '> Redirect output request

**********
* Static Storage Offsets
*
 org 0
 rmb 1 Std input  temp for redirection
 rmb 1 Std output temp for redirection
 rmb 1 Std error temp for redirection
MEMSIZ rmb 1 fetus (b) memory requirement
MODNAM rmb 2 fetus (x) module/path name
PRMSIZ rmb 2 fetus (y) parameter size
PRMPTR rmb 2 fetus (u) parameter ptr
MODSTK rmb 2 Language module Stack size
USEFUL rmb 1 0=no useful change produced
PRNCNT rmb 1 Parenthesis level
OPTS equ . Above bytes are cleared each SHLINE
PRINT rmb 1 0=print enabled
INPTEE rmb 1 0=don't echo std input lines
ERRXIT rmb 1 Not 0=exit if error
TEMP rmb 1 temporary for setpr
MODBUF rmb M$Mem+2 Buffer for Module header
 rmb 5 room for "-P X " on procedure files
SHLBUF rmb BUFSIZ
 rmb 256 Stack space
 rmb 200 room for params
SHLMEM equ .

HELLO fcb C$LF
 fcc "Shell"
 fcb C$CR

SHLPMT fcb C$LF
 fcc "OS9:"
SHLPSZ equ *-SHLPMT

 ttl Main Routines
 pag
**********
* Intercept routine
SHICPT clr R$A,S
 stb R$B,S
 rti

**********
* Shell Entry

SHELL leas -5,S make room in case first char is "("
 pshs D,X,Y save param size, ptr, stack top
 ldb #SHLBUF-1
 lbsr CLRMEM clear out shell's temps
 leax <SHICPT,PCR get dummy intercept routine
 OS9 F$ICPT set up to prevent death
 puls D,X Restore parameter ptr
 std PRMSIZ Any parameters?
 beq SHEL10 ..no; enter shell proper
 lbsr SHLINE process it as a shell line
 lbcs EXIT ..error; return it
 tst USEFUL Was anything useful done?
 lbne SHEL90 ..yes; return (no error)

SHEL10 lds ,S++ recover parameter space
 leax <HELLO,PCR "OS9 Shell" BANNER
 tst PRINT Prompting turned off?
 bne SHEL30 ..yes
 bsr SHOUT
SHEL20 leax <SHLPMT,PCR
 ldy #SHLPSZ
SHEL25 tst PRINT prompting turned off?
 bne SHEL30 ..yes
 bsr SHOU10 print prompt
SHEL30 clra READ Standard input
 leax SHLBUF,U get buffer ptr
 ldy #BUFSIZ
 OS9 I$ReadLn Read one line from terminal
 bcc SHEL40 Continue if no error
 cmpb #E$EOF end of file?
 beq SHEL80 ..yes; exit (no error)
SHEL35 tst ERRXIT Exit if errors?
 bne EXIT ..yes; return error
 OS9 F$PERR print error message
 bra SHEL20 ..repeat

SHEL40 cmpy #1 anything entered?
 bhi SHEL45 ..yes; try to do it
 leax SHLPMT+1,PCR Print new prompt
 ldy #SHLPSZ-1
 bra SHEL25 ..repeat

SHEL45 tst INPTEE copy input to std error?
 beq SHEL50 ..no; continue
 bsr SHOUT
SHEL50 lbsr SHLINE process shell line
 bcc SHEL20 ..repeat if no error
 tstb SYNTAX Error?
 bne SHEL35 ..no; report error
 bra SHEL20

SHEOF fcc "eof"
 fcb C$CR
SHEL80 tst PRINT prompting?
 bne SHEL90 ..no; just exit
 leax <SHEOF,PCR
 bsr SHOUT
SHEL90 clrb don't return error
EXIT OS9 F$EXIT Terminate

SHOUT ldy #80
SHOU10 lda #2 Output to error path
 OS9 I$WritLn
 rts

CLRMEM clr B,U
 decb
 bpl CLRMEM
 rts

 ttl Tables and lists
 pag
**********
* Partbl
* Table of Shell parameter Functions
*
PARTBL fdb SHCOMT-*
 fcb C$COMT+$80 Comment line
 fdb SHWAIT-*
 fcs "W"
 fdb SHCDIR-*
 fcs "CHD"
 fdb SHCXDR-*
 fcs "CHX"
 fdb SHEXEC-*
 fcs "EX"
 fdb SHKILL-*
 fcs "KILL" Kill process
 fdb SHXERR-*
 fcs "X" Exit if error
 fdb SHNXER-*
 fcs "-X" Don't exit if error
 fdb SHPRMT-*
 fcs "P" print prompt
 fdb SHNPRM-*
 fcs "-P" no prompt
 fdb SHTEE-*
 fcs "T" Echo input as read
 fdb SHNTEE-*
 fcs "-T" ..don't echo input
 fdb SHSETP-*
 fcs "SETPR" set <proc id> <priority>
 fdb CLRRTS-*
 fcb C$SEQ+$80
 fdb 0

**********
* Trmtbl
*   Table of Shell Options
*
TRMTBL
 ifeq PIPES-Yes
 fdb SHPIPE-*
 fcs "!" Build pipe
 endc
 fdb SHSEQ-*
 fcs ";" Sequential fork
 fdb SHCURR-*
 fcs "&" Concurrent fork
 fdb SHEOL-*
 fcb C$CR+$80 end of line (seq fork)
PRETBL
* rest may be pre-parameters
 fdb SHRDER-*
 fcs ">>" Redirect error
 fdb SHRDIN-*
 fcs "<" Redirect input
 fdb SHRDOU-*
 fcs ">" Redirect output
 fdb SHCMEM-*
 fcs "#" Change memory size
 fdb 0

* Lists Are Terminated By Negative Byte
*
PRNLST fcb C$CR,C$LPAR,C$RPAR,$FF
TRMLST fcb C$CR,C$PIPE,C$MEM,C$CURR,C$SEQ,C$RINP,C$ROUT,$FF
*
* Trmlst Must be in Ascending Sequence

 ttl Line Processing routines
 pag
**********
* Shline
*   process one Shell command line
*   (Will Never return if Chain is Requested)
*
* Passed: (X)=Shell command; Cr Terminated
*         (U)=Static Storage ptr
* Destroys: D,X,Y
* Error: CC=Set
*
SHLINE ldb #OPTS-1
 bsr CLRMEM clear option defaults
SHLI10 clr MEMSIZ
 leay <PARTBL,PCR Shell parameter table
 lbsr SHFUNC ..process shell parameters
 bcs SHLI90 ..error; return it
 cmpa #C$CR end of line?
 beq SHLI90 ..yes; return
 sta USEFUL ..something useful about to happen
 cmpa #C$LPAR Left paren?
 bne SHLI50 ..no; process shell command
 leay SHLNAM,PCR get name of self
 sty MODNAM ..setup to recurr
 leax 1,X
 stx PRMPTR passing parenthesized stuff
SHLI20 inc PRNCNT Deeper into parens
SHLI30 leay <PRNLST,PCR get paren list
 bsr SCAN Search for end paren
 cmpa #C$LPAR ..another open paren?
 beq SHLI20 ..yes
 cmpa #C$RPAR end paren?
 bne SHLI70 ..no; syntax error
 dec PRNCNT Outermost level?
 bne SHLI30 ..no; keep searching
 lda #C$CR
 sta -1,X Blast end paren
 bra SHLI60 ..process parameters

SHLI50 bsr SHOPTS save module, process pre-param opts
 bcs SHLI90 ..error; return it
SHLI60 leay <TRMLST,PCR List of param terminators
 bsr SCAN Skip over params
 tfr X,D
 subd PRMPTR
 std PRMSIZ save parameter size for birth
 leax -1,X Back up to terminator
 leay <TRMTBL,PCR Post-param function tbl
 bsr SHFUNC process command
 bcs SHLI90 ..error; exit
 ldy MODNAM Anything forked?
SHLI70 lbne SHLSTX ..no; syntax error
 cmpa #C$CR
 bne SHLI10
SHLI90 lbra RESET reset I/O in case of error

 pag
**********
* Shopts
*   process pre-parameter Shell Options
*
* Passed: (X)=command ptr
* Returns: (A)=next char in command line
*          (X)=command ptr updated
*          CC=Set, B=Error Code if Error
* Destroys: B,Y
*
SHOPTS stx MODNAM save module/path name ptr
 bsr PRSNAM
 bcs SHOP90 ..error; return
SHOP10 bsr PRSNAM
 bcc SHOP10 parse module/path name
 leay PRETBL,PCR pre-param function tbl
 bsr SHFUNC process pre-param options
 stx PRMPTR save parameter ptr
SHOP90 rts

PRSNAM OS9 F$PrsNam
 bcc PRSN10 ..return if no error
 lda ,X+
 cmpa #'.
 bne PRSN20 ..error; exit
 cmpa ,X+
 beq PRSN15
 leay -1,X
PRSN10 leax 0,Y
PRSN15 clra
 rts

PRSN20 comb
 leax -1,X
 ldb #E$BPNam
 rts

**********
* Shfunc
*   process a List of Shell Functions
*
* Passed: (X)=command line ptr
*         (Y)=Function Table ptr
* Returns: (A)=next char in command line
*          (X)=updated, CC=set if Error
* Destroys: B
*
SHFUNC bsr SKPSEP Skip command separator
 pshs Y save function tbl ptr
 bsr SHSRCH Function symbol in input?
 bcs SHFU20 ..no; return (done)
 ldd 0,Y get routine offset
 jsr D,Y process function
 puls Y Restore function tbl ptr
 bcc SHFUNC ..repeat if no error
 rts

SHFU20 clra
 lda 0,X
 puls Y,PC return (done)

**********
* Scan
*   Find Desired char in command line
*
* Passed: (X)=command line ptr
*         (Y)=List of chars to Look For
*             --Terminated By $Ff
*             --Must be Findable in String
* Returns: (A)=char found
*          (X)=updated, one Past char found
*
SCAN10 puls  Y

SCAN pshs Y save list of chars
 lda ,X+ get next command char
SCAN20 tst 0,Y ..end of list?
 bmi SCAN10 ..yes; try next char
 cmpa ,Y+ found?
 bne SCAN20 ..no
SCAN90 puls Y,PC return

**********
* Skpsep
*   Skip command line separator
*
* Passed: (X)=Comand line ptr
* Returns: (A)=separator char found
*          (X)=updated
* Error: CC=set (No separator found)
*
SKPSEP pshs X
 lda ,X+ get next char in line
 cmpa #C$SPAC
 beq SKPS20
 cmpa #C$COMA
 beq SKPS20
 leax TRMLST,PCR
SKPS10 cmpa ,X+ ..accepted terminator?
 bhi SKPS10 ..not this one
 puls X,PC ..return carry set if not

SKPS20 leas 2,S Throw away saved command ptr
 lda #C$SPAC
SKPS30 cmpa ,X+ Skip spaces
 beq SKPS30
 leax -1,X (note: comma returns space)
CLRRTS andcc #$FF-CARRY return carry clear
 rts

**********
* Shsrch
*   Search for Shell "Keyword"
*
* Passed: (X)=command line ptr
*         (Y)=Function Tbl
* Returns: (X)=updated, if found
*          (Y)=Ptr to Entry found
* Destroys: D
* Error: CC=set if not found
*
SHSRCH pshs X,Y save regs
 leay 2,Y
SHSR10 ldx 0,S Reset command line ptr
SHSR20 lda ,X+
 cmpa #'a Lower case?
 blo SHSR30 ..no; continue
 suba #'a-'A Convert to upper case
SHSR30 eora ,Y+
 asla MATCH?
 bne SHSR40 ..no; skip to next tbl entry
 bcc SHSR20 Repeat until end of tbl string
 lda -1,Y get last tbl char
 cmpa #'A+$80 Symbol (not letter)?
 blo SHSR35 ..yes; don't require separator
 bsr SKPSEP Must be followed by separator
 bcs SHSR40 ..not; no match
SHSR35 clra CLEAR Carry
 puls D,Y,PC return; found

SHSR40 leay -1,Y
SHSR45 lda ,Y+
 bpl SHSR45 Skip to end of tbl entry
 sty 2,S Update current table position
 ldd ,Y++ end of table?
 bne SHSR10 ..no; check next entry
 comb
 puls X,Y,PC return not found

 ttl Parameters
 pag
**********
* Shexec
*   Chain to a process
*
SHEXEC lbsr SHOPTS process pre-param options
 clra
 bsr CLSPTH close std input if redirected
 bsr CLSP00 close std out   if redirected
 bsr CLSP00 close std error if redirected
 bsr SHCOMT skip to end of line
 leax 1,X
 tfr X,D
 subd PRMPTR Compute parameter size
 std PRMSIZ
 leas $FF,U move stack onto dp
 lbsr SETPRM setup chain/fork parameters
 OS9 F$Chain Chain to process
 OS9 F$EXIT ..error if returns

CLSP00 inca
CLSPTH pshs A
 bra RSTP10 close (a)=path if redirected

**********
* Shchdir
*   Change Default Directory
*
SHCXDR lda #DIR.+EXEC. Change exec dir
 bra SHCD10

SHCDIR lda #DIR.+UPDAT. Change data dir
SHCD10 OS9 I$ChgDir Change directory
 rts

**********
* Shprmt
*   Turn On/Off "Os9: " printing
*
SHPRMT clra print prompt
 bra SHNP10

SHNPRM lda #1 don't print prompt
SHNP10 sta PRINT
 rts

**********
* Shtee
*   Turn On/Off Input "Tee" Echoing
*
SHTEE lda #1 Echo input lines
 bra SHNT10

SHNTEE clra don't Echo input lines
SHNT10 sta INPTEE
 rts

 pag
**********
* Shxerr
*   Turn On/Off Error Exiting
*
SHXERR lda #1 Echo input lines
 bra SHXR10

SHNXER clra don't Exit if error
SHXR10 sta ERRXIT
 rts

**********
* Shcomt
*   Skip Comment Line
*
SHCOMT lda #C$CR
SHCOM1 cmpa ,X+
 bne SHCOM1
 cmpa ,-X backup to carriage return
 rts

**********
* Reset
*   Close Any Redirected I/O Or pipes
*
* Passed: (U)=Static storage
* Destroys: None
*
RESET pshs CC,D
 clra Start with path zero
RESE10 bsr RSTPTH Reset path
 inca
 cmpa #2 All reset?
 bls RESE10
 ror ,S+
 puls D,PC

**********
* Rstpth
*   Reset Redirected path
*
* Passed: (A)=path to Reset
*         (U)=Static storage
* Destroys: B,CC
*
RSTPTH pshs A save path #
 tst A,U path redirected?
 beq RSTP90 ..no; exit
 OS9 I$Close Close path
 lda A,U
 OS9 I$DUP Restore path
RSTP10 ldb 0,S
 lda B,U
 beq RSTP90 not redirected; return
 clr B,U
 OS9 I$Close Close saved image
RSTP90 puls A,PC

STXMSG fcc "WHAT?"
 fcb C$CR

SHLSTX bsr RESET
 leax <STXMSG,PCR
 lbsr SHOUT print syntax error message
 clrb
 coma
 rts

 ttl Options
 pag
**********
* Shrdin
*   Redirect Std Input path
*
* Passed: (X)=New Std Input path
* Returns: (X)=updated
*          CC=set if Error
*
SHRDIN ldd #READ. path zero, read
 bra SHRDR

**********
* Shrdou
*   Redirect Std Output Or Error path
*
* Passed: (X)=New pathname
* returns (X)=updated
*         CC=set if Error
*
SHRDER ldd #$0200+C$CR
 stb -2,X Blast redirection symbol
 bra SHRDO1

SHRDOU lda #1
SHRDO1 ldb #WRITE.
 bra SHRDR

**********
* Shrdr
*   Redirect Output path
*
* Passed: (A)=Output path [0,1,2]
*         (B)=Mode: Read/Write/Update
*         (X)=New pathname ptr
* Returns: (X)=updated
*          CC=set if Error
*
SHRDR0 tst A,U pth already redirected?
 bne SHLSTX ..Yes; syntax error
 pshs D
 bra SHRDR1

SHRDR tst A,U path already redirected?
 bne SHLSTX ..syntax error if so
 pshs D save regs
 ldb #C$CR
 stb -1,X Blast redirection symbol
SHRDR1 OS9 I$DUP copy path
 bcs SHRD90 ..exit if error
 ldb 0,S
 sta B,U save std path
 lda 0,S
 OS9 I$Close Close std path
 lda 1,S get mode of new path
 bita #WRITE. Output? update?
 bne SHRD10 ..yes; create
 OS9 I$OPEN
 bra SHRD20
SHRD10 ldb #UPDAT.+PREAD. Output file attributes
 OS9 I$Create
SHRD20 stb 1,S return error code
SHRD90 puls D,PC

**********
* Shcmem
*   Change Default Memory Requirement
*
* Passed: (X)=Comand line ptr
* Returns: (X)=updated
* Error: CC=Set
*
SHCMEM ldb #C$CR
 stb -1,X
 ldb MEMSIZ Already changed?
 bne SHLSTX ..yes; syntax error
 lbsr SHGNUM get number
 eora #'K
 anda #$FF-$20 UPPER OR LOWER CASE "K"?
 bne SHCM20 ..no
 leax 1,X Skip it
 lda #4
 mul TIMES 4 PAGES PER "K"
 tsta
 bne SHLSTX
SHCM20 stb MEMSIZ set new memsize
 lbra SKPSEP ..must be followed by separator
*********
* Shseq
*   Sequential Execution (Fork, Wait)
*
SHEOL leax -1,X Back up to end of line
 lbsr SHFORK Give birth
 bra SHSQ05 Wait for death

SHSEQ lbsr SHFK00 Fork process
SHSQ05 bcs SHSQ90 ..exit if error
 lbsr RESET reset any redirected I/O
 bsr SHWT10 Wait for death
SHSQ10 bcs SHSQ90 ..exit if error
 lbsr SKPSEP
 cmpa #C$CR end of command line?
 bne SHSQ80 ..no; return
 leas 4,S return to shfunc's caller

SHSQ80 clrb return Carry clear
SHSQ90 lbra RESET

**********
* Shcurr
*   Start Concurrent process
*
SHCURR lbsr SHFK00 blast c$curr char; fork child
 bcs SHSQ90 ..error; exit
 bsr SHSQ90 reset std I/O paths
 ldb #C$CURR
 lbsr SHPNUM print child process id
 bra SHSQ10 return without waiting

**********
* Shwait
*   Wait for any process to Die

SHWAIT clra
SHWT10 pshs A Save process id
SHWT20 OS9 F$WAIT
 tsta  child dead?
 bne SHWT25 ..yes
 cmpb #S$Abort abort signal?
 bne SHWT40 ..no; return error
 lda 0,S get most recent child
 beq SHWT40 ..unknown; return error
 OS9 F$SEND Abort child process
 clr 0,S
 bra SHWT20 ..then wait for anybody to die

SHWT25 bcs SHWT90 ..error (no children); return it
 cmpa 0,S desired process id?
 beq SHWT40 ..yes; good
 tst 0,S waiting for any?
 beq SHWT30 ..yes; print proc id; return
 tstb unexpected error?
 beq SHWT20 No; wait for another child
SHWT30 pshs B save error status
 bsr SHSQ90 (reset) I/O
 ldb #C$DEAD
 lbsr SHPNUM print '-nn' obituary
 puls B restore status
SHWT40 tstb
 beq SHWT90
 coma
SHWT90 puls A,PC

**********
* Shfork
*   Give Birth to New process
*
SETPRM lda #OBJCT+PRGRM
 ldb MEMSIZ
 ldx MODNAM
 ldy PRMSIZ
 ldu PRMPTR
 rts

* Run-Time Interpreter names for various Languages
LANTBL equ *
 fcb SBRTN+ICODE
 fcs "RunB"
 fcb PRGRM+PCODE
 fcs "PascalS"
 fcb SBRTN+CblCode
 fcs "RunC"
 fcb 0 signals end of table

FORK.B lda #EXEC. search for executable module
 OS9 I$Open try to open file
 bcs SHFORK20 ..unable; look for procedure file
 leax MODBUF,U
 ldy #M$Mem+2
 OS9 I$Read read module header
 pshs CC,B save status
 OS9 I$Close close file
 puls CC,B
 lbcs SHFKER ..ERROR; abort
 lda M$Type,X get (A)=module type
 ldy M$Mem,X get (Y)=Static storage requirement
 bra SHFORK.C

SHFK00 lda #C$CR
 sta -1,X Blast end of param token

SHFORK pshs X,Y,U save caller's regs
 clra
 ldx MODNAM
 OS9 F$LINK is module already in memory?
 bcs FORK.B ..No; search 1st for executable module
 ldy M$Mem,U (Y)=Static storage requirement
 OS9 F$Unlink (A)=Type/Language
SHFORK.C cmpa #PRGRM+OBJCT Program Module?
 lbeq SHFORK30 ..Yes; FORK to it
 sty MODSTK save module static storage

* Search Subroutine Library for Class processor
 leax <LANTBL,PCR
SHFORK07 tst 0,X end of table?
 beq SHFORK90 ..yes; non-executable module
 cmpa ,X+ search table for language type
 beq SHFORK10 ..found
SHFORK08 tst ,X+ skip language name
 bpl SHFORK08
 bra SHFORK07

SHFORK10 ldd PRMPTR
 subd MODNAM
 addd PRMSIZ
 std PRMSIZ
 ldd MODNAM
 std PRMPTR
 bra SHFORK25 Fork to Class Processor

SHFORK20 ldx PRMSIZ
 leax 5,X
 stx PRMSIZ
 ldx MODNAM
 ldu 4,S Dp pointer
 lbsr SHRDIN try redirecting input to file
 bcs SHFKER ..error; return it
 ldu PRMPTR
 ldd #'X*256+C$SPAC
 std ,--U default exit if error to child
 ldd #'P*256+C$SPAC
 std ,--U
 ldb #'-
 stb ,-U default no prompts
 stu PRMPTR
 leax SHLNAM,PCR process "BATCH" FILE

SHFORK25 stx MODNAM fork to language interpreter
SHFORK30 ldx MODNAM restore module name
 lda #PRGRM+OBJCT
 OS9 F$LINK attempt to link executable module
 bcc SHFORK35 ..found; great
 OS9 F$LOAD load if not in memory
 bcs SHFKER ..return error if not found
SHFORK35 pshs U save executable module addr
 tst MEMSIZ explicit memory given?
 bne SHFORK37 ..Yes; use it
 ldd M$Mem,U get executable module's minimum
 addd MODSTK add in any required by "packed" modules
 addd #$FF round up
 sta MEMSIZ
SHFORK37 lbsr SETPRM
 OS9 F$FORK
 puls U restore module ptr
 pshs CC,B save error status
 bcs SHFORK40
 ldx #1
 OS9 F$Sleep give up time slice to give fetus head start
SHFORK40 clr MODNAM signal fork attempt
 clr MODNAM+1
 OS9 F$Unlink release module
 puls CC,B,X,Y,U,PC return

SHFORK90 ldb #E$NEMod error; non-executable module
SHFKER coma
 puls X,Y,U,PC return error

**********
* Shpipe
*   Build pipeline
*
* Passed: (X)=command ptr
* Returns: (X)=updated
*
 ifeq PIPES-Yes
PIPDEV fcc "/pipe"
 fcb C$CR
*
SHPIPE pshs X save command ptr
 leax <PIPDEV,PCR get name of "pipe DEVICE"
 ldd #$0100+UPDAT.
 lbsr SHRDR0 Redirect output
 puls X
 bcs SHKI90 ..error; exit
 lbsr SHFK00 Fork input side of pipe (blasting)
 bcs SHKI90 ..error; exit
 lda 0,U Get current std input path
 bne SHPIPE10 ..redirected; don't dupe
 OS9 I$DUP Clone std input path
 bcs SHKI90 ..exit if error
 sta 0,U save path number
SHPIPE10 clra
 OS9 I$Close Erase old std input path
 lda #1
 OS9 I$DUP Dup std output path to input
 lda #1
 lbra RSTPTH Reset std output path
 endc

**********
* Shpnum
*    Print decimal number, proceeded by (B)
*
* Passed: (A)=Number
*         (B)=Char To Print First
* Destroys: None
*
SHPNUM pshs D,X,Y
 pshs B,X,Y build output scratch
 leax 1,S Addr of output ptr
 ldb #'0-1
SHPN10 incb form hundred's digit
 suba #100
 bcc SHPN10
 stb ,X+
 ldb #'9+1
SHPN20 decb form tens digit
 adda #10
 bcc SHPN20
 stb ,X+
 adda #'0 form units digit
 ldb #$D
 std 0,X
 leax 0,S
 lbsr SHOUT Print it
 leas 5,S out goes the scratch
 puls D,X,Y,PC

 pag

**********
* Shkill
*   Kill a process
*
* Passed: (X)=param ptr
*       -->process number (dec) to kill
* Returns: (X)=updated
*          CC=set if Error
*
SHKILL bsr SHGNUM get number
 cmpb #2 Trying to kill process #1 (sysgo)?
 blo SHGN99 ..yes; syntax error
 tfr B,A Process number to kill
 ldb #S$KILL Kill code
 OS9 F$SEND
SHKI90 rts

**********
* Shgnum
*   Convert Ascii Number (0-255) to Binary
*
* Passed: (X)=Ascii String ptr
* Returns: (A)=next char After Number
*          (B)=Number
*          (X)=updated Past Number
*          CC=set if Error
*
SHGNUM clrb
SHGN10 lda ,X+
 suba #'0 Convert ascii to binary
 cmpa #9 Valid decimal digit?
 bhi SHGN20 ..no; end of number
 pshs A save digit
 lda #10
 mul MULTIPLY Partial result times 10
 addb ,S+ Add in next digit
 bcc SHGN10 get next digit if no overflow
SHGN20 lda ,-X

 bcs SHGN90 ..no; syntax error
 tstb non-zero?
 bne SHKI90 ..good; return
SHGN90 leas 2,S discard return addr
SHGN99 lbra SHLSTX Syntax error

SHSETP bsr SHGNUM  get process number
 stb TEMP Save proc#
 lbsr SKPSEP
 bsr SHGNUM get priority
 lda TEMP (a)=id, (b)=priority
 OS9 F$SPrior set priority
 rts

 emod module crc
SHLEND equ *

 end
