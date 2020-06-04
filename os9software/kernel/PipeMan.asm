         nam   PipeMan
         ttl   os9 file manager   
*
*    Pipe File Manager
*


Type set FlMgr+Objct 
Revs set ReEnt+1
 mod   PipeEnd,PipeNam,Type,Revs,PipeEnt,0

PipeNam fcs "PipeMan"
**********
* Revision History
*    edition 2    prehistoric
*    edition 3    03/15/83  Moved Seek label
*                           from Illegal Service Routines
*                           to No Action Service Routines

 fcb   3 edition number

**********
*
*     Definitions
*
 use defsfile

 org PD.FST
PD.FRead rmb 1 Process ID of first reader waiting
PD.NRead rmb 1 number of readers waiting
PD.WRead rmb 1 wake-up reader flag
PD.RdLn rmb 1 readln flag
PD.FWrit rmb 1 Process ID of first write waiting
PD.NWrit rmb 1 number of writers waiting
PD.WWrit rmb 1 wake-up writer flag
PD.WrLn rmb 1 writln flag
PD.BEnd rmb 2 buffer end
PD.NxIn rmb 2 next-in ptr
PD.NxOut rmb 2 next-out ptr
PD.Data rmb 1 data in buffer flag
 org 0
First rmb 1
Waiting rmb 1
Signal rmb 1
RWSwitch equ (PD.FRead!PD.FWrit)-(PD.FRead&PD.FWrit)


PipeEnt  equ   *
         lbra  POpen     Create
         lbra  POpen     Open
         lbra  UnkSvc    MakDir
         lbra  UnkSvc    ChgDir
         lbra  UnkSvc    Delete
         lbra  NoOp      Seek
         lbra  PRead
         lbra  PWrite
         lbra  PRdLn
         lbra  PWrLn
         lbra  NoOp
         lbra  NoOp
         lbra  Close

UnkSvc   comb
         ldb   #E$UnkSVC
         rts 

NoOp     clrb
         rts 

POpen    ldu   PD.RGS,y
         ldx   R$X,u
         pshs  y
         os9   F$PrsNam 
         bcs   L0073
         lda   -1,y
         bmi   L0058
         leax  0,y
         os9   F$PrsNam 
         bcc   L0073
L0058    sty   R$X,u
         puls  y
         ldd   #$0100
         os9   F$SRqMem 
         bcs   L0072
         stu   PD.BUF,y
         stu   PD.NxIn,y
         stu   PD.NxOut,y
         leau  d,u
         stu   PD.BEnd,y
L0072    rts 

L0073    comb
         ldb   #E$BPNam
         puls  pc,y

Close    lda   PD.CNT,y
         bne   L0086
         ldu   PD.BUF,y
         ldd   #$0100
         os9   F$SRtMem 
         bra   L00A1
L0086    cmpa  PD.NRead,y  $0B
         bne   L008E
         leax  PD.FST,y
         bra   L0094
L008E    cmpa  PD.NWrit,y
         bne   L00A1
         leax  PD.FWrit,y
L0094    lda   PD.FRead-PD.FST,x
         beq   L00A1
         ldb   PD.WRead-PD.FST,x
         beq   L00A1
         clr   PD.WRead-PD.FST,x
         os9   F$Send 
L00A1    clrb
         rts 

PRdLn    ldb   #$0D
         stb   PD.RdLn,y
         bra   L00AB

PRead    clr   PD.RdLn,y
L00AB    leax  PD.FST,y
         lbsr  L0140
         bcs   L00EB
         ldd   $06,u
         beq   L00EB
         ldx   $04,u
         addd  $04,u
         pshs  b,a
         bra   L00C9
L00BE    pshs  x
         leax  PD.FST,y
         lbsr  L016B
         puls  x
         bcs   L00DC
L00C9    lbsr  L01DD
         bcs   L00BE
         sta   ,x+
         tst   PD.RdLn,y
         beq   L00D8
         cmpa  PD.RdLn,y
         beq   L00DC
L00D8    cmpx  ,s
         bcs   L00C9
L00DC    tfr   x,d
         subd  ,s++
         addd  $06,u
         std   $06,u
         bne   L00EA
         ldb   #E$EOF
         bra   L00EB
L00EA    clrb
L00EB    leax  PD.FST,y
         lbra  L019D

PWrLn    ldb   #$0D
         stb   PD.WrLn,y
         bra   L00FA

PWrite   clr   PD.WrLn,y
L00FA    leax  PD.FWrit,y
         lbsr  L0140
         bcs   L013C
         ldd   $06,u
         beq   L013C
         ldx   $04,u
         addd  $04,u
         pshs  b,a
         bra   L0118
L010D    pshs  x
         leax  PD.FWrit,y
         lbsr  L016B
         puls  x
         bcs   L0130
L0118    lda   ,x
         lbsr  L01B7
         bcs   L010D
         leax  $01,x
         tst   PD.WrLn,y
         beq   L012B
         cmpa  PD.WrLn,y
         beq   L0130
L012B    cmpx  ,s
         bcs   L0118
         clrb
L0130    pshs  b,cc
         tfr   x,d
         subd  $02,s
         addd  $06,u
         std   $06,u
         puls  x,b,cc
L013C    leax  PD.FWrit,y
         bra   L019D
L0140    lda   ,x
         beq   L0165
         cmpa  $05,y
         beq   L0169
         inc   $01,x
         ldb   $01,x
         cmpb  $02,y
         bne   L0153
         lbsr  L0094
L0153    os9   F$IOQu 
         dec   $01,x
         pshs  x
         ldx   D.Proc
         ldb   P$Signal,x
         puls  x
         beq   L0140
         coma
         rts 

L0165    ldb   $05,y
         stb   0,x
L0169    clrb
         rts 

L016B    ldb   $01,x
         incb
         cmpb  $02,y
         beq   L0199
         stb   $01,x
         ldb   #$01
         stb   $02,x
         clr   $05,y
         pshs  x
         tfr   x,d
         eorb  #$04
         tfr   d,x
         lbsr  L0094
         ldx   #$0000
         os9   F$Sleep
         ldx   D.Proc
         ldb   P$Signal,x
         puls  x
         dec   1,x
         tstb
         bne   L019B
         clrb
         rts 

L0199    ldb   #E$Write
L019B    coma
         rts 

L019D    pshs  u,b,cc
         ldu   D.Proc
         lda   <$11,u
         bne   L01AA
         ldb   $01,x
         bne   L01B5
L01AA    sta   ,x
         tfr   x,d
         eorb  #$04
         tfr   d,x
         lbsr  L0094
L01B5    puls  pc,u,b,cc

L01B7    pshs  x,b
         ldx   PD.NxIn,y
         ldb   PD.Data,y
         beq   L01C9
         cmpx  PD.NxOut,y
         bne   L01CE
         comb
         puls  pc,x,b

L01C9    ldb   #$01
         stb   PD.Data,y
L01CE    sta   ,x+
         cmpx  PD.BEnd,y
         bcs   L01D7
         ldx   PD.BUF,y
L01D7    stx   PD.NxIn,y
         clrb
         puls  pc,x,b

L01DD    lda   PD.Data,y
         bne   L01E4
         comb
         rts 

L01E4    pshs  x
         ldx   PD.NxOut,y
         lda   ,x+
         cmpx  PD.BEnd,y
         bcs   L01F2
         ldx   PD.BUF,y
L01F2    stx   PD.NxOut,y
         cmpx  PD.NxIn,y
         bne   L01FD
         clr   PD.Data,y
L01FD    andcc #$FE
         puls  pc,x

         emod
PipeEnd      equ   *
