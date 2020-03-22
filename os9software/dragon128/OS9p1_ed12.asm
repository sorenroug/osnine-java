 nam OS-9 Level II kernal, part 1
 ttl System Type definitions

********************************
* Extracted from Dragon 128/Dragon Beta computer.
* The CPUType is called DRG128, and CPUSpeed is TwoMHz
********************************

         ifp1
 use defsfile
         endc

tylg     set   Systm
atrv     set   ReEnt+rev
rev      set   $08
         mod   OS9End,name,tylg,atrv,0,0

name     equ   *
         fcs   /OS9p1/
         fcb   12

LORAM set $20
HIRAM set $1000

COLD ldx #LORAM Set ptr
 ldy #HIRAM-LORAM Set byte count
 clra CLEAR D
 clrb
COLD05    std   ,x++
         leay  -$02,y
 bne COLD05
 inca ONE Page for direct page
         std   D.Tasks
         addb  #$10
         std   D.Tasks+2
         clrb
         inca
         std   D.BlkMap
         adda  #$01
         std   D.BlkMap+2
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
         leax  >L023A,pcr
         tfr   x,d
         ldx   #$00F2
L005B    std   ,x++
         cmpx  #$00FC
         bls   L005B
         leax  >ROMEnd,pcr
         pshs  x
         leay  >SYSVEC,pcr
         ldx   #$00E0
L006F    ldd   ,y++
         addd  ,s
         std   ,x++
         cmpx  #$00EC
         bls   L006F
         leas  $02,s
         ldx   D.XSWI2
         stx   D.UsrSvc
         ldx   D.XIRQ
         stx   D.UsrIRQ
         leax  >L02B3,pcr
         stx   D.SysSvc
         stx   D.XSWI2
         leax  >SYSIRQ,pcr
         stx   D.SysIRQ
         stx   D.XIRQ
         leax  >SVCIRQ,pcr
         stx   D.SvcIRQ
         leax  >IOPOLL,pcr
 stx D.POLL
         leay  >SVCTBL,pcr
         lbsr  L030B
         ldu   D.PrcDBT
         ldx   D.SysPrc
         stx   ,u
         stx   $01,u
         lda   #$01
         sta   ,x
         lda   #$80
         sta   $0C,x
         lda   #$80
         sta   D.SysTsk
         sta   $06,x
         lda   #$FF
         sta   $0A,x
         sta   $0B,x
         leax  <P$DATImg,x
         stx   D.SysDAT
         lda   #$D8
         sta   $3C
         clra
         clrb
         std   ,x++
         ldy   #$000D
         ldd   #DAT.Free
L00D7    std   ,x++
         leay  -$01,y
         bne   L00D7
         ldb   #$FE
         std   ,x++
         ldd   #$00FF
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         ldx   D.SysMem
         ldb   D.ModDir+2
L00EE    inc   ,x+
         decb
         bne   L00EE
         ldy   #$1000
         ldx   D.BlkMap
L00F9    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$FF
         beq   L011E
         stb   >$FE01
         ldu   ,y
         ldx   #$00FF
         stx   ,y
         cmpx  ,y
         bne   L011E
         ldx   #$FF00
         stx   ,y
         cmpx  ,y
         bne   L011E
         stu   ,y
         bra   L0122
L011E    ldb   #$80
         stb   [,s]
L0122    puls  x
         leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L00F9
         ldx   D.BlkMap
         inc   ,x
         ldx   D.BlkMap+2
         leax  >-$0010,x
L0134    lda   ,x
         beq   L0187
         tfr   x,d
         subd  D.BlkMap
         leas  <-$20,s
         leay  ,s
         bsr   L01B7
         pshs  x
         ldx   #$0000
L0148    pshs  y,x
         lbsr  L0B0B
         ldb   $01,y
         stb   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  y,x
         cmpa  #$87
         bne   L0170
         lbsr  L03EE
         bcc   L0166
         cmpb  #$E7
         bne   L0170
L0166    ldd   #$0002
         lbsr  L0B1D
         leax  d,x
         bra   L0172
L0170    leax  $01,x
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
L0187    leax  $01,x
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
L01AB    jmp   [>$FFEE]

L01AF    jmp 0,Y Let os9 part two finish

L01B1    lda   #$C0
         os9   F$Link
         rts
L01B7    pshs  y,x,b,a
         ldb   #$10
         ldx   ,s
L01BD    stx   ,y++
         leax  $01,x
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
 fcb F$CmpNam,$05,$73
 fcb F$CmpNam+$80,$05,$7B
 fcb F$CRC
 fdb CRCGen-*-2
 fcb F$SRqMem+$80,$05,$D2
 fcb F$SRtMem+$80,$06,$44
 fcb $AC,$0A,$29
 fcb $AD,$0A,$87
 fcb $AE,$01,$FB
 fcb $32,$01,$0D
 fcb $B4,$01,$28
 fcb $B5,$06,$8E
 fcb $B6,$05,$BA
 fcb $B8,$09,$4B
 fcb $39,$06,$E9
 fcb $BA,$07,$1B
 fcb $BC,$08,$A6
 fcb $BD,$08,$63
 fcb $BE,$08,$46
 fcb $BF,$09,$58
 fcb $C0,$09,$65
 fcb $C1,$09,$73
 fcb $C2,$09,$8B
 fcb $C3,$09,$A8
 fcb $C4,$08,$AE
 fcb $C6,$08,$C1
 fcb $C8,$08,$F7
 fcb $C9,$09,$10
 fcb F$STABX+$80,$09,$17
 fcb F$ELink+$80
 fdb ELINK-*-2
 fcb F$FModul+$80
 fdb FMODUL-*-2
 fcb F$GMap    * $54 request graphics memory
 fdb GFXMAP-*-2
 fcb F$GClr    * $55 return graphics memory
 fdb GFXCLR-*-2
 fcb $80

CNFSTR fcs /Init/ Configuration module name
OS9STR fcs /OS9p2/ Kernal, part 2 name
BTSTR fcs /Boot/

L023A fcb $6E,$98,$F0,$9E,$50,$EE,$88,$17,$27,$13

L0244    lbra  L0E1B

         ldx   D.Proc
         ldu   <$15,x
         beq   L0257
         bra   L0244
         ldx   D.Proc
         ldu   <$13,x
         bne   L0244
L0257    ldd   D.SysSvc
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
         bsr   L0294
         ldb   $06,x
         ldx   $0A,u
         lbsr  L1149
         leax  $01,x
         stx   $0A,u
         ldy   D.UsrDis
         lbsr  L02C7
         ldb   ,u
         andb  #$AF
         stb   ,u
         ldx   D.Proc
         bsr   L029E
         lda   $0C,x
         anda  #$7F
         lbra  L0C5F
L0294    lda   $06,x
         ldb   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   $04,x
         bra   L02A8
L029E    ldb   $06,x
         lda   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   $04,x
         exg   x,u
L02A8    ldy   #$0006
         tfr   b,dp
         orcc  #IntMasks
         lbra  L1171
L02B3    leau  ,s
         lda   ,u
         tfr   a,cc
         ldx   $0A,u
         ldb   ,x+
         stx   $0A,u
         ldy   D.SysDis
         bsr   L02C7
         lbra  L0D04
L02C7    lslb
         bcc   L02D1
         rorb
         ldx   >$00FE,y
         bra   L02DB
L02D1    clra
         ldx   d,y
         bne   L02DB
         comb
         ldb   #$D0
         bra   L02E1
L02DB    pshs  u
         jsr   ,x
         puls  u
L02E1    tfr   cc,a
         bcc   L02E7
         stb   $02,u
L02E7    ldb   ,u
         andb  #$D0
         stb   ,u
         anda  #$2F
         ora   ,u
         sta   ,u
         rts
         ldy   $06,u
         bra   L030B
L02F9    clra
         lslb
         tfr   d,u
         ldd   ,y++
         leax  d,y
         ldd   D.SysDis
         stx   d,u
         bcs   L030B
         ldd   D.UsrDis
         stx   d,u
L030B    ldb   ,y+
         cmpb  #$80
         bne   L02F9
         rts

SLINK    ldy   $06,u
         bra   L0324

ELINK    pshs  u
         ldb   $02,u
         ldx   $04,u
         bra   L033B

LINK     ldx   D.Proc
         leay  <P$DATImg,x
L0324    pshs  u
         ldx   $04,u
         lda   $01,u
         lbsr  L0616
         lbcs  L03A9
         leay  ,u
         ldu   ,s
         stx   $04,u
         std   $01,u
         leax  ,y
L033B    bitb  #$80
         bne   L0347
         ldd   $06,x
         beq   L0347
         ldb   #$D1
         bra   L03A9
L0347    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
         addd  #$0FFF
         tfr   a,b
         lsrb
         lsrb
         lsrb
         lsrb
         inca
         lsra
         lsra
         lsra
         lsra
         pshs  a
         leau  ,y
         bsr   L03AD
         bcc   L0376
         lda   ,s
         lbsr  L0A56
         bcc   L0373
         leas  $05,s
         ldb   #$CF
         bra   L03A9
L0373    lbsr  L0AA8
L0376    leax  >$0080,x
         sta   ,s
         lsla
         leau  a,x
         ldx   ,u
         leax  $01,x
         beq   L0387
         stx   ,u
L0387    ldu   $03,s
         ldx   $06,u
         leax  $01,x
         beq   L0391
         stx   $06,u
L0391    puls  u,y,x,b
         lbsr  L0ACC
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  L0B1D
         addd  $08,u
         std   $06,u
         clrb
         rts
L03A9    orcc  #$01
         puls  pc,u
L03AD    ldx   D.Proc
         leay  <P$DATImg,x
         clra
         pshs  y,x,b,a
         subb  #$10
         negb
         lslb
         leay  b,y
L03BB    ldx   ,s
         pshs  u,y
L03BF    ldd   ,y++
         cmpd  ,u++
         bne   L03D4
         leax  -$01,x
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
         pshs  u
         ldx   $04,u
         ldy   $01,u
         bsr   L03EE
         ldx   ,s
         stu   $08,x
         puls  pc,u
L03EE    pshs  y,x
         lbsr  L050F
         bcs   L041E
         ldd   #$0006
         lbsr  L0B1D
         andb  #$0F
         pshs  b,a
         ldd   #$0004
         lbsr  L0B1D
         leax  d,x
         puls  a
         lbsr  L0616
         puls  a
         bcs   L0422
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   L0422
         ldb   #$E7
         bra   L041E
L041C    ldb   #$CE
L041E    orcc  #$01
         puls  pc,y,x
L0422    ldx   ,s
         lbsr  L04AE
         bcs   L041C
         sty   ,u
         stx   $04,u
         clra
         clrb
         std   $06,u
         ldd   #$0002
         lbsr  L0B1D
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
         addd  #$0FFF
         lsra
         lsra
         lsra
         lsra
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
         lbsr  L0B1D
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
         clr   $01,x
         rts
L050C    orcc  #$01
         rts
L050F    pshs  y,x
         clra
         clrb
         lbsr  L0B1D
         cmpd  #$87CD
         beq   L0520
         ldb   #$CD
         bra   L057C
L0520    leas  -$01,s
         leax  $02,x
         lbsr  L0B0B
         ldb   #$07
         lda   #$4A
L052B    sta   ,s
         lbsr  L0AF3
         eora  ,s
         decb
         bne   L052B
         leas  $01,s
         inca
         beq   L053E
         ldb   #$EC
         bra   L057C
L053E    puls  y,x
         ldd   #$0002
         lbsr  L0B1D
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
L0561    lbsr  L0AF3
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
         bpl   CRCC99
         ldd   #$8021
         eora  ,u
         sta   ,u
         eorb  $02,u
         stb   $02,u
CRCC99    rts



*****
*
*  Subroutine Crcgen
*
* Generate Crc
*
CRCGen    ldd   $06,u
         beq   CRCGen20
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
         lbsr  L0B47
         ldx   D.Proc
         leay  <P$DATImg,x
         ldx   $0B,s
         lbsr  L0B0B
L05E6    lbsr  L0AF3
         lbsr  CRCCAL
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   L05E6
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  L0B47
         leas  $07,s
CRCGen20    clrb
         rts

FMODUL   pshs  u
         lda   $01,u
         ldx   $04,u
         ldy   $06,u
         bsr   L0616
         puls  y
         std   $01,y
         stx   $04,y
         stu   $08,y
         rts
L0616    ldu   #$0000
         pshs  u,b,a
         bsr   L069C
         cmpa  #$2F
         beq   L0695
         lbsr  L06CB
         bcs   L0698
         ldu   D.ModDir
         bra   L068B
L062A    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   L067F
         ldx   $04,u
         pshs  y,x
         ldd   #$0004
         lbsr  L0B1D
         leax  d,x
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  L0768
         leas  $04,s
         puls  y,x
         leas  $04,s
         bcs   L0687
         ldd   #$0006
         lbsr  L0B1D
         sta   ,s
         stb   $07,s
         lda   $06,s
         beq   L0676
         anda  #$F0
         beq   L066A
         eora  ,s
         anda  #$F0
         bne   L0687
L066A    lda   $06,s
         anda  #$0F
         beq   L0676
         eora  ,s
         anda  #$0F
         bne   L0687
L0676    puls  y,x,b,a
         abx
         clrb
         ldb   $01,s
         leas  $04,s
         rts
L067F    leas  $04,s
         ldd   $08,s
         bne   L0687
         stu   $08,s
L0687    puls  y,x,b,a
         leau  $08,u
L068B    cmpu  D.ModEnd
         bcs   L062A
         comb
         ldb   #$DD
         bra   L0698
L0695    comb
         ldb   #$EB
L0698    stb   $01,s
         puls  pc,u,b,a
L069C    pshs  y
L069E    lbsr  L0B0B
         lbsr  L0AE3
         leax  $01,x
         cmpa  #$20
         beq   L069E
         leax  -$01,x
         pshs  a
         tfr   y,d
         subd  $01,s
         asrb
         lbsr  L0ACC
         puls  pc,y,a

PNAM     ldx   D.Proc
         leay  <P$DATImg,x
         ldx   $04,u
         bsr   L06CB
         std   $01,u
         bcs   L06C8
         stx   $04,u
         abx
L06C8    stx   $06,u
         rts
L06CB    pshs  y
         lbsr  L0B0B
         pshs  y,x
         lbsr  L0AF3
         cmpa  #$2F
         bne   L06E0
         leas  $04,s
         pshs  y,x
         lbsr  L0AF3
L06E0    bsr   L072B
         bcs   L06F4
         clrb
L06E5    incb
         tsta
         bmi   L06F0
         lbsr  L0AF3
         bsr   L0714
         bcc   L06E5
L06F0    andcc #$FE
         bra   L0706
L06F4    cmpa  #$2C
         bne   L06FF
L06F8    leas  $04,s
         pshs  y,x
         lbsr  L0AF3
L06FF    cmpa  #$20
         beq   L06F8
         comb
         ldb   #$EB
L0706    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb
         lbsr  L0ACC
         puls  pc,y,b,a,cc

L0714    pshs  a
         anda  #$7F
         cmpa  #$2E
         beq   L0728
         cmpa  #$30
         bcs   L073F
         cmpa  #$39
         bls   L0728
         cmpa  #$5F
         bne   L072F
L0728    clra
         puls  pc,a
L072B    pshs  a
         anda  #$7F
L072F    cmpa  #$41
         bcs   L073F
         cmpa  #$5A
         bls   L0728
         cmpa  #$61
         bcs   L073F
         cmpa  #$7A
         bls   L0728
L073F    coma
         puls  pc,a

         ldx   D.Proc
         leay  <P$DATImg,x
         ldx   $04,u
         pshs  y,x
         bra   L0759
         ldx   D.Proc
         leay  <P$DATImg,x
         ldx   $04,u
         pshs  y,x
         ldy   D.SysDAT
L0759    ldx   $06,u
         pshs  y,x
         ldd   $01,u
         leax  $04,s
         leay  ,s
         bsr   L0768
         leas  $08,s
         rts
L0768    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  L0B0B
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  L0B0B
         bra   L0780
L077C    ldu   $04,s
         pulu  y,x
L0780    lbsr  L0AF3
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  L0AF3
         pshu  y,x
         eora  ,s
         tst   ,s+
         bmi   L07A0
         decb
         beq   L079D
         anda  #$DF
         beq   L077C
L079D    comb
         puls  pc,u,y,x,b,a
L07A0    decb
         bne   L079D
         anda  #$5F
         bne   L079D
         clrb
         puls  pc,u,y,x,b,a
         ldd   $01,u
         addd  #$00FF
         clrb
         std   $01,u
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
         cmpb  #$10
         bcs   L07B9
L07E1    ldb   $01,u
L07E3    cmpy  D.SysMem
         bhi   L07ED
         comb
         ldb   #$CF
         bra   L081C
L07ED    lda   ,-y
         bne   L07E1
         decb
         bne   L07E3
         sty   ,s
         lda   $01,s
         lsra
         lsra
         lsra
         lsra
         ldb   $01,s
         andb  #$0F
         addb  $01,u
         addb  #$0F
         lsrb
         lsrb
         lsrb
         lsrb
         ldx   D.SysPrc
         lbsr  L0918
         bcs   L081C
         ldb   $01,u
L0812    inc   ,y+
         decb
         bne   L0812
         lda   $01,s
         std   $08,u
         clrb
L081C    leas  $02,s
         rts
         ldd   $01,u
         beq   L0879
         addd  #$00FF
         ldb   $09,u
         beq   L082E
         comb
         ldb   #$D2
         rts
L082E    ldb   $08,u
         beq   L0879
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
         leay  -$01,y
         bne   L0844
L0879    clrb
         rts
         comb
         lda   D.Boot
         bne   L08DE
         inc   D.Boot
         ldx   D.Init
         beq   L088F
         ldd   <$14,x
         beq   L088F
         leax  d,x
         bra   L0893
L088F    leax  >BTSTR,pcr
L0893    lda   #$C1
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
         cmpd  #$87CD
         bne   L08D6
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         os9   F$VModul
         pshs  b
         ldd   $01,s
         leax  d,x
         puls  b
         bcc   L08D0
         cmpb  #$E7
         bne   L08D6
L08D0    ldd   $02,x
         leax  d,x
         bra   L08D8
L08D6    leax  $01,x
L08D8    cmpx  $02,s
         bcs   L08AF
         leas  $04,s
L08DE    rts
         ldb   $02,u
         bsr   L08E8
         bcs   L08E7
         std   $01,u
L08E7    rts
L08E8    pshs  y,x,b,a
         ldx   D.BlkMap
L08EC    leay  ,x
         ldb   $01,s
L08F0    cmpx  D.BlkMap+2
         bcc   L090D
         lda   ,x+
         bne   L08EC
         decb
         bne   L08F0
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   $01,s
         stb   $01,s
L0905    inc   ,y+
         deca
         bne   L0905
         clrb
         puls  pc,y,x,b,a
L090D    comb
         ldb   #$ED
         stb   $01,s
         puls  pc,y,x,b,a
         ldd   $01,u
         ldx   $04,u
L0918    pshs  u,y,x,b,a
         lsla
         leay  <P$DATImg,x
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
L093C    leax  -$01,x
         bne   L0927
         ldx   ,s++
         beq   L0973
         leau  <$20,u
L0947    lda   ,u+
         bne   L094F
         leax  -$01,x
         beq   L0973
L094F    cmpu  D.BlkMap+2
         bcs   L0947
         ldu   D.BlkMap
         clrb
         leay  >L09D2,pcr
L095B    lda   b,y
         lda   a,u
         bne   L0965
         leax  -$01,x
         beq   L0973
L0965    incb
         cmpb  #$20
         bcs   L095B
L096A    ldb   #$CF
         leas  $06,s
         stb   $01,s
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
L0991    leax  -$01,x
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
         ldy   $01,s
         std   -$02,y
         puls  y,b
L09C3    leax  -$01,x
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

GFXMAP   ldb   $02,u
         bsr   L09FB
         bcs   L09FA
         stx   $04,u
L09FA    rts
L09FB    pshs  x,b,a
         ldx   D.BlkMap
         leax  <$20,x
L0A02    ldb   $01,s
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
         stb   $01,s
         puls  pc,x,b,a

GFXCLR         ldb   $02,u
         ldx   $04,u
         pshs  x,b,a
         abx
         cmpx  #$0020
         bhi   L0A45
         ldx   D.BlkMap
         ldd   $02,s
         leax  d,x
         ldb   $01,s
         beq   L0A45
L0A3C    lda   ,x
         anda  #$FE
         sta   ,x+
         decb
         bne   L0A3C
L0A45    clrb
         puls  pc,x,b,a
         ldb   $02,u
         ldy   $06,u
         bsr   L0A54
         bcs   L0A53
         sta   $01,u
L0A53    rts
L0A54    tfr   b,a
L0A56    suba  #$11
         nega
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   L0A7B
         ldb   $02,u
         ldy   $06,u
         bsr   L0A6E
         bcs   L0A6D
         sta   $01,u
L0A6D    rts
L0A6E    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$11
         negb
         pshs  b,a
         bra   L0A7B
L0A7B    clra
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
         bne   L0A91
         ldb   #$CF
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
         ldd   $01,u
         ldx   $04,u
         ldu   $08,u
L0AA8    pshs  u,y,x,b,a
         leay  <P$DATImg,x
         lsla
         leay  a,y
L0AB0    ldx   ,u++
         stx   ,y++
         decb
         bne   L0AB0
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb
         puls  pc,u,y,x,b,a
         ldb   $02,u
         ldx   $04,u
         bsr   L0ACC
         stx   $04,u
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
         ldx   $04,u
         ldy   $06,u
         bsr   L0AE3
         sta   $01,u
         clrb
         rts
L0AE3    pshs  cc
         lda   $01,y
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x
         clr   DAT.Regs
         puls  pc,cc
L0AF3    lda   $01,y
         pshs  cc
         orcc  #IntMasks
         sta   DAT.Regs
         lda   ,x+
         clr   DAT.Regs
         puls  cc
         bra   L0B0B
L0B05    leax  >-$1000,x
         leay  $02,y
L0B0B    cmpx  #$1000
         bcc   L0B05
         rts
         ldd   $01,u
         leau  $04,u
         pulu  y,x
         bsr   L0B1D
         std   -$07,u
         clrb
         rts
L0B1D    pshs  y,x
         leax  d,x
         bsr   L0B0B
         bsr   L0AF3
         pshs  a
         bsr   L0AE3
         tfr   a,b
         puls  pc,y,x,a
         ldb   $02,u
         ldx   $04,u
         lbsr  L1125
         sta   $01,u
         rts
         ldd   $01,u
         ldx   $04,u
         lbra  L1137
         ldd   $01,u
         ldx   $04,u
         ldy   $06,u
         ldu   $08,u
L0B47    andcc #$FE
         leay  ,y
         beq   L0B5C
         pshs  u,y,x,dp,b,a,cc
         tfr   y,d
         lsra
         rorb
         tfr   d,y
         ldd   $01,s
         tfr   b,dp
         lbra  L115B
L0B5C    rts
         ldx   $04,u
L0B5F    ldb   $06,x
         bne   L0B6B
         bsr   L0B9E
         bcs   L0B6C
         stb   $06,x
         bsr   L0B80
L0B6B    clrb
L0B6C    rts
         ldx   $04,u
L0B6F    ldb   $06,x
         beq   L0B6C
         clr   $06,x
         bra   L0BBB
L0B77    lda   $0C,x
         bita  #$10
         bne   L0B80
         rts
         ldx   $04,u
L0B80    lda   $0C,x
         anda  #$EF
         sta   $0C,x
         andcc #$FE
         pshs  u,y,x,b,a,cc
         ldb   $06,x
         leax  <P$DATImg,x
         ldy   #$0010
         ldu   #$FE00
         lbra  L118E
         bsr   L0B9E
         stb   $02,u
         rts
L0B9E    pshs  x
         ldb   #$01
         ldx   D.Tasks
L0BA4    lda   b,x
         beq   L0BB2
         incb
         cmpb  #$10
         bne   L0BA4
         comb
         ldb   #$EF
         bra   L0BB7
L0BB2    inc   b,x
         orb   D.SysTsk
         clra
L0BB7    puls  pc,x
         ldb   $02,u
L0BBB    pshs  x,b
         ldb   D.SysTsk
         comb
         andb  ,s
         beq   L0BC8
         ldx   D.Tasks
         clr   b,x
L0BC8    puls  pc,x,b
         ldx   D.SProcQ
         beq   L0BF5
         lda   $0C,x
         bita  #$40
         beq   L0BF5
         ldu   $04,x
         ldd   $04,u
         subd  #$0001
         std   $04,u
         bne   L0BF5
L0BDF    ldu   $0D,x
         bsr   L0C09
         leax  ,u
         beq   L0BF3
         lda   $0C,x
         bita  #$40
         beq   L0BF3
         ldu   $04,x
         ldd   $04,u
         beq   L0BDF
L0BF3    stx   D.SProcQ
L0BF5    dec   D.Slice
         bne   L0C05
         inc   D.Slice
         ldx   D.Proc
         beq   L0C05
         lda   $0C,x
         ora   #$20
         sta   $0C,x
L0C05    clrb
         rts
         ldx   $04,u
L0C09    clrb
         pshs  u,y,x,cc
         lda   $0A,x
         sta   $0B,x
         orcc  #IntMasks
         ldu   #$0045
         bra   L0C21
L0C17    inc   $0B,u
         bne   L0C1D
         dec   $0B,u
L0C1D    cmpa  $0B,u
         bhi   L0C23
L0C21    leay  ,u
L0C23    ldu   $0D,u
         bne   L0C17
         ldd   $0D,y
         stx   $0D,y
         std   $0D,x
         puls  pc,u,y,x,cc
         ldx   D.Proc
         sts   $04,x
         lds   D.SysStk
         ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         jsr   [D.SvcIRQ]
         bcc   L0C53
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,x
         lbsr  L1125
         ora   #$50
         lbsr  L1137
L0C53    orcc  #IntMasks
         ldx   D.Proc
         ldu   $04,x
         lda   $0C,x
         bita  #$20
         beq   L0C9E
L0C5F    anda  #$DF
         sta   $0C,x
         lbsr  L0B6F
L0C66    bsr   L0C09
         ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #^IntMasks
         bra   L0C75

L0C73    cwai  #$AF
L0C75    orcc  #IntMasks
         ldy   #$0045
         bra   L0C7F
L0C7D    leay  ,x
L0C7F    ldx   $0D,y
         beq   L0C73
         lda   $0C,x
         bita  #$08
         bne   L0C7D
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  L0B5F
         bcs   L0C66
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   $0C,x
         bmi   L0D04
L0C9E    bita  #$02
         bne   L0CE2
         lbsr  L0B77
         ldb   <$19,x
         beq   L0CD7
         decb
         beq   L0CD4
         leas  -$0C,s
         leau  ,s
         lbsr  L0294
         lda   <$19,x
         sta   $02,u
         ldd   <$1A,x
         beq   L0CE2
         std   $0A,u
         ldd   <$1C,x
         std   $08,u
         ldd   $04,x
         subd  #$000C
         std   $04,x
         lbsr  L029E
         leas  $0C,s
         ldu   $04,x
         clrb
L0CD4    stb   <$19,x
L0CD7    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  L0E11
L0CE2    lda   $0C,x
         ora   #$80
         sta   $0C,x
         leas  >$0200,x
         andcc #^IntMasks
         ldb   <$19,x
         clr   <$19,x
         os9   F$Exit

SYSIRQ    jsr   [D.SvcIRQ]
 bcc SYSI10 branch if interrupt identified
 ldb R$CC,S get condition codes
 orb #IntMasks set interrupt mask
 stb R$CC,S update condition codes
SYSI10 rti

L0D04    ldx   D.SysPrc
         lbsr  L0B77
         leas  ,u
         rti

SVCIRQ   jmp   [D.Poll]

IOPOLL   orcc  #$01
         rts

         clra
         tfr   a,dp
         ldx   #DAT.Task
         lda   $01,x
         lbne  L0DF2
         ldb   #$04
         stb   $01,x
         lda   #$F0
         sta   ,x
         clra
         sta   $01,x
         lda   #$CF
         sta   ,x
         lda   #$FF
         sta   $02,x
         lda   #$3E
         sta   $01,x
         stb   $03,x
         lda   #$D8
         sta   $02,x
         ldy   #$FE00
         ldb   #$F0
L0D42    stb   ,x
         clra
         sta   ,y
         lda   #$1F
         sta   $06,y
         lda   #$FE
         sta   $0E,y
         lda   #$FF
         sta   $0F,y
         incb
         bne   L0D42
         lda   #$F0
         sta   ,x
         ldx   #$FC24
         lda   #$7F
         ldb   #$04
         stb   $01,x
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
         sta   $01,x
         lda   #$FF
         sta   ,x
         stb   $01,x
         ldx   #$FC22
         lda   #$18
         sta   ,x
         stb   $01,x
         ldx   #$FC80
         clrb
         leay  >L0DBE,pcr
L0D8F    lda   ,y+
         stb   ,x
         sta   $01,x
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
         leay  >L0DCE,pcr
         ldx   #$63C0
L0DB3    lda   ,y+
         beq   L0DBB
         sta   ,x++
         bra   L0DB3
L0DBB    lbra  COLD

L0DBE    fcb $37,$28,$2E,$35,$1E,$02,$19,$1B,$50,$09,$20,$09,$38,$00,$38,$00
L0DCE    fcc " OS-9 is loading - please wait ...."
         fcb 0

L0DF2    lds   #$FFFF
         sync
L0DF7    lds   #$FFFF
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
L0E11    ldb   $06,x
         orcc  #IntMasks
         stb   DAT.Task
         leas  ,u
         rti
L0E1B    ldb   $06,x
         stb   DAT.Task
         jmp   ,u
         emod
OS9End      equ   *

Target set $1225-$100
 use filler

L1125    andcc #$FE
         pshs  b,cc
         orcc  #IntMasks
         stb   DAT.Task
         lda   ,x
         ldb   #$80
         stb   DAT.Task
         puls  pc,b,cc

L1137    andcc #$FE
         pshs  b,cc
         orcc  #IntMasks
         stb   DAT.Task
         sta   ,x
         ldb   #$80
         stb   DAT.Task
         puls  pc,b,cc

L1149    andcc #$FE
         pshs  a,cc
         orcc  #IntMasks
         stb   DAT.Task
         ldb   ,x
         lda   #$80
         sta   DAT.Task
         puls  pc,a,cc

L115B    orcc  #IntMasks
         bcc   L1171
         sta   DAT.Task
         lda   ,x+
         stb   DAT.Task
         sta   ,u+
         leay  $01,y
         bra   L117F
L116D    lda   $01,s
         orcc  #IntMasks
L1171    sta   DAT.Task
         ldd   ,x++
         exg   b,dp
         stb   DAT.Task
         exg   b,dp
         std   ,u++
L117F    lda   #$80
         sta   DAT.Task
         lda   ,s
         tfr   a,cc
         leay  -$01,y
         bne   L116D
         puls  pc,u,y,x,dp,b,a,cc

L118E    orcc  #IntMasks
L1190    lda   $01,x
         leax  $02,x
         stb   DAT.Task
         sta   ,u+
         lda   #$80
         sta   DAT.Task
         leay  -$01,y
         bne   L1190
         puls  pc,u,y,x,b,a,cc

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
IRQH10    lda   #$80
         sta   DAT.Task
IRQH20    clra
         tfr   a,dp
         tfr   d,x
         jmp   [,x]

SWIHN    ldb   #D.SWI
         bra   IRQH10

NMIHN    ldb   #D.NMI
         bra   IRQH20

Target set $1225-$20
 use filler

SYSVEC fdb $F9A5
      fdb $F018
      fdb $F022
      fdb $EDDB
      fdb $FA0A
      fdb $F02B
      fdb $FBD2
      fdb $EDEE

      fdb $EDDB
 fdb SWI3HN+$FFF2-* Swi3 handler
 fdb SWI2HN+$FFF4-* Swi2 handler
 fdb FIRQHN+$FFF6-* Fast irq handler
 fdb IRQHN+$FFF8-* Irq handler
 fdb SWIHN+$FFFA-* Swi handler
 fdb NMIHN+$FFFC-* Nmi handler
      fdb $FAEE
ROMEnd equ *


 end
