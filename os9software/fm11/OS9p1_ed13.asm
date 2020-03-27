         nam   OS9p1
         ttl   os9 system module    


         ifp1
         use   defsfile
         endc

*****
*
*  Module Header
*
Revs set REENT+1

         mod   OS9End,OS9Nam,SYSTM,Revs,0,0

OS9Nam     equ   *
         fcs   /OS9p1/
         fcb   13
         fcc  "FM11L2"

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
         leax  >L0257,pcr
         tfr   x,d
         ldx   #$00F2
L0061    std   ,x++
         cmpx  #$00FC
         bls   L0061
         leax  >ROMEnd,pcr
         pshs  x
         leay  >SYSVEC,pcr
         ldx   #$00E0
L0075    ldd   ,y++
         addd  ,s
         std   ,x++
         cmpx  #$00EC
         bls   L0075
         leas  $02,s
         ldx   D.XSWI2
         stx   D.UsrSvc
         ldx   D.XIRQ
         stx   D.UsrIRQ
         leax  >L02D0,pcr
         stx   D.SysSvc
         stx   D.XSWI2
         leax  >SYSIRQ,pcr
         stx   D.SysIRQ
         stx   D.XIRQ
         leax  >SVCIRQ,pcr
         stx   D.SvcIRQ
         leax  >IOPOLL,pcr
         stx   D.POLL
         leay  >SVCTBL,pcr
         lbsr  L0328
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
         leax  P$DATImg,x
         stx   D.SysDAT
         clra  
         clrb  
         std   ,x++
         ldy   #$000D
         ldd   #$00FE
L00D9    std   ,x++
         leay  -$01,y
         bne   L00D9
         ldd   #$0001
         std   ,x++
         ldb   #$FF
         std   ,x++
         ldx   D.Tasks
         inc   ,x
         ldx   D.SysMem
         ldb   D.ModDir+2
L00F0    inc   ,x+
         decb  
         bne   L00F0
         ldy   #$1000
         ldx   D.BlkMap
L00FB    pshs  x
         ldd   ,s
         subd  D.BlkMap
         cmpb  #$FF
         beq   L0120
         stb   >$FD81
         ldu   ,y
         ldx   #$00FF
         stx   ,y
         cmpx  ,y
         bne   L0120
         ldx   #$FF00
         stx   ,y
         cmpx  ,y
         bne   L0120
         stu   ,y
         bra   L0124
L0120    ldb   #$80
         stb   [,s]
L0124    puls  x
         leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L00FB
         ldx   D.BlkMap
         inc   ,x
         lda   #$80
         sta   $01,x
L0134    lda   ,x
         beq   L01AA
         tfr   x,d
         subd  D.BlkMap
         leas  <-$20,s
         leay  ,s
         lbsr  L01DA
         pshs  x
         ldx   #$0000
         cmpb  #$FF
         bne   L0150
         ldx   #$0800
L0150    pshs  y,x
         lbsr  L0A62
         ldb   $01,y
         stb   >$FD80
         ldd   ,x
         clr   >$FD80
         puls  y,x
         cmpd  #$87CD
         beq   L0180
         puls  x
         bra   L01A7
L016B    pshs  y,x
         lbsr  L0A62
         ldb   $01,y
         stb   >$FD80
         lda   ,x
         clr   >$FD80
         puls  y,x
         cmpa  #$87
         bne   L0193
L0180    lbsr  L040C
         bcc   L0189
         cmpb  #$E7
         bne   L0193
L0189    ldd   #$0002
         lbsr  L0A74
         leax  d,x
         bra   L0195
L0193    leax  $01,x
L0195    tfr   x,d
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
L01AA    leax  $01,x
         cmpx  D.BlkMap+2
         bcs   L0134
L01B0    leax  >CNFSTR,pcr
         bsr   L01D4
         bcc   L01BF
         os9   F$Boot   
         bcc   L01B0
         bra   L01CE
L01BF    stu   D.Init
L01C1    leax  >OS9STR,pcr
         bsr   L01D4
         bcc   L01D2
         os9   F$Boot   
         bcc   L01C1
L01CE    jmp   [>$FFFE]

L01D2    jmp   ,y
L01D4    lda   #$C0
         os9   F$Link   
         rts   

L01DA    pshs  y,x,b,a
         ldb   #$10
         ldx   ,s
L01E0    stx   ,y++
         leax  $01,x
         decb  
         bne   L01E0
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

L0257  fcb $6E,$98,$F0,$9E,$50,$EE,$88,$17,$27,$13

L0261    lbra  L0C92+$1000

         ldx   D.Proc
         ldu   <$15,x
         beq   L0274
         bra   L0261

         ldx   D.Proc
         ldu   <$13,x
         bne   L0261
L0274    ldd   D.SysSvc
         std   D.XSWI2
         ldd   D.SysIRQ
         std   D.XIRQ
         lda   $0C,x
         ora   #$80
         sta   $0C,x
         sts   $04,x
         leas  >$01F4,x
         andcc #$AF
         leau  ,s
         bsr   L02B1
         ldb   $06,x
         ldx   $0A,u
         lbsr  L0CBD+$1000
         leax  $01,x
         stx   $0A,u
         ldy   D.UsrDis
         lbsr  L02E4
         ldb   ,u
         andb  #$AF
         stb   ,u
         ldx   D.Proc
         bsr   L02BB
         lda   $0C,x
         anda  #$7F
         lbra  L0BB6

L02B1    lda   $06,x
         ldb   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   $04,x
         bra   L02C5
L02BB    ldb   $06,x
         lda   D.SysTsk
         pshs  u,y,x,dp,b,a,cc
         ldx   $04,x
         exg   x,u
L02C5    ldy   #$0006
         tfr   b,dp
         orcc  #$50
         lbra  L0CE5+$1000

* System Service
L02D0    leau  ,s
         lda   ,u
         tfr   a,cc
         ldx   $0A,u
         ldb   ,x+
         stx   $0A,u
         ldy   D.SysDis
         bsr   L02E4
         lbra  L0C5B

L02E4    lslb  
         bcc   L02EE
         rorb  
         ldx   >$00FE,y
         bra   L02F8
L02EE    clra  
         ldx   d,y
         bne   L02F8
         comb  
         ldb   #$D0
         bra   L02FE
L02F8    pshs  u
         jsr   ,x
         puls  u
L02FE    tfr   cc,a
         bcc   L0304
         stb   $02,u
L0304    ldb   ,u
         andb  #$D0
         stb   ,u
         anda  #$2F
         ora   ,u
         sta   ,u
         rts   

SSVC     ldy   $06,u
         bra   L0328
L0316    clra  
         lslb  
         tfr   d,u
         ldd   ,y++
         leax  d,y
         ldd   D.SysDis
         stx   d,u
         bcs   L0328
         ldd   D.UsrDis
         stx   d,u
L0328    ldb   ,y+
         cmpb  #$80
         bne   L0316
         rts   

SLINK    ldy   R$Y,u
         bra   L0341

ELINK    pshs  u
         ldb   $02,u
         ldx   $04,u
         bra   L0358
LINK     ldx   D.Proc
         leay  P$DATImg,x
L0341    pshs  u
         ldx   $04,u
         lda   $01,u
         lbsr  L0634
         lbcs  L03C7
         leay  ,u
         ldu   ,s
         stx   $04,u
         std   $01,u
         leax  ,y
L0358    bitb  #$80
         bne   L0364
         ldd   $06,x
         beq   L0364
 ldb #E$ModBsy err: module busy
         bra   L03C7
L0364    ldd   $04,x
         pshs  x,b,a
         ldy   ,x
         ldd   $02,x
         addd  #$0FFF
         tfr   a,b
         lsrb  
         lsrb  
         lsrb  
         lsrb  
         adda  #$04
         lsra  
         lsra  
         lsra  
         lsra  
         pshs  a
         leau  ,y
         bsr   L03CB
         bcc   L0394
         lda   ,s
         lbsr  L09AB
         bcc   L0391
         leas  $05,s
         ldb   #$CF
         bra   L03C7
L0391    lbsr  L09FD
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
         lbsr  L0A21
         stx   $08,u
         ldx   $04,y
         ldy   ,y
         ldd   #$0009
         lbsr  L0A74
         addd  $08,u
         std   $06,u
         clrb  
         rts   
L03C7    orcc  #$01
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

*****
*
*  Subroutine Valmod
*
* Validate Module
*
VMOD pshs U Save register ptr
         ldx   $04,u
         ldy   $01,u
         bsr   L040C
         ldx   ,s
         stu   $08,x
         puls  pc,u
L040C    pshs  y,x
         lbsr  IDCHK
         bcs   L043C
         ldd   #$0006
         lbsr  L0A74
         andb  #$0F
         pshs  b,a
         ldd   #$0004
         lbsr  L0A74
         leax  d,x
         puls  a
         lbsr  L0634
         puls  a
         bcs   L0440
         pshs  a
         andb  #$0F
         subb  ,s+
         bcs   L0440
         ldb   #$E7
         bra   L043C
L043A    ldb   #$CE
L043C    orcc  #$01
         puls  pc,y,x
L0440    ldx   ,s
         lbsr  L04CC
         bcs   L043A
         sty   ,u
         stx   $04,u
         clra  
         clrb  
         std   $06,u
         ldd   #$0002
         lbsr  L0A74
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
         lbsr  L0A74
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
         lbsr  L0A74
         cmpd  #$87CD
         beq   L053E
         ldb   #$CD
         bra   L059A
L053E    leas  -$01,s
         leax  $02,x
         lbsr  L0A62
         ldb   #$07
         lda   #$4A
L0549    sta   ,s
         lbsr  L0A4A
         eora  ,s
         decb  
         bne   L0549
         leas  $01,s
         inca  
         beq   L055C
         ldb   #$EC
         bra   L059A
L055C    puls  y,x
         ldd   #$0002
         lbsr  L0A74
         pshs  y,x,b,a
         ldd   #$FFFF
         pshs  b,a
         pshs  b
         lbsr  L0A62
         leau  ,s
L0572    tstb  
         bne   L057F
         pshs  x
         ldx   #$0001
         os9   F$Sleep  
         puls  x
L057F    lbsr  L0A4A
         bsr   CRCCAL
         ldd   $03,s
         subd  #$0001
         std   $03,s
         bne   L0572
         puls  y,x,b
         cmpb  #$80
         bne   L0598
         cmpx  #$0FE3
         beq   L059C
L0598    ldb   #$E8
L059A    orcc  #$01
L059C    puls  pc,y,x


*****
*
*  Subroutine Crccal
*
* Calculate Next Crc Value
*
CRCCAL eora 0,U Add crc msb
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
         bpl   L05DC
         ldd   #$8021
         eora  ,u
         sta   ,u
         eorb  $02,u
         stb   $02,u
L05DC    rts   



*****
*
*  Subroutine Crcgen
*
* Generate Crc
*
CRCGen ldd R$Y,u get byte count
         beq   L061E
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
         lbsr  L0A9E
         ldx   D.Proc
         leay  P$DATImg,x
         ldx   $0B,s
         lbsr  L0A62
L0604    lbsr  L0A4A
         lbsr  CRCCAL
         ldd   $09,s
         subd  #$0001
         std   $09,s
         bne   L0604
         puls  y,x,b,a
         exg   a,b
         exg   x,u
         lbsr  L0A9E
         leas  $07,s
L061E    clrb  
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

FMODUL   pshs  u
         lda   $01,u
         ldx   $04,u
         ldy   $06,u
         bsr   L0634
         puls  y
         std   $01,y
         stx   $04,y
         stu   $08,y
         rts   
L0634    ldu   #$0000
         pshs  u,b,a
         bsr   L06BA
         cmpa  #$2F
         beq   L06B3
         lbsr  PRSNAM
         bcs   FMOD40
         ldu   D.ModDir
         bra   L06A9
L0648    pshs  y,x,b,a
         pshs  y,x
         ldy   ,u
         beq   L069D
         ldx   $04,u
         pshs  y,x
         ldd   #$0004
         lbsr  L0A74
         leax  d,x
         pshs  y,x
         leax  $08,s
         ldb   $0D,s
         leay  ,s
         lbsr  L0786
         leas  $04,s
         puls  y,x
         leas  $04,s
         bcs   L06A5
         ldd   #$0006
         lbsr  L0A74
         sta   ,s
         stb   $07,s
         lda   $06,s
         beq   FMOD16
         anda  #$F0
         beq   L0688
         eora  ,s
         anda  #$F0
         bne   L06A5
L0688    lda   $06,s
         anda  #$0F
         beq   FMOD16
         eora  ,s
         anda  #$0F
         bne   L06A5
FMOD16    puls  y,x,b,a
         abx   
         clrb  
         ldb   $01,s
         leas  $04,s
         rts   
L069D    leas  $04,s
         ldd   $08,s
         bne   L06A5
         stu   $08,s
L06A5    puls  y,x,b,a
         leau  $08,u
L06A9    cmpu  D.ModEnd
         bcs   L0648
         comb  
         ldb   #$DD
         bra   FMOD40
L06B3    comb  
         ldb   #$EB
FMOD40    stb   $01,s
         puls  pc,u,b,a

L06BA    pshs  y
L06BC    lbsr  L0A62
         lbsr  L0A3A
         leax  $01,x
         cmpa  #$20
         beq   L06BC
         leax  -$01,x
         pshs  a
         tfr   y,d
         subd  $01,s
         asrb  
         lbsr  L0A21
         puls  pc,y,a

PNAM     ldx   D.Proc
         leay  P$DATImg,x
         ldx   $04,u
         bsr   PRSNAM
         std   $01,u
         bcs   L06E6
         stx   $04,u
         abx   
L06E6    stx   $06,u
         rts   

PRSNAM    pshs  y
         lbsr  L0A62
         pshs  y,x
         lbsr  L0A4A
         cmpa  #$2F
         bne   L06FE
         leas  $04,s
         pshs  y,x
         lbsr  L0A4A
L06FE    bsr   L0749
         bcs   L0712
         clrb  
L0703    incb  
         tsta  
         bmi   L070E
         lbsr  L0A4A
         bsr   L0732
         bcc   L0703
L070E    andcc #$FE
         bra   L0724
L0712    cmpa  #$2C
         bne   L071D
L0716    leas  $04,s
         pshs  y,x
         lbsr  L0A4A
L071D    cmpa  #$20
         beq   L0716
         comb  
         ldb   #$EB
L0724    puls  y,x
         pshs  b,a,cc
         tfr   y,d
         subd  $03,s
         asrb  
         lbsr  L0A21
         puls  pc,y,b,a,cc

L0732    pshs  a
         anda  #$7F
         cmpa  #$2E
         beq   L0746
         cmpa  #$30
         bcs   L075D
         cmpa  #$39
         bls   L0746
         cmpa  #$5F
         bne   L074D
L0746    clra  
         puls  pc,a
L0749    pshs  a
         anda  #$7F
L074D    cmpa  #$41
         bcs   L075D
         cmpa  #$5A
         bls   L0746
         cmpa  #$61
         bcs   L075D
         cmpa  #$7A
         bls   L0746
L075D    coma  
         puls  pc,a

CMPNAM   ldx   D.Proc
         leay  P$DATImg,x
         ldx   $04,u
         pshs  y,x
         bra   L0777

SCMPNAM  ldx   D.Proc
         leay  P$DATImg,x
         ldx   $04,u
         pshs  y,x
         ldy   D.SysDAT
L0777    ldx   $06,u
         pshs  y,x
         ldd   $01,u
         leax  $04,s
         leay  ,s
         bsr   L0786
         leas  $08,s
         rts   
L0786    pshs  u,y,x,b,a
         ldu   $02,s
         pulu  y,x
         lbsr  L0A62
         pshu  y,x
         ldu   $04,s
         pulu  y,x
         lbsr  L0A62
         bra   L079E
L079A    ldu   $04,s
         pulu  y,x
L079E    lbsr  L0A4A
         pshu  y,x
         pshs  a
         ldu   $03,s
         pulu  y,x
         lbsr  L0A4A
         pshu  y,x
         eora  ,s
         tst   ,s+
         bmi   L07BE
         decb  
         beq   L07BB
         anda  #$DF
         beq   L079A
L07BB    comb  
         puls  pc,u,y,x,b,a
L07BE    decb  
         bne   L07BB
         anda  #$5F
         bne   L07BB
         clrb  
         puls  pc,u,y,x,b,a

*****
*
*  Subroutine Srqmem
*
* System Memory Request
*
SRQMEM ldd R$D,U Get byte count
         addd  #$00FF
         clrb  
         std   $01,u
         ldy   D.SysMem
         leas  -$02,s
         stb   ,s
L07D7    ldx   D.SysDAT
         lslb  
         ldd   b,x
         cmpd  #$00FE
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
         ldb   $01,s
         andb  #$0F
         addb  $01,u
         addb  #$0F
         lsrb  
         lsrb  
         lsrb  
         lsrb  
         ldx   D.SysPrc
         lbsr  L0936
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

 page
*****
*
*  Subroutine Srtmem
*
* System Memory Return
*
SRTMEM ldd R$D,U Get byte count
         beq   SRTMXX
         addd  #$00FF
         ldb   $09,u
         beq   L084C
         comb  
         ldb   #$D2
         rts   
L084C    ldb   $08,u
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
         cmpd  #$00FE
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
         ldd   #$00FE
         std   ,x
L0891    leax  $02,x
         leay  -$01,y
         bne   L0862
SRTMXX    clrb  
         rts   

BOOT     comb
         lda   D.Boot
         bne   L08FC
         inc   D.Boot
         ldx   D.Init
         beq   L08AD
         ldd   <$14,x
         beq   L08AD
         leax  d,x
         bra   L08B1
L08AD    leax  >BTSTR,pcr
L08B1    lda   #$C1
         os9   F$Link   
         bcs   L08FC
         jsr   ,y
         bcs   L08FC
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
L08CD    ldd   ,x
         cmpd  #$87CD
         bne   L08F4
         tfr   x,d
         subd  ,s
         tfr   d,x
         tfr   y,d
         os9   F$VModul 
         pshs  b
         ldd   $01,s
         leax  d,x
         puls  b
         bcc   L08EE
         cmpb  #$E7
         bne   L08F4
L08EE    ldd   $02,x
         leax  d,x
         bra   L08F6
L08F4    leax  $01,x
L08F6    cmpx  $02,s
         bcs   L08CD
         leas  $04,s
L08FC    rts   

ALLRAM   ldb   R$B,u
         bsr   L0906
         bcs   L0905
         std   $01,u
L0905    rts   

L0906    pshs  y,x,b,a
         ldx   D.BlkMap
L090A    leay  ,x
         ldb   $01,s
L090E    cmpx  D.BlkMap+2
         bcc   L092B
         lda   ,x+
         bne   L090A
         decb  
         bne   L090E
         tfr   y,d
         subd  D.BlkMap
         sta   ,s
         lda   $01,s
         stb   $01,s
L0923    inc   ,y+
         deca  
         bne   L0923
         clrb  
         puls  pc,y,x,b,a

L092B    comb  
         ldb   #$ED
         stb   $01,s
         puls  pc,y,x,b,a

ALLIMG   ldd   R$D,u
         ldx   $04,u
L0936    pshs  u,y,x,b,a
         lsla  
         leay  P$DATImg,x
         leay  a,y
         clra  
         tfr   d,x
         ldu   D.BlkMap
         pshs  u,y,x,b,a
L0945    ldd   ,y++
         cmpd  #$00FE
         beq   L095A
         lda   d,u
         cmpa  #$01
         puls  b,a
         bne   L096F
         subd  #$0001
         pshs  b,a
L095A    leax  -$01,x
         bne   L0945
         ldx   ,s++
         beq   L0978
L0962    lda   ,u+
         bne   L096A
         leax  -$01,x
         beq   L0978
L096A    cmpu  D.BlkMap+2
         bcs   L0962
L096F    ldb   #$CF
         leas  $06,s
         stb   $01,s
         comb  
         puls  pc,u,y,x,b,a
L0978    puls  u,y,x
L097A    ldd   ,y++
         cmpd  #$00FE
         bne   L098E
L0982    lda   ,u+
         bne   L0982
         inc   ,-u
         tfr   u,d
         subd  D.BlkMap
         std   -$02,y
L098E    leax  -$01,x
         bne   L097A
         ldx   $02,s
         lda   $0C,x
         ora   #$10
         sta   $0C,x
         clrb  
         puls  pc,u,y,x,b,a

FREEHB   ldb   R$B,u
         ldy   $06,u
         bsr   L09A9
         bcs   L09A8
         sta   $01,u
L09A8    rts   

L09A9    tfr   b,a
L09AB    suba  #$11
         nega  
         pshs  x,b,a
         ldd   #$FFFF
         pshs  b,a
         bra   L09D0

FREELB   ldb   R$B,u
         ldy   $06,u
         bsr   L09C3
         bcs   L09C2
         sta   $01,u
L09C2    rts   
L09C3    lda   #$FF
         pshs  x,b,a
         lda   #$01
         subb  #$11
         negb  
         pshs  b,a
         bra   L09D0
L09D0    clra  
         ldb   $02,s
         addb  ,s
         stb   $02,s
         cmpb  $01,s
         bne   L09E6
         ldb   #$CF
         stb   $03,s
         comb  
         bra   L09F3
L09E2    tfr   a,b
         addb  $02,s
L09E6    lslb  
         ldx   b,y
         cmpx  #$00FE
         bne   L09D0
         inca  
         cmpa  $03,s
         bne   L09E2
L09F3    leas  $02,s
         puls  pc,x,b,a

SETIMG   ldd   R$D,u
         ldx   $04,u
         ldu   $08,u
L09FD    pshs  u,y,x,b,a
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

DATLOG   ldb   R$B,u
         ldx   $04,u
         bsr   L0A21
         stx   $04,u
         clrb  
         rts   
L0A21    pshs  x,b,a
         lslb  
         lslb  
         lslb  
         lslb  
         addb  $02,s
         stb   $02,s
         puls  pc,x,b,a

LDAXY    ldx   R$X,u
         ldy   $06,u
         bsr   L0A62
         bsr   L0A3A
         sta   $01,u
         clrb  
         rts   
L0A3A    pshs  cc
         lda   $01,y
         orcc  #$50
         sta   >$FD80
         lda   ,x
         clr   >$FD80
         puls  pc,cc
L0A4A    lda   $01,y
         pshs  cc
         orcc  #$50
         sta   >$FD80
         lda   ,x+
         clr   >$FD80
         puls  cc
         bra   L0A62
L0A5C    leax  >-$1000,x
         leay  $02,y
L0A62    cmpx  #$1000
         bcc   L0A5C
         rts   

LDDDXY   ldd   R$D,u
         leau  $04,u
         pulu  y,x
         bsr   L0A74
         std   -$07,u
         clrb  
         rts   
L0A74    pshs  y,x
         leax  d,x
         bsr   L0A62
         bsr   L0A4A
         pshs  a
         bsr   L0A3A
         tfr   a,b
         puls  pc,y,x,a

LDABX    ldb   R$B,u
         ldx   $04,u
         lbsr  L0C99+$1000
         sta   $01,u
         rts   

STABX    ldd   R$D,u
         ldx   $04,u
         lbra  L0CAB+$1000

MOVE     ldd   R$D,u
         ldx   $04,u
         ldy   $06,u
         ldu   $08,u
L0A9E    andcc #$FE
         leay  ,y
         beq   L0AB3
         pshs  u,y,x,dp,b,a,cc
         tfr   y,d
         lsra  
         rorb  
         tfr   d,y
         ldd   $01,s
         tfr   b,dp
         lbra  L0CCF+$1000
L0AB3    rts   

ALLTSK   ldx   R$X,u
L0AB6    ldb   $06,x
         bne   L0AC2
         bsr   L0AF5
         bcs   L0AC3
         stb   $06,x
         bsr   L0AD7
L0AC2    clrb  
L0AC3    rts  
 
DELTSK   ldx   R$X,u
L0AC6    ldb   $06,x
         beq   L0AC3
         clr   $06,x
         bra   L0B12
L0ACE    lda   $0C,x
         bita  #$10
         bne   L0AD7
         rts   

SETTSK   ldx   R$X,u
L0AD7    lda   $0C,x
         anda  #$EF
         sta   $0C,x
         andcc #$FE
         pshs  u,y,x,b,a,cc
         ldb   $06,x
         leax  P$DATImg,x
         ldy   #$0010
         ldu   #$FD80
         lbra  L0D02+$1000

RESTSK   bsr   L0AF5
         stb   $02,u
         rts   

L0AF5    pshs  x
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
L0B12    pshs  x,b
         ldb   D.SysTsk
         comb  
         andb  ,s
         beq   L0B1F
         ldx   D.Tasks
         clr   b,x
L0B1F    puls  pc,x,b
         ldx   D.SProcQ
         beq   L0B4C
         lda   $0C,x
         bita  #$40
         beq   L0B4C
         ldu   $04,x
         ldd   $04,u
         subd  #$0001
         std   $04,u
         bne   L0B4C
L0B36    ldu   $0D,x
         bsr   L0B60
         leax  ,u
         beq   L0B4A
         lda   $0C,x
         bita  #$40
         beq   L0B4A
         ldu   $04,x
         ldd   $04,u
         beq   L0B36
L0B4A    stx   D.SProcQ
L0B4C    dec   D.Slice
         bne   L0B5C
         inc   D.Slice
         ldx   D.Proc
         beq   L0B5C
         lda   $0C,x
         ora   #$20
         sta   $0C,x
L0B5C    clrb  
         rts   

 page
*****
*
*  Subroutine Actprc
*
* Put Process In Active Process Queue
*
APROC ldx R$X,U
L0B60    clrb  
         pshs  u,y,x,cc
         lda   $0A,x
         sta   $0B,x
         orcc  #$50
         ldu   #$0045
         bra   L0B78
L0B6E    inc   $0B,u
         bne   L0B74
         dec   $0B,u
L0B74    cmpa  $0B,u
         bhi   L0B7A
L0B78    leay  ,u
L0B7A    ldu   $0D,u
         bne   L0B6E
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
         jsr   [>$00CE]
         bcc   L0BAA
         ldx   D.Proc
         ldb   $06,x
         ldx   $04,x
         lbsr  L0C99+$1000
         ora   #$50
         lbsr  L0CAB+$1000
L0BAA    orcc  #$50
         ldx   D.Proc
         ldu   $04,x
         lda   $0C,x
         bita  #$20
         beq   L0BF5
L0BB6    anda  #$DF
         sta   $0C,x
         lbsr  L0AC6
L0BBD    bsr   L0B60

NPROC    ldx   D.SysPrc
         stx   D.Proc
         lds   D.SysStk
         andcc #$AF
         bra   L0BCC
L0BCA    cwai  #$AF
L0BCC    orcc  #$50
         ldy   #$0045
         bra   L0BD6
L0BD4    leay  ,x
L0BD6    ldx   $0D,y
         beq   L0BCA
         lda   $0C,x
         bita  #$08
         bne   L0BD4
         ldd   $0D,x
         std   $0D,y
         stx   D.Proc
         lbsr  L0AB6
         bcs   L0BBD
         lda   D.TSlice
         sta   D.Slice
         ldu   $04,x
         lda   $0C,x
         bmi   L0C5B
L0BF5    bita  #$02
         bne   NXTOUT
         lbsr  L0ACE
         ldb   <$19,x
         beq   L0C2E
         decb  
         beq   L0C2B
         leas  -$0C,s
         leau  ,s
         lbsr  L02B1
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
         lbsr  L02BB
         leas  $0C,s
         ldu   $04,x
         clrb  
L0C2B    stb   <$19,x
L0C2E    ldd   D.UsrSvc
         std   D.XSWI2
         ldd   D.UsrIRQ
         std   D.XIRQ
         lbra  L0C88+$1000

NXTOUT    lda   $0C,x
         ora   #$80
         sta   $0C,x
         leas  >$0200,x
         andcc #$AF
         ldb   <$19,x
         clr   <$19,x
         os9   F$Exit   

*****
*
*  Interrupt Routine Sysirq
*
* Handles Irq While In System State
*
SYSIRQ    jsr   [>$00CE]
         bcc   L0C5A
         ldb   ,s
         orb   #$50
         stb   ,s
L0C5A    rti   
L0C5B    ldx   D.SysPrc
         lbsr  L0ACE
         leas  ,u
         rti   

SVCIRQ    jmp   [>$0026]

IOPOLL    orcc  #$01
         rts  
 
         jmp   [>$00F8]
         rts   
         rts   

         clra  
         tfr   a,dp
         ldb   #$80
         stb   DAT.Task
         sta   >$FD80
         lda   #$01
         sta   >$FD8E
         lda   #$FF
         sta   >$FD8F
         lbra  COLD+$F000 LF019

L0C88    ldb   $06,x
         orcc  #$50
         stb   DAT.Task
         leas  ,u
         rti   

L0C92    ldb   $06,x
         stb   DAT.Task
         jmp   ,u

L0C99    andcc #$FE
         pshs  b,cc
         orcc  #$50
         stb   DAT.Task
         lda   ,x
         ldb   #$80
         stb   DAT.Task
         puls  pc,b,cc

L0CAB    andcc #$FE
         pshs  b,cc
         orcc  #$50
         stb   DAT.Task
         sta   ,x
         ldb   #$80
         stb   DAT.Task
         puls  pc,b,cc

L0CBD    andcc #$FE
         pshs  a,cc
         orcc  #$50
         stb   DAT.Task
         ldb   ,x
         lda   #$80
         sta   DAT.Task
         puls  pc,a,cc

L0CCF    orcc  #$50
         bcc   L0CE5
         sta   DAT.Task
         lda   ,x+
         stb   DAT.Task
         sta   ,u+
         leay  $01,y
         bra   L0CF3
L0CE1    lda   $01,s
         orcc  #$50
L0CE5    sta   DAT.Task
         ldd   ,x++
         exg   b,dp
         stb   DAT.Task
         exg   b,dp
         std   ,u++
L0CF3    lda   #$80
         sta   DAT.Task
         lda   ,s
         tfr   a,cc
         leay  -$01,y
         bne   L0CE1
         puls  pc,u,y,x,dp,b,a,cc

L0D02    orcc  #$50
L0D04    lda   $01,x
         leax  $02,x
         stb   DAT.Task
         sta   ,u+
         lda   #$80
         sta   DAT.Task
         leay  -$01,y
         bne   L0D04
         puls  pc,u,y,x,b,a,cc

         orcc  #$50
         ldb   #$F2
         bra   IRQH10
         orcc  #$50
         ldb   #$F4
         bra   IRQH10
         tst   ,s
         bmi   L0D38
         pshs  a
         lda   $01,s
         pshs  y,x,dp,b,a
         ora   #$80
         pshs  a
         lda   $08,s
         sta   $01,s
         stu   $08,s
L0D38    ldb   #D.FIRQ
         bra   IRQH10

         orcc  #$50
         ldb   #D.IRQ

IRQH10   lda   #$80
         sta   DAT.Task
         clra  
         tfr   a,dp
         tfr   d,x
         jmp   [,x]

SWIHN    ldb   #D.SWI
         bra   IRQH10

NMIHN    ldb   #D.NMI
         bra   IRQH10

         emod
OS9End      equ   *

  fcb $9F,$1A,$C8,$30,$10,$34,$AD,$EC,$A0
SYSVEC equ $0D60
  fcb $FD,$A1,$F4,$DA,$F4,$E4,$FE,$EA,$FE,$06,$F4,$ED,$F2,$80,$F2,$80
  fcb $F2,$80,$FF,$98,$FF,$9E,$FF,$A4,$FF,$BC,$FF,$CC
  fdb $FFD0
  fdb $FEF0
ROMEnd equ $0D80
