 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from Fujitsu FM-11 computer
* This kernal uses two bytes per block in BlkMap
********************************

************************************************************
*                                                          *
*           OS-9 Level II V1.2 - Kernal, part 1            *
*                                                          *
* Copyright 1982 by Microware Systems Corporation          *
* Reproduced Under License                                 *
*                                                          *
* This source code is the proprietary confidential prop-   *
* erty of Microware Systems Corporation, and is provided   *
* to the licensee solely for documentation and educational *
* purposes. Reproduction, publication, or distribution in  *
* any form to any party other than the licensee is         *
* is strictly prohibited !!!                               *
*                                                          *
************************************************************

*****
*
*  Module Header
*
 use defsfile

Revs set REENT+1
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam   fcs   /OS9p1/

************************************************************
*
*     Edition History
*
* Edition $28 - Beginning of history
*   pre-82/8/10
*
* Edition   1 - Addition of 6829 modifications
*   82/8/10
*
* Edition   2 - Addition of Profitel & Gimix2 CPU types
*   82/10/1
*
* Edition   3 - changes in timing of process state flag switching
*   82/11/6
*
* Edition   4 -
*             - change "AllImage to set DAT image change flag after
*               actually changing the image
*             - change "Slice" to not decrement "D.Slice" below zero
*
* Edition   5 - change "SetImage" to set DAT image change flag after
*   83/01/20    actually changing the image
*
* Edition   6 - complete changes for write-protecting modules
*   83/01/26  - change initialization for Positron systems

 fcb 13
 fcc "FM11L2"

LORAM set $20
HIRAM set $1000

COLD ldx #LORAM Set ptr
 ldy #HIRAM-LORAM Set byte count
 clra CLEAR D
 clrb
COLD05 std ,X++ Clear system memory block
 leay -2,Y Count down
 bne COLD05
 inca ONE Page for direct page
 std D.Tasks     Start at $100
 addb #DAT.TkCt Number of task maps
 std D.TmpDAT
 clrb
 inca
 std D.BlkMap    Base address for block map
 adda #DAT.BMSz/256
 std D.BlkMap+2
 std D.SysDis   Base address for System Service Dispatch Table
 inca
 std D.UsrDis
 inca Allocate 256 bytes for User Service Dispatch Table
 std D.PrcDBT
 inca
 std D.SysPrc
 std D.Proc
 adda #2 Allocate 512 bytes for stack
 tfr D,S
 inca Allocate 256 bytes for System Stack
 std D.SysStk    Start at $900
 std D.SysMem
 inca
 std D.ModDir
 std D.ModEnd
 adda #6
 std D.ModDir+2
 std D.ModDAT
 leax >JMPMINX,pcr
 tfr x,d
 ldx #D.SWI3
COLD06 std ,x++
 cmpx #D.NMI
 bls COLD06
 leax ROMEnd,PCR get vector offset
 pshs x
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
 leax SYSREQ,PCR Get system service routine
 stx D.SysSVC
 stx D.XSWI2 Set service to system state
 leax SYSIRQ,PCR Get system interrupt routine
 stx D.SysIRQ
 stx D.XIRQ
 leax SVCIRQ,pcr
 stx D.SvcIRQ Set interrupts to system state
 leax IOPOLL,PCR Set irq polling routine
 stx D.POLL
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
 stx D.SysDAT
*
* Set up memory blocks in system DAT image
*
 clra
 clrb
 std ,X++ Mark block 0 in SysDAT
 ldy #13        Dat.BlCt-RAMCount-ROMCount-IOCount
 ldd #DAT.Free  Initialize the rest of the blocks to be free
COLD10 std ,X++
 leay -1,Y
 bne COLD10
         ldd   #$0001  ?? type of block ROM?
 std ,X++
 ldb #IOBlock Mark IO block (Note: LDB)
 std ,X++
 ldx D.Tasks
 inc 0,X  Reserve task 0
 ldx D.SysMem
 ldb D.ModDir+2
COLD15 inc ,X+
 decb
 bne COLD15
*
* Map every physical block into block 1 to see if there is RAM
*
 ldy #HIRAM
 ldx D.BlkMap
COLD20 pshs X
 ldd 0,S
 subd D.BlkMap
 cmpb #DAT.BlMx Last block?
 beq COLD25 ..yes
 stb DAT.Regs+1
 ldu 0,y Get current value
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

COLD25 ldb #NotRAM
 stb [,s]
COLD30 puls X
 leax 1,X
 cmpx D.BlkMap+2
 bcs COLD20
 ldx D.BlkMap
 inc 0,X
         lda   #$80
         sta   1,x
COLD35    lda  0,x
 beq COLD60
 tfr X,D
 subd D.BlkMap
 leas -32,S
 leay 0,S
 lbsr COLD90
 pshs X
 ldx #$0000
         cmpb  #$FF
         bne   COLD40
         ldx   #$0800
COLD40 pshs Y,X
 lbsr ADJBLK jump to next block?
 ldb 1,Y
 stb DAT.Regs
         ldd   ,x
         clr   DAT.Regs
         puls  y,x
         cmpd  #$87CD
         beq   COLD44
         puls  x
         bra   COLD57
COLD42    pshs  y,x
         lbsr  ADJBLK
         ldb   1,y
         stb   DAT.Regs
         lda   ,x
 clr DAT.Regs
 puls Y,X
 cmpa #M$ID1
 bne COLD50
COLD44    lbsr  VALMOD
 bcc COLD45
 cmpb #E$KwnMod Is it a known module
 bne COLD50
COLD45 ldd #M$Size Get module size
 lbsr F.LDDDXY
 leax D,X Skip module
 bra COLD55
COLD50 leax 1,X Try next location
COLD55 tfr X,D
 tstb
         bne   COLD42
 bita #$0F   at $0F00?
         bne   COLD42
 lsra Calculate block number
 lsra
 lsra
 lsra
 deca
 puls X
 leax A,X
COLD57    leas 32,S Make space on stack
COLD60 leax 1,X
 cmpx D.BlkMap+2
 bcs COLD35

COLD65 leax CNFSTR,pcr Get initial module name ptr
 bsr LINKTO Link to configuration module
 bcc COLD70
 os9 F$Boot
 bcc COLD65
 bra COLD80

COLD70 stu D.Init
COLD75 leax OS9STR,pcr
 bsr LINKTO
 bcc COLD85
 os9 F$Boot
 bcc COLD75
COLD80    jmp   [>$FFFE]

COLD85 jmp 0,Y Let os9 part two finish

LINKTO lda #SYSTM Get system type module
 os9 F$Link
 rts

* Copies value on stack to all positions in block
COLD90 pshs Y,X,D
 ldb #DAT.BlCt  blocks/address space
 ldx 0,S
COLD95 stx ,Y++
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
 fdb VMOD-*-2
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
 fdb LDAXY-*-2
 fcb F$LDDDXY+$80
 fdb LDDDXY-*-2
 fcb F$LDABX+$80
 fdb LDABX-*-2
 fcb F$STABX+$80
 fdb STABX-*-2
 fcb F$ELink+$80
 fdb ELINK-*-2
 fcb F$FModul+$80
 fdb FMODUL-*-2
 fcb $80

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name
BTSTR fcs /Boot/

JMPMINX jmp [<(D.XSWI3-D.SWI3),x] Jump to the "x" version of the interrupt

*****
*
*  Swi3 Handler
*
SWI3HN ldx D.Proc
 ldu P$SWI3,X
 beq USRIRQ No user-supplied interrupt handler

USRSWI    lbra  PassSWI+$1000

*****
*
*  Swi2 Handler
*
SWI2HN ldx D.Proc
 ldu P$SWI2,X
 beq USRIRQ No user-supplied interrupt handler
 bra USRSWI

*****
*
*  Swi Handler
*
SWIHN ldx D.Proc
 ldu P$SWI,X
 bne USRSWI

*****
*
*  Interrupt Service Routine Usrirq
*
* Handles Irq While In User State
*
* Entry: X=Process descriptor pointer of process that made system call
*
USRIRQ ldd D.SysSvc Get system request routine
 std D.XSWI2
 ldd D.SysIRQ Get system irq routine
 std D.XIRQ
 lda P$State,X
 ora #SysState
 sta P$State,X
 sts P$SP,X
 leas (P$Stack-R$Size),X
 andcc #^IntMasks
 leau 0,S
 bsr CpySP2U
 ldb P$Task,X
 ldx R$PC,U
         lbsr  H.LDBBX+$1000
 leax 1,X Increment X
 stx R$PC,U
 ldy D.UsrDis
 lbsr DISPCH Go do request
 ldb R$CC,U get condition code
 andb #^IntMasks
 stb R$CC,U update condition codes
 ldx D.Proc
 bsr CpyU2SP
 lda P$State,X Clear system state
 anda #^SysState
 lbra IRQHN20

* Copy 12 bytes from user task to SysTask
CpySP2U lda P$Task,X
 ldb D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 bra CPY10

* Copy 12 bytes from SysTask to U in Task B
CpyU2SP ldb P$Task,X
 lda D.SysTsk
 pshs U,Y,X,DP,D,CC
 ldx P$SP,X
 exg X,U
CPY10 ldy #R$Size/2
 tfr B,DP
 orcc #IntMasks
         lbra  MOVER20+$1000

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
SYSREQ leau 0,S Copy stack ptr
 lda R$CC,U
 tfr a,cc
*
* Get Service Request Code
*
 ldx R$PC,U Get program counter
 ldb ,X+ Get service code
 stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr DISPCH Call service routine
 lbra SYSRET

DISPCH aslb SHIFT For two byte table entries
 bcc DISP10 Branch if not i/o
 rorb RE-ADJUST Byte
 ldx IOEntry,y Get i/o routine
 bra DISP20
DISP10 clra
 ldx D,Y Get routine address
 bne DISP20 Branch is not null
 comb SET Carry
 ldb #E$UnkSvc Unknown service code
 bra DISP25
DISP20 pshs u Save register ptr
 jsr 0,X Call routine
 puls u Retrieve register ptr
*
* Return Condition Codes To Caller
*
DISP25 tfr cc,a Copy condition codes
 bcc DISP30
 stb R$B,u
DISP30 ldb R$CC,U Get condition codes
 andb #$D0 Clear h, n, z, v, c
 stb R$CC,U Save it
 anda #$2F Clear e, f, i
 ora R$CC,U Return conditions
 sta R$CC,U
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

SETS10 clra
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
 bne SETS10 Branch if not
 rts
 page

SLINK    ldy   R$Y,u
         bra   LINK05

ELINK    pshs  u
         ldb   R$B,u
         ldx   R$X,u
         bra   LINK10
LINK     ldx   D.Proc
         leay  P$DATImg,x
LINK05    pshs  u
         ldx   R$X,u
         lda   R$A,u
         lbsr  F.FMODUL
         lbcs  LINKXit
         leay  ,u
         ldu   ,s
         stx   R$X,u
         std   R$D,u
         leax  ,y
LINK10    bitb  #$80
         bne   LINK20
         ldd   $06,x
         beq   LINK20
 ldb #E$ModBsy err: module busy
         bra   LINKXit
LINK20    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
         addd  #DAT.BlSz-1
         tfr   a,b
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         adda  #$04
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         pshs  a
         leau  ,y
         bsr   LINK70
         bcc   LINK40
         lda   ,s
         lbsr  F.FREEHB
         bcc   LINK30
         leas  $05,s
         ldb   #$CF
         bra   LINKXit
LINK30    lbsr  F.SETIMG
LINK40    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  1,x
         beq   LINK50
         stx   ,u
LINK50    ldu   $03,s
         ldx   $06,u
         leax  1,x
         beq   LINK60
         stx   $06,u
LINK60    puls  u,y,x,b
         lbsr  F.DATLOG
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  F.LDDDXY
         addd  $08,u
         std   $06,u
         clrb
         rts

LINKXit orcc #CARRY
 puls pc,u

LINK70    ldx   D.Proc
         leay  P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #$10
         negb
         lslb
         leay  b,y
LINK80    ldx   ,s
         pshs  u,y
LINK85    ldd   ,y++
         cmpd  ,u++
         bne   LINK90
         leax  -1,x
         bne   LINK85
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a

LINK90    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   LINK80
         puls  pc,y,x,b,a

*****
*
*  Subroutine Valmod
*
* Validate Module
*
VMOD pshs U Save register ptr
 ldx R$X,U Get new module ptr
 ldy R$D,u
 bsr VALMOD Validate module
 ldx 0,s  Retrieve register ptr
 stu R$U,x Return directory entry
 puls pc,u

VALMOD pshs  y,x Save registers
 lbsr IDCHK Check sync & chksum
 bcs   BADVAL
 ldd   #M$Type
 lbsr  F.LDDDXY
 andb  #Revsmask
 pshs  b,a
 ldd   #M$Name
 lbsr  F.LDDDXY
 leax  d,x
 puls  a
 lbsr  F.FMODUL
 puls  a
         bcs   VMOD20
 pshs  a
 andb  #Revsmask
 subb  ,s+
         bcs   VMOD20
         ldb   #$E7
         bra   BADVAL
VMOD10 ldb #E$DirFul Err: directory full
BADVAL orcc #CARRY SET Carry
 puls pc,y,x

VMOD20    ldx   ,s
         lbsr  VMOD70
         bcs   VMOD10
         sty   ,u
         stx   R$X,u
         clra
         clrb
         std   $06,u
         ldd   #$0002
         lbsr  F.LDDDXY
         pshs  x
         addd  ,s++
         std   $02,u
         ldy   [,u]
         ldx   D.ModDir
         pshs  u
         bra   VMOD32
VMOD30    leax  $08,x
VMOD32    cmpx  D.ModEnd
         bcc   VMOD35
         cmpx  ,s
         beq   VMOD30
         cmpy  [,x]
         bne   VMOD30
         bsr   VMOD50
VMOD35    puls  u
         ldx   D.BlkMap
         ldd   $02,u
         addd  #DAT.BlSz-1
         lsra
         lsra
         lsra
         lsra
         ldy   ,u
VMOD40    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02   ModBlock
         stb   ,x
         puls  x,a
         deca
         bne   VMOD40
         clrb
         puls  pc,y,x
VMOD50    pshs  u,y,x,b,a
         ldx   ,x
         pshs  x
         clra
         clrb
VMOD55    ldy   ,x
         beq   VMOD57
         std   ,x++
         bra   VMOD55
VMOD57    puls  x
         ldy   $02,s
         ldu   ,u
         puls  b,a
VMOD60    cmpx  ,y
         bne   VMOD68
         stu   ,y
         cmpd  $02,y
         bcc   VMOD65
         ldd   $02,y
VMOD65    std   $02,y
VMOD68    leay  $08,y
         cmpy  D.ModEnd
         bne   VMOD60
         puls  pc,u,y,x
VMOD70    pshs  u,y,x
         ldd   #$0002
         lbsr  F.LDDDXY
         addd  ,s
         addd  #DAT.BlSz-1
         lsra
         lsra
         lsra
         lsra
         tfr   a,b
         pshs  b
         incb
         lslb
         negb
         sex
         bsr   VMOD80
         bcc   VMOD79
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   VMOD80
VMOD79    puls  pc,u,y,x,b
VMOD80    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   VMODERR
         ldu   $07,s
         bne   VMOD85
         pshs  x
         ldy   D.ModEnd
         leay  $08,y
         cmpy  ,s++
         bhi   VMODERR
         sty   D.ModEnd
         leay  -$08,y
         sty   $07,s
VMOD85    stx   D.ModDAT
         ldy   $05,s
         ldb   $02,s
         stx   $05,s
VMOD88    ldu   ,y++
         stu   ,x++
         decb
         bne   VMOD88
         clr   ,x
         clr   1,x
         rts
VMODERR    orcc  #$01
         rts

IDCHK    pshs  y,x
         clra
         clrb
         lbsr  F.LDDDXY
 cmpd #M$ID12 Check them
         beq   PARITY
         ldb   #$CD
         bra   CRCC20
PARITY    leas  -1,s
         leax  $02,x
         lbsr  ADJBLK
 ldb #M$IDSize-2
 lda #(M$ID1!M$ID2)-(M$ID1&M$ID2)   M$ID1 xor M$ID2
PARI10 sta 0,S
 lbsr GETBYTE
         eora  ,s
         decb
         bne   PARI10
         leas  1,s
         inca
         beq   IDCH30
         ldb   #$EC
         bra   CRCC20
IDCH30    puls  y,x
         ldd   #$0002
         lbsr  F.LDDDXY
         pshs  y,x,b,a
         ldd   #$FFFF
         pshs  b,a
         pshs  b
         lbsr  ADJBLK
         leau  ,s
CRCC05    tstb
         bne   CRCC10
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
CRCC10    lbsr  GETBYTE
         bsr   CRCCAL
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   CRCC05
         puls  y,x,b
         cmpb  #$80
         bne   CRCC15
         cmpx  #$0FE3
         beq   CRCC30
CRCC15    ldb   #$E8
CRCC20    orcc  #$01
CRCC30    puls  pc,y,x


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
         beq   CRCGen20
         ldx   R$X,u
         pshs  x,b,a
         leas  -$03,s
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         ldx   $08,u
         ldy   #$0003
         leau  ,s
         pshs  y,x,b,a
         lbsr  F.MOVE
         ldx   D.Proc
         leay  P$DATImg,x
         ldx   $0B,s
         lbsr  ADJBLK
CRCGen10    lbsr  GETBYTE
         lbsr  CRCCAL
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   CRCGen10
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  F.MOVE
         leas  $07,s
CRCGen20    clrb
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

*****
* Find Module directory
*
FMODUL pshs u
 lda R$A,u
 ldx R$X,u
 ldy R$Y,u
 bsr F.FMODUL
 puls y
 std R$D,y
 stx R$X,y
 stu R$U,y
 rts

F.FMODUL ldu #0 Return zero if not found
 pshs u,D
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModDir Get module directory ptr
         bra   FMOD33
FMOD10    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   FMOD20
         ldx   R$X,u
         pshs  y,x
         ldd   #$0004
         lbsr  F.LDDDXY
         leax  d,x
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  F.CHKNAM
         leas  $04,s
         puls  y,x
         leas  $04,s
         bcs   FMOD30
         ldd   #$0006
         lbsr  F.LDDDXY
         sta   ,s
         stb   $07,s
         lda   $06,s
         beq   FMOD16
         anda  #$F0
         beq   FMOD14
         eora  ,s
 anda #TypeMask
 bne FMOD30 Branch if different
FMOD14 lda 6,S Get desired language
 anda #LangMask
 beq FMOD16 Branch if any
         eora  ,s
         anda  #$0F
         bne   FMOD30
FMOD16    puls  y,x,b,a
         abx
         clrb
         ldb   1,s
         leas  $04,s
         rts
FMOD20    leas  $04,s
         ldd   $08,s
         bne   FMOD30
         stu   $08,s
FMOD30    puls  y,x,b,a
         leau  $08,u
FMOD33    cmpu  D.ModEnd
         bcs   FMOD10
         comb
         ldb   #E$MNF
         bra   FMOD40
FMOD35 comb SET Carry
         ldb   #E$BNam
FMOD40    stb   1,s
         puls  pc,u,b,a

* Skip spaces
SKIPSP    pshs  y
SKIP10    lbsr  ADJBLK
         lbsr  H.LDAXY
         leax  1,x
         cmpa  #$20
         beq   SKIP10
         leax  -1,x
         pshs  a
         tfr   y,d
         subd  1,s
         asrb
         lbsr  F.DATLOG
         puls  pc,y,a

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
 leay P$DATImg,x
 ldx R$X,u Get string ptr
 bsr PRSNAM Call parse name
 std R$D,U Return byte & size
 bcs PNam.x branch if error
 stx R$X,U Return updated string ptr
 abx
PNam.x stx R$Y,U Return name end ptr
 rts

PRSNAM    pshs  y
         lbsr  ADJBLK
         pshs  y,x
         lbsr  GETBYTE
 cmpa #'/ Slash?
 bne PRSNA1 ..no
         leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA1    bsr   ALPHA
         bcs   PRSNA4
         clrb
PRSNA2 incb INCREMENT Character count
         tsta
         bmi   PRSNA3
         lbsr  GETBYTE
         bsr   ALFNUM
         bcc   PRSNA2
PRSNA3    andcc #^CARRY clear carry
         bra   L0724
PRSNA4    cmpa  #$2C
         bne   PRSNA6
PRSNA5    leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 comb (NAME Not found)
 ldb #E$BNam
L0724    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  F.DATLOG
         puls  pc,y,b,a,cc

ALFNUM    pshs  a
         anda  #$7F
         cmpa  #$2E
         beq   RETCC
         cmpa  #$30
         bcs   RETCS
         cmpa  #$39
         bls   RETCC
         cmpa  #$5F
         bne   ALPHA10
RETCC    clra
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

CMPNAM   ldx   D.Proc
         leay  P$DATImg,x
         ldx   R$X,u
         pshs  y,x
         bra   F.CMPNAM

SCMPNAM  ldx   D.Proc
         leay  P$DATImg,x
         ldx   R$X,u
         pshs  y,x
         ldy   D.SysDAT
F.CMPNAM    ldx   $06,u
         pshs  y,x
         ldd   R$D,u
         leax  $04,s
         leay  ,s
         bsr   F.CHKNAM
         leas  $08,s
         rts

F.CHKNAM    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  ADJBLK
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  ADJBLK
         bra   CHKN15

CHKN10    ldu   $04,s
         pulu  y,x
CHKN15    lbsr  GETBYTE
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  GETBYTE
         pshu  y,x
         eora  ,s
         tst   ,s+
 bmi CHKN20 Branch if last module char
 decb DECREMENT Char count
 beq RETCS1 Branch if last character
 anda #$FF-$20 Match upper/lower case
 beq CHKN10 ..yes; repeat
RETCS1 comb Set carry
 puls  PC,U,Y,X,D
CHKN20    decb
         bne   RETCS1
         anda  #$5F
         bne   RETCS1
         clrb
         puls  pc,u,y,x,b,a

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
         ldy   D.SysMem
         leas  -$02,s
         stb   ,s
L07D7    ldx   D.SysDAT
         lslb
         ldd   b,x
         cmpd  #DAT.Free
         beq   L07EF
         ldx   D.BlkMap
         lda   d,x
         cmpa  #$01   RAMinUse
         bne   L07F0
         leay  <$10,y
         bra   L07F7
L07EF    clra
L07F0    ldb   #$10
L07F2    sta   ,y+
         decb
         bne   L07F2
L07F7    inc   ,s
         ldb   ,s
         cmpb  #$10
         bcs   L07D7
L07FF    ldb   1,u
L0801    cmpy  D.SysMem
         bhi   L080B
         comb
         ldb   #$CF
         bra   L083A
L080B    lda   ,-y
         bne   L07FF
         decb
         bne   L0801
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
         andb  #$0F
         addb  1,u
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
 ifge DAT.BlSz-$2000
         lsrb
 endc
         ldx   D.SysPrc
         lbsr  F.ALLIMG
         bcs   L083A
         ldb   1,u
L0830    inc   ,y+
         decb
         bne   L0830
         lda   1,s
         std   $08,u
         clrb
L083A    leas  $02,s
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
 ldb R$U+1,u Is address on page boundary?
 beq SRTM10 yes
 comb
 ldb #E$BPAddr
 rts

SRTM10    ldb   $08,u
         beq   SRTMXX
         ldx   D.SysMem
         abx
L0853    ldb   ,x
         andb  #$FE
         stb   ,x+
         deca
         bne   L0853
         ldx   D.SysDAT
         ldy   #$0010
L0862    ldd   ,x
         cmpd  #DAT.Free
         beq   L0891
         ldu   D.BlkMap
         lda   d,u
         cmpa  #$01  RAMinUse
         bne   L0891
         tfr   x,d
         subd  D.SysDAT
         lslb
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #$10
L087F    lda   ,u+
         bne   L0891
         decb
         bne   L087F
         ldd   ,x
         ldu   D.BlkMap
         clr   d,u
         ldd   #DAT.Free
         std   ,x
L0891    leax  $02,x
         leay  -1,y
         bne   L0862
SRTMXX    clrb
         rts

*****
BOOT comb set carry
 lda D.Boot
 bne BOOTXX Don't boot if already tried
 inc D.Boot
 ldx D.Init
 beq BOOT05 No init module
 ldd BootStr,X
 beq BOOT05 No boot string in init module
 leax D,X Get name ptr
 bra BOOT06
BOOT05 leax  BTSTR,pcr
BOOT06 lda #SYSTM+OBJCT get type
 OS9 F$LINK find bootstrap module
 bcs BOOTXX Can't boot without module
 jsr 0,Y Call boot entry
 bcs BOOTXX Boot failed
 leau D,X
 tfr X,D
 anda #$F0     ?????
 clrb
 pshs u,D
 lsra
 lsra
 lsra
 ifge DAT.BlSz-$2000
 lsra
 endc
 ldy D.SysDAT
 leay a,Y
BOOT10 ldd 0,X get module beginning
 cmpd #M$ID12 is it module sync code?
 bne BOOT20 branch if not
 tfr X,D
 subd 0,S
 tfr D,X
 tfr Y,D
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
L090A    leay  ,x
         ldb   1,s
L090E    cmpx  D.BlkMap+2
         bcc   ALRAMERR
         lda   ,x+
         bne   L090A
         decb
         bne   L090E
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   1,s
         stb   1,s
L0923    inc   ,y+
         deca
         bne   L0923
         clrb
         puls  pc,y,x,b,a

ALRAMERR    comb
         ldb   #$ED
         stb   1,s
         puls  pc,y,x,b,a

ALLIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
F.ALLIMG    pshs  u,y,x,b,a
         lsla
         leay  P$DATImg,x
         leay  a,y
         clra
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
ALLIMG10    ldd   ,y++
         cmpd  #DAT.Free
         beq   ALLIMG20
         lda   d,u
         cmpa  #$01   #RAMinUse
         puls  b,a
         bne   ALLIMG50
         subd  #1
         pshs  b,a
ALLIMG20    leax  -1,x
         bne   ALLIMG10
         ldx   ,s++
         beq   ALLIMG60
ALLIMG30    lda   ,u+
         bne   ALLIMG40
         leax  -1,x
         beq   ALLIMG60
ALLIMG40    cmpu  D.BlkMap+2
         bcs   ALLIMG30
ALLIMG50    ldb   #E$MemFul
         leas  $06,s
         stb   1,s
         comb
         puls  pc,u,y,x,b,a

ALLIMG60    puls  u,y,x
ALLIMG65    ldd   ,y++
         cmpd  #DAT.Free
         bne   ALLIMG70
ALLIMG68    lda   ,u+
         bne   ALLIMG68
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         std   -$02,y
ALLIMG70    leax  -1,x
         bne   ALLIMG65
 ldx 2,S Get process ptr
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
         sta   R$A,u
FRHB10    rts

FRHB20    tfr   b,a
F.FREEHB    suba  #$11
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   FREEBLK

*****
* Get Free low block
*
FREELB   ldb   R$B,u Get block count
         ldy   R$Y,u DAT image pointer
         bsr   L09C3
         bcs   L09C2
         sta   R$A,u
L09C2    rts

L09C3    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$11  DAT.BlCt+1
         negb
         pshs  b,a
         bra   FREEBLK

FREEBLK    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  1,s
         bne   L09E6
         ldb   #$CF
         stb   $03,s
         comb
         bra   L09F3
L09E2    tfr   a,b
         addb  $02,s
L09E6    lslb
         ldx   b,y
         cmpx  #DAT.Free
         bne   FREEBLK
         inca
         cmpa  $03,s
         bne   L09E2
L09F3    leas  $02,s
         puls  pc,x,b,a

SETIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
         ldu   R$U,u New image pointer
F.SETIMG    pshs  u,y,x,b,a
         leay  P$DATImg,x
         lsla
         leay  a,y
L0A05    ldx   ,u++
         stx   ,y++
         decb
         bne   L0A05
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

*****
* Convert DAT block/offset to logical address
*
DATLOG   ldb   R$B,u
         ldx   R$X,u
         bsr   F.DATLOG
         stx   R$X,u
         clrb
         rts

* Convert offset into real address
* Input: B, X
* Effect: updated X
F.DATLOG pshs X,D
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

LDAXY    ldx   R$X,u
         ldy   R$Y,u
         bsr   ADJBLK
         bsr   H.LDAXY
         sta   R$A,u
         clrb
         rts
* Get byte from other DAT
* Input: X - location
*        Y - DAT image number
H.LDAXY    pshs  cc
         lda   1,y
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,cc

* Get byte and increment X
* Input: X - location
*        Y - DAT image number
* Output: A - result
GETBYTE    lda   1,y
         pshs  cc
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x+
         clr   DAT.Regs
         puls  cc
         bra   ADJBLK

ADJBLK10 leax >-DAT.BlSz,X
 leay 2,Y
ADJBLK cmpx #DAT.BlSz
 bcc ADJBLK10
 rts

*****
* Load D [D+X],[Y]]
* Loads two bytes from the address space described by the DAT image
* pointed to by Y.
*
LDDDXY ldd R$D,u Offset to the offset within DAT image
 leau 4,U
 pulu Y,X
 bsr F.LDDDXY
 std -7,U
 clrb
 rts

*****
* Get word at D offset into X
F.LDDDXY pshs Y,X
 leax D,X
 bsr ADJBLK
 bsr GETBYTE
 pshs A
 bsr H.LDAXY
 tfr A,B
 puls PC,Y,X,A

*****
* Load A from 0,X in task B
*
LDABX ldb R$B,u Task number
 ldx R$X,u Data pointer
         lbsr  H.LDABX+$1000
 sta R$A,U
 rts

*****
* Store A at 0,X in task B
*
STABX ldd R$D,U
 ldx R$X,U
         lbra  H.STABX+$1000

****
* Move data (low bound first)
*
MOVE ldd R$D,u Source and destination task number
 ldx R$X,u Source pointer
 ldy R$Y,u Byte count
 ldu R$U,u Destination pointer
F.MOVE andcc #^CARRY clear carry
 leay 0,y How many bytes to move?
 beq MOVE10 ..branch if zero
 pshs U,Y,X,DP,D,CC
 tfr Y,D
 lsra Divide number of bytes by 2
 rorb
 tfr D,Y
 ldd 1,S
 tfr B,DP
         lbra  MOVER00+$1000
MOVE10    rts

ALLTSK   ldx   R$X,u
F.ALLTSK    ldb   $06,x
         bne   ALLTSK10
         bsr   F.RESTSK
         bcs   TSKRET
         stb   $06,x
         bsr   F.SETTSK
ALLTSK10    clrb
TSKRET    rts

DELTSK   ldx   R$X,u
F.DELTSK    ldb   $06,x
         beq   TSKRET
         clr   $06,x
         bra   F.RELTSK

* Did task image change?
UPDTSK lda P$State,x
 bita #ImgChg
 bne F.SETTSK
 rts

SETTSK   ldx   R$X,u
F.SETTSK    lda   $0C,x
         anda  #$EF
         sta   $0C,x
         andcc #^CARRY clear carry
         pshs  u,y,x,b,a,cc
         ldb   $06,x
         leax  P$DATImg,x
         ldy   #$0010
         ldu   #DAT.Regs
         lbra  SETDAT00+$1000 Copy DAT image to DAT registers

*****
* Reserve Task Number
* Output: B = Task number
RESTSK bsr F.RESTSK
 stb R$B,u Set task number
 rts

* Find free task and reserve it
F.RESTSK pshs x
 ldb #1
 ldx D.Tasks
RESTSK10 lda B,X
 beq RESTSK20
 incb
 cmpb #DAT.TkCt Last task slot?
 bne RESTSK10 ..yes
 comb
 ldb #E$NoTask
 bra RESTSK30
RESTSK20 inc b,x Mark occupied
 orb D.SysTsk
 clra
RESTSK30 puls PC,X

*****
* Release Task number
*
RELTSK ldb R$B,u Task number
F.RELTSK pshs x,b
 ldb D.SysTsk
 comb
 andb 0,S
 beq RELTSK20
 ldx D.Tasks
 clr B,X
RELTSK20 puls PC,x,b

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
 bsr F.APROC Activate process
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
APROC ldx R$X,U  Address of process descriptor
F.APROC clrb
 pshs  u,y,x,cc
 lda P$Prior,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQMask+FIRQMask Set interrupt masks
*
* Age Active Processes
*
 ldu #D.AProcQ-P$Queue Fake process ptr
 bra ACTP30
ACTP10 inc P$AGE,U
 bne ACTP20 is not 0
 dec P$AGE,u too high
ACTP20 cmpa P$AGE,U Who has bigger priority?
 bhi ACTP40
ACTP30 leay 0,U Copy ptr to this process
ACTP40 ldu P$Queue,U Get ptr to next process
 bne ACTP10
 ldd P$Queue,Y
 stx P$Queue,Y
 std P$Queue,X
 puls PC,U,Y,X,CC

*****
*
*  Irq Handler
*
IRQHN ldx D.Proc
 sts P$SP,x Save stack pointer of running process
 lds D.SysStk
 ldd D.SysSvc
 std D.XSWI2
 ldd D.SysIRQ
 std D.XIRQ
 jsr [D.SvcIRQ] Go to interrupt service
 bcc IRQHN10 branch if service failed
 ldx D.Proc
 ldb P$Task,X
 ldx P$SP,X
         lbsr  H.LDABX+$1000
 ora #IntMasks inhibit interrupts in process
         lbsr  H.STABX+$1000
IRQHN10 orcc #IntMasks
 ldx D.Proc
 ldu P$SP,X
 lda P$State,X
 bita #TimOut
 beq NXTP30
IRQHN20 anda #^TimOut
 sta P$State,X
 lbsr F.DELTSK
IRQHN30 bsr F.APROC

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

*
* Loop until there is a Process in the Active Queue
*
NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
 ldy #D.AProcQ-P$Queue Fake process ptr
 bra NXTP20
NXTP10 leay 0,x Copy process pointer
NXTP20 ldx P$Queue,Y Get first process in active queue
 beq NXTP04 Branch if none
 lda P$State,X
 bita #Suspend
 bne NXTP10
*
* Remove Process from Active Queue
*
 ldd P$Queue,X Get next process ptr
 std P$Queue,Y Remove first from active queue
 stx D.Proc Set current process
 lbsr F.ALLTSK Allocate Process Task number
 bcs IRQHN30
 lda D.TSlice
 sta D.Slice
 ldu P$SP,X Get stack ptr
*
* Check Process Status, check for Signal pending
*
 lda P$State,X Is process in system state?
 bmi SYSRET Branch if so
NXTP30 bita #CONDEM Is process condemmed?
 bne NXTOUT Branch if so
 lbsr UPDTSK
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
 lbsr CpySP2U Copy 12 bytes from P$SP to U
 lda P$Signal,X
 sta 2,U
 ldd P$SigVec,X Get intercept vector
 beq NXTOUT Branch if none
 std 10,U
 ldd P$SigDat,X Get intercept data address
 std 8,U
 ldd P$SP,X
 subd #R$Size Make space for copy
 std P$SP,X
 lbsr CpyU2SP Copy 12 bytes from U to P$SP
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
         lbra  SVCRET+$1000 Start next process

NXTOUT lda P$State,x Get process status
 ora #SysState Set system state
 sta P$State,X Update status
 leas P$Stack,X
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
SYSIRQ    jsr   [D.SvcIRQ]
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti

* Return from a system call
SYSRET ldx D.SysPrc Get system process dsc. ptr
 lbsr UPDTSK
 leas 0,u Reset stack pointer
 rti

SVCIRQ jmp [D.Poll]

IOPOLL orcc #CARRY
 rts

FIRQHN   jmp   [>$00F8]
         rts
         rts

DATInit clra
 tfr a,dp
         ldb   #SysTask
         stb   DAT.Task
         sta   DAT.Regs
         lda   #$01    ROMBlock?
         sta   >$FD8E   DAT.Regs+$E
         lda   #IOBlock
         sta   >$FD8F   DAT.Regs+$F
         lbra  COLD+$F000

* Restore DAT image and return from interrupt
*
SVCRET ldb P$Task,x Get task number from process
 orcc #IntMasks
 stb DAT.Task
 leas 0,u Reset stack pointer
 rti

* Switch task and execute user supplied SWI vector
*
PassSWI ldb   P$Task,x
 stb   DAT.Task
 jmp   0,u

* Get byte at 0,X in task B
* Returns value in A
H.LDABX andcc #^CARRY clear carry
 pshs B,CC
 orcc #IntMasks
 stb DAT.Task
 lda 0,X
 ldb #SysTask
 stb DAT.Task
 puls PC,B,CC

* Store register A at 0,X
H.STABX andcc #^CARRY clear carry
 pshs B,CC
 orcc #IntMasks
 stb DAT.Task
 sta 0,X
 ldb #SysTask
 stb DAT.Task
 puls PC,B,CC

* Get byte from Task in task B
* Returns value in B
H.LDBBX andcc #^CARRY clear carry
 pshs a,cc
 orcc #IntMasks
 stb DAT.Task
 ldb 0,X
 lda #SysTask
 sta DAT.Task
 puls PC,A,CC

* Move Y*2 bytes from X in TASK A to U in Task B
* Input: Y = Number of bytes divided 2 (lsr)
*        CC = carry set if Y was odd.
MOVER00 orcc #IntMasks
 bcc MOVER20 branch if no carry
 sta DAT.Task
 lda ,X+
 stb DAT.Task
 sta ,U+
 leay 1,Y
 bra MOVER30
MOVER10 lda 1,S
 orcc #IntMasks
MOVER20 sta DAT.Task
 ldd ,X++
 exg B,DP
 stb DAT.Task
 exg B,DP
 std ,U++
MOVER30 lda #SysTask
 sta DAT.Task
 lda 0,S
 tfr A,CC
 leay -1,Y
 bne MOVER10
 puls PC,U,Y,X,DP,D,CC

* Copy DAT image to DAT register
* Input: B: Task number
*        X: Pointer to DAT image
*        Y: Number of bytes
*        U: Pointer to DAT.Regs
SETDAT00 orcc #IntMasks
SETDAT10 lda 1,X
 leax 2,X
 stb DAT.Task
 sta ,u+
 lda #SysTask
 sta DAT.Task
 leay -1,Y
 bne SETDAT10
 puls PC,U,Y,X,D,CC

SWI3RQ orcc #IntMasks
 ldb #D.SWI3
 bra SWITCH

SWI2RQ orcc #IntMasks
 ldb #D.SWI2
 bra SWITCH

FIRQ   tst   ,s
         bmi   L0D38
         pshs  a
         lda   1,s
         pshs  y,x,dp,b,a
         ora   #$80
         pshs  a
         lda   $08,s
         sta   1,s
         stu   $08,s
L0D38    ldb   #D.FIRQ
         bra   SWITCH

IRQ orcc #IntMasks
 ldb #D.IRQ

SWITCH lda #SysTask
 sta DAT.Task
SWITCH10 clra
 tfr A,DP
 tfr D,X
 jmp [,X]

SWIRQ ldb #D.SWI
 bra SWITCH

NMI ldb #D.NMI
 bra SWITCH

 emod
OS9End equ *

  fcb $9F,$1A,$C8,$30,$10,$34,$AD,$EC,$A0

SYSVEC equ *
 fdb TICK+$FFE0-*   Clock tick
 fdb SWI3HN+$FFE2-*      Swi3 handler
 fdb SWI2HN+$FFE4-*    Swi2 handler
 fdb FIRQHN+$FFE6-*      Fast irq handler
 fdb IRQHN+$FFE8-*     Irq handler
 fdb SWIHN+$FFEA-*     Swi handler
 fdb 0000+$FFEC-*   Nmi handler
 fdb 0000+$FFEE-*

 fdb 0000+$FFF0-*
 fdb SWI3RQ+$FFF2-* Swi3 handler
 fdb SWI2RQ+$FFF4-* Swi2 handler
 fdb FIRQ+$FFF6-* Fast irq handler
 fdb IRQ+$FFF8-* Irq handler
 fdb SWIRQ+$FFFA-* Swi handler
 fdb NMI+$FFFC-* Nmi handler
 fdb DATInit+$FFFE-*
ROMEnd equ *
