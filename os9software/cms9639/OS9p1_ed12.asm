 nam OS-9 Level II kernal, part 1
 ttl System Type definitions



     use defsfile

*****
*
*  Module Header
*
Revs set REENT+8
 mod OS9End,OS9Nam,SYSTM,Revs,0,0

LORAM set $20
HIRAM set $2000

OS9Nam fcs /OS9p1/
 fcb 12 Edition number

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
 clra
 clrb
 std ,x++
         incb
 std ,x++
 ldy #$000D
 ldd #DAT.Free
L00D6    std   ,x++
         leay  -$01,y
         bne   L00D6
         ldd   #$00FF  ROMBlock
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         ldx   D.SysMem
         ldb   D.ModDir+2
L00E9    inc   ,x+
         decb
         bne   L00E9
         ldy   #HIRAM
         ldx   D.BlkMap
L00F4    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$FF
         beq   COLD15
         stb   >$F002
         ldu   ,y
 ldx #$00FF Get bit pattern
 stx 0,Y Store it
 cmpx 0,Y Is it there?
 bne COLD15 If not, end of ram
 ldx #$FF00 Try a different pattern
 stx 0,Y Store it
 cmpx 0,Y Did it take?
 bne COLD15 If not, eor
         stu   ,y
         bra   L011D
COLD15    ldb   #$80
         stb   [,s]
L011D    puls  x
         leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L00F4
         ldx   D.BlkMap
         inc   ,x
         inc   $01,x
         ldx   D.BlkMap+2
         leax  >-$0010,x
L0131    lda   ,x
         beq   L018B
         tfr   x,d
         subd  D.BlkMap
         cmpd  #$00FF
         beq   L018B
         leas  <-$20,s
         leay  ,s
         lbsr  L01D7
         pshs  x
         ldx   #$0000
L014C    pshs  y,x
         lbsr  DATBLEND
         ldb   $01,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   L0174
         lbsr  VALMOD
         bcc   L016A
         cmpb  #E$KwnMod Is it known module
         bne   L0174
L016A    ldd   #M$Size Get module size
         lbsr  LDDX
         leax  d,x
         bra   L0176
L0174    leax  $01,x
L0176    tfr   x,d
         tstb
         bne   L014C
         bita  #$0F
         bne   L014C
         lsra
         lsra
         lsra
         lsra
         deca
         puls  x
         leax  a,x
         leas  <$20,s
L018B    leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L0131
L0191    leax  >CNFSTR,pcr
         bsr   L01B5
         bcc   L01A0
         os9   F$Boot
         bcc   L0191
         bra   L01AF
L01A0    stu   D.Init
L01A2    leax  >OS9STR,pcr
         bsr   L01B5
         bcc   L01B3
         os9   F$Boot
         bcc   L01A2
L01AF    jmp   [>$FFFE]

L01B3    jmp   0,y Let os9 part two finish

L01B5    clrb
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

L01D7    pshs  y,x,b,a
         ldb   #$10
         ldx   ,s
L01DD    stx   ,y++
         leax  $01,x
         decb
         bne   L01DD
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
         ldu   <$17,x
         beq   L0271

L025E    lbra  CHGTASK


SWI2HN         ldx   D.Proc
         ldu   P$SWI2,x
         beq   L0271
         bra   L025E

SWIHN    ldx   D.Proc
         ldu   P$SWI,x
         bne   L025E

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
         bsr   L02A6
         ldb   >$FFA0
         andcc #$AF
         ldy   D.UsrDis
         lbsr  DISPCH
         ldb   R$CC,u
         andb  #$AF
         stb   R$CC,u
         ldx   D.Proc
         bsr   L02B1
         lda   P$State,x
         anda  #$7F
         lbra  L0C0C

L02A6    lda   $06,x
         anda  #$7F
         clrb
         pshs  u,x,cc
         ldx   P$SP,x
         bra   L02BC

L02B1    ldb   $06,x
         andb  #$7F
         clra
         pshs  u,x,cc
         ldx   P$SP,x
         exg   x,u
L02BC    orcc  #$50
         sta   >$FFB8
         stx   >$FFC0
         stu   >$FFC4
         ldx   #$000C
         stx   >$FFC2
         stx   >$FFC6
         stb   >$FFB9
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
SYSREQ    leau  ,s
         ldb   >$FFA0
         lda   ,u
         tfr   a,cc
         ldy   D.SysDis
         bsr   DISPCH
         lbra  L0CAE

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

SSVC         ldy   $06,u
         bra   SETSVC

L031E    clra
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
         bne   L031E
         rts

SLINK         ldy   $06,u
         bra   L0349

ELINK         pshs  u
         ldb   $02,u
         ldx   $04,u
         bra   LINK10

LINK         ldx   D.Proc
         leay  P$DATImg,x
L0349    pshs  u
         ldx   $04,u
         lda   $01,u
         lbsr  FMOD05
         lbcs  LINKXit
         leay  ,u
         ldu   ,s
         stx   $04,u
         std   $01,u
         leax  ,y
LINK10    bitb  #$80
         bne   LINK20
         ldd   $06,x
         beq   LINK20
         ldb   #$D1
         bra   LINKXit
LINK20    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
         addd  #$0FFF
         tfr   a,b
         lsrb
         lsrb
         lsrb
         lsrb
         pshs  b
         leau  ,y
         bsr   L03CB
         bcc   L0394
         lbsr  L0996
         bcc   L0391
         leas  $05,s
         ldb   #E$MemFul
         bra   LINKXit
L0391    lbsr  L09EA
L0394    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  $01,x
         beq   L03A5
         stx   ,u
L03A5    ldu   $03,s
         ldx   $06,u
         leax  $01,x
         beq   L03AF
         stx   $06,u
L03AF    puls  u,y,x,b
         lbsr  L0A0E
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #M$EXEC Get execution offset
         lbsr  LDDX
         addd  $08,u
         std   $06,u
         clrb
         rts

LINKXit    orcc  #$01
         puls  pc,u

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

VMOD         pshs  u
         ldx   $04,u
         ldy   $01,u
         bsr   VALMOD
         ldx   ,s
         stu   $08,x
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
         bcs   L0440
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   L0440
         ldb   #$E7
         bra   BADVAL
VMOD10    ldb   #$CE
BADVAL    orcc  #$01
         puls  pc,y,x
L0440    ldx   ,s
         lbsr  L04CC
         bcs   VMOD10
         sty   ,u
         stx   $04,u
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
         addd  #$0FFF
         lsra
         lsra
         lsra
         lsra
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
         lbsr  LDDX
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

IDCHK    pshs  y,x
         clra
         clrb
         lbsr  LDDX
         cmpd  #$87CD
         beq   PARITY
         ldb   #$CD
         bra   CRCC20
PARITY    leas  -$01,s
         leax  $02,x
         lbsr  DATBLEND
         ldb   #$07
         lda   #$4A
PARI10    sta   ,s
         lbsr  GETBYTE
         eora  ,s
         decb
         bne   PARI10
         leas  $01,s
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
         lbsr  DATBLEND
         leau  ,s
CRCC05    tstb
         bne   L057F
         pshs  x
         ldx   #$0001
         os9   F$Sleep
         puls  x
L057F    lbsr  GETBYTE
         bsr   CRCCAL
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   CRCC05
         puls  y,x,b
         cmpb  #$80
         bne   L0598
         cmpx  #$0FE3
         beq   L059C
L0598    ldb   #$E8
CRCC20    orcc  #$01
L059C    puls  pc,y,x

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
 lbsr MOVE10
 ldx D.Proc
 leay P$DATImg,x
 ldx 11,s
 lbsr DATBLEND
CRCGen10 lbsr GETBYTE get next data byte
 lbsr CRCCAL update crc
 ldd 9,s
 subd #1 count byte
 std 9,s
 bne CRCGen10 branch if more
 puls y,x,d
 exg a,b
 exg x,u
 lbsr MOVE10
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
 bsr FMOD05
 puls y
 std R$D,y
 stx R$X,y
 stu R$U,y
 rts

FMOD05    ldu   #$0000
         pshs  u,b,a
         bsr   SKIPSP
         cmpa  #$2F
         beq   L06B3
         lbsr  PRSNAM
         bcs   FMOD40
         ldu   D.ModDir
         bra   FMOD33
FMOD10    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   L069D
         ldx   $04,u
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
         beq   L0694
         anda  #$F0
         beq   L0688
         eora  ,s
         anda  #$F0
         bne   FMOD30
L0688    lda   $06,s
         anda  #$0F
         beq   L0694
         eora  ,s
         anda  #$0F
         bne   FMOD30
L0694    puls  y,x,b,a
         abx
         clrb
         ldb   $01,s
         leas  $04,s
         rts
L069D    leas  $04,s
         ldd   $08,s
         bne   FMOD30
         stu   $08,s
FMOD30    puls  y,x,b,a
         leau  $08,u
FMOD33    cmpu  D.ModEnd
         bcs   FMOD10
         comb
         ldb   #$DD
         bra   FMOD40
L06B3    comb
         ldb   #$EB
FMOD40    stb   $01,s
         puls  pc,u,b,a

SKIPSP    pshs  y
L06BC    lbsr  DATBLEND
         lbsr  L0A25
         leax  $01,x
         cmpa  #$20
         beq   L06BC
         leax  -$01,x
         pshs  a
         tfr   y,d
         subd  $01,s
         asrb
         lbsr  L0A0E
         puls  pc,y,a

PNAM         ldx   D.Proc
         leay  P$DATImg,x
         ldx   $04,u
         bsr   PRSNAM
         std   $01,u
         bcs   PNam.x
         stx   $04,u
         abx
PNam.x    stx   $06,u
         rts

PRSNAM    pshs  y
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
L0703    incb
         tsta
         bmi   L070E
         lbsr  GETBYTE
         bsr   ALFNUM
         bcc   L0703
L070E    andcc #$FE
         bra   L0724
PRSNA4    cmpa  #$2C
         bne   L071D
L0716    leas  $04,s
         pshs  y,x
         lbsr  GETBYTE
L071D    cmpa  #$20
         beq   L0716
         comb
         ldb   #$EB
L0724    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  L0A0E
         puls  pc,y,b,a,cc

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

CMPNAM         ldx   D.Proc
         leay  P$DATImg,x
         ldx   $04,u
         pshs  y,x
         bra   L0777

SCMPNAM         ldx   D.Proc
         leay  P$DATImg,x
         ldx   $04,u
         pshs  y,x
         ldy   D.SysDAT
L0777    ldx   $06,u
         pshs  y,x
         ldd   $01,u
         leax  $04,s
         leay  ,s
         bsr   CHKNAM
         leas  $08,s
         rts

CHKNAM    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  DATBLEND
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  DATBLEND
         bra   L079E
CHKN10    ldu   $04,s
         pulu  y,x
L079E    lbsr  GETBYTE
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  GETBYTE
         pshu  y,x
         eora  ,s
         tst   ,s+
         bmi   L07BE
         decb
         beq   RETCS1
         anda  #$DF
         beq   CHKN10
RETCS1    comb
         puls  pc,u,y,x,b,a
L07BE    decb
         bne   RETCS1
         anda  #$5F
         bne   RETCS1
         clrb
         puls  pc,u,y,x,b,a

SRQMEM         ldd   $01,u
         addd  #$00FF
         clrb
         std   $01,u
         ldy   D.SysMem
         leas  -$02,s
         stb   ,s
L07D7    ldx   D.SysDAT
         lslb
         ldd   b,x
         cmpd  #$8000
         beq   L07EF
         ldx   D.BlkMap
         lda   d,x
         cmpa  #$01
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
L07FF    ldb   $01,u
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
         lda   $01,s
         lsra
         lsra
         lsra
         lsra
         ldb   1,s
         andb  #(DAT.BlSz/256)-1
         addb  1,u
         addb  #(DAT.BlSz/256)-1
         lsrb
         lsrb
         lsrb
         lsrb
         ldx   D.SysPrc
         lbsr  ALLIMG10
         bcs   L083A
         ldb   $01,u
L0830    inc   ,y+
         decb
         bne   L0830
         lda   $01,s
         std   $08,u
         clrb
L083A    leas  $02,s
         rts

SRTMEM         ldd   $01,u
         beq   SRTMXX
         addd  #$00FF
         ldb   $09,u
         beq   SRTM10
         comb
         ldb   #$D2
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
         cmpd  #$8000
         beq   L0891
         ldu   D.BlkMap
         lda   d,u
         cmpa  #$01
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
         ldd   #$8000
         std   ,x
L0891    leax  $02,x
         leay  -$01,y
         bne   L0862
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
 leau d,x
         tfr   x,d
         anda  #$F0
         clrb
         pshs  u,b,a
         lsra
         lsra
         lsra
         ldy   D.SysDAT
         leay  a,y
BOOT10 ldd 0,X get module beginning
 cmpd #M$ID12 is it module sync code?
 bne BOOT20 branch if not
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         os9   F$VModul
         pshs  b
         ldd   $01,s
         leax  d,x
         puls  b
         bcc   BOOT15
         cmpb  #$E7
         bne   BOOT20
BOOT15 ldd M$SIZE,X Get module size
         leax  d,x
         bra   BOOT30
BOOT20    leax  $01,x
BOOT30    cmpx  $02,s
         bcs   BOOT10
         leas  $04,s
BOOTXX    rts

ALLRAM         ldb   $02,u
         bsr   L08F3
         bcs   L08F2
         std   $01,u
L08F2    rts
L08F3    pshs  y,x,b,a
         ldx   D.BlkMap
L08F7    leay  ,x
         ldb   $01,s
L08FB    cmpx  D.BlkMap+2
         bcc   L0918
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

L0918    comb
         ldb   #$ED
         stb   $01,s
         puls  pc,y,x,b,a

ALLIMG         ldd   $01,u
         ldx   $04,u
ALLIMG10    pshs  u,y,x,b,a
         lsla
         leay  P$DATImg,x
         leay  a,y
         clra
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
L0932    ldd   ,y++
         cmpd  #$8000
         beq   L0947
         lda   d,u
         cmpa  #$01
         puls  b,a
         bne   L095C
         subd  #$0001
         pshs  b,a
L0947    leax  -$01,x
         bne   L0932
         ldx   ,s++
         beq   L0965
L094F    lda   ,u+
         bne   L0957
         leax  -$01,x
         beq   L0965
L0957    cmpu  D.BlkMap+2
         bcs   L094F
L095C    ldb   #$CF
         leas  $06,s
         stb   $01,s
         comb
         puls  pc,u,y,x,b,a
L0965    puls  u,y,x
L0967    ldd   ,y++
         cmpd  #$8000
         bne   L097B
L096F    lda   ,u+
         bne   L096F
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         std   -$02,y
L097B    leax  -$01,x
         bne   L0967
         ldx   $02,s
         lda   P$State,x
         ora   #$10
         sta   P$State,x
         clrb
         puls  pc,u,y,x,b,a

FREEHB         ldb   $02,u
         ldy   $06,u
         bsr   L0996
         bcs   L0995
         sta   $01,u
L0995    rts

L0996    tfr   b,a
         suba  #$11
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   L09BD

FREELB         ldb   $02,u
         ldy   $06,u
         bsr   L09B0
         bcs   L09AF
         sta   $01,u
L09AF    rts
L09B0    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$11
         negb
         pshs  b,a
         bra   L09BD

L09BD    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
         bne   L09D3
         ldb   #$CF
         stb   $03,s
         comb
         bra   L09E0
L09CF    tfr   a,b
         addb  $02,s
L09D3    lslb
         ldx   b,y
         cmpx  #$8000
         bne   L09BD
         inca
         cmpa  $03,s
         bne   L09CF
L09E0    leas  $02,s
         puls  pc,x,b,a

SETIMG   ldd   R$D,u  Get beginning and number of blocks
         ldx   R$X,u Process descriptor pointer
         ldu   R$U,u New image pointer
L09EA    pshs  u,y,x,b,a
         leay  P$DATImg,x
         lsla
         leay  a,y
L09F2    ldx   ,u++
         stx   ,y++
         decb
         bne   L09F2
         ldx   $02,s
         lda   P$State,x
         ora   #ImgChg
         sta   P$State,x
         clrb
         puls  pc,u,y,x,b,a

DATLOG         ldb   $02,u
         ldx   $04,u
         bsr   L0A0E
         stx   $04,u
         clrb
         rts

* Convert offset into real address
* Input: B, X
* Effect: updated X
L0A0E    pshs  x,b,a
         lslb
         lslb
         lslb
         lslb
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

LDAXY         ldx   $04,u
         ldy   $06,u
         bsr   L0A25
         sta   $01,u
         clrb
         rts

* Get byte from other DAT
L0A25    pshs  cc
         lda   $01,y
         orcc  #$50
         sta   >$F000
         lda   ,x
         clr   >$F000
         puls  pc,cc

GETBYTE    lda   $01,y
         pshs  cc
         orcc  #$50
         sta   >$F000
         lda   ,x+
         clr   >$F000
         puls  cc
         bra   DATBLEND
GETBYTE5    leax  >-$1000,x
         leay  $02,y
DATBLEND    cmpx  #$1000
         bcc   GETBYTE5
         rts

LDDDXY         ldd   $01,u
         leau  $04,u
         pulu  y,x
         bsr   LDDX
         std   -$07,u
         clrb
         rts

LDDX    pshs  y,x
         leax  d,x
         bsr   DATBLEND
         bsr   GETBYTE
         pshs  a
         bsr   L0A25
         tfr   a,b
         puls  pc,y,x,a

LDABX         ldb   $02,u
         ldx   $04,u
         lbsr  L0A80
         sta   $01,u
         rts

STABX         ldd   $01,u
         ldx   $04,u
         lbra  L0A8F

L0A80    andcc #$FE
         pshs  u,x,b,a,cc
         leau  $01,s
         andb  #$7F
         clra
         exg   a,b
         exg   x,u
         bra   L0A98
L0A8F    andcc #$FE
         pshs  u,x,b,a,cc
         leau  $01,s
         andb  #$7F
         clra
L0A98    orcc  #$50
         stu   >$FFC0
         stx   >$FFC4
         ldu   #$0001
         stu   >$FFC2
         stu   >$FFC6
         sta   >$FFB8
         stb   >$FFB9
         ldb   #$03
         stb   >$FFBC
         nop
         puls  pc,u,x,b,a,cc

MOVE     ldd   R$D,u Source and destination task number
         ldx   R$X,u Source pointer
         ldy   R$Y,u Byte count
         ldu   R$U,u  Destination pointer
MOVE10    andcc #$FE
         pshs  b,a,cc
         anda  #$7F
         andb  #$7F
         leay  ,y
         beq   L0AE8
         orcc  #$50
         stx   >$FFC0
         stu   >$FFC4
         sty   >$FFC2
         sty   >$FFC6
         sta   >$FFB8
         stb   >$FFB9
         ldb   #$03
         stb   >$FFBC
         nop
L0AE8    puls  pc,b,a,cc

ALLTSK         ldx   $04,u
L0AEC    ldb   $06,x
         bne   L0AF8
         bsr   L0B4B
         bcs   L0AF9
         stb   $06,x
         bsr   SETTSK10
L0AF8    clrb
L0AF9    rts

DELTSK         ldx   $04,u
DELTSK10         ldb   $06,x
         beq   L0AF9
         clr   $06,x
         bra   RELTSK10

* Did task image change?
UPDTSK lda P$State,x
 bita #ImgChg
 bne SETTSK10
 rts

SETTSK        ldx   $04,u
SETTSK10    lda   P$State,x
         anda  #$EF
         sta   P$State,x
         andcc #$FE
         pshs  y,x,b,a,cc
         ldb   $06,x
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
         leax  P$DATImg,x
         orcc  #$50
         ldy   #$F000
         leay  d,y
         ldb   #$10
L0B31    lda   ,x+
         cmpa  #$80
         beq   L0B3B
         lda   ,x+
         bra   L0B3F
L0B3B    lda   #$FF
         leax  $01,x
L0B3F    sta   ,y+
         decb
         bne   L0B31
         puls  pc,y,x,b,a,cc

RESTSK         bsr   L0B4B
         stb   $02,u
         rts

* Find free task
L0B4B    pshs  x
         ldb   #$01
         ldx   D.Tasks
L0B51    lda   b,x
         beq   L0B5F
         incb
         cmpb  #$80
         bne   L0B51
         comb
         ldb   #$EF
         bra   L0B64
L0B5F    inc   b,x
         orb   D.SysTsk
         clra
L0B64    puls  pc,x

RELTSK         ldb   $02,u
RELTSK10    pshs  x,b
         ldb   D.SysTsk
         comb
         andb  ,s
         beq   L0B75
         ldx   D.Tasks
         clr   b,x
L0B75    puls  pc,x,b

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

SLICE    dec   D.Slice
         bne   SLIC10
         inc   D.Slice
         ldx   D.Proc
         beq   SLIC10
         lda   P$State,x
         ora   #$20
         sta   P$State,x
SLIC10    clrb
         rts

APROC         ldx   $04,u
ACTPRC    clrb
         pshs  u,y,x,cc
         lda   $0A,x
         sta   $0B,x
         orcc  #$50
         ldu   #$0045
         bra   L0BCE
L0BC4    inc   $0B,u
         bne   L0BCA
         dec   $0B,u
L0BCA    cmpa  $0B,u
         bhi   L0BD0
L0BCE    leay  ,u
L0BD0    ldu   $0D,u
         bne   L0BC4
 ldd P$Queue,y
 stx P$Queue,y
 std P$Queue,x
         puls  pc,u,y,x,cc

IRQHN         ldx   D.Proc
         sts   $04,x
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         jsr   [D.SvcIRQ]
         bcc   L0C00
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0A80
         ora   #$50
         lbsr  L0A8F
L0C00    orcc  #$50
         ldx   D.Proc
         ldu   $04,x
         lda   P$State,x
         bita  #$20
         beq   L0C48
L0C0C    anda  #$DF
         sta   P$State,x
L0C10    bsr   ACTPRC

NPROC         ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #$AF
         bra   NXTP06

NXTP04    cwai  #$AF
NXTP06    orcc  #$50
         ldy   #D.AProcQ-P$Queue Fake process ptr
         bra   L0C29
L0C27    leay  ,x
L0C29    ldx   $0D,y
         beq   NXTP04
         lda   P$State,x
         bita  #$08
         bne   L0C27
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  L0AEC
         bcs   L0C10
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   P$State,x
         bmi   L0CAE
L0C48    bita  #$02
         bne   NXTOUT
         lbsr  UPDTSK
         ldb   P$Signal,x
         beq   L0C81
         decb
         beq   L0C7E
         leas  -$0C,s
         leau  ,s
         lbsr  L02A6
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
         lbsr  L02B1
         leas  $0C,s
         ldu   $04,x
         clrb
L0C7E    stb   P$Signal,x
L0C81    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  L0CF2

NXTOUT    lda   P$State,x
         ora   #$80
         sta   P$State,x
         leas  >$0200,x
         andcc #$AF
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

L0CAE    ldx   D.SysPrc
         lbsr  UPDTSK
         leas  ,u
         rti

SVCIRQ   jmp   [D.Poll]

IOPOLL    orcc  #$01
         rts

DATINT         clra
         tfr   a,dp
         sta   >$FFBA
         ldy   #$F010
         lda   #$FF
         ldb   #$01
L0CCB    sta   ,-y
         decb
         bne   L0CCB
         ldb   #$0D
         lda   #$FF
L0CD4    sta   ,-y
         decb
         bne   L0CD4
         ldb   #$01
L0CDB    stb   ,-y
         decb
         bpl   L0CDB
         ldb   #$03
         stb   >$FFD4
         ldb   #$00
         stb   >$FFD1
         orb   #$01
         stb   >$FFD0
         lbra  COLD
L0CF2    ldb   $06,x
         orcc  #$50
         stb   >$FFBB
         leas  ,u
         ldb   #$04
         stb   >$FFBC
         rti

CHGTASK    leas  -$0C,s
         sts   $04,x
         leas  >$01F4,x
         ldb   #$80
         stb   ,s
         stu   $0A,s
         tfr   s,u
         lbsr  L02B1
         lds   $04,x
         ldb P$Task,x
         stb   >$FFBB
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

IRQ10    clr   >$FFBC
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
 fdb $FECD

ROMEnd equ *
