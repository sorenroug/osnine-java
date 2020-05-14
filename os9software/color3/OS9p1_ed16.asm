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
HIRAM set $2000

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
         addd  #$0040   Allocate 64 bytes for block map
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
         std   D.CCMem
         ldd   #HIRAM
         std   D.CCStk
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
 stx D.SysDAT
 clra
 clrb
 std ,x++
         ldy   #$0006        Dat.BlCt-ROMCount-RAMCount-1
 ldd #DAT.Free  Initialize the rest of the blocks to be free
COLD10    std   ,x++
         leay  -1,y
         bne   COLD10
         ldd   #ROMBlock
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         inc   1,x
         ldx   D.SysMem
         ldb   D.CCStk
COLD15    inc   ,x+
         decb
         bne   COLD15
         clr   D.MemSz
         ldd   #$0313
         std   >DAT.Regs+5
         ldx   #$A000
         ldd   #$DC78
         std   ,x
         cmpd  >HIRAM,x
         beq   L0122
         inc   D.MemSz
L0122    ldy   #HIRAM
         ldx   D.BlkMap
COLD20    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$3F
         bne   L0136
         ldb   #$01
         bra   COLD28
L0136    lda   D.MemSz
         bne   L013E
         cmpb  #$0F
         bcc   COLD25
L013E    stb   >$FFA1   DAT.Regs+1
         ldu   ,y
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD25 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD25 If not, eor
         stu   0,y
         bra   COLD30
COLD25    ldb   #$80  #NotRAM
COLD28    stb   [,s]
COLD30    puls  x
         leax  1,x
         cmpx  D.BlkMap+2
         bcs   COLD20
         ldx   D.BlkMap
         inc   ,x
         ldx   D.BlkMap+2
         leax  >-1,x
         tfr   x,d
         subd  D.BlkMap
         leas  -16,s
         leay  ,s
         lbsr  COLD90
         pshs  x
         ldx   #$0D00
COLD40    pshs  y,x
         lbsr  DATBLEND
         ldb   1,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   COLD50
         lbsr  VALMOD
         bcc   COLD45
         cmpb  #$E7
         bne   COLD50
COLD45    ldd   #$0002
         lbsr  F.LDDDXY
         leax  d,x
         bra   L01A9
COLD50    leax  1,x
L01A9    cmpx  #$1E00
         bcs   COLD40
         bsr   L01D2
COLD65    leax CNFSTR,PCR Get initial module name ptr
         bsr   LINKTO
         bcc   COLD70
         os9   F$Boot
         bcc   COLD65
         bra   L01CE
COLD70    stu   D.Init
COLD75    leax OS9STR,PCR
         bsr   LINKTO
         bcc   COLD85
         os9   F$Boot
         bcc   COLD75
L01CE    jmp   D.Crash

COLD85    jmp 0,Y Let os9 part two finish

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

LINKTO    lda #SYSTM Get system type module
         os9   F$Link
         rts

COLD90    pshs  y,x,b,a
         ldb   #DAT.BlCt
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

 ifeq CPUType-COLOR3
 fcb F$AlHRam+$80
 fdb ALHRAM-*-2
 endc

 fcb $80

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name
BTSTR fcs /Boot/

JMPMINX jmp [<-$10,x] Jump to the "x" version of the interrupt

SWI3HN ldx D.Proc
         ldu   P$SWI3,x
         beq   L028E

USRSWI    lbra  JMPUSWI

SWI2HN   ldx   D.Proc
         ldu   P$SWI2,x
         beq   L028E
         bra   USRSWI

SWIHN    ldx   D.Proc
         ldu   P$SWI,x
         bne   USRSWI

L028E    ldd   D.SysSvc
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
         bsr   L02CB
         ldb   P$Task,x
         ldx   R$PC,u
         lbsr  H.LDBBX
         leax  1,x
         stx   $0A,u
         ldy   D.UsrDis
         lbsr  DISPCH
         ldb   ,u
         andb  #$AF
         stb   ,u
         ldx   D.Proc
         bsr   L02DA
         lda   P$State,x
         anda  #$7F
         lbra  IRQHN20

L02CB    pshs  u,y,x,cc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0BF5
         leax  >-$6000,x
         bra   L02E9

L02DA    pshs  u,y,x,cc
         ldb   $06,x
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
         ldy   #$000C
L0303    ldd   ,x++
         std   ,u++
         leay  -$02,y
         bne   L0303
         ldx   D.SysDat
         lda   $0B,x
         ldb   $0D,x
         std   >DAT.Regs+5
         puls  pc,u,y,x,cc

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
SYSREQ    leau  ,s
         lda   D.SSTskN
         clr   D.SSTskN
         pshs  a
         lda   R$CC,u
         tfr   a,cc
*
* Get Service Request Code
*
         ldx   R$PC,u
         ldb   ,s
         beq   L032F
         lbsr  H.LDBBX
         leax  1,x
         bra   L0331
L032F    ldb   ,x+ Get service code
L0331    stx R$PC,U Update program counter
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
         ldu   0,s
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
         adda  #$02
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         pshs  a
         leau  ,y
         bsr   L0422
         bcc   L03EB
         lda   ,s
         lbsr  F.FREEHB
         bcc   L03E8
         leas  $05,s
         bra   LINKXit
L03E8    lbsr  F.SETIMG
L03EB    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  1,x
         beq   L03FC
         stx   ,u
L03FC    ldu   $03,s
         ldx   R$Y,u
         leax  1,x
         beq   L0406
         stx   R$Y,u
L0406    puls  u,y,x,b
         lbsr  F.DATLOG
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #M$EXEC Get execution offset
         lbsr  F.LDDDXY
         addd  R$U,u
         std   R$Y,u Return it to user
         clrb
         rts

LINKXit    orcc  #$01
         puls  pc,u

L0422    ldx   D.Proc
         leay  P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #DAT.BlCt
         negb
         lslb
         leay  b,y
L0430    ldx   ,s
         pshs  u,y
L0434    ldd   ,y++
         cmpd  ,u++
         bne   L0449
         leax  -1,x
         bne   L0434
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a
L0449    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   L0430
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
 bcs BADVAL
 ldd #M$Type
 lbsr F.LDDDXY
 andb #Revsmask
 pshs D
 ldd #M$Name
 lbsr F.LDDDXY
 leax d,x
 puls a
 lbsr F.FMODUL
 puls a
 bcs VMOD20
 pshs a
 andb #Revsmask
 subb ,s+
 bcs VMOD20
 ldb #E$KwnMod
 bra BADVAL
VMOD10 ldb #E$DirFul Err: directory full
BADVAL orcc #CARRY SET Carry
 puls pc,y,x

VMOD20    ldx   ,s
         lbsr  L0524
         bcs   VMOD10
         sty   ,u
         stx   R$X,u
         clra
         clrb
         std   R$Y,u
         ldd   #$0002
         lbsr  F.LDDDXY
         pshs  x
         addd  ,s++
         std   $02,u
         ldy   [,u]
         ldx   D.ModDir
         pshs  u
         bra   L04BE
L04BC    leax  $08,x
L04BE    cmpx  D.ModEnd
         bcc   L04CD
         cmpx  ,s
         beq   L04BC
         cmpy  [,x]
         bne   L04BC
         bsr   L04F2
L04CD    puls  u
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
L04DE    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02
         stb   ,x
         puls  x,a
         deca
         bne   L04DE
         clrb
         puls  pc,y,x
L04F2    pshs  u,y,x,b,a
         ldx   ,x
         pshs  x
         clra
         clrb
L04FA    ldy   ,x
         beq   L0503
         std   ,x++
         bra   L04FA
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
L051B    leay  $08,y
         cmpy  D.ModEnd
         bne   L050C
         puls  pc,u,y,x

L0524    pshs  u,y,x
         ldd   #$0002
         lbsr  F.LDDDXY
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
         bsr   L054E
         bcc   L054C
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   L054E
L054C    puls  pc,u,y,x,b

L054E    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   L0583
         ldu   $07,s
         bne   L056E
         pshs  x
         ldy   D.ModEnd
         leay  $08,y
         cmpy  ,s++
         bhi   L0583
         sty   D.ModEnd
         leay  -$08,y
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

IDCHK    pshs  y,x
         clra
         clrb
         lbsr  F.LDDDXY
         cmpd  #M$ID12
         beq   PARITY
         ldb   #E$BMID
         bra   CRCC20
PARITY    leas  -1,s
         leax  $02,x
         lbsr  DATBLEND
         ldb   #$07
         lda   #$4A
PARI10    sta   ,s
         lbsr  GETBYTE
         eora  ,s
         decb
         bne   PARI10
         leas  1,s
         inca
         beq   CRCCHK
         ldb   #E$BMHP
         bra   CRCC20



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
 lbsr DATBLEND
 leau 0,S Get crc register ptr
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
CRCC15    ldb   #E$BMCRC
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
CRCGen   ldd   R$Y,u
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
         leay  <P$DATImg,x
         ldx   $0B,s
         lbsr  DATBLEND
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
 ldu D.ModEnd Get module directory ptr
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
FMOD33    leau  -$08,u
         cmpu  D.ModDir
         bcc   FMOD10
         ldb   #E$MNF
         bra   FMOD40
FMOD35    comb
         ldb   #E$BNam
FMOD40    stb   1,s
         puls  pc,u,b,a

SKIPSP    pshs  y
SKIP10    lbsr  DATBLEND
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

PNAM     ldx   D.Proc
         leay  <P$DATImg,x
         ldx   R$X,u
         bsr   F.PRSNAM
         std   R$D,u
         bcs   PNam.x
         stx   R$X,u
         abx
PNam.x    stx   R$Y,u
         rts

F.PRSNAM    pshs  y
         lbsr  DATBLEND
         pshs  y,x
         lbsr  GETBYTE
         cmpa  #$2F
         bne   PRSNA1
         leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA1    bsr   ALPHA
         bcs   PRSNA4
         clrb
PRSNA2    incb
         tsta
         bmi   PRSNA3
         lbsr  GETBYTE
         bsr   ALFNUM
         bcc   PRSNA2
PRSNA3    andcc #$FE
         bra   PRSNA10
PRSNA4    cmpa  #$2C
         bne   PRSNA6
PRSNA5    leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA6    cmpa  #$20
         beq   PRSNA5
         comb
         ldb   #E$BNam
PRSNA10    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  F.DATLOG
         puls  pc,y,b,a,cc

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
CMPNAM   ldx   D.Proc
         leay  <P$DATImg,x
         ldx   R$X,u
         pshs  y,x
         bra   L07CF

SCMPNAM  ldx   D.Proc
         leay  <P$DATImg,x
         ldx   R$X,u
         pshs  y,x
         ldy   D.SysDat
L07CF    ldx   R$Y,u
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
         lbsr  DATBLEND
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  DATBLEND
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
         leas  -2,s
         stb   ,s
SRQM10    ldx   D.SysDat
         lslb
         ldd   b,x
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
         ldx   D.SysPrc
         lbsr  F.ALLIMG
         bcs   SRQMXX
         ldb   1,u
L088A    inc   ,y+
         decb
         bne   L088A
         lda   1,s
         std   $08,u
         clrb
SRQMXX    leas  $02,s
         rts

 page
*****
*
*  Subroutine Srtmem
*
* System Memory Return
*
SRTMEM ldd R$D,U Get byte count
         beq   SRTMXX
 addd #$FF Round up to page
 ldb R$U+1,u IS Address good?
 beq SRTM10 Branch if so
         comb
         ldb   #E$BPAddr
         rts

SRTM10    ldb   R$U,u
         beq   SRTMXX
         ldx   D.SysMem
         abx
SRTM20    ldb   ,x
         andb  #$FE
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
         cmpa  #$01
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
BOOT05 leax  BTSTR,pcr
BOOT06 lda #SYSTM+OBJCT get type
 OS9 F$LINK find bootstrap module
 bcs BOOTXX Can't boot without module
 jsr 0,Y Call boot entry
 bcs BOOTXX Boot failed
         std   D.BtSz
         stx   D.BtPtr
 leau d,x
 tfr x,d
         anda  #$E0
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
         bcc   L0995
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

L0995    comb
         ldb   #E$NoRAM
         stb   1,s
         puls  pc,y,x,b,a

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
         bls   L0995
         lda   ,-x
         bne   L09A9
         decb
         bne   L09AB
         tfr   x,y
         bra   L0983
 endc

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
         cmpa  #$01
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
         ora   #$10
         sta   P$State,x
         clrb
         puls  pc,u,y,x,b,a

FREEHB   ldb   R$B,u
         ldy   R$Y,u
         bsr   L0A31
         bcs   L0A30
         sta   R$A,u return beginning block number
L0A30    rts

L0A31    tfr   b,a
F.FREEHB    suba  #$09  DAT.BlCt+1
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   FREEBLK

FREELB   ldb   R$B,u
         ldy   R$Y,u
         bsr   FRLB20
         bcs   L0A4A
         sta   1,u
L0A4A    rts

FRLB20    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$09  DAT.BlCt+1
         negb
         pshs  b,a
         bra   FREEBLK

*****
* Get Free low block
*
FREEBLK    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  1,s
         bne   L0A75
         ldb   #E$MemFul
         cmpy  D.SysDat
         bne   L0A6C
         ldb   #E$NoRam
L0A6C    stb   $03,s
         comb
         bra   L0A82
L0A71    tfr   a,b
         addb  $02,s
L0A75    lslb
         ldx   b,y
         cmpx  #DAT.Free
         bne   FREEBLK
         inca
         cmpa  $03,s
         bne   L0A71
L0A82    leas  $02,s
         puls  pc,x,b,a

*****
*
*
*
SETIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
         ldu   R$U,u New image pointer
F.SETIMG    pshs  u,y,x,b,a
         leay  <P$DATImg,x
         lsla
         leay  a,y
L0A94    ldx   ,u++
         stx   ,y++
         decb
         bne   L0A94
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

*****
* Convert DAT block/offset to logical address
*
DATLOG   ldb   R$B,u  DAT image offset
         ldx   R$X,u Block offset
         bsr   F.DATLOG
         stx   R$X,u
         clrb
         rts

* Convert offset into real address
* Input: B, X
* Effect: updated X
F.DATLOG    pshs  x,b,a
         lslb
         lslb
         lslb
         lslb
 ifge DAT.BlSz-$2000
         lslb
 endc
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

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
H.LDAXY    pshs  cc
         lda   1,y
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,cc

* Get byte and increment X
* Input: X - location
*        A - DAT image number
* Output: A - result
*
GETBYTE lda 1,y
 pshs  cc
 orcc #IntMasks
 sta   DAT.Regs
 lda   ,x+
 clr   DAT.Regs
 puls  cc
 bra DATBLEND
GETBYTE5 leax >-DAT.BlSz,x
 leay 2,y
DATBLEND cmpx #DAT.BlSz
 bcc GETBYTE5
 rts

*****
* Load D [D+X],[Y]]
* Loads two bytes from the address space described by the DAT image
* pointed to by Y.
*
LDDDXY   ldd   R$D,u
         leau  R$X,u
         pulu  y,x
         bsr   F.LDDDXY
         std   -$07,u
         clrb
         rts

* Get word at D offset into X
F.LDDDXY    pshs  y,x
         leax  d,x
         bsr   DATBLEND
         bsr   GETBYTE
         pshs  a
         bsr   H.LDAXY
         tfr   a,b
         puls  pc,y,x,a

*****
* Load A from 0,X in task B
*
LDABX ldb R$B,u Task number
 ldx R$X,u Data pointer
 lbsr H.LDABX
 sta R$A,u
 rts

*****
* Store A at 0,X in task B
*
STABX ldd R$D,u
 ldx R$X,u
 lbra H.STABX

****
* Move data (low bound first)
*
MOVE     ldd   R$D,u Source and destination task number
         ldx   R$X,u
         ldy   R$Y,u
         ldu   R$U,u
F.MOVE    pshs  u,y,x,b,a
         leay  ,y
         lbeq  MOVE10
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
         ldd   #DAT.BlSz
         subd  ,s
         pshs  b,a
         ldd   #DAT.BlSz
         subd  $06,s
         pshs  b,a
         ldx   $08,s
         leax  >-$6000,x
         ldu   $04,s
         leau  >-$4000,u
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
         std   >DAT.Regs+5
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
MOVE10    clrb
         puls  pc,u,y,x,b,a

L0BF5    pshs  b
         tfr   x,d
         anda  #$E0    bottom page?
         beq   L0C07   yes
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

H.STABX    andcc #^CARRY clear carry
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

* Get byte from Task in B ??
H.LDBBX    andcc #^CARRY clear carry
         pshs  u,x,a,cc
         bsr   L0BF5
         bsr   L0C09
         ldd   a,u
         orcc  #IntMasks
         stb   DAT.Regs
         ldb   ,x
         clr   DAT.Regs
         puls  pc,u,x,a,cc

*****
* Allocate Process Task number
*
ALLTSK   ldx   R$X,u
F.ALLTSK    ldb   $06,x
         bne   ALLTSK10
         bsr   F.RESTSK
         bcs   TSKRET
         stb   $06,x
         bsr   F.SETTSK
ALLTSK10    clrb
TSKRET    rts

*****
* Deallocate Process Task number
*
DELTSK   ldx   R$X,u
F.DELTSK    ldb   $06,x
         beq   TSKRET
         clr   $06,x
         bra   F.RELTSK

*
* Update process task registers if changed
*
UPDTSK lda P$State,x
 bita #ImgChg Did task image change?
 bne F.SETTSK Set process task registers
 rts

*****
SETTSK   ldx   R$X,u
F.SETTSK    lda   P$State,x
         anda  #^ImgChg
         sta   P$State,x
         andcc #^CARRY clear carry
         pshs  u,y,x,b,a,cc
         ldb   P$Task,x
         leax  P$DATImg,x
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
RESTSK   bsr   F.RESTSK
         stb   R$B,u
         rts

* Find free task
F.RESTSK    pshs  x
         ldb   #2
 ldx D.Tasks
RESTSK10 lda b,x
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
RESTSK30 puls pc,x

*****
* Release Task number
*
RELTSK ldb R$B,u Task number
F.RELTSK pshs x,b
 ldb D.SysTsk
 comb
 andb 0,s
 beq RELTSK20
 ldx D.Tasks
 clr b,x
RELTSK20 puls pc,x,b

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
APROC ldx R$X,u
F.APROC clrb
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
IRQHN ldx D.Proc
 sts P$SP,x Save stack pointer of running process
 lds D.SysStk
 ldd D.SysSvc
 std D.XSWI2
 ldd D.SysIRQ
 std D.XIRQ
 jsr [D.SvcIRQ] Go to interrupt service
 bcc IRQHN10 branch if service failed
         ldx   D.Proc
         ldb   P$Task,x
         ldx   P$SP,x
         lbsr  H.LDABX
         ora   #$50
         lbsr  H.STABX
IRQHN10    orcc  #IntMasks
         ldx   D.Proc
         lda   P$State,x
         bita  #TimOut
         bne   IRQHN20
         ldu   #D.AProcQ-P$Queue Fake process ptr
         ldb   #$08
L0D6A    ldu   P$Queue,u
         beq   L0D78
         bitb  P$State,u
         bne   L0D6A
         ldb   $0A,x
         cmpb  $0A,u
         bcs   IRQHN20
L0D78    ldu   $04,x
         bra   L0DB9
IRQHN20    anda  #$DF
         sta   P$State,x
         lbsr  F.DELTSK
L0D83    lbsr  F.APROC

NPROC    ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #^IntMasks
         bra   NXTP06

NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
         lda   #$08
         ldx   #D.AProcQ-P$Queue Fake process ptr
NXTP10    leay  ,x
         ldx   P$Queue,y
         beq   NXTP04
         bita  $0C,x
         bne   NXTP10
         ldd   $0D,x
         std   P$Queue,y
         stx   D.Proc
         lbsr  F.ALLTSK
         bcs   L0D83
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   $0C,x
         bmi   SYSRET00
L0DB9    bita  #$02
         bne   NXTOUT
         lbsr  UPDTSK
         ldb   <$19,x
         beq   L0DF2
         decb
         beq   L0DEF
         leas  -$0C,s
         leau  ,s
         lbsr  L02CB
         lda   <$19,x
         sta   $02,u
         ldd   <$1A,x
         beq   NXTOUT
         std   $0A,u
         ldd   <$1C,x
         std   $08,u
         ldd   $04,x
         subd  #$000C
         std   $04,x
         lbsr  L02DA
         leas  $0C,s
         ldu   $04,x
         clrb
L0DEF    stb   <$19,x
L0DF2    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  RETIRQ

NXTOUT    lda   P$State,x Get process status
         ora #SysState Set system state
         sta   P$State,x Update status
         leas  >P$Stack,x   
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
         lbsr  UPDTSK
         orcc  #IntMasks
         puls  a
         bsr   UPDGIME
 leas 0,u Reset stack pointer
 rti

* Update GIME INIT1 register
UPDGIME sta D.SSTskN System State Task Number
         beq   UPDG10
         ora   D.TINIT
         sta   D.TINIT
         sta   DAT.Task
UPDG10 rts

SVCIRQ   jmp   [D.Poll]

IOPOLL orcc #CARRY
 rts

* Restore DAT image and return from interrupt
*
RETIRQ    ldb   $06,x
         orcc  #IntMasks
         bsr   L0E8D
         lda   D.TINIT
         ora   #$01
         sta   D.TINIT
         sta   DAT.Task
         leas  ,u
         rti

* Switch task and execute user supplied SWI vector
*
JMPUSWI    ldb   D.TINIT
         orb   #$01
         stb   D.TINIT
 stb DAT.Task
 jmp 0,U Execute user interrupt handler

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

SWI3RQ    orcc  #IntMasks
         ldb   #D.SWI3
         bra   IRQ10

SWI2RQ    orcc  #IntMasks
         ldb   #D.SWI2
         bra   IRQ10

FIRQ   ldb   #D.FIRQ
         bra   IRQ10

IRQ    orcc  #IntMasks
         ldb   #D.IRQ

IRQ10    lda   #SysTask
         sta   DAT.Task
         clra
         tfr   a,dp
         lda   D.TINIT
         anda  #$FE
         sta   D.TINIT
         sta   DAT.Task
         clra
         tfr   d,x
         jmp   [,x]

SWIRQ    ldb   #D.SWI
         bra   IRQ10

NMI    ldb   #D.NMI
         bra   IRQ10

         emod
OS9End      equ   *
 fcc /99999/

SYSVEC fdb TICK+$FFDE-* Clock tick handler
 fdb SWI3HN+$FFE0-* Swi3 handler
 fdb SWI2HN+$FFE2-* Swi2 handler
 fdb 0000+$FFE4-*  Fast irq handler
 fdb IRQHN+$FFE6-* Irq handler
 fdb SWIHN+$FFE8-* Swi handler
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
