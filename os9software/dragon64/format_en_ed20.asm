* From Eurohard OS-9 L1 2.0 (English labels)

* Header for : Format
* Module size: $9BF  #2495
* Module CRC : $53BEDF (Good)
* Hdr parity : $9E
* Exec. off  : $0045  #69
* Data size  : $2B39  #11065
* Edition    : $14  #20
* Ty/La At/Rv: $11 $81
* Prog mod, 6809 Obj, re-ent, R/O

         nam   Format
         ttl   program module       

         ifp1
         use   defsfile
         endc
tylg     set   Prgrm+Objct   
atrv     set   ReEnt+rev
rev      set   $01
PAGE     equ   $0100
StdOut   equ   1

         mod   eom,name,tylg,atrv,start,size
F.Dma    rmb   2
F.Opn    rmb   1
F.Wtc    rmb   1
u0004    rmb   1
F.Fac    rmb   2
u0007    rmb   1
u0008    rmb   1
u0009    rmb   1
u000A    rmb   2
u000C    rmb   2
u000E    rmb   2
F.Bdn    rmb   1
u0011    rmb   1
F.Sid    rmb   1
u0013    rmb   2
u0015    rmb   1
u0016    rmb   1
u0017    rmb   1
u0018    rmb   1
u0019    rmb   2
u001B    rmb   1
u001C    rmb   1
F.Val    rmb   2
F.Ilv    rmb   1
F.Prm    rmb   1
u0021    rmb   1
F.Tot    rmb   3
F.Bit    rmb   1
u0026    rmb   1
u0027    rmb   1
u0028    rmb   1
u0029    rmb   1
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   2
F.Cnt    rmb   3
F.Bms    rmb   1
u0033    rmb   1
u0034    rmb   2
u0036    rmb   2
u0038    rmb   2
u003A    rmb   1
u003B    rmb   2
u003D    rmb   2
u003F    rmb   4
u0043    rmb   1
F.Dtb    rmb   2
u0046    rmb   1
Prmbuf    rmb   1
u0048    rmb   11
u0053    rmb   1
u0054    rmb   16
u0064    rmb   3
Nambuf    rmb   32
Allbuf   rmb   40
Secbuf   rmb   14
u00BD    rmb   12
u00C9    rmb   5
u00CE    rmb   9
u00D7    rmb   17
u00E8    rmb   6
u00EE    rmb   177
u019F    rmb   2
u01A1    rmb   2
u01A3    rmb   12
Optbuf   rmb   PAGE
Fdtbuf   rmb  9927
u2976    rmb   451
size     equ   .
name     equ   *
         fcs   /Format/
         fcb   20 

val1    fdb   0
val2    fdb   0
val3    fdb   0 

hdsdat   fcb   $80,$E5
         fcb   $80,$E5
         fcb   0,$00 

dctdat   fcb   $20,$4E
         fcb   $00,$00 

         fcb   $08,$00 
         fcb   $03,$F5
         fcb   $01,$FE 

         fcb   $04,$00 
         fcb   $01,$F7
         fcb   22,$4E   GAP2 22 x $4E
         fcb   $0C,$00 
         fcb   $03,$F5
         fcb   $01,$FB

         fcb   $80,$E5
         fcb   $80,$E5
         fcb   1,$F7
         fcb   $18,$4E
         fcb   $00,$00 
         fcb   $4E
         fcb   $00 
         fcb   $2C
         fcb   $01 
         fcb   $50

start    equ   *
         stu   <F.Dma
         bsr   clrwrk
         bsr   prsprm
         bsr   L00C4
         lbsr  dsktyp
         lbsr  L030C
         lbsr  intdsk    Write disk identification sector
         lbsr  L04E4
         lbsr  verify
         lbsr  fdsnok
         ldu   <F.Dtb
         os9   I$Detach 
         clrb  
fexout   os9   F$Exit   

clrwrk   leay  F.Opn,u
         pshs  y
         leay  >Secbuf,u
clrone   clr   ,-y
         cmpy  ,s
         bhi   clrone
         puls  pc,y

prsprm   lda   ,x+
         cmpa  #'/
         beq   L0084
bpnerr   ldb   #E$BPNam
         lbra  usermg

L0084    os9   F$PrsNam 
         lbcs  usermg
         lda   #$2F
         cmpa  ,y
         beq   bpnerr
         sty   <F.Prm
         leay  <Prmbuf,u
movnam    sta   ,y+
         lda   ,x+
         decb  
         bpl   movnam
         leax  <u0048,u
         lda   #$20
         sta   ,y
         clra  
         os9   I$Attach 
         lbcs  usermg
         stu   <F.Dtb
         ldu   <F.Dma
         lda   #$40
         ldb   #$20
         std   ,y
         lda   #$02
         leax  <Prmbuf,u
         os9   I$Open   
         bcs   fexout
         sta   <F.Opn
         rts   

L00C4    bsr   defalt
         bsr   L0107
         lbsr  L01AE
         rts   

* Get the parameters from the device descriptor
defalt   leax  >Optbuf,u
         clrb  
         os9   I$GetStt 
         bcs   fexout
         ldb   $07,x
         stb   <F.Sid
         ldb   $04,x
         pshs  b
         andb  #$01
         stb   <F.Bdn   0 = FM, 1 = MFM
         puls  b
         lsrb  
         andb  #$01
         stb   <u0011
         ldd   $05,x
         std   <u0013
         ldb   $03,x
         stb   <u001B
         andb  #$20
         stb   <u0046
         ldd   $09,x
         std   <u0017
         ldd   $0B,x
         std   <u0019
         ldb   $0D,x
         stb   <F.Ilv
         ldb   #$01
         stb   <F.Bit   Set cluster size to 1
         clrb  
         rts   

L0107    ldx   <F.Prm
L0109    leay  >opt.1,pcr
         bsr   L0120
         bcs   L0129
         pshs  b,a
         ldd   $02,y
         leay  d,y
         puls  b,a
         jsr   ,y
         bcc   L0109
         lbra  fexout

L0120    lda   ,x+
L0122    cmpa  ,y
         bne   L012A
         ldb   $01,y     Load default value
         clra  
L0129    rts   

L012A    leay  $04,y
         tst   ,y
         bne   L0122
         coma  
         rts   
opt.1    fcb   $52  R
         fcb   $59  Y
         fdb   o.rdy-opt.1
opt.2    fcb   $72  r
         fcb   $59  Y
         fdb   o.rdy-opt.2

opt.3    fcb   $22 "
         fcb   $00
         fdb   o.nam-opt.3

* Cylinders
opt.4    fcb   $27 '
         fcb   $00
         fdb   o.cyl-opt.4

* Sectors per cluster
opt.5    fcb   $2F /
         fcb   $00
         fdb   o.sect-opt.5

* Single sided
opt.6    fcb   $31 1
         fcb   1
         fdb   o.sid-opt.6

* Dual sided
opt.7    fcb   $32 2
         fcb   2
         fdb   o.sid-opt.7

opt.8    fcb   $20  space
         fcb   $00
         fdb   o.noop-opt.8

         fcb   $00

* Confirmation on ready
o.rdy    stb   <u001C
o.noop   rts

o.sid    stb   <F.Sid
         rts   

* Option for disk name
o.nam    leay  Nambuf,u
         ldb   #$20
L015E    lda   ,x+
         cmpa  #$22
         beq   L0175
         sta   ,y+
         decb  
         bne   L015E
L0169    ldb   ,x+
         cmpb  #$22
         beq   L017B
         cmpb  #$20
         bcc   L0169
         bra   L017B
L0175    lda   #$20
         cmpb  #$20
         beq   L017F
L017B    leay  -$01,y
         lda   ,y
L017F    adda  #$80
         sta   ,y
         clrb  
         rts  
 
* Cylinders
o.cyl    lbsr  inpnum
         ldd   <F.Val
         std   <u0013
         cmpd  #80       80 tracks?
         bne   L0194
         stb   <u0011
L0194    clrb  
L0195    rts   

* Sectors per cluster
o.sect   lbsr  inpnum
         ldd   <F.Val
         tsta  
         beq   L01A0
         ldb   #$01
L01A0    stb   <F.Bit
         negb  
         decb  
         andb  <F.Bit
         beq   L01AC
         ldb   #$01
         stb   <F.Bit
L01AC    clrb  
         rts   

L01AE    leax  >progvers,pcr
         lbsr  print
         leay  >Optbuf,u
         ldx   $09,y
         stx   <u0017
         leax  >formatgo,pcr
         ldy   #formaten-formatgo
         lbsr  prntln
         leax  <Prmbuf,u
         tfr   x,y
L01CD    lda   ,y+
         cmpa  #$40
         bne   L01CD
         pshs  y
         lda   #$0D
         sta   -$01,y
         lbsr  print
         puls  y
         lda   #$40
         sta   -$01,y
         lda   <u001C
         bne   L0195
L01E6    leax  >prompt,pcr
         ldy   #prmptend-prompt
         lbsr  respon
         anda  #^$20
         cmpa  #'Y
         beq   L0195
         clrb  
         cmpa  #'N
         lbeq  fexout
         cmpa  #'P
         bne   L01E6
         leax  >tracks80,pcr
         ldy   #tracksen-tracks80
         bsr   respon
         anda  #^$20
         cmpa  #'Y
         bne   L0219
         ldd   #$0050
         std   <u0013
         stb   <u0011
L0219    leax  >dblsided,pcr
         ldy   #gdsect-dblsided
         bsr   respon
         anda  #^$20
         cmpa  #'Y
         bne   L022D
         lda   #$02
         sta   <F.Sid
L022D    leax  >cluster,pcr
         ldy   #syscbd-cluster
         bsr   respon
         anda  #^$20
         cmpa  #'Y
         bne   L01E6
         lda   #$02
         sta   <F.Bit
         bra   L01E6

* Print line
linend   leax  >justcr,pcr
print    ldy   #80
prntln   lda   #$01
         os9   I$WritLn 
         rts   

* Prompt for a response
* Read from StdIn
respon   pshs  u,y,x,b,a
         bsr   prntln
         leax  ,s
         ldy   #$0001
         clra  
         os9   I$Read   
         lbcs  fexout
         bsr   linend
         puls  u,y,x,b,a
         anda  #$7F
         rts   

dsktyp   leax  >hdsdat,pcr
         stx   <u000A
         leax  >dctdat,pcr
         stx   <u000C
         clra  
         ldb   <F.Sid
         tfr   d,y
         clrb  
         ldx   <u0013
         bsr   L02BE
         exg   d,x
         subd  #$0001
         bcc   L0289
         leax  -$01,x
L0289    exg   d,x
         ldy   <u0017
         bsr   L02BE
         exg   d,x
         addd  <u0019
         std   <F.Tot+1
         exg   d,x
         adcb  #$00
         stb   <F.Tot
         lda   #$08
         pshs  a
         ldx   <F.Tot+1
         ldb   <F.Tot
         bsr   L0307
         lda   <F.Bit
         pshs  a
         bsr   L0307
         tstb  
         beq   L02B9
         leax  >clsmme,pcr   Print cluster mismatch
         lbsr  print
         lbra  abortf

L02B9    leas  $02,s
         stx   <u0026
         rts   

L02BE    lda   #$08
L02C0    clr   ,-s
         deca  
         bne   L02C0
         sty   ,s
         stb   $02,s
         stx   $03,s
L02CC    ldd   ,s
         beq   L02EF
         lsra  
         rorb  
         std   ,s
         bcc   L02E2
         ldd   $03,s
         addd  $06,s
         std   $06,s
         lda   $02,s
         adca  $05,s
         sta   $05,s
L02E2    ldd   $03,s
         lslb  
         rola  
         std   $03,s
         lda   $02,s
         rola  
         sta   $02,s
         bra   L02CC
L02EF    leas  $05,s
         puls  pc,x,b
L02F3    pshs  x,b
         lsr   ,s
         ror   $01,s
         ror   $02,s
         puls  x,b
         exg   d,x
         adcb  #$00
         adca  #$00
         exg   d,x
         adcb  #$00
L0307    lsr   $02,s
         bne   L02F3
         rts   

* Format physical tracks. This is actually done by the device driver
*
L030C    lda   <F.Opn
         ldb   #$03
         os9   I$SetStt 
         lbcs  fexout
         ldd   #$0000
         std   <F.Wtc
         inca  
         sta   <u0007
L031F    clr   <F.Fac
L0321    bsr   L036B
         leax  >Secbuf,u
         ldu   <F.Wtc
         clrb  
         orb   #$02
         tst   <u0011
         beq   L0332
         orb   #$04
L0332    lda   <F.Fac
         beq   L0338
         orb   #$01
L0338    tfr   d,y
         lda   <F.Opn
         ldb   #$04
         os9   I$SetStt 
         lbcs  fexout
         ldu   <F.Dma
         ldb   <F.Fac
         incb  
         stb   <F.Fac
         cmpb  <F.Sid
         bcs   L0321
         ldd   <F.Wtc
         addd  #1
         std   <F.Wtc
         cmpd  <u0013
         bcs   L031F
L035C    rts   

* Expand the codes in sgtdat or dbtdat into Secbuf
* Stop when $0,$0 is seen
L035D    ldy   <u000E
L0360    ldd   ,y++
         beq   L035C
L0364    stb   ,x+
         deca  
         bne   L0364
         bra   L0360

L036B    ldy   <u000C
         ldb   <u0018
         sty   <u000E
         stb   <u0009
         stb   <u0016
         bsr   cplsat
         leax  >Secbuf,u
         bsr   L0360
         sty   <u000E
L0382    bsr   L035D
         dec   <u0009
         bne   L0382
         lda   ,y+
         sty   <u000E
         stx   <u003B
         leay  >u2976,u
         sty   <F.Val
         tfr   a,b
L0398    std   ,x++
         cmpx  <F.Val
         bcs   L0398
         ldy   <u000E
         ldd   ,y++
         std   <u003D
         ldd   ,y
         std   <u003F
         clr   <u0009
         leax  >Secbuf,u
         ldd   <u003D
         leay  >Allbuf,u
L03B5    leax  d,x
         ldd   <u0004
         std   ,x
         ldb   <u0009
         lda   b,y
         incb  
         stb   <u0009
         ldb   <u0007
         inca  
         std   $02,x
         lda   <u0009
         cmpa  <u0016
         bcc   L03D1
         ldd   <u003F
         bra   L03B5
L03D1    rts   

cplsat   pshs  y,b
         tfr   b,a
         ldb   <u0004
         cmpb  #$01
         bhi   L03F1
         leax  >Allbuf,u
         leay  a,x
         ldb   <F.Ilv
         nega  
         pshs  y,x,b,a
         clra  
L03E8    sta   ,x
         inca  
         cmpa  <u0016
         bne   L03F3
         leas  $06,s
L03F1    puls  pc,y,b
L03F3    ldb   <F.Ilv
         abx   
         cmpx  $04,s
         bcs   L03FE
         ldb   ,s
         leax  b,x
L03FE    cmpx  $02,s
         bne   L03E8
         leax  $01,x
         stx   $02,s
         bra   L03E8

* Write disk identification sector
intdsk   lbsr  clrbuf
         ldd   <F.Tot+1
         std   $01,x
         ldb   <F.Tot
         stb   ,x
         ldd   <u0017
         std   <$11,x
         stb   $03,x
         lda   <F.Bit
         sta   $07,x
         clra  
         ldb   <u0026
         tst   <u0027
         beq   L0428
         addd  #$0001
L0428    addd  #$0001
         addd  #$0010
         std   $09,x
         clra  
         ora   #$02
         ldb   <F.Sid
         cmpb  #$01
         beq   L043B
         ora   #$01
L043B    tst   <u0011
         beq   L0441
         ora   #$04
L0441    sta   <$10,x
         ldd   <u0026
         std   $04,x
         lda   #$FF       Set disk attributes to $ff
         sta   $0D,x
         leax  >u00C9,u
         os9   F$Time   
         leax  >u00CE,u
         leay  <Nambuf,u
         tst   ,y
         beq   nmntav
L045E    lda   ,y+
         sta   ,x+
         bpl   L045E
         bra   L0499

* Ask for disk name
nmntav   leax  >namask,pcr
         ldy   #namasken-namask
         lbsr  prntln
         leax  >u00CE,u
         ldy   #$0021
         clra  
         os9   I$ReadLn 
         bcc   L048A
         cmpa  #E$EOF
         bne   nmntav
abortf   leax  >fabort,pcr
         lbra  exterr

L048A    tfr   y,d
         leax  d,x
         clr   ,-x
         decb  
         beq   nmntav
         lda   ,-x
         ora   #$80
         sta   ,x
L0499    leax  >u00C9,u
         leay  <$40,x
         pshs  y
         ldd   #$0000
L04A5    addd  ,x++
         cmpx  ,s
         bcs   L04A5
         leas  $02,s
         std   >u00BD,u
         ldd   >val1,pcr
         std   >u019F,u
         ldd   >val2,pcr
         std   >u01A1,u
         ldd   >val3,pcr
         std   >u01A3,u
         lda   <F.Opn
         ldb   #$00
         leax  >u00EE,u
         os9   I$GetStt 
         ldb   #$03
         os9   I$SetStt 
         lbcs  fexout
         leax  >Secbuf,u
         lbra  wrtsec

L04E4    lda   <F.Opn
         os9   I$Close  
         leax  <Prmbuf,u
         lda   #$01
         os9   I$Open   
         lbcs  rptbss
         sta   <F.Opn
         leax  >Secbuf,u
         ldy   #$0100
         os9   I$Read   
         lbcs  rptbss
         lda   <F.Opn
         os9   I$Close  
         leax  <Prmbuf,u
         lda   #$03
         os9   I$Open   
         lbcs  rptbss
         sta   <F.Opn
         rts   

* Verify disk
verify   lda   <u001B
         clr   <u0043
         ldd   <u0019
         std   <u0015
         clra  
         clrb  
         std   <u0034
         std   <F.Wtc
         std   <u0008
         std   <F.Cnt+1
         stb   <F.Cnt
         sta   <u003A
         leax  >Optbuf,u
         stx   <u0036
         lbsr  clrsec
         leax  >$0100,x
         stx   <u0038
         clra  
         ldb   #$01
         std   <F.Bms
         lda   <F.Bit
         sta   <u0029
         clr   <u0028
         clra  
         ldb   <u0026
         tst   <u0027
         beq   L0554
         addd  #$0001
L0554    addd  #$0009
         addd  #$0010
         std   <u002B
         lda   <F.Bit
L055E    lsra  
         bcs   L056F
         lsr   <u002B
         ror   <u002C
         bcc   L055E
         inc   <u002C
         bne   L055E
         inc   <u002B
         bra   L055E
L056F    ldb   <u002C
         stb   <u002D
         lda   <F.Bit
         mul   
         std   <u002B
         subd  #$0001
         subb  <u0026
         sbca  #$00
         subd  #$0010
         tst   <u0027
         beq   L0589
         subd  #$0001
L0589    stb   <u002A
L058B    tst   <u0043
         bne   nxtsec
         lda   <F.Opn
         leax  >Secbuf,u
         ldy   #$0100
         os9   I$Read   
         bcc   nxtsec
         os9   F$PErr   
         lbsr  L078B
         lda   #$FF
         sta   <u0028
         tst   <F.Cnt
         bne   nxtsec
         ldx   <F.Cnt+1
         cmpx  <u002B
         bhi   nxtsec
rptbss   leax  >syscbd,pcr   Print bad system sector
exterr   lbsr  print
         clrb  
         lbra  fexout

nxtsec   ldd   <u0008
         addd  #$0001
         std   <u0008
         cmpd  <u0015
         bcs   L0602
         clr   <u0008
         clr   <u0009
         tst   <u0043
         bne   L05F7
* Write the sector number to stdout
         lda   #$20
         pshs  a
         lda   <u0004
         lbsr  L0664
         pshs  b,a
         lda   <F.Wtc
         lbsr  L0664
         pshs  b
         tfr   s,x
         ldy   #$0004
         lbsr  prntln
         lda   $02,s
         cmpa  #'F    Write newline if number ends with 'F'
         bne   L05F5
         lbsr  linend
L05F5    leas  $04,s
L05F7    ldd   <F.Wtc
         addd  #$0001
         std   <F.Wtc
         ldd   <u0017
         std   <u0015
L0602    dec   <u0029
         bne   L0618
         bsr   L0641
         tst   <u0028
         bne   L0612
         ldx   <u0034
         leax  $01,x
         stx   <u0034
L0612    clr   <u0028
         lda   <F.Bit
         sta   <u0029
L0618    ldb   <F.Cnt
         ldx   <F.Cnt+1
         leax  $01,x
         bne   L0621
         incb  
L0621    cmpb  <F.Tot
         bcs   L0629
         cmpx  <F.Tot+1
         bcc   L0630
L0629    stb   <F.Cnt
         stx   <F.Cnt+1
         lbra  L058B
L0630    lda   #$FF
         sta   <u0028
         leay  >Optbuf,u
L0638    cmpy  <u0036
         beq   L067C
         bsr   L0641
         bra   L0638

L0641    ldx   <u0036
         lda   <u0028
         rora  
         rol   ,x+
         inc   <u003A
         lda   <u003A
         cmpa  #$08
         bcs   L0663
         clr   <u003A
         stx   <u0036
         cmpx  <u0038
         bne   L0663
         bsr   L06C0
         leax  >Optbuf,u
         stx   <u0036
         lbsr  clrsec
L0663    rts   

L0664    tfr   a,b
         lsra  
         lsra  
         lsra  
         lsra  
         andb  #$0F
         addd  #$3030
         cmpa  #$39
         bls   L0675
         adda  #$07
L0675    cmpb  #$39
         bls   L067B
         addb  #$07
L067B    rts   

* Print out the number of good sectors
L067C    lbsr  linend
         leax  >gdsect,pcr
         ldy   #gdsecten-gdsect
         lbsr  prntln
         ldb   <F.Bit
         clra  
         ldx   <u0034
         pshs  x,a
L0691    lsrb  
         bcs   L069C
         lsl   $02,s
         rol   $01,s
         rol   ,s
         bra   L0691
L069C    puls  x,a
         ldb   #$0D
         pshs  b
         tfr   d,y
         tfr   x,d
         tfr   b,a
         bsr   L0664
         pshs  b,a
         tfr   x,d
         bsr   L0664
         pshs  b,a
         tfr   y,d
         bsr   L0664
         pshs  b,a
         tfr   s,x
         lbsr  print
         leas  $07,s
         rts   

L06C0    pshs  y
         clra  
         ldb   #$01
         cmpd  <F.Bms
         bne   L06DB
         leax  >Optbuf,u
         clra  
         ldb   <u002D
         tfr   d,y
         clrb  
         os9   F$AllBit 
         lbcs  rptbss
L06DB    lbsr  seksec
         leax  >Optbuf,u
         lbsr  wrtsec
         ldd   <F.Tot
         cmpd  <F.Cnt
         bcs   L06F7
         bhi   L06F4
         ldb   <F.Tot+2
         cmpb  <F.Cnt+2
         bcc   L06F7
L06F4    lbsr  L078B
L06F7    ldd   <F.Bms
         addd  #$0001
         std   <F.Bms
         puls  pc,y

* Write the root dir structure
* Reserve space for boot sectors?
fdsnok   ldd   #$0010
         addd  <F.Bms
         std   <F.Bms
         bsr   seksec
         leax  >Fdtbuf,u
         bsr   clrsec
         leax  >Fdtbuf+FD.DAT,u
         os9   F$Time   
         leax  >Fdtbuf,u
         lda   #$BF
         sta   ,x
         lda   #$02         Set link count to 2
         sta   $08,x
         clra  
         ldb   #$40
         std   $0B,x
         ldb   <u002A
         decb  
         stb   <$14,x
         ldd   <F.Bms
         addd  #$0001
         std   <$11,x
         bsr   wrtsec
* Write the directory entries
         bsr   clrbuf
         ldd   #$2EAE
         std   ,x
         stb   <$20,x
         ldd   <F.Bms
         std   <$1E,x
         std   <$3E,x
         bsr   wrtsec

         bsr   clrbuf
         ldb   <u002A
L074F    decb  
         bne   L0753
         rts   

L0753    pshs  b
         bsr   wrtsec
         puls  b
         bra   L074F

* Clear the sector buffer
clrbuf   leax  >Secbuf,u
clrsec   clra  
         clrb  
L0761    sta   d,x
         decb  
         bne   L0761
         rts   

wrtsec   lda   <F.Opn
         ldy   #$0100
         os9   I$Write  
         lbcs  fexout
         rts   
seksec   clra  
         ldb   <F.Bms
         tfr   d,x
         lda   <u0033
         clrb  
         tfr   d,u
L077F    lda   <F.Opn
         os9   I$Seek   
         ldu   <F.Dma
         lbcs  fexout
         rts   
L078B    ldx   <F.Cnt
         lda   <F.Cnt+2
         clrb  
         addd  #$0100
         tfr   d,u
         bcc   L077F
         leax  $01,x
         bra   L077F
         ldd   ,y
         leau  >Secbuf,u
         leax  >dcnums,pcr
         ldy   #$2F20
L07A9    leay  >$0100,y
         subd  ,x
         bcc   L07A9
         addd  ,x++
         pshs  b,a
         ldd   ,x
         tfr   y,d
         beq   L07D1
         ldy   #$2F30
         cmpd  #$3020
         bne   L07CB
         ldy   #$2F20
         tfr   b,a
L07CB    sta   ,u+
         puls  b,a
         bra   L07A9

L07D1    sta   ,u+
         lda   #$0D
         sta   ,u
         ldu   <F.Dma
         leas  $02,s
         leax  >Secbuf,u
         lbsr  print
         rts   

* Decimal powers
dcnums   fdb 10000
         fdb 1000
         fdb 100
         fdb 10
         fdb 1
         fdb 0

* Parse a number pointed to in X
* Store result in F.Val
inpnum   ldd   #$0000
L07F2    bsr   L0802
         bcs   L07FC
         bne   L07F2
         std   <F.Val
         bne   L0801
L07FC    ldd   #$0001
         std   <F.Val
L0801    rts   

L0802    pshs  y,b,a
         ldb   ,x+
         subb  #$30
         cmpb  #$0A
         bcc   L0820
         lda   #$00
         ldy   #$000A
L0812    addd  ,s
         bcs   L081E
         leay  -$01,y
         bne   L0812
         std   ,s
         andcc #$FB
L081E    puls  pc,y,b,a
L0820    orcc  #$04
         puls  pc,y,b,a
usermg   lda   #$02
         os9   F$PErr   
         leax  <useopt,pcr
         ldy   #faborten-useopt
         lda   #$02
         os9   I$WritLn 
         clrb  
         os9   F$Exit   

progvers fcb   $0A
         fcc  "FORMAT V2.1"
justcr   fcb   $0D

useopt   fcc   "Use: FORMAT /devname <opts>"
         fcb   $0A
         fcc   "  opts: R  - Ready"
         fcb   $0A
         fcc   /        "disk name"/
         fcb   $0A
         fcc   /        'number of tracks'/
         fcb   $0A
         fcc   /        1  - one sided/
         fcb   $0A
         fcc   /        2  - dual sided/
         fcb   $0A
         fcc   '        /sectors per cluster/'
         fcb   $0A
         fcb   $0D

formatgo fcc   'Formatting drive '
formaten equ   *
prompt   fcc   'y (yes), p (parameters) or n (no)'
         fcb   $0A
         fcc   'Ready?  '
prmptend equ   *
namask   fcc   'Disk name: '
namasken equ   *

tracks80 fcc   '80 tracks? : '
tracksen equ   *
cluster  fcc   '2 sectors per cluster? '
syscbd  fcc   'Bad system sector, '
         fcb   $0D
fabort   fcc   'FORMAT ABORTED'
faborten equ   *
         fcb   $0D
clsmme   fcc   'Cluster size mismatch'
         fcb   $0D
dblsided fcc   'Double sided? '
gdsect   fcc   'Number of good sectors: $'
gdsecten equ *
         emod
eom      equ   *
