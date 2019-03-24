         nam   Format
         ttl   Dragon 64 version

* Header for : Format
* Module size: $A96  #2710
* Module CRC : $8C93D6 (Good)
* Hdr parity : $B4
* Exec. off  : $009B  #155
* Data size  : $2B39  #11065
* Edition    : $12  #18
* Ty/La At/Rv: $11 $81
* Prog mod, 6809 Obj, re-ent, R/O

* See http://info-coach.fr/atari/hardware/FD-Hard.php
* http://www.hermannseib.com/documents/floppy.pdf

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
F.Scl    rmb   1
F.Cns    rmb   1
u0009    rmb   1
u000A    rmb   1
u000B    rmb   1
F.Dtk    rmb   2 track data pointer
u000E    rmb   1
u000F    rmb   1
F.Bdn    rmb   1  bit density 0 = FM, 1 = MFM
F.Tdn    rmb   1  track density
F.Sid    rmb   1
F.Cyl    rmb   2
u0015    rmb   1
F.Wsc    rmb   1 sector count
F.Spt    rmb   2 sectors per track
F.Stz    rmb   1
u001A    rmb   1
F.Typ    rmb   1  Disk type: bit 7 = harddisk
skipconf rmb   1  Skip confirmation (To allow replacing disk)
F.Val    rmb   2
F.Ilv    rmb   1 skip
F.Prm    rmb   2  parameters
F.Tot    rmb   3 total sectors
F.Bit    rmb   1 Number of sectors per cluster (always 1)
F.Map    rmb   1
u0027    rmb   1
u0028    rmb   1
u0029    rmb   1
F.Das    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   2
F.Cnt    rmb   3 lsn count
F.Bms    rmb   2 Bitmap sectors
u0034    rmb   2
F.Pnt    rmb   2 pointer
F.Max    rmb   2
F.Mcn    rmb   1 map count
u003B    rmb   2
u003D    rmb   2
u003F    rmb   4
u0043    rmb   1
F.Dtb    rmb   2 device table
u0046    rmb   1
Prmbuf   rmb   32
Nambuf   rmb   32
Allbuf   rmb   40
Secbuf   rmb   PAGE
Optbuf   rmb   PAGE
Fdtbuf   rmb   9927
u2976    rmb   451

size     equ   .
name     equ   *
         fcs   /Format/
         fcb   $12 

val1     fdb   0 
val2     fdb   0 
val3     fdb   0 

hdsdat   fcb   $80,$E5 
         fcb   $80,$E5
         fcb   0,$00 

* Low level formatting

* First byte is the number of the second byte to expect

* IBM 3740 format
sgtdat   fcb   1,$00
         fcb   40,$FF
         fcb   6,$00
         fcb   1,$FC  Index Address Mark (IAM)
         fcb   12,$FF
         fcb   0,$00 

         fcb   6,$00 
         fcb   1,$FE 

         fcb   4,$00 
         fcb   1,$F7   2 CRCs written
         fcb   10,$FF 
         fcb   6,$00 
         fcb   1,$FB   Data address mark

         fcb   $80,$E5
         fcb   $80,$E5
         fcb   1,$F7
         fcb   10,$FF 
         fcb   $00,$00 

         fcb   $FF 
         fcb   $00 
         fcb   $43
         fcb   $01
         fcb   $28

* Structure of pre-index gap of double density

* track header IBM System 34 format
dbtdat   fcb   80,$4E
         fcb   12,$00  Sync 12 x 00
         fcb   3,$F6  IAM 3 x $F6 + 1 x $FC
         fcb   1,$FC  Index Address Mark (IAM)
         fcb   $20,$4E  GAP1
         fcb   $00,$00 

         fcb   12,$00  SYNC 12 x $00
         fcb   3,$F5   IDAM
         fcb   1,$FE 

         fcb   4,$00 
         fcb   1,$F7
         fcb   22,$4E  GAP2 22 x $4E
         fcb   12,$00  SYNC 12 x $00
         fcb   3,$F5   DATA AM
         fcb   1,$FB 

         fcb   $80,$E5
         fcb   $80,$E5
         fcb   1,$F7
         fcb   22,$4E
         fcb   $00,$00 

         fcb   $4E,$00 
         fcb   $90 
         fcb   $01 
         fcb   $52 

dctdat   fcb   $20,$4E
         fcb   $00,$00 

         fcb   $08,$00 
         fcb   $03,$F5
         fcb   $01,$FE 

         fcb   $04,$00 
         fcb   $01,$F7
         fcb   22,$4E   GAP2 22 x $4E
         fcb   $0C,$00 SYNC 12 x $00
         fcb   $03,$F5 DATA AM
         fcb   $01,$FB 

         fcb   $80,$E5
         fcb   $80,$E5
         fcb   $01,$F7
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
         bsr   L011A
         lbsr  dsktyp
         lbsr  L0351
         lbsr  intdsk    Write disk identification sector
         lbsr  access
         lbsr  verify
         lbsr  fdsnok   Write root dir structure
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
         cmpa  #PDELIM       /
         beq   L00DA
bpnerr   ldb   #E$BPNam
         lbra  usermg

L00DA    os9   F$PrsNam 
         lbcs  usermg
         lda   #PDELIM       /
         cmpa  ,y
         beq   bpnerr    Bad path name error
         sty   <F.Prm
         leay  <Prmbuf,u
movnam   sta   ,y+
         lda   ,x+
         decb  
         bpl   movnam
         leax  <Prmbuf+1,u
         lda   #C$SPAC
         sta   ,y
         clra  
         os9   I$Attach 
         lbcs  usermg
         stu   <F.Dtb
         ldu   <F.Dma
         lda   #'@
         ldb   #C$SPAC
         std   ,y
         lda   #WRITE.
         leax  <Prmbuf,u
         os9   I$Open   
         bcs   fexout
         sta   <F.Opn
         rts   

L011A    bsr   defalt
         bsr   L015D
         lbsr  L0216
         rts   

* Get the parameters from the device descriptor
defalt   leax  >Optbuf,u
         clrb              SS.Opt - Function code 0
         os9   I$GetStt 
         bcs   fexout
         ldb   PD.SID-PD.OPT,x    Get number of sides
         stb   <F.Sid
         ldb   PD.DNS-PD.OPT,x    Density capability
         pshs  b
         andb  #$01
         stb   <F.Bdn   0 = FM, 1 = MFM
         puls  b
         lsrb  
         andb  #$01
         stb   <F.Tdn         Track density 1 = 96 TPI 0 = single 48 TPI
         ldd   PD.CYL-PD.OPT,x
         std   <F.Cyl
         ldb   PD.TYP-PD.OPT,x
         stb   <F.Typ
         andb  #$20
         stb   <u0046
         ldd   PD.SCT-PD.OPT,x
         std   <F.Spt
         ldd   PD.T0S-PD.OPT,x  Default sectors/track tr00,s0
         std   <F.Stz
         ldb   PD.ILV-PD.OPT,x
         stb   <F.Ilv
         ldb   #$01
         stb   <F.Bit   Set cluster size to 1
         clrb  
         rts   

L015D    ldx   <F.Prm
L015F    leay  >opt.1,pcr
         bsr   L0176
         bcs   L017F
         pshs  b,a
         ldd   $02,y
         leay  d,y
         puls  b,a
         jsr   ,y
         bcc   L015F
         lbra  fexout

L0176    lda   ,x+
L0178    cmpa  ,y
         bne   L0180
         ldb   $01,y     Load default value
         clra  
L017F    rts   

L0180    leay  $04,y
         tst   ,y
         bne   L0178
         coma  
         rts   

opt.1    fcb   $52  R
         fcb   $59  Y
         fdb   o.rdy-opt.1
opt.2    fcb   $72  r
         fcb   $59  Y
         fdb   o.rdy-opt.2
opt.3    fcb   $22  "
         fcb   $00
         fdb   o.nam-opt.3
opt.4    fcb   $3A  :
         fcb   $00
         fdb   o.ilv-opt.4
opt.5    fcb   $43  C
         fcb   $00
         fdb   o.unk3-opt.5
opt.6    fcb   $63  c
         fcb   $00
         fdb   o.unk3-opt.6
opt.7    fcb   $28  (
         fcb   $00
         fdb   o.noop-opt.7
opt.8    fcb   $29  )
         fcb   $00
         fdb   o.noop-opt.8
opt.9    fcb   $2C   ,
         fcb   $00
         fdb   o.noop-opt.9
opt.a    fcb   $20   space
         fcb   $00
         fdb   o.noop-opt.a
         fcb   $00

* Not referred to in options
o.unk1   stb   <F.Bdn
o.noop   rts

* Confirmation on ready
o.rdy    stb   <skipconf
         rts

* Not referred to in options
o.sid    stb   <F.Sid
         rts

o.unk3   inc   <u0046
         rts   

* Option for disk name
o.nam    leay  Nambuf,u
         ldb   #$20
nxtnam   lda   ,x+
         cmpa  #'"
         beq   namfil
         sta   ,y+
         decb  
         bne   nxtnam
L01CD    ldb   ,x+
         cmpb  #'"
         beq   L01DF
         cmpb  #C$SPAC
         bcc   L01CD
         bra   L01DF
namfil   lda   #C$SPAC
         cmpb  #$20
         beq   nulnam
L01DF    leay  -$01,y
         lda   ,y
nulnam   adda  #$80
         sta   ,y
         clrb  
         rts   

* Not referred to in options
o.cyl    lbsr  inpnum
         ldd   <F.Val
         std   <F.Cyl
         rts   

* ":" option Interleave
o.ilv    lbsr  inpnum
         ldd   <F.Val
         tsta  
         beq   L01FB
         ldb   #$01
L01FB    stb   <F.Ilv
L01FD    rts   

* Not referred to in options
* Sets cluster size
o.unk6   lbsr  inpnum
         ldd   <F.Val
         tsta  
         beq   L0208
         ldb   #$01
L0208    stb   <F.Bit   Set cluster size to 1
         negb  
         decb  
         andb  <F.Bit
         beq   L0214
         ldb   #$01
         stb   <F.Bit   Set cluster size to 1 if insane
L0214    clrb  
         rts   

L0216    leax  >progvers,pcr
         lbsr  print
         leay  >Optbuf,u
         ldx   $0B,y
         tst   <F.Bdn
         beq   L0229
         ldx   PD.SCT-PD.OPT,y
L0229    stx   <F.Spt
         leax  >formatgo,pcr
         ldy   #formaten-formatgo
         lbsr  prntln
         leax  <Prmbuf,u
         tfr   x,y
L023B    lda   ,y+
         cmpa  #$40
         bne   L023B
         pshs  y
         lda   #$0D
         sta   -$01,y
         lbsr  print
         puls  y
         lda   #$40
         sta   -$01,y
         lda   <skipconf
         bne   L01FD
* Ask for ready (Y/N)
L0254    leax  >prompt,pcr
         ldy   #prmptend-prompt
         lbsr  respon
         anda  #^$20
         cmpa  #'Y
         beq   L01FD
         clrb  
         cmpa  #'N
         lbeq  fexout
         bra   L0254

* Print line
linend   leax  >justcr,pcr
print    ldy   #80
prntln   lda   #StdOut
         os9   I$WritLn 
         rts   

* Prompt for a response
* Read from StdIn
respon   pshs  u,y,x,b,a
         bsr   prntln
         leax  ,s        Where to store the response
         ldy   #1        Read one character
         clra            Set A to stdin
         os9   I$Read   
         lbcs  fexout
         bsr   linend
         puls  u,y,x,b,a
         anda  #$7F
         rts   

dsktyp   leax  >hdsdat,pcr
         stx   <u000A
         ldb   <F.Typ
         bitb  #$C0
         bne   trkdat
         ldb   <u0046
         beq   L02AB
         leax  >dctdat,pcr
         bra   trkdat

L02AB    leax  >sgtdat,pcr    Single bit density
         stx   <u000A
         tst   <F.Bdn   bit density 0 = FM, 1 = MFM
         beq   trkdat
         leax  >dbtdat,pcr    Double bit density
trkdat   stx   <F.Dtk
         clra  
         ldb   <F.Sid
         tfr   d,y
         clrb  
         ldx   <F.Cyl
         bsr   L0303
         exg   d,x
         subd  #$0001
         bcc   mionoc
         leax  -$01,x
mionoc   exg   d,x
         ldy   <F.Spt
         bsr   L0303
         exg   d,x
         addd  <F.Stz
         std   <F.Tot+1
         exg   d,x
         adcb  #$00
         stb   <F.Tot
         lda   #$08
         pshs  a
         ldx   <F.Tot+1
         ldb   <F.Tot
         bsr   L034C
         lda   <F.Bit
         pshs  a
         bsr   L034C
         tstb  
         beq   bmpsok
         leax  >clsmme,pcr   Print cluster mismatch
         lbsr  print
         lbra  abortf

bmpsok   leas  $02,s
         stx   <F.Map
         rts   

L0303    lda   #$08
L0305    clr   ,-s
         deca  
         bne   L0305
         sty   ,s
         stb   $02,s
         stx   $03,s
L0311    ldd   ,s
         beq   L0334
         lsra  
         rorb  
         std   ,s
         bcc   L0327
         ldd   $03,s
         addd  $06,s
         std   $06,s
         lda   $02,s
         adca  $05,s
         sta   $05,s
L0327    ldd   $03,s
         lslb  
         rola  
         std   $03,s
         lda   $02,s
         rola  
         sta   $02,s
         bra   L0311
L0334    leas  $05,s
         puls  pc,x,b
L0338    pshs  x,b
         lsr   ,s
         ror   $01,s
         ror   $02,s
         puls  x,b
         exg   d,x
         adcb  #$00
         adca  #$00
         exg   d,x
         adcb  #$00
L034C    lsr   $02,s
         bne   L0338
         rts   

L0351    tst   <F.Typ
         bpl   L036B       If bit 7 is on then do physical format - don't ask
         leax  >L0A58,pcr  Ask for physical format
         ldy   #$0022
         lbsr  respon
         anda  #^$20
         cmpa  #'Y
         beq   L036B
         cmpa  #'N
         bne   L0351
         rts   

* Format physical tracks. This is actually done by the device driver
*
L036B    lda   <F.Opn
         ldb   #SS.Reset  Restore head to track 0
         os9   I$SetStt 
         lbcs  fexout
         ldd   #0
         std   <F.Wtc track = 0
         inca  
         sta   <F.Scl       Sector length = 256
fmontk   clr   <F.Fac       side = 0
fmostk   bsr   intdat
         leax  >Secbuf,u
         ldu   <F.Wtc       track count
         clrb  
         tst   <F.Bdn
         beq   L039B
         tst   <u0046
         bne   L0399
         tst   <u0004
         bne   L0399
         tst   <F.Fac  side count
         beq   L039B
L0399    orb   #$02        Set side 1 ?
L039B    tst   <F.Tdn
         beq   L03A1
         orb   #$04    Declare double density
L03A1    lda   <F.Fac  side count
         beq   L03A7
         orb   #$01
L03A7    tfr   d,y
         lda   <F.Opn
         ldb   #SS.WTrk
         os9   I$SetStt  X= addr of track buffer, U= track, Y= side/density
         lbcs  fexout
         ldu   <F.Dma
         ldb   <F.Fac  side count
         incb  
         stb   <F.Fac  side count
         cmpb  <F.Sid
         bcs   fmostk
         ldd   <F.Wtc
         addd  #1
         std   <F.Wtc
         cmpd  <F.Cyl
         bcs   fmontk
         rts   

* Expand the codes in sgtdat or dbtdat into Secbuf
* Stop when $0,$0 is seen
L03CC    ldy   <u000E
L03CF    ldd   ,y++
         beq   L03E9
L03D3    stb   ,x+
         deca  
         bne   L03D3
         bra   L03CF

intdat   lda   <F.Typ
         bita  #$C0
         beq   L03EA
         ldy   <F.Dtk
         leax  >Secbuf,u
         bsr   L03CF
L03E9    rts   

L03EA    ldy   <F.Dtk
         ldb   <F.Spt+1
         tst   <u0046
         bne   L0400
         tst   <u0004
         bne   L0400
         tst   <F.Fac
         bne   L0400
         ldy   <u000A
         ldb   <u001A
L0400    sty   <u000E
         stb   <u0009
         stb   <F.Wsc
         bsr   cplsat
         leax  >Secbuf,u
         bsr   L03CF
         sty   <u000E
L0412    bsr   L03CC
         dec   <u0009
         bne   L0412
         lda   ,y+
         sty   <u000E
         stx   <u003B
         leay  >u2976,u
         sty   <F.Val
         tfr   a,b
L0428    std   ,x++
         cmpx  <F.Val
         bcs   L0428
         ldy   <u000E
         ldd   ,y++
         std   <u003D
         ldd   ,y
         std   <u003F
         clr   <u0009
         leax  >Secbuf,u
         ldd   <u003D
         leay  >Allbuf,u
L0445    leax  d,x
         ldd   <u0004
         std   ,x
         ldb   <u0009
         lda   b,y
         incb  
         stb   <u0009
         ldb   <F.Scl
         tst   <u0046
         beq   L0459
         inca  
L0459    std   $02,x
         lda   <u0009
         cmpa  <F.Wsc
         bcc   L0465
         ldd   <u003F
         bra   L0445
L0465    rts   

cplsat   pshs  y,b skip table
         tfr   b,a
         ldb   <u0004
         cmpb  #$01
         bhi   plaend
         leax  >Allbuf,u
         leay  a,x
         ldb   <F.Ilv
         bne   L0481
L047A    leax  >L097F,pcr
         lbra  exterr
L0481    cmpb  <F.Wsc
         bhi   L047A
         nega  
         pshs  y,x,b,a
         clra  
L0489    sta   ,x
         inca  
         cmpa  <F.Wsc
         bne   nxtlps
         leas  $06,s
plaend   puls  pc,y,b

nxtlps   ldb   <F.Ilv
         abx   
         cmpx  $04,s
         bcs   L049F
         ldb   ,s
         leax  b,x
L049F    cmpx  $02,s
         bne   L0489
         leax  $01,x
         stx   $02,s
         bra   L0489

* Write disk identification sector
intdsk   lbsr  clrbuf
         ldd   <F.Tot+1
         std   DD.TOT+1,x
         ldb   <F.Tot
         stb   DD.TOT,x
         ldd   <F.Spt
         std   <DD.SPT,x
         stb   DD.TKS,x
         lda   <F.Bit
         sta   DD.BIT+1,x
         clra  
         ldb   <F.Map
         tst   <u0027
         beq   L04C9
         addd  #$0001
L04C9    addd  #$0001
         addd  #$0010
         std   DD.DIR+1,x
         clra  
         tst   <F.Bdn
         beq   L04D8
         ora   #$02
L04D8    ldb   <F.Sid
         cmpb  #$01
         beq   L04E0
         ora   #$01
L04E0    tst   <F.Tdn
         beq   L04E6
         ora   #$04
L04E6    sta   <DD.FMT,x
         ldd   <F.Map
         std   DD.MAP,x
         lda   #$FF       Set disk attributes to $ff
         sta   DD.ATT,x
         leax  Secbuf+DD.DAT,u     Set creation date
         os9   F$Time   
         leax  Secbuf+DD.NAM,u
         leay  Nambuf,u
         tst   ,y
         beq   nmntav
L0503    lda   ,y+
         sta   ,x+
         bpl   L0503
         bra   L053E

* Ask for disk name
nmntav   leax  >namask,pcr
         ldy   #namasken-namask
         lbsr  prntln
         leax  Secbuf+DD.NAM,u
         ldy   #$0021
         clra  
         os9   I$ReadLn 
         bcc   dknmib
         cmpa  #E$EOF
         bne   nmntav
abortf   leax  >fabort,pcr
         lbra  exterr

dknmib   tfr   y,d
         leax  d,x
         clr   ,-x
         decb  
         beq   nmntav
         lda   ,-x
         ora   #$80
         sta   ,x

L053E    leax  Secbuf+DD.DAT,u
         leay  <$40,x
         pshs  y
         ldd   #$0000
L054A    addd  ,x++
         cmpx  ,s
         bcs   L054A
         leas  $02,s
         std   Secbuf+DD.DSK,u  Set disk number based on date

         ldd   >val1,pcr
         std   Secbuf+DD.OPT+$b1,u
         ldd   >val2,pcr
         std   Secbuf+DD.OPT+$b1+2,u
         ldd   >val3,pcr
         std   Secbuf+DD.OPT+$b1+4,u
         lda   <F.Opn
         ldb   #SS.Opt
         leax  >Secbuf+DD.OPT,u
         os9   I$GetStt 
         ldb   #SS.Reset
         os9   I$SetStt 
         lbcs  fexout
         leax  >Secbuf,u
         lbra  wrtsec

access   lda   <F.Opn
         os9   I$Close  
         leax  <Prmbuf,u
         lda   #READ.
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
         lda   #UPDAT.
         os9   I$Open   
         lbcs  rptbss
         sta   <F.Opn
         rts   

* Verify disk
verify   lda   <F.Typ
         clr   <u0043
         bita  #$80           If bit 7 is on then do verification - don't ask
         beq   doverf
L05C7    leax  >askver,pcr    Ask for verification
         ldy   #$0019
         lbsr  respon
         anda  #^$20
         cmpa  #'Y
         beq   doverf
         cmpa  #'N
         bne   L05C7         Neither Y or N answered
         sta   <u0043
* Do verification
doverf   ldd   <F.Stz
         std   <u0015
         clra  
         clrb  
         std   <u0034
         std   <F.Wtc
         std   <F.Cns
         std   <F.Cnt+1
         stb   <F.Cnt
         sta   <F.Mcn
         leax  >Optbuf,u
         stx   <F.Pnt
         lbsr  clrsec
         leax  PAGE,x
         stx   <F.Max
         clra  
         ldb   #$01
         std   <F.Bms
         lda   <F.Bit
         sta   <u0029
         clr   <u0028
         clra  
         ldb   <F.Map
         tst   <u0027
         beq   L0614
         addd  #$0001
L0614    addd  #$0009
         addd  #$0010
         std   <u002B
         lda   <F.Bit
L061E    lsra  
         bcs   L062F
         lsr   <u002B
         ror   <u002C
         bcc   L061E
         inc   <u002C
         bne   L061E
         inc   <u002B
         bra   L061E
L062F    ldb   <u002C
         stb   <u002D
         lda   <F.Bit
         mul   
         std   <u002B
         subd  #$0001
         subb  <F.Map
         sbca  #$00
         subd  #$0010
         tst   <u0027
         beq   L0649
         subd  #$0001
L0649    stb   <F.Das
L064B    tst   <u0043
         bne   nxtsec
         lda   <F.Opn
         leax  >Secbuf,u
         ldy   #$0100
         os9   I$Read   
         bcc   nxtsec
         os9   F$PErr   
         lbsr  L084B
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

nxtsec   ldd   <F.Cns
         addd  #$0001
         std   <F.Cns
         cmpd  <u0015
         bcs   L06C2
         clr   <F.Cns
         clr   <u0009
         tst   <u0043
         bne   L06B7
* Write the sector number to stdout
         lda   #$20
         pshs  a
         lda   <u0004
         lbsr  L0724
         pshs  b,a
         lda   <F.Wtc
         lbsr  L0724
         pshs  b
         tfr   s,x
         ldy   #4
         lbsr  prntln
         lda   $02,s
         cmpa  #'F    Write newline if number ends with 'F'
         bne   L06B5
         lbsr  linend
L06B5    leas  $04,s
L06B7    ldd   <F.Wtc
         addd  #$0001
         std   <F.Wtc
         ldd   <F.Spt
         std   <u0015
L06C2    dec   <u0029
         bne   L06D8
         bsr   L0701
         tst   <u0028
         bne   L06D2
         ldx   <u0034
         leax  $01,x
         stx   <u0034
L06D2    clr   <u0028
         lda   <F.Bit
         sta   <u0029
L06D8    ldb   <F.Cnt
         ldx   <F.Cnt+1
         leax  $01,x
         bne   L06E1
         incb  
L06E1    cmpb  <F.Tot
         bcs   L06E9
         cmpx  <F.Tot+1
         bcc   L06F0
L06E9    stb   <F.Cnt
         stx   <F.Cnt+1
         lbra  L064B
L06F0    lda   #$FF
         sta   <u0028
         leay  >Optbuf,u
L06F8    cmpy  <F.Pnt
         beq   pnogsf
         bsr   L0701
         bra   L06F8

L0701    ldx   <F.Pnt
         lda   <u0028
         rora  
         rol   ,x+
         inc   <F.Mcn
         lda   <F.Mcn
         cmpa  #$08
         bcs   L0723
         clr   <F.Mcn
         stx   <F.Pnt
         cmpx  <F.Max
         bne   L0723
         bsr   L0780
         leax  >Optbuf,u
         stx   <F.Pnt
         lbsr  clrsec
L0723    rts   

L0724    tfr   a,b
         lsra  
         lsra  
         lsra  
         lsra  
         andb  #$0F
         addd  #$3030
         cmpa  #$39
         bls   L0735
         adda  #$07
L0735    cmpb  #$39
         bls   L073B
         addb  #$07
L073B    rts   

* Print out the number of good sectors
pnogsf   lbsr  linend
         leax  >gdsect,pcr
         ldy   #$0019
         lbsr  prntln
         ldb   <F.Bit
         clra  
         ldx   <u0034
         pshs  x,a
L0751    lsrb  
         bcs   L075C
         lsl   $02,s
         rol   $01,s
         rol   ,s
         bra   L0751
L075C    puls  x,a
         ldb   #$0D
         pshs  b
         tfr   d,y
         tfr   x,d
         tfr   b,a
         bsr   L0724
         pshs  b,a
         tfr   x,d
         bsr   L0724
         pshs  b,a
         tfr   y,d
         bsr   L0724
         pshs  b,a
         tfr   s,x
         lbsr  print
         leas  $07,s
         rts   

L0780    pshs  y
         clra  
         ldb   #$01
         cmpd  <F.Bms
         bne   L079B
         leax  >Optbuf,u
         clra  
         ldb   <u002D
         tfr   d,y
         clrb  
         os9   F$AllBit 
         lbcs  rptbss
L079B    lbsr  seksec
         leax  >Optbuf,u
         lbsr  wrtsec
         ldd   <F.Tot
         cmpd  <F.Cnt
         bcs   L07B7
         bhi   L07B4
         ldb   <F.Tot+2
         cmpb  <F.Cnt+2
         bcc   L07B7
L07B4    lbsr  L084B
L07B7    ldd   <F.Bms
         addd  #$0001
         std   <F.Bms
         puls  pc,y

* Write the root dir structure
* Reserve space for boot sectors?
fdsnok   ldd   #$0010
         addd  <F.Bms
         std   <F.Bms
         bsr   seksec
* Write the file descriptor for the root directory
         leax  >Fdtbuf,u
         bsr   clrsec
         leax  >Fdtbuf+FD.DAT,u
         os9   F$Time   
         leax  >Fdtbuf,u
         lda   #^SHARE.
         sta   FD.ATT,x
         lda   #$02         Set link count to 2
         sta   FD.LNK,x
         clra  
         ldb   #DIR.SZ*2
         std   FD.SIZ+2,x   Directory size is 64 bytes
         ldb   <F.Das
         decb  
         stb   FD.SEG+FDSL.B+1,x
         ldd   <F.Bms
         addd  #1
         std   FD.SEG+FDSL.A+1,x
         bsr   wrtsec
* Write the directory entries
         bsr   clrbuf
         ldd   #'.*256+'.+128    '..
         std   ,x
         stb   <DIR.SZ,x    Store '.' at the next entry
         ldd   <F.Bms
         std   <DIR.FD+1,x
         std   <DIR.FD+1+DIR.SZ,x
         bsr   wrtsec

* Write the empty sectors of the directory
         bsr   clrbuf
         ldb   <F.Das
L080F    decb  
         bne   L0813
         rts   

L0813    pshs  b
         bsr   wrtsec
         puls  b
         bra   L080F

* Clear the sector buffer
clrbuf   leax  >Secbuf,u
clrsec   clra  
         clrb  
L0821    sta   d,x
         decb  
         bne   L0821
         rts   

* Write sector
wrtsec   lda   <F.Opn
         ldy   #PAGE
         os9   I$Write  
         lbcs  fexout
         rts   

* Seek past bitmap sectors
seksec   clra  
         ldb   <F.Bms
         tfr   d,x
         lda   <F.Bms+1
         clrb  
         tfr   d,u
sekopn   lda   <F.Opn
         os9   I$Seek   
         ldu   <F.Dma
         lbcs  fexout
         rts   
L084B    ldx   <F.Cnt
         lda   <F.Cnt+2
         clrb  
         addd  #PAGE
         tfr   d,u
         bcc   sekopn
         leax  1,x
         bra   sekopn
         ldd   ,y
         leau  >Secbuf,u
         leax  >dcnums,pcr
         ldy   #PDELIM*256+C$SPAC
L0869    leay  >$0100,y
         subd  ,x
         bcc   L0869
         addd  ,x++
         pshs  b,a
         ldd   ,x
         tfr   y,d
         beq   L0891
         ldy   #PDELIM*256+'0
         cmpd  #'0*256+C$SPAC
         bne   L088B
         ldy   #PDELIM*256+C$SPAC
         tfr   b,a
L088B    sta   ,u+
         puls  b,a
         bra   L0869

L0891    sta   ,u+
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
L08B2    bsr   L08C2
         bcs   L08BC
         bne   L08B2
         std   <F.Val
         bne   L08C1
L08BC    ldd   #$0001
         std   <F.Val
L08C1    rts   

L08C2    pshs  y,b,a
         ldb   ,x+
         subb  #$30
         cmpb  #$0A
         bcc   L08E0
         lda   #$00
         ldy   #$000A
L08D2    addd  ,s
         bcs   L08DE
         leay  -$01,y
         bne   L08D2
         std   ,s
         andcc #$FB
L08DE    puls  pc,y,b,a
L08E0    orcc  #$04
         puls  pc,y,b,a
usermg    lda   #$02
         os9   F$PErr   
         leax  <useopt,pcr
         ldy   #340
         lda   #$02
         os9   I$WritLn 
         clrb  
         os9   F$Exit   

progvers fcb   $0A
         fcc   "DRAGON FORMAT UTILITY"
justcr   fcb   $0D

useopt   fcc   "Use: FORMAT /devname <opts>"
         fcb   $0A
         fcc   /  opts: R  - Ready/
         fcb   $0A
         fcc   /        "disk name"/
         fcb   $0A
         fcb   $0D

formatgo fcc   /Formatting drive /
formaten equ   *

prompt   fcc   /y (yes) or n (no)/
         fcb   $0A
         fcc   /Ready?  /
prmptend equ   *

L097F    fcc   /ABORT Interleave value out of range/
         fcb   $0D
namask   fcc   /Disk name: /
namasken equ   *
         fcc   /How many Cylinders (Tracks?) : /
syscbd   fcc   /Bad system sector, /
fabort   fcc   /FORMAT ABORTED/
         fcb   $0D
clsmme   fcc   /Cluster size mismatch/
         fcb   $0D
         fcc   /Double density? Change from 96tpi to 48tpi? /
         fcc   /Double sided? /
gdsect   fcc   /Number of good sectors: $/
L0A58    fcc   /Both PHYSICAL and LOGICAL format? /
askver    fcc   /Physical Verify desired? /

         emod
eom      equ   *
