 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

 use defsfile

*****
*
*  Module Header
*
Revs set REENT+8
 mod OS9End,OS9Nam,SYSTM,Revs,COLD,0

OS9Nam fcs /OS9p1/
 fcb 16 Edition number

LORAM set $100
HIRAM set $2000  One block

COLD ldx #LORAM Set ptr
 ldy #HIRAM-LORAM Set byte count
 clra CLEAR D
 clrb
COLD05 std ,X++ Clear two bytes
 leay -2,Y Count down
 bne COLD05
 inca ONE Page for direct page
 std D.Tasks
 addb #DAT.TkCt
 std D.TskIPt Task image Pointer table
 clrb
 inca
 std D.BlkMap
 addd  #DAT.BMSz  64   Allocate 64 bytes for block map
 std D.BlkMap+2
 clrb
 inca
 std D.SysDis
 inca
 std D.UsrDis
 inca Allocate 256 bytes for process descriptor block 
 std D.PrcDBT
 inca Allocate 256 bytes for system process descriptor
 std D.SysPrc
 std D.Proc
 adda #2
 tfr d,s
 inca
 std D.SysStk
 std D.SysMem
 inca
 std D.ModDir
 std D.ModEnd
 adda #6
 std D.ModDir+2
 std D.ModDAT
 std D.CCMem
 ldd #HIRAM
 std D.CCStk
 leax >IntXfr,pcr
 tfr X,D
 ldx #D.SWI3
COLD06 std ,x++
 cmpx #D.NMI
 bls COLD06
 leax ROMEnd,PCR get vector offset
 pshs X save it
 leay SYSVEC,PCR Get interrupt entries
 ldx #D.Clock
COLD08 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.XNMI end of dp vectors?
 bls COLD08 branch if not
 leas 2,S return scratch
 ldx D.XSWI2
 stx D.UsrSvc
 ldx D.XIRQ
 stx D.UsrIRQ
 leax SysSvc,PCR Get system service routine
 stx D.SysSVC
 stx D.XSWI2 Set service to system state
 leax SYSIRQ,PCR Get system interrupt routine
 stx D.SysIRQ
 stx D.XIRQ
 leax GoPoll,pcr
 stx D.SvcIRQ Set interrupts to system state
 leax IOPOLL,PCR Set irq polling routine
 stx D.POLL
         leax  >UPDG10,pcr
         stx   D.AltIRQ
         leax  >L0E69,pcr
         stx   D.Flip0
         leax  >L0E7D,pcr
         stx   D.Flip1
*
* Initialize Service Routine Dispatch Table
*
 leay SVCTBL,PCR Get ptr to service routine table
 lbsr SETSVC Set service table entries
 ldu D.PrcDBT
 ldx D.SysPrc
 stx ,u
 stx 1,u
 lda #1   Process id 1
 sta P$ID,x
 lda #SysState
 sta P$State,x
 lda #SysTask
 sta D.SysTsk
 sta P$Task,x
 lda #$FF
 sta P$Prior,x
 sta P$Age,x
 leax P$DATImg,x
 stx D.SysDAT set system DAT image ptr
*
* Set up memory blocks in system DAT image
*
 clra
 clrb
 std ,X++ use block zero for system
         ldy   #$0006        Dat.BlCt-ROMCount-RAMCount
 ldd #DAT.Free get free block code
Cold16 std ,X++ mark free entry
 leay -1,Y count block
 bne Cold16 branch if more
         ldd   #ROMBlock
         std   ,x++
 ldx D.Tasks get task number table
 inc 0,X claim system task
         inc   1,x
 ldx D.SysMem get system memory map ptr
         ldb   D.CCStk
Cold17 inc ,X+ claim page
 decb count it
 bne Cold17 branch if more
*
*      build Memory Block Map
*
         clr   D.MemSz
         ldd   #$0313
         std   >DAT.Regs+5
         ldx   #$A000
         ldd   #$DC78
         std   ,x
         cmpd  >HIRAM,x
         beq   COLD18
         inc   D.MemSz
COLD18    ldy   #HIRAM
         ldx   D.BlkMap
Cold20    pshs  x
         ldd   ,s
 subd D.BlkMap get block number
         cmpb  #$3F   IOBlock?
         bne   COLD22
         ldb   #$01
         bra   COLD28
COLD22    lda   D.MemSz
         bne   COLD23
         cmpb  #$0F
         bcc   COLD25
COLD23    stb   >$FFA1   DAT.Regs+1
 ldu 0,y get current contents
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD25 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD25 If not, eor
 stu 0,y Replace current value
 bra COLD30

COLD25    ldb   #NotRAM
COLD28    stb   [,s]
COLD30    puls  x
 leax 1,X next Block Map entry
 cmpx D.BlkMap+2 end of map?
 bcs Cold20 branch if not
*
*      search Not-Ram, excluding I/O, for modules
*
 ldx D.BlkMap
 inc 0,X claim block zero for system
 ldx D.BlkMap+2
         leax  >-1,x
         tfr   x,d
         subd  D.BlkMap
         leas  -16,s
         leay  ,s
         lbsr  MovDAT
         pshs  x
         ldx   #$0D00
COLD40    pshs  y,x
         lbsr  AdjImg
         ldb   1,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
 puls y,x retrieve ptrs
 cmpa #$87 could be module?
 bne Cold70 branch if not
Cold62 lbsr ValMod validate module
 bcc Cold65 branch if successful
 cmpb #E$KwnMod known module?
 bne Cold70 branch if not
Cold65 ldd #M$Size get module size offset
 lbsr LDDDXY
 leax D,X move ptr
 bra Cold75
Cold70 leax 1,X move ptr
Cold75    cmpx  #$1E00  DAT.Addr?
         bcs   COLD40
         bsr   L01D2
Cold.z1 leax InitName,pcr Get initial module name ptr
 bsr LinkSys Link to configuration module
 bcc Cold.z2
 os9 F$Boot
 bcc Cold.z1
 bra ColdErr

Cold.z2 stu D.Init
Cold.z3 leax P2Name,pcr
 bsr LinkSys
 bcc Cold.xit
 os9 F$Boot
 bcc Cold.z3
ColdErr jmp D.Crash

Cold.xit    jmp 0,Y Let os9 part two finish

L01D2    ldx   D.SysMem
         leax  >$00ED,x
         lda   #$80
         sta   <$12,x
         ldb   #$12
L01DF    lda   #$01
L01E1    sta   ,x+
         decb
         bne   L01E1
         ldx   D.BlkMap+2
         sta   -1,x
         rts

LinkSys lda #SYSTM Get system type module
 os9 F$Link
 rts


************************************************************
*
*       Subroutine MovDAT
*
*   Make temporary image of of DAT-Block Addr
*
*  Input: D = DAT image offset
*         Y = ptr to DAT temp area
*
* Output: DAT image moved to temp area
*
*   Data: D.TmpDAT
*
*  Calls: None
*
MovDAT pshs Y,X,D
 ldb #DAT.BlCt  blocks/address space
 ldx 0,S
COLD95 stx ,y++
 leax 1,X
 decb
 bne COLD95
 puls PC,Y,X,D

 page
*****
*
* System Service Routine Table
*
SVCTBL equ *
 fcb F$Link
 fdb LINK-*-2
 fcb F$PrsNam
 fdb PNAM-*-2
 fcb F$CmpNam
 fdb CMPNAM-*-2
 fcb F$CmpNam+$80
 fdb SCMPNAM-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+$80
 fdb SRQMEM-*-2
 fcb F$SRtMem+$80
 fdb SRTMEM-*-2
 fcb F$AProc+$80
 fdb APROC-*-2
 fcb F$NProc+$80
 fdb NPROC-*-2
 fcb F$VModul+$80
 fdb VModule-*-2
 fcb F$SSVC
 fdb SSVC-*-2
 fcb F$SLink+$80
 fdb SLINK-*-2
 fcb F$Boot+$80
 fdb BOOT-*-2
 fcb F$BtMem+$80
 fdb SRQMEM-*-2
 fcb F$Move+$80
 fdb MOVE-*-2
 fcb F$AllRAM
 fdb ALLRAM-*-2
 fcb F$AllImg+$80
 fdb ALLIMG-*-2
 fcb F$SetImg+$80
 fdb SETIMG-*-2
 fcb F$FreeLB+$80
 fdb FREELB-*-2
 fcb F$FreeHB+$80
 fdb FREEHB-*-2
 fcb F$AllTsk+$80
 fdb ALLTSK-*-2
 fcb F$DelTsk+$80
 fdb DELTSK-*-2
 fcb F$SetTsk+$80
 fdb SETTSK-*-2
 fcb F$ResTsk+$80
 fdb RESTSK-*-2
 fcb F$RelTsk+$80
 fdb RELTSK-*-2
 fcb F$DATLog+$80
 fdb DATLOG-*-2
 fcb F$LDAXY+$80
 fdb F.LDAXY-*-2
 fcb F$LDDDXY+$80
 fdb F.LDDDXY-*-2
 fcb F$LDABX+$80
 fdb F.LDABX-*-2
 fcb F$STABX+$80
 fdb F.STABX-*-2
 fcb F$ELink+$80
 fdb ELINK-*-2
 fcb F$FModul+$80
 fdb FMODUL-*-2

 ifeq CPUType-COLOR3
 fcb F$AlHRam+$80
 fdb ALHRAM-*-2
 endc

 fcb $80

************************************************************
*
*     Module Names
*
InitName fcs "Init"
P2Name fcs "OS9p2"
BootName fcs "Boot"



 ttl System Service Request Routines
 pag
************************************************************
*
*     Interrupt Transfer
*
IntXfr jmp [-16,x] transfer to interrupt routine



************************************************************
*
*     User State Interrupt Routines
*
*   Checks for user defined routine; uses system if none
*
* Data: D.Proc
*
* Calls: UserSvc
*
UserSWI3 ldx D.Proc get current process ptr
 ldu P$SWI3,X get user interrupt routine
 beq UserSvc branch if none
UsrSWI10 lbra PassSWI

UserSWI2 ldx D.Proc get current process ptr
 ldu P$SWI2,X get user interrupt routine
 beq UserSvc branch if none
 bra UsrSWI10

UserSWI ldx D.Proc get current process ptr
 ldu P$SWI,X get SWI routine
 bne UsrSWI10 branch if set
*
*     fall through to UserSvc
*
 page
************************************************************
*
*     User Service Request Routine
*
*   Process User service requests
*
* Input: X = Process descriptor ptr
*        S = value of stack after interrupt
*
* Output: none
*
* Data: D.SysSvc, D.SWI2, D.SysIRQ, D.IRQ, D.Proc, D.UsrDis
*
* Calls: GetRegs, PutRegs, LDBBX, Dispatch, UserRet
*
UserSvc ldd D.SysSvc get system SWI2 service routine
 std D.XSWI2 set SWI2 entry
 ldd D.SysIRQ get system IRQ service routine
 std D.XIRQ set IRQ entry
 lda P$State,X get state flag
 ora #SysState set system state
 sta P$State,X update state
 sts P$SP,X save stack ptr
 leas (P$Stack-R$Size),X move to local stack
 andcc #^IntMasks clear interrupt masks
 leau 0,s get system stack ptr
 bsr GetRegs get user stack
 ldb P$Task,X get process task number
 ldx R$PC,u get program counter
 lbsr LDBBX get service request code
 leax 1,X move PC past code
 stx R$PC,u update program counter
 ldy D.UsrDis get user dispatch table ptr
 lbsr Dispatch dispatch to service routine
 ldb R$CC,u get user condition codes
 andb #^IntMasks clear interrupt masks
 stb R$CC,u update condition codes
 ldx D.Proc get process ptr
 bsr PutRegs return user stack
 lda P$State,X get process state flags
 anda #^SysState clear system state
 lbra UsrRet.a
 page
************************************************************
*
*     Subroutine GetRegs
*
*   Copy User interrupt register stack
*
* Input: X = Process Descriptor ptr
*        U = local stack ptr
*
* Output: none
*
* Data: none
*
* Calls: MoveRegs
*
GetRegs    pshs  u,y,x,cc
         ldb   $06,x
 ldx P$SP,X get process stack ptr
         lbsr  L0BF5
         leax  >-$6000,x
         bra   L02E9




************************************************************
*
*     Subroutine PutRegs
*
*   Copy User interrupt register stack
*
* Input: X = Process Descriptor ptr
*        U = local stack ptr
*
* Output: none
*
* Data: none
*
* Calls: MoveRegs
*
PutRegs    pshs  u,y,x,cc
         ldb P$Task,X get process task
         ldx   $04,x
         lbsr  L0BF5
         leax  >-$6000,x
         exg   x,u
L02E9    pshs  u
         lbsr  L0C09
         leau  a,u
         leau  1,u
         lda   ,u++
         ldb   ,u
         ldu   #DAT.Regs+5
         orcc  #IntMasks
         std   ,u
         puls  u
 ldy #R$Size get byte count
L0303    ldd   ,x++
         std   ,u++
         leay  -$02,y
         bne   L0303
         ldx   D.SysDat
         lda   $0B,x
         ldb   $0D,x
         std   >DAT.Regs+5
         puls  pc,u,y,x,cc
 page
************************************************************
*
*     System Service Request Routine
*
*   Process system service requests
*
* Input: S = value of stack after interrupt
*
* Output: none
*
* Data: D.SysDis, D.SysPrc
*
* Calls: Dispatch, SvcRet
*
SysSvc leau 0,S Copy stack ptr
         lda   D.SSTskN
         clr   D.SSTskN
         pshs  a
 lda R$CC,u get caller's interrupt masks
 tfr a,cc restore interrupt masks
 ldx R$PC,u get program counter
         ldb   ,s
         beq   SysSvc10
         lbsr  LDBBX
         leax  1,x
         bra   SysSvc20

SysSvc10 ldb ,X+ Get service code
SysSvc20 stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr Dispatch Call service routine
 lbra SYSRET

Dispatch aslb SHIFT For two byte table entries
 bcc Dispat10 Branch if not i/o
 rorb RE-ADJUST Byte
 ldx IOEntry,y Get i/o routine
 bra Dispat20
Dispat10 clra
 ldx D,Y Get routine address
 bne Dispat20 Branch is not null
 comb SET Carry
 ldb #E$UnkSvc Unknown service code
 bra Dispat30
Dispat20 pshs u Save register ptr
 jsr 0,X Call routine
 puls u Retrieve register ptr
*
* Return Condition Codes To Caller
*
Dispat30 tfr cc,a Copy condition codes
 bcc Dispat40
 stb R$B,u
Dispat40 ldb R$CC,U Get condition codes
 andb #$D0 Clear h, n, z, v, c
 stb R$CC,U Save it
 anda #$2F Clear e, f, i
 ora R$CC,U Return conditions
 sta R$CC,U
 rts
 page
************************************************************
*
*     Subroutine SSvc
*
*   Set Service Routine Table entry Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Call: SetSvc
*
SSVC ldy R$Y,U Get table address
 bra SETSVC

SetSvc10 clra
 lslb
 tfr D,U copy routine offset
 ldd ,Y++ Get table relative offset
 leax D,Y Get routine address
 ldd D.SysDis
 stx D,U Put in system routine table
 bcs SETSVC Branch if system only
 ldd D.UsrDis
 stx D,U Put in user routine table
SETSVC ldb ,Y+ Get next routine offset
 cmpb #$80 End of table code?
 bne SetSvc10 Branch if not
 rts
 page

*****
* System link
* Input: A = Module type
*        X = Module string pointer
*        Y = Name string DAT image pointer
SLINK ldy R$Y,U
 bra SysLink

*****
* Link using module directory entry
*
* Input: B = Module type
*        X = Pointer to module directory entry
ELINK pshs  U
 ldb R$B,U
 ldx R$X,u Get name ptr
 bra EntLink

*****
*
*  Subroutine Link
*
* Search Module Directory & Return Module Address
*
* Input: U = Register Package
* Output: Cc = Carry Set If Not Found
* Local: None
* Global: D.ModDir
*
LINK ldx D.Proc
 leay P$DATImg,X
SysLink pshs U Save register package
 ldx R$X,U Get name ptr
 lda R$A,u Get module type
 lbsr FModule
 lbcs LinkErr
 leay 0,U Make copy
 ldu 0,s Get register ptr
 stx R$X,U
 std R$D,U
 leax 0,Y
EntLink bitb #REENT is this sharable
 bne Link10 branch if so
 ldd MD$Link,x  Check for links
 beq Link10 .. none
 ldb #E$ModBsy err: module busy
 bra LinkErr
Link10 ldd MD$MPtr,X  Module ptr
 pshs X,D
 ldy MD$MPDAT,x   Module DAT Image ptr
 ldd MD$MBSiz,x  Memory Block size
 addd  #DAT.BlSz-1
 tfr A,B
 lsrb
 lsrb
 lsrb
 lsrb
 ifge DAT.BlSz-$2000
 lsrb Divide by 32 for 8K blocks
 endc
         adda #2
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
 lsra Divide by 32 for 8K blocks
 endc
 pshs a save adjusted count
 leau 0,Y copy group DAT image ptr
 bsr SrchPDAT is group mapped in?
 bcc Link30 branch if so
 lda 0,s get adjusted count
 lbsr FreeHB10 is there room to map?
 bcc Link20 branch if so
 leas 5,s clean stack
 bra LinkErr
Link20 lbsr SetImage set process DAT image
Link30 leax P$Links,X get link count table ptr
 sta 0,s save block number
 asla make table offset
 leau A,X get link ptr
 ldx 0,u get link count
 leax 1,X count link
 beq Link40 branch if overflow
 stx 0,u update link count
Link40 ldu 3,s get entry ptr
 ldx MD$Link,u get link count
 leax 1,X count use
 beq Link50 branch if overflow
 stx MD$Link,u update link count
Link50 puls U,Y,X,B retrieve offset, entry, & registers
 lbsr DATtoLog convert to logical
 stx R$U,u return to user
 ldx MD$MPtr,Y get module ptr
 ldy MD$MPDAT,Y get DAT image ptr
 ldd #M$EXEC get module execution offset
 lbsr LDDDXY get module execution offset
 addd R$U,u make execution logical address
 std R$Y,u return to user
 clrb clear carry
 rts

LinkErr orcc #Carry set carry
 puls PC,u
 page
***********************************************************
*
*     Subroutine SrchPDAT
*
*
* Input: B = Number of blocks
*        U = Module DAT Image ptr
*
* Output: A = beginning block number, if found
*         Y = Process DAT image ptr
*
* Data: none
*
* Calls: SrchDAT
*
SrchPDAT ldx D.Proc get process ptr
 leay P$DATImg,X get process DAT image ptr
*
*     fall through to SrchDAT
*
***********************************************************
*
*     Subroutine SrchDAT
*
*   Search DAT image for specified blocks
*
* Input: B = block count
*        Y = search DAT image ptr
*        U = target DAT image ptr
*
* Output: A = beginning block number, if found
*
* Data: none
*
* Calls: none
*
SrchDAT clra clear MSB count
         pshs  y,x,b,a
         subb  #DAT.BlCt
         negb
         lslb
         leay  b,y
SrchD10    ldx   ,s
         pshs  u,y
SrchD20    ldd   ,y++
         cmpd  ,u++
         bne   SrchD30
         leax  -1,x
         bne   SrchD20
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a
SrchD30    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   SrchD10
         puls  pc,y,x,b,a

***********************************************************
*
*     Subroutine VModule
*
*   Module Validation Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear if successful; set if not
*
* Data: none
*
* Calls: ValMod
*
VModule pshs U Save register ptr
 ldx R$X,U Get new module ptr
 ldy R$D,u
 bsr ValMod Validate module
 ldx 0,s  Retrieve register ptr
 stu R$U,x Return directory entry
 puls pc,u




***********************************************************
*
*     Subroutine ValMod
*
*   Validate Module and update Module Directory
*
* Input: X = Module Block offset
*        Y = Module DAT Image ptr
*
* Output: D destroyed
*         U = Directory Entry
*         Carry clear if successful; set if not
*
* Data: none
*
* Calls: ModCheck, LDDDXY, AdjImg, FModule, DATtoLog
*
ValMod pshs Y,X save new module ptr
 lbsr ModCheck is it good module?
 bcs ValMoErr branch if not
 ldd #M$Type get module type offset
 lbsr LDDDXY
 andb #Revsmask
 pshs D
 ldd #M$Name
 lbsr LDDDXY
 leax d,x
 puls a
 lbsr FModule
 puls a
 bcs ValMod20
 pshs a
 andb #Revsmask
 subb ,s+
 bcs ValMod20
 ldb #E$KwnMod
 bra ValMoErr
VMOD10 ldb #E$DirFul Err: directory full
ValMoErr orcc #CARRY SET Carry
 puls pc,y,x

ValMod20    ldx   ,s
         lbsr  SetMoImg
         bcs   VMOD10
         sty   ,u
         stx   R$X,u
         clra
         clrb
         std   R$Y,u
         ldd   #$0002
         lbsr  LDDDXY
         pshs  x
         addd  ,s++
         std   $02,u
         ldy   [,u]
         ldx   D.ModDir
         pshs  u
         bra   ValMod35
ValMod30    leax  $08,x
ValMod35    cmpx  D.ModEnd
         bcc   ValMod55
         cmpx  ,s
         beq   ValMod30
         cmpy  [,x]
         bne   ValMod30
         bsr   FreDATI
ValMod55    puls  u
         ldx   D.BlkMap
         ldd   $02,u
         addd  #DAT.BlSz-1
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         ldy   ,u
ValMod60    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02
         stb   ,x
         puls  x,a
         deca
         bne   ValMod60
         clrb
         puls  pc,y,x

FreDATI    pshs  u,y,x,b,a
         ldx   ,x
         pshs  x
         clra
         clrb
Fre.Lp    ldy   ,x
         beq   L0503
         std   ,x++
         bra   Fre.Lp
L0503    puls  x
         ldy   $02,s
         ldu   ,u
         puls  b,a
L050C    cmpx  ,y
         bne   L051B
         stu   ,y
         cmpd  $02,y
         bcc   L0519
         ldd   $02,y
L0519    std   $02,y
L051B    leay  MD$ESize,Y
         cmpy  D.ModEnd
         bne   L050C
         puls  pc,u,y,x

SetMoImg    pshs  u,y,x
         ldd   #$0002
         lbsr  LDDDXY
         addd  ,s
         addd  #DAT.BlSz-1
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         tfr   a,b
         pshs  b
         incb
         lslb
         negb
         sex
         bsr   chkspce
         bcc   SetI.out
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   chkspce
SetI.out    puls  pc,u,y,x,b

chkspce    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   L0583
         ldu   $07,s
         bne   L056E
         pshs  x
         ldy   D.ModEnd
         leay  MD$ESize,Y
         cmpy  ,s++
         bhi   L0583
         sty   D.ModEnd
         leay  -MD$ESize,Y
         sty   $07,s
L056E    stx   D.ModDAT
         ldy   $05,s
         ldb   $02,s
         stx   $05,s
L0577    ldu   ,y++
         stu   ,x++
         decb
         bne   L0577
         clr   ,x
         clr   1,x
         rts
L0583    orcc  #$01
         rts

ModCheck pshs Y,X
 clra
 clrb
 lbsr LDDDXY Get first two bytes
 cmpd #M$ID12 Check them
 beq PARITY
 ldb #E$BMID Err: illegal id block
 bra CRCC20 exit
PARITY leas -1,s  Save space on stack
 leax 2,X
 lbsr AdjImg Go to next DAT block?
 ldb #M$IDSize-2
 lda #$4A  M$ID1^M$ID2
PARI10 sta 0,S
 lbsr LDAXYP
 eora 0,S Add parity of next byte
 decb Done?
 bne PARI10 Branch if not
 leas 1,s Reset stack
 inca Add 1 to expected $FF
 beq CRCCHK Parity good?
 ldb #E$BMHP
 bra CRCC20



*****
*
*  Subroutine Crcchk
*
* Check Module Crc
*
CRCCHK puls Y,X
 ldd #M$Size Get module size
 lbsr LDDDXY
 pshs Y,X,D
 ldd #$FFFF
 pshs D Init crc register
 pshs B Init crc register
 lbsr AdjImg
 leau 0,S Get crc register ptr
CRCC05 tstb
 bne CRCC10
 pshs x
 ldx #1
 os9 F$Sleep
 puls x
CRCC10 lbsr LDAXYP Get next byte
 bsr CRCCAL Calculate crc
 ldd 3,S
 subd #1 count byte
 std 3,S
 bne CRCC05
 puls y,x,b
 cmpb #CRCCon1 Is it good?
 bne CRCC15 Branch if not
 cmpx #CRCCon23 Is it good?
 beq CRCC30 Branch if so
CRCC15 ldb #E$BMCRC Err: bad crc
CRCC20 orcc #CARRY SET Carry
CRCC30 puls X,Y,PC


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
*  Subroutine Crcgen
*
* Generate Crc
*
CRCGen ldd R$Y,u get byte count
 beq CRCGen20 branch if none
 ldx R$X,u get data ptr
 pshs X,D
 leas -3,S
 ldx D.Proc
 lda P$Task,X
 ldb D.SysTsk
 ldx R$U,u get crc ptr
 ldy #3
 leau 0,S
 pshs Y,X,D
 lbsr Mover
 ldx D.Proc
 leay P$DATImg,X
 ldx 11,S
 lbsr AdjImg
CRCGen10 lbsr LDAXYP get next data byte
 lbsr CRCCAL update crc
 ldd 9,S
 subd #1 count byte
 std 9,S
 bne CRCGen10 branch if more
 puls Y,X,D
 exg A,B
 exg X,U
 lbsr Mover
 leas 7,S
CRCGen20 clrb clear carry
 rts

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
* Global: D.ModDir

FMODUL pshs u
 lda R$A,u
 ldx R$X,u
 ldy R$Y,u
 bsr FModule
 puls y
 std R$D,y
 stx R$X,y
 stu R$U,y
 rts

FModule ldu #0 Return zero if not found
 pshs u,d
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr F.PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModEnd Get module directory ptr
 bra FMOD33 Test if end is reached
FMOD10 pshs y,x,d
 pshs y,x
 ldy 0,u Get module ptr
 beq FMOD20 Branch if not used
 ldx M$NAME,U Get name offset
 pshs y,x
 ldd #M$NAME Get name offset
 lbsr LDDDXY
 leax d,x Get name ptr
 pshs y,x
 leax 8,s
 ldb 13,s
 leay 0,s
 lbsr F.CHKNAM Compare names
 leas 4,s
 puls y,x
 leas 4,s
 bcs FMOD30
 ldd #M$Type Get desired language
 lbsr LDDDXY
 sta 0,s
 stb 7,s
 lda 6,S Get desired type
 beq FMOD16 Branch if any
 anda #TypeMask
 beq FMOD14 Branch if any
 eora 0,S Get type difference
 anda #TypeMask
 bne FMOD30 Branch if different
FMOD14 lda 6,S Get desired language
 anda #LangMask
 beq FMOD16 Branch if any
 eora ,S
 anda #LangMask
 bne FMOD30 Branch if different
FMOD16 puls Y,X,D Retrieve registers
 abx
 clrb
 ldb 1,S
 leas 4,S
 rts
FMOD20 leas  4,S
 ldd 8,s Free entry found?
 bne FMOD30 Branch if so
 stu 8,S
FMOD30 puls Y,X,D Retrieve registers
FMOD33    leau  -MD$ESize,U Move to previous entry
         cmpu  D.ModDir
         bcc   FMOD10
 ldb #E$MNF
 bra FMOD40
FMOD35 comb SET Carry
 ldb #E$BNam
FMOD40 stb 1,S Save B on stack
 puls D,U,PC

* Skip spaces
SKIPSP pshs y
SKIP10 lbsr AdjImg
 lbsr LDAXY Get byte from other DAT
 leax 1,x move forward
 cmpa #'  compare with space
 beq SKIP10
 leax -1,x Get not space
 pshs a
 tfr Y,D
 subd 1,S
 asrb
 lbsr DATtoLog
 puls pc,y,a

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
PNAM ldx D.Proc
 leay P$DATImg,X
 ldx R$X,u Get string ptr
 bsr F.PRSNAM Call parse name
 std R$D,U Return byte & size
 bcs PNam.x branch if error
 stx R$X,U Return updated string ptr
 abx
PNam.x stx R$Y,U Return name end ptr
 rts

F.PRSNAM pshs y
 lbsr AdjImg
 pshs Y,X
 lbsr LDAXYP Get first char
 cmpa #'/ Slash?
 bne PRSNA1 ..no
 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PRSNA1 bsr ALPHA 1st character must be alphabetic
 bcs PRSNA4 Branch if bad name
 clrb
PRSNA2 incb INCREMENT Character count
 tsta End of name (high bit set)?
 bmi PRSNA3 ..yes; quit
 lbsr LDAXYP
 bsr ALFNUM Alphanumeric?
 bcc PRSNA2 ..yes; count it
PRSNA3 andcc #^CARRY clear carry
 bra PRSNA10
PRSNA4 cmpa #', Comma (skip if so)?
 bne PRSNA6 ..no
PRSNA5 leas 4,S
 pshs Y,X
 lbsr LDAXYP
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 comb (NAME Not found)
 ldb #E$BNam 
PRSNA10 puls Y,X
 pshs d,cc
 tfr Y,D
 subd 3,S
 asrb
 lbsr DATtoLog
 puls PC,Y,D,CC

* Check For Alphanumeric Character
*
* Passed:  (A)=Char
* Returns:  Cc=Set If Not Alphanumeric
* Destroys None
*
ALFNUM pshs a
 anda #$7F
 cmpa #'. period?
 beq RETCC branch if so
 cmpa #'0 Below zero?
 blo RETCS ..yes; return carry set
 cmpa #'9 Numeric?
 bls RETCC ..yes
 cmpa #'_ Underscore?
 bne ALPHA10
RETCC clra
 puls  pc,a

ALPHA pshs a
 anda #$7F Strip high order bit
ALPHA10 cmpa #'A
 blo RETCS
 cmpa #'Z Upper case alphabetic?
 bls RETCC ..yes
 cmpa #$61 Below lower case a?
 blo RETCS ..yes
 cmpa #$7A Lower case?
 bls RETCC ..yes
RETCS coma Set carry
 puls  pc,a

* Compare Pathname With Module Name
*
* Passed:  (X)=Pathname
*          (Y)=Module Name (High Bit Set Delim)
*          (B)=Length Of Pathname
* Returns:  Cc=Set If Names Not Equal
*
CMPNAM ldx D.Proc
 leay P$DATImg,X
 ldx R$X,U
 pshs  Y,X
 bra F.CMPNAM

SCMPNAM ldx D.Proc
 leay P$DATImg,X
 ldx R$X,U
 pshs Y,X
 ldy D.SysDAT
F.CMPNAM ldx R$Y,u Get module name
 pshs Y,X
 ldd R$D,U
 leax 4,S
 leay 0,S
 bsr F.CHKNAM
 leas 8,S
 rts

F.CHKNAM pshs U,Y,X,D Save registers
 ldu 2,S
 pulu Y,X
 lbsr AdjImg
 pshu Y,X
 ldu 4,S
 pulu Y,X
 lbsr AdjImg
 bra CHKN15

CHKN10 ldu 4,S
 pulu Y,X
CHKN15 lbsr LDAXYP
 pshu Y,X
 pshs a
 ldu 3,S
 pulu Y,X
 lbsr LDAXYP
 pshu Y,X
 eora 0,S
 tst ,s+
 bmi CHKN20 Branch if last module char
 decb DECREMENT Char count
 beq RETCS1 Branch if last character
 anda #$FF-$20 Match upper/lower case
 beq CHKN10 ..yes; repeat
RETCS1 comb Set carry
 puls  PC,U,Y,X,D

CHKN20 decb
 bne RETCS1 LAST Char of pathname?
 anda #$FF-$A0 Match upper/lower & high order bit
 bne RETCS1 ..no; return carry set
 clrb
 puls  pc,u,Y,X,D

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
 ldy D.SysMem
 leas -2,S
 stb 0,S
SRQM10 ldx D.SysDAT
 lslb
 ldd B,X
 cmpd  #DAT.Free
         beq   SRQM15
         ldx   D.BlkMap
         lda   d,x
         cmpa  #$01
         bne   SRQM20
         leay  DAT.TkCt,y
         bra   SRQM30
SRQM15    clra
SRQM20    ldb   #DAT.TkCt
SRQM25    sta   ,y+
         decb
         bne   SRQM25
SRQM30    inc   ,s
         ldb   ,s
         cmpb  #DAT.BlCt
         bcs   SRQM10
SRQM40    ldb   1,u
SRQM45    cmpy  D.SysMem
         bhi   SRQM50
         comb
         ldb   #E$NoRAM
         bra   SRQMXX
SRQM50    lda   ,-y
         bne   SRQM40
         decb
         bne   SRQM45
         sty   ,s
         lda   1,s
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         ldb   1,s
         andb  #(DAT.BlSz/256)-1
         addb  1,u
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
 ldx D.SysPrc
 lbsr F.ALLIMG
 bcs SRQMXX
 ldb R$A,U Get page count
SRQM60 inc ,y+
 decb
 bne SRQM60
 lda 1,S
 std R$U,U Return ptr to memory
 clrb
SRQMXX leas 2,S
 rts

 page
*****
*
*  Subroutine Srtmem
*
* System Memory Return
*
SRTMEM ldd R$D,U Get byte count
 beq SRTMXX  Branch if returning nothing
 addd #$FF Round up to page
 ldb R$U+1,u IS Address good?
 beq SRTM10 Branch if so
 comb
 ldb #E$BPAddr
 rts

SRTM10 ldb R$U,U
 beq SRTMXX Branch if returning nothing
 ldx D.SysMem
 abx
SRTM20 ldb 0,X
         andb  #$FE   #^RAMinUse
         stb   ,x+
         deca
         bne   SRTM20
         ldx   D.SysDat
         ldy   #DAT.BlCt
SRTM30    ldd   ,x
         cmpd  #DAT.Free
         beq   SRTM50
         ldu   D.BlkMap
         lda   d,u
         cmpa  #$01   #RAMinUse
         bne   SRTM50
         tfr   x,d
         subd  D.SysDat
         lslb
         lslb
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #DAT.TkCt
SRTM40    lda   ,u+
         bne   SRTM50
         decb
         bne   SRTM40
         ldd   ,x
         ldu   D.BlkMap
         clr   d,u
         ldd   #DAT.Free
         std   ,x
SRTM50    leax  $02,x
         leay  -1,y
         bne   SRTM30
SRTMXX    clrb
         rts

BOOT comb set carry
 lda D.Boot
 bne BOOTXX Don't boot if already tried
 inc D.Boot
 ldx D.Init
 beq BOOT05 No init module
 ldd BootStr,X
 beq BOOT05 No boot string in init module
 leax d,x Get name ptr
 bra BOOT06
BOOT05 leax  BootName,pcr
BOOT06 lda #SYSTM+OBJCT get type
 OS9 F$LINK find bootstrap module
 bcs BOOTXX Can't boot without module
 jsr 0,Y Call boot entry
 bcs BOOTXX Boot failed
 std D.BtSz
 stx D.BtPtr
 leau d,x
 tfr x,d
 anda #DAT.Addr
 clrb
 pshs u,d
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
 ldy D.SysDAT
 leay a,y
BOOT10 ldd 0,X get module beginning
 cmpd #M$ID12 is it module sync code?
 bne BOOT20 branch if not
 tfr x,d
 subd 0,s
 tfr d,x
 tfr y,d
 OS9 F$VModul Validate module
 pshs b
 ldd 1,s
 leax d,x
 puls b
 bcc BOOT15
 cmpb #E$KwnMod
 bne BOOT20
BOOT15 ldd M$SIZE,X Get module size
 leax d,x
 bra BOOT30
BOOT20 leax 1,X Try next
BOOT30 cmpx 2,s End of boot?
 bcs BOOT10 Branch if not
 leas 4,s restore stack
         ldx   D.SysDat
         ldb   $0D,x
         incb
         ldx   D.BlkMap
         lbra  L01DF
BOOTXX rts

*****
*
* Allocate RAM blocks
*
ALLRAM   ldb   R$B,u
         bsr   ALRAM10
         bcs   ALRAM05
         std   R$D,u
ALRAM05    rts

ALRAM10    pshs  y,x,b,a
         ldx   D.BlkMap
L0974    leay  ,x
         ldb   1,s
L0978    cmpx  D.BlkMap+2
         bcc   ALRAMERR
         lda   ,x+
         bne   L0974
         decb
         bne   L0978
L0983    tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   1,s
         stb   1,s
L098D    inc   ,y+
         deca
         bne   L098D
         clrb
         puls  pc,y,x,b,a

ALRAMERR comb
 ldb #E$NoRam
 stb 1,S Save error code
 puls PC,Y,X,D

 ifeq CPUType-COLOR3
ALHRAM   ldb   R$B,u
         bsr   L09A5
         bcs   L09A4
         std   R$D,u
L09A4    rts

L09A5    pshs  y,x,b,a
         ldx   D.BlkMap+2
L09A9    ldb   1,s
L09AB    cmpx  D.BlkMap
         bls   ALRAMERR
         lda   ,-x
         bne   L09A9
         decb
         bne   L09AB
         tfr   x,y
         bra   L0983
 endc

*****
*
* Allocate image RAM blocks
*
ALLIMG ldd R$D,u  Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer
F.ALLIMG pshs u,y,x,d
         lsla
         leay  P$DATImg,x
         leay  a,y
         clra
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
L09CD    ldd   ,y++
         cmpd  #DAT.Free
         beq   L09E2
         lda   d,u
         cmpa  #$01   #RAMinUse
         puls  b,a
         bne   L09F7
         subd  #$0001
         pshs  b,a
L09E2    leax  -1,x
         bne   L09CD
         ldx   ,s++
         beq   L0A00
L09EA    lda   ,u+
         bne   L09F2
         leax  -1,x
         beq   L0A00
L09F2    cmpu  D.BlkMap+2
         bcs   L09EA
L09F7    ldb   #E$MemFul
         leas  $06,s
         stb   1,s
         comb
         puls  pc,u,y,x,b,a

L0A00    puls  u,y,x
L0A02    ldd   ,y++
         cmpd  #DAT.Free
         bne   L0A16
L0A0A    lda   ,u+
         bne   L0A0A
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         std   -$02,y
L0A16    leax  -1,x
         bne   L0A02
         ldx   $02,s
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         clrb
         puls  pc,u,y,x,b,a

*****
*
* Get free high block
*
FREEHB   ldb   R$B,u
         ldy   R$Y,u
         bsr   FRHB20
         bcs   FRHB10
         sta   R$A,u return beginning block number
FRHB10    rts

FRHB20    tfr   b,a
FreeHB10    suba  #$09  DAT.BlCt+1
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   FREEBLK

*****
* Get Free low block
*
FREELB   ldb   R$B,u
         ldy   R$Y,u
         bsr   FRLB20
         bcs   FRLB10
         sta   1,u
FRLB10    rts

FRLB20    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #DAT.BlCt+1
         negb
         pshs  b,a
         bra   FREEBLK

FREEBLK    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  1,s
         bne   FREBLK20
         ldb   #E$MemFul
         cmpy  D.SysDat
         bne   FREBLK05
         ldb   #E$NoRam
FREBLK05 stb   3,s Save error code
         comb
         bra   FREBLK30

FREBLK10 tfr A,B
 addb  2,s Add to current start block #
FREBLK20 lslb Multiply block # by 2
 ldx B,Y Get DAT marker for that block
 cmpx #DAT.Free Empty block?
 bne FREEBLK ..No, move to next block
 inca
 cmpa 3,S
 bne FREBLK10
FREBLK30 leas 2,s Reset stack
 puls PC,X,D Restore reg, error code & return

*****
*
*
*
SETIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
         ldu   R$U,u New image pointer
SetImage    pshs  u,y,x,b,a
         leay  <P$DATImg,x
         lsla
         leay  a,y
L0A94    ldx   ,u++
         stx   ,y++
         decb
         bne   L0A94
         ldx   $02,s
         lda   P$State,X
         ora   #ImgChg
         sta   P$State,X
         clrb
         puls  pc,u,y,x,b,a

*****
* Convert DAT block/offset to logical address
*
DATLOG ldb R$B,u  DAT image offset
 ldx R$X,u Block offset
 bsr DATtoLog
 stx R$X,u Return logical address
 clrb
 rts

* Convert offset into real address
* Input: B, X
* Effect: updated X
DATtoLog pshs X,D
 lslb
 lslb
 lslb
 lslb
 ifge DAT.BlSz-$2000
 lslb Divide by 32 for 8K blocks
 endc
 addb 2,S
 stb 2,S
 puls pc,X,D
 page
***********************************************************
*
*     Subroutine FLDAXY
*
*   Load A X, [Y] Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: LDAXY
*
F.LDAXY ldx R$X,u get block offset
 ldy R$Y,u DAT get DAT image ptr
 bsr LDAXY
 sta R$A,u return byte
 clrb
 rts


***********************************************************
*
*     Subroutine LDAXY
*
*   Load A register from X offset of Y block
*
* Input: X = Block offset
*        Y = DAT Image ptr
*
* Output: A = [X,Y]
*
* Data: none
*
* Calls: none
*
LDAXY pshs CC
 lda 1,Y
 orcc #IntMasks
 sta DAT.Regs
 lda 0,X
 clr DAT.Regs
 puls PC,CC

* Get byte and increment X
* Input: X - location
*        A - DAT image number
* Output: A - result
*
LDAXYP equ *
 ifge DAT.BlSz-4096
 lda 1,y get DAT block image
 pshs cc save masks
 orcc #IntMasks set interrupt masks
 sta DAT.Regs set block zero
 lda ,x+ get byte
 clr DAT.Regs reset block zero
 puls cc reset interrupt masks
 else
 jmp NOWHERE Code is not available
 endc
 bra AdjImg adjust image

AdjImg10 leax -DAT.BlSz,x reduce offset
 leay 2,y move image ptr
AdjImg cmpx #DAT.BlSz is offset in block range?
 bcc AdjImg10 branch if not
 rts
 page
***********************************************************
*
*     Subroutine FLDDDXY
*
*   Load D D+X,[Y]] Service routine
*
* Input: U = registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: LDDDXY
*
F.LDDDXY ldd R$D,u Offset to the offset within DAT image
 leau 4,U
 pulu Y,X
 bsr LDDDXY
 std -7,U
 clrb
 rts


***********************************************************
*
*     Subroutine LDDDXY
*
*   Load D register from X+D offset of Y block
*
* Input: D = Address offset
*        X = Block offset
*        Y = DAT Image ptr
*
* Output: D = [D+X,Y]
*
* Data: none
*
* Calls: AdjImg, LDAXYP, LDAXY
*
LDDDXY pshs Y,X save registers
 leax D,X add address offset
 bsr AdjImg
 bsr LDAXYP
 pshs a
 bsr LDAXY
 tfr a,b
 puls pc,y,x,a

 page
***********************************************************
*
*     Subroutine F.LDABX
*
*   Load A 0,X from address space B
*
* Input: U = registers ptrs
*
* Output: Carry clear
*
* Data: none
*
* Calls: LDABX
*
F.LDABX ldb R$B,u Task number
 ldx R$X,u Data pointer
 lbsr H.LDABX
 sta R$A,u
 rts

*****
* Store A at 0,X in task B
*
F.STABX ldd R$D,u
 ldx R$X,u
 lbra STABX
 page
***********************************************************
*
*     Subroutine Move
*
*   Move Data service routine
*
* Input: U = Registers ptr
*        R$A,u = Source Task number
*        R$B,u = Destination Task number
*        R$X,u = Source ptr
*        R$Y,u = Byte count
*        R$U,u = Destination ptr
*
* Output: carry clear
*
* Data: none
*
* Calls: Mover
*
Move ldd R$D,u get user D register
 ldx R$X,u get user X register
 ldy R$Y,u get user Y register
 ldu R$U,u get user U register
*
*     fall through to Mover
*
***********************************************************
*
*     Subroutine Mover
*
*   Move data from one task to another
*
* Input: A = Source Task number
*        B = Destination Task number
*        X = Source ptr
*        Y = Byte count
*        U = Destination ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: Mover00
*
Mover pshs U,Y,X,B,A
 leay 0,y How many bytes to move?
 lbeq MoveNone ..branch if zero
         pshs  y,b,a
         tfr   a,b
         lbsr  L0BF5
         lbsr  L0C09
         leay  a,u
         pshs  y,x
         ldb   $09,s
         ldx   $0E,s
         lbsr  L0BF5
         lbsr  L0C09
         leay  a,u
         pshs  y,x
         ldd   #DAT.BlSz get block size
         subd  ,s
         pshs  b,a
         ldd   #DAT.BlSz
         subd  $06,s
         pshs  b,a
         ldx   $08,s
         leax  >-$6000,x make X point to where we'll map block
         ldu   $04,s
         leau  >-$4000,u  make U point to where we'll map block
L0B6A    pshs  cc
         orcc  #IntMasks
         ldd   [<$07,s]
         pshs  b
         ldd   [<$0C,s]
         pshs  b
         ldd   <$11,s
         cmpd  $03,s
         bls   L0B82
         ldd   $03,s
L0B82    cmpd  $05,s
         bls   L0B89
         ldd   $05,s
L0B89    cmpd  #$0040
         bls   L0B92
         ldd   #$0040
L0B92    std   $0F,s
         lsra
         rorb
         tfr   d,y
         puls  b,a
         std   >DAT.Regs+5  map in the blocks
         bcc   L0BA7
         lda   ,x+
         sta   ,u+
         leay  ,y
         beq   L0BAF
L0BA7    ldd   ,x++
         std   ,u++
         leay  -1,y
         bne   L0BA7
L0BAF    ldy   D.SysDat
         ldd   $0A,y
         stb   >DAT.Regs+5
         ldd   $0C,y
         stb   >$FFA6  DAT.Regs+6
         puls  cc
         ldd   $0E,s
         subd  $0C,s
         beq   L0BEF
         std   $0E,s
         ldd   ,s
         subd  $0C,s
         bne   L0BD7
         ldd   #DAT.BlSz
         leax  >-DAT.BlSz,x
         inc   $0B,s
         inc   $0B,s
L0BD7    std   ,s
         ldd   $02,s
         subd  $0C,s
         bne   L0BEA
         ldd   #DAT.BlSz
         leau  >-DAT.BlSz,u
         inc   $07,s
         inc   $07,s
L0BEA    std   $02,s
         lbra  L0B6A
L0BEF    leas  <$10,s
MoveNone    clrb
         puls  pc,u,y,x,b,a

* Calculate offset within DAT image
* Entry: B=Task #
*        X=Pointer to data
* Exit : A=Offset into DAT image
*        X=Offset within block from original pointer
L0BF5    pshs  b
         tfr   x,d
         anda  #%11100000   Keep only which 8K bank it's in
         beq   L0C07   Bank 0, no further calcs needed
         exg   d,x
         anda  #$1F   DAT.TkCt-1
         exg   d,x
         lsra
         lsra
         lsra
         lsra
L0C07    puls  pc,b

L0C09    pshs  b
         ldu   D.TskIPt
         lslb
         ldu   b,u
         puls  pc,b


* Get byte at 0,X in task B
* Returns value in A
H.LDABX    andcc #^CARRY clear carry
         pshs  u,x,b,cc
         bsr   L0BF5
         bsr   L0C09
         ldd   a,u
         orcc  #IntMasks
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,u,x,b,cc

* Store register A at 0,X
STABX    andcc #^CARRY clear carry
         pshs  u,x,b,a,cc
         bsr   L0BF5
         bsr   L0C09
         ldd   a,u
         lda   1,s
         orcc  #IntMasks
         stb   DAT.Regs
         sta   ,x
         clr   DAT.Regs
         puls  pc,u,x,b,a,cc

* Get byte from Task in task B
* Returns value in B
LDBBX andcc #^CARRY clear carry
         pshs  u,x,a,cc
         bsr   L0BF5
         bsr   L0C09
         ldd   a,u
         orcc  #IntMasks
         stb   DAT.Regs
         ldb   ,x
         clr   DAT.Regs
         puls  pc,u,x,a,cc
 page
***********************************************************
*
*     Subroutine AllTsk
*
*   Process Task allocation service routine
*
* Input: U = registers ptr
*        R$X,y = Process ptr
*
* Output: Carry clear if successful; set otherwise
*
* Data: none
*
* Calls: AllPrTsk
*
AllTsk ldx R$X,u get process ptr
*
*     fall through to AllPrTsk
*
***********************************************************
*
*     Subroutine AllPrTsk
*
*   Allocate process task number
*
* Input: X = Process ptr
*
* Output: carry clear if successful; set otherwise
*
* Data: none
*
* Calls: ResvTask, SetPrTsk
*
AllPrTsk ldb P$Task,X
 bne AllPrT10
 bsr ResvTask Reserve task number
 bcs TSKRET
 stb P$Task,X
 bsr SetPrTsk Set process task registers
AllPrT10 clrb
TSKRET rts

*****
* Deallocate Process Task number
*
DELTSK ldx R$X,u  Get process descriptor
DelPrTsk ldb P$Task,X
 beq TSKRET
 clr P$Task,X
 bra RelsTask

*
* Update process task registers if changed
*
ChkPrTsk lda P$State,x
 bita #ImgChg Did task image change?
 bne SetPrTsk Set process task registers
 rts

*****
SETTSK ldx R$X,U

SetPrTsk lda P$State,X
 anda #^ImgChg
 sta P$State,X
 andcc #^CARRY clear carry
 pshs u,Y,X,D,cc
 ldb P$Task,X
 leax P$DATImg,X
         ldu   D.TskIPt
         lslb
         stx   b,u
         cmpb  #$02
         bgt   L0C9F
         ldu   #DAT.Regs
         leax  1,x
         ldb   #$08 DAT.BlCt DAT.ImSz/2
L0C98    lda   ,x++
         sta   ,u+
         decb
         bne   L0C98
L0C9F    puls  pc,u,y,x,b,a,cc

*****
* Reserve Task Number
* Output: B = Task number
RESTSK bsr ResvTask
 stb R$B,u Set task number
 rts

* Find free task
ResvTask    pshs  x
         ldb   #2
 ldx D.Tasks
ResTsk10 lda b,x
 beq RESTSK20
 incb
 cmpb #DAT.TkCt Last task slot?
 bne ResTsk10 ..yes
 comb
 ldb #E$NoTask
 bra RESTSK30
RESTSK20 inc b,x Mark occupied
 orb D.SysTsk
 clra
RESTSK30 puls pc,x

*****
* Release Task number
*
RELTSK ldb R$B,u Task number
RelsTask pshs x,b
 ldb D.SysTsk
 comb
 andb 0,s
 beq RelTsk10
 ldx D.Tasks
 clr b,x
RelTsk10 puls pc,x,b

 page
*****
*
*  Clock Tick Routine
*
* Wake Sleeping Processes
*
TICK ldx D.SProcQ Get sleeping queue ptr
 beq SLICE Branch if none
 lda P$State,X Get process status
 bita #TimSleep Is it in timed sleep?
 beq SLICE Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 subd #1 Count down
 std R$X,U Update tick count
 bne SLICE Branch if ticks left
TICK10 ldu P$Queue,X Get next process ptr
 bsr ActvProc Activate process
 leax 0,U Copy process ptr
 beq TICK20 Branch if end of queue
 lda P$State,X Get process status
 bita #TimSleep In timed sleep?
 beq TICK20 Branch if not
 ldu P$SP,X Get stack ptr
 ldd R$X,U Get tick count
 beq TICK10 Branch if time
TICK20 stx D.SProcQ Update sleep queue ptr
*
* Update Time Slice counter
*
SLICE dec D.Slice Count tick
 bne SLIC10 Branch if slice not over
 inc D.Slice
*
* If Process not in System State, Give up Time-Slice
*
 ldx D.PROC Get current process ptr
 beq SLIC10 Branch if none
 lda P$State,X Get status
 ora #TIMOUT Set time-out flag
 sta P$State,X Update process status
SLIC10 clrb
 rts
 page
*****
*
*  Subroutine Actprc
*
* Put Process In Active Process Queue
*
APROC ldx R$X,u
ActvProc clrb
 pshs u,y,x,b,cc
 lda P$Prior,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQMask+FIRQMask Set interrupt masks
 ldu #D.AProcQ-P$Queue Fake process ptr
 bra ACTP30
ACTP10 inc P$AGE,u
 bne ACTP20 is not 0
 dec P$AGE,u too high
ACTP20 cmpa P$AGE,U Who has bigger priority?
 bhi ACTP40
ACTP30 leay 0,U Copy ptr to this process
ACTP40 ldu P$Queue,U Get ptr to next process
 bne ACTP10
 ldd P$Queue,y
 stx P$Queue,y
 std P$Queue,x
         puls  pc,u,y,x,b,cc  B added here

*****
*
*  Irq Handler
*
UserIRQ ldx D.Proc
 sts P$SP,x Save stack pointer of running process
 lds D.SysStk
 ldd D.SysSvc
 std D.XSWI2
 ldd D.SysIRQ
 std D.XIRQ
 jsr [D.SvcIRQ] Go to interrupt service
 bcc UserRet branch if service failed
 ldx D.Proc
 ldb P$Task,X
 ldx P$SP,X
 lbsr H.LDABX Get saved cc
 ora #IntMasks inhibit interrupts in process
 lbsr STABX Save CC
UserRet orcc #IntMasks
 ldx D.Proc
         lda   P$State,x
         bita  #TimOut
         bne   UsrRet.a
         ldu   #D.AProcQ-P$Queue Fake process ptr
         ldb   #$08
L0D6A    ldu   P$Queue,u
         beq   L0D78
         bitb  P$State,u
         bne   L0D6A
         ldb   $0A,x
         cmpb  $0A,u
         bcs   UsrRet.a
L0D78    ldu   $04,x
         bra   NXTP30
UsrRet.a    anda  #$DF
         sta   P$State,x
         lbsr  DelPrTsk
IRQHN30 lbsr ActvProc

*****
*
*  Routine Nxtprc
*
* Starts next Process in Active Queue
* If no Active Processes, Wait for one
*
NPROC ldx D.SysPrc
 stx D.Proc Clear current process
 lds D.SysStk
 andcc #^IntMasks
 bra NXTP06

NextPr10 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
         lda   #$08
         ldx   #D.AProcQ-P$Queue Fake process ptr
NXTP10    leay  ,x
NXTP20 ldx P$Queue,Y Get first process in active queue
 beq NextPr10 Branch if none
         bita  P$State,X
         bne   NXTP10
*
* Remove Process from Active Queue
*
 ldd P$Queue,X Get next process ptr
 std P$Queue,Y Remove first from active queue
 stx D.Proc Set current process
 lbsr AllPrTsk Allocate Process Task number
 bcs IRQHN30
 lda D.TSlice
 sta D.Slice
 ldu P$SP,X Get stack ptr
*
* Check Process Status, check for Signal pending
*
 lda P$State,X Is process in system state?
         bmi   SYSRET00
NXTP30 bita #CONDEM Is process condemmed?
 bne KillProc Branch if so
 lbsr ChkPrTsk
 ldb P$Signal,X Is a signal waiting?
 beq NXTP50 Branch if not
 decb Wake-up Signal?
 beq NXTP40 Branch if so
*
* Signal is pending; If an Intercept has been set
* Build an Interrupt Stack for User
*
 leas -R$Size,S Make space for copy
 leau 0,S Copy stack pointer
 lbsr GetRegs Copy 12 bytes from P$SP to U
 lda P$Signal,X
 sta 2,U
 ldd P$SigVec,X Get intercept vector
 beq KillProc Branch if none
 std 10,U
 ldd P$SigDat,X Get intercept data address
 std 8,U
 ldd P$SP,X
 subd #R$Size Make space for copy
 std P$SP,X
 lbsr PutRegs Copy 12 bytes from U to P$SP
 leas R$Size,S Reset stack
 ldu P$SP,X
 clrb
NXTP40 stb P$Signal,X Clear signal
*
* Switch to User State
*
NXTP50 ldd D.UsrSvc
 std D.XSWI2
 ldd D.UsrIRQ Get user irq
 std D.XIRQ
 lbra SVCRET Start next process

KillProc lda P$State,x Get process status
 ora #SysState Set system state
 sta P$State,x Update status
 leas P$Stack,x   
 andcc #^IntMasks Clear interrupt masks
 ldb P$Signal,X Return fatal signal
 clr P$Signal,X
 OS9 F$EXIT Terminate process

*****
*
*  Interrupt Routine Sysirq
*
* Handles Irq While In System State
*
SYSIRQ   lda   D.SSTskN
         clr   D.SSTskN
         pshs  a
 jsr [D.SvcIRQ] Go to interrupt service
         puls  a
         bsr   UPDGIME
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti

* Return from a system call
SYSRET00    clr   ,-s
SYSRET ldx D.SysPrc
 lbsr ChkPrTsk
 orcc #IntMasks
 puls a
 bsr UPDGIME
 leas 0,u Reset stack pointer
 rti

* Update GIME INIT1 register
UPDGIME sta D.SSTskN System State Task Number
         beq   UPDG10
         ora   D.TINIT
         sta   D.TINIT
         sta   DAT.Task
UPDG10 rts

GoPoll   jmp   [D.Poll]

IOPOLL orcc #CARRY
 rts

* Restore DAT image and return from interrupt
*
SVCRET ldb P$Task,x Get task number from process
 orcc #IntMasks
         bsr   L0E8D
         lda   D.TINIT
         ora   #$01
         sta   D.TINIT
         sta   DAT.Task
 leas 0,u Reset stack pointer
 rti

* Switch task and execute user supplied SWI vector
*
PassSWI    ldb   D.TINIT
         orb   #$01
         stb   D.TINIT
 stb DAT.Task
 jmp 0,U Execute user interrupt handler

* Change to task 0
L0E69    pshs  b,a
         lda   D.TINIT
         anda  #$FE
         sta   D.TINIT
         sta   DAT.Task
         clr   D.SSTskN
         puls  b,a
         tfr   x,s
         tfr   a,cc
         rts

* Change to task 1
L0E7D    ldb   #$01
         bsr   L0E8D
         lda   D.TINIT
         ora   #$01
         sta   D.TINIT
         sta   DAT.Task
         inc   D.SSTskN
         rti

L0E8D    pshs  u,x,b,a
         ldx   #$FFA8  DAT.Regs+8
         ldu   D.TskIPt
         lslb
         ldu   b,u
         leau  1,u
         ldb   #$08
L0E9B    lda   ,u++
         sta   ,x+
         decb
         bne   L0E9B
         puls  pc,u,x,b,a
 page
***********************************************************
*
*     Interrupt Vector Routines
*
*   Set interrupt masks, of necessary, set system memory,
*   and jump through direct page psuedo-vector
*
* Data: none
*
* Calls: [D.SWI3], [D.SWI2], [D.FIRQ], [D.IRQ], [D.SWI], [D.NMI]
*

SWI3RQ orcc #IntMasks
 ldb #D.SWI3
 bra SWITCH

SWI2RQ orcc  #IntMasks
 ldb   #D.SWI2
 bra SWITCH

FIRQ ldb #D.FIRQ
 bra SWITCH

IRQ orcc #IntMasks
 ldb #D.IRQ

Switch equ *
 lda #SysTask
 sta DAT.Task
 clra
 tfr A,DP
         lda   D.TINIT
         anda  #$FE
         sta   D.TINIT
         sta   DAT.Task
 clra
 tfr D,X
 jmp [,X]

SWIRQ ldb #D.SWI
 bra SWITCH

NMI ldb #D.NMI
 bra SWITCH

 emod
OS9End equ *

 fcc /99999/

SYSVEC fdb TICK+$FFDE-* Clock tick handler
 fdb UserSWI3+$FFE0-* Swi3 handler
 fdb UserSWI2+$FFE2-* Swi2 handler
 fdb 0000+$FFE4-*  Fast irq handler
 fdb UserIRQ+$FFE6-* Irq handler
 fdb UserSWI+$FFE8-* Swi handler
 fdb 0000+$FFEA-* Nmi handler
 fdb $0055
* Long branches
 lbra SWI3RQ
 lbra SWI2RQ
 lbra FIRQ
 lbra IRQ
 lbra SWIRQ
 lbra NMI
ROMEnd equ *


 end
