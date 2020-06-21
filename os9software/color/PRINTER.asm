         nam   PRINTER
         ttl   os9 device driver

   use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,PENT,size

pia1a    equ   $FF20
pia1b    equ   $FF22

**********
* Static storage offsets
*
 org V.SCF room for scf variables
u001D    rmb   2

size     equ   .
         fcb   READ.+WRITE.
name     equ   *
         fcs   /PRINTER/
         fcb   $01 Revision

PENT     lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TERM
**************
* INIT
INIT    pshs  cc
         orcc  #IntMasks
         ldx   #pia1a
         clr   $01,x
         lda   #$FE
         sta   ,x
         lda   #$36
         sta   $01,x
         lda   ,x
         puls  cc
         clrb
         rts
**************
* READ
*   This module doesn't do reads
*
READ    pshs  a
         bra   L0058

L0043    pshs  a
         lda   <PD.BAU,y
         cmpa  #$07
         bcc   L0058
         lsla
         leax  <L005F,pcr
         ldd   a,x
         std   <u001D,u
         clrb
         puls  pc,a
L0058    ldb   #$CB
         puls  a
L005C    orcc  #$01
         rts

* Delays
L005F    fcb $04,$85
         fcb $01,$A5
         fcb $00,$D0
         fcb $00,$66
         fcb $00,$30
         fcb $00,$16
         fcb $00,$08

L006D    pshs  b,a
         ldd   <u001D,u
         bra   L007B

         pshs  b,a
         ldd   <u001D,u
         lsra
         rorb
L007B    subd  #$0001
         bne   L007B
         puls  pc,b,a

**************
* WRITE
*
WRITE    bsr   L0043
         bcs   L005C
         pshs  b,a
L0088    ldb   #$03
L008A    lda   >pia1b
         lsra
         bcs   L0088
         bsr   L006D
         decb
         bne   L008A
         puls  b,a
         ldb   #$09
         pshs  b,cc
         orcc  #$50
         andcc #$FE
L009F    ldb   #$02
         bcs   L00A4
         clrb
L00A4    stb   >pia1a
         bsr   L006D
         lsra
         dec   $01,s
         bne   L009F
         ldb   #$02
         stb   >pia1a
         bsr   L006D
         puls  pc,b,cc

**************
* GETSTA
*
GETSTA    cmpa  #SS.Ready
         bne   chkeof
allok    clrb
         rts
chkeof    cmpa  #SS.EOF
         beq   allok
**************
* PUTSTA
*
PUTSTA    comb
         ldb   #E$UnkSvc
         rts
**************
* TERM
*   Terminate driver
*
TERM    rts
         emod
eom      equ   *
