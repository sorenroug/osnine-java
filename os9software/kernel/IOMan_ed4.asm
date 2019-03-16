         nam   IOMan
         ttl   os9 system module    

* This is a disassembly of the IOMan edition 4 distributed with OS-9 for Dragon 64

* Header for : IOMan
* Module size: $6E7  #1767
* Module CRC : $BD0579 (Good)
* Hdr parity : $19
* Edition    : $04  #4
* Ty/La At/Rv: $C1 $81
* System mod, 6809 Obj, re-ent, R/O

         ifp1
         use   ../DEFS/os9defs
         endc
tylg     set   Systm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
edition  equ   $04
         mod   eom,name,tylg,atrv,IOManEnt,size

size     equ   .

name     fcs   /IOMan/
         fcb   edition

* IOMan is called from OS9p2
IOManEnt equ   *
* allocate device and polling tables
         ldx   D.Init
         lda   PollCnt,x
         ldb   #POLSIZ
         mul   
         pshs  b,a
         lda   DevCnt,x
         ldb   #DEVSIZ
         mul   
         addd  0,s
         addd  #$00FF                  bring up to next page
         clrb  
         os9   F$SRqMem 
         bcs   Crash
* clear allocated mem
         leax  ,u
L002E    clr   ,x+
         subd  #$0001
         bhi   L002E
         stu   D.PolTbl
         ldd   ,s++
         leax  d,u
         stx   D.DevTbl
         ldx   D.PthDBT
         os9   F$All64  
         bcs   Crash
         stx   D.PthDBT
         os9   F$Ret64  
         leax  >DPoll,pcr
         stx   <D.Poll
* install I/O system calls
         leay  <IOCalls,pcr
         os9   F$SSvc   
         rts                           return to OS9p2

Crash    jmp   [>$FFFE]

IOCalls  fcb   $7F
         fdb   UsrIO-*-2

         fcb   F$Load
         fdb   FLoad-*-2

         fcb   F$PErr
         fdb   FPErr-*-2

         fcb   F$IOQu+$80
         fdb   FIOQu-*-2

         fcb   $FF
         fdb   SysIO-*-2

         fcb   F$IRQ+$80
         fdb   FIRQ-*-2

         fcb   F$IODel+$80
         fdb   FIODel-*-2

         fcb   $80

FIODel   ldx   R$X,u
         pshs  u,y,x
         ldu   D.Init
         ldb   DevCnt,u
         pshs  b
         ldu   D.DevTbl
L007C    lbsr  L00FB
         bcs   L008C
         tst   $08,u
         lbne  L00F6
         leau  $09,u
         decb  
         bne   L007C
L008C    ldu   D.DevTbl
         ldb   ,s
L0090    lbsr  L00FB
         lbcs  L00F3
         tst   $08,u
         lbne  L00EA
         pshs  u,b
         ldx   $02,u
         clr   $02,u
         clr   $03,u
         ldu   D.DevTbl
         ldb   $03,s
L00A9    cmpx  $02,u
         beq   L00DD
         leau  $09,u
         decb  
         bne   L00A9
         ldu   $01,s
         ldy   D.Proc
         ldb   ,y
         stb   $08,u
         ldy   $04,u
         ldu   ,u
         exg   x,u
         ldd   $09,x
         leax  d,x
         pshs  u
         jsr   $0F,x
         puls  u
         ldx   $01,s
         ldx   ,x
         ldd   $0B,x
         addd  #$00FF                  round up to next page
         clrb  
         os9   F$SRtMem                return mem
         ldx   $01,s
         ldx   $04,x
L00DD    ldu   $01,s
         clr   $04,u
         clr   $05,u
         clr   $08,u
         lbsr  L04D1
         puls  u,b
L00EA    ldx   $01,s
         leau  $09,u
         decb  
         lbne  L0090
L00F3    clra  
         puls  pc,u,y,x,a

L00F6    comb  
         ldb   #E$ModBsy
         puls  pc,u,y,x,a

L00FB    cmpx  $04,u
         beq   L010D
         cmpx  ,u
         beq   L010D
         cmpx  $06,u
         beq   L010D
         leau  $09,u
         decb  
         bne   L00FB
         comb  
L010D    rts   

UsrIODis fdb   IAttach-UsrIODis
         fdb   IDetach-UsrIODis
         fdb   IDup-UsrIODis
         fdb   IUsrCall-UsrIODis
         fdb   IUsrCall-UsrIODis
         fdb   IMakDir-UsrIODis
         fdb   IChgDir-UsrIODis
         fdb   IDelete-UsrIODis
         fdb   UISeek-UsrIODis
         fdb   UIRead-UsrIODis
         fdb   UIWrite-UsrIODis
         fdb   UIRead-UsrIODis
         fdb   UIWrite-UsrIODis
         fdb   UIGetStt-UsrIODis
         fdb   UISeek-UsrIODis
         fdb   UIClose-UsrIODis
         fdb   IDeletX-UsrIODis

SysIODis fdb   IAttach-SysIODis
         fdb   IDetach-SysIODis
         fdb   SIDup-SysIODis
         fdb   ISysCall-SysIODis
         fdb   ISysCall-SysIODis
         fdb   IMakDir-SysIODis
         fdb   IChgDir-SysIODis
         fdb   IDelete-SysIODis
         fdb   SISeek-SysIODis
         fdb   SIRead-SysIODis
         fdb   SIWrite-SysIODis
         fdb   SIRead-SysIODis
         fdb   SIWrite-SysIODis
         fdb   SIGetStt-SysIODis
         fdb   SISeek-SysIODis
         fdb   SIClose-SysIODis
         fdb   IDeletX-SysIODis

UsrIO    leax  <UsrIODis,pcr
         bra   IODsptch
SysIO    leax  <SysIODis,pcr
IODsptch cmpb  #I$DeletX
         bhi   ErrSvc
         pshs  b
         lslb                          multiply by 2
         ldd   b,x                     offset
         leax  d,x                     get addr
         puls  b
         jmp   ,x
ErrSvc   comb  
         ldb   #E$UnkSvc
         rts   

IAttach  ldb   #$11
L016F    clr   ,-s
         decb  
         bpl   L016F
         stu   <$10,s
         lda   $01,u
         sta   $09,s
         ldx   $04,u
         lda   #Devic+0
         os9   F$Link   
         bcs   EAttach
         stu   $04,s
         ldy   <$10,s
         stx   $04,y
         ldd   $0F,u
         std   $0C,s
         ldd   $0B,u
         leax  d,u
         lda   #Drivr+0
         os9   F$Link   
         bcs   EAttach
         stu   ,s
         ldu   $04,s
         ldd   $09,u
         leax  d,u
         lda   #FlMgr+0
         os9   F$Link   
         bcc   L01B8
* error on attach, so detach
EAttach  stb   <$11,s                  save fmgr addr on stack
         leau  ,s
         os9   I$Detach 
         leas  <$11,s                  clean up stack
         comb  
         puls  pc,b

L01B8    stu   $06,s
         ldx   D.Init
         ldb   DevCnt,x
         lda   DevCnt,x
         ldu   D.DevTbl
L01C2    ldx   $04,u
         beq   L01F7
         cmpx  $04,s
         bne   L01DD
         ldx   $02,u
         bne   L01DB
         pshs  a
         lda   $08,u
         beq   L01D7
         os9   F$IOQu   
L01D7    puls  a
         bra   L01C2
L01DB    stu   $0E,s
L01DD    ldx   $04,u
         ldy   $0F,x
         cmpy  $0C,s
         bne   L01F7
         ldx   ,u
         cmpx  ,s
         bne   L01F7
         ldx   $02,u
         stx   $02,s
         tst   $08,u
         beq   L01F7
         sta   $0A,s
L01F7    leau  $09,u
         decb  
         bne   L01C2
         ldu   $0E,s
         lbne  L0259
         ldu   D.DevTbl
L0204    ldx   $04,u
         beq   L0219
         leau  $09,u
         deca  
         bne   L0204
         ldb   #E$DevOvf               device table overflow
         bra   EAttach
L0211    ldb   #E$BMode                bad mode
         bra   EAttach
L0215    ldb   #E$DevBsy
         bra   EAttach
L0219    ldx   $02,s
         lbne  L0250
         stu   $0E,s
         ldx   ,s
         ldd   $0B,x
         addd  #$00FF                  round up to next page
         clrb  
         os9   F$SRqMem 
         lbcs  EAttach
         stu   $02,s
L0232    clr   ,u+
         subd  #$0001
         bhi   L0232
         ldd   $0C,s
         ldu   $02,s
         clr   ,u
         std   $01,u
         ldy   $04,s
         ldx   ,s
         ldd   $09,x
         jsr   d,x
         lbcs  EAttach
         ldu   $0E,s                   get dev entry
L0250    ldb   #$08
L0252    lda   b,s
         sta   b,u
         decb  
         bpl   L0252
L0259    ldx   $04,u
         ldb   $07,x
         lda   $09,s
         anda  $0D,x
         ldx   ,u
         anda  $0D,x
         cmpa  $09,s
         lbne  L0211
         tst   $0A,s
         beq   L0277
         andb  $07,x
         bitb  #$80
         lbeq  L0215
L0277    inc   $08,u
         ldx   <$10,s
         stu   $08,x
         leas  <$12,s                  restore stack
         clrb  
         rts   

IDetach  ldu   R$U,u
         dec   $08,u
         ldx   $06,u
         ldy   ,u
         ldu   $04,u
         os9   F$UnLink 
         leau  ,y
         os9   F$UnLink 
         leau  ,x
         os9   F$UnLink                unlink descriptor
         clrb  
         rts   

* user state I$Dup
IDup     bsr   FindPath
         bcs   IDupRTS
         pshs  x,a
         lda   $01,u
         lda   a,x
         bsr   L02B6
         bcs   L02B2
         puls  x,b
         stb   $01,u
         sta   b,x
         rts   
L02B2    puls  pc,x,a

* system state I$Dup
SIDup    lda   R$A,u
L02B6    lbsr  FindPDsc
         bcs   IDupRTS
         inc   $02,y
IDupRTS  rts   

* find next free path position in current proc
FindPath ldx   D.Proc
         leax  <$26,x
         clra  
L02C4    tst   a,x
         beq   L02D1
         inca  
         cmpa  #$10
         bcs   L02C4
         comb  
         ldb   #$C8
         rts   
L02D1    andcc #^Carry
         rts   

IUsrCall bsr   FindPath
         bcs   L02E6
         pshs  u,x,a
         bsr   ISysCall
         puls  u,x,a
         bcs   L02E6
         ldb   $01,u
         stb   a,x
         sta   $01,u
L02E6    rts   

ISysCall pshs  b
         ldb   $01,u
         bsr   L0364
         bcs   L02FB
         puls  b
         lbsr  CallFMgr
         bcs   L030A
         lda   ,y
         sta   $01,u
         rts   
L02FB    puls  pc,a

* make directory
IMakDir  pshs  b
         ldb   #$82
L0301    bsr   L0364
         bcs   L02FB
         puls  b
         lbsr  CallFMgr
L030A    pshs  b,cc
         ldu   $03,y
         os9   I$Detach 
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64  
         puls  pc,b,cc

* change directory
IChgDir  pshs  b
         ldb   $01,u
         orb   #$80
         bsr   L0364
         bcs   L02FB
         puls  b
         lbsr  CallFMgr
         bcs   L030A
         ldu   D.Proc
         ldb   $01,y
         bitb  #$1B
         beq   L0341
         ldx   <$1A,u
         beq   L033A
         dec   $08,x
L033A    ldx   $03,y
         stx   <$1A,u
         inc   $08,x
L0341    bitb  #$24
         beq   L0353
         ldx   <$20,u
         beq   L034C
         dec   $08,x
L034C    ldx   $03,y
         stx   <$20,u
         inc   $08,x
L0353    clrb  
         bra   L030A

IDelete  pshs  b
         ldb   #$02
         bra   L0301

IDeletX  ldb   #$87
         pshs  b
         ldb   $01,u
         bra   L0301

* create path descriptor and initialize
* Entry:
*   B  = path mode
L0364    pshs  u
         ldx   <D.PthDBT
         os9   F$All64  
         bcs   L03C3
         inc   $02,y
         stb   $01,y
         ldx   $04,u
L0373    lda   ,x+
         cmpa  #$20
         beq   L0373
         leax  -$01,x
         stx   $04,u
         ldb   $01,y
         cmpa  #$2F
         beq   L0399
         ldx   D.Proc
         bitb  #$24
         beq   L038E
         ldx   <$20,x
         bra   L0391
L038E    ldx   <$1A,x
L0391    beq   L03C5
         ldx   $04,x
         ldd   $04,x
         leax  d,x
L0399    pshs  y
         os9   F$PrsNam 
         puls  y
         bcs   L03C5
         lda   $01,y
         os9   I$Attach 
         stu   $03,y
         bcs   L03C7
         ldx   $04,u
         leax  <$11,x
         ldb   ,x+
         leau  <$20,y
         cmpb  #$20
         bls   L03BF
         ldb   #$1F
L03BB    lda   ,x+
         sta   ,u+
L03BF    decb  
         bpl   L03BB
         clrb  
L03C3    puls  pc,u
L03C5    ldb   #$D7
L03C7    pshs  b
         lda   ,y
         ldx   D.PthDBT
         os9   F$Ret64  
         puls  b
         coma  
         bra   L03C3
L03D5    lda   $01,u
         cmpa  #$10
         bcc   L03E6
         ldx   D.Proc
         leax  <$26,x
         andcc #^Carry
         lda   a,x
         bne   L03E9
L03E6    comb  
         ldb   #$C9
L03E9    rts   

UISeek   bsr   L03D5
         bcc   GetPDsc
         rts   

SISeek   lda   $01,u
GetPDsc  bsr   FindPDsc
         lbcc  CallFMgr
         rts   

UIRead   bsr   L03D5
         bcc   L03FF
         rts   
SIRead   lda   $01,u
L03FF    pshs  b
         ldb   #$05
L0403    bsr   FindPDsc
         bcs   L0412
         bitb  $01,y
         beq   L0410
         puls  b
         lbra  CallFMgr
L0410    ldb   #$D7
L0412    com   ,s+
         rts   

UIWrite  bsr   L03D5
         bcc   L041C
         rts   

SIWrite  lda   $01,u
L041C    pshs  b
         ldb   #$02
         bra   L0403


* find path descriptor of path passed in A
* Exit:
*   Y  = addr of path desc (if no error)
FindPDsc pshs  x
         ldx   D.PthDBT
         os9   F$Find64 
         puls  x
         bcs   L03E6
L042D    rts   

UIGetStt bsr   L03D5
         bcc   L0435
         rts   

SIGetStt lda   $01,u
L0435    pshs  b,a
         lda   $02,u
         sta   $01,s
         puls  a
         bsr   GetPDsc
         puls  a
         pshs  cc
         tsta  
         beq   L044C
         cmpa  #$0E
         beq   L045E
         puls  pc,cc
L044C    leax  <$20,y
L044F    ldy   $04,u
         ldb   #$20
L0454    lda   ,x+
         sta   ,y+
         decb  
         bne   L0454
         leas  $01,s
         rts   
L045E    ldx   $03,y
         ldx   $04,x
         ldd   $04,x
         leax  d,x
         bra   L044F

UIClose  lbsr  L03D5
         bcs   L042D
         pshs  b
         ldb   $01,u
         clr   b,x
         puls  b
         bra   L0479

SIClose  lda   $01,u
L0479    bsr   FindPDsc
         bcs   L042D
         dec   $02,y
         tst   $05,y
         bne   L0485
         bsr   CallFMgr
L0485    tst   $02,y
         bne   L042D
         lbra  L030A
L048C    os9   F$IOQu   
         comb  
         ldb   <$36,x
         bne   L04A0
L0495    ldx   D.Proc
         ldb   ,x
         clra  
         lda   $05,y
         bne   L048C
         stb   $05,y
L04A0    rts   

* B = entry point into FMgr
* Y = path desc
CallFMgr pshs  u,y,x,b
         bsr   L0495
         bcc   L04AB
         leas  $01,s
         bra   L04BE
L04AB    stu   $06,y
         ldx   $03,y
         ldx   $06,x
         ldd   $09,x
         leax  d,x
         ldb   ,s+
         subb  #$83
         lda   #$03
         mul   
         jsr   d,x
L04BE    pshs  b,cc
         bsr   L04D1
         ldy   $04,s
         ldx   D.Proc
         lda   ,x
         cmpa  $05,y
         bne   L04CF
         clr   $05,y
L04CF    puls  pc,u,y,x,b,cc
L04D1    pshs  y,x
         ldy   D.Proc
         bra   L04E8
L04D8    clr   <$11,y
         ldb   #$01
         os9   F$Send   
         ldx   D.PrcDBT
         os9   F$Find64 
         clr   <$10,y
L04E8    lda   <$11,y
         bne   L04D8
         puls  pc,y,x

* IRQ install routine
FIRQ     ldx   $04,u
         ldb   ,x                      B = flip byte
         ldx   $01,x
         clra  
         pshs  cc
         pshs  x,b
         ldx   D.Init
         ldb   $0C,x
         ldx   D.PolTbl
         ldy   $04,u
         beq   L0540
         tst   $01,s
         beq   L056B
         decb  
         lda   #$09
         mul   
         leax  d,x
         lda   $03,x
         bne   L056B
         orcc  #$50
L0515    ldb   $02,s
         cmpb  -$01,x
         bcs   L0528
         ldb   #$09
L051D    lda   ,-x
         sta   $09,x
         decb  
         bne   L051D
         cmpx  D.PolTbl
         bhi   L0515
L0528    ldd   $01,u
         std   ,x
         ldd   ,s++
         sta   $02,x
         stb   $03,x
         ldb   ,s+
         stb   $08,x
         ldd   $06,u
         std   $04,x
         ldd   $08,u
         std   $06,x
         puls  pc,cc
L0540    leas  $04,s
         ldy   $08,u
L0545    cmpy  $06,x
         beq   L0551
         leax  $09,x
         decb  
         bne   L0545
         clrb  
         rts   
L0551    pshs  b,cc
         orcc  #$50
         bra   L055E
L0557    ldb   $09,x
         stb   ,x+
         deca  
         bne   L0557
L055E    lda   #$09
         dec   $01,s
         bne   L0557
L0564    clr   ,x+
         deca  
         bne   L0564
         puls  pc,a,cc
L056B    leas  $04,s
L056D    comb  
         ldb   #$CA
         rts   

* IRQ polling routine
DPoll    ldy   D.PolTbl
         ldx   D.Init
         ldb   $0C,x
         bra   L057F
L057A    leay  $09,y
         decb  
         beq   L056D
L057F    lda   [,y]
         eora  $02,y
         bita  $03,y
         beq   L057A
         ldu   $06,y
         pshs  y,b
         jsr   [<$04,y]
         puls  y,b
         bcs   L057A
         rts   

* load a module
FLoad    pshs  u
         ldx   $04,u
         bsr   L05B5
         bcs   L05B3
         inc   $02,u
         ldy   ,u
         ldu   ,s
         stx   $04,u
         sty   $08,u
         lda   $06,y
         ldb   $07,y
         std   $01,u
         ldd   $09,y
         leax  d,y
         stx   $06,u
L05B3    puls  pc,u
L05B5    lda   #$04
         os9   I$Open   
         bcs   L062B
         leas  -$0A,s
         ldu   #$0000
         pshs  u,y,x
         sta   $06,s
L05C5    ldd   $04,s
         bne   L05CB
         stu   $04,s
L05CB    lda   $06,s
         leax  $07,s
         ldy   #$0009
         os9   I$Read   
         bcs   L0617
         ldd   ,x
         cmpd  #$87CD
         bne   L0615
         ldd   $09,s
         os9   F$SRqMem 
         bcs   L0617
         ldb   #$09
L05E9    lda   ,x+
         sta   ,u+
         decb  
         bne   L05E9
         lda   $06,s
         leax  ,u
         ldu   $09,s
         leay  -$09,u
         os9   I$Read   
         leax  -$09,x
         bcs   L0604
         os9   F$VModul 
         bcc   L05C5
L0604    pshs  u,b
         leau  ,x
         ldd   $02,x
         os9   F$SRtMem 
         puls  u,b
         cmpb  #$E7
         beq   L05C5
         bra   L0617
L0615    ldb   #$CD
L0617    puls  u,y,x
         lda   ,s
         stb   ,s
         os9   I$Close  
         ldb   ,s
         leas  $0A,s
         cmpu  #$0000
         bne   L062B
         coma  
L062B    rts   

ErrHead  fcc   /ERROR #/
ErrNum   equ   *-ErrHead
         fcb   $2F,$3A,$30,$0D
ErrLen   equ   *-ErrHead

FPErr    ldx   D.Proc
         lda   <$28,x
         beq   L066D
         leas  -$0B,s
         leax  <ErrHead,pcr
         leay  ,s
L0645    lda   ,x+
         sta   ,y+
         cmpa  #$0D
         bne   L0645
         ldb   $02,u
L064F    inc   $07,s
         subb  #$64
         bcc   L064F
L0655    dec   $08,s
         addb  #$0A
         bcc   L0655
         addb  #$30
         stb   $09,s
         ldx   D.Proc
         leax  ,s
         ldu   D.Proc
         lda   <$28,u
         os9   I$WritLn 
         leas  $0B,s
L066D    rts   

FIOQu    ldy   D.Proc
L0671    lda   <P$IOQN,y
         beq   L0695
         cmpa  R$A,u
         bne   L068E
         clr   <P$IOQN,y
         ldx   D.PrcDBT
         os9   F$Find64 
         bcs   L06E3
         clr   <P$IOQP,y
         ldb   #S$Wake
         os9   F$Send   
         bra   L069E
L068E    ldx   D.PrcDBT
         os9   F$Find64 
         bcc   L0671
L0695    lda   R$A,u
L0697    ldx   D.PrcDBT
         os9   F$Find64 
         bcs   L06E3
L069E    lda   <P$IOQN,y
         bne   L0697
         ldx   D.Proc
         lda   ,x
         sta   <P$IOQN,y
         lda   ,y
         sta   <P$IOQP,x
         ldx   #$0000
         os9   F$Sleep  
         ldu   D.Proc
         lda   <P$IOQP,u
         beq   L06E0
         ldx   D.PrcDBT
         os9   F$Find64 
         bcs   L06E0
         lda   <P$IOQN,y
         beq   L06E0
         lda   <P$IOQN,u
         sta   <P$IOQN,y
         beq   L06E0
         clr   <P$IOQN,u
         ldx   D.PrcDBT
         os9   F$Find64 
         bcs   L06E0
         lda   <P$IOQP,u
         sta   <P$IOQP,y
L06E0    clr   <P$IOQP,u
L06E3    rts   
         emod
eom      equ   *
