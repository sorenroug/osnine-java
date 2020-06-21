         nam   RS232
         ttl   os9 device driver

  use defsfile

tylg     set   Drivr+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size

pia1a    equ   $FF20
pia1b    equ   $FF22

**********
* Static storage offsets
*
 org V.SCF room for scf variables
u001D    rmb   2

size     equ   .
         fcb   $03
name     equ   *
         fcs   /RS232/
         fcb   $02

start    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TERM

INIT    pshs  cc
         orcc  #$50
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

READ    bsr   L006A
         bcs   L0083
         ldb   #$08
         pshs  b,cc
         bra   L004D
L0047    ldx   #$0001
         os9   F$Sleep
L004D    ldb   >pia1b
         andb  #$01
         bne   L0047
         orcc  #$50
         clra
         bsr   L009B
L0059    bsr   L0094
         ldb   >pia1b
         lsrb
         rora
         dec   $01,s
         bne   L0059
         bsr   L009B
         puls  b,cc
         clrb
         rts
L006A    pshs  a
         lda   <$35,y
         cmpa  #$07
         bcc   L007F
         lsla
         leax  <L0086,pcr
         ldd   a,x
         std   <u001D,u
         clrb
         puls  pc,a
L007F    ldb   #$CB
         puls  a
L0083    orcc  #$01
         rts

L0086    fcb $04,$85
         fcb $01,$A5
         fcb $00,$D0
         fcb $00,$66
         fcb $00,$30
         fcb $00,$16
         fcb $00,$08

L0094    pshs  b,a
         ldd   <u001D,u
         bra   L00A2
L009B    pshs  b,a
         ldd   <u001D,u
         lsra
         rorb
L00A2    subd  #$0001
         bne   L00A2
         puls  pc,b,a
**************
* WRITE
*
WRITE    bsr   L006A
         bcs   L0083
         ldb   #$09
         pshs  b,cc
         orcc  #$50
         andcc #$FE
L00B5    ldb   #$02
         bcs   L00BA
         clrb
L00BA    stb   >pia1a
         bsr   L0094
         lsra
         dec   $01,s
         bne   L00B5
         ldb   #$02
         stb   >pia1a
         bsr   L0094
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
