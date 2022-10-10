
 nam OS-9 Level I V1.1 kernal, part 1
 ttl System Type definitions

* It was disassembled from a boot disk for Exorciser
* There is no difference from edition 8 for OS-9 level I v. 1.1.
* except for the RamLimit and the PCU09 configuration.

 use defsfile

 ttl Names & tables
 opt -c
 page

************************************************************
*                                                          *
*           OS-9 Level I V1.1 - Kernal, part 1             *
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

*****
*
*  Module Header
*
Type set SYSTM+OBJCT
Revs set REENT+1
 mod OS9End,OS9Nam,Type,Revs,COLD,0
OS9Nam fcs /OS9/

*************************
*    Edition History
*
* Ed.  8 - Beginning of history  (V1.1 final version)
*
* Ed.  9 - Changed RamLimit

*********
* Version Id
*
 ifeq CPUTYP-EXORSR
 fcc /EXOR/ Version name
RamLimit set $E800
 endc
 ifeq CPUTYP-MM19
 fcc /MM19/ Version name
RamLimit set $E800
 endc
 ifeq CPUTYP-GIMIX
 fcc /GMX/ Version name
RamLimit set $E000
 endc
 ifeq CPUTYP-EXRSET
 fcc /EXOR/ Version name
RamLimit set $E000
 endc
 ifeq CPUTYP-PCU09
  fcc /PCU09/ Version name
RamLimit set $EC00
 endc

 fcb 9 Edition number
 use copyright
CNFSTR fcs /INIT/ Configuration module name
OS9STR fcs /OS9P2/ Kernal, part 2 name
 page
*****
*
* System Service Routine Table
*
SVCTBL equ *
 fcb F$LINK
 fdb LINK-*-2
 fcb F$FORK
 fdb FORK-*-2
 fcb F$CHAN
 fdb USRCHN-*-2
 fcb F$CHAN+$80
 fdb SYSCHN-*-2
 fcb F$PNAM
 fdb PNAM-*-2
 fcb F$CNAM
 fdb CNAM-*-2
 fcb F$SBIT
 fdb SBIT-*-2
 fcb F$ABIT
 fdb ABIT-*-2
 fcb F$DBIT
 fdb DBIT-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRQM+$80
 fdb SRQMEM-*-2
 fcb F$SRTM+$80
 fdb SRTMEM-*-2
 fcb F$APRC+$80
 fdb APRC-*-2
 fcb F$NPRC+$80
 fdb NXTPRC-*-2
 fcb F$VMOD+$80
 fdb VMOD-*-2
 fcb F$SSVC
 fdb SSVC-*-2
 fcb $80



 ttl COLD Start
 page
*
* Clear System Memory, Skipping First 32 Bytes
*
LORAM set $20
HIRAM set $300
RAMMSK set $F0 Initial bit map mask
COLD ldx #LORAM Set ptr
 ldy #HIRAM-LORAM Set byte count
 clra CLEAR D
 clrb
COLD05 std ,X++ Clear two bytes
 leay -2,Y Count down
 bne COLD05
 inca ONE Page for direct page
 std D.FMBM Set free memory bit map
 addb #BMAPSZ Add map size
 std D.FMBM+2
 addb #2 Reserve i/o routine entry
 std D.SSVC Set system service request table
 addb #SVCTSZ+2 Add table size
 std D.USVC Set user service request table
 clrb SET Module directory address
 inca
 std D.MODD Set module directory address
 stx D.MODD+2 Set end
 leas $100,X get initial stack
*
* Find End Of Ram
*
COLD10 leay 0,X Copy current ptr
 ldd 0,Y Get current value
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD15 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD15 If not, eor
 std 0,Y Replace current value
 leax 256,Y Try next page
 cmpx #RamLimit
 bcs COLD10 Branch if more
 leay 0,X Copy end-of-ram ptr
COLD15 leax 0,Y Copy eor ptr

 ifeq CPUTyp-EXORSR
*** >>> Patch For Exorciser Environment <<< ***
*
 leax NMI,pcr
 stx $FFFC
 leax SWIRQ,pcr
 stx $FFFA
 leax IRQ,PCR get irq vector
 stx $FFF8 set hardware vector
 leax SWI2RQ,PCR get swi2 vector
 stx $FFF4 set hardware vector
 leax SWI3RQ,PCR get swi3 vector
 stx $FFF2 set hardware vector
EndRAM equ $A23 This must be greater than the size
* of ctlrmod+bootmod+os9p2+*
 leax -EndRAM,PCR get artificial end-of-ram
 stx D.MLIM
 stx D.BtLo
 stx D.BtHi
*
*** >>> End Of Exorciser Patch <<< ***
 else
 stx D.MLIM Set memory limit
 endc
 ifeq  CPUTYP-PCU09
 stx D.BtLo
 stx D.BtHi
 endc

*
* Search Memory For Modules, Build Module Directory
*
COLD20 lbsr VALMOD Look for valid module
 bcs COLD30 Branch if bad module
 ldd M$SIZE,X Get module size
 leax D,X Skip module
 bra COLD35
COLD30 cmpb #E$KMOD Is it known module
 beq COLD40 Branch on first duplicate
 leax 1,X Try next location
COLD35 bne COLD20
COLD40 leay SYSVEC,PCR Get interrupt entries
 leax ROMEnd,PCR get vector offset
 pshs X save it
 ldx #D.SWI3 Get vector address
COLD45 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.NMI end of dp vectors?
 bls COLD45 branch if not
 leas 2,S return scratch
 leax USRIRQ,PCR Get user interrupt routine
 stx D.UIRQ
 leax USRREQ,PCR Get user service routine
 stx D.UREQ
 leax SYSIRQ,PCR Get system interrupt routine
 stx D.SIRQ
 stx D.ISVC Set interrupts to system state
 leax SYSREQ,PCR Get system service routine
 stx D.SREQ
 stx D.SWI2 Set service to system state
 leax IOPOLL,PCR Set irq polling routine
 stx D.POLL
*
* Initialize Service Routine Dispatch Table
*
 leay SVCTBL,PCR Get ptr to service routine table
 lbsr SETSVC Set service table entries
 lda #SYSTM Get system type module
 leax CNFSTR,PCR Get initial module name ptr
 OS9 F$LINK Link to configuration module
 lbcs COLD Retry if error
 stu D.BASE Save ptr
 ldd MAXMEM+1,U Get memory limit
 clrb ROUND Down
 cmpd D.MLIM Does ram go that high?
 bcc COLD50 Branch if not
 std D.MLIM Set given memory limit
COLD50 ldx D.FMBM Get bit map ptr
 ldb #RAMMSK Get initial mask
 stb 0,X
 clra GET Beginning page number
 ldb D.MLIM
 negb GET Page count
 tfr D,Y
 negb GET Page number
 lbsr ALOCAT
 leax OS9STR,PCR
 lda #SYSTM+OBJCT Get object type
 OS9 F$LINK
 lbcs COLD
 jmp 0,Y Let os9 part two finish

 ttl INTERRUPT Service handlers
 page
*****
*
*  Swi3 Interrupt Routine
*
SWI3RQ jmp [D.SWI3] Go thru page zero vector



*****
*
*  Swi2 Interrupt Routine
*
SWI2RQ jmp [D.SWI2] Go thru page zero vector



*****
*
*  Firq Interrupt Handler
*
FIRQ jmp [D.FIRQ] Go thru page zero vector



*****
*
*  Irq Interrupt Routine
*
IRQ jmp [D.IRQ] Go thru page zero vector



*****
*
*  Swi Interrupt Routine
*
SWIRQ jmp [D.SWI] Go thru page zero vector



*****
*
*  Nmi Interrupt Routine
*
NMI jmp [D.NMI] Go thru page zero vector
 page
*****
*
*  Swi3 Handler
*
SWI3HN pshs B,X,PC Save registers
 ldb #P$SWI3 Use swi3 vector
 bra SWIH10



*****
*
*  Swi2 Handler
*
SWI2HN pshs B,X,PC Save registers
 ldb #P$SWI2 Use swi2 vector
 bra SWIH10



*****
*
*  Firq Handler
*
FIRQHN rti



*****
*
*  Irq Handler
*
IRQHN jmp [D.ISVC] Go to interrupt service



*****
*
*  Swi Handler
*
SWIHN pshs B,X,PC Save registers
 ldb #P$SWI Use swi vector
SWIH10 ldx >D.PROC Get process descriptor ptr
 ldx B,X Get entry point address
 stx 3,S Save it
 puls B,X,PC Restore registers & jump



*****
*
*  Nmi Handler
*
NMIHN equ FIRQHN
 page
*****
*
*  Interrupt Service Routine Usrirq
*
* Handles Irq While In User State
*
USRIRQ leay <USRI10,PCR Get post-switch routine
SWITCH clra SET Direct page
 tfr A,DP
 ldx D.PROC Get process
 ldd D.SREQ Get system request routine
 std D.SWI2
 ldd D.SIRQ Get system irq routine
 std D.ISVC
 leau 0,S Copy user stack ptr
 stu P$SP,X
 lda P$STAT,X Set system state
 ora #SYSTAT
 sta P$STAT,X
 jmp 0,Y Go to post-switch routine
USRI10 jsr [D.POLL] Call irq polling routine
 bcc USRI20 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IRQM set interrupt mask
 stb R$CC,S update condition codes
USRI20 lbra USRRET



*****
*
*  Interrupt Routine Sysirq
*
* Handles Irq While In System State
*
SYSIRQ clra clear direct page
 tfr A,DP
 jsr [D.POLL] Call irq polling
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IRQM set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti



*****
*
*  Interrupt Polling Default
*
IOPOLL comb set carry
 rts
 page
*****
*
*  Clock Tick Routine
*
* Wake Sleeping Processes
*
TICK ldx D.SPRQ Get sleeping queue ptr
 beq SLICE Branch if none
 lda P$STAT,X Get process status
 bita #TSLEEP Is it in timed sleep?
 beq SLICE Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 subd #1 Count down
 std R$X,U Update tick count
 bne SLICE Branch if ticks left
TICK10 ldu P$QUEU,X Get next process ptr
 bsr ACTPRC Activate process
 leax 0,U Copy process ptr
 beq TICK20 Branch if end of queue
 lda P$STAT,X Get process status
 bita #TSLEEP In timed sleep?
 beq TICK20 Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 beq TICK10 Branch if time
TICK20 stx D.SPRQ Update sleep queue ptr
*
* Update Time Slice counter
*
SLICE dec D.SLIC Count tick
 bne SLIC10 Branch if slice not over
 lda D.TSLC Get ticks/time-slice
 sta D.SLIC Reset slice tick count
*
* If Process not in System State, Give up Time-Slice
*
 ldx D.PROC Get current process ptr
 beq SLIC10 Branch if none
 lda P$STAT,X Get status
 ora #TIMOUT Set time-out flag
 sta P$STAT,X Update process status
 bpl SLIC20 Branch if user state
SLIC10 rti
SLIC20 leay USRRET,PCR Set transfer ptr
 bra SWITCH Switch to system state
 page
*****
*
*  Subroutine Actprc
*
* Put Process In Active Process Queue
*
APRC ldx R$X,U
ACTPRC pshs Y,U Save registers
*
* Age Active Processes
*
 ldu #D.APRQ-P$QUEU Fake process ptr
 bra ACTP20
ACTP10 ldb P$AGE,U Get age
 incb
 beq ACTP20 Branch if highest
 stb P$AGE,U
ACTP20 ldu P$QUEU,U Get next process
 bne ACTP10 Branch if more
*
* Sort New Process Into Queue
*
 ldu #D.APRQ-P$QUEU Fake process ptr
 lda P$PRIO,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQM+FIRQM Set interrupt masks
ACTP30 leay 0,U Copy ptr to this process
 ldu P$QUEU,U Get ptr to next process
 beq ACTP40 Branch if no more
 cmpa P$AGE,U Who has bigger priority?
 bls ACTP30 Branch if queue process
ACTP40 stu P$QUEU,X Insert into list
 stx P$QUEU,Y
 clrb CLEAR Carry
 puls Y,U,PC
 page
*****
*
*  Subroutine Usrreq
*
* User Service Request Handling Routine
*
USRREQ leay <USRR10,PCR Get post-switch routine
 orcc #IRQM+FIRQM Set interrupt masks
 lbra SWITCH Switch to system state
USRR10 andcc #$FF-IRQM-FIRQM Clear interrupt masks
 ldy D.USVC Get user service routine table
 bsr DISPCH Go do request
USRRET ldx D.PROC Get process ptr
 beq NXTPRC Branch if none
 orcc #IRQM+FIRQM Set interrupt masks
 ldb P$STAT,X Clear system state
 andb #$FF-SYSTAT
 stb P$STAT,X Update status
 bitb #TIMOUT Is time-slice over?
 beq CURPRC Branch if not
 andb #$FF-TIMOUT Clear time-out flag
 stb P$STAT,X Update status
USRR20 bsr ACTPRC Put in active queue
 bra NXTPRC Start next process



*****
*
*  Subroutine Sysreq
*
SYSREQ clra clear direct page
 tfr A,DP
 leau 0,S Copy stack ptr
 ldy D.SSVC Get system service routine table
 bsr DISPCH Call service routine
 rti
 page
*****
*
*  Subroutine Dispch
*
* Service Routine Dispatch
*
DISPCH pshs U Save register ptr
*
* Get Service Request Code
*
 ldx R$PC,U Get program counter
 ldb ,X+ Get service code
 stx R$PC,U Update program counter
*
* Get Service Routine Address
*
 aslb SHIFT For two byte table entries
 bcc DISP10 Branch if not i/o
 rorb RE-ADJUST Byte
 ldx -2,Y Get i/o routine
 bra DISP20
DISP10 cmpb #SVCTSZ Code in range?
 bcc BADSVC
 ldx B,Y Get routine address
 beq BADSVC Branch if none
DISP20 jsr 0,X Call routine
*
* Return Condition Codes To Caller
*
DISP25 puls U Retrieve register ptr
 tfr CC,A Copy condition codes
 bcc DISP30 Branch if no error
 stb R$B,U Return error code
DISP30 ldb R$CC,U Get condition codes
 andb #$F0 Clear n, z, v, c
 stb R$CC,U Save it
 anda #$0F Clear e, f, h, i
 ora R$CC,U Return conditions
 sta R$CC,U
 rts

BADSVC comb SET Carry
 ldb #E$USVC Unknown service code
 bra DISP25
 page
*****
*
*  Routine Nxtprc
*
* Starts next Process in Active Queue
* If no Active Processes, Wait for one
*
NXTOUT ldb P$STAT,X Get process status
 orb #SYSTAT Set system state
 stb P$STAT,X Update status
 ldb P$SIGN,X Return fatal signal
 andcc #$FF-IRQM-FIRQM Clear interrupt masks
 OS9 F$EXIT Terminate process
NXTPRC clra
 clrb
 std D.PROC Clear current process
 bra NXTP06
*
* Loop until there is a Process in the Active Queue
*
NXTP04 cwai #$FF-IRQM-FIRQM Clear interrupt masks & wait
NXTP06 orcc #IRQM+FIRQM Set interrupt masks
 ldx D.APRQ Get first process in active queue
 beq NXTP04 Branch if none
*
* Remove Process from Active Queue
*
 ldd P$QUEU,X Get next process ptr
 std D.APRQ Remove first from active queue
 stx D.PROC Set current process
 lds P$SP,X Get stack ptr
*
* Check Process Status, check for Signal pending
*
CURPRC ldb P$STAT,X Is process in system state?
 bmi NXTP30 Branch if so
 bitb #CONDEM Is process condemmed?
 bne NXTOUT Branch if so
 ldb P$SIGN,X Is a signal waiting?
 beq NXTP20 Branch if not
 decb Wake-up Signal?
 beq NXTP10 Branch if so
*
* Signal is pending; If an Intercept has been set
* Build an Interrupt Stack for User
*
 ldu P$SIGV,X Get intercept vector
 beq NXTOUT Branch if none
 ldy P$SIGD,X Get intercept data address
 ldd R$Y,S Get user y register
 pshs D,Y,U Build partial stack
 ldu R$X+6,S Get user x register
 lda P$SIGN,X Get signal
 ldb R$DP+6,S Get direct page
 tfr D,Y Copy registers
 ldd R$CC+6,S Get registers
 pshs D,Y,U Complete stack
 clrb
NXTP10 stb P$SIGN,X Clear signal
*
* Switch to User State
*
NXTP20 ldd P$SWI2,X Get user service request
 std D.SWI2
 ldd D.UIRQ Get user irq
 std D.ISVC
NXTP30 rti Start next process
 page
*****
*
*  Subroutine Link
*
* Search Module Directory & Return Module Address
*
* Input: U = Register Package
* Output: Cc = Carry Set If Not Found
* Local: None
* Global: D.MODD
*
LINK pshs U Save register package
 ldd R$D,U Get revision, type
 ldx R$X,U Get name ptr
 lbsr FMODUL Search directory
 bcc LINK10
 ldb #E$LNEM Err: link non-existing module
 bra LINKXit
LINK10 ldy 0,U Get module address
 ldb M$REVS,Y get attributes/revision
 bitb #REENT is this sharable
 bne LINK20 branch if so
 tst 2,U is it in use?
 beq LINK20 branch if not
 comb set carry
 ldb #E$MODB err: module busy
 bra LINKXit
LINK20 inc 2,U count use
 ldu 0,S Get register ptr
 stx R$X,U
 sty R$U,U
 ldd M$TYPE,Y Get type/lang & attr/revs
 std R$D,U
 ldd M$EXEC,Y Get execution offset
 leax D,Y Make entry ptr
 stx R$Y,U Return it to user
LINKXit puls U,PC



*****
*
*  Subroutine Valmod
*
* Validate Module
*
VMOD pshs U Save register ptr
 ldx R$X,U Get new module ptr
 bsr VALMOD Validate module
 puls Y Retrieve register ptr
 stu R$U,Y Return directory entry
VMOD10 rts

VALMOD bsr IDCHK Check sync & chksum
 bcs VALM40 Branch if not module
 lda M$TYPE,X Get module type
 pshs A,X Save module type & ptr
 ldd M$NAME,X Get name ptr
 leax D,X
 puls A Retrieve type
 lbsr FMODUL Search directory
 puls X Retrieve module ptr
 bcs VALM10 Branch if not found
 ldb #E$KMOD Get known module error code
 cmpx 0,U Is it same module?
 beq BADVAL Branch if so
 lda M$REVS,X Get new revision level
 anda #REVMSK
 pshs A Save it
 ldy 0,U Get old module ptr
 lda M$REVS,Y Get old revision level
 anda #REVMSK
 cmpa ,S+ Which is higher?
 bcc BADVAL Branch if old
 pshs X,Y Save registers
 ldb 2,U module in use?
 bne VALM15 branch if so
 ldx 0,U Get module ptr
 cmpx D.BTLO Is it rom/system module?
 bcc VALM15 Branch if so
 ldd M$SIZE,X
 addd #$FF
 tfr A,B
 clra
 tfr D,Y
 ldb 0,U
 ldx D.FMBM
 OS9 F$DBIT Clear bit map
 clr 2,U
VALM15 puls X,Y
VALM20 stx 0,U Install new module
VALM30 clrb CLEAR Carry
VALM40 rts
VALM10 leay 0,U Free directory entry?
 bne VALM20 Branch if so
 ldb #E$DIRF Err: directory full
BADVAL coma SET Carry
 rts

IDCHK ldd 0,X Get first two bytes
 cmpd #M$ID12 Check them
 bne IDCH10 Branch if not module
 leay 8,X Get header end ptr
 bsr PARITY Check header parity
 bcc IDCH30 Branch if good
IDCH10 comb SET Carry
 ldb #E$IID Err: illegal id block
IDCH20 rts
IDCH30 pshs X Save module ptr
 ldy M$SIZE,X Get module size
 bsr CRCCHK Check crc code
 puls X,PC



*****
*
*  Subroutine Parity
*
* Check Vertical Parity
*
PARITY pshs X,Y Save registers
 clra
PARI10 eora ,X+ Add parity of next byte
 cmpx 2,S Done?
 bls PARI10 Branch if not
 cmpa #$FF Parity good?
 puls X,Y,PC



*****
*
*  Subroutine Crcchk
*
* Check Module Crc
*
CRCCHK ldd #$FFFF
 pshs D.BASE crc register
 pshs D
 leau 1,S Get crc register ptr
CRCC10 lda ,X+ Get next byte
 bsr CRCCAL Calculate crc
 leay -1,Y count byte
 bne CRCC10 branch if more
 clr -1,U Clear msb-1
 lda 0,U Get crc
 cmpa #$80 Is it good?
 bne CRCC20 Branch if not
 ldd 1,U Get crc
 cmpd #$0FE3 Is it good?
 beq CRCC30 Branch if so
CRCC20 comb SET Carry
 ldb #E$BCRC Err: bad crc
CRCC30 puls X,Y,PC



*****
*
*  Subroutine Crcgen
*
* Generate Crc
*
CRCGen ldx R$X,U get data ptr
 ldy R$Y,U get byte count
 beq CRCGen20 branch if none
 ldu R$U,U get crc ptr
CRCGen10 lda ,X+ get next data byte
 bsr CRCCAL update crc
 leay -1,Y count byte
 bne CRCGen10 branch if more
CRCGen20 clrb clear carry
 rts



*****
*
*  Subroutine Crccal
*
* Calculate Next Crc Value
*
CRCCAL eora 0,U Add crc msb
 pshs A save it
 ldd 1,U Get crc mid & low
 std 0,U Shift to high & mid
 clra
 ldb 0,S Get old msb
 lslb SHIFT D
 rola
 eora 1,U Add old lsb
 std 1,U Set crc mid & low
 clrb
 lda 0,S Get old msb
 lsra SHIFT D
 rorb
 lsra SHIFT D
 rorb
 eora 1,U Add new mid
 eorb 2,U Add new low
 std 1,U Set crc mid & low
 lda 0,S Get old msb
 lsla
 eora 0,S Add old msb
 sta 0,S
 lsla
 lsla
 eora 0,S Add altered msb
 sta 0,S
 lsla
 lsla
 lsla
 lsla
 eora ,S+ Add altered msb
 bpl CRCC99
 ldd #$8021
 eora 0,U
 sta 0,U
 eorb 2,U
 stb 2,U
CRCC99 rts



*****
*
*  Subroutine Fmodul
*
* Search Directory For Module
*
* Input: A = Type
*        X = Name String Ptr
* Output: U = Directory Entry Address
*         Cc = Carry Set If Not Found
* Local: None
* Global: D.MODD

FMODUL ldu #0 Return zero if not found
 tfr A,B Copy type
 anda #TYPMSK Get desired type
 andb #LANMSK Get desired language
 pshs D,X,Y,U Save registers
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.MODD Get module directory ptr
FMOD10 pshs B,Y,U Save count, end-of-name, & directory
 ldu 0,U Get module ptr
 beq FMOD20 Branch if not used
 ldd M$NAME,U Get name offset
 leay D,U Get name ptr
 ldb 0,S Get character count
 lbsr CHKNAM Compare names
 bcs FMOD30 Branch if different
 lda 5,S Get desired type
 beq FMOD14 Branch if any
 eora M$TYPE,U Get type difference
 anda #TYPMSK
 bne FMOD30 Branch if different
FMOD14 lda 6,S Get desired language
 beq FMOD16 Branch if any
 eora M$TYPE,U Get language difference
 anda #LANMSK
 bne FMOD30 Branch if different
FMOD16 puls B,X,U Retrieve registers
 stu 6,S Return directory entry
 bsr SKIPSP Skip spaces
 stx 2,S Return updated ptr
 clra CLEAR Carry
 bra FMOD40
FMOD20 ldd 11,S Free entry found?
 bne FMOD30 Branch if so
 ldd 3,S Return this entry
 std 11,S
FMOD30 puls B,Y,U Retrieve registers
 leau 4,U Move to next entry
 cmpu D.MODD+2 End of directory?
 bcs FMOD10 Branch if not
FMOD35 comb SET Carry
FMOD40 puls D,X,Y,U,PC

SKIPSP lda #'  get space
SKIP10 cmpa ,X+ Is there a space
 beq SKIP10
 lda ,-X Get not space
 rts
 page
*****
*
*  Subroutine Fork
*
* Creates New Child Process
*
FORK ldx D.PRDB Get process block ptr
 OS9 F$A64 Get new process descriptor
 bcs PRCFUL Branch if none left
 ldx D.PROC Get parent process ptr
 pshs X Save parent process ptr
 ldd P$USER,X Copy user index
 std P$USER,Y
 lda P$PRIO,X Copy priority
 clrb CLEAR Age
 std P$PRIO,Y
 ldb #SYSTAT Get system state flag
 stb P$STAT,Y Set infant state
 sty D.PROC Make child current process
*
* Pass I/O Defaults & Paths 0, 1, And 2
*    From Parent To Child
*
 leax P$DIO,X Get parent path ptr
 leay P$DIO,Y Get child path ptr
 ldb #DIOSIZ Get byte count
FORK10 lda ,X+ Get parent byte
 sta ,Y+ Pass to child
 decb COUNT Down
 bne FORK10 Branch if more
 ldb #3 Get number of paths
FORK20 lda ,X+ Get path number
 OS9 I$DUP Duplicate path
 bcc FORK25
 clra CLEAR Path number
FORK25 sta ,Y+ Pass path to child
 decb COUNT Down
 bne FORK20 Branch if more
 bsr SETPRC Set up process
 bcs FORK40 Branch if error
 puls Y Retrieve parent process ptr
 sty D.PROC Make parent current process
 lda P$ID,X Get child id
 sta R$A,U Return to parent
 ldb P$CID,Y Get youngest child id
 sta P$CID,Y Set new child
 lda P$ID,Y Get parent id
 std P$PID,X Set parent & sibling ids
 ldb P$STAT,X Get child state
 andb #$FF-SYSTAT Clear system state
 stb P$STAT,X Update child state
 OS9 F$APRC Activate child process
 rts
FORK40 pshs B Save error code
 OS9 F$EXIT Terminate child
 comb SET Carry
 puls B,X Retrieve error code & parent process ptr
 stx D.PROC Make parent current process
 rts

PRCFUL comb SET Carry
 ldb #E$PRCF Err: process table full
 rts



*****
*
*  Subroutine Usrchn
*
* User Chain Routine
*
USRCHN bsr CHAIN Do chain
 bcs BADCHN Branch if error
 orcc #IRQM+FIRQM Set interrupt masks
 ldb P$STAT,X Clear system state
 andb #$FF-SYSTAT
 stb P$STAT,X
USRC10 OS9 F$APRC Put process in active queue
 OS9 F$NPRC Start next process



*****
*
*  Subroutine Syschn
*
* System Chain Routine
*
SYSCHN bsr CHAIN Do chain
 bcc USRC10 Branch if no error
BADCHN pshs B Save error code
 stb P$SIGN,X Set error status
 ldb P$STAT,X Get process status
 orb #CONDEM Condem process
 stb P$STAT,X
 ldb #$FF Set high priority
 stb P$PRIO,X
 comb
 puls B,PC



*****
*
* Subroutine Chain
*
* Execute Overlay
*
CHAIN pshs U Save register ptr
 ldx D.PROC Get process ptr
 ldu P$PMOD,X Get primary module ptr
 OS9 F$UNLK
 ldu 0,S Retrieve register ptr
 bsr SETPRC Set up process
 puls U,PC Clean stack
 page
*****
*
*  Subroutine Setprc
*
* Set Up Process Descriptor
*
SETPRC ldx D.PROC Get process ptr
 pshs X,U Save process & register ptr
 ldd D.UREQ Get user service request
 std P$SWI,X Reset swi vector
 std P$SWI2,X Reset swi2 vector
 std P$SWI3,X Reset swi3 vector
 clra
 clrb
 sta P$SIGN,X Clear signal
 std P$SIGV,X Clear signal vector ptr
 lda R$A,U Get type
 ldx R$X,U Get name ptr
 OS9 F$LINK
 bcc SETP10 Branch if found
 OS9 F$LOAD Try loading it
 bcs SETP50 Branch if not loadable
SETP10 ldy D.PROC Get process ptr
 stu P$PMOD,Y Save primary module ptr
 cmpa #PRGRM+OBJCT is it program object?
 beq SETP15 branch if so
 cmpa #SYSTM+OBJCT is it system object?
 beq SETP15 branch if so
 comb set carry
 ldb #E$NEMod err: non-executable module
 bra SETP50
SETP15 leay 0,U Copy module ptr
 ldu 2,S Get register ptr
 stx R$X,U Return updated ptr
 lda R$B,U Get memory over-ride
 clrb
 cmpd M$STAK,Y Is it big enough?
 bcc SETP20
 ldd M$STAK,Y Get memory required
SETP20 OS9 F$MEM Mem to correct size
 bcs SETP50 Branch if no memory
 subd #R$SIZE Deduct stack room
 subd R$Y,U Deduct parameter count
 bcs BADPAR Branch if not available
 ldx R$U,U Get parameter beginning
 ldd R$Y,U Get parameter count
 pshs D Save parameter count
 beq SETP40 Branch if no parameters
 leax D,X Get parameter end ptr
SETP30 lda ,-X Get parameter byte
 sta ,-Y Pass it
 cmpx R$U,U Done?
 bhi SETP30 Branch if not
SETP40 ldx D.PROC Get process ptr
 sty R$X-R$SIZE,Y
 leay -R$SIZE,Y
 sty P$SP,X Set stack ptr
 lda P$ADDR,X Set beginning address
 clrb
 std R$U,Y
 sta R$DP,Y Get direct page ptr
 adda P$PCNT,X Get end prt
 std R$Y,Y
 puls D Retrieve parameter byte count
 std R$D,Y Pass to process
 ldb #ENTIRE Set cc entire bit
 stb R$CC,Y
 ldu P$PMOD,X Get module ptr
 ldd M$EXEC,U
 leau D,U Get module entry
 stu R$PC,Y Set new program counter
 clrb CLEAR Carry
BADPAR ldb #E$IFKP Err: illegal fork parameters
SETP50 puls X,U,PC
 page
*****
*
*  Subroutine Srqmem
*
* System Memory Request
*
SRQMEM ldd R$D,U Get byte count
 addd #$FF Round up to page
 clrb
 std R$D,U Return size to user
 ldx D.FMBM+2 Get end of bit map
 ldd #$1FF Set mask & bit number
 pshs D Save them
 bra SRQM20
SRQM10 dec 1,S Count page number down
 ldb 1,S Save it
SRQM15 lsl 0,S Shift mask
 bcc SRQM25 Branch if no byte change
 rol 0,S Move mask to low bit
SRQM20 leax -1,X Move to next map byte
 cmpx D.FMBM End of map?
 bcs SRQM30
SRQM25 lda 0,X Get map byte
 anda 0,S Get map bit
 bne SRQM10 Branch if allocated
 dec 1,S Count page number down
 subb 1,S Get number of free pages
 cmpb R$A,U Compare to requested number
 rora SAVE Carry
 addb 1,S Restore high page bound
 rola RESTORE Carry
 bcs SRQM15 Branch if not enough
 ldb 1,S Get page number
 clra
 incb
SRQM30 leas 2,S Return scratch
 bcs MEMFUL Branch if not enough
 ldx D.FMBM Get free memory ptr
 tfr D,Y Copy page number
 ldb R$A,U Get page count
 clra
 exg D,Y Switch page count & number
 bsr ALOCAT Allocate memory
 exg A,B Convert page number to address
 std R$U,U Return ptr to memory
SRQMXX clra CLEAR Carry
 rts

MEMFUL comb SET Carry
 ldb #E$MEMF Get error code
 rts
 page
*****
*
*  Subroutine Srtmem
*
* System Memory Return
*
SRTMEM ldd R$D,U Get byte count
 addd #$FF Round up to page
 tfr A,B Make page count
 clra
 tfr D,Y Copy page count
 ldd R$U,U Get address
 beq SRQMXX Branch if returning nothing
 tstb IS Address good?
 beq SRTM10 Branch if so
BADPAG comb SET Carry
 ldb #E$BBND
 rts
SRTM10 exg A,B Convert address to page number
 ldx D.FMBM Get free memory ptr
 bra DEALOC Deallocate memory
 page
*****
*
*  Subroutine Alocat
*
* Set Bits In Bit Map
*
* Input: D = Beginning Page Number
*        X = Bit Map Address
*        Y = Page Count
* Output: None
* Local: None
* Global: None
*
ABIT ldd R$D,U Get beginning bit number
 leau R$X,U
 pulu X,Y Get bit map addr & bit count
ALOCAT pshs D,X,Y Save registers
 bsr FNDBIT Adjust map ptr & get bit mask
 tsta TEST Mask
 pshs A Save mask
 bmi ALOC15 Branch if first bit of byte
 lda 0,X Get map byte
ALOC10 ora 0,S Set bit
 leay -1,Y Decrement page count
 beq ALOC35 Branch if done
 lsr 0,S Shift mask
 bcc ALOC10 Branch if more in this byte
 sta ,X+ Restore byte
ALOC15 tfr Y,D Copy page count
 sta 0,S Save msb
 lda #$FF Get eight pages worth
 bra ALOC25
ALOC20 sta ,X+ Get eight pages
ALOC25 subb #8 Are there eight left?
 bcc ALOC20 Branch if so
 dec 0,S Any msb left?
 bpl ALOC20 Branch if so
ALOC30 asla MAKE Final mask
 incb MOVE Count to zero
 bne ALOC30 Branch if not done
 ora 0,X Set final bits
ALOC35 sta 0,X Set byte
 clra CLEAR Carry
 leas 1,S Return scratch
 puls D,X,Y,PC
 page
*****
*
*  Subroutine Fndbit
*
* Make Page Number Into Ptr & Mask
*
* Input: D = Page Number
*        X = Map Beginning Address
* Output: A = Bit Mask
*         B = 0
*         X = Byte Address
* Local: None
* Global: None
*
FNDBIT pshs B Save lsb
 lsra PAGE/2
 rorb
 lsra PAGE/4
 rorb
 lsra PAGE/8
 rorb
 leax D,X Get byte address
 puls B Get lsb
 lda #$80 Get mask
 andb #7 Page modulo 8
 beq FNDB20 Branch if done
FNDB10 lsra SHIFT Mask
 decb
 bne FNDB10
FNDB20 rts
 page
*****
*
*  Subroutine Dealoc
*
* Deallocates Space In Bit Map
*
* Input: D = Beginning Page Number
*        X = Bit Map Address
*        Y = Page Count
* Output: None
* Local: None
* Global: None
*
DBIT ldd R$D,U Get beginning bit number
 leau R$X,U
 pulu X,Y Get bit map addr & bit count
DEALOC pshs D,X,Y Save registers
 bsr FNDBIT Adjust map ptr & get bit mask
 coma REVERSE Mask
 pshs A save it
 bpl DEAL10 branch if first bit of byte
 lda 0,X get map byte
DEAL05 anda 0,S Clear bit
 leay -1,Y Decrement page count
 beq DEAL30 Branch if done
 asr 0,S Shift mask
 bcs DEAL05 Branch if more
 sta ,X+ Store map byte
DEAL10 tfr Y,D Copy page count
 bra DEAL20
DEAL15 clr ,X+ Clear map byte
DEAL20 subd #8 Are there eight left?
 bhi DEAL15 Branch if so
 beq DEAL30 Branch if done
DEAL25 asla MAKE Final mask
 incb
 bne DEAL25
 coma REVERSE Mask
 anda 0,X Clear map bits
DEAL30 sta 0,X Store map byte
 clr ,S+ Clear carry & return scratch
 puls D,X,Y,PC
 page
*****
*
*  Subroutine Floblk
*
* Find Free Block Searching Up
*
* Same As Fhiblk
*
SBIT pshs U Save register ptr
 ldd R$D,U Get beginning bit number
 ldx R$X,U Get bit map ptr
 ldy R$Y,U Get bit count
 ldu R$U,U Get map end addr
 bsr FLOBLK Search bit map
 puls U Retrieve register ptr
 std R$D,U Return bit number
 sty R$Y,U return bits found
 rts

FLOBLK pshs D,X,Y,U Save registers
 pshs D,Y Copy beginning page number & size
 clr 8,S Clear size found
 clr 9,S
 tfr D,Y Copy beginning page number
 bsr FNDBIT Adjust map ptr & get bit mask
 pshs A Save mask
 bra FLOB20
FLOB10 leay 1,Y Move beginning bit number
 sty 5,S Save beginning block number
FLOB15 lsr 0,S Shift mask
 bcc FLOB25 Branch if mask okay
 ror 0,S Shift mask around end
 leax 1,X Move map ptr
FLOB20 cmpx 11,S End of map?
 bcc FLOB30 Branch if so
FLOB25 lda 0,X Get map byte
 anda 0,S Mask bit
 bne FLOB10 Branch if in use
 leay 1,Y Move page number
 tfr Y,D Copy page number
 subd 5,S Subtract beginning page number
 cmpd 3,S Block big enough?
 bcc FLOB35 Branch if so
 cmpd 9,S Biggest so far?
 bls FLOB15 Branch if not
 std 9,S Save size
 ldd 5,S Copy beginning page number
 std 1,S
 bra FLOB15
FLOB30 ldd 1,S Get beginning page number of largest
 std 5,S Return it
 coma SET Carry
 bra FLOB40
FLOB35 std 9,S Return size
FLOB40 leas 5,S Return scratch
 puls D,X,Y,U,PC
 page
***************
* Parse Path Name
*
* Passed:  (X)=Pathname Ptr
* Returns: (X)=Skipped Past Prefix '/'
*          (Y)=Ptr To 1St Delim In Pathname
*          (A)=Delimiter Character
*          (B)=Number Of Characters Found <=255
*           Cc=Set If No Characters Found
* Unaffects: U
*
PNAM ldx R$X,U Get string ptr
 bsr PRSNAM Call parse name
 stx R$X,U Return updated string ptr
 sty R$Y,U Return name end ptr
 std R$D,U Return byte & size
 rts

PRSNAM lda 0,X Get first char
 cmpa #'/ Slash?
 bne PRSNA1 ..no
 leax 1,X ..yes; skip it
PRSNA1 leay 0,X
 clrb
 lda ,Y+
 anda #$7F
 bsr ALPHA 1st character must be alphabetic
 bcs PRSNA4 Branch if bad name
PRSNA2 incb INCREMENT Character count
 tst -1,Y End of name (high bit set)?
 bmi PRSNA3 ..yes; quit
 lda ,Y+ Get next character
 anda #$7F Strip high order bit
 bsr ALFNUM Alphanumeric?
 bcc PRSNA2 ..yes; count it
 leay -1,Y Backup to unknown
PRSNA3 clra
 rts

PRSNA4 cmpa #', Comma (skip if so)?
 bne PRSNA6 ..no
PRSNA5 lda ,Y+ Get next character
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 leay -1,Y Backup to non-delim char
 coma (NAME Not found)
 rts RETURN Carry set



* Check For Alphanumeric Character
*
* Passed:  (A)=Char
* Returns:  Cc=Set If Not Alphanumeric
* Destroys None
*
ALFNUM cmpa #'. period?
 beq RETCC branch if so
 cmpa #'0 Below zero?
 blo RETCS ..yes; return carry set
 cmpa #'9 Numeric?
 bls RETCC ..yes
 cmpa #'_ Underscore?
 beq RETCC ..yes
ALPHA cmpa #'A
 blo RETCS
 cmpa #'Z Upper case alphabetic?
 bls RETCC ..yes
 cmpa #$61 Below lower case a?
 blo RETCS ..yes
 cmpa #$7A Lower case?
 bls RETCC ..yes
RETCS orcc #CARRY Set carry
 rts



* Compare Pathname With Module Name
*
* Passed:  (X)=Pathname
*          (Y)=Module Name (High Bit Set Delim)
*          (B)=Length Of Pathname
* Returns:  Cc=Set If Names Not Equal
*
CNAM ldb R$B,U Get size
 leau R$X,U
 pulu X,Y Get string ptrs
CHKNAM pshs D,X,Y Save registers
CHKN10 lda ,Y+ Get (next) char of module name
 bmi CHKN20 Branch if last module char
 decb DECREMENT Char count
 beq RETCS1 Branch if last character
 eora ,X+ Equal pathname char?
 anda #$FF-$20 Match upper/lower case
 beq CHKN10 ..yes; repeat
RETCS1 orcc #Carry Set carry
 puls D,X,Y,PC
CHKN20 decb LAST Char of pathname?
 bne RETCS1 Branch if not
 eora 0,X Does last one match?
 anda #$FF-$A0 Match upper/lower & high order bit
 bne RETCS1 ..no; return carry set
 puls D,X,Y Restore regs
RETCC andcc #$FF-CARRY Clear carry
 rts
 page
*****
*
*  Subroutine Ssvc
*
* Set Entries In Service Routine Dispatch Tables
*
SSVC ldy R$Y,U Get table address
 bra SETSVC

SETS10 aslb MAKE Table offset
 ldu D.SSVC Get system service table
 leau B,U Get entry ptr
 ldd ,Y++ Get table relative offset
 leax D,Y Get routine address
 stx 0,U Put in system routine table
 bcs SETSVC Branch if system only
 stx SVCTSZ+2,U Put in user routine table
SETSVC ldb ,Y+ Get next routine offset
 cmpb #$80 End of table code?
 bne SETS10 Branch if not
 rts
 page

 ifeq CPUTyp-GIMIX
*
* Dynamic Address Translator Initialization
*
DATINT clr $E231 Clear m58167 interrupts
 ldb #$F
 ldx #$0000
DAT10 stb ,-X Init dat register
 decb Next Dat mask
 bpl DAT10 branch if more
 lbra COLD
 endc

 emod
OS9End equ *
 page
*****
*
* Interrupt Vector Package
*
* Generate Rtses to $FFE0
*
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D0
 fcc /9999999999999999/
 endc
 ifle *-$7D8
 fcc /99999999/
 endc
 ifle *-$7DC
 fcc /9999/
 endc
 ifle *-$7DE
 fcc /99/
 endc
 ifle *-$7DF
 fcc /9/
 endc

*
* Os-9 System Entries
*
 fdb TICK+$FFE0-* Clock tick handler
SYSVEC fdb SWI3HN+$FFE2-* Swi3 handler
 fdb SWI2HN+$FFE4-* Swi2 handler
 fdb FIRQHN+$FFE6-* Fast irq handler
 fdb IRQHN+$FFE8-* Irq handler
 fdb SWIHN+$FFEA-* Swi handler
 fdb NMIHN+$FFEC-* Nmi handler
 fdb 0 Reserved
* Actual Vector Entries
 fdb 0 Reserved
 fdb SWI3RQ+$FFF2-* Swi3
 fdb SWI2RQ+$FFF4-* Swi2
 fdb FIRQ+$FFF6-* Firq
 fdb IRQ+$FFF8-* Irq
 fdb SWIRQ+$FFFA-* Swi
 fdb NMI+$FFFC-* Nmi

 ifeq (CPUTYP-MM19)*(CPUTYP-PERCOM)*(CPUTYP-CMS9609)*(CPUTYP-EXORSR)*(CPUTYP-EXRSET)*(CPUTYP-PCU09)
 fdb COLD+$FFFE-* Restart
 else
 fdb DATINT+$FFFE-* Dynamic address translator initialization
 endc

ROMEnd equ *


 end
