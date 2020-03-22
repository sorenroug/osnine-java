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
         addb  #$20
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
         ldx   #$00F2
L0065    std   ,x++
         cmpx  #$00FC
         bls   L0065
         leax  >ROMEnd,pcr
         pshs  x
         leay  >SYSVEC,pcr
         ldx   #D.Clock
L0079    ldd   ,y++
         addd  ,s
         std   ,x++
         cmpx  #$00EC
         bls   L0079
         leas  $02,s
         ldx   D.XSWI2
         stx   D.UsrSvc
         ldx   D.XIRQ
         stx   D.UsrIRQ
         leax  >L0316,pcr
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
         lbsr  L037F
         ldu   D.PrcDBT
         ldx   D.SysPrc
         stx   ,u
         stx   $01,u
         lda   #$01
         sta   ,x
         lda   #$80
         sta   $0C,x
         lda   #$00
         sta   D.SysTsk
         sta   $06,x
         lda   #$FF
         sta   $0A,x
         sta   $0B,x
         leax  <P$DATImg,x
         stx   D.SysDat
         clra
         clrb
         std   ,x++
         ldy   #$0006
         ldd   #DAT.Free
L00EF    std   ,x++
         leay  -1,y
         bne   L00EF
         ldd   #$003F
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         inc   $01,x
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
         bcc   L0159
L013E    stb   >$FFA1
         ldu   ,y
         ldx   #$00FF
         stx   ,y
         cmpx  ,y
         bne   L0159
         ldx   #$FF00
         stx   ,y
         cmpx  ,y
         bne   L0159
         stu   ,y
         bra   L015D
L0159    ldb   #$80
L015B    stb   [,s]
L015D    puls  x
         leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L0128
         ldx   D.BlkMap
         inc   ,x
         ldx   D.BlkMap+2
         leax  >-1,x
         tfr   x,d
         subd  D.BlkMap
         leas  -$10,s
         leay  ,s
         lbsr  L01F1
         pshs  x
         ldx   #$0D00
L017F    pshs  y,x
         lbsr  L0AF0
         ldb   $01,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   L01A7
         lbsr  L0463
         bcc   L019D
         cmpb  #$E7
         bne   L01A7
L019D    ldd   #$0002
         lbsr  L0B02
         leax  d,x
         bra   L01A9
L01A7    leax  $01,x
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
         sta   -$01,x
         rts

L01EB    lda #SYSTM Get system type module
         os9   F$Link
         rts

L01F1    pshs  y,x,b,a
         ldb   #$08
         ldx   ,s
L01F7    stx   ,y++
         leax  $01,x
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
         fcb F$AlHRam+$80
         fdb ALHRAM-*-2
         fcb $80

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name
BTSTR fcs /Boot/

L0271    fcb   $6E,$98,$F0,$9E,$50,$EE,$88,$17,$27,$13

L027B    lbra  L0E5E
         ldx   D.Proc
         ldu   <$15,x
         beq   L028E
         bra   L027B
         ldx   D.Proc
         ldu   <$13,x
         bne   L027B
L028E    ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         lda   $0C,x
         ora   #$80
         sta   $0C,x
         sts   $04,x
         leas  >$01F4,x
         andcc #^IntMasks
         leau  ,s
         bsr   L02CB
         ldb   $06,x
         ldx   $0A,u
         lbsr  L0C40
         leax  $01,x
         stx   $0A,u
         ldy   D.UsrDis
         lbsr  L033B
         ldb   ,u
         andb  #$AF
         stb   ,u
         ldx   D.Proc
         bsr   L02DA
         lda   $0C,x
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
         leau  $01,u
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

* Process software interupts from system state
* Entry: U=Register stack pointer
L0316    leau  ,s
         lda   D.SSTskN
         clr   D.SSTskN
         pshs  a
         lda   ,u
         tfr   a,cc
         ldx   $0A,u
         ldb   ,s
         beq   L032F
         lbsr  L0C40
         leax  $01,x
         bra   L0331
L032F    ldb   ,x+
L0331    stx   $0A,u
         ldy   D.SysDis
         bsr   L033B
         lbra  L0E2B

L033B    lslb
         bcc   L0345
         rorb
         ldx   >$00FE,y
         bra   L034F
L0345    clra
         ldx   d,y
         bne   L034F
         comb
         ldb   #E$UnkSvc
         bra   L0355
L034F    pshs  u
         jsr   ,x
         puls  u
L0355    tfr   cc,a
         bcc   L035B
         stb   R$B,u
L035B    ldb   ,u
         andb  #$D0
         stb   ,u
         anda  #$2F
         ora   ,u
         sta   ,u
         rts

SSVC     ldy   R$Y,u
         bra   L037F
L036D    clra
         lslb
         tfr   d,u
         ldd   ,y++
         leax  d,y
         ldd   D.SysDis
         stx   d,u
         bcs   L037F
         ldd   D.UsrDis
         stx   d,u
L037F    ldb   ,y+
         cmpb  #$80
         bne   L036D
         rts

SLINK    ldy   R$Y,u
         bra   L0398

ELINK    pshs  u
         ldb   R$B,u
         ldx   R$X,u
         bra   L03AF

LINK     ldx   D.Proc
         leay  <P$DATImg,x
L0398    pshs  u
         ldx   R$X,u
         lda   R$A,u
         lbsr  L068D
         lbcs  L041E
         leay  ,u
         ldu   0,s
         stx   R$X,u
         std   R$D,u
         leax  ,y
L03AF    bitb  #$80
         bne   L03BB
         ldd   $06,x
         beq   L03BB
 ldb #E$ModBsy err: module busy
         bra   L041E
L03BB    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
         addd  #$1FFF
         tfr   a,b
         lsrb
         lsrb
         lsrb
         lsrb
         lsrb
         adda  #$02
         lsra
         lsra
         lsra
         lsra
         lsra
         pshs  a
         leau  ,y
         bsr   L0422
         bcc   L03EB
         lda   ,s
         lbsr  L0A33
         bcc   L03E8
         leas  $05,s
         bra   L041E
L03E8    lbsr  L0A8C
L03EB    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  $01,x
         beq   L03FC
         stx   ,u
L03FC    ldu   $03,s
         ldx   R$Y,u
         leax  $01,x
         beq   L0406
         stx   R$Y,u
L0406    puls  u,y,x,b
         lbsr  L0AB0
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  L0B02
         addd  $08,u
         std   R$Y,u
         clrb
         rts
L041E    orcc  #$01
         puls  pc,u
L0422    ldx   D.Proc
         leay  <P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #$08
         negb
         lslb
         leay  b,y
L0430    ldx   ,s
         pshs  u,y
L0434    ldd   ,y++
         cmpd  ,u++
         bne   L0449
         leax  -$01,x
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
         ldy   $01,u
         bsr   L0463
         ldx   ,s
         stu   R$U,x
         puls  pc,u

L0463    pshs  y,x
         lbsr  L0586
         bcs   L0493
         ldd   #$0006
         lbsr  L0B02
         andb  #$0F
         pshs  b,a
         ldd   #$0004
         lbsr  L0B02
         leax  d,x
         puls  a
         lbsr  L068D
         puls  a
         bcs   L0497
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   L0497
         ldb   #E$KwnMod
         bra   L0493
L0491    ldb   #E$DirFul
L0493    orcc  #$01
         puls  pc,y,x
L0497    ldx   ,s
         lbsr  L0524
         bcs   L0491
         sty   ,u
         stx   R$X,u
         clra
         clrb
         std   R$Y,u
         ldd   #$0002
         lbsr  L0B02
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
         addd  #$1FFF
         lsra
         lsra
         lsra
         lsra
         lsra
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
         lbsr  L0B02
         addd  ,s
         addd  #$1FFF
         lsra
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
         clr   $01,x
         rts
L0583    orcc  #$01
         rts
L0586    pshs  y,x
         clra
         clrb
         lbsr  L0B02
         cmpd  #M$ID12
         beq   L0597
         ldb   #E$BMID
         bra   L05F3
L0597    leas  -$01,s
         leax  $02,x
         lbsr  L0AF0
         ldb   #$07
         lda   #$4A
L05A2    sta   ,s
         lbsr  L0AD8
         eora  ,s
         decb
         bne   L05A2
         leas  $01,s
         inca
         beq   L05B5
         ldb   #E$BMHP
         bra   L05F3
L05B5    puls  y,x
         ldd   #$0002
         lbsr  L0B02
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
L05D8    lbsr  L0AD8
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
L065D    lbsr  L0AD8
         lbsr  CRCCAL
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   L065D
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  L0B2C
         leas  $07,s
CRCGen20    clrb
         rts

FMODUL   pshs  u
         lda   R$A,u
         ldx   R$X,u
         ldy   R$Y,u
         bsr   L068D
         puls  y
         std   R$D,y
         stx   R$X,y
         stu   R$U,y
         rts
L068D    ldu   #$0000
         pshs  u,b,a
         bsr   L0712
         cmpa  #$2F
         beq   L070B
         lbsr  L0741
         bcs   L070E
         ldu   D.ModEnd
         bra   L0700
L06A1    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   L06F6
         ldx   R$X,u
         pshs  y,x
         ldd   #$0004
         lbsr  L0B02
         leax  d,x
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  L07DE
         leas  $04,s
         puls  y,x
         leas  $04,s
         bcs   L06FE
         ldd   #$0006
         lbsr  L0B02
         sta   ,s
         stb   $07,s
         lda   $06,s
         beq   L06ED
         anda  #$F0
         beq   L06E1
         eora  ,s
         anda  #$F0
         bne   L06FE
L06E1    lda   $06,s
         anda  #$0F
         beq   L06ED
         eora  ,s
         anda  #$0F
         bne   L06FE
L06ED    puls  y,x,b,a
         abx
         clrb
         ldb   $01,s
         leas  $04,s
         rts
L06F6    leas  $04,s
         ldd   $08,s
         bne   L06FE
         stu   $08,s
L06FE    puls  y,x,b,a
L0700    leau  -$08,u
         cmpu  D.ModDir
         bcc   L06A1
         ldb   #E$MNF
         bra   L070E
L070B    comb
         ldb   #E$BNam
L070E    stb   $01,s
         puls  pc,u,b,a

L0712    pshs  y
L0714    lbsr  L0AF0
         lbsr  L0AC8
         leax  $01,x
         cmpa  #$20
         beq   L0714
         leax  -$01,x
         pshs  a
         tfr   y,d
         subd  $01,s
         asrb
         lbsr  L0AB0
         puls  pc,y,a

PNAM     ldx   D.Proc
         leay  <P$DATImg,x
         ldx   R$X,u
         bsr   L0741
         std   R$D,u
         bcs   L073E
         stx   R$X,u
         abx
L073E    stx   R$Y,u
         rts
L0741    pshs  y
         lbsr  L0AF0
         pshs  y,x
         lbsr  L0AD8
         cmpa  #$2F
         bne   L0756
         leas  $04,s
         pshs  y,x
         lbsr  L0AD8
L0756    bsr   L07A1
         bcs   L076A
         clrb
L075B    incb
         tsta
         bmi   L0766
         lbsr  L0AD8
         bsr   L078A
         bcc   L075B
L0766    andcc #$FE
         bra   L077C
L076A    cmpa  #$2C
         bne   L0775
L076E    leas  $04,s
         pshs  y,x
         lbsr  L0AD8
L0775    cmpa  #$20
         beq   L076E
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
         beq   L079E
         cmpa  #$30
         bcs   L07B5
         cmpa  #$39
         bls   L079E
         cmpa  #$5F
         bne   L07A5
L079E    clra
         puls  pc,a
L07A1    pshs  a
         anda  #$7F
L07A5    cmpa  #$41
         bcs   L07B5
         cmpa  #$5A
         bls   L079E
         cmpa  #$61
         bcs   L07B5
         cmpa  #$7A
         bls   L079E
L07B5    coma
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
         bsr   L07DE
         leas  $08,s
         rts
L07DE    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  L0AF0
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  L0AF0
         bra   L07F6
L07F2    ldu   $04,s
         pulu  y,x
L07F6    lbsr  L0AD8
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  L0AD8
         pshu  y,x
         eora  ,s
         tst   ,s+
         bmi   L0816
         decb
         beq   L0813
         anda  #$DF
         beq   L07F2
L0813    comb
         puls  pc,u,y,x,b,a
L0816    decb
         bne   L0813
         anda  #$5F
         bne   L0813
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
         cmpb  #$08
         bcs   L082F
L0857    ldb   $01,u
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
         lda   $01,s
         lsra
         lsra
         lsra
         lsra
         lsra
         ldb   $01,s
         andb  #$1F
         addb  $01,u
         addb  #$1F
         lsrb
         lsrb
         lsrb
         lsrb
         lsrb
         ldx   D.SysPrc
         lbsr  L09BE
         bcs   L0894
         ldb   $01,u
L088A    inc   ,y+
         decb
         bne   L088A
         lda   $01,s
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
         beq   L08F2
 addd #$FF Round up to page
 ldb R$U+1,u IS Address good?
 beq SRTM10 Branch if so
         comb
         ldb   #E$BPAddr
         rts

SRTM10    ldb   R$U,u
         beq   L08F2
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
         leay  -$01,y
         bne   L08BC
L08F2    clrb
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
         ldd   $01,s
         leax  d,x
         puls  b
         bcc   L094E
         cmpb  #$E7
         bne   L0954
L094E    ldd   $02,x
         leax  d,x
         bra   L0956
L0954    leax  $01,x
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
         ldb   $01,s
L0978    cmpx  D.BlkMap+2
         bcc   L0995
         lda   ,x+
         bne   L0974
         decb
         bne   L0978
L0983    tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   $01,s
         stb   $01,s
L098D    inc   ,y+
         deca
         bne   L098D
         clrb
         puls  pc,y,x,b,a
L0995    comb
         ldb   #E$NoRAM
         stb   1,s
         puls  pc,y,x,b,a

ALHRAM   ldb   R$B,u
         bsr   L09A5
         bcs   L09A4
         std   R$D,u
L09A4    rts

L09A5    pshs  y,x,b,a
         ldx   D.BlkMap+2
L09A9    ldb   $01,s
L09AB    cmpx  D.BlkMap
         bls   L0995
         lda   ,-x
         bne   L09A9
         decb
         bne   L09AB
         tfr   x,y
         bra   L0983

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
L09E2    leax  -$01,x
         bne   L09CD
         ldx   ,s++
         beq   L0A00
L09EA    lda   ,u+
         bne   L09F2
         leax  -$01,x
         beq   L0A00
L09F2    cmpu  D.BlkMap+2
         bcs   L09EA
L09F7    ldb   #E$MemFul
         leas  $06,s
         stb   $01,s
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
L0A16    leax  -$01,x
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
         sta   $01,u
L0A30    rts
L0A31    tfr   b,a
L0A33    suba  #$09
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   L0A58

FREELB   ldb   R$B,u
         ldy   R$Y,u
         bsr   L0A4B
         bcs   L0A4A
         sta   $01,u
L0A4A    rts
L0A4B    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$09
         negb
         pshs  b,a
         bra   L0A58
L0A58    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
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

SETIMG   ldd   R$D,u
         ldx   R$X,u
         ldu   R$U,u
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

DATLOG   ldb   R$B,u
         ldx   R$X,u
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
         sta   $01,u
         clrb
         rts
L0AC8    pshs  cc
         lda   $01,y
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,cc
L0AD8    lda   $01,y
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
         bsr   L0B02
         std   -$07,u
         clrb
         rts
L0B02    pshs  y,x
         leax  d,x
         bsr   L0AF0
         bsr   L0AD8
         pshs  a
         bsr   L0AC8
         tfr   a,b
         puls  pc,y,x,a

LDABX    ldb   R$B,u
         ldx   R$X,u
         lbsr  L0C12
         sta   $01,u
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
         leay  -$01,y
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
         lda   $01,s
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
         bsr   L0C79
L0C64    clrb
L0C65    rts

DELTSK   ldx   R$X,u
L0C68    ldb   $06,x
         beq   L0C65
         clr   $06,x
         bra   L0CC3
L0C70    lda   $0C,x
         bita  #$10
         bne   L0C79
         rts

SETTSK   ldx   R$X,u
L0C79    lda   $0C,x
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
         leax  $01,x
         ldb   #$08
L0C98    lda   ,x++
         sta   ,u+
         decb
         bne   L0C98
L0C9F    puls  pc,u,y,x,b,a,cc

RESTSK   bsr   L0CA6
         stb   R$B,u
         rts
L0CA6    pshs  x
         ldb   #$02
         ldx   D.Tasks
L0CAC    lda   b,x
         beq   L0CBA
         incb
         cmpb  #$20
         bne   L0CAC
         comb
         ldb   #E$NoTask
         bra   L0CBF
L0CBA    inc   b,x
         orb   D.SysTsk
         clra
L0CBF    puls  pc,x

RELTSK   ldb   R$B,u
L0CC3    pshs  x,b
         ldb   D.SysTsk
         comb
         andb  ,s
         beq   L0CD0
         ldx   D.Tasks
         clr   b,x
L0CD0    puls  pc,x,b
         ldx   D.SProcQ
         beq   L0CFD
         lda   $0C,x
         bita  #$40
         beq   L0CFD
         ldu   $04,x
         ldd   $04,u
         subd  #$0001
         std   $04,u
         bne   L0CFD
L0CE7    ldu   $0D,x
         bsr   L0D11
         leax  ,u
         beq   L0CFB
         lda   $0C,x
         bita  #$40
         beq   L0CFB
         ldu   $04,x
         ldd   $04,u
         beq   L0CE7
L0CFB    stx   D.SProcQ
L0CFD    dec   D.Slice
         bne   L0D0D
         inc   D.Slice
         ldx   D.Proc
         beq   L0D0D
         lda   $0C,x
         ora   #$20
         sta   $0C,x
L0D0D    clrb
         rts

APROC    ldx   R$X,u
L0D11    clrb
         pshs  u,y,x,b,cc
         lda   $0A,x
         sta   $0B,x
         orcc  #IntMasks
         ldu   #$0045
         bra   L0D29
L0D1F    inc   $0B,u
         bne   L0D25
         dec   $0B,u
L0D25    cmpa  $0B,u
         bhi   L0D2B
L0D29    leay  ,u
L0D2B    ldu   $0D,u
         bne   L0D1F
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         puls  pc,u,y,x,b,cc
         ldx   D.Proc
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
L0D83    lbsr  L0D11
NPROC    ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #^IntMasks
         bra   L0D93

L0D91    cwai  #$AF
L0D93    orcc  #IntMasks
         lda   #$08
         ldx   #$0045
L0D9A    leay  ,x
         ldx   $0D,y
         beq   L0D91
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
         bne   L0DFD
         lbsr  L0C70
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
         beq   L0DFD
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
L0DFD    lda   $0C,x
         ora   #$80
         sta   $0C,x
         leas  >$0200,x
         andcc #^IntMasks
         ldb   <$19,x
         clr   <$19,x
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
         lbsr  L0C70
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
         leau  $01,u
         ldb   #$08
L0E9B    lda   ,u++
         sta   ,x+
         decb
         bne   L0E9B
         puls  pc,u,x,b,a

SWI3HN    orcc  #IntMasks
         ldb   #D.SWI3
         bra   IRQH10

SWI2HN    orcc  #IntMasks
         ldb   #D.SWI2
         bra   IRQH10

FIRQHN   ldb   #D.FIRQ
         bra   IRQH10

IRQHN    orcc  #IntMasks
         ldb   #D.IRQ

IRQH10   lda   #$00
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

SWIHN    ldb   #D.SWI
         bra   IRQH10

NMIHN    ldb   #D.NMI
         bra   IRQH10

         emod
OS9End      equ   *
 fcc /99999/

SYSVEC fdb $FDD2
 fdb $F374
 fdb $F37E
 fdb $F100
 fdb $FE37
 fdb $F387
 fdb $F100
 fdb $0055
* Long branches
 lbra SWI3HN
 lbra SWI2HN
 lbra FIRQHN
 lbra IRQHN
 lbra SWIHN
 lbra NMIHN
ROMEnd equ *


 end
