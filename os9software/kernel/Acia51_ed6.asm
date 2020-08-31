 nam ACIA51
 ttl Interrupt-Driven Acia driver for Rockwell 6551

*
* Device driver from Dragon 128 (Level 2)
*
 use defsfile

***************
* Interrupt-driven Acia Device Driver

INPSIZ set 80 input  buffer size (<=256)
OUTSIZ set 140 output buffer size (<=256)

tylg     set   Drivr+Objct   
atrv     set   ReEnt+rev
rev      set   $01
         mod   ACIEND,ACINAM,tylg,atrv,ACIENT,ACIMEM


**********
* Static storage offsets
*
 org V.SCF room for scf variables
INXTI    rmb   1
INXTO    rmb   1
INCNT    rmb   1
ONXTI    rmb   1
ONXTO    rmb   1
HALTED    rmb   1
INHALT    rmb   1
RDYSGNL    rmb   2
ERRSTAT    rmb   1
INPBUF    rmb   INPSIZ
OUTBUF    rmb   OUTSIZ
ACIMEM     equ   .

* HALTED state conditions
H.XOFF equ 1 V.XOFF char has been received; awaiting V.XON
H.EMPTY equ 2 Output buffer is empty

 fcb UPDAT.
ACINAM fcs "ACIA51"
         fcb  6 

ACIENT    equ   *
         lbra  INIT
         lbra  READ
         lbra  WRITE
         lbra  GETSTA
         lbra  PUTSTA
         lbra  TRMNAT

ACMASK   fcb $00,$80,$0A

INIT ldx V.PORT,U I/o port address
         stb   $01,x
         ldb   #$02
         stb   <HALTED,u
         ldd   <$26,y
         lbsr  L016B
         lda   ,x
         lda   ,x
         tst   $01,x
         bmi   L00BC
         clra  
         clrb  
         std   <INXTI,u
         std   <ONXTI,u
         sta   <INHALT,u
         sta   <INCNT,u
         std   <RDYSGNL,u
         ldd   V.PORT,u
         addd  #$0001
         leax  >ACMASK,pcr
         leay  >ACIRQ,pcr
         os9   F$IRQ    
         bcs   INIT9
         ldx   V.PORT,u
         ldb   V.TYPE,u
         orb   #$09
         stb   $02,x
         clrb  
INIT9    rts   

READ00    bsr   ACSLEP
READ    lda   <INHALT,u
         ble   L008B
         ldb   <INCNT,u
         cmpb  #$0A
         bhi   L008B
         ldb   V.XON,u
         orb   #$80
         stb   <INHALT,u
         ldb   V.TYPE,u
         orb   #$05
         ldx   V.PORT,u
         stb   $02,x
L008B    tst   <RDYSGNL,u
         bne   L00BC
         ldb   <INXTO,u
         leax  <INPBUF,u
         orcc  #$50
         cmpb  <INXTI,u
         beq   READ00
         abx   
         lda   ,x
         dec   <INCNT,u
         incb  
         cmpb  #$4F
         bls   L00A9
         clrb  
L00A9    stb   <INXTO,u
         clrb  
         ldb   V.ERR,u
         beq   L00B9
         stb   <$3C,y
         clr   V.ERR,u
         comb  
         ldb   #$F4
L00B9    andcc #$AF
         rts   

L00BC    comb  
         ldb   #$F6
         rts   

**********
* Acslep - Sleep for I/O activity

ACSLEP    pshs  x,b,a
         lda   D.Proc
         sta   V.Wake,u
         ldx   D.Proc
         lda P$State,x
         ora   #Suspend
         sta P$State,x
         andcc #^IntMasks
         ldx   #1
         os9   F$Sleep  
         ldx   D.Proc
         ldb   <$19,x
         beq   ACSL90
         cmpb  #$03
         bls   ACSLER
ACSL90    clra  
         lda   $0C,x
         bita  #$02
         bne   ACSLER
         puls  pc,x,b,a

ACSLER    leas  $06,s
         coma  
         rts   

WRIT00    bsr   ACSLEP
WRITE    leax  <OUTBUF,u
         ldb   <ONXTI,u
         abx   
         sta   ,x
         incb  
         cmpb  #$8B
         bls   WRIT10
         clrb  
WRIT10    orcc  #$50
         cmpb  <ONXTO,u
         beq   WRIT00
         stb   <ONXTI,u
         lda   <HALTED,u
         beq   Write80
         anda  #$FD
         sta   <HALTED,u
         bne   Write80
         lda   V.TYPE,u
         ora   #$05
         ldx   V.PORT,u
         sta   $02,x
Write80    andcc #$AF
Write90    clrb  
         rts   

GETSTA    cmpa  #$01
         bne   GETS10
         ldb   <INCNT,u
         beq   L00BC
         ldx   $06,y
         stb   $02,x
L012E    clrb  
         rts   

GETS10    cmpa  #$06
         beq   Write90

L0134    comb  
         ldb   #$D0
         rts   

PUTSTA    cmpa  #$1A
         bne   L0153
         lda   $05,y
         ldx   $06,y
         ldb   $05,x
         orcc  #$50
         tst   <INCNT,u
         bne   L014E
         std   <RDYSGNL,u
         bra   Write80

L014E    andcc #$AF
         lbra  SendSig

L0153    cmpa  #$1B
         beq   L0160
         cmpa  #$1F
         bne   L0134
         ldd   <$34,y
         bra   L016B
L0160    lda   $05,y
         cmpa  <RDYSGNL,u
         bne   L012E
         clr   <RDYSGNL,u
         rts   
L016B    pshs  x
         andb  #$07
         leax  >BAUDTBL,pcr
         ldb   b,x
         pshs  b
         tfr   a,b
         lslb  
         lslb  
         lslb  
         lslb  
         orb   ,s+
         anda  #$E0
         pshs  cc
         pshs  a
         orcc  #$50
         sta   V.TYPE,u
         ldx   V.PORT,u
         lda   $02,x
         anda  #$0F
         ora   ,s+
         std   $02,x
         puls  x,cc
         clrb  
         rts   

BAUDTBL  fcb   $13        110 baud
         fcb   $16        300 baud
         fcb   $17        600 baud
         fcb   $18       1200 baud
         fcb   $1A       2400 baud
         fcb   $1C       4800 baud
         fcb   $1E       9600 baud
         fcb   $1F      19200 baud

TRMN00    lbsr  ACSLEP
TRMNAT    ldx   D.Proc
         lda   ,x
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldb   <ONXTI,u
         orcc  #$50
         cmpb  ONXTO,u
         bne   TRMN00
         lda   V.TYPE,u
         ora   #$08
         ldx   V.PORT,u
         sta   $02,x
         andcc #$AF
         ldx   #0
         os9   F$IRQ    
         rts   

ACIRQ    ldx   V.PORT,u
         tfr   a,b
         andb  #$44
         cmpb  <ERRSTAT,u
         beq   OutIRQ
         stb   <ERRSTAT,u
         bitb  #$44
         lbne  InXOFF
         lbra  InXON

OutIRQ    bita  #$08
         bne   L0232
         lda   <INHALT,u
         bpl   L01F5
         anda  #$7F
         sta   ,x
         eora  V.XON,u
         sta   <INHALT,u
         lda   <HALTED,u
         bne   L021B
         clrb  
         rts   
L01F5    leay  <OUTBUF,u
         ldb   <ONXTO,u
         cmpb  <ONXTI,u
         beq   OutIRQ2
         clra  
         lda   d,y
         incb  
         cmpb  #$8B
         bls   L0209
         clrb  
L0209    stb   <ONXTO,u
         sta   ,x
         cmpb  <ONXTI,u
         bne   WAKEUP
OutIRQ2    lda   <HALTED,u
         ora   #$02
         sta   <HALTED,u
L021B    ldb   V.TYPE,u
         orb   #$09
         stb   $02,x
WAKEUP    lda   V.Wake,u
         beq   L0230
         clrb  
         stb   V.Wake,u
         tfr   d,x
         lda   $0C,x
         anda  #$F7
         sta   $0C,x
L0230    clrb  
         rts   

L0232    anda  #$07
         beq   InIRQ0
         ldb   ,x
         ora   V.ERR,u
         sta   V.ERR,u
         bra   L0230

InIRQ0    lda   ,x
         beq   InIRQ1
         cmpa  V.INTR,u
         beq   InAbort
         cmpa  V.QUIT,u
         beq   InQuit
         cmpa  V.PCHR,u
         beq   InPause
         cmpa  V.XON,u
         beq   InXON
         cmpa  <V.XOFF,u
         lbeq  InXOFF

InIRQ1    leax  <INPBUF,u
         ldb   <INXTI,u
         abx   
         sta   ,x
         incb  
         cmpb  #$4F
         bls   L0268
         clrb  
L0268    cmpb  <INXTO,u
         bne   L0275
         ldb   #$04
         orb   V.ERR,u
         stb   V.ERR,u
         bra   WAKEUP

L0275    stb   <INXTI,u
         inc   <INCNT,u
         tst   <RDYSGNL,u
         beq   InIRQ4
         ldd   <RDYSGNL,u
         clr   <RDYSGNL,u
SendSig    os9   F$Send   
         clrb  
         rts   

InIRQ4    lda   <V.XOFF,u
         beq   WAKEUP
         ldb   <INCNT,u
         cmpb  #$46
         bcs   WAKEUP
         ldb   <INHALT,u
         bne   WAKEUP
         anda  #$7F
         sta   <V.XOFF,u
         ora   #$80
         sta   <INHALT,u
         ldb   V.TYPE,u
         orb   #$05
         ldx   V.PORT,u
         stb   $02,x
         lbra  WAKEUP

InPause    ldx   V.DEV2,u
         beq   InIRQ1
         sta   $08,x
         bra   InIRQ1

InAbort    ldb   #$03
         bra   InQuit10

InQuit    ldb   #$02
InQuit10    pshs  a
         lda   V.LPRC,u
         beq   L02C9
         clr   V.Wake,u
         bsr   SendSig
L02C9    puls  a
         bra   InIRQ1

InXON    lda   <HALTED,u
         anda  #$FE
         sta   <HALTED,u
         bne   L02DD
         lda   V.TYPE,u
         ora   #$05
         sta   $02,x
L02DD    clrb  
         rts   

InXOFF    lda   <HALTED,u
         bne   L02EA
         ldb   V.TYPE,u
         orb   #$09
         stb   $02,x
L02EA    ora   #$01
         sta   <HALTED,u
         clrb  
         rts   
         emod
ACIEND      equ   *
