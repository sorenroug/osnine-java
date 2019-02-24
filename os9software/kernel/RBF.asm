********************************************************************

         nam   RBF
         ttl   Disk file manager

         ifp1
         use   defsfile
         endc

tylg     set   FlMgr+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   0
size     equ   .

name     equ   *
         fcs   /RBF/
         fcb   $07 

L0011    fcb   DRVMEM

* All routines are entered with
* (Y) = Path descriptor pointer
* (U) = Caller's register stack pointer
start    equ   *
         lbra  Create
         lbra  Open
         lbra  MakDir
         lbra  ChgDir
         lbra  Delete
         lbra  Seek
         lbra  Read
         lbra  Write
         lbra  ReadLn
         lbra  WriteLn
         lbra  GetStat
         lbra  PutStat
         lbra  Term

********************************************************************
* Y points to path descriptor
* U points to something also
Create   pshs  y
         leas  -$05,s
         lda   R$B,u
         anda  #^DIR.
         sta   R$B,u   save perms back
         lbsr  L05B8
         bcs   L004A
         ldb   #E$CEF
L004A    cmpb  #E$PNNF
         bne   L0070
         cmpa  #PDELIM    Compare '/
         beq   L0070
         pshs  x
         ldx   PD.RGS,y
         stu   R$X,x
         ldb   <PD.SBP,y
         ldx   <PD.SBP+1,y
         lda   <PD.SSZ,y
         ldu   <PD.SSZ+1,y
         pshs  u,x,b,a
         clra  
         ldb   #$01
         lbsr  L08C3
         bcc   L0075
         leas  $08,s
L0070    leas  $05,s
         lbra  L0275
L0075    std   $0B,s
         ldb   <PD.SBP,y
         ldx   <PD.SBP+1,y
         stb   $08,s
         stx   $09,s
         puls  u,x,b,a
         stb   <PD.SBP,y
         stx   <PD.SBP+1,y
         sta   <PD.SSZ,y
         stu   <PD.SSZ+1,y
         ldd   <PD.DCP,y
         std   $0B,y
         ldd   <PD.DCP+2,y
         std   $0D,y
         lbsr  L071C
         bcs   L00A7
L009E    tst   ,x
         beq   L00BC
         lbsr  L0707
         bcc   L009E
L00A7    cmpb  #$D3
         bne   L0070
         ldd   #$0020
         lbsr  L04AB
         bcs   L0070
         lbsr  L0237
         lbsr  L0CD5   Is buffer modified?
         lbsr  L071C
L00BC    leau  ,x
         lbsr  L015C
         puls  x
         os9   F$PrsNam 
         bcs   L0070
         cmpb  #$1D
         bls   L00CE
         ldb   #$1D
L00CE    clra  
         tfr   d,y
         lbsr  L04DD
         tfr   y,d
         ldy   $05,s
         decb  
         lda   b,u
         ora   #$80
         sta   b,u
         ldb   ,s
         ldx   $01,s
         stb   <$1D,u
         stx   <$1E,u
         lbsr  L0CA5
         bcs   L0144
         ldu   $08,y
         bsr   L0163
         lda   #$04
         sta   $0A,y
         ldx   $06,y
         lda   $02,x
         sta   ,u
         ldx   D.Proc
         ldd   P$User,x
         std   FD.OWN,u
         lbsr  GetDate
         ldd   FD.DAT,u
         std   FD.Creat,u
         ldb   FD.DAT+2,u
         stb   FD.Creat+2,u
         ldb   #$01
         stb   FD.LNK,u
         ldd   $03,s
         subd  #$0001
         beq   L012B
         leax  <FD.SEG,u
         std   FDSL.B,x
         ldd   $01,s
         addd  #$0001
         std   FDSL.A+1,x
         ldb   ,s
         adcb  #$00
         stb   FDSL.A,x
L012B    ldb   ,s
         ldx   $01,s
         lbsr  L0CA7
         bcs   L0144
         lbsr  L07B3
         stb   <PD.FD,y
         stx   <PD.FD+1,y
         lbsr  L07A7
         leas  $05,s
         bra   L01BA
L0144    puls  u,x,a
         sta   <PD.SBP,y
         stx   <PD.SBP+1,y
         clr   <PD.SSZ,y
         stu   <PD.SSZ+1,y
         pshs  b
         lbsr  L0AD7
         puls  b
L0159    lbra  L0275
L015C    pshs  u,x,b,a
         leau  <$20,u
         bra   L0169
L0163    pshs  u,x,b,a
         leau  >$0100,u
L0169    clra  
         clrb  
         tfr   d,x
L016D    pshu  x,b,a
         cmpu  $04,s
         bhi   L016D
         puls  pc,u,x,b,a

********************************************************************
* Y points to path descriptor
Open     pshs  y
         lbsr  L05B8
         bcs   L0159
         ldu   PD.RGS,y
         stx   R$X,u
         ldd   <PD.FD+1,y
         bne   L01B3
         lda   <$34,y
         bne   L01B3
         ldb   PD.MOD,y
         andb  #DIR.
         lbne  L0273
         std   <PD.SBP,y
         sta   <PD.SBP+2,y
         std   <PD.SBL,y
         sta   <PD.SBL+2,y
         ldx   <PD.DTB,y
         lda   $02,x
         std   <$11,y
         sta   <$1B,y
         ldd   ,x
         std   $0F,y
         std   <$19,y
         puls  pc,y
L01B3    lda   $01,y
         lbsr  L076D
         bcs   L0159
L01BA    puls  y

* Copy from file descriptor to path descriptor
* U = file descriptor, Y = Path descriptor
L01BC    clra  
         clrb  
         std   PD.CP,y
         std   PD.CP+2,y
         std   <PD.SBL,y
         sta   <PD.SBL+2,y
         sta   <PD.SSZ,y
         lda   FD.ATT,u
         sta   <PD.ATT,y
         ldd   <FD.SEG+FDSL.A,u     Copy first segment from file descriptor
         std   <PD.SBP,y
         lda   <FD.SEG+FDSL.A+2,u
         sta   <PD.SBP+2,y
         ldd   <FD.SEG+FDSL.B,u
         std   <PD.SSZ+1,y
         ldd   FD.SIZ,u
         ldx   FD.SIZ+2,u
         std   PD.SIZ,y
         stx   <PD.SIZ+2,y
         clrb  
         rts   

********************************************************************
MakDir   lbsr  Create
         bcs   L0235
         ldd   #$0040       Set size for .. and .
         std   <PD.SIZ+2,y
         bsr   L0247
         bcs   L0235
         lbsr  L07B4
         bcs   L0235
         ldu   $08,y
         lda   ,u
         anda  #$BF
         ora   #$80    Set the directory flag
         sta   ,u
         bsr   L0237
         bcs   L0235
         lbsr  L0163
         ldd   #$2EAE     Add ..
         std   DIR.NM,u
         stb   <DIR.SZ+DIR.NM,u   Add .
         lda   <PD.DFD,y
         sta   <DIR.FD,u
         ldd   <PD.DFD+1,y
         std   <DIR.FD+1,u
         lda   <PD.FD,y
         sta   <DIR.SZ+DIR.FD,u
         ldd   <PD.FD+1,y
         std   <DIR.SZ+DIR.FD+1,u
         lbsr  L0CA5
L0235    bra   FreeBuf

L0237    lbsr  L0C43

* Write file size in memory to file descriptor
L023A    ldx   PD.BUF,y
         ldd   PD.SIZ,y
         std   FD.SIZ,x
         ldd   <PD.SIZ+2,y
         std   FD.SIZ+2,x
         clr   PD.SMF,y
L0247    lbra  L0C9D

* Y points to path descriptor
Term     clra  
         tst   PD.CNT,y
         bne   L0272
         ldb   PD.MOD,y
         bitb  #WRITE.
         beq   FreeBuf
         lbsr  L0CD5   Is buffer modified?
         bcs   FreeBuf
         ldd   <$34,y
         bne   L0264
         lda   <$36,y
         beq   FreeBuf
L0264    bsr   GetDate
         bsr   L023A
         lbsr  L0515
         bcc   FreeBuf
         lbsr  L0A18
         bra   FreeBuf
L0272    rts   
L0273    ldb   #E$FNA   File not accessible
L0275    coma  
FreeBufY puls  y
FreeBuf  pshs  b,cc
         ldu   PD.BUF,y
         beq   L0284
         ldd   #$0100
         os9   F$SRtMem 
L0284    puls  pc,b,cc

* Get date
GetDate  lbsr  L0C43
         ldu   PD.BUF,y
         lda   FD.LNK,u   Save link count as it will be overwritten by F$Time
         pshs  a
         leax  FD.DAT,u
         os9   F$Time   
         puls  a
         sta   FD.LNK,u
         rts   

* Y points to path descriptor
ChgDir   pshs  y
         lda   PD.MOD,y
         ora   #$80
         sta   PD.MOD,y
         lbsr  Open
         bcs   FreeBufY
         ldx   D.Proc
         lda   <$21,y
         ldu   <$35,y
         ldb   $01,y
         bitb  #$03
         beq   L02BD
         ldb   <$34,y
         std   <$1C,x
         stu   <$1E,x
L02BD    ldb   $01,y
         bitb  #$04
         beq   L02CC
         ldb   <$34,y
         std   <$22,x
         stu   <$24,x
L02CC    clrb  
         bra   FreeBufY

********************************************************************
Delete   pshs  y
         lbsr  L05B8
         bcs   FreeBufY
         ldd   <$35,y
         bne   L02E2
         tst   <$34,y
         lbeq  L0273
L02E2    lda   #$42
         lbsr  L076D
         bcs   L0356
         ldu   $06,y
         stx   $04,u
         lbsr  L0C43
         bcs   L0356
         ldx   $08,y
         dec   $08,x
         beq   L02FD
         lbsr  L0C9D
         bra   L0323
L02FD    clra  
         clrb  
         std   $0F,y
         std   <$11,y
         lbsr  L0A18
         bcs   L0356
         ldb   <$34,y
         ldx   <$35,y
         stb   <$16,y
         stx   <$17,y
         ldx   $08,y
         ldd   <$13,x
         addd  #$0001
         std   <$1A,y
         lbsr  L0AD7
L0323    bcs   L0356
         lbsr  L0CD5   Is buffer modified?
         lbsr  L07B3
         lda   <$37,y
         sta   <$34,y
         ldd   <$38,y
         std   <$35,y
         lbsr  L07A7
         lbsr  L0C43
         bcs   L0356
         lbsr  L01BC Copy from file descriptor to path descriptor
         ldd   <$3A,y
         std   PD.CP,y
         ldd   <$3C,y
         std   PD.CP+2,y
         lbsr  L071C
         bcs   L0356
         clr   ,x
         lbsr  L0CA5
L0356    lbra  FreeBufY

********************************************************************
Seek     ldb   $0A,y
         bitb  #$02
         beq   L0372
         lda   $05,u
         ldb   $08,u
         subd  $0C,y
         bne   L036D
         lda   $04,u
         sbca  $0B,y
         beq   L0376
L036D    lbsr  L0CD5   Is buffer modified?
         bcs   L037A
L0372    ldd   $04,u
         std   $0B,y
L0376    ldd   $08,u
         std   $0D,y
L037A    rts   

********************************************************************
ReadLn   bsr   L03B7
         bsr   L03A0
         pshs  u,y,x,b,a
         exg   x,u
         ldy   #$0000
         lda   #$0D
L0389    leay  $01,y
         cmpa  ,x+
         beq   L0392
         decb  
         bne   L0389
L0392    ldx   $06,s
         bsr   L03E7
         sty   $0A,s
         puls  u,y,x,b,a
         ldd   $02,s
         leax  d,x
         rts   
L03A0    bsr   L0403
         lda   ,-x
         cmpa  #$0D
         beq   L03AC
         ldd   $02,s
         bne   L0409
L03AC    ldu   $06,y
         ldd   $06,u
         subd  $02,s
         std   $06,u
         leas  $08,s
         rts   
L03B7    ldd   $06,u
         bsr   L03C0
         bcs   L03E4
         std   $06,u
         rts   
L03C0    pshs  b,a
         ldd   <$11,y
         subd  $0D,y
         tfr   d,x
         ldd   $0F,y
         sbcb  $0C,y
         sbca  $0B,y
         bcs   L03E1
         bne   L03DE
         tstb  
         bne   L03DE
         cmpx  ,s
         bcc   L03DE
         stx   ,s
         beq   L03E1
L03DE    clrb  
         puls  pc,b,a
L03E1    comb  
         ldb   #E$EOF
L03E4    leas  $02,s
         rts   
L03E7    lbra  L04DD

********************************************************************
Read     bsr   L03B7
         bsr   L03FB
L03EE    pshs  u,y,x,b,a
         exg   x,u
         tfr   d,y
         bsr   L03E7
         puls  u,y,x,b,a
         leax  d,x
         rts   
L03FB    bsr   L0403
         bne   L0409
         clrb  
L0400    leas  $08,s
         rts   
L0403    ldd   $04,u
         ldx   $06,u
         pshs  x,b,a
L0409    lda   $0A,y
         bita  #$02
         bne   L042D
         lbsr  L0CD5   Is buffer modified?
         bcs   L0400
         tst   $0E,y
         bne   L0428
         tst   $02,s
         beq   L0428
         leax  <L048F,pcr
         cmpx  $06,s
         bne   L0428
         lbsr  L0BB8
         bra   L042B
L0428    lbsr  L0B96
L042B    bcs   L0400
L042D    ldu   $08,y
         clra  
         ldb   $0E,y
         leau  d,u
         negb  
         sbca  #$FF
         ldx   ,s
         cmpd  $02,s
         bls   L0440
         ldd   $02,s
L0440    pshs  b,a
         jsr   [<$08,s]
         stx   $02,s
         ldb   $01,s
         addb  $0E,y
         stb   $0E,y
         bne   L045C
         lbsr  L0CD5   Is buffer modified?
         inc   $0D,y
         bne   L045C
         inc   $0C,y
         bne   L045C
         inc   $0B,y
L045C    ldd   $04,s
         subd  ,s++
         std   $02,s
         jmp   [<$04,s]

********************************************************************
WriteLn  pshs  y
         clrb  
         ldy   $06,u
         beq   L0483
         ldx   $04,u
L046F    leay  -$01,y
         beq   L0483
         lda   ,x+
         cmpa  #$0D
         bne   L046F
         tfr   y,d
         nega  
         negb  
         sbca  #$00
         addd  $06,u
         std   $06,u
L0483    puls  y

********************************************************************
Write    ldd   $06,u
         beq   L04A9
         bsr   L04AB
         bcs   L04AA
         bsr   L04A0
L048F    pshs  y,b,a
         tfr   d,y
         bsr   L04DD
         puls  y,b,a
         leax  d,x
         lda   $0A,y
         ora   #$03
         sta   $0A,y
         rts   
L04A0    lbsr  L0403
         lbne  L0409
         leas  $08,s
L04A9    clrb  
L04AA    rts   
L04AB    addd  $0D,y
         tfr   d,x
         ldd   $0B,y
         adcb  #$00
         adca  #$00
L04B5    cmpd  $0F,y
         bcs   L04A9
         bhi   L04C1
         cmpx  <$11,y
         bls   L04A9
L04C1    pshs  u
         ldu   <$11,y
         stx   <$11,y
         ldx   $0F,y
         std   $0F,y
         pshs  u,x
         lbsr  L07B4
         puls  u,x
         bcc   L04DB
         stx   $0F,y
         stu   <$11,y
L04DB    puls  pc,u
L04DD    pshs  u,y,x
         ldd   $02,s
         beq   L0506
         leay  d,u
         lsrb  
         bcc   L04EC
         lda   ,x+
         sta   ,u+
L04EC    lsrb  
         bcc   L04F3
         ldd   ,x++
         std   ,u++
L04F3    pshs  y
         exg   x,u
         bra   L0500
L04F9    pulu  y,b,a
         std   ,x++
         sty   ,x++
L0500    cmpx  ,s
         bcs   L04F9
         leas  $02,s
L0506    puls  pc,u,y,x

********************************************************************
GetStat  ldb   $02,u
         cmpb  #SS.Opt
         beq   L052E
         cmpb  #SS.EOF
         bne   L051A
         clr   $02,u
         clra  
L0515    ldb   #$01
         lbra  L03C0
L051A    cmpb  #SS.Ready
         bne   L0521
         clr   $02,u
         rts   
L0521    cmpb  #SS.Size
         bne   L052F
         ldd   $0F,y
         std   $04,u
         ldd   <$11,y
         std   $08,u
L052E    rts   
L052F    cmpb  #SS.Pos
         bne   L053C
         ldd   $0B,y
         std   $04,u
         ldd   $0D,y
         std   $08,u
         rts   
L053C    cmpb  #SS.FD
         bne   L0556
         lbsr  L0C43
         bcs   L052E
         ldu   $06,y
         ldd   $06,u
         tsta  
         beq   L054F
         ldd   #$0100
L054F    ldx   $04,u
         ldu   $08,y
         lbra  L03EE
L0556    lda   #$09
         lbra  L0C64

********************************************************************
PutStat  ldb   $02,u
         cmpb  #SS.Opt
         bne   L056F
         ldx   $04,u
         leax  $02,x
         leau  <$22,y
         ldy   #$000D
         lbra  L04DD
L056F    cmpb  #SS.Size
         bne   L05AF
         ldd   <$35,y
         bne   L057D
         tst   <$34,y
         beq   L05B4
L057D    lda   $01,y
         bita  #$02
         beq   L05AB
         ldd   $04,u
         ldx   $08,u
         cmpd  $0F,y
         bcs   L0596
         bne   L0593
         cmpx  <$11,y
         bcs   L0596
L0593    lbra  L04B5
L0596    std   $0F,y
         stx   <$11,y
         ldd   $0B,y
         ldx   $0D,y
         pshs  x,b,a
         lbsr  L0A18
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         rts   
L05AB    comb  
         ldb   #E$BMode
         rts   

L05AF    lda   #$0C
         lbra  L0C64
L05B4    comb  
         ldb   #E$UnkSvc
L05B7    rts   

L05B8    ldd   #$0100
         stb   $0A,y
         os9   F$SRqMem 
         bcs   L05B7
         stu   $08,y
         ldx   $06,y
         ldx   $04,x
         pshs  u,y,x
         leas  -$04,s
         clra  
         clrb  
         sta   <$34,y
         std   <$35,y
         std   <$1C,y
         lda   ,x
         sta   ,s
         cmpa  #PDELIM
         bne   L05EF
         lbsr  L073C
         sta   ,s
         lbcs  L06D2
         leax  ,y
         ldy   $06,s
         bra   L0612
L05EF    anda  #$7F
         cmpa  #$40
         beq   L0612
         lda   #PDELIM
         sta   ,s
         leax  -$01,x
         lda   $01,y
         ldu   D.Proc
         leau  <$1A,u
         bita  #$24
         beq   L0608
         leau  $06,u
L0608    ldb   $03,u
         stb   <$34,y
         ldd   $04,u
         std   <$35,y
L0612    ldu   $03,y
         stu   <$3E,y
         lda   <$21,y
         ldb   >L0011,pcr
         mul   
         addd  $02,u
         addd  #$000F
         std   <$1E,y
         lda   ,s
         anda  #$7F
         cmpa  #$40
         bne   L0633
         leax  $01,x
         bra   L0655
L0633    lbsr  L0C30
         lbcs  L06DA
         ldu   $08,y
         ldd   $0E,u
         std   <$1C,y
         ldd   <$35,y
         bne   L0655
         lda   <$34,y
         bne   L0655
         lda   $08,u
         sta   <$34,y
         ldd   $09,u
         std   <$35,y
L0655    stx   $04,s
         stx   $08,s
L0659    lbsr  L0CD5   Is buffer modified?
         lbsr  L07A7
         bcs   L06DA
         lda   ,s
         cmpa  #PDELIM
         bne   L06BC
         clr   $02,s
         clr   $03,s
         lda   PD.MOD,y
         ora   #$80
         lbsr  L076D
         bcs   L06D2
         lbsr  L01BC Copy from file descriptor to path descriptor
         ldx   $08,s
         leax  $01,x
         lbsr  L073C
         std   ,s
         stx   $04,s
         sty   $08,s
         ldy   $06,s
         bcs   L06D2
         lbsr  L071C
         bra   L0693
L068F    bsr   L06DD
L0691    bsr   L0707
L0693    bcs   L06D2
         tst   ,x
         beq   L068F
         leay  ,x
         ldx   $04,s
         ldb   $01,s
         clra  
         os9   F$CmpNam 
         ldx   $06,s
         exg   x,y
         bcs   L0691
         bsr   L06EB
         lda   <$1D,x
         sta   <$34,y
         ldd   <$1E,x
         std   <$35,y
         lbsr  L07B3
         bra   L0659
L06BC    ldx   $08,s
         tsta  
         bmi   L06C9
         os9   F$PrsNam 
         leax  ,y
         ldy   $06,s
L06C9    stx   $04,s
         clra  
L06CC    lda   ,s
         leas  $04,s
         puls  pc,u,y,x
L06D2    cmpb  #$D3
         bne   L06DA
         bsr   L06DD
         ldb   #E$PNNF
L06DA    coma  
         bra   L06CC
L06DD    pshs  b,a
         lda   $04,s
         cmpa  #PDELIM
         beq   L0705
         ldd   $06,s
         bne   L0705
         puls  b,a
L06EB    pshs  b,a
         stx   $06,s
         lda   <PD.FD,y
         sta   <PD.DFD,y
         ldd   <PD.FD+1,y
         std   <PD.DFD+1,y
         ldd   PD.CP,y
         std   <PD.DCP,y
         ldd   PD.CP+2,y
         std   <PD.DCP+2,y
L0705    puls  pc,b,a

L0707    ldb   $0E,y
         addb  #$20
         stb   $0E,y
         bcc   L071C
         lbsr  L0CD5   Is buffer modified?
         inc   $0D,y
         bne   L071C
         inc   $0C,y
         bne   L071C
         inc   $0B,y
L071C    ldd   #$0020
         lbsr  L03C0
         bcs   L073B
         lda   $0A,y
         bita  #$02
         bne   L0734
         lbsr  L0BB8
         bcs   L073B
         lbsr  L0B96
         bcs   L073B
L0734    ldb   $0E,y
         lda   $08,y
         tfr   d,x
         clrb  
L073B    rts   
L073C    os9   F$PrsNam 
         pshs  x
         bcc   L076B
         clrb  
L0744    pshs  a
         anda  #$7F
         cmpa  #PDIR
         puls  a
         bne   L075F
         incb  
         leax  $01,x
         tsta  
         bmi   L075F
         lda   ,x
         cmpb  #$03
         bcs   L0744
         lda   #PDELIM
         decb  
         leax  -$03,x
L075F    tstb  
         bne   L0767
         comb  
         ldb   #E$BPNam
         puls  pc,x
L0767    leay  ,x
         andcc #$FE
L076B    puls  pc,x
L076D    tfr   a,b
         anda  #$07
         andb  #$C0
         pshs  x,b,a
         lbsr  L0C43
         bcs   L079C
         ldu   $08,y
         ldx   D.Proc
         ldd   $09,x
         beq   L0785
         cmpd  $01,u
L0785    puls  a
         beq   L078C
         lsla  
         lsla  
         lsla  
L078C    ora   ,s
         anda  #$BF
         pshs  a
         ora   #$80
         anda  ,u
         cmpa  ,s
         beq   L07A5
         ldb   #E$FNA
L079C    leas  $02,s
         coma  
         puls  pc,x
         ldb   #E$Share
         bra   L079C
L07A5    puls  pc,x,b,a
L07A7    clra  
         clrb  
         std   $0B,y
         std   $0D,y
         sta   <$19,y
         std   <$1A,y
L07B3    rts   
L07B4    pshs  u,x
L07B6    bsr   L0812
         bne   L07C6
         cmpx  <$1A,y
         bcs   L080D
         bne   L07C6
         lda   <$12,y
         beq   L080D
L07C6    lbsr  L0C43
         bcs   L080A
         ldx   $0B,y
         ldu   $0D,y
         pshs  u,x
         ldd   $0F,y
         std   $0B,y
         ldd   <$11,y
         std   $0D,y
         lbsr  L0BD2
         puls  u,x
         stx   $0B,y
         stu   $0D,y
         bcc   L080D
         cmpb  #$D5
         bne   L080A
         bsr   L0812
         bne   L07F6
         tst   <$12,y
         beq   L07F9
         leax  $01,x
         bne   L07F9
L07F6    ldx   #$FFFF
L07F9    tfr   x,d
         tsta  
         bne   L0806
         cmpb  <$2E,y
         bcc   L0806
         ldb   <$2E,y
L0806    bsr   L0820
         bcc   L07B6
L080A    coma  
         puls  pc,u,x
L080D    lbsr  L0BB8
         puls  pc,u,x
L0812    ldd   <$10,y
         subd  <$14,y
         tfr   d,x
         ldb   $0F,y
         sbcb  <$13,y
         rts   
L0820    pshs  u,x
         lbsr  L08C3
         bcs   L085C
         lbsr  L0C43
         bcs   L085C
         ldu   $08,y
         clra  
         clrb  
         std   $09,u
         std   $0B,u
         leax  <$10,u
         ldd   $03,x
         beq   L08A4
         ldd   $08,y
         inca  
         pshs  b,a
         bra   L084F
L0842    clrb  
         ldd   -$02,x
         beq   L0858
         addd  $0A,u
         std   $0A,u
         bcc   L084F
         inc   $09,u
L084F    leax  $05,x
         cmpx  ,s
         bcs   L0842
         comb  
         ldb   #E$SLF
L0858    leas  $02,s
         leax  -$05,x
L085C    bcs   L08C1
         ldd   -$04,x
         addd  -$02,x
         pshs  b,a
         ldb   -$05,x
         adcb  #$00
         cmpb  <$16,y
         puls  b,a
         bne   L08A4
         cmpd  <$17,y
         bne   L08A4
         ldu   <$1E,y
         ldd   $06,u
         ldu   $08,y
         subd  #$0001
         coma  
         comb  
         pshs  b,a
         ldd   -$05,x
         eora  <$16,y
         eorb  <$17,y
         lsra  
         rorb  
         lsra  
         rorb  
         lsra  
         rorb  
         anda  ,s+
         andb  ,s+
         std   -$02,s
         bne   L08A4
         ldd   -$02,x
         addd  <$1A,y
         bcs   L08A4
         std   -$02,x
         bra   L08B3
L08A4    ldd   <$16,y
         std   ,x
         lda   <$18,y
         sta   $02,x
         ldd   <$1A,y
         std   $03,x
L08B3    ldd   $0A,u
         addd  <$1A,y
         std   $0A,u
         bcc   L08BE
         inc   $09,u
L08BE    lbsr  L0C9D
L08C1    puls  pc,u,x
L08C3    pshs  u,y,x,b,a
         ldb   #$0D
L08C7    clr   ,-s
         decb  
         bne   L08C7
         ldx   <$1E,y
         ldd   $04,x
         std   $05,s
         ldd   $06,x
         std   $03,s
         std   $0B,s
         ldx   $03,y
         ldx   $04,x
         leax  <$12,x
         subd  #$0001
         addb  $0E,x
         adca  #$00
         bra   L08EB
L08E9    lsra  
         rorb  
L08EB    lsr   $0B,s
         ror   $0C,s
         bcc   L08E9
         std   $01,s
         ldd   $03,s
         std   $0B,s
         subd  #$0001
         addd  $0D,s
         bcc   L0905
         ldd   #$FFFF
         bra   L0905
L0903    lsra  
         rorb  
L0905    lsr   $0B,s
         ror   $0C,s
         bcc   L0903
         cmpa  #$08
         bcs   L0912
         ldd   #$0800
L0912    std   $0D,s
         lbsr  L0B49
         lbcs  L0A0C
         ldx   <$1E,y
         ldd   <$1A,x
         cmpd  $0E,x
         bne   L0944
         lda   <$1C,x
         cmpa  $04,x
         bne   L0944
         ldd   $0D,s
         cmpd  $01,s
         bcs   L0951
         lda   <$1D,x
         cmpa  $04,x
         bcc   L0944
         sta   $07,s
         nega  
         adda  $05,s
         sta   $05,s
         bra   L0951
L0944    ldd   $0E,x
         std   <$1A,x
         lda   $04,x
         sta   <$1C,x
         clr   <$1D,x
L0951    inc   $07,s
         ldb   $07,s
         lbsr  L0B8F
         lbcs  L0A0C
         ldd   $05,s
         tsta  
         beq   L0964
         ldd   #$0100
L0964    ldx   $08,y
         leau  d,x
         ldy   $0D,s
         clra  
         clrb  
         os9   F$SchBit 
         pshs  b,a,cc
         tst   $03,s
         bne   L097F
         cmpy  $04,s
         bcs   L097F
         lda   $0A,s
         sta   $03,s
L097F    puls  b,a,cc
         bcc   L09B2
         cmpy  $09,s
         bls   L0991
         sty   $09,s
         std   $0B,s
         lda   $07,s
         sta   $08,s
L0991    ldy   <$11,s
         tst   $05,s
         beq   L099D
         dec   $05,s
         bra   L0951
L099D    ldb   $08,s
         beq   L0A0A
         clra  
         cmpb  $07,s
         beq   L09AB
         stb   $07,s
         lbsr  L0B8F
L09AB    ldx   $08,y
         ldd   $0B,s
         ldy   $09,s
L09B2    std   $0B,s
         sty   $09,s
         os9   F$AllBit 
         ldy   <$11,s
         ldb   $07,s
         lbsr  L0B77
         bcs   L0A0C
         lda   ,s
         beq   L09D0
         ldx   <$1E,y
         deca  
         sta   <$1D,x
L09D0    lda   $07,s
         deca  
         clrb  
         lsla  
         rolb  
         lsla  
         rolb  
         lsla  
         rolb  
         stb   <$16,y
         ora   $0B,s
         ldb   $0C,s
         ldx   $09,s
         ldy   <$11,s
         std   <$17,y
         stx   <$1A,y
         ldd   $03,s
         bra   L0A00
L09F1    lsl   <$18,y
         rol   <$17,y
         rol   <$16,y
         lsl   <$1B,y
         rol   <$1A,y
L0A00    lsra  
         rorb  
         bcc   L09F1
         clrb  
         ldd   <$1A,y
         bra   L0A14
L0A0A    ldb   #E$Full
L0A0C    ldy   <$11,s
         lbsr  L0B7E
         coma  
L0A14    leas  $0F,s
         puls  pc,u,y,x

L0A18    clra  
         lda   PD.MOD,y
         bita  #$80
         bne   L0A7A
         ldd   PD.SIZ,y
         std   PD.CP,y
         ldd   <PD.SIZ+2,y
         std   PD.CP+2,y
         lbsr  L0BD2
         bcc   L0A31
         cmpb  #E$NES
         bra   L0A72

L0A31    ldd   <$14,y
         subd  $0C,y
         addd  <$1A,y
         tst   $0E,y
         beq   L0A40
         subd  #$0001
L0A40    pshs  b,a
         ldu   <PD.DTB,y
         ldd   $06,u
         subd  #$0001
         coma  
         comb  
         anda  ,s+
         andb  ,s+
         ldu   <$1A,y
         std   <$1A,y
         beq   L0A74
         tfr   u,d
         subd  <$1A,y
         pshs  x,b,a
         addd  <$17,y
         std   <$17,y
         bcc   L0A6A
         inc   <$16,y
L0A6A    bsr   L0AD7
         bcc   L0A7B
         leas  $04,s
         cmpb  #E$IBA
L0A72    bne   L0A79
L0A74    lbsr  L0C43
         bcc   L0A84
L0A79    coma  
L0A7A    rts   

L0A7B    lbsr  L0C43
         bcs   L0AD4
         puls  x,b,a
         std   $03,x
L0A84    ldu   PD.BUF,y
         ldd   <$11,y
         std   $0B,u
         ldd   $0F,y
         std   $09,u
         tfr   x,d
         clrb  
         inca  
         leax  $05,x
         pshs  x,b,a
         bra   L0ABF
L0A99    ldd   -$02,x
         beq   L0ACC
         std   <$1A,y
         ldd   -$05,x
         std   <$16,y
         lda   -$03,x
         sta   <$18,y
         bsr   L0AD7
         bcs   L0AD4
         stx   $02,s
         lbsr  L0C43
         bcs   L0AD4
         ldx   $02,s
         clra  
         clrb  
         std   -$05,x
         sta   -$03,x
         std   -$02,x
L0ABF    lbsr  L0C9D
         bcs   L0AD4
         ldx   $02,s
         leax  $05,x
         cmpx  ,s
         bcs   L0A99
L0ACC    clra  
         clrb  
         sta   <$19,y
         std   <$1A,y
L0AD4    leas  $04,s
         rts   
L0AD7    pshs  u,y,x,a
         ldx   <$1E,y
         ldd   $06,x
         subd  #$0001
         addd  <$17,y
         std   <$17,y
         ldd   $06,x
         bcc   L0AFF
         inc   <$16,y
         bra   L0AFF
L0AF0    lsr   <$16,y
         ror   <$17,y
         ror   <$18,y
         lsr   <$1A,y
         ror   <$1B,y
L0AFF    lsra  
         rorb  
         bcc   L0AF0
         clrb  
         ldd   <$1A,y
         beq   L0B47
         ldd   <$16,y
         lsra  
         rorb  
         lsra  
         rorb  
         lsra  
         rorb  
         tfr   b,a
         ldb   #E$IBA
         cmpa  $04,x
         bhi   L0B46
         cmpa  <$1D,x
         bcc   L0B22
         sta   <$1D,x
L0B22    inca  
         sta   ,s
L0B25    bsr   L0B49
         bcs   L0B25
         ldb   ,s
         bsr   L0B8F
         bcs   L0B46
         ldx   $08,y
         ldd   <$17,y
         anda  #$07
         ldy   <PD.SSZ+1,y
         os9   F$DelBit 
         ldy   $03,s
         ldb   ,s
         bsr   L0B77
         bcc   L0B47
L0B46    coma  
L0B47    puls  pc,u,y,x,a
L0B49    lbsr  L0CD5   Is buffer modified?
         bra   L0B53
L0B4E    os9   F$IOQu   
         bsr   L0B63
L0B53    bcs   L0B62
         ldx   <$1E,y
         lda   <$17,x
         bne   L0B4E
         lda   $05,y
         sta   <$17,x
L0B62    rts   

L0B63    ldu   D.Proc
         ldb   <P$Signal,u
         beq   L0B6E
         cmpb  #$03
         bls   L0B75
L0B6E    clra  
         lda   P$State,u
         bita  #$02
         beq   L0B76
L0B75    coma  
L0B76    rts   
L0B77    clra  
         tfr   d,x
         clrb  
         lbsr  L0CA7
L0B7E    pshs  cc
         ldx   <$1E,y
         lda   $05,y
         cmpa  <$17,x
         bne   L0B8D
         clr   <$17,x
L0B8D    puls  pc,cc
L0B8F    clra  
         tfr   d,x
         clrb  
         lbra  L0C62
L0B96    pshs  u,x
         bsr   L0BB8
         bcs   L0BA7
         lbsr  L0C5C
         bcs   L0BA7
         lda   $0A,y
         ora   #$02
         sta   $0A,y
L0BA7    puls  pc,u,x

         pshs  u,x
         lbsr  L0CA5
         bcs   L0BB6
         lda   $0A,y
         anda  #$FE
         sta   $0A,y
L0BB6    puls  pc,u,x

L0BB8    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         cmpb  <$19,y
         bcs   L0BD0
         bhi   L0BD2
         cmpx  <$1A,y
         bcc   L0BD2
L0BD0    clrb  
         rts   

L0BD2    pshs  u
         bsr   L0C43
         bcs   L0C2C
         clra  
         clrb  
         std   <$13,y
         stb   <$15,y
         ldu   $08,y
         leax  <$10,u
         lda   $08,y
         ldb   #E$Lock
         pshs  b,a
L0BEB    ldd   $03,x
         beq   L0C10
         addd  <$14,y
         tfr   d,u
         ldb   <$13,y
         adcb  #$00
         cmpb  $0B,y
         bhi   L0C1D
         bne   L0C04
         cmpu  $0C,y
         bhi   L0C1D
L0C04    stb   <$13,y
         stu   <$14,y
         leax  $05,x
         cmpx  ,s
         bcs   L0BEB
L0C10    clra  
         clrb  
         sta   <$19,y
         std   <$1A,y
         comb  
         ldb   #E$NES
         bra   L0C2C
L0C1D    ldd   ,x
         std   <$16,y
         lda   $02,x
         sta   <$18,y
         ldd   $03,x
         std   <$1A,y
L0C2C    leas  $02,s
         puls  pc,u
L0C30    pshs  x,b
         lbsr  L0CD5   Is buffer modified?
         bcs   L0C3F
         clrb  
         ldx   #$0000
         bsr   L0C62
         bcc   L0C41
L0C3F    stb   ,s
L0C41    puls  pc,x,b

* Check/load descriptor sector into buffer
L0C43    ldb   PD.SMF,y
         bitb  #$04
         bne   L0BD0      Clear B and return
         lbsr  L0CD5   Is buffer modified?
         bcs   L0CBD
         ldb   PD.SMF,y
         orb   #$04
         stb   PD.SMF,y
         ldb   <PD.FD,y
         ldx   <PD.FD+1,y
         bra   L0C62
L0C5C    bsr   L0CD5   Is buffer modified?
         bcs   L0CBD
         bsr   L0CBE
L0C62    lda   #$03
L0C64    pshs  u,y,x,b,a
         ldu   $03,y
         ldu   $02,u
         bra   L0C6F

L0C6C    os9   F$IOQu   
L0C6F    lda   $04,u
         bne   L0C6C
         lda   PD.CPR,y
         sta   $04,u
         ldd   ,s
         ldx   $02,s
         pshs  u
         bsr   L0C8B
         puls  u
         lda   #$00
         sta   $04,u
         bcc   L0C89
         stb   $01,s
L0C89    puls  pc,u,y,x,b,a

L0C8B    pshs  pc,x,b,a
         ldx   PD.DEV,y
         ldd   ,x
         ldx   ,x
         addd  $09,x
         addb  ,s
         adca  #$00
         std   $04,s
         puls  pc,x,b,a

L0C9D    ldb   <PD.FD,y
         ldx   <PD.FD+1,y
         bra   L0CA7
L0CA5    bsr   L0CBE
L0CA7    lda   #$06
         pshs  x,b,a
         ldd   <PD.DSK,y
         beq   L0CB6
         ldx   <PD.DTB,y
         cmpd  DD.DSK,x
L0CB6    puls  x,b,a
         beq   L0C64
         comb  
         ldb   #E$DIDC  Disk ID change
L0CBD    rts   

L0CBE    ldd   $0C,y
         subd  <$14,y
         tfr   d,x
         ldb   $0B,y
         sbcb  <$13,y
         exg   d,x
         addd  <$17,y
         exg   d,x
         adcb  <$16,y
         rts   

* is the buffer modified?
L0CD5    clrb  
         pshs  u,x
         ldb   PD.SMF,y
         andb  #$06
         beq   L0CF2
         tfr   b,a
         eorb  PD.SMF,y
         stb   PD.SMF,y
         andb  #$01
         beq   L0CF2
         eorb  PD.SMF,y
         stb   PD.SMF,y
         bita  #$02
         beq   L0CF2
         bsr   L0CA5
L0CF2    puls  pc,u,x
         emod
eom      equ   *
