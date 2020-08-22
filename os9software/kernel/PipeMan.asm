 nam Pipe File Manager

* Copyright 1980 by Microware Systems Corp.,

* This source code is the proprietary confidential property of
* Microware Systems Corporation, and is provided to licensee
* solely  for documentation and educational purposes. Reproduction,
* publication, or distribution in any form to any party other than
* the licensee is strictly prohibited!

 ttl Module Header   
*********
*    Pipe File Manager
*
Type set FlMgr+Objct 
Revs set ReEnt+1
 mod PipeEnd,PipeNam,Type,Revs,PipeEnt,0
PipeNam fcs "PipeMan"
**********
* Revision History
*    edition 2    prehistoric
*    edition 3    03/15/83  Moved Seek label
*                           from Illegal Service Routines
*                           to No Action Service Routines

 fcb 3 edition number

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


PipeEnt equ *
 lbra Create
 lbra Open
 lbra MakDir
 lbra ChgDir
 lbra Delete
 lbra Seek
 lbra PRead
 lbra PWrite
 lbra PRdLn
 lbra PWrLn
 lbra Getstat
 lbra Putstat
 lbra Close

**************************************************
*
*     Illegal Service routines
*
Makdir equ *
ChgDir equ *
Delete equ *
 comb
 ldb #E$UnkSVC err: unknown service request
 rts 

**************************************************
*
*     No Action Service routines
*
GetStat equ *
PutStat equ *
Seek equ *
 clrb
 rts 
 page
**********
* Open - Pipe File Manager
*
Create equ *
Open equ *
 ldu PD.RGS,y
 ldx R$X,u
 pshs y
 ifeq level-1
 os9 F$PrsNam parse the device name
 bcs OpenErr branch if error
 lda -1,y
 else
 os9 F$PrsNam parse the device name
 bcs OpenErr branch if error
 ldx D.Proc
 ldb P$Task,x
 leax -1,y
 OS9 F$LDABX
 tsta
 endc
 bmi Open.A
 leax  0,y
 os9   F$PrsNam 
 bcc   OpenErr
Open.A    sty   R$X,u
 puls  y
 ldd   #$0100
 ifeq level-1
 os9 F$SRqMem get buffer
 else
 os9 F$SRqMem get buffer
 endc
 bcs   Open.B
 stu   PD.BUF,y
 stu   PD.NxIn,y
 stu   PD.NxOut,y
 leau  d,u
 stu   PD.BEnd,y
Open.B    rts 

OpenErr comb
 ldb   #E$BPNam
 puls  pc,y
 page
**************************************************
*
Close    lda   PD.CNT,y
         bne   Clos.A
         ldu   PD.BUF,y
         ldd   #$0100
         os9   F$SRtMem 
         bra   Send.A
Clos.A    cmpa  PD.NRead,y  $0B
         bne   Clos.B
         leax  PD.FST,y
         bra   SendSign
Clos.B    cmpa  PD.NWrit,y
         bne   Send.A
         leax  PD.FWrit,y
SendSign    lda   PD.FRead-PD.FST,x
         beq   Send.A
         ldb   PD.WRead-PD.FST,x
         beq   Send.A
         clr   PD.WRead-PD.FST,x
         os9   F$Send 
Send.A    clrb
         rts 
 page
**************************************************
*
PRdLn    ldb   #$0D
         stb   PD.RdLn,y
         bra   Read

PRead    clr   PD.RdLn,y
Read    leax  PD.FST,y
         lbsr  GetCon
         bcs   Read.G
         ldd   $06,u
         beq   Read.G
         ldx   R$X,u
         addd  R$X,u
         pshs  d
         bra   Read.C
Read.A    pshs  x
         leax  PD.FST,y
         lbsr  Wait
 ifeq level-1
         puls  x
         bcs   Read.E
 else
 jmp NOWHERE
 endc
Read.C    lbsr  BuffOut
         bcs   Read.A
 ifeq level-1
         sta   ,x+
 else
 OS9 F$STABX transfer byte
 leax 1,x move ptr
 endc
         tst   PD.RdLn,y
         beq   Read.D
         cmpa  PD.RdLn,y
         beq   Read.E
Read.D    cmpx  ,s
         bcs   Read.C
Read.E    tfr   x,d
         subd  ,s++
         addd  $06,u
         std   $06,u
         bne   Read.F
         ldb   #E$EOF
         bra   Read.G
Read.F    clrb
Read.G    leax  PD.FST,y
         lbra  RelCon
 page
**************************************************
*
PWrLn    ldb   #$0D
         stb   PD.WrLn,y
         bra   Write

PWrite   clr   PD.WrLn,y
Write    leax  PD.FWrit,y
         lbsr  GetCon
         bcs   L013C
         ldd   $06,u
         beq   L013C
         ldx   $04,u
         addd  $04,u
         pshs  b,a
         bra   L0118
Writ.A    pshs  x
         leax  PD.FWrit,y
         lbsr  Wait
         puls  x
         bcs   L0130
L0118    lda   ,x
         lbsr  BuffIn
         bcs   Writ.A
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
         bra   RelCon
 page
**************************************************
*
GetCon    lda   ,x
         beq   GetC.B
         cmpa  $05,y
         beq   GetC.C
         inc   $01,x
         ldb   $01,x
         cmpb  $02,y
         bne   GetC.A
         lbsr  SendSign
GetC.A    os9   F$IOQu 
         dec   $01,x
         pshs  x
         ldx   D.Proc
         ldb   P$Signal,x
         puls  x
         beq   GetCon
         coma
         rts 

GetC.B    ldb   $05,y
         stb   0,x
GetC.C    clrb
         rts 
 page
**************************************************
*
Wait    ldb   $01,x
         incb
         cmpb  $02,y
         beq   Wait.A
         stb   $01,x
         ldb   #$01
         stb   $02,x
         clr   $05,y
         pshs  x
         tfr   x,d
         eorb  #$04
         tfr   d,x
         lbsr  SendSign
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

Wait.A equ *
 ldb   #E$Write
L019B    coma
         rts 

**************************************************
*
RelCon    pshs  u,b,cc
         ldu   D.Proc
         lda   <$11,u
         bne   L01AA
         ldb   $01,x
         bne   RelC.B
L01AA    sta   ,x
         tfr   x,d
         eorb  #$04
         tfr   d,x
         lbsr  SendSign
RelC.B    puls  pc,u,b,cc

 page
**************************************************
*
BuffIn    pshs  x,b
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

BuffOut lda   PD.Data,y
         bne   BufO.A
         comb
         rts 
BufO.A    pshs  x
         ldx   PD.NxOut,y
         lda   ,x+
         cmpx  PD.BEnd,y
         bcs   BufO.B
         ldx   PD.BUF,y
BufO.B    stx   PD.NxOut,y
         cmpx  PD.NxIn,y
         bne   BufO.C
         clr   PD.Data,y
BufO.C    andcc #$FE
         puls  pc,x

         emod
PipeEnd      equ   *
