 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from Dragon 128/Dragon Beta computer.
* The CPUType is called DRG128, and CPUSpeed is TwoMHz
********************************

 ifp1
 use defsfile
 endc

*****
*
*  Module Header
*
Revs set REENT+8
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam fcs /OS9p1/
 fcb 12 Edition number

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
 std D.Tasks+2
 clrb
 inca
 std D.BlkMap
 adda #1
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
COLD30 std ,x++
 cmpx #D.NMI
 bls COLD30
 leax >ROMEnd,pcr
 pshs x
 leay SYSVEC,PCR Get interrupt entries
 ldx #D.Clock
COLD45 ldd ,Y++ get vector
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.XNMI end of dp vectors?
 bls COLD45 branch if not
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
 ifeq CPUType-DRG128
 lda #$D8
 sta D.GRReg  Graphics control port
 endc
 clra
 clrb
 std ,x++
 ldy #$000D
 ldd #DAT.Free
L00D7    std   ,x++
         leay  -1,y
         bne   L00D7
         ldb   #ROMBlock
         std   ,x++
         ldd   #$00FF  IOBlock
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         ldx   D.SysMem
         ldb   D.ModDir+2
L00EE    inc   ,x+
         decb
         bne   L00EE
         ldy   #HIRAM
         ldx   D.BlkMap
L00F9    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$FF
         beq   COLD15
         stb   >$FE01  DAT.Regs+1
         ldu   ,y
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD15 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD15 If not, eor
         stu   0,y
         bra   L0122
COLD15    ldb   #$80
         stb   [,s]
L0122    puls  x
         leax  1,x
         cmpx  D.BlkMap+2
         bcs   L00F9
         ldx   D.BlkMap
         inc   ,x
         ldx   D.BlkMap+2
         leax  >-16,x
L0134    lda   ,x
         beq   L0187
         tfr   x,d
         subd  D.BlkMap
         leas  <-32,s
         leay  ,s
         bsr   L01B7
         pshs  x
         ldx   #$0000
L0148    pshs  y,x
         lbsr  L0B0B
         ldb   1,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   L0170
         lbsr  VALMOD
         bcc   L0166
         cmpb  #E$KwnMod Is it known module
         bne   L0170
L0166    ldd   #M$Size Get module size
         lbsr  LDDX
         leax  d,x Skip module
         bra   L0172
L0170    leax  1,x Try next location
L0172    tfr   x,d
         tstb
         bne   L0148
         bita  #$0F
         bne   L0148
         lsra
         lsra
         lsra
         lsra
         deca
         puls  x
         leax  a,x
         leas  <$20,s
L0187    leax  1,x
         cmpx  D.BlkMap+2
         bcs   L0134
L018D    leax  CNFSTR,pcr
         bsr   L01B1
         bcc   L019C
         os9   F$Boot
         bcc   L018D
         bra   L01AB
L019C    stu   D.Init
L019E    leax  OS9STR,pcr
         bsr   L01B1
         bcc   L01AF
         os9   F$Boot
         bcc   L019E
L01AB    jmp   [>D$REBOOT]

L01AF    jmp 0,Y Let os9 part two finish

L01B1    lda #SYSTM Get system type module
         os9   F$Link
         rts

L01B7    pshs  y,x,b,a
         ldb   #DAT.BlCt
         ldx   ,s
L01BD    stx   ,y++
         leax  1,x
         decb
         bne   L01BD
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
 ifeq CPUType-DRG128
 fcb F$GMap     $54 request graphics memory
 fdb GFXMAP-*-2
 fcb F$GClr     $55 return graphics memory
 fdb GFXCLR-*-2
 endc
 fcb $80

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name
BTSTR fcs /Boot/

JMPMINX jmp [<-$10,x] Jump to the "x" version of the interrupt

SWI3HN ldx D.Proc
         ldu   P$SWI3,x
         beq   L0257

L0244    lbra  CHGTASK

SWI2HN ldx   D.Proc
         ldu   P$SWI2,x
         beq   L0257
         bra   L0244

SWIHN    ldx   D.Proc
         ldu   P$SWI,x
         bne   L0244

L0257    ldd   D.SysSvc
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
         bsr   L0294
         ldb   P$Task,x
         ldx   R$PC,u
         lbsr  L1149 Get byte from other Task
         leax  1,x
         stx   R$PC,u
         ldy   D.UsrDis
         lbsr  DISPCH
         ldb   R$CC,u
         andb  #$AF
         stb   R$CC,u
         ldx   D.Proc
         bsr   L029E
         lda   P$State,x
         anda  #$7F
         lbra  L0C5F

L0294    lda   P$Task,x
         ldb   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   P$SP,x
         bra   L02A8

L029E    ldb   P$Task,x
         lda   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   P$SP,x
         exg   x,u
L02A8    ldy   #$0006
         tfr   b,dp
         orcc  #IntMasks
         lbra  L1171

*****
*
*  Subroutine SYSREQ
*
* Service Routine Dispatch
*
* Process software interupts from system state
* Entry: U=Register stack pointer
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
         lbra  L0D04

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
L02F9    clra
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
         bne   L02F9
         rts

SLINK    ldy   R$Y,u
         bra   L0324

ELINK    pshs  u
         ldb   R$B,u
         ldx   R$X,u Get name ptr
         bra   LINK10

LINK     ldx   D.Proc
         leay  P$DATImg,x
L0324    pshs  u
         ldx   R$X,u
         lda   R$A,u
         lbsr  FMOD05
         lbcs  LINKXit
         leay  ,u
         ldu   ,s
         stx   R$X,u
         std   R$D,u
         leax  ,y
LINK10    bitb #REENT is this sharable
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
         inca
         lsra
         lsra
         lsra
         lsra
 ifge DAT.BlSz-$2000
         lsra
 endc
         pshs  a
         leau  ,y
         bsr   L03AD
         bcc   L0376
         lda   ,s
         lbsr  L0A56
         bcc   L0373
         leas  $05,s
         ldb   #E$MemFul
         bra   LINKXit
L0373    lbsr  L0AA8
L0376    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  1,x
         beq   L0387
         stx   ,u
L0387    ldu   $03,s
         ldx   $06,u
         leax  1,x
         beq   L0391
         stx   $06,u
L0391    puls  u,y,x,b
         lbsr  L0ACC
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #M$EXEC Get execution offset
         lbsr  LDDX
         addd  R$U,u
         std   R$Y,u Return it to user
         clrb
         rts

LINKXit orcc #CARRY
 puls pc,u

L03AD    ldx   D.Proc
         leay  P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #DAT.BlCt
         negb
         lslb
         leay  b,y
L03BB    ldx   ,s
         pshs  u,y
L03BF    ldd   ,y++
         cmpd  ,u++
         bne   L03D4
         leax  -1,x
         bne   L03BF
         puls  u,b,a
         subd  $04,s
         lsrb
         stb   ,s
         clrb
         puls  pc,y,x,b,a
L03D4    puls  u,y
         leay  -$02,y
         cmpy  $04,s
         bcc   L03BB
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
 bcs   L0422
 pshs  a
 andb  #Revsmask
 subb  ,s+
 bcs   L0422
 ldb   #E$KwnMod
 bra   BADVAL
VMOD10 ldb #E$DirFul Err: directory full
BADVAL orcc #CARRY SET Carry
 puls pc,y,x

L0422    ldx   ,s
         lbsr  L04AE
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
         bra   L0449
L0447    leax  $08,x
L0449    cmpx  D.ModEnd
         bcc   L0458
         cmpx  ,s
         beq   L0447
         cmpy  [,x]
         bne   L0447
         bsr   L047C
L0458    puls  u
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
L0468    pshs  x,a
         ldd   ,y++
         leax  d,x
         ldb   ,x
         orb   #$02
         stb   ,x
         puls  x,a
         deca
         bne   L0468
         clrb
         puls  pc,y,x
L047C    pshs  u,y,x,b,a
         ldx   ,x
         pshs  x
         clra
         clrb
L0484    ldy   ,x
         beq   L048D
         std   ,x++
         bra   L0484
L048D    puls  x
         ldy   $02,s
         ldu   ,u
         puls  b,a
L0496    cmpx  ,y
         bne   L04A5
         stu   ,y
         cmpd  $02,y
         bcc   L04A3
         ldd   $02,y
L04A3    std   $02,y
L04A5    leay  $08,y
         cmpy  D.ModEnd
         bne   L0496
         puls  pc,u,y,x
L04AE    pshs  u,y,x
         ldd   #$0002
         lbsr  LDDX
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
         bsr   L04D7
         bcc   L04D5
         os9   F$GCMDir
         ldu   #$0000
         stu   $05,s
         bsr   L04D7
L04D5    puls  pc,u,y,x,b
L04D7    ldx   D.ModDAT
         leax  d,x
         cmpx  D.ModEnd
         bcs   L050C
         ldu   $07,s
         bne   L04F7
         pshs  x
         ldy   D.ModEnd
         leay  $08,y
         cmpy  ,s++
         bhi   L050C
         sty   D.ModEnd
         leay  -$08,y
         sty   $07,s
L04F7    stx   D.ModDAT
         ldy   $05,s
         ldb   $02,s
         stx   $05,s
L0500    ldu   ,y++
         stu   ,x++
         decb
         bne   L0500
         clr   ,x
         clr   1,x
         rts
L050C    orcc  #$01
         rts

IDCHK    pshs  y,x
         clra
         clrb
         lbsr  LDDX
 cmpd #M$ID12 Check them
         beq   L0520
         ldb   #E$BMID
         bra   L057C
L0520    leas  -1,s
         leax  $02,x
         lbsr  L0B0B
         ldb   #$07
         lda   #$4A
L052B    sta   ,s
         lbsr  GETBYTE
         eora  ,s
         decb
         bne   L052B
         leas  1,s
         inca
         beq   L053E
         ldb   #E$BMHP
         bra   L057C
L053E    puls  y,x
         ldd   #$0002
         lbsr  LDDX
         pshs  y,x,b,a
         ldd   #$FFFF
         pshs  b,a
         pshs  b
         lbsr  L0B0B
         leau  ,s
L0554    tstb
         bne   L0561
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
L0561    lbsr  GETBYTE
         bsr   CRCCAL
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   L0554
         puls  y,x,b
         cmpb  #$80
         bne   L057A
         cmpx  #$0FE3
         beq   L057E
L057A    ldb   #$E8
L057C    orcc  #$01
L057E    puls  pc,y,x


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
         beq   CRCGen20 branch if none
         ldx   R$X,u get data ptr
         pshs  x,b,a
         leas  -$03,s
         ldx   D.Proc
         lda   $06,x
         ldb   D.SysTsk
         ldx   R$U,u
         ldy   #$0003
         leau  ,s
         pshs  y,x,b,a
         lbsr  L0B47
         ldx   D.Proc
         leay  P$DATImg,x
         ldx   $0B,s
         lbsr  L0B0B
CRCGen10 lbsr GETBYTE get next data byte
         lbsr CRCCAL update crc
         ldd   9,s
         subd  #1 count byte
         std   9,s
         bne   CRCGen10 branch if more
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  L0B47
         leas  7,s
CRCGen20 clrb
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
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModDir Get module directory ptr
 bra FMOD33 Test if end is reached
FMOD10    pshs  y,x,b,a
         pshs  y,x
         ldy   0,u
         beq   FMOD20
         ldx   M$NAME,U Get name offset
         pshs  y,x
         ldd #M$NAME Get name offset
         lbsr LDDX
         leax d,x Get name ptr
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  CHKNAM
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
 anda #LangMask
 bne FMOD30 Branch if different
FMOD16    puls  y,x,d Retrieve registers
         abx
         clrb
         ldb   1,s
         leas  $04,s
         rts
FMOD20    leas  $04,s
         ldd   $08,s
         bne   FMOD30
         stu   $08,s
FMOD30   puls  y,x,d
         leau  $08,u
FMOD33   cmpu  D.ModEnd
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
L069E    lbsr  L0B0B
         lbsr  L0AE3
         leax  1,x
         cmpa  #$20
         beq   L069E
         leax  -1,x
         pshs  a
         tfr   y,d
         subd  1,s
         asrb
         lbsr  L0ACC
         puls  pc,y,a

PNAM     ldx   D.Proc
         leay  P$DATImg,x
         ldx   R$X,u Get string ptr
 bsr PRSNAM Call parse name
 std R$D,U Return byte & size
 bcs PNam.x branch if error
 stx R$X,U Return updated string ptr
         abx
PNam.x stx R$Y,U Return name end ptr
 rts

PRSNAM    pshs  y
         lbsr  L0B0B
         pshs  y,x
         lbsr  GETBYTE
 cmpa #'/ Slash?
 bne PRSNA1 ..no
         leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA1    bsr   L072B
         bcs   PRSNA4
         clrb
PRSNA2 incb INCREMENT Character count
         tsta
         bmi   PRSNA3
         lbsr  GETBYTE
         bsr   L0714
         bcc   PRSNA2
PRSNA3 andcc #^CARRY clear carry
         bra   L0706
PRSNA4 cmpa #', Comma (skip if so)?
         bne   PRSNA6
PRSNA5    leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA6 cmpa #$20 Space?
 beq PRSNA5 ..yes; skip
 comb (NAME Not found)
 ldb #E$BNam 
L0706    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  L0ACC
         puls  pc,y,b,a,cc

L0714    pshs  a
         anda  #$7F
 cmpa #'. period?
 beq RETCC branch if so
 cmpa #'0 Below zero?
 blo RETCS ..yes; return carry set
 cmpa #'9 Numeric?
 bls RETCC ..yes
 cmpa #'_ Underscore?
 bne ALPHA
RETCC clra
 puls  pc,a
L072B    pshs  a
 anda  #$7F
ALPHA cmpa #'A
 blo RETCS
 cmpa #'Z Upper case alphabetic?
 bls RETCC ..yes
 cmpa #$61 Below lower case a?
 blo RETCS ..yes
 cmpa #$7A Lower case?
 bls RETCC ..yes
RETCS    coma Set carry
         puls  pc,a

CMPNAM   ldx   D.Proc
         leay  P$DATImg,x
         ldx   R$X,u
         pshs  y,x
         bra   L0759

SCMPNAM  ldx   D.Proc
         leay  P$DATImg,x
         ldx   R$X,u
         pshs  y,x
         ldy   D.SysDAT
L0759    ldx   $06,u
         pshs  y,x
         ldd   R$D,u
         leax  $04,s
         leay  ,s
         bsr   CHKNAM
         leas  $08,s
         rts

CHKNAM    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  L0B0B
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  L0B0B
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
L07B9    ldx   D.SysDAT
         lslb
         ldd   b,x
         cmpd  #DAT.Free
         beq   L07D1
         ldx   D.BlkMap
         lda   d,x
         cmpa  #$01
         bne   L07D2
         leay  <$10,y
         bra   L07D9
L07D1    clra
L07D2    ldb   #$10
L07D4    sta   ,y+
         decb
         bne   L07D4
L07D9    inc   ,s
         ldb   ,s
         cmpb  #DAT.BlCt
         bcs   L07B9
L07E1    ldb   1,u
L07E3    cmpy  D.SysMem
         bhi   L07ED
         comb
         ldb   #E$MemFul Get error code
         bra   L081C
L07ED    lda   ,-y
         bne   L07E1
         decb
         bne   L07E3
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
         lbsr  L0918
         bcs   L081C
         ldb   1,u
L0812    inc   ,y+
         decb
         bne   L0812
         lda   1,s
         std   $08,u
         clrb
L081C    leas  $02,s
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

SRTM10    ldb   R$U,u
         beq   SRTMXX  Branch if returning nothing
         ldx   D.SysMem
         abx
L0835    ldb   ,x
         andb  #$FE
         stb   ,x+
         deca
         bne   L0835
         ldx   D.SysDAT
         ldy   #$0010
L0844    ldd   ,x
         cmpd  #DAT.Free
         beq   L0873
         ldu   D.BlkMap
         lda   d,u
         cmpa  #$01
         bne   L0873
         tfr   x,d
         subd  D.SysDAT
         lslb
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #$10
L0861    lda   ,u+
         bne   L0873
         decb
         bne   L0861
         ldd   ,x
         ldu   D.BlkMap
         clr   d,u
         ldd   #DAT.Free
         std   ,x
L0873    leax  $02,x
         leay  -1,y
         bne   L0844
SRTMXX   clrb
         rts

BOOT     comb
         lda   D.Boot
         bne   L08DE
         inc   D.Boot
         ldx   D.Init
         beq   L088F
         ldd   BootStr,x   <$14,x
         beq   L088F
         leax  d,x
         bra   L0893
L088F    leax  >BTSTR,pcr
L0893    lda #SYSTM+OBJCT Get object type
         os9   F$Link
         bcs   L08DE
         jsr   ,y
         bcs   L08DE
         leau  d,x
         tfr   x,d
         anda  #$F0
         clrb
         pshs  u,b,a
         lsra
         lsra
         lsra
         ldy   D.SysDAT
         leay  a,y
L08AF    ldd   ,x
         cmpd  #M$ID12
         bne   L08D6
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         os9   F$VModul
         pshs  b
         ldd   1,s
         leax  d,x
         puls  b
         bcc   L08D0
         cmpb  #$E7
         bne   L08D6
L08D0    ldd   $02,x
         leax  d,x
         bra   L08D8
L08D6    leax  1,x
L08D8    cmpx  $02,s
         bcs   L08AF
         leas  $04,s
L08DE    rts

ALLRAM   ldb   R$B,u Get number of blocks
         bsr   L08E8
         bcs   L08E7
         std   R$D,u
L08E7    rts

L08E8    pshs  y,x,b,a
         ldx   D.BlkMap
L08EC    leay  ,x
         ldb   1,s
L08F0    cmpx  D.BlkMap+2
         bcc   L090D
         lda   ,x+
         bne   L08EC
         decb
         bne   L08F0
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   1,s
         stb   1,s
L0905    inc   ,y+
         deca
         bne   L0905
         clrb
         puls  pc,y,x,b,a

L090D    comb
         ldb   #E$NoRam
         stb   1,s
         puls  pc,y,x,b,a

ALLIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
L0918    pshs  u,y,x,b,a
         lsla
         leay  P$DATImg,x
         leay  a,y
         clra
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
L0927    ldd   ,y++
         cmpd  #DAT.Free
         beq   L093C
         lda   d,u
         cmpa  #$01
         puls  b,a
         bne   L096A
         subd  #$0001
         pshs  b,a
L093C    leax  -1,x
         bne   L0927
         ldx   ,s++
         beq   L0973
*
         leau  <$20,u
*
L0947    lda   ,u+
         bne   L094F
         leax  -1,x
         beq   L0973
L094F    cmpu  D.BlkMap+2
         bcs   L0947
         ldu   D.BlkMap
         clrb
         leay  >L09D2,pcr
L095B    lda   b,y
         lda   a,u
         bne   L0965
         leax  -1,x
         beq   L0973
L0965    incb
         cmpb  #$20
         bcs   L095B
L096A    ldb   #$CF
         leas  $06,s
         stb   1,s
         comb
         puls  pc,u,y,x,b,a
L0973    puls  u,y,x
         leau  <$20,u
L0978    ldd   ,y++
         cmpd  #DAT.Free
         bne   L0991
L0980    cmpu  D.BlkMap+2
         beq   L0997
         lda   ,u+
         bne   L0980
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         std   -$02,y
L0991    leax  -1,x
         bne   L0978
         bra   L09C7
L0997    ldu   D.BlkMap
         clrb
         bra   L09A8
L099C    pshs  b
         ldd   ,y++
         cmpd  #DAT.Free
         puls  b
         bne   L09C3
L09A8    pshs  y
         leay  >L09D2,pcr
L09AE    lda   b,y
         incb
         tst   a,u
         bne   L09AE
         inc   a,u
         pshs  b
         tfr   a,b
         clra
         ldy   1,s
         std   -$02,y
         puls  y,b
L09C3    leax  -1,x
         bne   L099C
L09C7    ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

L09D2    fcb $00,$01,$02,$03,$04,$05,$06,$07
         fcb $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
         fcb $10,$11,$12,$13,$14,$15,$16,$17
         fcb $18,$19,$1A,$1B,$1C,$1D,$1E,$1F

 ifeq CPUType-DRG128
* OS-9 Level 2 normally allocates memory blocks from physical
* block 0 upwards. On the Dragon 128 the first 128k bytes (32
* blocks) can be allocated to the screen. In certain screen
* modes the same blocks in the two 64k byte pages must be
* allocated together, (eg blocks 10 to 14 with blocks 26 to 30).
* Therefore OS-9 has been expanded with the addition of two
* system calls to manage screen memory. F$GMap reserves screen
* memory, in the lower or both pages. F$GClr returns the memory.
* In order to maximise the availability of memory for the screen
* display, the normal OS-9 memory allocation routines have been
* modified . First, any memory above the first 32 block s is used.
* Then blocks a reallocated from the first 32 in an order
* designed to maximise the availability of screen memory, (which
* is allocated by F$GMap from the top down). This order is
* determined by a table in the source file BlkTrans, used in the
* assembly of OS9P1 and IOMAN.

* F$GMap
* Input B = number of 4k blocks required in each 64k page
*       A = 0 required in lower page only
*           1 required in both pages
* Output X = first block number in lower page
*            or carry set, B has error code, if memory not available
GFXMAP   ldb   R$B,u
         bsr   L09FB
         bcs   L09FA
         stx   R$X,u
L09FA    rts
L09FB    pshs  x,b,a
         ldx   D.BlkMap
         leax  <$20,x
L0A02    ldb   1,s
L0A04    cmpx  D.BlkMap
         beq   L0A1F
         tst   ,-x
         bne   L0A02
         decb
         bne   L0A04
         tfr   x,d
         subd  D.BlkMap
         std   $02,s
         ldd   ,s
L0A17    inc   ,x+
         decb
         bne   L0A17
         clrb
         puls  pc,x,b,a
L0A1F    comb
         ldb   #$ED
         stb   1,s
         puls  pc,x,b,a

* F$GClr
* Input B = number of blocks to deal locate in each 64k page
*       A = 0 deallocate in lower page only
*           1 deallocate in both pages
*       X = first block number in lower page
* Output: None
GFXCLR   ldb   R$B,u
         ldx   R$X,u
         pshs  x,b,a
         abx
         cmpx  #$0020
         bhi   L0A45
         ldx   D.BlkMap
         ldd   $02,s
         leax  d,x
         ldb   1,s
         beq   L0A45
L0A3C    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0A3C
L0A45    clrb
         puls  pc,x,b,a
 endc

FREEHB   ldb   R$B,u Get block count
         ldy   R$Y,u DAT image pointer
         bsr   L0A54
         bcs   L0A53
         sta   R$A,u return beginning block number
L0A53    rts

L0A54    tfr   b,a
L0A56    suba  #$11  DAT.BlCt+1
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   L0A7B

FREELB   ldb   R$B,u Get block count
         ldy   R$Y,u DAT image pointer
         bsr   L0A6E
         bcs   L0A6D
         sta   R$A,u return beginning block number
L0A6D    rts

L0A6E    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$11  DAT.BlCt+1
         negb
         pshs  b,a
         bra   L0A7B

L0A7B    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  1,s
         bne   L0A91
         ldb   #E$MemFul
         stb   $03,s
         comb
         bra   L0A9E
L0A8D    tfr   a,b
         addb  $02,s
L0A91    lslb
         ldx   b,y
         cmpx  #DAT.Free
         bne   L0A7B
         inca
         cmpa  $03,s
         bne   L0A8D
L0A9E    leas  $02,s
         puls  pc,x,b,a

SETIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
         ldu   R$U,u New image pointer
L0AA8    pshs  u,y,x,b,a
         leay  P$DATImg,x
         lsla
         leay  a,y
L0AB0    ldx   ,u++
         stx   ,y++
         decb
         bne   L0AB0
         ldx   $02,s
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         clrb
         puls  pc,u,y,x,b,a

DATLOG   ldb   R$B,u  DAT image offset
         ldx   R$X,u Block offset
         bsr   L0ACC
         stx   R$X,u Return logical address
         clrb
         rts
L0ACC    pshs  x,b,a
         lslb
         lslb
         lslb
         lslb
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

LDAXY    ldx   R$X,u Block offset
         ldy   R$Y,u DAT image pointer
         bsr   L0AE3
         sta   R$A,u
         clrb
         rts

L0AE3    pshs  cc
         lda   1,y
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,cc

GETBYTE    lda   1,y
         pshs  cc
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x+
         clr   DAT.Regs
         puls  cc
         bra   L0B0B
L0B05    leax  >-DAT.BlSz,x
         leay  $02,y
L0B0B    cmpx  #DAT.BlSz
         bcc   L0B05
         rts

LDDDXY   ldd   R$D,u Offset to the offset within DAT image
         leau  $04,u
         pulu  y,x
         bsr   LDDX
         std   -$07,u
         clrb
         rts

* Get word at D offset into X
LDDX pshs  y,x
 leax  d,x
         bsr   L0B0B
 bsr GETBYTE
 pshs  a
         bsr   L0AE3
 tfr a,b
 puls  pc,y,x,a

LDABX    ldb   R$B,u Task number
         ldx   R$X,u Data pointer
         lbsr  L1125
         sta   R$A,u
         rts

STABX    ldd   R$D,u
         ldx   R$X,u
         lbra  L1137

MOVE     ldd   R$D,u Source and destination task number
         ldx   R$X,u Source pointer
         ldy   R$Y,u Byte count
         ldu   R$U,u  Destination pointer
L0B47    andcc #^CARRY clear carry
         leay  ,y
         beq   L0B5C
         pshs  u,y,x,dp,b,a,cc
         tfr   y,d
         lsra
         rorb
         tfr   d,y
         ldd   1,s
         tfr   b,dp
         lbra  L115B
L0B5C    rts

ALLTSK   ldx   R$X,u  Get process descriptor
L0B5F    ldb   P$Task,x
         bne   L0B6B
         bsr   L0B9E
         bcs   L0B6C
         stb   P$Task,x
         bsr   SETTSK10
L0B6B    clrb
L0B6C    rts

DELTSK   ldx   R$X,u  Get process descriptor
L0B6F    ldb   P$Task,x
         beq   L0B6C
         clr   P$Task,x
         bra   RELTSK10

* Did task image change?
UPDTSK lda P$State,x
 bita #ImgChg
 bne SETTSK10
 rts

SETTSK   ldx   R$X,u
SETTSK10    lda   P$State,x
         anda  #$EF
         sta   P$State,x
         andcc #^CARRY clear carry
         pshs  u,y,x,b,a,cc
         ldb   P$Task,x
         leax  P$DATImg,x
         ldy   #$0010
         ldu   #$FE00
         lbra  L118E

RESTSK   bsr   L0B9E
         stb   R$B,u Get task number
         rts

* Find free task
L0B9E    pshs  x
         ldb   #1
         ldx   D.Tasks
L0BA4    lda   b,x
         beq   L0BB2
         incb
         cmpb  #DAT.TkCt
         bne   L0BA4
         comb
         ldb   #E$NoTask
         bra   L0BB7
L0BB2    inc   b,x
         orb   D.SysTsk
         clra
L0BB7    puls  pc,x

RELTSK   ldb   R$B,u
RELTSK10 pshs x,b
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
 bsr ACTPRC Activate process
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
ACTPRC clrb
 pshs  u,y,x,cc
 lda P$Prior,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQMask+FIRQMask Set interrupt masks
 ldu #D.AProcQ-P$Queue Fake process ptr
         bra   L0C21
L0C17    inc   P$AGE,u
         bne   L0C1D
         dec   P$AGE,u
L0C1D    cmpa P$AGE,U Who has bigger priority?
         bhi   L0C23
L0C21    leay 0,U Copy ptr to this process
L0C23  ldu P$Queue,U Get ptr to next process
         bne   L0C17
         ldd   P$Queue,y
         stx   P$Queue,y
         std   P$Queue,x
         puls  pc,u,y,x,cc

*****
*
*  Irq Handler
*
IRQHN    ldx   D.Proc
         sts   P$SP,x
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         jsr   [D.SvcIRQ]
         bcc   L0C53
         ldx   D.Proc
         ldb   P$Task,x
         ldx   P$SP,x
         lbsr  L1125
         ora   #$50
         lbsr  L1137
L0C53    orcc  #IntMasks
         ldx   D.Proc
         ldu   P$SP,x
         lda   P$State,x
         bita  #$20
         beq   L0C9E
L0C5F    anda  #$DF
         sta   P$State,x
         lbsr  L0B6F
L0C66    bsr   ACTPRC

NPROC    ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #^IntMasks
         bra   NXTP06

NXTP04 cwai #$FF-IRQMask-FIRQMask Clear interrupt masks & wait
NXTP06 orcc #IRQMask+FIRQMask Set interrupt masks
         ldy   #D.AProcQ-P$Queue Fake process ptr
         bra   L0C7F
L0C7D    leay  ,x
L0C7F    ldx   P$Queue,y
         beq   NXTP04
         lda   P$State,x
         bita  #Suspend
         bne   L0C7D
         ldd   P$Queue,x
         std   P$Queue,y
         stx   D.Proc
         lbsr  L0B5F
         bcs   L0C66
         lda   D.TSlice
         sta   D.Slice
         ldu   P$SP,x
         lda   P$State,x Is process in system state?
         bmi   L0D04
L0C9E    bita  #Condem Is process condemmed?
         bne   NXTOUT
         lbsr  UPDTSK
         ldb   P$Signal,x
         beq   L0CD7
         decb
         beq   L0CD4
         leas  -$0C,s
         leau  ,s
         lbsr  L0294
         lda   P$Signal,x
         sta   $02,u
         ldd   P$SigVec,x
         beq   NXTOUT
         std   $0A,u
         ldd   P$SigDat,x
         std   $08,u
         ldd   P$SP,x
         subd  #$0C
         std   P$SP,x
         lbsr  L029E
         leas  $0C,s
         ldu   P$SP,x
         clrb
L0CD4    stb   P$Signal,x
L0CD7    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  L0E11

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
SYSIRQ    jsr   [D.SvcIRQ]
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti

L0D04    ldx   D.SysPrc
         lbsr  UPDTSK
         leas  ,u
         rti

SVCIRQ   jmp   [D.Poll]

IOPOLL   orcc  #$01
         rts

DATINT clra
         tfr   a,dp
         ldx   #DAT.Task
         lda   1,x
         lbne  L0DF2
         ldb   #$04
         stb   1,x
         lda   #$F0
         sta   0,x
         clra
         sta   1,x
         lda   #$CF
         sta   ,x
         lda   #$FF
         sta   $02,x
         lda   #$3E
         sta   1,x
         stb   $03,x
         lda   #$D8
         sta   $02,x
         ldy   #$FE00  DAT.Regs
         ldb   #$F0
L0D42    stb   ,x
         clra
         sta   ,y
         lda   #$1F
         sta   $06,y
         lda   #$FE
         sta   $E,y
         lda   #$FF
         sta   $F,y
         incb
         bne   L0D42
         lda   #$F0
         sta   ,x
         ldx   #A.Mouse
         lda   #$7F
         ldb   #$04
         stb   1,x
         sta   ,x
         stb   $03,x
         lda   #$02
         sta   $02,x
         clra
         sta   $03,x
         lda   #$83
         sta   $02,x
         stb   $03,x
         lda   #$02
         sta   1,x
         lda   #$FF
         sta   ,x
         stb   1,x
         ldx   #$FC22 A.P+2
         lda   #$18
         sta   ,x
         stb   1,x
         ldx   #A.Crtc address of 6845 CRTC
         clrb
         leay  >L0DBE,pcr
L0D8F    lda   ,y+
         stb   ,x
         sta   1,x
         incb
         cmpb  #$10
         bcs   L0D8F
         lda   #$B0
         sta   DAT.Task
         ldx   #$6000
         ldd   #$2008
L0DA5    std   ,x++
         cmpx  #$7000
         bne   L0DA5
         leay  >LOADMSG,pcr
         ldx   #$63C0
L0DB3    lda   ,y+
         beq   L0DBB
         sta   ,x++
         bra   L0DB3
L0DBB    lbra  COLD

L0DBE    fcb $37,$28,$2E,$35,$1E,$02,$19,$1B,$50,$09,$20,$09,$38,$00,$38,$00
LOADMSG  fcc " OS-9 is loading - please wait ...."
         fcb 0

L0DF2    lds   #$FFFF
         sync

NMIHN    lds   #$FFFF
         ldx   D.DMPort
         ldu   D.DMMem
         ldb   D.DMDir
         bne   L0E0A
L0E03    sync
         lda   ,x
         sta   ,u+
         bra   L0E03
L0E0A    lda   ,u+
L0E0C    sync
L0E0D    sta   ,x
         bra   L0E0A
L0E11    ldb   P$Task,x
         orcc  #IntMasks
         stb   DAT.Task
         leas  ,u
         rti

* Switch task
CHGTASK ldb   P$Task,x
 stb   DAT.Task
 jmp   0,u

 emod
OS9End equ *

Target set $1225-$100
 use filler

L1125    andcc #^CARRY clear carry
         pshs  b,cc
         orcc  #IntMasks
         stb   DAT.Task
         lda   ,x
         ldb   #SysTask
         stb   DAT.Task
         puls  pc,b,cc

* Store register A
L1137    andcc #^CARRY clear carry
         pshs  b,cc
         orcc  #IntMasks
         stb   DAT.Task
         sta   ,x
         ldb   #SysTask
         stb   DAT.Task
         puls  pc,b,cc

* Get byte from Task in B
L1149    andcc #^CARRY clear carry
         pshs  a,cc
         orcc  #IntMasks
         stb   DAT.Task
         ldb   ,x
         lda   #SysTask
         sta   DAT.Task
         puls  pc,a,cc

L115B    orcc  #IntMasks
         bcc   L1171
         sta   DAT.Task
         lda   ,x+
         stb   DAT.Task
         sta   ,u+
         leay  1,y
         bra   L117F
L116D    lda   1,s
         orcc  #IntMasks
L1171    sta   DAT.Task
         ldd   ,x++
         exg   b,dp
         stb   DAT.Task
         exg   b,dp
         std   ,u++
L117F    lda   #SysTask
         sta   DAT.Task
         lda   ,s
         tfr   a,cc
         leay  -1,y
         bne   L116D
         puls  pc,u,y,x,dp,b,a,cc

L118E    orcc  #IntMasks
L1190    lda   1,x
         leax  $02,x
         stb   DAT.Task
         sta   ,u+
         lda   #SysTask
         sta   DAT.Task
         leay  -1,y
         bne   L1190
         puls  pc,u,y,x,b,a,cc

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
IRQ20    clra
         tfr   a,dp
         tfr   d,x
         jmp   [,x]

SWIRQ    ldb   #D.SWI
         bra   IRQ10

NMI      ldb   #D.NMI
         bra   IRQ20

Target set $1225-$20
 use filler

SYSVEC fdb TICK+$FFE0-* Clock tick handler
 fdb SWI3HN+$FFE2-* Swi3 handler
 fdb SWI2HN+$FFE4-* Swi2 handler
 fdb 0000+$FFE6-*  Fast irq handler
 fdb IRQHN+$FFE8-* Irq handler
 fdb SWIHN+$FFEA-* Swi handler
 fdb NMIHN+$FFEC-* Nmi handler
 fdb COLD+$FFEE-*

 fdb 0000+$FFF0-*
 fdb SWI3RQ+$FFF2-* Swi3
 fdb SWI2RQ+$FFF4-* Swi2
 fdb FIRQ+$FFF6-* Firq
 fdb IRQ+$FFF8-* Irq
 fdb SWIRQ+$FFFA-* Swi
 fdb NMI+$FFFC-* Nmi
 fdb DATINT+$FFFE-* Dynamic address translator initialization
ROMEnd equ *


 end
