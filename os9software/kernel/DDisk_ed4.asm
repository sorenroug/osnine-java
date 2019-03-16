* From Eurohard OS9 l1 v2.0
* Header for : Ddisk
* Module size: $385  #901
* Module CRC : $DBA847 (Good)
* Hdr parity : $58
* Exec. off  : $0014  #20
* Data size  : $00B2  #178
* Edition    : $04  #4
* Ty/La At/Rv: $E1 $84
* Device Driver mod, 6809 Obj, re-ent, R/O

* Handles dual-sided disks

         nam   Ddisk
         ttl   os9 device driver    

         ifp1
         use   defsfile
         endc
tylg     set   Drivr+Objct   
atrv     set   ReEnt+rev
rev      set   $04
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   3
u0003    rmb   2
u0005    rmb   1
u0006    rmb   2
u0008    rmb   7
u000F    rmb   19
u0022    rmb   1
u0023    rmb   29
u0040    rmb   3
u0043    rmb   5
u0048    rmb   95
u00A7    rmb   2
u00A9    rmb   1
u00AA    rmb   1
u00AB    rmb   1
u00AC    rmb   1
u00AD    rmb   2
u00AF    rmb   1
u00B0    rmb   1
u00B1    rmb   1
size     equ   .
         fcb   $FF 
name     equ   *
         fcs   /Ddisk/
         fcb   $04 
start    equ   *
         lbra  L0026
         lbra  L006A
         lbra  L0123
         lbra  L0068
         lbra  L0305
         lbra  L0068
L0026    clra  
         sta   >$006F
         sta   >$FF48
         ldx   #$FF40
         lda   #$D0
         sta   ,x
         lbsr  L02FE
         lda   ,x
         lda   #$FF
         ldb   #$04
         leax  u000F,u
L003F    sta   ,x
         sta   <$15,x
         leax  <$26,x
         decb  
         bne   L003F
         leax  >L0173,pcr
         stx   >$010A
         lda   #$7E
         sta   >$0109
         ldd   #$0100
         pshs  u
         os9   F$SRqMem 
         tfr   u,x
         puls  u
         bcs   L0069
         stx   >u00AD,u
L0068    clrb  
L0069    rts   
L006A    lda   #$91
         cmpx  #$0000
         bne   L0093
         bsr   L0093
         bcs   L0069
         ldx   $08,y
         pshs  y,x
         ldy   >u00A7,u
         ldb   #$14
L0080    lda   b,x
         sta   b,y
         decb  
         bpl   L0080
         clrb  
         puls  pc,y,x
L008A    bcc   L0093
         pshs  x,b,a
         lbsr  L0343
         puls  x,b,a
L0093    pshs  x,b,a
         bsr   L009E
         puls  x,b,a
         bcc   L0069
         lsra  
         bne   L008A
L009E    lbsr  L01BD
         bcs   L0069
         ldx   $08,y
         pshs  y,dp,cc
         ldb   #$88
         orb   >u00B1,u
         bsr   L00C7
L00AF    lda   <u0023
         bmi   L00BF
         leay  -$01,y
         bne   L00AF
         bsr   L0108
         puls  y,dp,cc
         lbra  L02DB
L00BE    sync  
L00BF    lda   <u0043
         ldb   <u0022
         sta   ,x+
         bra   L00BE
L00C7    lda   #$FF
         tfr   a,dp
         lda   <u0006
         sta   >u00AC,u
         anda  #$FE
         sta   <u0006
         bita  #$40
         beq   L00DF
L00D9    lda   <u0005
         bita  #$10
         beq   L00D9
L00DF    orcc  #$50
         lda   <u0003
         sta   >u00AB,u
         lda   #$34
         sta   <u0003
         lda   <u0006
         anda  #$FE
         sta   <u0006
         lda   <u0023
         ora   #$03
         sta   <u0023
         lda   <u0022
         ldy   #$FFFF
         lda   #$24
         ora   >u00A9,u
         stb   <u0040
         sta   <u0048
         rts   
L0108    lda   >u00A9,u
         ora   #$04
         sta   <u0048
         lda   >u00AB,u
         sta   <u0003
         lda   <u0023
         anda  #$FC
         sta   <u0023
         lda   >u00AC,u
         sta   <u0006
         rts   
L0123    lda   #$91
L0125    pshs  x,b,a
         bsr   L0148
         puls  x,b,a
         bcs   L0138
         tst   <$28,y
         bne   L0136
         bsr   L0185
         bcs   L0138
L0136    clrb  
L0137    rts   
L0138    lsra  
         lbeq  L02D3
         bcc   L0125
         pshs  x,b,a
         lbsr  L0343
         puls  x,b,a
         bra   L0125
L0148    bsr   L01BD
         bcs   L0137
         ldx   $08,y
         pshs  y,dp,cc
         ldb   #$A8
L0152    orb   >u00B1,u
         lbsr  L00C7
         lda   ,x+
L015B    ldb   <u0023
         bmi   L016D
         leay  -$01,y
         bne   L015B
         bsr   L0108
         puls  y,dp,cc
         lbra  L02D3
L016A    lda   ,x+
         sync  
L016D    sta   <u0043
         ldb   <u0022
         bra   L016A
L0173    leas  $0C,s
         bsr   L0108
         puls  y,dp,cc
         ldb   >$FF40
         bitb  #$04
         lbne  L02DB
         lbra  L02AF
L0185    pshs  x,b,a
         ldx   $08,y
         pshs  x
         ldx   >u00AD,u
         stx   $08,y
         ldx   $04,s
         lbsr  L009E
         puls  x
         stx   $08,y
         bcs   L01BB
         lda   #$20
         pshs  u,y,a
         ldy   >u00AD,u
         tfr   x,u
L01A7    ldx   ,u
         cmpx  ,y
         bne   L01B7
         leau  u0008,u
         leay  $08,y
         dec   ,s
         bne   L01A7
         bra   L01B9
L01B7    orcc  #$01
L01B9    puls  u,y,a
L01BB    puls  pc,x,b,a
L01BD    clr   >u00AA,u
         clr   >u00B1,u
         lbsr  L0262
         tstb  
         bne   L01DC
         tfr   x,d
         ldx   >u00A7,u
         cmpd  #$0000
         beq   L0216
         cmpd  $01,x
         bcs   L01E0
L01DC    comb  
         ldb   #$F1
         rts   
L01E0    clr   ,-s
         bra   L01E9
L01E4    clrb  
         bra   L0202
L01E7    inc   ,s
L01E9    subd  #$0012
         bcc   L01E7
         addb  #$12
         lda   <$10,x
         bita  #$01
         puls  a
         beq   L0202
         lsra  
         rol   >u00B1,u
         lsl   >u00B1,u
L0202    cmpa  >u00B0,u
         bls   L0216
         pshs  a
         lda   >u00A9,u
         ora   #$10
         sta   >u00A9,u
         puls  a
L0216    incb  
L0217    stb   >$FF42
         lbsr  L02FE
         cmpb  >$FF42
         bne   L0217
         ldb   <$15,x
         tst   >u00AF,u
         beq   L022C
         lslb  
L022C    stb   >$FF41
         tst   >u00AA,u
         bne   L023A
         cmpa  <$15,x
         beq   L025A
L023A    sta   <$15,x
         tst   >u00AF,u
         beq   L0244
         lsla  
L0244    sta   >$FF43
         ldb   #$12
         orb   <$22,y
         lbsr  L02DF
         pshs  x
         ldx   #$222E
L0254    leax  -$01,x
         bne   L0254
         puls  x
L025A    lda   <$15,x
         sta   >$FF41
L0260    clrb  
         rts   
L0262    lda   <$21,y
         cmpa  #$04
         bcs   L026D
         comb  
         ldb   #$F0
         rts   
L026D    pshs  x,b,a
         sta   >u00A9,u
         lbsr  L0362
         leax  u000F,u
         ldb   #$26
         mul   
         leax  d,x
         cmpx  >u00A7,u
         beq   L028B
         stx   >u00A7,u
         com   >u00AA,u
L028B    lda   #$10
         sta   >u00B0,u
         lda   <$24,y
         anda  #$02
         sta   >u00AF,u
         beq   L02AD
         lda   <$10,x
         bita  #$04
         beq   L02AD
         clr   >u00AF,u
         lda   #$28
         sta   >u00B0,u
L02AD    puls  pc,x,b,a
L02AF    bitb  #$F8
         beq   L02C5
         bitb  #$80
         bne   L02CB
         bitb  #$40
         bne   L02CF
         bitb  #$20
         bne   L02D3
         bitb  #$10
         bne   L02D7
         bitb  #$08
L02C5    beq   L0260
         comb  
         ldb   #$F3
         rts   
L02CB    comb  
         ldb   #$F6
         rts   
L02CF    comb  
         ldb   #$F2
         rts   
L02D3    comb  
         ldb   #$F5
         rts   
L02D7    comb  
         ldb   #$F7
         rts   
L02DB    comb  
         ldb   #$F4
         rts   
L02DF    bsr   L02FC
L02E1    ldb   >$FF40
         bitb  #$01
         beq   L0304
         lda   #$F0
         sta   >$006F
         bra   L02E1
L02EF    lda   #$04
         ora   >u00A9,u
         sta   >$FF48
         stb   >$FF40
         rts   
L02FC    bsr   L02EF
L02FE    lbsr  L0301
L0301    lbsr  L0304
L0304    rts   
L0305    ldx   $06,y
         ldb   $02,x
         cmpb  #$03
         beq   L0343
         cmpb  #$04
         beq   L0315
         comb  
         ldb   #$D0
L0314    rts   
L0315    lbsr  L0262
         ldb   $07,x
         ldx   >u00A7,u
         stb   <$10,x
         andb  #$01
         lslb  
         stb   >u00B1,u
         lbsr  L0262
         ldx   $06,y
         lda   $09,x
         ldx   >u00A7,u
         lbsr  L01E4
         bcs   L0314
         ldx   $06,y
         ldx   $04,x
         ldb   #$F0
         pshs  y,dp,cc
         lbra  L0152
L0343    lbsr  L0262
         ldx   >u00A7,u
         clr   <$15,x
         lda   #$05
L034F    ldb   #$42
         pshs  a
         bsr   L035C
         puls  a
         deca  
         bne   L034F
         ldb   #$02
L035C    orb   <$22,y
         lbra  L02DF
L0362    pshs  x,b,a
         lda   >$006F
         bne   L037B
         lda   #$04
         ora   >u00A9,u
         sta   >$FF48
         ldx   #$A000
L0375    nop   
         nop   
         leax  -$01,x
         bne   L0375
L037B    lda   #$F0
         sta   >$006F
         puls  pc,x,b,a
         emod
eom      equ   *
