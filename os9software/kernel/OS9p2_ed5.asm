
 nam OS-9 Level I V1.1 kernal, part 2
 ttl Module Header


************************************************************
*                                                          *
*        Microware OS-9 Level I V1.1 Kernal, part 2        *
*                                                          *
************************************************************

* Copyright 1980 by Motorola, Inc., and Microware Systems Corp.,
* Reproduced Under License

*
* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than 
* the licensee is strictly prohibited!!
*

 use defsfile

*****
*
*  Module Header
*
Type set SYSTM+OBJCT
Revs set REENT+1
 mod OS9End,OS9Nam,Type,Revs,OS9Ent,0
OS9Nam fcs /OS9p2/

 fcb 5 Edition number

 fcc   /(C)1981Microware/

*************************
*    Edition History
*
* Ed.  5 - Beginning of history  (V1.1 final version)

 ttl Service Routine initialization table
 page
*****
*
* System Service Routine Table
*
SVCTBL equ *
 fcb $7F
 fdb IOHOOK-*-2
 fcb F$UNLK
 fdb UNLINK-*-2
 fcb F$WAIT
 fdb WAIT-*-2
 fcb F$EXIT
 fdb EXIT-*-2
 fcb F$MEM
 fdb USRMEM-*-2
 fcb F$SEND
 fdb SEND-*-2
 fcb F$ICPT
 fdb INTCPT-*-2
 fcb F$SLEP
 fdb SLEEP-*-2
 fcb F$ID
 fdb GETID-*-2
 fcb F$SPRI
 fdb SETPRI-*-2
 fcb F$SSWI
 fdb SETSWI-*-2
 fcb F$STIM
 fdb SetTime-*-2
 fcb F$F64+$80
 fdb F64-*-2
 fcb F$A64+$80
 fdb A64-*-2
 fcb F$R64+$80
 fdb R64-*-2
 fcb $80



 ttl Cold Start routine
 page
*****
*
* Cold Start Routines
*
*
* Initialize Service Routine Dispatch Table
*
OS9Ent leay SVCTBL,PCR Get ptr to service routine table
 OS9 F$SSVC Set service table addresses
 ldx D.PRDB Get process ptr
 OS9 F$A64 Get a process
 bcs COLD
 stx D.PRDB Set process block
 sty D.PROC
 tfr S,D copy stack ptr
 deca get page lower bound
 ldb #1 set page count
 std P$ADDR,Y set process descriptor
 lda #SYSTAT Set system state
 sta P$STAT,Y
 ldu D.BASE get configuration ptr
 bsr SETDIRS set default directories
 bcc COLD10 branch if successful
 lbsr BOOT Default failed, boot
 bsr SETDIRS try again
COLD10 bsr SETSTDS open standard i/o
 bcc COLD20 branch if successful
 lbsr BOOT open failed, boot
 bsr SETSTDS try again
COLD20 ldd INISTR,U Get initial execution string
 leax D,U Get string ptr
 lda #OBJCT set type
 clrb use declared memory
 ldy #0 No parameters
 OS9 F$CHAN Start process

COLD jmp [$FFFE] Abort start up

SETDIRS clrb clear carry
 ldd SYSSTR,U Get system device name
 beq SETDIR10 Branch if none
 leax D,U Get name ptr
 lda #EXEC.+READ. Set both execution & data
 OS9 I$CDIR Set default directory
SETDIR10 rts

SETSTDS clrb clear carry
 ldd STDSTR,U get name offset
 leax D,U get name ptr
 lda #UPDAT. set mode
 OS9 I$OPEN open file
 bcs SETSTD10 branch if error
 ldx D.PROC get process ptr
 sta P$PATH,X set standard input
 OS9 I$DUP count open image
 sta P$PATH+1,X set standard output
 OS9 I$DUP count open image
 sta P$PATH+2,X set standard error
SETSTD10 rts


 ttl SERVICE Routines
 page
*****
*
*  Subroutine Unlink
*
* Decrment Link Count. If Count Reaches Zero,
*    Delete Module From Directory & Return Memory
*
UNLINK ldd R$U,U Get module address
 beq UNLK25 Branch if none
 ldx D.MODD Get directory ptr
UNLK10 cmpd 0,X Is it this module?
 beq UNLK15 Branch if so
 leax 4,X Move to next entry
 cmpx D.MODD+2 End of directory?
 bcs UNLK10
 bra UNLK25
UNLK15 lda 2,X Get use count
 beq UNLK16 Branch if not used
 deca DOWN Link count
 sta 2,X
 bne UNLK25 Branch if still used
UNLK16 ldy 0,X Get ptr to module

 ifne CPUTYP-EXORSR
 cmpy D.BTLO Is it 'system' module?
 bcc UNLK25 Branch if so
 endc

 ldb M$TYPE,Y Get module type
 cmpb #FLMGR Is i/o module?
 bcs UNLK20 Branch if not
 OS9 F$IODL Delete from i/o system
 bcc UNLK20
 inc 2,X Reset link count
 bra UNLK30

UNLK20 equ *
 ifeq CPUTYP-EXORSR
 cmpy D.BTLO Is it 'system' module?
 bcc UNLK25 Branch if so
 endc

 clra
 clrb
 std 0,X Clear directory entry
 std 0,Y Destroy id code
 ldd M$SIZE,Y Get module size
 lbsr DIV256 Divide by 256, rounding up
 exg D,Y Switch page count & beginning address
 exg A,B Make address into page number
 ldx D.FMBM Get bit map ptr
 OS9 F$DBIT Deallocate memory block
UNLK25 clra CLEAR Carry
UNLK30 rts
 page
*****
*
*  Subroutine Wait
*
* Wait for Child Process to Exit
*
WAIT ldy D.PROC Get process ptr
 ldx D.PRDB Get process descriptor block ptr
 lda P$CID,Y Does process have children?
 bne WAIT10 Branch if so
 comb Set Carry
 ldb #E$NOCH Err: no children
 rts
WAIT10 OS9 F$F64 Get process ptr
 lda P$STAT,Y Get child's status
 bita #DEAD Is child dead?
 bne WAIT20 Branch if so
 lda P$SID,Y More children?
 bne WAIT10 Branch if so
 clr R$A,U clear child process id
 ldx D.PROC Get process ptr
 orcc #IRQM+FIRQM Set interrupt masks
 ldd D.WPRQ Put in waiting queue
 std P$QUEU,X
 stx D.WPRQ
 lbra ZZZPRC Put process to sleep
WAIT20 ldx D.PROC Get parent process ptr
*
*           Fall Thru to Childs
*
*****
*
*  Subroutine Childs
*
* Return Child's Death Status to Parent
*
* Input:  X - Parent Process ptr
*         Y - Child Process ptr
*         U - Parent Process Register ptr
*
CHILDS lda P$ID,Y Get process id
 ldb P$SIGN,Y Get death status
 std R$D,U Return to parent
 pshs A,X,Y,U Save registers
 leay P$CID-P$SID,X Fake sibling process ptr
 ldx D.PRDB Get process descriptor block ptr
 bra CHIL20
CHIL10 OS9 F$F64 Get process ptr
CHIL20 lda P$SID,Y Is child next sibling?
 cmpa 0,S
 bne CHIL10 Branch if not
 ldu 3,S Get process ptr
 ldb P$SID,U Get child's sibling
 stb P$SID,Y Remove child from sibling list
 OS9 F$R64 Return process descriptor
 puls A,X,Y,U,PC
 page
*****
*
*  Subroutine Exit
*
* Process Termination
*
EXIT ldx D.PROC Get process ptr
 ldb R$B,U Get exit status
 stb P$SIGN,X Save status
 ldb #NPATHS Get number of paths
 leay P$PATH,X Get path table ptr
EXIT10 lda ,Y+ Get next path number
 beq EXIT15 Branch if not in use
 pshs B Save path count
 OS9 I$CLOS Close the file
 puls B Retrieve path count
EXIT15 decb COUNT Down
 bne EXIT10 Branch if more
 lda P$ADDR,X Get memory page number
 tfr D,U Copy it
 lda P$PCNT,X
 OS9 F$SRTM
 ldu P$PMOD,X Get primary module ptr
 OS9 F$UNLK Unlink it
 ldu D.PROC Get process ptr
 leay P$CID-P$SID,U Fake sibling process
 ldx D.PRDB Get process descriptor block
 bra EXIT30
EXIT20 clr P$SID,Y Clear sibling link
 OS9 F$F64 Get next process ptr
 lda P$STAT,Y Get process status
 bita #DEAD Is process dead?
 beq EXIT25 Branch if not
 lda P$ID,Y Return process to free
 OS9 F$R64 Return process descriptor
EXIT25 clr P$PID,Y Clear parent process ptr
EXIT30 lda P$SID,Y Get sibling id
 bne EXIT20 Branch if there is one
 ldx #D.WPRQ-P$QUEU Fake process ptr
 lda P$PID,U Get parent process id
 bne EXIT40 Branch if parent alive
 ldx D.PRDB Get process block ptr
 lda P$ID,U Get process id
 OS9 F$R64 Return process descriptor
 bra EXIT50
EXIT35 cmpa P$ID,X Is this parent?
 beq EXIT45 Branch if so
EXIT40 leay 0,X Copy this process ptr
 ldx P$QUEU,X Get next process ptr
 bne EXIT35 Branch if there is one
 lda P$STAT,U Get process status
 ora #DEAD Note process death
 sta P$STAT,U Update status
 bra EXIT50 Wait for parent to notice
EXIT45 ldd P$QUEU,X Remove parent from wait list
 std P$QUEU,Y
 OS9 F$APRC Put parent in active process queue
 leay 0,U Copy child ptr
 ldu P$SP,X Get parent's stack
 ldu R$D,U Get actual wait stack
 lbsr CHILDS Return child status
EXIT50 clra REMOVE Process from active system
 clrb
 std D.PROC
 rts
 page
*****
*
*  Subroutine Usrmem
*
* Adjust User Memory To Requested Size
*
USRMEM ldx D.PROC get process ptr
 ldd R$D,U Get size requested
 beq USRM35 branch if info request
 bsr DIV256 Divide by 256, rounding up
 subb P$PCNT,X Subtract current size
 beq USRM35 Branch if already requested size
 bcs USRM20 Branch if current > requested
 tfr D,Y Copy pages needed
 ldx P$ADDR,X Get memory address & size
 pshs X,Y,U Save registers
 ldb 0,S Get address
 beq USRM10 Branch if none
 addb 1,S Get location of new
USRM10 ldx D.FMBM Get free memory ptrs
 ldu D.FMBM+2
 OS9 F$SBIT Look for memory
 bcs BADMEM Branch if not available
 stb 2,S Save page number of new
 ldb 0,S Get beginning of old
 beq USRM15 Branch if none
 addb 1,S Add size old
 cmpb 2,S Is that where new begins?
 bne BADMEM Branch if not
USRM15 ldb 2,S Get page number of new
 OS9 F$ABIT Allocate memory
 ldd 2,S Get new address & size
 suba 1,S Get address of current
 addb 1,S Get size current
 puls X,Y,U
 ldx D.PROC Get process ptr
 bra USRM30
USRM20 negb GET Excess page count
 tfr D,Y Copy it
 negb GET Size requested
 addb P$PCNT,X
 addb P$ADDR,X Get page number of excess
 cmpb P$SP,X Deallocating stack?
 bhi USRM25 Branch if not
 comb SET Carry
 ldb #E$DESP
 rts
USRM25 ldx D.FMBM Get free memory ptr
 OS9 F$DBIT Deallocate memory
 tfr Y,D Copy excess page count
 negb
 ldx D.PROC Get process ptr
 addb P$PCNT,X Adjust page count
 lda P$ADDR,X Get address
USRM30 std P$ADDR,X Set new address & size
USRM35 lda P$PCNT,X Get process beginning address
 clrb CLEAR Lsb
 std R$D,U Return memory size
 adda P$ADDR,X Return ptr to memory end
 std R$Y,U
 rts

BADMEM comb SET Carry
 ldb #E$MEMF Err: memory full
 puls X,Y,U,PC



*****
*
* Subroutine Div256
*
* Divide By 256, Rounding Up
*
DIV256 addd #$FF
 clrb ROUND Up
 exg A,B Divide by 256
 rts
 page
*****
*
*  Subroutine Send
*
* Send a Signal to Process(es)
*
SEND lda R$A,U Get destination process id
 bne SENSUB Branch if not all processes
*
* Loop thru all Process Ids, send Signal to all but Sender
*
 inca Start with process 1
SEND10 ldx D.PROC Get process ptr
 cmpa P$ID,X Is this sender?
 beq SEND15 Branch if so
 bsr SENSUB Signal process
SEND15 inca Get next process id
 bne SEND10 Branch if more
 clrb Clear Carry
 rts
*
* Get destination Process ptr
*
SENSUB ldx D.PRDB Get process descriptor block ptr
 OS9 F$F64 Get process ptr
 bcc SEND20 Branch if good
 ldb #E$IPID Err: illegal process id
 rts
*
* Check Signal type
*
SEND20 orcc #IRQM+FIRQM Set interrupt masks
 pshs A,Y Save process id & ptr
 ldb R$B,U Is it unconditional abort signal?
 bne SEND30 Branch if not
 lda P$STAT,Y Get process status
 ora #CONDEM Condem process
 sta P$STAT,Y Update status
*
* Check for Signal collision
*
SEND30 lda P$SIGN,Y Is signal pending?
 beq SEND40 Branch if not
 deca Is it wake-up?
 beq SEND40 Branch if so
 comb Set Carry
 ldb #E$USP Err: unprocessed signal pending
 puls A,Y,PC
SEND40 stb P$SIGN,Y Save signal
*
* Look for Process in Sleeping Queue
*
 ldx #D.SPRQ-P$QUEU Fake process ptr
 bra SEND55
SEND50 cmpx 1,S Is this destination process?
 beq   SEND65 branch if it is
SEND55 leay 0,X Copy process ptr
 ldx P$QUEU,Y More in queue?
 bne SEND50 Branch if so
*
* Look for Process in Waiting Queue
*
 ldx #D.WPRQ-P$QUEU Fake process ptr
SEND60 leay 0,X Copy process ptr
 ldx P$QUEU,Y More in queue?
 beq SEND75 Branch if not
 cmpx 1,S Is this destination process?
 bne SEND60 Branch if not
*
* Move Process from it's current Queue to Active Queue
*
SEND65 ldd P$QUEU,X Remove from queue
 std P$QUEU,Y
 lda P$SIGN,X Get signal
 deca Is it wake-up?
 bne SEND70 Branch if not
 sta P$SIGN,X Clear signal
SEND70 OS9 F$APRC Put in active queue
SEND75 clrb Clear carry
 puls A,Y,PC
 page
*****
*
*  Subroutine Sleep
*
* Suspend Process
*
SLEEP ldx D.PROC Get current process
 orcc #IRQM+FIRQM Set interrupt mask
 lda P$SIGN,X Signal waiting?
 beq SLEP20 Branch if not
CKSIGN deca IS It wake-up?
 bne SLEP10 Branch if not
 sta P$SIGN,X Clear signal
SLEP10 OS9 F$APRC Put process in active queue
 bra ZZZPRC Suspend process
SLEP20 ldd R$X,U Get length of sleep
 beq SLEP50 Branch if indefinite
 subd #1 count current tick
 std R$X,U update count
 beq SLEP10 branch if done
 pshs X,U Save process & register ptr
 ldx #D.SPRQ-P$QUEU Fake process ptr
SLEP30 leay 0,X Copy process ptr
 ldx P$QUEU,X Get next process
 beq SLEP40 Branch if end of queue
 pshs D Save sleep time
 lda P$STAT,X Get process status
 bita #TSLEEP In timed sleep?
 puls D Retrieve sleep time
 beq SLEP40 Branch if not timed sleep
 ldu P$SP,X Get process stack ptr
 subd R$X,U Subtract sleep time
 bcc SLEP30 Branch if not greater
 addd R$X,U Fix sleep time
SLEP40 puls X,U Retrieve process & register ptr
 std R$X,U Set time to sleep
 ldd P$QUEU,Y Put process in queue
 stx P$QUEU,Y
 std P$QUEU,X
 lda P$STAT,X Set timed sleep status
 ora #TSLEEP
 sta P$STAT,X
 ldx P$QUEU,X Get next process ptr
 beq ZZZPRC
 lda P$STAT,X Get status
 bita #TSLEEP In timed sleep?
 beq ZZZPRC Branch if not
 ldx P$SP,X Get stack ptr
 ldd R$X,X Get sleep time
 subd R$X,U Subtract new sleep
 std R$X,X Update sleep time
 bra ZZZPRC
SLEP50 lda P$STAT,X Get status
 anda #$FF-TSLEEP Set not timed sleep
 sta P$STAT,X
 ldd #D.SPRQ-P$QUEU Fake process ptr
SLEP60 tfr D,Y Copy process ptr
 ldd P$QUEU,Y Get next process ptr
 bne SLEP60 Branch if one exists
 stx P$QUEU,Y Link into queue
 std P$QUEU,X
*
*      Fall Thru To Zzzprc
*
*****
*
*  Subroutine Zzzprc
*
* Deactivate Process, Start Another
*
ZZZPRC leay <WAKPRC,PCR Get wakeup address
 pshs Y Make new pc
 ldy D.PROC Get process ptr
 ldd P$SP,Y Get process stack
 ldx R$X,U Get sleep time (if any)
 pshs CC,D,DP,X,Y,U Make new stack
 sts P$SP,Y Note location
 OS9 F$NPRC Start another process

WAKPRC std P$SP,Y Restore previous stack
 stx R$X,U Return sleep time
 clrb CLEAR Carry
 rts
 page
*****
*
*  Subroutine Intcpt
*
* Signal Intercept Handler
*
INTCPT ldx D.PROC Get process ptr
 ldd R$X,U Get vector
 std P$SIGV,X Save it
 ldd R$U,U Get data address
 std P$SIGD,X Save it
 clrb CLEAR Carry
 rts



*****
*
*  Subroutine Setpri
*
* Set Process Priority
*
SETPRI lda R$A,U Get process id
 ldx D.PRDB Get process block ptr
 OS9 F$F64 Find process descriptor
 bcs SETP10
 ldx D.PROC Get setting process ptr
 ldd P$USER,X Get setting user
 cmpd P$USER,Y Same as set user?
 bne SETP10 Branch if not
 lda R$B,U Get priority
 sta P$PRIO,Y Set priority
 rts
SETP10 comb SET Carry
 ldb #E$IPID Err: illegal process id
 rts



*****
*
*  Subroutine Getid
*
GETID ldx D.PROC Get process ptr
 lda P$ID,X Get process id
 sta R$A,U Return to user
 ldd P$USER,X Get user index
 std R$Y,U Return to user
 clrb
 rts
 page
*****
*
*  Subroutine Setswi
*
* Set Software Interrupt Vectors
*
SETSWI ldx D.PROC Get process ptr
 leay P$SWI,X Get ptr to vectors
 ldb R$A,U Get swi code
 decb ADJUST Range
 cmpb #3 Is it in range
 bcc SSWI10 Branch if not
 aslb
 ldx R$X,U
 stx B,Y
 rts
SSWI10 comb
 ldb #E$ISWI
 rts


**********
*
* Subroutine Settime
*

SetTime ldx R$X,U get date ptr
 ldd 0,X get year & month
 std D.YEAR
 ldd 2,X get day & hour
 std D.DAY
 ldd 4,X get minute & second
 std D.MIN
 clrb  
 rts   
 page
***************
* Findpd
*   Find Address Of Path Descriptor Or Process Descriptor
*
* Calling Seq: (A)=Pd Number
*              (X)=Pd Table Addr
* Returns: (Y)=Addr Of Pd
*          Cc=Set If Pd Is Not Owned By Caller
* Destroys: B,Cc
*
F64 lda R$A,U Get block number
 ldx R$X,U Get block ptr
 bsr FINDPD Find block
 bcs F6410
 sty R$Y,U
F6410 rts

FINDPD pshs D Save registers
 tsta LEGAL Number?
 beq FPDERR ..yes; error
 clrb
 lsra
 rorb
 lsra
 rorb DIVIDED By 4 pd's per pd block
 lda A,X Map into high order pd address
 tfr D,Y (y)=address of path descriptor
 beq FPDERR Pd block not allocated!
 tst 0,Y Is pd in use?
 bne FINDP9 Allocated pd, good!
FPDERR coma ERROR - return carry set
FINDP9 puls D,PC Return
 page
***************
* Aloc64
*   Allocate Path Descriptor (64 Bytes)
*
* Passed:  X=Pdbt, Path Descriptor Block Table Addr
* Returns: A=Path Number
*          Y=Pd Address
*          Cc=Set If Unable To Allocate
*           B=Error Code If Unable To Allocate
* Destroys: B
*
A64 ldx R$X,U Get block ptr
 bne A6410 Branch if set
 bsr A64ADD Add a page
 bcs A6420 Branch if error
 stx 0,X Init block
 stx R$X,U Return block ptr
A6410 bsr ALOC64 Alocate block
 bcs A6420
 sta R$A,U Return block number
 sty R$Y,U Return block ptr
A6420 rts

A64ADD pshs U Save register ptr
 ldd #$100 Get a page
 OS9 F$SRQM
 leax 0,U Copy page ptr
 puls U Retrieve register ptr
 bcs A64A20 Branch if no memory
 clra
 clrb
A64A10 sta D,X Clear page
 incb
 bne A64A10
A64A20 rts

ALOC64 pshs X,U
 clra

ALCPD1 pshs A Save index of pd block
 clrb
 lda A,X
 beq ALPD12 Empty block (not found)
 tfr D,Y (y)=address of pd block
 clra
ALPD11 tst D,Y Available pd?
 beq ALPD13 ..yes
 addb #PDSIZE Skip to next pd
 bcc ALPD11 Repeat until end of pd block
ALPD12 orcc #CARRY Set carry - not found
ALPD13 leay D,Y Get address of path descriptor
 puls A Restore pd block index
 bcc ALCPD4 Found a pd, return it
 inca SKIP To next pd block
 cmpa #PDSIZE Last one checked?
 blo ALCPD1 ..no; keep looking
 clra
ALCPD2 tst A,X Search for an unused pdb
 beq ALCPD3 ..found one
 inca SKIP To next
 cmpa #PDSIZE All tried?
 blo ALCPD2 ..no; keep looking
 ldb #E$PTHF No available path
 coma RETURN Carry set - error
 bra ALCPD9 Return

ALCPD3 pshs A,X
 bsr A64ADD Add a page
 bcs ALCPDR Allocate error
 leay 0,X Set up pd address as first pd in block
 tfr X,D
 tfr A,B (b)=page address of new pd block
 puls A,X
* (A)=Pdbt Index, (X)=Pdbt
 stb A,X
 clrb
*
* A=Index Into Pdbt Of Pdb Containing Pd
* B=Low Order Address Of Pd In Pdb
* Y=Address Of Pd
*
ALCPD4 aslb FORM Path number
 rola
 aslb
 rola
 ldb #PDSIZE-1
ALCPD5 clr B,Y
 decb
 bne ALCPD5 Clear out fresh path descriptor
 sta PD.PD,Y Set pd# in pd (indicates in use)
ALCPD9 puls X,U,PC Return carry clear


ALCPDR leas 3,S Return not enough memory error
 puls X,U,PC Return

***************
* Rtrn64
*   Return Path Descriptor To Free Status
*
* Passed: (A)=Path Number
*         (X)=D.Pdbt Path Descriptor Block Table Addr
* Returns: None
* Destroys: Cc
*
R64 lda R$A,U Get block number
 ldx R$X,U Get block ptr
RTRN64 pshs D,X,Y,U Save registers
 clrb
 lsra
 rorb
 lsra PATH #
 rorb DIVIDED By 4 pd's per block
 pshs A Save a
 lda A,X
 beq RTRNP9 Impossible path number - return
 tfr D,Y Get address of pd
 clr 0,Y Mark it as unused
 clrb
 tfr D,U Get address of pdb in which pd lies
 clra
RTRNP1 tst D,U Pd in use?
 bne RTRNP9 ..yes; return
 addb #PDSIZE
 bne RTRNP1 Repeat for each pd in block
 inca (D)=$0100
 OS9 F$SRTM Return (unused) pdb to system store
 lda 0,S
 clr A,X Mark pd unused
RTRNP9 clr ,S+ Return scratch with carry clear
 puls D,X,Y,U,PC Return to caller



 ttl BOOTSTRAP Routines
 page
*****
*
*  Subroutine Iohook
*
* Handles Locating/Loading Remainder Of System
*
* Input: Y - Service Dispatch Table ptr
*
IOSTR fcb 'I,'O,'M,'A,'N+$80
IOHOOK pshs D,X,Y,U Save registers
 bsr IOLink Link ioman
 bcc IOHOOK10
 bsr BOOT Ioman not found, boot
 bcs IOHOOK20
 bsr IOLink Link ioman again
 bcs IOHOOK20
IOHOOK10 jsr 0,Y Call ioman init
 puls D,X,Y,U Retrieve registers
 ldx -2,Y Get ioman entry
 jmp 0,X
IOHOOK20 puls D,X,Y,U,PC

IOLink leax IOSTR,PCR Get ioman name ptr
 lda #SYSTM+OBJCT Get type
 OS9 F$LINK
 rts

BOOT ldx D.BASE
 comb set carry
 ldd BOOTSTR,X Get default device string
 beq BOOTXX Can't boot without device
 leax D,X Get name ptr
 lda #SYSTM+OBJCT get type
 OS9 F$LINK find bootstrap module
 bcs BOOTXX Can't boot without module
 jsr 0,Y Call boot entry
 bcs BOOTXX Boot failed
 stx D.MLIM Set memory limit
 stx D.BTLO Set boot area low limit
 leau D,X Make boot area high limit
 stu D.BTHI
BOOT10 ldd 0,X get module beginning
 cmpd #M$ID12 is it module sync code?
 bne BOOT20 branch if not
 OS9 F$VMOD Validate module
 bcs BOOT20
 ldd M$SIZE,X Get module size
 leax D,X Skip module
 bra BOOT30
BOOT20 leax 1,X Try next
BOOT30 cmpx D.BTHI End of boot?
 bcs BOOT10 Branch if not
BOOTXX rts   


 emod
OS9End equ *



 ttl Configuration Module
 page
*****
*
* Configuration Module
*
Type set SYSTM
 mod ConEnd,ConNam,Type,Revs
 fcb 0 no extended memory
 fdb $F800 High free memory bound
 fcb 12 Entries in interrupt polling table
 fcb 12 Entries in device table
 fdb ModNam Initial module name
 fdb DirNam Default directory name
 fdb TermNam Standard i/o device name
 fdb BootNam Bootstrap module name
ConNam fcs "Init"
ModNam fcs "SysGo"
DirNam fcs "/D0"
TermNam fcs "/Term"
BootNam fcs "Boot"
 emod
ConEnd equ *

 end
