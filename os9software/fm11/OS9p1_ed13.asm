 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from Fujitsu FM-11 computer
* This kernal uses two bytes per block in BlkMap
********************************

 ifp1
 use defsfile
 endc

*****
*
*  Module Header
*
Revs set REENT+1
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam   fcs   /OS9p1/
 fcb 13
 fcc "FM11L2"

LORAM set $20
HIRAM set $1000

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
 std D.TmpDAT
 clrb
 inca
 std D.BlkMap
 adda #1   DAT.BMSz/256
 std D.BlkMap+2
 std D.SysDis
 inca
 std D.UsrDis
 inca
 std D.PrcDBT
 inca
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
 leax >JMPMINX,pcr
 tfr x,d
 ldx #D.SWI3
COLD06 std ,x++
 cmpx #D.NMI
 bls COLD06
 leax >ROMEnd,pcr
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
 clra
 clrb
 std ,x++
 ldy #$000D
 ldd #DAT.Free
COLD10    std   ,x++
         leay  -1,y
         bne   COLD10
         ldd   #$0001  ?? type of block ROM?
         std   ,x++
         ldb   #$FF   IOBlock
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         ldx   D.SysMem
         ldb   D.ModDir+2
COLD15    inc   ,x+
         decb
         bne   COLD15
         ldy   #HIRAM
         ldx   D.BlkMap
COLD20    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$FF  IOBlock ?
         beq   COLD25
         stb   >$FD81  DAT.Regs+1
         ldu   ,y
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD25 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD25 If not, eor
         stu   ,y
         bra   COLD30

COLD25 ldb #NotRAM
         stb   [,s]
COLD30    puls  x
         leax  1,x
         cmpx  D.BlkMap+2
         bcs   COLD20
         ldx   D.BlkMap
         inc   ,x
         lda   #$80
         sta   1,x
COLD35    lda  0,x
         beq   COLD60
         tfr   x,d
         subd  D.BlkMap
         leas  <-32,s
         leay  ,s
         lbsr  COLD90
         pshs  x
         ldx   #$0000
         cmpb  #$FF
         bne   COLD40
         ldx   #$0800
COLD40    pshs  y,x
         lbsr  ADJBLK
         ldb   1,y
         stb   DAT.Regs
         ldd   ,x
         clr   DAT.Regs
         puls  y,x
         cmpd  #$87CD
         beq   L0180
         puls  x
         bra   L01A7
L016B    pshs  y,x
         lbsr  ADJBLK
         ldb   1,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #M$ID1
         bne   COLD50
L0180    lbsr  VALMOD
         bcc   COLD45
         cmpb  #E$KwnMod Is it known module
         bne   COLD50
COLD45    ldd   #M$Size Get module size
         lbsr  LDDX
         leax  d,x
         bra   COLD55
COLD50    leax  1,x
COLD55    tfr   x,d
         tstb
         bne   L016B
         bita  #$0F
         bne   L016B
         lsra
         lsra
         lsra
         lsra
         deca
         puls  x
         leax  a,x
L01A7    leas  <$20,s
COLD60    leax  1,x
         cmpx  D.BlkMap+2
         bcs   COLD35
COLD65    leax  >CNFSTR,pcr
         bsr   LINKTO
         bcc   COLD70
         os9   F$Boot
         bcc   COLD65
         bra   COLD80
COLD70    stu   D.Init
COLD75    leax  OS9STR,pcr
         bsr   LINKTO
         bcc   COLD85
         os9   F$Boot
         bcc   COLD75
COLD80    jmp   [>$FFFE]

COLD85    jmp 0,Y Let os9 part two finish

LINKTO    lda #SYSTM Get system type module
         os9   F$Link
         rts

COLD90    pshs  y,x,b,a
         ldb   #$10   DAT.BlCt
         ldx   ,s
COLD95    stx   ,y++
         leax  1,x
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

JMPMINX jmp [<-$10,x] Jump to the "x" version of the interrupt

SWI3HN ldx D.Proc
         ldu   P$SWI3,x
         beq   L0274

USRSWI    lbra  PassSWI+$1000

SWI2HN ldx   D.Proc
         ldu   P$SWI2,x
         beq   L0274
         bra   USRSWI

SWIHN    ldx   D.Proc
         ldu   P$SWI,x
         bne   USRSWI

L0274    ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         lda   P$State,x
         ora   #SysState
         sta   P$State,x
         sts   P$SP,x
         leas  (P$Stack-R$Size),x
         andcc #^IntMasks
         leau  ,s
         bsr   CpySP2U
         ldb   P$Task,x
         ldx   $0A,u
         lbsr  H.LDBBX+$1000
         leax  1,x
         stx   $0A,u
         ldy   D.UsrDis
         lbsr  DISPCH
         ldb   ,u
         andb  #$AF
         stb   ,u
         ldx   D.Proc
         bsr   CpyU2SP
         lda   P$State,x
         anda  #$7F
         lbra  IRQHN20

CpySP2U    lda   $06,x
         ldb   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   $04,x
         bra   L02C5

* Copy 12 bytes from SysTask to U in Task B
CpyU2SP    ldb   $06,x
         lda   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   $04,x
         exg   x,u
L02C5    ldy   #R$Size/2
         tfr   b,dp
         orcc  #IntMasks
         lbra  MOVER20+$1000

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
SYSREQ    leau  ,s
         lda   R$CC,u
         tfr   a,cc
*
* Get Service Request Code
*
 ldx R$PC,U Get program counter
 ldb ,X+ Get service code
 stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr DISPCH Call service routine
         lbra  SYSRET

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
SSVC     ldy   R$Y,u
         bra   SETSVC

SETS10    clra
         lslb
         tfr   d,u
         ldd   ,y++
         leax  d,y
         ldd   D.SysDis
         stx   d,u
         bcs   SETSVC
         ldd   D.UsrDis
         stx   d,u
SETSVC    ldb   ,y+
         cmpb  #$80
         bne   SETS10
         rts

SLINK    ldy   R$Y,u
         bra   L0341

ELINK    pshs  u
         ldb   R$B,u
         ldx   R$X,u
         bra   L0358
LINK     ldx   D.Proc
         leay  P$DATImg,x
L0341    pshs  u
         ldx   R$X,u
         lda   R$A,u
         lbsr  FMOD05
         lbcs  LINKXit
         leay  ,u
         ldu   ,s
         stx   R$X,u
         std   R$D,u
         leax  ,y
L0358    bitb  #$80
         bne   L0364
         ldd   $06,x
         beq   L0364
 ldb #E$ModBsy err: module busy
         bra   LINKXit
L0364    ldd   $04,x
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
         bsr   L03CB
         bcc   L0394
         lda   ,s
         lbsr  F.FREEHB
         bcc   L0391
         leas  $05,s
         ldb   #$CF
         bra   LINKXit
L0391    lbsr  F.SETIMG
L0394    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  1,x
         beq   L03A5
         stx   ,u
L03A5    ldu   $03,s
         ldx   $06,u
         leax  1,x
         beq   L03AF
         stx   $06,u
L03AF    puls  u,y,x,b
         lbsr  F.DATLOG
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  LDDX
         addd  $08,u
         std   $06,u
         clrb
         rts

LINKXit orcc #CARRY
 puls pc,u

L03CB    ldx   D.Proc
         leay  P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #$10
         negb
         lslb
         leay  b,y
L03D9    ldx   ,s
         pshs  u,y
L03DD    ldd   ,y++
         cmpd  ,u++
         bne   L03F2
         leax  -1,x
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

VALMOD pshs  y,x Save registers
 lbsr IDCHK Check sync & chksum
 bcs   BADVAL
 ldd   #M$Type
 lbsr  LDDX
 andb  #Revsmask
 pshs  b,a
 ldd   #M$Name
 lbsr  LDDX
 leax  d,x
 puls  a
 lbsr  FMOD05
 puls  a
         bcs   L0440
 pshs  a
 andb  #Revsmask
 subb  ,s+
         bcs   L0440
         ldb   #$E7
         bra   BADVAL
VMOD10 ldb #E$DirFul Err: directory full
BADVAL orcc #CARRY SET Carry
 puls pc,y,x

L0440    ldx   ,s
         lbsr  L04CC
         bcs   VMOD10
         sty   ,u
         stx   R$X,u
         clra
         clrb
         std   $06,u
         ldd   #$0002
         lbsr  LDDX
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
         addd  #DAT.BlSz-1
         lsra
         lsra
         lsra
         lsra
         ldy   ,u
L0486    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02   ModBlock
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
         lbsr  LDDX
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
         clr   1,x
         rts
L052A    orcc  #$01
         rts

IDCHK    pshs  y,x
         clra
         clrb
         lbsr  LDDX
 cmpd #M$ID12 Check them
         beq   PARITY
         ldb   #$CD
         bra   CRCC20
PARITY    leas  -1,s
         leax  $02,x
         lbsr  ADJBLK
         ldb   #$07
         lda   #$4A
PARI10    sta   ,s
         lbsr  GETBYTE
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
         lbsr  LDDX
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

FMODUL pshs u
 lda R$A,u
 ldx R$X,u
 ldy R$Y,u
 bsr FMOD05
 puls y
 std R$D,y
 stx R$X,y
 stu R$U,y
 rts

FMOD05 ldu #0 Return zero if not found
 pshs u,d
         bsr   SKIPSP
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
         lbsr  LDDX
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
         lbsr  LDDX
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
L06BC    lbsr  ADJBLK
         lbsr  H.LDAXY
         leax  1,x
         cmpa  #$20
         beq   L06BC
         leax  -1,x
         pshs  a
         tfr   y,d
         subd  1,s
         asrb
         lbsr  F.DATLOG
         puls  pc,y,a

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
LDDDXY   ldd   R$D,u
         leau  $04,u
         pulu  y,x
         bsr   LDDX
         std   -$07,u
         clrb
         rts

LDDX    pshs  y,x
         leax  d,x
         bsr   ADJBLK
         bsr   GETBYTE
         pshs  a
         bsr   H.LDAXY
         tfr   a,b
         puls  pc,y,x,a

LDABX    ldb   R$B,u
         ldx   R$X,u
         lbsr  H.LDABX+$1000
         sta   R$A,u
         rts

STABX    ldd   R$D,u
         ldx   R$X,u
         lbra  H.STABX+$1000

****
* Move data (low bound first)
*
MOVE     ldd   R$D,u
         ldx   R$X,u
         ldy   R$Y,u
         ldu   $08,u
F.MOVE    andcc #^CARRY clear carry
         leay  ,y
         beq   MOVE10
         pshs  u,y,x,dp,b,a,cc
         tfr   y,d
         lsra
         rorb
         tfr   d,y
         ldd   1,s
         tfr   b,dp
         lbra  MOVER00+$1000
MOVE10    rts

ALLTSK   ldx   R$X,u
F.ALLTSK    ldb   $06,x
         bne   L0AC2
         bsr   F.RESTSK
         bcs   L0AC3
         stb   $06,x
         bsr   F.SETTSK
L0AC2    clrb
L0AC3    rts

DELTSK   ldx   R$X,u
F.DELTSK    ldb   $06,x
         beq   L0AC3
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

RESTSK   bsr   F.RESTSK
         stb   R$B,u
         rts

* Find free task
F.RESTSK    pshs  x
         ldb   #$01
         ldx   D.Tasks
L0AFB    lda   b,x
         beq   L0B09
         incb
         cmpb  #$10
         bne   L0AFB
         comb
         ldb   #$EF
         bra   L0B0E
L0B09    inc   b,x
         orb   D.SysTsk
         clra
L0B0E    puls  pc,x

RELTSK   ldb   R$B,u
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
 ldu #D.AProcQ-P$Queue Fake process ptr
         bra   L0B78
L0B6E    inc   $0B,u
         bne   L0B74
         dec   P$AGE,u
L0B74    cmpa  $0B,u
         bhi   L0B7A
L0B78    leay  ,u
L0B7A    ldu   $0D,u
         bne   L0B6E
         ldd   P$Queue,y
         stx   P$Queue,y
         std   P$Queue,x
         puls  pc,u,y,x,cc

*****
*
*  Irq Handler
*
IRQHN    ldx   D.Proc
         sts   $04,x
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         jsr   [D.SvcIRQ]
         bcc   IRQHN10
         ldx   D.Proc
         ldb   P$Task,x
         ldx   P$SP,x
         lbsr  H.LDABX+$1000
         ora   #$50
         lbsr  H.STABX+$1000
IRQHN10    orcc  #IntMasks
         ldx   D.Proc
         ldu   P$SP,x
         lda   P$State,x
         bita  #$20
         beq   NXTP30
IRQHN20    anda  #$DF
         sta   P$State,x
         lbsr  F.DELTSK
IRQHN30    bsr   F.APROC

*****
*
*  Routine Nxtprc
*
* Starts next Process in Active Queue
* If no Active Processes, Wait for one
*
NPROC    ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #^IntMasks
         bra   NXTP06

NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06    orcc  #IntMasks
         ldy   #D.AProcQ-P$Queue Fake process ptr
         bra   L0BD6
L0BD4    leay  ,x
L0BD6    ldx   P$Queue,y
         beq   NXTP04
         lda   P$State,x
         bita  #Suspend
         bne   L0BD4
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  F.ALLTSK
         bcs   IRQHN30
         lda   D.TSlice
         sta   D.Slice
         ldu   P$SP,x
         lda   P$State,x Is process in system state?
         bmi   SYSRET
NXTP30    bita  #Condem Is process condemmed?
         bne   NXTOUT
         lbsr  UPDTSK
         ldb   P$Signal,x
         beq   L0C2E
         decb
         beq   L0C2B
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
L0C2B    stb   P$Signal,x
L0C2E    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  SVCRET+$1000

NXTOUT    lda   P$State,x Get process status
         ora #SysState Set system state
         sta   P$State,x Update status
         leas  >$0200,x         P$Stack
         andcc #^IntMasks Clear interrupt masks
         ldb   P$Signal,x
         clr   P$Signal,x
         os9   F$Exit


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

SYSRET    ldx   D.SysPrc
         lbsr  UPDTSK
         leas  ,u
         rti

SVCIRQ   jmp   [D.Poll]

IOPOLL    orcc  #$01
         rts

FIRQHN   jmp   [>$00F8]
         rts
         rts

DATINT   clra
         tfr   a,dp
         ldb   #SysTask
         stb   DAT.Task
         sta   DAT.Regs
         lda   #$01    ROMBlock?
         sta   >$FD8E   DAT.Regs+$E
         lda   #$FF    IOBlock
         sta   >$FD8F   DAT.Regs+$F
         lbra  COLD+$F000

* Restore DAT image and return from interrupt
*
SVCRET    ldb   $06,x
         orcc  #IntMasks
         stb   DAT.Task
         leas  ,u
         rti

* Switch task and execute user supplied SWI vector
*
PassSWI ldb   P$Task,x
 stb   DAT.Task
 jmp   0,u

* Get byte at 0,X in task B
* Returns value in A
H.LDABX    andcc #^CARRY clear carry
         pshs  b,cc
         orcc  #IntMasks
         stb   DAT.Task
         lda   ,x
         ldb   #SysTask
         stb   DAT.Task
         puls  pc,b,cc

* Store register A at 0,X
H.STABX    andcc #^CARRY clear carry
         pshs  b,cc
         orcc  #IntMasks
         stb   DAT.Task
         sta   ,x
         ldb   #SysTask
         stb   DAT.Task
         puls  pc,b,cc

* Get byte from Task in task B
* Returns value in B
H.LDBBX    andcc #^CARRY clear carry
         pshs  a,cc
         orcc  #IntMasks
         stb   DAT.Task
         ldb   ,x
         lda   #SysTask
         sta   DAT.Task
         puls  pc,a,cc

* Move Y*2 bytes from X in TASK A to U in Task B
* Input: Y = Number of bytes divided 2 (lsr)
*        CC = carry set if Y was odd.
MOVER00    orcc  #IntMasks
         bcc   MOVER20
         sta   DAT.Task
         lda   ,x+
         stb   DAT.Task
         sta   ,u+
         leay  1,y
         bra   MOVER30
MOVER10    lda   1,s
         orcc  #IntMasks
MOVER20    sta   DAT.Task
         ldd   ,x++
         exg   b,dp
         stb   DAT.Task
         exg   b,dp
         std   ,u++
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
SETDAT00    orcc  #IntMasks
SETDAT10    lda   1,x
         leax  $02,x
         stb   DAT.Task
         sta   ,u+
         lda   #$80
         sta   DAT.Task
         leay  -1,y
         bne   SETDAT10
         puls  pc,u,y,x,b,a,cc

SWI3RQ   orcc  #IntMasks
         ldb   #D.SWI3
         bra   SWITCH

SWI2RQ   orcc  #IntMasks
         ldb   #D.SWI2
         bra   SWITCH

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

IRQ    orcc  #IntMasks
         ldb   #D.IRQ

SWITCH    lda   #SysTask
         sta   DAT.Task
         clra
         tfr   a,dp
         tfr   d,x
         jmp   [,x]

SWIRQ    ldb   #D.SWI
         bra   SWITCH

NMIHN    ldb   #D.NMI
         bra   SWITCH

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
 fdb NMIHN+$FFFC-* Nmi handler
 fdb DATINT+$FFFE-*
ROMEnd equ *
