 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from ROM.

********************************

 use defsfile

*****
*
*  Module Header
*
Revs set REENT+8
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam fcs /OS9p1/
 fcb 12 Edition number

LORAM set $20
HIRAM set $2000

COLD ldx #LORAM Set ptr
 ldy #HIRAM-LORAM Set byte count
 clra CLEAR D
 clrb
COLD05 std ,X++ Clear system memory block
 leay -2,Y Count down
 bne COLD05
 inca ONE Page for direct page
 std D.Tasks
 addb #DAT.TkCt
 std D.Tasks+2
 clrb
 inca
 std D.BlkMap    Base address for block map
 adda #1  256 bytes for block map
 std D.BlkMap+2
 std D.SysDis
 inca
 std D.UsrDis
 inca
 std D.PrcDBT
 inca
 std D.SysPrc
 std D.Proc
 adda #2 Allocate 512 bytes for stack
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
 leax >JMPMINX,pcr
 tfr x,d
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
 std ,x++    block 0
 ifeq HIRAM-$2000     ifge HIRAM-DAT.Blsz
         incb       block 1
         std ,x++
 endc
 ldy #13        Dat.BlCt-ROMCount-RAMCount-1
 ldd #DAT.Free  Initialize the rest of the blocks to be free
COLD10 std ,x++
 leay -1,Y
 bne COLD10
 ldd #ROMBlock Mark ROM block at $F000
 std ,x++
         ldx   D.Tasks
         inc   ,x
         ldx   D.SysMem
         ldb   D.ModDir+2
COLD15    inc   ,x+
         decb
         bne   COLD15
*
* Map every physical block into block 2 to see if there is RAM
*
 ldy #HIRAM
 ldx D.BlkMap
COLD20 pshs X
 ldd 0,S
 subd D.BlkMap
         cmpb  #$FF
         beq   COLD25
         stb   DAT.Regs+2
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
         stb   [,s]
COLD30    puls  x
         leax  $01,x
         cmpx  D.BlkMap+2
         bcs   COLD20
         ldx   D.BlkMap
         inc   0,x
         inc   1,x
         ldx   D.BlkMap+2
         leax  >-16,x
COLD35    lda   ,x
         beq   COLD60
         tfr   x,d
         subd  D.BlkMap
         cmpd  #$00FF
         beq   COLD60
         leas  <-$20,s
         leay  ,s
         lbsr  COLD90
         pshs  x
         ldx   #$0000
COLD40    pshs  y,x
         lbsr  ADJBLK
         ldb   $01,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   COLD50
         lbsr  VALMOD
         bcc   COLD45
         cmpb  #E$KwnMod Is it known module
         bne   COLD50
COLD45 ldd #M$Size Get module size
 lbsr F.LDDDXY
 leax D,X Skip module
 bra COLD55
COLD50 leax  1,X Try next location
COLD55    tfr   x,d
         tstb
         bne   COLD40
         bita  #$0F
         bne   COLD40
         lsra
         lsra
         lsra
         lsra
         deca
         puls  x
         leax  a,x
         leas  <$20,s
COLD60    leax  $01,x
         cmpx  D.BlkMap+2
         bcs   COLD35

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

COLD85    jmp   0,y Let os9 part two finish

LINKTO    clrb
L01B6    incb
         lda   ,x+
         bpl   L01B6
         negb
         leas  b,s
         negb
         tfr   s,y
         pshs  b
         exg   x,y
         decb
L01C6    lda   ,-y
         sta   b,x
         decb
         bpl   L01C6
         lda #SYSTM Get system type module
         os9   F$Link
         puls  a
         leas  a,s
         rts

* Copies value on stack to all positions in block
COLD90    pshs  y,x,b,a
         ldb   #$10
         ldx   ,s
COLD95    stx   ,y++
         leax  $01,x
         decb
         bne   COLD95
         puls  pc,y,x,b,a

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


SWI3HN ldx D.Proc
         ldu   <$17,x
         beq   L0271

USRSWI    lbra  PassSWI


SWI2HN         ldx   D.Proc
         ldu   P$SWI2,x
         beq   L0271
         bra   USRSWI

SWIHN    ldx   D.Proc
         ldu   P$SWI,x
         bne   USRSWI

* Process software interupts from a user state
* Entry: X=Process descriptor pointer of process that made system call
L0271    ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         lda   P$State,x
         ora   #SysState
         sta   P$State,x
         sts   P$SP,x
         leas  (P$Stack-R$Size),x
         leau  ,s
         bsr   CpySP2U
         ldb   >$FFA0
         andcc #$AF
         ldy   D.UsrDis
         lbsr  DISPCH
         ldb   R$CC,u
         andb  #$AF
         stb   R$CC,u
         ldx   D.Proc
         bsr   CpyU2SP
         lda   P$State,x
         anda  #$7F
         lbra  IRQHN20

CpySP2U    lda   $06,x
         anda  #$7F
         clrb
         pshs  u,x,cc
         ldx   P$SP,x
         bra   L02BC

CpyU2SP    ldb   $06,x
         andb  #$7F
         clra
         pshs  u,x,cc
         ldx   P$SP,x
         exg   x,u
L02BC    orcc  #$50
         sta   >$FFB8 Address to copy from
         stx   >$FFC0
         stu   >$FFC4
         ldx   #12
         stx   >$FFC2
         stx   >$FFC6
         stb   >$FFB9 Address to copy to
         ldb   #$03
         stb   >$FFBC
         nop
         puls  pc,u,x,cc

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
SYSREQ leau 0,S Copy stack ptr
         ldb   >$FFA0
 lda R$CC,u
 tfr a,cc
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
 tfr d,u copy routine offset
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

*****
* System link
* Input: A = Module type
*        X = Module string pointer
*        Y = Name string DAT image pointer
SLINK ldy R$Y,u
 bra LINK05

*****
* Link using module directory entry
*
* Input: B = Module type
*        X = Pointer to module directory entry
ELINK pshs  u
 ldb R$B,u
 ldx R$X,u Get name ptr
 bra LINK10

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
 leay P$DATImg,x
LINK05 pshs U Save register package
 ldx R$X,U Get name ptr
 lda R$A,u Get module type
 lbsr F.FMODUL
 lbcs LINKXit
 leay 0,U Make copy
 ldu 0,s Get register ptr
 stx R$X,U
 std R$D,U
 leax 0,Y
LINK10 bitb #REENT is this sharable
 bne LINK20 branch if so
 ldd MD$Link,x  Check for links
 beq LINK20 .. none
 ldb #E$ModBsy err: module busy
 bra LINKXit
LINK20 ldd MD$MPtr,X  Module ptr
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
         pshs  b
         leau  0,y
         bsr   L03CB
         bcc   LINK40
         lbsr  FRHB20
         bcc   LINK30
         leas  $05,s
         ldb   #E$MemFul
         bra   LINKXit
LINK30    lbsr  F.SETIMG
LINK40    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  $01,x
         beq   LINK50
         stx   ,u
LINK50    ldu   $03,s
         ldx   $06,u
         leax  $01,x
         beq   LINK60
         stx   $06,u
LINK60    puls  u,y,x,b
         lbsr  F.DATLOG
         stx   $08,u
         ldx   $04,y
         ldy   ,y
 ldd #M$EXEC Get execution offset
 lbsr F.LDDDXY
 addd R$U,U
 std R$Y,u Return it to user
 clrb
 rts

LINKXit orcc #CARRY
 puls pc,u

* Called from LINK
L03CB    ldx   D.Proc
         leay  P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #$10 #DAT.BlCt
         negb
         lslb
         leay  b,y
L03D9    ldx   ,s
         pshs  u,y
L03DD    ldd   ,y++
         cmpd  ,u++
         bne   L03F2
         leax  -$01,x
         bne   L03DD
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a

L03F2    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   L03D9
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

VALMOD pshs Y,X Save registers
 lbsr IDCHK Check sync & chksum
 bcs   BADVAL
 ldd   #M$Type
 lbsr  F.LDDDXY
 andb  #Revsmask
 pshs  d
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
 ldb #E$KwnMod
 bra BADVAL
VMOD10 ldb #E$DirFul Err: directory full
BADVAL    orcc  #$01
         puls  pc,y,x

VMOD20    ldx   ,s
         lbsr  L04CC
         bcs   VMOD10
         sty   ,u
         stx   $04,u
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
         bra   L0467
L0465    leax  $08,x
L0467    cmpx  D.ModEnd
         bcc   L0476
         cmpx  ,s
         beq   L0465
         cmpy  [,x]
         bne   L0465
         bsr   L049A
L0476    puls  u
         ldx   D.BlkMap
         ldd   $02,u
         addd  #DAT.BlSz-1 Round up to nearest block
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra Divide by 32 for 8K blocks
 endc
         ldy   ,u
L0486    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02
         stb   ,x
         puls  x,a
         deca
         bne   L0486
         clrb
         puls  pc,y,x

L049A    pshs  u,y,x,b,a
         ldx   ,x
         pshs  x
         clra
         clrb
L04A2    ldy   ,x
         beq   L04AB
         std   ,x++
         bra   L04A2
L04AB    puls  x
         ldy   $02,s
         ldu   ,u
         puls  b,a
L04B4    cmpx  ,y
         bne   L04C3
         stu   ,y
         cmpd  $02,y
         bcc   L04C1
         ldd   $02,y
L04C1    std   $02,y
L04C3    leay  $08,y
         cmpy  D.ModEnd
         bne   L04B4
         puls  pc,u,y,x
L04CC    pshs  u,y,x
         ldd   #$0002
         lbsr  F.LDDDXY
         addd  ,s
         addd  #$0FFF
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
         bsr   L04F5
         bcc   L04F3
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   L04F5
L04F3    puls  pc,u,y,x,b
L04F5    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   L052A
         ldu   $07,s
         bne   L0515
         pshs  x
         ldy   D.ModEnd
         leay  $08,y
         cmpy  ,s++
         bhi   L052A
         sty   D.ModEnd
         leay  -$08,y
         sty   $07,s
L0515    stx   D.ModDAT
         ldy   $05,s
         ldb   $02,s
         stx   $05,s
L051E    ldu   ,y++
         stu   ,x++
         decb
         bne   L051E
         clr   ,x
         clr   $01,x
         rts
L052A    orcc  #$01
         rts

IDCHK pshs y,x
 clra
 clrb
 lbsr F.LDDDXY Get first two bytes
 cmpd #M$ID12 Check them
 beq PARITY
 ldb #E$BMID Err: illegal id block
 bra CRCC20 exit
PARITY leas -1,s  Save space on stack
 leax 2,X
 lbsr ADJBLK Go to next DAT block?
 ldb #M$IDSize-2
 lda #$4A  M$ID1^M$ID2
PARI10 sta 0,S
 lbsr GETBYTE
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
 lbsr F.LDDDXY
 pshs Y,X,D
 ldd #$FFFF
 pshs D Init crc register
 pshs B Init crc register
 lbsr ADJBLK
 leau 0,S Get crc register ptr
CRCC05 tstb
 bne CRCC10
 pshs x
 ldx #1
 os9 F$Sleep
 puls x
CRCC10 lbsr GETBYTE Get next byte
 bsr CRCCAL Calculate crc
 ldd 3,s
 subd #1 count byte
 std 3,s
 bne CRCC05
 puls y,x,b
 cmpb #$80 Is it good?
 bne CRCC15 Branch if not
 cmpx #$0FE3 Is it good?
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
 pshs x,d
 leas -3,s
 ldx D.Proc
 lda P$Task,x
 ldb D.SysTsk
 ldx R$U,u get crc ptr
 ldy #3
 leau 0,s
 pshs y,x,d
 lbsr F.MOVE
 ldx D.Proc
 leay P$DATImg,x
 ldx 11,s
 lbsr ADJBLK
CRCGen10 lbsr GETBYTE get next data byte
 lbsr CRCCAL update crc
 ldd 9,s
 subd #1 count byte
 std 9,s
 bne CRCGen10 branch if more
 puls y,x,d
 exg a,b
 exg x,u
 lbsr F.MOVE
 leas 7,s
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
 bsr F.FMODUL
 puls y
 std R$D,y
 stx R$X,y
 stu R$U,y
 rts

F.FMODUL ldu #0 Return zero if not found
 pshs u,d
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr F.PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModDir Get module directory ptr
 bra FMOD33 Test if end is reached
FMOD10 pshs y,x,d
 pshs y,x
 ldy 0,u Get module ptr
 beq FMOD20 Branch if not used
 ldx M$NAME,U Get name offset
 pshs y,x
 ldd #M$NAME Get name offset
 lbsr F.LDDDXY
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
 lbsr F.LDDDXY
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
 eora ,s
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
 leau MD$ESize,U Move to next entry
FMOD33 cmpu D.ModEnd End of directory?
 bcs FMOD10 Branch if not
 comb
 ldb #E$MNF
 bra FMOD40
FMOD35 comb SET Carry
 ldb #E$BNam
FMOD40 stb 1,S Save B on stack
 puls D,U,PC

* Skip spaces
SKIPSP pshs y
SKIP10 lbsr ADJBLK
 lbsr H.LDAXY Get byte from other DAT
 leax 1,x move forward
 cmpa #'  compare with space
 beq SKIP10
 leax -1,x Get not space
 pshs a
 tfr Y,D
 subd 1,S
 asrb
 lbsr F.DATLOG
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
 leay P$DATImg,x
 ldx R$X,u Get string ptr
 bsr F.PRSNAM Call parse name
 std R$D,U Return byte & size
 bcs PNam.x branch if error
 stx R$X,U Return updated string ptr
 abx
PNam.x stx R$Y,U Return name end ptr
 rts

F.PRSNAM pshs y
 lbsr ADJBLK
 pshs y,X
 lbsr GETBYTE Get first char
 cmpa #'/ Slash?
 bne PRSNA1 ..no
 leas 4,S
 pshs y,X
 lbsr GETBYTE
PRSNA1 bsr ALPHA 1st character must be alphabetic
 bcs PRSNA4 Branch if bad name
 clrb
PRSNA2 incb INCREMENT Character count
 tsta End of name (high bit set)?
 bmi PRSNA3 ..yes; quit
 lbsr GETBYTE
 bsr ALFNUM Alphanumeric?
 bcc PRSNA2 ..yes; count it
PRSNA3 andcc #^CARRY clear carry
 bra PRSNA10
PRSNA4 cmpa #', Comma (skip if so)?
 bne PRSNA6 ..no
PRSNA5 leas 4,S
 pshs Y,X
 lbsr GETBYTE
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 comb (NAME Not found)
 ldb #E$BNam 
PRSNA10 puls Y,X
 pshs d,cc
 tfr Y,D
 subd 3,S
 asrb
 lbsr F.DATLOG
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
 ldx R$X,u
 pshs y,x
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
 pulu y,X
 lbsr ADJBLK
 pshu y,X
 ldu 4,S
 pulu y,X
 lbsr ADJBLK
 bra CHKN15
CHKN10 ldu 4,S
 pulu y,X
CHKN15 lbsr GETBYTE
 pshu Y,X
 pshs a
 ldu 3,S
 pulu Y,X
 lbsr GETBYTE
 pshu Y,X
 eora 0,S
 tst ,s+
 bmi CHKN20 Branch if last module char
 decb DECREMENT Char count
 beq RETCS1 Branch if last character
 anda #$FF-$20 Match upper/lower case
 beq CHKN10 ..yes; repeat
RETCS1 comb Set carry
 puls PC,U,Y,X,D

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
         cmpa  #$01 #RAMinUse
         bne   SRQM20
         leay  DAT.BlCt,y
         bra   SRQM30
SRQM15    clra
SRQM20    ldb   #DAT.BlCt
SRQM25    sta   ,y+
         decb
         bne   SRQM25
SRQM30    inc   ,s
         ldb   ,s
         cmpb  #DAT.BlCt
         bcs   SRQM10
SRQM40    ldb   $01,u
SRQM45    cmpy  D.SysMem
         bhi   SRQM50
         comb
         ldb   #$CF
         bra   SRQMXX
SRQM50    lda   ,-y
         bne   SRQM40
         decb
         bne   SRQM45
         sty   ,s
         lda   $01,s
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra Divide by 32 for 8K blocks
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
 lsrb Divide by 32 for 8K blocks
 endc
 ldx D.SysPrc
 lbsr F.ALLIMG
 bcs SRQMXX
 ldb R$A,U Get page count
SRQM60 inc ,Y+
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
 ldb R$U+1,u Is address on page boundary?
 beq SRTM10 yes
 comb
 ldb #E$BPAddr
 rts

SRTM10 ldb R$U,U
 beq SRTMXX Branch if returning nothing
 ldx D.SysMem
 abx
SRTM20    ldb   ,x
         andb  #$FE   #^RAMinUse
         stb   ,x+
         deca
         bne   SRTM20
         ldx   D.SysDAT
         ldy   #DAT.BlCt
SRTM30    ldd   ,x
         cmpd  #$8000
         beq   SRTM50
         ldu   D.BlkMap
         lda   d,u
         cmpa  #$01   #RAMinUse
         bne   SRTM50
         tfr   x,d
         subd  D.SysDAT
         lslb
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #$10
SRTM40    lda   ,u+
         bne   SRTM50
         decb
         bne   SRTM40
         ldd   ,x
         ldu   D.BlkMap
         clr   d,u
         ldd #DAT.Free
         std   ,x
SRTM50    leax  $02,x
         leay  -$01,y
         bne   SRTM30
SRTMXX    clrb
         rts

BOOT comb set carry
 lda D.Boot
 bne BOOTXX Don't boot if already tried
 inc D.Boot
         ldx   #$F000
         ldd   M$EXEC,x
         jsr   d,x
 bcs BOOTXX Boot failed
 leau D,X Set U to end of boot
 tfr X,D
 anda #DAT.Addr Calculate start of block
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
 tfr X,D
 subd 0,S Subtract start of block (U on stack)
 tfr D,X Module block offset
 tfr Y,D Transfer DAT image pointer to D
 OS9 F$VModul Validate module
 pshs B
 ldd 1,S Get U back from stack
 leax D,X
 puls B
 bcc BOOT15
 cmpb #E$KwnMod
 bne BOOT20
BOOT15 ldd M$SIZE,X Get module size
 leax D,X
 bra BOOT30
BOOT20 leax 1,X Try next
BOOT30 cmpx 2,S End of boot?
 bcs BOOT10 Branch if not
 leas 4,S Restore stack
BOOTXX rts


*****
*
* Allocate RAM blocks
*
ALLRAM         ldb   $02,u
         bsr   ALRAM10
         bcs   ALRAM05
         std   $01,u
ALRAM05    rts

ALRAM10    pshs  y,x,b,a
         ldx   D.BlkMap
L08F7    leay  ,x
         ldb   $01,s
L08FB    cmpx  D.BlkMap+2
         bcc   ALRAMERR
         lda   ,x+
         bne   L08F7
         decb
         bne   L08FB
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   $01,s
         stb   $01,s
L0910    inc   ,y+
         deca
         bne   L0910
         clrb
         puls  pc,y,x,b,a

ALRAMERR comb
 ldb #E$NoRam
 stb 1,S Save error code
 puls PC,Y,X,D

*****
*
* Allocate image RAM blocks
*
ALLIMG ldd R$D,u  Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer
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
         subd  #$0001
         pshs  b,a
ALLIMG20    leax  -$01,x
         bne   ALLIMG10
         ldx   ,s++
         beq   ALLIMG60
ALLIMG30    lda   ,u+
         bne   ALLIMG40
         leax  -$01,x
         beq   ALLIMG60
ALLIMG40    cmpu  D.BlkMap+2
         bcs   ALLIMG30

ALLIMG50 ldb #E$MemFul
 leas 6,S
 stb 1,S
 comb
 puls PC,U,Y,X,D

ALLIMG60    puls  u,y,x
ALLIMG65    ldd   ,y++
         cmpd  #DAT.Free
         bne   ALLIMG70
ALLIMG68 equ *
         lda   ,u+
         bne   ALLIMG68
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         std   -$02,y
ALLIMG70    leax  -$01,x
         bne   ALLIMG65
         ldx   $02,s
         lda   P$State,X
         ora   #ImgChg
         sta   P$State,X
         clrb
         puls  pc,u,y,x,b,a


*****
*
* Get free high block
*
FREEHB ldb R$B,u Get block count
 ldy R$Y,u DAT image pointer
 bsr FRHB20 Go find free blocks in high part of DAT
 bcs FRHB10
 sta R$A,u return beginning block number
FRHB10 rts

FRHB20    tfr   b,a
         suba  #$11
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   FREEBLK

*****
* Get Free low block
*
FREELB         ldb   $02,u
         ldy   $06,u
         bsr   FRLB20
         bcs   FRLB10
         sta   $01,u
FRLB10    rts

FRLB20    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$11
         negb
         pshs  b,a
         bra   FREEBLK

FREEBLK    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
         bne   FREBLK20
         ldb   #$CF
 stb 3,S Save error code
 comb set carry
 bra FREBLK30

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
* Set Process DAT Image
* Copies DAT Image into the process descriptor
*
SETIMG ldd R$D,u Get beginning and number of blocks
 ldx R$X,u Process descriptor pointer
 ldu R$U,u New image pointer
F.SETIMG pshs U,Y,X,D
 leay P$DATImg,X
 lsla
 leay A,Y
SETIMG10 ldx ,u++
 stx ,y++
 decb
 bne SETIMG10
 ldx 2,S
 lda P$State,X
 ora #ImgChg
 sta P$State,X
 clrb
 puls PC,U,Y,X,D

*****
* Convert DAT block/offset to logical address
*
DATLOG ldb R$B,u  DAT image offset
 ldx R$X,u Block offset
 bsr F.DATLOG
 stx R$X,u Return logical address
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

*****
* Load A [X, [Y]]
* Returns one byte in the memory block specified by the DAT image in Y
* offset by X.
LDAXY ldx R$X,u Block offset
 ldy R$Y,u DAT image pointer
 bsr H.LDAXY
 sta R$A,u Store result
 clrb
 rts

* Get byte from other DAT
* Input: X - location
*        Y - DAT image number
H.LDAXY pshs CC
 lda 1,Y
 orcc #IntMasks
 sta DAT.Regs
 lda 0,X
 clr DAT.Regs
 puls PC,CC

* Get byte and increment X
* Input: X - location
*        Y - DAT image number
* Output: A - result
GETBYTE lda 1,Y
 pshs cc
 orcc #IntMasks
 sta DAT.Regs
 lda ,x+
 clr DAT.Regs
 puls cc
 bra ADJBLK

ADJBLK10 leax -DAT.BlSz,X
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
 lbsr H.LDABX
 sta R$A,U
 rts

*****
* Store A at 0,X in task B
*
STABX ldd R$D,U
 ldx R$X,U
 lbra H.STABX

* Get byte at 0,X in task B
* Returns value in A
H.LDABX andcc #^CARRY clear carry
         pshs  u,x,b,a,cc
         leau  $01,s
         andb  #$7F
         clra
         exg   a,b
         exg   x,u
         bra   L0A98

* Store register A
H.STABX andcc #^CARRY clear carry
         pshs  u,x,b,a,cc
         leau  $01,s
         andb  #$7F
         clra
L0A98  orcc #IntMasks
         stu   >$FFC0
         stx   >$FFC4
         ldu   #$0001
         stu   >$FFC2
         stu   >$FFC6
         sta   >$FFB8 Address to copy from
         stb   >$FFB9 Address to copy to
         ldb   #$03
         stb   >$FFBC
         nop
         puls  pc,u,x,b,a,cc

****
* Move data (low bound first)
*
MOVE ldd R$D,u Source and destination task number
 ldx R$X,u Source pointer
 ldy R$Y,u Byte count
 ldu R$U,u Destination pointer
F.MOVE andcc #^CARRY clear carry
         pshs  b,a,cc
         anda  #$7F
         andb  #$7F
 leay 0,y How many bytes to move?
 beq MOVE10 ..branch if zero
 orcc #IntMasks
         stx   >$FFC0
         stu   >$FFC4
         sty   >$FFC2
         sty   >$FFC6
         sta   >$FFB8 Address to copy from
         stb   >$FFB9
         ldb   #$03
         stb   >$FFBC
         nop
MOVE10 puls PC,B,A,CC

*****
* Allocate Process Task number
*
ALLTSK ldx R$X,u Get process descriptor
F.ALLTSK ldb P$Task,X
 bne ALLTSK10
 bsr F.RESTSK Reserve task number
 bcs TSKRET
 stb P$Task,X
 bsr F.SETTSK Set process task registers
ALLTSK10 clrb
TSKRET rts

*****
* Deallocate Process Task number
*
DELTSK ldx R$X,u  Get process descriptor
F.DELTSK ldb P$Task,X
 beq TSKRET
 clr P$Task,X
 bra F.RELTSK

*
* Update process task registers if changed
*
UPDTSK lda P$State,X
 bita #ImgChg Did task image change?
 bne F.SETTSK Set process task registers
 rts

*****
*
* Set process Task DAT registers
*
SETTSK ldx R$X,U Process descriptor pointer
F.SETTSK lda P$State,X
 anda #^ImgChg
 sta P$State,X
 andcc #^CARRY clear carry
 pshs Y,X,D,CC
 ldb P$Task,X
         andb  #$7F
         clra
         lslb
         rola
         lslb
         rola
         lslb
         rola
         lslb
         rola
 leax P$DATImg,X
 orcc #IntMasks
 ldy #DAT.Regs
         leay  d,y
         ldb   #DAT.ImSz/2
L0B31    lda   ,x+
         cmpa  #$80   Unassigned block?
         beq   L0B3B
         lda   ,x+
         bra   L0B3F
L0B3B    lda   #$FF
         leax  1,x
L0B3F    sta   ,y+
         decb
         bne   L0B31
         puls  PC,Y,X,D,CC

*****
* Reserve Task Number
* Output: B = Task number
RESTSK bsr F.RESTSK
 stb R$B,u Set task number
 rts

* Find free task
F.RESTSK    pshs  x
         ldb   #$01
         ldx   D.Tasks
RESTSK10    lda   b,x
         beq   RESTSK20
         incb
         cmpb  #$80
         bne   RESTSK10
         comb
         ldb   #$EF
         bra   RESTSK30
RESTSK20    inc   b,x
         orb   D.SysTsk
         clra
RESTSK30    puls  pc,x

*****
* Release Task number
*
RELTSK         ldb   $02,u
F.RELTSK    pshs  x,b
         ldb   D.SysTsk
         comb
         andb  ,s
         beq   RELTSK20
         ldx   D.Tasks
         clr   b,x
RELTSK20    puls  pc,x,b

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
 puls pc,u,y,x,cc

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
 lbsr H.LDABX Get saved cc
 ora #IntMasks inhibit interrupts in process
 lbsr H.STABX Save CC
IRQHN10 orcc #IntMasks
 ldx D.Proc
 ldu P$SP,X
 lda P$State,X
 bita  #TimOut
 beq NXTP30
IRQHN20 anda #^TimOut
 sta P$State,X
*lbsr F.DELTSK
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

NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
         ldy   #D.AProcQ-P$Queue Fake process ptr
         bra   NXTP20
NXTP10    leay  ,x
NXTP20    ldx   $0D,y
         beq   NXTP04
         lda   P$State,x
         bita  #$08
         bne   NXTP10
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  F.ALLTSK
         bcs   IRQHN30
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   P$State,x
         bmi   SYSRET
NXTP30    bita  #$02
         bne   NXTOUT
         lbsr  UPDTSK
         ldb   P$Signal,x
         beq   NXTP50
         decb
         beq   NXTP40
         leas  -$0C,s
         leau  ,s
         lbsr  CpySP2U
         lda   P$Signal,x
         sta   $02,u
         ldd   <$1A,x
         beq   NXTOUT
         std   $0A,u
         ldd   <$1C,x
         std   $08,u
         ldd   $04,x
         subd  #$000C
         std   $04,x
         lbsr  CpyU2SP
         leas  $0C,s
         ldu   $04,x
         clrb
NXTP40    stb   P$Signal,x
NXTP50    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  SVCRET

NXTOUT lda P$State,x Get process status
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

SVCIRQ   jmp   [D.Poll]

IOPOLL orcc #CARRY
 rts

DATINT    clra
         tfr   a,dp
         sta   >$FFBA
         ldy   #$F010  DAT.Regs+16
         lda   #$FF   ROMBlock
         ldb   #$01
L0CCB    sta   ,-y
         decb
         bne   L0CCB
         ldb   #$0D
         lda   #$FF  ROMBlock or IOBlock
L0CD4    sta   ,-y
         decb
         bne   L0CD4
         ldb   #$01
L0CDB    stb   ,-y  Two blocks of ram
         decb
         bpl   L0CDB
         ldb   #$03
         stb   >$FFD4
         ldb   #$00
         stb   >$FFD1
         orb   #$01
         stb   >$FFD0
         lbra  COLD

* Restore DAT image and return from interrupt
*
SVCRET ldb P$Task,x Get task number from process
 orcc #IntMasks
 stb DAT.Task
 leas 0,u Reset stack pointer
         ldb   #$04
         stb   >$FFBC
         rti

* Switch task and execute user supplied SWI vector
*
PassSWI    leas  -$0C,s
         sts   P$SP,x
         leas  (P$Stack-R$Size),X
         ldb   #$80
         stb   ,s
         stu   $0A,s
         tfr   s,u
         lbsr  CpyU2SP
         lds   P$SP,x
 ldb P$Task,x Get task number from process
 stb DAT.Task
         ldb   #$04
         stb   >$FFBC
         rti

SWI3RQ    orcc  #IntMasks
         ldb   #D.SWI3
         bra   IRQ10

SWI2RQ    orcc  #IntMasks
         ldb   #D.SWI2
         bra   IRQ10

FIRQ ldb #D.FIRQ
         bra   IRQ10

IRQ orcc #IntMasks
 ldb #D.IRQ

IRQ10    clr   >$FFBC  Switch to system task
         clra
         tfr   a,dp
         tfr   d,x
         jmp   [,x]

SWIRQ ldb #D.SWI
 bra IRQ10

NMI ldb #D.NMI
 bra IRQ10

 emod
OS9End equ *

Target set $0DF0-$20
 use filler

SYSVEC fdb TICK+$FFE0-* Clock tick handler
 fdb SWI3HN+$FFE2-* Swi3 handler
 fdb SWI2HN+$FFE4-* Swi2 handler
 fdb 0000+$FFE6-*  Fast irq handler
 fdb IRQHN+$FFE8-* Irq handler
 fdb SWIHN+$FFEA-* Swi handler
 fdb 0000+$FFEC-*
 fdb 0000+$FFEE-*

 fdb 0000+$FFF0-*
 fdb SWI3RQ+$FFF2-* Swi3
 fdb SWI2RQ+$FFF4-* Swi2
 fdb FIRQ+$FFF6-* Firq
 fdb IRQ+$FFF8-* Irq
 fdb SWIRQ+$FFFA-* Swi
 fdb NMI+$FFFC-* Nmi
 fdb DATINT+$FFFE-* Dynamic address translator initialization

ROMEnd equ *
