         nam   Procs
         ttl   program module       

* General procedure
* Disable interrupts
* Copy the processes
* Enable interrupts
* Print them out


 use defsfile

tylg     set   Prgrm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
showall  rmb   1
AProcQ   rmb   2
WProcQ   rmb   2
SProcQ   rmb   2
act.uid  rmb   2
u0009    rmb   1
bufend   rmb   2
outbuf   rmb   88
u0064    rmb   132
u00E8    rmb   2155
proctbl  rmb   9*50        Space for 50 processes
size     equ   .
name     equ   *

priocol  equ   3
statecol equ   4

         fcs   /Procs/
         fcb   $08 
header   fcb   $0A 
 ifeq Screen-small
         fcc   "Usr #  id pty sta mem pri mod"
         fcb   $0D 
dashes   fcs   "----- --- --- --- --- -------"
L004F    fcs   " act "
L0054    fcs   " wai "
L0059    fcs   " sle "
 else
         fcc   "Usr #  id pty  state   mem primary module"
         fcb   $0D 
dashes   fcs   "----- --- --- -------- --- --------------"
L004F    fcs   "  active  " 
L0054    fcs   "  waiting " 
L0059    fcs   " sleeping "
 endc

start    equ   *
         clr   showall
         lda   ,x+
         eora  #'E
         anda  #$DF
         bne   L006A
         inc   showall
L006A    leax  outbuf,u
         stx   <bufend
         orcc  #IntMasks       Block I and F interrupts
         ldx   >D.AProcQ     $004D
         stx   <AProcQ
         ldx   >D.WProcQ   $004F
         stx   <WProcQ
         ldx   >D.SProcQ   $0051
         stx   <SProcQ
         ldx   >D.Proc   $004B
         ldd   $09,x
         std   <act.uid      Active User id
         pshs  u
         leau  >proctbl,u
         lda   #$01
         ldx   <AProcQ
         lbsr  ReadPDs
         lda   #$02
         ldx   <WProcQ
         lbsr  ReadPDs
         lda   #$03
         ldx   <SProcQ
         lbsr  ReadPDs
         andcc #^IntMasks       Allow I and F interrupts
         clra  
         clrb  
         pshu  b,a       Push two zero bytes on U
         pshu  b,a       Push two more zero bytes on U
         puls  u
         leay  >header,pcr
         bsr   CopyStr
         bsr   writeln
         leay  >dashes,pcr
         bsr   CopyStr
         bsr   writeln
         leax  >proctbl,u
L00BF    leax  -$09,x
         ldd   $05,x
         beq   goodexit
         ldd   $07,x
         lbsr  L0166
         lbsr  WrtSpace
         ldb   ,x
         bsr   L012A
         lbsr  WrtSpace
         ldb   priocol,x       read priority
         bsr   L012A
         lda   statecol,x       read state
         leay  >L004F,pcr   
         cmpa  #$01        state = 1 (act)
         beq   L00EE
         leay  >L0054,pcr
         cmpa  #$02        state = 2 (wai)
         beq   L00EE
         leay  >L0059,pcr  state = other (sle)
L00EE    bsr   CopyStr
         ldb   $02,x       read page count
         bsr   L012A
         lbsr  WrtSpace
         ldy   $05,x
 ifeq Screen-small
 else
         ldd   $04,y
         leay  d,y
         bsr   CopyStr
         bsr   WrtSpace
         lda   #'<
         bsr   addtobuf
         lda   $01,x
         lbsr  L0209
         bcs   L0140
         ldy   $03,y
         ldy   $04,y
 endc
         ldd   $04,y
         leay  d,y
         bsr   CopyStr
 ifeq Screen-small
         bsr   WrtSpace
 endc
L0140    bsr   writeln
         bra   L00BF

goodexit clrb  
         os9   F$Exit   

* Copy signed string
CopyStr  lda   ,y
         anda  #$7F
         bsr   addtobuf
         lda   ,y+
         bpl   CopyStr
         rts   

* Write line out
writeln    pshs  y,x,a
         lda   #$0D
         bsr   addtobuf
         leax  outbuf,u
         stx   <bufend
         ldy   #$0050
         lda   #$01
         os9   I$WritLn 
         puls  pc,y,x,a

* Convert value in B to numeric string
L012A    clr   <u0009
         lda   #$FF
L012E    inca  
         subb  #100
         bcc   L012E
         bsr   L0144
         lda   #10
L0137    deca  
         addb  #10
         bcc   L0137
         bsr   L0144
         tfr   b,a
         adda  #'0
         bra   addtobuf
L0144    tsta  
         beq   L0149
         sta   <u0009
L0149    tst   <u0009
         bne   L014F
WrtSpace lda   #$F0
L014F    adda  #'0

* Copy one character in A to buffer
addtobuf pshs  x
         ldx   <bufend
         sta   ,x+
         stx   <bufend
         puls  pc,x

L015B    fdb 10000,1000,100,10,1
         fcb $ff

* Convert value in D to numeric string
L0166    pshs  y,x,b,a
         leax  <L015B,pcr
         ldy   #$2F20
L016F    leay  >$0100,y
         subd  ,x
         bcc   L016F
         addd  ,x++
         pshs  b,a
         tfr   y,d
         tst   ,x
         bmi   L0197
         ldy   #$2F30
         cmpd  #$3020
         bne   L0191
         ldy   #$2F20
         lda   #$20
L0191    bsr   addtobuf
         puls  b,a
         bra   L016F
L0197    bsr   addtobuf
         leas  $02,s
         puls  pc,y,x,b,a

* Read a process descriptor chain and puts the values on U stack
* |User 2|Module 2|State 1|Prior 1|PagCnt 1|Path #0 1|Procid 1|
* A record is 9 bytes
ReadPDs  pshs  y,b,a
         leax  ,x
         beq   L01C9
L01A3    ldd   P$User,x
         tst   showall
         bne   L01AE
         cmpd  act.uid    Same as active user?
         bne   L01C5
L01AE    pshu  b,a
         lda   P$Prior,x      * $0B
         ldb   ,s             * state
         ldy   P$PModul,x      * $12
         pshu  y,b,a
         lda   P$PagCnt,x
         pshu  a
         lda   P$ID,x        * $00
         ldb   P$PATH,x      * $26
         pshu  b,a
L01C5    ldx   P$Queue,x   * next prtr
         bne   L01A3
L01C9    puls  pc,y,b,a

L0209    pshs  x,b,a
         ldx   >$0064
         tsta  
         beq   L01E2
         clrb  
         lsra  
         rorb  
         lsra  
         rorb  
         lda   a,x
         tfr   d,y
         beq   L01E2
         tst   ,y
         bne   L01E3
L01E2    coma  
L01E3    puls  pc,x,b,a
         emod
eom      equ   *
