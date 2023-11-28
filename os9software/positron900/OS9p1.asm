 nam OS-9 Level II V1.2
 ttl Module Header


 use defsfile

Type     set   Systm
Revs     set   ReEnt+8
         mod   OS9End,OS9Name,Type,Revs,0,0


OS9Name fcs /OS9p1/

         fcb   11

 ttl Coldstart Routines
 pag
************************************************************
*
*     Routine Cold
*
*   System Coldstart; determines system state, initializes
* system data structures, searches for the remainder of the
* system and attempts to start operation.
*
LORAM set $20
HiRAM set DAT.Blsz*RAMCount

*
*      clear system RAM
*
TEST set 0 not test mode
COLD    clr   >$E800
         clr   >$E808
         ldx   #$0300
         stx   >DAT.Regs
         ldx   #$0000
         clr   ,x
         lda   ,x
         bne   L0045
         dec   ,x
         lda   ,x
         cmpa  #$FF
         bne   L0045
         ldd   #$0306
         std   >DAT.Regs
         lda   ,x
         bita  #$01
         beq   L0045
         ldx   #$01EC
         stx   >$FFB0
         jmp   >$C000

L0045    ldx   #$0300
         ldy   #$0000
L004C    clra
         clrb
         stx   >DAT.Regs
L0051    clr   d,y
         incb
         cmpb  #$50
         bne   L0051
         clrb
         inca
         cmpa  #$08
         bne   L0051
         leax  $01,x
         cmpx  #$0340
         bne   L004C
         lda   >$ED00
         anda  #$E0
         bne   L0090
         ldx   #$EC00
         lda   #$80
         sta   $03,x
         clr   ,x
         clr   $01,x
         lda   #$8F
         sta   $03,x
         clr   $03,x
         lda   #$28
L007F    deca
         bne   L007F
         lda   #$0F
         sta   $03,x
         ldd   ,x
         lda   #$90
         sta   $03,x
         lda   #$12
         sta   $03,x
L0090    ldx   #$ED01
         ldy   #$E001
         ldb   #$04
L0099    lda   ,x+
         sta   $02,y
         lda   #$02
         sta   $01,y
         leay  >$0150,y
         decb
         bne   L0099
         lda   >$ED00
         bita  #$01
         beq   L00BB
         ldy   #$E001
L00B3    tst   $01,y
         bne   L00B3
         lda   #$05
         sta   $01,y
L00BB    ldx   #DAT.WrEn+$000
         stx   DAT.Regs
 ldx #LoRAM get low limit ptr
 ldy #HiRAM-LoRAM get byte count
 clra clear d
 clrb
Cold10 std ,X++ clear memory
         leay  -$02,y
         bne   Cold10
*
*     initialize DAT image, Memory Block Map, &
*        Module Directory ptrs
*
 inca skip direct page
 std D.Tasks set Task User Table ptr
 addb #DAT.TkCt allocate Task User Table
 std D.TmpDAT set temporary DAT stack ptr
 clrb
 inca allocate DAT stack
 std D.BlkMap set free memory block map
 adda #DAT.BMSz/256 allocate memory block map
 std D.BlkMap+2 set initialization ptr
 std D.SysDis set System Dispatch Table ptr
 inca allocate table
 std D.UsrDis set User Dispatch Table ptr
 inca allocate table
 std D.PrcDBT set Process Descriptor Block ptr
 inca allocate table
 std D.SysPrc set system process ptr
 std D.Proc set current process
 adda #P$Size/256 allocate system process descriptor
 tfr d,s set stack
 inca allocate system stack
 std D.SysStk set top of system stack
 std D.SysMem set system memory map ptr
 inca allocate memory map
 std D.ModDir set module directory ptr
 std D.ModEnd set end of directory ptr
         adda  #$07
 std D.ModDir+2 set end ptr
 std D.ModDAT set end ptr for Module DAT area
 leax IntXfr,pcr get interrupt transfer
 tfr X,D copy it
 ldx #D.SWI3 get entry vectors ptr
Cold14 std ,X++ set vector
 cmpx #D.NMI end of vectors?
 bls Cold14 branch if not
 leax ROMEnd,PCR get entry offset
 pshs X save it
 leay HdlrVec,PCR get interrupt handlers
 ldx #D.Clock get psuedo-vector ptr
Cold15 ldd ,Y++ get vector
 addd 0,s add offset
 std ,X++ set psuedo-vector
 cmpx #D.XNMI end of vectors?
 bls Cold15 branch if not
 leas 2,s return scratch
 ldx D.XSWI2 get user service routine
 stx D.UsrSvc set user entry
 ldx D.XIRQ get user IRQ routine
 stx D.UsrIRQ set user entry
 leax SysSvc,PCR get system service routine
 stx D.SysSVC set system entry
 stx D.XSWI2 set system entry
 leax SysIRQ,PCR get system IRQ routine
 stx D.SysIRQ set system entry
 stx D.XIRQ set IRQ entry
 leax GoPoll,pcr get call to [D.Poll]
 stx D.SvcIRQ set in-system IRQ service
 leax IOPoll,PCR get polling routine ptr
 stx D.POLL set it
 leay SvcTbl,PCR get service routine initial
 lbsr SetSvc install service routines
 ldu D.PrcDBT get process descriptor block ptr
 ldx D.SysPrc get system process ptr
 stx 0,u set process zero page
 stx 1,u set process one page
 lda #1 set process ID
 sta P$ID,X
 lda #SysState get system state
 sta P$State,X set state
 lda #SysTask get system task
 sta D.SysTsk set system task number
 sta P$Task,X set process task number
 lda #255 get high priority
 sta P$Prior,X set process priority
 sta P$Age,X set process age
 leax P$DATImg,X get DAT image ptr
 stx D.SysDAT set system DAT image ptr
 ifeq DAT.WrEn
 clra
 clrb
 else
 ldd #DAT.WrEn
 endc
 std ,X++ use block zero for system
 ifge RAMCount-2
 incb
 std   ,x++
 ifge RAMCount-3
 incb
 std   ,x++
 endc
 endc
         ldy   #Dat.BlCt-ROMCount-RAMCount-1 get free block count
         ldd   #DAT.Free
Cold16 std ,X++ mark free entry
 leay -1,Y count block
 bne Cold16 branch if more
         ldd   #DAT.WrEn+$0140
         std   ,x++
         ldd   #DAT.WrEn+$0150
         std   ,x++
         ldd   #ROMBlock ($01FE)
L019B    std   ,x++
         incb
         bne   L019B
         ldx   D.Tasks
         inc   ,x
         inc   $01,x
 ldx D.SysMem get system memory map ptr
 ldb D.ModDir+2 get number of pages used
Cold17 inc ,X+ claim page
 decb count it
 bne Cold17 branch if more
*
*      build Memory Block Map
*
 ifeq RAMCheck-BlockTyp
 ldy #DAT.BlSz*RAMCount get unused block ptr
 ldx D.BlkMap
 endc
Cold20 equ *
 ifeq RAMCheck-BlockTyp
 pshs X
 ldd 0,s
 endc
 subd D.BlkMap get block number
 ifle DAT.BlMx-255
 ifeq MappedIO-true
 cmpb #IOBlock is this I/O block?
 else
 cmpb #DAT.BlMx last block?
 endc
 beq Cold30 branch of so
 stb DAT.Regs+RAMCount set block register
 else
 cmpd #DAT.BlMx
 bcc Cold30
 ifne DAT.WrEn
 ora #(DAT.WrEn/256)
 endc
 std DAT.Regs+(RAMCount*2) set block register
 ifeq RAMCheck-BlockTyp
 ldu 0,y get current contents
 ldx #$00FF get first test pattern
 stx 0,Y store it
 cmpx 0,Y did it store?
 bne Cold30 branch if not
 ldx #$FF00 get second test pattern
 stx 0,Y store it
 cmpx 0,Y did it store?
 bne Cold30 branch if not
 stu 0,y replace original contents
 bra Cold40
Cold30 ldb #NotRAM get not-RAM flag
 stb [0,s] mark block not-RAM
Cold40 puls x retrieve block map ptr
 leax 1,X next Block Map entry
 cmpx D.BlkMap+2 end of map?
 bcs Cold20 branch if not
 endc
*
*      search Not-Ram, excluding I/O, for modules
*
 ldx D.BlkMap
 inc 0,X claim block zero for system
 ifge RAMCount-2
 inc 1,x
 ifge RAMCount-3
 inc 2,x
 endc
 endc
 ifeq ROMCheck-Limited
         ldx   D.BlkMap+2
 endc
Cold50    lda   ,x
         beq   Cold80
         tfr   x,d
         subd  D.BlkMap
         cmpd  #$015F
         beq   Cold80
         leas  <-$40,s
         leay  ,s
 ifne TEST
 else
         bsr   MovDAT
 endc
         pshs  x
         ldx   #$0000
Cold55 equ *
Cold60    pshs  y,x
         lbsr  AdjImg
         ldd   ,y
         std   >DAT.Regs
         lda   ,x
         ldx   #$0200
         stx   >DAT.Regs
 endc
 puls y,x retrieve ptrs
 cmpa #$87 could be module?
 bne Cold70 branch if not
Cold62 lbsr ValMod validate module
 bcc Cold65 branch if successful
 cmpb #E$KwnMod known module?
 bne Cold70 branch if not
Cold65 ldd #M$Size get module size offset
 lbsr LDDDXY get module size
 leax D,X move ptr
 bra Cold75
Cold70 leax 1,X move ptr
Cold75 tfr X,D copy ptr
 tstb end of block?
 bne Cold60 branch if not
 bita #^DAT.Addr end of block?
 bne Cold60 branch if not
         puls  x
         leas DAT.BlCt*2,s throw away temp DAT area
Cold80    leax  -1,x
         ldy   D.BlkMap+2
         leay  <-$80,y
         pshs  y
         cmpx  ,s++
         bcc   Cold50
Cold.z1 leax InitName,pcr get name ptr
 bsr LinkSys link to "Init"
 bcc Cold.z2 branch if found
 ifne TEST
 endc
 os9 F$Boot call bootstrap
 bcc Cold.z1 branch if bootstrapped
 ifne TEST
 endc
 bra ColdErr
Cold.z2 stu D.Init save module ptr
Cold.z3 leax P2Name,pcr get name str str
 bsr LinkSys link to "OS9p2"
 bcc Cold.xit branch if found
 ifne TEST
 endc
 os9 F$Boot call bootstrapper
 bcc Cold.z3 branch if bootstrapped
ColdErr equ *
  jmp   [>$FFFE]

Cold.xit jmp 0,y go to "OS9p2"

LinkSys lda #Systm set module type
 os9 F$Link link to it
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
MovDAT pshs y,x,d save regs
 ldb #DAT.BlCt get block count
 ldx 0,s get starting block number
MovDAT.B stx ,Y++ set DAT image
 leax 1,X mov ptr
 decb done?
 bne MovDAT.B bra if not
 puls PC,Y,X,D return


SvcTbl equ *
 fcb F$Link
 fdb Link-*-2
 fcb F$PRSNAM
 fdb PNam-*-2
 fcb F$CmpNam
 fdb UCNam-*-2
 fcb F$CmpNam+SysState
 fdb SCNam-*-2
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+SysState
 fdb SRqMem-*-2
 fcb F$SRtMem+SysState
 fdb SRtMem-*-2
 fcb F$AProc+SysState
 fdb AProc-*-2
 fcb F$NProc+SysState
 fdb NextProc-*-2
 fcb F$VModul+SysState
 fdb VModule-*-2
 fcb F$SSvc
 fdb SSvc-*-2
 fcb F$SLink+SysState
 fdb SLink-*-2
 fcb F$Boot+SysState
 fdb Boot-*-2
 fcb F$BtMem+SysState
 fdb SRqMem-*-2
 fcb F$Move+SysState
 fdb Move-*-2
 fcb F$AllRAM
 fdb AllRAM-*-2
 fcb F$AllImg+SysState
 fdb AllImg-*-2
 fcb F$SetImg+SysState
 fdb SetImg-*-2
 fcb F$FreeLB+SysState
 fdb FreeLB-*-2
 fcb F$FreeHB+SysState
 fdb FreeHB-*-2
 fcb F$AllTsk+SysState
 fdb AllTsk-*-2
 fcb F$DelTsk+SysState
 fdb DelTsk-*-2
 fcb F$SetTsk+SysState
 fdb SetTsk-*-2
 fcb F$ResTsk+SysState
 fdb ResTsk-*-2
 fcb F$RelTsk+SysState
 fdb RelTsk-*-2
 fcb F$DATLog+SysState
 fdb DATLog-*-2
 fcb F$LDAXY+SysState
 fdb F.LDAXY-*-2
 fcb F$LDDDXY+SysState
 fdb F.LDDDXY-*-2
 fcb F$LDABX+SysState
 fdb F.LDABX-*-2
 fcb F$STABX+SysState
 fdb F.STABX-*-2
 fcb F$ELink+SysState
 fdb ELink-*-2
 fcb F$FModul+SysState
 fdb FMod-*-2
 fcb $80


InitName fcs "Init"
P2Name fcs "OS9p2"
BootName fcs "Boot"

IntXfr         jmp   [<-$10,x]

UserSWI3        ldx   D.Proc
         ldu   <$17,x
         beq   UserSvc
UsrSWI10  lbra  PassSWI

UserSWI2         ldx   D.Proc
         ldu   <$15,x
         beq   UserSvc
         bra   UsrSWI10

UserSWI        ldx   D.Proc
         ldu   <$13,x
         bne   UsrSWI10

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

GetRegs    pshs  u,y,x,cc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0C7C
         leax  >-$2000,x
         bra   PutReg.A

PutRegs    pshs  u,y,x,cc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0C7C
         leax  >-$2000,x
         exg   x,u
PutReg.A    pshs  u
         ldu   #DAT.Regs
         leau  a,u
         orcc  #$50
         stb   >$FFCA
         pulu  y,b,a
         clr   >$FFCA
         ldu   #$FFBC
         pshu  y,b,a
         puls  u
 ldy #R$Size get double byte count
L0392    ldd   ,x++
         std   ,u++
         leay  -$02,y
         bne   L0392
         ldx   D.SysDAT
         ldd   <$38,x
         std   >$FFB8
         ldd   <$3A,x
         std   >$FFBA
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
SysSvc leau 0,s get registers ptr
 lda R$CC,u get caller's interrupt masks
 tfr a,cc restore interrupt masks
 ldx R$PC,u get program counter
 ldb ,X+ get service code
 stx R$PC,u update program counter
 ldy D.SysDis get system dispatch table ptr
 bsr Dispatch dispatch to service routine
 lbra SysRet
 page
************************************************************
*
*     Subroutine Dispatch
*
*   Calls service routing using service request code as an
*   index in table of service routine addresses
*
* Input: B = Service Request code
*        Y = Service Routine Address Table ptr
*        U = registers ptr
*
* Output: none
*
* Data: none
*
* Calls: [max(B*2,254),Y]
*
Dispatch aslb make table offset
         bcc   L03C8
         rorb
         ldx   >$00FE,y
         bra   L03D2
L03C8    clra
         ldx   d,y
         bne   L03D2
         comb
         ldb   #$D0
         bra   L03D8
L03D2    pshs  u
         jsr   ,x
         puls  u
L03D8    tfr   cc,a
         bcc   Dispat40
         stb   $02,u
Dispat40    ldb   ,u
         andb  #$D0
         stb   ,u
         anda  #$2F
         ora   ,u
         sta   ,u
         rts

SSvc ldy R$Y,u get table address
 bra SetSvc

SetSvc10    clra
         lslb
         tfr   d,u
         ldd   ,y++
         leax  d,y
         ldd   D.SysDis
         stx   d,u
         bcs   SetSvc
         ldd   D.UsrDis
         stx   d,u
SetSvc    ldb   ,y+
         cmpb  #$80
         bne   SetSvc10
         rts

SLink        ldy   $06,u
         bra   SysLink
ELink         pshs  u
         ldb   $02,u
         ldx   $04,u
         bra   L0432

Link ldx D.Proc get process ptr
 leay P$DATImg,x get DAT image ptr
SysLink    pshs  u
         ldx   $04,u
         lda   $01,u
         lbsr  FModule
         lbcs  L04B5
         leay  ,u
         ldu   ,s
         stx   $04,u
         std   $01,u
         leax  ,y
L0432    bitb  #$80
         bne   Link10
         ldd   $06,x
         beq   Link10
         ldb   #$D1
         bra   L04B5
Link10    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
 addd #DAT.BlSz-1 round to next block
         tfr   a,b
         lsrb
         lsrb
         lsrb
         pshs  b
         leau  ,y
         bsr   L04B9
         bcc   L0482
         lbsr  FreeHBlk
         bcc   L0462
         leas  $05,s
         ldb   #$CF
         bra   L04B5
L0462    lbsr  SetImage
         pshs  u,b,a
         lsla
         leau  a,y
         ldy   $09,s
         lda   $02,y
         bita  #$40
         beq   L0480
         clra
         tfr   d,y
L0476    ldd   ,u
         ora   #$02
         std   ,u++
         leay  -$01,y
         bne   L0476
L0480    puls  u,b,a
L0482    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  $01,x
         beq   L0493
         stx   ,u
L0493    ldu   $03,s
         ldx   $06,u
         leax  $01,x
         beq   L049D
         stx   $06,u
L049D    puls  u,y,x,b
         lbsr  DATtoLog
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  LDDDXY
         addd  $08,u
         std   $06,u
         clrb
         rts
L04B5    orcc  #$01
         puls  pc,u
L04B9    ldx   D.Proc
         leay  <$40,x
         clra
         pshs  y,x,b,a
         subb  #$20
         negb
         lslb
         leay  b,y
L04C7    ldx   ,s
         pshs  u,y
L04CB    ldd   ,y++
         anda  #$01
         cmpd  ,u++
         bne   L04E2
         leax  -$01,x
         bne   L04CB
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a
L04E2    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   L04C7
         puls  pc,y,x,b,a

VModule pshs U save registers ptr
 ldx R$X,u get module offset
 ldy R$D,u get DAT image ptr
 bsr ValMod validate module
 ldx 0,s get registers ptr
 stu R$U,x return entry ptr
VModXit puls pc,u



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
ValMod    pshs  y,x
         lbsr  ModCheck
         bcs   ValMoErr
         ldd   #$0006
         lbsr  LDDDXY
         andb  #$0F
         pshs  b,a
         ldd   #$0004
         lbsr  LDDDXY
         leax  d,x
         puls  a
         lbsr  FModule
         puls  a
         bcs   L0530
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   L0530
         ldb   #$E7
         bra   ValMoErr
ValMoErA    ldb   #$CE
ValMoErr    orcc  #$01
         puls  pc,y,x
L0530    ldx   ,s
         lbsr  SetMoImg
         bcs   ValMoErA
         sty   ,u
         stx   $04,u
         clra
         clrb
         std   $06,u
         ldd   #$0002
         lbsr  LDDDXY
         pshs  x
         addd  ,s++
         std   $02,u
         ldy   [,u]
         ldx   D.ModDir
         pshs  u
         bra   L0557
ValMod30    leax  $08,x
L0557    cmpx  D.ModEnd
         bcc   L0566
         cmpx  ,s
         beq   ValMod30
         cmpy  [,x]
         bne   ValMod30
         bsr   FreDATI
L0566    puls  u
         ldx   D.BlkMap
         ldd   $02,u
         addd  #$07FF
         lsra
         lsra
         lsra
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
L0591    ldy   ,x
         beq   L059A
         std   ,x++
         bra   L0591
L059A    puls  x
         ldy   $02,s
         ldu   ,u
         puls  b,a
L05A3    cmpx  ,y
         bne   L05B2
         stu   ,y
         cmpd  $02,y
         bcc   L05B0
         ldd   $02,y
L05B0    std   $02,y
L05B2    leay  $08,y
         cmpy  D.ModEnd
         bne   L05A3
         puls  pc,u,y,x

SetMoImg    pshs  u,y,x
         ldd   #$0002
         lbsr  LDDDXY
         addd  ,s
         addd  #$07FF
         lsra
         lsra
         lsra
         tfr   a,b
         pshs  b
         incb
         lslb
         negb
         sex
         bsr   chkspce
         bcc   L05E1
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   chkspce
L05E1    puls  pc,u,y,x,b

chkspce    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   L0618
         ldu   $07,s
         bne   L0603
         pshs  x
         ldy   D.ModEnd
         leay  $08,y
         cmpy  ,s++
         bhi   L0618
         sty   D.ModEnd
         leay  -$08,y
         sty   $07,s
L0603    stx   D.ModDAT
         ldy   $05,s
         ldb   $02,s
         stx   $05,s
L060C    ldu   ,y++
         stu   ,x++
         decb
         bne   L060C
         clr   ,x
         clr   $01,x
         rts
L0618    orcc  #$01
         rts

ModCheck    pshs  y,x
         clra
         clrb
         lbsr  LDDDXY
         cmpd  #$87CD
         beq   L062C
         ldb   #$CD
         bra   L0688
L062C    leas  -$01,s
         leax  $02,x
         lbsr  AdjImg
         ldb   #$07
         lda   #$4A
L0637    sta   ,s
         lbsr  LDAXYP
         eora  ,s
         decb
         bne   L0637
         leas  $01,s
         inca
         beq   L064A
         ldb   #$EC
         bra   L0688
L064A    puls  y,x
         ldd   #$0002
         lbsr  LDDDXY
         pshs  y,x,b,a
         ldd   #$FFFF
         pshs  b,a
         pshs  b
         lbsr  AdjImg
         leau  ,s
L0660    tstb
         bne   L066D
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
L066D    lbsr  LDAXYP
         bsr   CRCCal
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   L0660
         puls  y,x,b
         cmpb  #$80
         bne   L0686
         cmpx  #$0FE3
         beq   L068A
L0686    ldb   #$E8
L0688    orcc  #$01
L068A    puls  pc,y,x

CRCCal    eora  ,u
         pshs  a
         ldd   $01,u
         std   ,u
         clra
         ldb   ,s
         lslb
         rola
         eora  $01,u
         std   $01,u
         clrb
         lda   ,s
         lsra
         rorb
         lsra
         rorb
         eora  $01,u
         eorb  $02,u
         std   $01,u
         lda   ,s
         lsla
         eora  ,s
         sta   ,s
         lsla
         lsla
         eora  ,s
         sta   ,s
         lsla
         lsla
         lsla
         lsla
         eora  ,s+
         bpl   L06CA
         ldd   #$8021
         eora  ,u
         sta   ,u
         eorb  $02,u
         stb   $02,u
L06CA    rts

CRCGen         ldd   $06,u
         beq   L070C
         ldx   $04,u
         pshs  x,b,a
         leas  -$03,s
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         ldx   $08,u
         ldy   #$0003
         leau  ,s
         pshs  y,x,b,a
         lbsr  Mover
         ldx   D.Proc
         leay  <$40,x
         ldx   $0B,s
         lbsr  AdjImg
L06F2    lbsr  LDAXYP
         lbsr  CRCCal
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   L06F2
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  Mover
         leas  $07,s
L070C    clrb
         rts

FMod         pshs  u
         lda   $01,u
         ldx   $04,u
         ldy   $06,u
         bsr   FModule
         puls  y
         std   $01,y
         stx   $04,y
         stu   $08,y
         rts
FModule    ldu   #$0000
         pshs  u,b,a
         bsr   SkipSpc
         cmpa  #$2F
         beq   L07A1
         lbsr  PrsNam
         bcs   L07A4
         ldu   D.ModDir
         bra   L0797
L0736    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   L078B
         ldx   $04,u
         pshs  y,x
         ldd   #$0004
         lbsr  LDDDXY
         leax  d,x
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  ChkNam
         leas  $04,s
         puls  y,x
         leas  $04,s
         bcs   L0793
         ldd   #$0006
         lbsr  LDDDXY
         sta   ,s
         stb   $07,s
         lda   $06,s
         beq   FModul30
         anda  #$F0
         beq   L0776
         eora  ,s
         anda  #$F0
         bne   L0793
L0776    lda   $06,s
         anda  #$0F
         beq   FModul30
         eora  ,s
         anda  #$0F
         bne   L0793
FModul30    puls  y,x,b,a
         abx
         clrb
         ldb   $01,s
         leas  $04,s
         rts

L078B    leas  $04,s
         ldd   $08,s
         bne   L0793
         stu   $08,s
L0793    puls  y,x,b,a
         leau  $08,u
L0797    cmpu  D.ModEnd
         bcs   L0736
         comb
         ldb   #$DD
         bra   L07A4
L07A1    comb
         ldb   #$EB
L07A4    stb   $01,s
         puls  pc,u,b,a
SkipSpc    pshs  y
L07AA    lbsr  AdjImg
         lbsr  LDAXY
         leax  $01,x
         cmpa  #$20
         beq   L07AA
         leax  -$01,x
         pshs  a
         tfr   y,d
         subd  $01,s
         asrb
         lbsr  DATtoLog
         puls  pc,y,a

PNam         ldx   D.Proc
         leay  <$40,x
         ldx   $04,u
         bsr   PrsNam
         std   $01,u
         bcs   L07D4
         stx   $04,u
         abx
L07D4    stx   $06,u
         rts

PrsNam    pshs  y
         lbsr  AdjImg
         pshs  y,x
         lbsr  LDAXYP
         cmpa  #$2F
         bne   L07EC
         leas  $04,s
         pshs  y,x
         lbsr  LDAXYP
L07EC    bsr   Alpha
         bcs   L0800
         clrb
L07F1    incb
         tsta
         bmi   L07FC
         lbsr  LDAXYP
         bsr   AlphaNum
         bcc   L07F1
L07FC    andcc #$FE
         bra   L0812
L0800    cmpa  #$2C
         bne   L080B
L0804    leas  $04,s
         pshs  y,x
         lbsr  LDAXYP
L080B    cmpa  #$20
         beq   L0804
         comb
         ldb   #$EB
L0812    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  DATtoLog
         puls  pc,y,b,a,cc

AlphaNum    pshs  a
         anda  #$7F
         cmpa  #$2E
         beq   L0834
         cmpa  #$30
         bcs   L084B
         cmpa  #$39
         bls   L0834
         cmpa  #$5F
         bne   L083B
L0834    clra
         puls  pc,a
Alpha    pshs  a
         anda  #$7F
L083B    cmpa  #$41
         bcs   L084B
         cmpa  #$5A
         bls   L0834
         cmpa  #$61
         bcs   L084B
         cmpa  #$7A
         bls   L0834
L084B    coma
         puls  pc,a

UCNam         ldx   D.Proc
         leay  <$40,x
         ldx   $04,u
         pshs  y,x
         bra   L0865

SCNam         ldx   D.Proc
         leay  <$40,x
         ldx   $04,u
         pshs  y,x
         ldy   D.SysDAT
L0865    ldx   $06,u
         pshs  y,x
         ldd   $01,u
         leax  $04,s
         leay  ,s
         bsr   ChkNam
         leas  $08,s
         rts

ChkNam    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  AdjImg
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  AdjImg
         bra   L088C
L0888    ldu   $04,s
         pulu  y,x
L088C    lbsr  LDAXYP
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  LDAXYP
         pshu  y,x
         eora  ,s
         tst   ,s+
         bmi   L08AC
         decb
         beq   L08A9
         anda  #$DF
         beq   L0888
L08A9    comb
         puls  pc,u,y,x,b,a
L08AC    decb
         bne   L08A9
         anda  #$5F
         bne   L08A9
         clrb
         puls  pc,u,y,x,b,a

SRqMem         ldd   $01,u
         addd  #$00FF
         clrb
         std   $01,u
         ldy   D.SysMem
         leas  -$02,s
         stb   ,s
L08C5    ldx   D.SysDAT
         lslb
         ldd   b,x
         cmpd  #$015F
         beq   L08DE
         ldx   D.BlkMap
         anda  #$01
         lda   d,x
         cmpa  #$01
         bne   L08DF
         leay  $08,y
         bra   L08E6
L08DE    clra
L08DF    ldb   #$08
L08E1    sta   ,y+
         decb
         bne   L08E1
L08E6    inc   ,s
         ldb   ,s
         cmpb  #$20
         bcs   L08C5
L08EE    ldb   $01,u
L08F0    cmpy  D.SysMem
         bhi   L08FA
         comb
         ldb   #$CF
         bra   L0927
L08FA    lda   ,-y
         bne   L08EE
         decb
         bne   L08F0
         sty   ,s
         lda   $01,s
         lsra
         lsra
         lsra
         ldb   $01,s
         andb  #$07
         addb  $01,u
         addb  #$07
         lsrb
         lsrb
         lsrb
         ldx   D.SysPrc
         lbsr  AllImage
         bcs   L0927
         ldb   $01,u
SRqMem70    inc   ,y+
         decb
         bne   SRqMem70
         lda   $01,s
         std   $08,u
         clrb
L0927    leas  $02,s
         rts

SRtMem         ldd   $01,u
         beq   L0987
         addd  #$00FF
         ldb   $09,u
         beq   L0939
         comb
         ldb   #$D2
         rts
L0939    ldb   $08,u
         beq   L0987
         ldx   D.SysMem
         abx
L0940    ldb   ,x
         andb  #$FE
         stb   ,x+
         deca
         bne   L0940
         ldx   D.SysDAT
         ldy   #$0020
L094F    ldd   ,x
         cmpd  #$015F
         beq   L0981
         ldu   D.BlkMap
         anda  #$01
         lda   d,u
         cmpa  #$01
         bne   L0981
         tfr   x,d
         subd  D.SysDAT
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #$08
L096D    lda   ,u+
         bne   L0981
         decb
         bne   L096D
         ldd   ,x
         ldu   D.BlkMap
         anda  #$01
         clr   d,u
         ldd   #$015F
         std   ,x
L0981    leax  $02,x
         leay  -$01,y
         bne   L094F
L0987    clrb
         rts

Boot         comb
         lda   D.Boot
         bne   BootXX
         inc   D.Boot
         ldx   D.Init
         beq   L099D
         ldd   <$14,x
         beq   L099D
         leax  d,x
         bra   L09A1
L099D    leax  BootName,pcr
L09A1    lda   #$C1
         os9   F$Link
         bcs   BootXX
         jsr   ,y
         bcs   BootXX
         leau  d,x
         tfr   x,d
         anda  #$F8
         clrb
         pshs  u,b,a
         lsra
         lsra
         ldy   D.SysDAT
         leay  a,y
L09BC    ldd   ,x
         cmpd  #$87CD
         bne   L09E5
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         anda  #$FD
         os9   F$VModul
         pshs  b
         ldd   $01,s
         leax  d,x
         puls  b
         bcc   L09DF
         cmpb  #$E7
         bne   L09E5
L09DF    ldd   $02,x
         leax  d,x
         bra   Boot50
L09E5    leax  $01,x
Boot50    cmpx  $02,s
         bcs   L09BC
         leas  $04,s
BootXX    rts

AllRAM         ldb   $02,u
         bsr   RAMBlk
         bcs   L09F6
         std   $01,u
L09F6    rts

RAMBlk    pshs  y,x,b,a
         ldx   D.BlkMap
L09FB    leay  ,x
         ldb   $01,s
L09FF    cmpx  D.BlkMap+2
         bcc   L0A1C
         lda   ,x+
         bne   L09FB
         decb
         bne   L09FF
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   $01,s
         stb   $01,s
L0A14    inc   ,y+
         deca
         bne   L0A14
         clrb
         puls  pc,y,x,b,a
L0A1C    comb
         ldb   #$ED
         stb   $01,s
         puls  pc,y,x,b,a

AllImg         ldd   $01,u
         ldx   $04,u

AllImage    pshs  u,y,x,b,a
         lsla
         leay  <$40,x
         leay  a,y
         clra
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
L0A36    ldd   ,y++
         cmpd  #$015F
         beq   L0A4D
         anda  #$01
         lda   d,u
         cmpa  #$01
         puls  b,a
         bne   AllImErr
         subd  #$0001
         pshs  b,a
L0A4D    leax  -$01,x
         bne   L0A36
         ldx   ,s++
         beq   L0A6B
L0A55    lda   ,u+
         bne   L0A5D
         leax  -$01,x
         beq   L0A6B
L0A5D    cmpu  D.BlkMap+2
         bcs   L0A55
AllImErr    ldb   #$CF
         leas  $06,s
         stb   $01,s
         comb
         puls  pc,u,y,x,b,a
L0A6B    puls  u,y,x
L0A6D    ldd   ,y++
         cmpd  #$015F
         bne   L0A83
L0A75    lda   ,u+
         bne   L0A75
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         ora   #$02
         std   -$02,y
L0A83    leax  -$01,x
         bne   L0A6D
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

FreeHB         ldb   $02,u
         ldy   $06,u
         bsr   FreeHBlk
         bcs   L0A9D
         sta   $01,u
L0A9D    rts

FreeHBlk    tfr   b,a
         suba  #$21
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   FreeBlk

FreeLB         ldb   $02,u
         ldy   $06,u
         bsr   FreeLBlk
         bcs   L0AB7
         sta   $01,u
L0AB7    rts

FreeLBlk    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$21
         negb
         pshs  b,a
         bra   FreeBlk
FreeBlk    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
         bne   L0ADB
         ldb   #$CF
         stb   $03,s
         comb
         bra   L0AE8
L0AD7    tfr   a,b
         addb  $02,s
L0ADB    lslb
         ldx   b,y
         cmpx  #$015F
         bne   FreeBlk
         inca
         cmpa  $03,s
         bne   L0AD7
L0AE8    leas  $02,s
         puls  pc,x,b,a

SetImg         ldd   $01,u
         ldx   $04,u
         ldu   $08,u
SetImage    pshs  u,y,x,b,a
         leay  <$40,x
         lsla
         leay  a,y
L0AFA    ldx   ,u++
         stx   ,y++
         decb
         bne   L0AFA
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

DATLog         ldb   $02,u
         ldx   $04,u
         bsr   DATtoLog
         stx   $04,u
         clrb
         rts
DATtoLog    pshs  x,b,a
         lslb
         lslb
         lslb
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

F.LDAXY         ldx   $04,u
         ldy   $06,u
         bsr   LDAXY
         sta   $01,u
         clrb
         rts

LDAXY    pshs  x,b,cc
         ldd   ,y
         orcc  #$50
         std   >DAT.Regs
         lda   ,x
         ldx   #$0200
         stx   >DAT.Regs
         puls  pc,x,b,cc

LDAXYP    pshs  x,b,cc
         ldd   ,y
         orcc  #$50
         std   >DAT.Regs
         lda   ,x
         ldx   #$0200
         stx   >DAT.Regs
         puls  x,b,cc
         leax  $01,x
         bra   AdjImg

AdjImg10    leax  >-$0800,x
         leay  $02,y
AdjImg    cmpx  #$0800
         bcc   AdjImg10
         rts

F.LDDDXY         ldd   $01,u
         leau  $04,u
         pulu  y,x
         bsr   LDDDXY
         std   -$07,u
         clrb
         rts

LDDDXY    pshs  y,x
         leax  d,x
         lbsr  L0C7C
         leay  a,y
         bsr   LDAXYP
         pshs  a,cc
         ldd   ,y
         orcc  #$50
         std   >DAT.Regs
         ldb   ,x
         ldx   #$0200
         stx   >DAT.Regs
         puls  pc,y,x,a,cc

F.LDABX         ldb   $02,u
         ldx   $04,u
         lbsr  LDABX
         sta   $01,u
         rts

F.STABX         ldd   $01,u
         ldx   $04,u
         lbra  STABX

Move ldd R$D,u get user D register
 ldx R$X,u get user X register
 ldy R$Y,u get user Y register
 ldu R$U,u get user U register

Mover    pshs  u,y,x,b,a
         leay  ,y
         lbeq  L0C79
         pshs  y,b,a
         ldu   #DAT.Regs
         lbsr  L0C7C
         leay  a,u
         pshs  y,x
         ldx   $0E,s
         lbsr  L0C7C
         leay  a,u
         pshs  y,x
         ldd   #$0800
         subd  ,s
         pshs  b,a
         ldd   #$0800
         subd  $06,s
         pshs  b,a
         ldx   $08,s
         leax  ,x
         ldu   $04,s
         leau  >$0800,u
L0BDB    pshs  cc
         orcc  #$50
         tst   D.DMAReq
         beq   L0BE7
         puls  cc
         bra   L0BDB
L0BE7    inc   D.DMAReq
         lda   <$11,s
         sta   >$FFCA
         ldy   [<$0B,s]
         ldb   #$01
         stb   >$FFCA
         sty   >DAT.Regs
         clr   >$FFCA
         lda   <$12,s
         sta   >$FFCA
         ldy   [<$07,s]
         stb   >$FFCA
         sty   >$FF82
         clr   >$FFCA
         puls  cc
         ldd   $0E,s
         cmpd  ,s
         bls   L0C1E
         ldd   ,s
L0C1E    cmpd  $02,s
         bls   L0C25
         ldd   $02,s
L0C25    std   $0C,s
         std   >$E805
         stx   >$E801
         stu   >$E803
         lda   #$3F
         sta   >$E800
L0C35    lda   >$E800
         bpl   L0C35
         clr   >$E800
         clr   D.DMAReq
         ldd   $0E,s
         subd  $0C,s
         beq   L0C76
         std   $0E,s
         ldd   $0C,s
         leax  d,x
         leau  d,u
         ldd   ,s
         subd  $0C,s
         bne   L0C5E
         ldd   #$0800
         leax  >-$0800,x
         inc   $0B,s
         inc   $0B,s
L0C5E    std   ,s
         ldd   $02,s
         subd  $0C,s
         bne   L0C71
         ldd   #$0800
         leau  >-$0800,u
         inc   $07,s
         inc   $07,s
L0C71    std   $02,s
         lbra  L0BDB
L0C76    leas  <$10,s
L0C79    clrb
         puls  pc,u,y,x,b,a
L0C7C    pshs  b
         tfr   x,d
         anda  #$F8
         beq   L0C8C
         exg   d,x
         anda  #$07
         exg   d,x
         lsra
         lsra
L0C8C    puls  pc,b

LDABX    andcc #$FE
         pshs  u,x,b,cc
         bsr   L0C7C
         ldu   #DAT.Regs
         orcc  #$50
         stb   >$FFCA
         ldu   a,u
         ldb   D.SysTsk
         stb   >$FFCA
         stu   >DAT.Regs
         lda   ,x
         ldu   #$0200
         stu   >DAT.Regs
         puls  pc,u,x,b,cc

STABX    andcc #$FE
         pshs  u,x,b,a,cc
         bsr   L0C7C
         ldu   #DAT.Regs
         orcc  #$50
         stb   >$FFCA
         ldd   a,u
         ora   #$02
         tfr   d,u
         ldb   D.SysTsk
         stb   >$FFCA
         lda   $01,s
         stu   >DAT.Regs
         sta   ,x
         ldu   #$0200
         stu   >DAT.Regs
         puls  pc,u,x,b,a,cc

LDBBX    andcc #$FE
         pshs  u,x,a,cc
         bsr   L0C7C
         ldu   #DAT.Regs
         orcc  #$50
         stb   >$FFCA
         ldu   a,u
         ldb   D.SysTsk
         stb   >$FFCA
         stu   >DAT.Regs
         ldb   ,x
         ldu   #$0200
         stu   >DAT.Regs
         puls  pc,u,x,a,cc

AllTsk         ldx   $04,u
AllPrTsk    ldb   $06,x
         bne   L0D08
         bsr   ResvTask
         bcs   L0D09
         stb   $06,x
         bsr   SetPrTsk
L0D08    clrb
L0D09    rts

DelTsk         ldx   $04,u
DelPrTsk    ldb   $06,x
         beq   L0D09
         clr   $06,x
         bra   RelsTask

ChkPrTsk    lda   $0C,x
         bita  #$10
         bne   SetPrTsk
         rts
 page
***********************************************************
*
*     Subroutine SetTsk
*
*   Set task DAT registers service routine
*
* Input: U = Registers ptr
*        R$X,y = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: SetPrTsk
*
SetTsk ldx R$X,u get process ptr

SetPrTsk    lda   $0C,x
         anda  #$EF
         sta   $0C,x
         andcc #$FE
         pshs  u,y,x,b,a,cc
         ldb   $06,x
         leax  <$40,x
         ldy   #$0020
         ldu   #DAT.Regs
         orcc  #$50
         stb   >$FFCA
L0D38    ldd   ,x++
         ora   #$02
         std   ,u++
         leay  -$01,y
         bne   L0D38
         ldb   D.SysTsk
         stb   >$FFCA
         puls  pc,u,y,x,b,a,cc

***********************************************************
*
*     Subroutine ResTsk
*
*   Reserve Task Number
*
* Output: B = New task number
*
* Calls: ResvTask
*
ResTsk bsr ResvTask
 stb R$B,u set task number
 rts

* Find free task and reserve it
ResvTask pshs x
         ldb   #$02
 ldx D.Tasks
ResTsk10 lda B,X
 beq ResTsk20
 incb
 cmpb #DAT.TkCt Last task slot?
 bne ResTsk10 ..yes
 comb
 ldb #E$NoTask err: no tasks
 bra ResTsk30
ResTsk20 inc b,x reserve task
 orb D.SysTsk set selected bits
 clra clear carry
ResTsk30 puls PC,X

RelTsk         ldb   $02,u

RelsTask    pshs  x,b
         ldb   D.SysTsk
         comb
         andb  ,s
         beq   L0D78
         ldx   D.Tasks
         clr   b,x
L0D78    puls  pc,x,b

***********************************************************
*
*     Clock Tick Subroutine
*
*   Update timed-sleep processes' time, make active if
*   time expires; update current process's time slice
*
* Input: none
*
* Output: Carry clear
*
* Data: D.SProcQ, D.Slice, D.TSlice, D.Proc
*
* Calls: ActvProc
*
Tick ldx D.SProcQ get sleep queue ptr
 beq Slice branch if queue empty
 lda P$State,X get process state
 bita #TimSleep timed-sleep state?
 beq Slice branch if not
 ldu P$SP,X get process stack ptr
 ldd R$X,u get sleep time
 subd #1 count tick
 std R$X,u update time
 bne Slice branch if not expired
Tick.A ldu P$Queue,X get next queue ptr
 bsr ActvProc make process active
 leax 0,u copy next queue ptr
 beq Tick.B branch if none
 lda P$State,X get process state
 bita #TimSleep timed-sleep state
 beq Tick.B branch if not
 ldu P$SP,X get process stack ptr
 ldd R$X,u get sleep time
 beq Tick.A branch if expired
Tick.B stx D.SProcQ update queue ptr
*
*     fall through to Slice
*
Slice dec D.Slice Count tick
 bne Slic.a Branch if slice not over
 inc D.Slice reset to last tick of slice
 ldx D.Proc get current process ptr
 beq Slic.a branch if none
 lda P$State,X get process state
 ora #TIMOUT set time-out flag
 sta P$State,X update state
Slic.a clrb clear carry
 rts
 page
***********************************************************
*
*     Subroutine AProc
*
*   Put process in Active Process Queue Service routine
*
* Input: U = Registers ptr
*
* Output: Carry clear
*
* Data: none
*
* Calls: ActvProc
*
AProc ldx R$X,u get process ptr
*
*     fall through to ActvProc
*
***********************************************************
*
*     Subroutine ActvProc
*
*   Put process in Active Process Queue
*
* Input: X = Process Descriptor ptr
*
* Output: Carry clear
*
* Data: D.AProcQ
*
* Calls: none
*
ActvProc    clrb
         pshs  u,y,x,cc
         lda   $0A,x
         sta   $0B,x
         orcc  #$50
         ldu   #$0045
         bra   L0DD1
L0DC7    inc   $0B,u
         bne   L0DCD
         dec   $0B,u
L0DCD    cmpa  $0B,u
         bhi   L0DD3
L0DD1    leay  ,u
L0DD3    ldu   $0D,u
         bne   L0DC7
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         puls  pc,u,y,x,cc

UserIRQ         ldx   D.Proc
         sts   $04,x
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         jsr   [>$00CE]
         bcc   UserRet
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,x
         lbsr  LDABX
         ora   #$50
         lbsr  STABX

UserRet    orcc  #$50
         ldx   D.Proc
         ldu   $04,x
         lda   $0C,x
         bita  #$20
         beq   CurrProc
UsrRet.a    anda  #$DF
         sta   $0C,x
         lbsr  DelPrTsk
L0E16    bsr   ActvProc

NextProc ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #$AF
         bra   L0E25
L0E23    cwai  #$AF
L0E25    orcc  #$50
         ldy   #$0045
         bra   L0E2F
L0E2D    leay  ,x
L0E2F    ldx   $0D,y
         beq   L0E23
         lda   $0C,x
         bita  #$08
         bne   L0E2D
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  AllPrTsk
         bcs   L0E16
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   $0C,x
         bmi   SysRet
CurrProc    bita  #$02
         bne   KillProc
         lbsr  ChkPrTsk
         ldb   <$19,x
         beq   L0E87
         decb
         beq   CurrPr20
         leas  -$0C,s
         leau  ,s
         lbsr  GetRegs
         lda   <$19,x
         sta   $02,u
         ldd   <$1A,x
         beq   KillProc
         std   $0A,u
         ldd   <$1C,x
         std   $08,u
         ldd   $04,x
         subd  #$000C
         std   $04,x
         lbsr  PutRegs
         leas  $0C,s
         ldu   $04,x
         clrb
CurrPr20    stb   <$19,x
L0E87    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  SvcRet
KillProc    lda   $0C,x
         ora   #$80
         sta   $0C,x
         leas  >$0200,x
         andcc #$AF
         ldb   <$19,x
         clr   <$19,x
         os9   F$Exit

SysIRQ    jsr   [>$00CE]
         bcc   L0EB3
         ldb   ,s
         orb   #$50
         stb   ,s
L0EB3    rti

SysRet    ldx   D.SysPrc
         lbsr  ChkPrTsk
         leas  ,u
         rti

GoPoll    jmp   [>$0026]
IOPoll    orcc  #$01
         rts


***********************************************************
*
*     Routine DATInit
*
* The DAT register map starts at $FF80 and uses 2 KB blocks. It therefore
* has 32 sections mapped with a 16 bit word. I.e. the DAT RAM is located
* at the address range $FF80 to $FFBF. In the 16 bit word, the bottom 9 bits
* selects a 2 KB block. Bit 9 is write-enable and must be set for RAM.
*
DATInit         clra
         tfr   a,dp
         ldu   #$FFC8
         ldb   #$07
KVInit    stb   ,-u
         decb
         bne   KVInit
         leay  ,-u

* Map top 4 KB of ROM to $F800 and $F000
         ldx   #$01FF
         ldb   #$02
L0ED7    stx   ,--y
         leax  -$01,x
         decb
         bne   L0ED7
         ldx   #$0350
         stx   ,--y
         ldx   #$0340
         stx   ,--y
         ldb   #$19
         ldx   #$015F
L0EED    stx   ,--y
         decb
         bne   L0EED
         ldd   #$0202
L0EF5    std   ,--y
         decb
         bpl   L0EF5
         clra
         sta   ,u
         ldb   >$E900
         tstb
         lbpl  COLD

         ldx   D.SysDAT
         ldy   #DAT.Regs
L0F0B    lda   ,x+
         sta   ,y+
         cmpy  #$FFC0
         bne   L0F0B
         ldx   D.Proc
         lda   $0C,x
         ora   #$80
         sta   $0C,x
         leas  >$0200,x
         andb  #$7F
         rolb
         rolb
         rolb
         rolb
         andb  #$03
         cmpb  #$03
         bne   L0F2F
         ldb   #$02
L0F2F    addb  #$64
         andcc #$AF
         os9   F$Exit

SvcRet ldb P$Task,x get task number
 orcc #IntMasks set interrupt masks
 stb DAT.Task switch to task
 leas 0,u move stack ptr
 ldb #2
 stb DAT.Fuse delay switching to user task until rti is executed
 rti

PassSWI ldb P$Task,x get process task
 stb DAT.Task switch to task
 ldb #3
 stb DAT.Fuse delay switching to user task until jmp is executed
 jmp 0,u go to user routine

SWI3RQ orcc #IntMasks set interrupt masks
 ldb #D.SWI3 get direct page offset
 bra Switch

SWI2RQ orcc #IntMasks set interrupt masks
 ldb #D.SWI2 get direct page offset
 bra Switch

FIRQ ldb #D.FIRQ get direct page offset
 bra Switch

IRQ orcc #IntMasks set fast interrupt masks
 ldb #D.IRQ get direct page offset
Switch equ *
 lda #SysTask get system task number
 sta DAT.Task set system memory
 clra
 tfr a,dp clear direct page register
 tfr d,x copy direct page ptr
 jmp [0,x] go through vector

SWIRQ ldb #D.SWI get direct page offset
 bra Switch

NMIRQ ldb #D.NMI get direct page offset
 bra Switch
 page
 emod
OS9End equ *

 fcb $39,$39,$39,$39
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 fcb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

offset set $FFE0-*

HdlrVec fdb Tick+offset
 fdb UserSWI3+offset
 fdb UserSWI2+offset
 fdb offset
 fdb UserIRQ+offset
 fdb UserSWI+offset
 fdb offset
 fdb offset

***********************************************************
*
*     System Interrupt Vectors
*
 fdb offset
 fdb SWI3RQ+offset
 fdb SWI2RQ+offset
 fdb FIRQ+offset
 fdb IRQ+offset
 fdb SWIRQ+offset
 fdb NMIRQ+offset
 fdb DATInit+offset

ROMEnd equ *

 end
