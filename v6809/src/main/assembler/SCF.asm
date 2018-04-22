         nam   SCF
         ttl   os9 file manager     

         ifp1
         use   os9defs
         endc
tylg     set   FlMgr+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   0
size     equ   .
name     equ   *
         fcs   /SCF/
         fcb   $08 
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

* Open/Create entry
Open
Create   ldx   PD.DEV,y
         stx   <$3B,y
         ldu   $06,y
         ldx   $04,u
         pshs  y
         os9   F$PrsNam 
         bcs   L00C7
         lda   -$01,y
         bmi   L0053
         leax  ,y
         os9   F$PrsNam 
         bcc   L00C7
L0053    sty   $04,u
         puls  y
         lda   #$01
         bita  $01,y
         beq   L009C
         ldd   #$0001
         os9   F$SRqMem 
         bcs   L00CC
         stu   $08,y
         clrb  
         bsr   L008B

* cute message
         fcb   $62,$1B,$59,$6B,$65,$65,$2A,$11,$1C,$0D,$0F
         fcb   $42,$0C,$6C,$62,$6D,$31,$13,$0F,$0B,$49,$0C
         fcb   $72,$7C,$6A,$2B,$08,$00,$02,$11,$00,$79

* put cute message into our newly allocated PD buffer
L008B    puls  x                       get PC into X
         clra  
L008E    eora  ,x+
         sta   ,u+
         decb  
         cmpa  #$0D
         bne   L008E
L0097    sta   ,u+
         decb  
         bne   L0097
L009C    ldu   $03,y
         beq   MakDir
         ldx   $02,u
         lda   <$28,y
         sta   $07,x
         ldx   $04,u
         ldd   <$36,y
         beq   Seek
         leax  d,x
         lda   $01,y
         anda  #$02
         asra  
         pshs  a
         lda   $01,y
         anda  #$01
         lsla  
         ora   ,s+
         os9   I$Attach 
         bcs   L00CC
         stu   $0A,y
* seek/delete routine
Seek
Delete   clra
         rts   
L00C7    puls  pc,y

* ChgDir/MakDir entry
ChgDir
MakDir   comb
         ldb   #$D7
L00CC    rts   

Term     tst   $02,y
         bne   L00E3
         ldu   $0A,y
         beq   L00D8
         os9   I$Detach 
L00D8    ldu   $08,y
         beq   L00E2
         ldd   #$0001
         os9   F$SRtMem 
L00E2    clra  
L00E3    rts   

GetStat  ldx   $06,y
         lda   $02,x
         cmpa  #$00
         beq   L011C
         pshs  a
         ldd   #$0009
L00F1    ldx   $03,y
         ldu   $02,x
         ldx   ,x
         addd  $09,x
         leax  d,x
         puls  a
         jmp   ,x                      jump into driver

PutStat  ldx   $06,y
         lda   $02,x
         cmpa  #$00
         beq   L010E
         pshs  a
         ldd   #$000C
         bra   L00F1
L010E    ldx   $04,x
         leay  <$20,y
         ldb   #$1A
L0115    lda   ,x+
         sta   ,y+
         decb  
         bne   L0115
L011C    clrb  
         rts   
         comb  
         ldb   #$D0
L0121    rts   

Read     lbsr  L0327
         bcs   L0121
         inc   $0C,y
         ldx   $06,u
         beq   L016A
         pshs  x
         ldx   #$0000
         ldu   $04,u
         lbsr  L027E
         bcs   L0143
         tsta  
         beq   L0159
         cmpa  <$2C,y
         bne   L0151
L0141    ldb   #$D3
L0143    leas  $02,s
         pshs  b
         bsr   L016A
         comb  
         puls  pc,b
L014C    lbsr  L027E
         bcs   L0143
L0151    tst   <$24,y
         beq   L0159
         lbsr  L0396
L0159    leax  $01,x
         sta   ,u+
         beq   L0164
         cmpa  <$2B,y
         beq   L0168
L0164    cmpx  ,s
         bcs   L014C
L0168    leas  $02,s
L016A    ldu   $06,y
         stx   $06,u
         lbra  L02D1

ReadLn   lbsr  L0327
         bcs   L0121
         ldx   $06,u
         beq   L016A
         tst   $06,u
         beq   L0181
         ldx   #$0100
L0181    pshs  x
         ldd   #$FFFF
         std   $0D,y
         lbsr  L0231
L018B    lbsr  L027E
         lbcs  L0217
         tsta  
         beq   L01A0
         ldb   #$29
L0197    cmpa  b,y
         beq   L01C9
         incb  
         cmpb  #$31
         bls   L0197
L01A0    cmpx  $0D,y
         bls   L01A6
         stx   $0D,y
L01A6    leax  $01,x
         cmpx  ,s
         bcs   L01B6
         lda   <$33,y
         lbsr  L024F
         leax  -$01,x
         bra   L018B
L01B6    lbsr  L029F
         sta   ,u+
         cmpa  #$0A
         bra   L01C4
         lbsr  L0251
         lda   #$0A
L01C4    lbsr  L02AF
         bra   L018B
L01C9    pshs  pc,x
         leax  >L01DC,pcr
         subb  #$29
         lslb  
         leax  b,x
         stx   $02,s
         puls  x
         jsr   [,s++]
         bra   L018B
L01DC    bra   L0237
         bra   L0226
         bra   L01EE
         bra   L020D
         bra   L0255
         bra   L025E
         puls  pc
         bra   L0226
         bra   L0226
L01EE    leas  $02,s
         sta   ,u
         lbsr  L02AF
         ldu   $06,y
         leax  $01,x
         stx   $06,u
         ldx   $04,u
         ldu   $08,y
L01FF    lda   ,u+
         sta   ,x+
         cmpa  <$2B,y
         bne   L01FF
         leas  $02,s
         lbra  L02D1
L020D    leas  $02,s
         leax  ,x
         lbeq  L0141
         bra   L01A0
L0217    pshs  b
         lda   #$0D
         sta   ,u
         bsr   L0251
         puls  b
         lbra  L0143
L0224    bsr   L0237
L0226    leax  ,x
         beq   L0231
         tst   <$23,y
         beq   L0224
         bsr   L0251
L0231    ldx   #$0000
         ldu   $08,y
         rts   
L0237    leax  ,x
         lbeq  L02BD
         leau  -$01,u
         leax  -$01,x
         tst   <$22,y
         beq   L024C
         bsr   L024C
         lda   #$20
         bsr   L024F
L024C    lda   <$32,y
L024F    bra   L02C6
L0251    lda   #$0D
         bra   L02C6
L0255    lda   <$2B,y
         sta   ,u
         bsr   L0231
L025C    bsr   L02BE
L025E    cmpx  $0D,y
         beq   L0275
         leax  $01,x
         cmpx  $02,s
         bcc   L0273
         lda   ,u+
         beq   L025C
         cmpa  <$2B,y
         bne   L025C
         leau  -$01,u
L0273    leax  -$01,x
L0275    rts   
L0276    pshs  u,y,x
         ldx   $0A,y
         ldu   $03,y
         bra   L0286
L027E    pshs  u,y,x
         ldx   $03,y
         ldu   $0A,y
         beq   L028D
L0286    ldu   $02,u
         ldb   <$28,y
         stb   $07,u
L028D    leax  ,x
         beq   L029D
         tfr   u,d
         ldu   $02,x
         std   $09,u
         ldu   #$0003
         lbsr  L03FF
L029D    puls  pc,u,y,x
L029F    tst   <$21,y
         beq   L02AE
         cmpa  #$61
         bcs   L02AE
         cmpa  #$7A
         bhi   L02AE
         suba  #$20
L02AE    rts   
L02AF    tst   <$24,y
         bne   L02BE
         cmpa  #$0D
         bne   L02BD
         tst   <$25,y
         bne   L02BE
L02BD    rts   
L02BE    cmpa  #$20
         bcc   L02C6
         cmpa  #$0D
         bne   L02C9
L02C6    lbra  L0396
L02C9    pshs  a
         lda   #$2E
         bsr   L02C6
         puls  pc,a
L02D1    ldx   D.Proc
         lda   ,x
         ldx   $03,y
         bsr   L02DB
         ldx   $0A,y
L02DB    beq   L02E5
         ldx   $02,x
         cmpa  $04,x
         bne   L02E5
         clr   $04,x
L02E5    rts   
L02E6    pshs  x,a
         ldx   $02,x
         lda   $04,x
         beq   L0308
         cmpa  ,s
         beq   L0324
         pshs  a
         bsr   L02D1
         puls  a
         os9   F$IOQu   
         inc   $0F,y
         ldx   D.Proc
         ldb   <$36,x
         puls  x,a
         beq   L02E6
         coma  
         rts   
L0308    lda   ,s
         sta   $04,x
         sta   $03,x
         lda   <$2F,y
         sta   $0D,x
         ldd   <$30,y
         std   $0B,x
         ldd   <$38,y
         std   $0F,x
         lda   <$34,y
         beq   L0324
         sta   $06,x
L0324    clra  
         puls  pc,x,a
L0327    ldx   D.Proc
         lda   ,x
         clr   $0F,y
         ldx   $03,y
         bsr   L02E6
         bcs   L0341
         ldx   $0A,y
         beq   L033B
         bsr   L02E6
         bcs   L0341
L033B    tst   $0F,y
         bne   L0327
         clr   $0C,y
L0341    ldu   $06,y
         rts   

WriteLn  bsr   L0327
         bra   L034C
Write    bsr   L0327
         inc   $0C,y
L034C    ldx   $04,u
         ldu   $06,u
         beq   L038D
L0352    lda   ,x+
         tst   $0C,y
         bne   L036C
         lbsr  L029F
         cmpa  #$0A
         bne   L036C
         lda   #$0D
         tst   <$25,y
         bne   L036C
         bsr   L03A2
         bcs   L0390
         lda   #$0A
L036C    bsr   L03A2
         bcs   L0390
         leau  -$01,u
         cmpu  #$0000
         bls   L038D
         lda   -$01,x
         beq   L0352
         cmpa  <$2B,y
         bne   L0352
         tst   $0C,y
         bne   L0352
L0385    ldu   $06,y
         tfr   x,d
         subd  $04,u
         std   $06,u
L038D    lbra  L02D1
L0390    pshs  b,cc
         bsr   L0385
         puls  pc,b,cc
L0396    pshs  u,x,a
         ldx   $0A,y
         beq   L03F6
         cmpa  #$0D
         bne   L03F8
         bra   L03D1
L03A2    pshs  u,x,a
         ldx   $03,y
         cmpa  #$0D
         bne   L03F8
         ldu   $02,x
         tst   $08,u
         bne   L03BF
         tst   $0C,y
         bne   L03D1
         tst   <$27,y
         beq   L03D1
         dec   $07,u
         bne   L03D1
         bra   L03C9
L03BF    lbsr  L0276
         bcs   L03C9
         cmpa  <$2F,y
         bne   L03BF
L03C9    lbsr  L0276
         cmpa  <$2F,y
         beq   L03C9
L03D1    ldu   $02,x
         clr   $08,u
         lda   #$0D
         bsr   L03FC
         tst   $0C,y
         bne   L03F6
         ldb   <$26,y
         pshs  b
         tst   <$25,y
         beq   L03ED
         lda   #$0A
L03E9    bsr   L03FC
         bcs   L03F4
L03ED    lda   #$00
         dec   ,s
         bpl   L03E9
         clra  
L03F4    leas  $01,s
L03F6    puls  pc,u,x,a
L03F8    bsr   L03FC
         puls  pc,u,x,a
L03FC    ldu   #$0006
L03FF    pshs  u,y,x,a
         ldu   $02,x
         clr   $05,u
         ldx   ,x
         ldd   $09,x
         addd  $05,s
         leax  d,x
         lda   ,s+
         jsr   ,x
         puls  pc,u,y,x
         emod
eom      equ   *
