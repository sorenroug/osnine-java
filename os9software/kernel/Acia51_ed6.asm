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
u001E    rmb   1
INCNT    rmb   1
ONXTI    rmb   1
ONXTO    rmb   1
HALTED    rmb   1
INHALT    rmb   1
RDYSGNL    rmb   2
ERRSTAT    rmb   1
INPBUF    rmb   41
u0050    rmb   39
OUTBUF    rmb   9
u0080    rmb   46
u00AE    rmb   85
ACIMEM     equ   .

* HALTED state conditions
H.XOFF equ 1 V.XOFF char has been received; awaiting V.XON
H.EMPTY equ 2 Output buffer is empty

 fcb UPDAT.
ACINAM fcs "ACIA51"
         fcb   $06 

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
         bcs   L006D
         ldx   V.PORT,u
         ldb   V.TYPE,u
         orb   #$09
         stb   $02,x
         clrb  
L006D    rts   

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
         ldb   <u001E,u
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
L00A9    stb   <u001E,u
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

ACSLEP    pshs  x,b,a
         lda   <u0050
         sta   V.Wake,u
         ldx   <u0050
         lda   $0C,x
         ora   #$08
         sta   $0C,x
         andcc #$AF
         ldx   #$0001
         os9   F$Sleep  
         ldx   <u0050
         ldb   <$19,x
         beq   L00E1
         cmpb  #$03
         bls   L00EA
L00E1    clra  
         lda   $0C,x
         bita  #$02
         bne   L00EA
         puls  pc,x,b,a

L00EA    leas  $06,s
         coma  
         rts   

L00EE    bsr   ACSLEP
WRITE    leax  <OUTBUF,u
         ldb   <ONXTI,u
         abx   
         sta   ,x
         incb  
         cmpb  #$8B
         bls   L00FF
         clrb  
L00FF    orcc  #$50
         cmpb  <ONXTO,u
         beq   L00EE
         stb   <ONXTI,u
         lda   <HALTED,u
         beq   L011D
         anda  #$FD
         sta   <HALTED,u
         bne   L011D
         lda   V.TYPE,u
         ora   #$05
         ldx   V.PORT,u
         sta   $02,x
L011D    andcc #$AF
L011F    clrb  
         rts   

GETSTA    cmpa  #$01
         bne   L0130
         ldb   <INCNT,u
         beq   L00BC
         ldx   $06,y
         stb   $02,x
L012E    clrb  
         rts   
L0130    cmpa  #$06
         beq   L011F
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
         bra   L011D
L014E    andcc #$AF
         lbra  L0286
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
TRMNAT    ldx   <u0050
         lda   ,x
         sta   V.BUSY,u
         sta   V.LPRC,u
         ldb   <ONXTI,u
         orcc  #$50
         cmpb  <ONXTO,u
         bne   TRMN00
         lda   V.TYPE,u
         ora   #$08
         ldx   V.PORT,u
         sta   $02,x
         andcc #$AF
         ldx   #$0000
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
         beq   L0259
         cmpa  V.INTR,u
         beq   InAbort
         cmpa  V.QUIT,u
         beq   InQuit
         cmpa  V.PCHR,u
         beq   L02B1
         cmpa  V.XON,u
         beq   InXON
         cmpa  <V.XOFF,u
         lbeq  InXOFF

L0259    leax  <INPBUF,u
         ldb   <INXTI,u
         abx   
         sta   ,x
         incb  
         cmpb  #$4F
         bls   L0268
         clrb  
L0268    cmpb  <u001E,u
         bne   L0275
         ldb   #$04
         orb   V.ERR,u
         stb   V.ERR,u
         bra   WAKEUP
L0275    stb   <INXTI,u
         inc   <INCNT,u
         tst   <RDYSGNL,u
         beq   L028B
         ldd   <RDYSGNL,u
         clr   <RDYSGNL,u
L0286    os9   F$Send   
         clrb  
         rts   

L028B    lda   <V.XOFF,u
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

L02B1    ldx   V.DEV2,u
         beq   L0259
         sta   $08,x
         bra   L0259

InAbort    ldb   #$03
         bra   InQuit10

InQuit    ldb   #$02
InQuit10    pshs  a
         lda   V.LPRC,u
         beq   L02C9
         clr   V.Wake,u
         bsr   L0286
L02C9    puls  a
         bra   L0259

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
