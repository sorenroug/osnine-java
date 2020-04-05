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
         std   D.Tasks
         addb  #DAT.TkCt
         std   D.TskIPt
         clrb
         inca
         std   D.BlkMap
         addd  #$0040
         std   D.BlkMap+2
         clrb
         inca
         std   D.SysDis
         inca
         std   D.UsrDis
         inca
         std   D.PrcDBT
         inca
         std   D.SysPrc
         std   D.Proc
         adda  #$02
         tfr   d,s
         inca
         std   D.SysStk
         std   D.SysMem
         inca
         std   D.ModDir
         std   D.ModEnd
         adda  #$06
         std   D.ModDir+2
         std   D.ModDAT
         std   D.CCMem
         ldd   #HIRAM
         std   D.CCStk
         leax  >L0271,pcr
         tfr   x,d
         ldx   #D.SWI3
COLD30   std   ,x++
         cmpx  #D.NMI
         bls   COLD30
         leax  >ROMEnd,pcr
         pshs  x
         leay  >SYSVEC,pcr
         ldx   #D.Clock
COLD45    ldd   ,y++
 addd 0,S add offset
 std ,X++ init dp vector
 cmpx #D.XNMI end of dp vectors?
 bls COLD45 branch if not
 leas 2,S return scratch
         ldx   D.XSWI2
         stx   D.UsrSvc
         ldx   D.XIRQ
         stx   D.UsrIRQ
         leax  >SYSREQ,pcr
         stx   D.SysSvc
         stx   D.XSWI2
         leax  >SYSIRQ,pcr
         stx   D.SysIRQ
         stx   D.XIRQ
         leax  >SVCIRQ,pcr
         stx   D.SvcIRQ
 leax IOPOLL,PCR Set irq polling routine
 stx D.POLL
         leax  >L0E44,pcr
         stx   D.AltIRQ
         leax  >L0E69,pcr
         stx   D.Flip0
         leax  >L0E7D,pcr
         stx   D.Flip1
         leay  >SVCTBL,pcr
         lbsr  SETSVC
         ldu   D.PrcDBT
         ldx   D.SysPrc
         stx   ,u
         stx   1,u
         lda   #$01
         sta   ,x
         lda   #$80
         sta   $0C,x
         lda   #$00   SysTask
         sta   D.SysTsk
         sta   $06,x
         lda   #$FF
         sta   $0A,x
         sta   $0B,x
         leax  P$DATImg,x
         stx   D.SysDat
         clra
         clrb
         std   ,x++
         ldy   #$0006
         ldd   #DAT.Free
L00EF    std   ,x++
         leay  -1,y
         bne   L00EF
         ldd   #ROMBlock
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         inc   1,x
         ldx   D.SysMem
         ldb   D.CCStk
L0104    inc   ,x+
         decb
         bne   L0104
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
L0128    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$3F
         bne   L0136
         ldb   #$01
         bra   L015B
L0136    lda   D.MemSz
         bne   L013E
         cmpb  #$0F
         bcc   COLD15
L013E    stb   >$FFA1   DAT.Regs+1
         ldu   ,y
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD15 If not, end of ram
         ldx   #$FF00
         stx   ,y
         cmpx  ,y
         bne   COLD15
         stu   ,y
         bra   L015D
COLD15    ldb   #$80
L015B    stb   [,s]
L015D    puls  x
         leax  1,x
         cmpx  D.BlkMap+2
         bcs   L0128
         ldx   D.BlkMap
         inc   ,x
         ldx   D.BlkMap+2
         leax  >-1,x
         tfr   x,d
         subd  D.BlkMap
         leas  -16,s
         leay  ,s
         lbsr  L01F1
         pshs  x
         ldx   #$0D00
L017F    pshs  y,x
         lbsr  L0AF0
         ldb   1,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   L01A7
         lbsr  VALMOD
         bcc   L019D
         cmpb  #$E7
         bne   L01A7
L019D    ldd   #$0002
         lbsr  LDDX
         leax  d,x
         bra   L01A9
L01A7    leax  1,x
L01A9    cmpx  #$1E00
         bcs   L017F
         bsr   L01D2
L01B0    leax CNFSTR,PCR Get initial module name ptr
         bsr   L01EB
         bcc   L01BF
L01B8    os9   F$Boot
         bcc   L01B0
         bra   L01CE
L01BF    stu   D.Init
L01C1    leax OS9STR,PCR
         bsr   L01EB
         bcc   L01D0
         os9   F$Boot
         bcc   L01C1
L01CE    jmp   D.Crash

L01D0    jmp 0,Y Let os9 part two finish

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

L01EB    lda #SYSTM Get system type module
         os9   F$Link
         rts

L01F1    pshs  y,x,b,a
         ldb   #$08   DAT.BlCt
         ldx   ,s
L01F7    stx   ,y++
         leax  1,x
         decb
         bne   L01F7
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

L0271    fcb   $6E,$98,$F0

SWI3HN ldx D.Proc
         ldu   P$SWI3,x
         beq   L028E

L027B    lbra  L0E5E

SWI2HN   ldx   D.Proc
         ldu   P$SWI2,x
         beq   L028E
         bra   L027B

SWIHN    ldx   D.Proc
         ldu   P$SWI,x
         bne   L027B

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
         ldx   $0A,u
         lbsr  L0C40
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
         lbra  L0D7C

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
         ldx   $0A,u
         ldb   ,s
         beq   L032F
         lbsr  L0C40
         leax  1,x
         bra   L0331
L032F    ldb   ,x+
L0331    stx R$PC,U Update program counter
 ldy D.SysDis Get system service routine table
 bsr DISPCH Call service routine
         lbra  L0E2B

DISPCH    lslb
         bcc   DISP10
         rorb
         ldx   >$00FE,y
         bra   DISP20
DISP10    clra
         ldx   d,y
         bne   DISP20
         comb
         ldb   #E$UnkSvc
         bra   DISP25
DISP20    pshs  u
         jsr   ,x
         puls  u
DISP25    tfr   cc,a
         bcc   DISP30
         stb   R$B,u
DISP30 ldb R$CC,U Get condition codes
 andb #$D0 Clear h, n, z, v, c
 stb R$CC,U Save it
 anda #$2F Clear e, f, i
 ora R$CC,U Return conditions
 sta R$CC,U
 rts

SSVC     ldy   R$Y,u
         bra   SETSVC
L036D    clra
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
         bne   L036D
         rts

SLINK    ldy   R$Y,u
         bra   L0398

ELINK    pshs  u
         ldb   R$B,u
         ldx   R$X,u
         bra   LINK10

LINK     ldx   D.Proc
         leay  P$DATImg,x
L0398    pshs  u
         ldx   R$X,u
         lda   R$A,u
         lbsr  FMOD05
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
         lbsr  L0A33
         bcc   L03E8
         leas  $05,s
         bra   LINKXit
L03E8    lbsr  L0A8C
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
         lbsr  L0AB0
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #M$EXEC Get execution offset
         lbsr  LDDX
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
         ldy   1,u
         bsr   VALMOD
         ldx   ,s
         stu   R$U,x
         puls  pc,u

VALMOD    pshs  y,x
         lbsr  IDCHK
         bcs   BADVAL
         ldd   #$0006
         lbsr  LDDX
         andb  #$0F
         pshs  b,a
         ldd   #$0004
         lbsr  LDDX
         leax  d,x
         puls  a
         lbsr  FMOD05
         puls  a
         bcs   L0497
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   L0497
         ldb   #E$KwnMod
         bra   BADVAL
VMOD10    ldb   #E$DirFul
BADVAL    orcc  #$01
         puls  pc,y,x
L0497    ldx   ,s
         lbsr  L0524
         bcs   VMOD10
         sty   ,u
         stx   R$X,u
         clra
         clrb
         std   R$Y,u
         ldd   #$0002
         lbsr  LDDX
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
         lbsr  LDDX
         cmpd  #M$ID12
         beq   L0597
         ldb   #E$BMID
         bra   L05F3
L0597    leas  -1,s
         leax  $02,x
         lbsr  L0AF0
         ldb   #$07
         lda   #$4A
L05A2    sta   ,s
         lbsr  GETBYTE
         eora  ,s
         decb
         bne   L05A2
         leas  1,s
         inca
         beq   L05B5
         ldb   #E$BMHP
         bra   L05F3
L05B5    puls  y,x
         ldd   #$0002
         lbsr  LDDX
         pshs  y,x,b,a
         ldd   #$FFFF
         pshs  b,a
         pshs  b
         lbsr  L0AF0
         leau  ,s
L05CB    tstb
         bne   L05D8
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
L05D8    lbsr  GETBYTE
         bsr   CRCCAL
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   L05CB
         puls  y,x,b
         cmpb  #$80
         bne   L05F1
         cmpx  #$0FE3
         beq   L05F5
L05F1    ldb   #E$BMCRC
L05F3    orcc  #$01
L05F5    puls  pc,y,x



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
         lbsr  L0B2C
         ldx   D.Proc
         leay  <P$DATImg,x
         ldx   $0B,s
         lbsr  L0AF0
CRCGen10    lbsr  GETBYTE
         lbsr  CRCCAL
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   CRCGen10
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  L0B2C
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
 bsr SKIPSP Skip leading spaces
 cmpa #'/ Is there leading '/'
 beq FMOD35
 lbsr PRSNAM Parse name
 bcs FMOD40 Branch if bad name
 ldu D.ModEnd Get module directory ptr
 bra FMOD33 Test if end is reached
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
L0714    lbsr  L0AF0
         lbsr  L0AC8
         leax  1,x
         cmpa  #$20
         beq   L0714
         leax  -1,x
         pshs  a
         tfr   y,d
         subd  1,s
         asrb
         lbsr  L0AB0
         puls  pc,y,a

PNAM     ldx   D.Proc
         leay  <P$DATImg,x
         ldx   R$X,u
         bsr   PRSNAM
         std   R$D,u
         bcs   PNam.x
         stx   R$X,u
         abx
PNam.x    stx   R$Y,u
         rts

PRSNAM    pshs  y
         lbsr  L0AF0
         pshs  y,x
         lbsr  GETBYTE
         cmpa  #$2F
         bne   PRSNA1
         leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA1    bsr   L07A1
         bcs   PRSNA4
         clrb
PRSNA2    incb
         tsta
         bmi   PRSNA3
         lbsr  GETBYTE
         bsr   L078A
         bcc   PRSNA2
PRSNA3    andcc #$FE
         bra   L077C
PRSNA4    cmpa  #$2C
         bne   PRSNA6
PRSNA5    leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
PRSNA6    cmpa  #$20
         beq   PRSNA5
         comb
         ldb   #E$BNam
L077C    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  L0AB0
         puls  pc,y,b,a,cc
L078A    pshs  a
         anda  #$7F
         cmpa  #$2E
         beq   RETCC
         cmpa  #$30
         bcs   RETCS
         cmpa  #$39
         bls   RETCC
         cmpa  #$5F
         bne   ALPHA
RETCC    clra
         puls  pc,a
L07A1    pshs  a
         anda  #$7F
ALPHA    cmpa  #$41
         bcs   RETCS
         cmpa  #$5A
         bls   RETCC
         cmpa  #$61
         bcs   RETCS
         cmpa  #$7A
         bls   RETCC
RETCS    coma
         puls  pc,a

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
         bsr   CHKNAM
         leas  $08,s
         rts

CHKNAM    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  L0AF0
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  L0AF0
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
L082F    ldx   D.SysDat
         lslb
         ldd   b,x
         cmpd  #DAT.Free
         beq   L0847
         ldx   D.BlkMap
         lda   d,x
         cmpa  #$01
         bne   L0848
         leay  <$20,y
         bra   L084F
L0847    clra
L0848    ldb   #$20
L084A    sta   ,y+
         decb
         bne   L084A
L084F    inc   ,s
         ldb   ,s
         cmpb  #DAT.BlCt
         bcs   L082F
L0857    ldb   1,u
L0859    cmpy  D.SysMem
         bhi   L0863
         comb
         ldb   #E$NoRAM
         bra   L0894
L0863    lda   ,-y
         bne   L0857
         decb
         bne   L0859
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
         lbsr  L09BE
         bcs   L0894
         ldb   1,u
L088A    inc   ,y+
         decb
         bne   L088A
         lda   1,s
         std   $08,u
         clrb
L0894    leas  $02,s
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
L08AD    ldb   ,x
         andb  #$FE
         stb   ,x+
         deca
         bne   L08AD
         ldx   D.SysDat
         ldy   #$0008
L08BC    ldd   ,x
         cmpd  #DAT.Free
         beq   L08EC
         ldu   D.BlkMap
         lda   d,u
         cmpa  #$01
         bne   L08EC
         tfr   x,d
         subd  D.SysDat
         lslb
         lslb
         lslb
         lslb
         ldu   D.SysMem
         leau  d,u
         ldb   #$20
L08DA    lda   ,u+
         bne   L08EC
         decb
         bne   L08DA
         ldd   ,x
         ldu   D.BlkMap
         clr   d,u
         ldd   #DAT.Free
         std   ,x
L08EC    leax  $02,x
         leay  -1,y
         bne   L08BC
SRTMXX    clrb
         rts

BOOT     comb
         lda   D.Boot
         bne   L0966
         inc   D.Boot
         ldx   D.Init
         beq   L0908
         ldd   <$14,x
         beq   L0908
         leax  d,x
         bra   L090C
L0908    leax  >BTSTR,pcr
L090C    lda   #$C1
         os9   F$Link
         bcs   L0966
         jsr   ,y
         bcs   L0966
         std   D.BtSz
         stx   D.BtPtr
         leau  d,x
         tfr   x,d
         anda  #$E0
         clrb
         pshs  u,b,a
         lsra
         lsra
         lsra
         lsra
         ldy   D.SysDat
         leay  a,y
L092D    ldd   ,x
         cmpd  #$87CD
         bne   L0954
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         os9   F$VModul
         pshs  b
         ldd   1,s
         leax  d,x
         puls  b
         bcc   L094E
         cmpb  #$E7
         bne   L0954
L094E    ldd   $02,x
         leax  d,x
         bra   L0956
L0954    leax  1,x
L0956    cmpx  $02,s
         bcs   L092D
         leas  $04,s
         ldx   D.SysDat
         ldb   $0D,x
         incb
         ldx   D.BlkMap
         lbra  L01DF
L0966    rts

ALLRAM   ldb   R$B,u
         bsr   L0970
         bcs   L096F
         std   R$D,u
L096F    rts

L0970    pshs  y,x,b,a
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

ALLIMG   ldd   R$D,u
         ldx   R$X,u
L09BE    pshs  u,y,x,b,a
         lsla
         leay  <P$DATImg,x
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
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a

FREEHB   ldb   R$B,u
         ldy   R$Y,u
         bsr   L0A31
         bcs   L0A30
         sta   R$A,u return beginning block number
L0A30    rts

L0A31    tfr   b,a
L0A33    suba  #$09  DAT.BlCt+1
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   L0A58

FREELB   ldb   R$B,u
         ldy   R$Y,u
         bsr   L0A4B
         bcs   L0A4A
         sta   1,u
L0A4A    rts
L0A4B    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$09  DAT.BlCt+1
         negb
         pshs  b,a
         bra   L0A58
L0A58    clra
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
         bne   L0A58
         inca
         cmpa  $03,s
         bne   L0A71
L0A82    leas  $02,s
         puls  pc,x,b,a

SETIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
         ldu   R$U,u New image pointer
L0A8C    pshs  u,y,x,b,a
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

DATLOG   ldb   R$B,u  DAT image offset
         ldx   R$X,u Block offset
         bsr   L0AB0
         stx   R$X,u
         clrb
         rts
L0AB0    pshs  x,b,a
         lslb
         lslb
         lslb
         lslb
         lslb
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

LDAXY    ldx   R$X,u
         ldy   R$Y,u
         bsr   L0AC8
         sta   1,u
         clrb
         rts
L0AC8    pshs  cc
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
         bra   L0AF0
L0AEA    leax  >-DAT.BlSz,x
         leay  $02,y
L0AF0    cmpx  #DAT.BlSz
         bcc   L0AEA
         rts

LDDDXY   ldd   R$D,u
         leau  R$X,u
         pulu  y,x
         bsr   LDDX
         std   -$07,u
         clrb
         rts

* Get word at D offset into X
LDDX    pshs  y,x
         leax  d,x
         bsr   L0AF0
         bsr   GETBYTE
         pshs  a
         bsr   L0AC8
         tfr   a,b
         puls  pc,y,x,a

LDABX    ldb   R$B,u
         ldx   R$X,u
         lbsr  L0C12
         sta   1,u
         rts

STABX    ldd   R$D,u
         ldx   R$X,u
         lbra  L0C28

MOVE     ldd   R$D,u
         ldx   R$X,u
         ldy   R$Y,u
         ldu   R$U,u
L0B2C    pshs  u,y,x,b,a
         leay  ,y
         lbeq  L0BF2
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
         stb   >$FFA6
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
L0BF2    clrb
         puls  pc,u,y,x,b,a
L0BF5    pshs  b
         tfr   x,d
         anda  #$E0
         beq   L0C07
         exg   d,x
         anda  #$1F
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
L0C12    andcc #$FE
         pshs  u,x,b,cc
         bsr   L0BF5
         bsr   L0C09
         ldd   a,u
         orcc  #IntMasks
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,u,x,b,cc
L0C28    andcc #$FE
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

L0C40    andcc #$FE
         pshs  u,x,a,cc
         bsr   L0BF5
         bsr   L0C09
         ldd   a,u
         orcc  #IntMasks
         stb   DAT.Regs
         ldb   ,x
         clr   DAT.Regs
         puls  pc,u,x,a,cc

ALLTSK   ldx   R$X,u
L0C58    ldb   $06,x
         bne   L0C64
         bsr   L0CA6
         bcs   L0C65
         stb   $06,x
         bsr   SETTSK10
L0C64    clrb
L0C65    rts

DELTSK   ldx   R$X,u
L0C68    ldb   $06,x
         beq   L0C65
         clr   $06,x
         bra   RELTSK10

* Did task image change?
UPDTSK lda P$State,x
 bita #ImgChg
 bne SETTSK10
 rts

SETTSK   ldx   R$X,u
SETTSK10    lda   P$State,x
         anda  #$EF
         sta   $0C,x
         andcc #$FE
         pshs  u,y,x,b,a,cc
         ldb   $06,x
         leax  <P$DATImg,x
         ldu   D.TskIPt
         lslb
         stx   b,u
         cmpb  #$02
         bgt   L0C9F
         ldu   #DAT.Regs
         leax  1,x
         ldb   #$08
L0C98    lda   ,x++
         sta   ,u+
         decb
         bne   L0C98
L0C9F    puls  pc,u,y,x,b,a,cc

RESTSK   bsr   L0CA6
         stb   R$B,u
         rts

* Find free task
L0CA6    pshs  x
         ldb   #$02
         ldx   D.Tasks
L0CAC    lda   b,x
         beq   L0CBA
         incb
         cmpb  #DAT.TkCt
         bne   L0CAC
         comb
         ldb   #E$NoTask
         bra   L0CBF
L0CBA    inc   b,x
         orb   D.SysTsk
         clra
L0CBF    puls  pc,x

RELTSK   ldb   R$B,u
RELTSK10    pshs  x,b
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
APROC ldx R$X,u
ACTPRC clrb
 pshs u,y,x,b,cc
 lda P$Prior,X Get process priority/age
 sta P$AGE,X Set age to priority
 orcc #IRQMask+FIRQMask Set interrupt masks
 ldu #D.AProcQ-P$Queue Fake process ptr
         bra   L0D29
L0D1F    inc   $0B,u
         bne   L0D25
         dec   $0B,u
L0D25    cmpa  $0B,u
         bhi   L0D2B
L0D29    leay  ,u
L0D2B    ldu   $0D,u
         bne   L0D1F
         ldd   P$Queue,y
         stx   P$Queue,y
         std   P$Queue,x
         puls  pc,u,y,x,b,cc

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
         bcc   L0D5B
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0C12
         ora   #$50
         lbsr  L0C28
L0D5B    orcc  #IntMasks
         ldx   D.Proc
         lda   $0C,x
         bita  #$20
         bne   L0D7C
         ldu   #$0045
         ldb   #$08
L0D6A    ldu   $0D,u
         beq   L0D78
         bitb  $0C,u
         bne   L0D6A
         ldb   $0A,x
         cmpb  $0A,u
         bcs   L0D7C
L0D78    ldu   $04,x
         bra   L0DB9
L0D7C    anda  #$DF
         sta   $0C,x
         lbsr  L0C68
L0D83    lbsr  ACTPRC

NPROC    ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #^IntMasks
         bra   NXTP06

NXTP04    cwai  #$AF
NXTP06    orcc  #IntMasks
         lda   #$08
         ldx   #$0045
L0D9A    leay  ,x
         ldx   $0D,y
         beq   NXTP04
         bita  $0C,x
         bne   L0D9A
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  L0C58
         bcs   L0D83
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   $0C,x
         bmi   L0E29
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
         lbra  L0E4C

NXTOUT    lda   P$State,x Get process status
         ora #SysState Set system state
         sta   P$State,x Update status
         leas  >$0200,x         P$Stack
         andcc #^IntMasks
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
         jsr   [D.SvcIRQ] Go to interrupt service
         puls  a
         bsr   L0E39
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti

L0E29    clr   ,-s
L0E2B    ldx   D.SysPrc
         lbsr  UPDTSK
         orcc  #IntMasks
         puls  a
         bsr   L0E39
         leas  ,u
         rti

L0E39    sta   D.SSTskN
         beq   L0E44
         ora   D.TINIT
         sta   D.TINIT
         sta   DAT.Task
L0E44    rts

SVCIRQ   jmp   [D.Poll]

IOPOLL   orcc  #$01
         rts

L0E4C    ldb   $06,x
         orcc  #IntMasks
         bsr   L0E8D
         lda   D.TINIT
         ora   #$01
         sta   D.TINIT
         sta   DAT.Task
         leas  ,u
         rti

L0E5E    ldb   D.TINIT
         orb   #$01
         stb   D.TINIT
         stb   DAT.Task
         jmp   ,u
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
         ldx   #$FFA8
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
