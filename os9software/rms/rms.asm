         nam   rms
         ttl   Record Management System

         ifp1
         use   defsfile
         endc
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   eom,name,tylg,atrv,start,size
u0000    rmb   2
u0002    rmb   2
u0004    rmb   2  Start of parameter area
FD.RMS    rmb   1  path to .RMS file
FD.DIC    rmb   1  path to DIC file
u0008    rmb   1   path to NDX file
u0009    rmb   2
u000B    rmb   2
u000D    rmb   2
u000F    rmb   2
u0011    rmb   2
u0013    rmb   2
u0015    rmb   2
u0017    rmb   2
u0019    rmb   2   input buffer
u001B    rmb   2
u001D    rmb   2
u001F    rmb   2
u0021    rmb   2
u0023    rmb   1
u0024    rmb   2
u0026    rmb   2
u0028    rmb   1
u0029    rmb   1
u002A    rmb   1
u002B    rmb   1
u002C    rmb   1
u002D    rmb   1
u002E    rmb   1
u002F    rmb   1
u0030    rmb   2
u0032    rmb   1
u0033    rmb   5
u0038    rmb   2
u003A    rmb   1   Screen rows
u003B    rmb   1   Screen width
u003C    rmb   1
u003D    rmb   3
u0040    rmb   10
u004A    rmb   1
u004B    rmb   7
u0052    rmb   28 Ring bell
u006E    rmb   1
LEAD.IN    rmb   3   address $6F
u0072    rmb   1
u0073    rmb   1
u0074    rmb   1
u0075    rmb   1
u0076    rmb   1
u0077    rmb   1
u0078    rmb   1
u0079    rmb   1
u007A    rmb   1
u007B    rmb   1
u007C    rmb   1
u007D    rmb   1
u007E    rmb   1
u007F    rmb   1
u0080    rmb   1
u0081    rmb   1
u0082    rmb   1
u0083    rmb   1
u0084    rmb   1
u0085    rmb   1
u0086    rmb   1
u0087    rmb   1
u0088    rmb   1
u0089    rmb   1
u008A    rmb   1
u008B    rmb   1
u008C    rmb   1
u008D    rmb   1
LEAD.OUT    rmb   2  Address $8E
u0090    rmb   2
u0092    rmb   1
u0093    rmb   1
u0094    rmb   1
u0095    rmb   1
u0096    rmb   1
u0097    rmb   7
u009E    rmb   1
u009F    rmb   2
u00A1    rmb   11
u00AC    rmb   1
u00AD    rmb   1
u00AE    rmb   1
u00AF    rmb   4
u00B3    rmb   1
u00B4    rmb   1
u00B5    rmb   2
u00B7    rmb   3
u00BA    rmb   2
u00BC    rmb   68
u0100    rmb   44
u012C    rmb   7796
size     equ   .
name     equ   *
         fcs   /rms/
         fcb   $01

start    equ   *
         leau  >$100,u
         stu   <u00B5  Buffer for 2x getstat/setstat
         leau  <$040,u
         stu   <u00BA
         stu   <u009F
         leau  >$12C,u
         stu   <u00BC
         stu   <u0000
         stx   <u0004  Start of parameter area
         leax  >-$00A0,x
         stx   <u0002
         clr   <u00B4
         clr   <u0038
         clr   <u002A
         clr   <u002B
         clr   <u00A1
         leax  >L0041,pcr
         os9   F$Icpt
         bra   L0042

L0041    rti

L0042    ldd   #$0000
         ldx   <u00B5
         os9   I$GetStt
         ldx   <u00B5
         leay  <$20,x
         ldb   #$20
L0051    lda   ,x+
         sta   ,y+
         decb
         bne   L0051
         ldx   <u00B5
         leax  <$20,x
         ldd   #$0000
         clr   PD.EKO-PD.OPT,x
         clr   PD.ALF-PD.OPT,x
         clr   $07,x
         std   $09,x
         std   $0B,x
         std   $0D,x
         std   PD.PSC-PD.OPT,x
         std   PD.QUT-PD.OPT,x
         clr   PD.OVF-PD.OPT,x
         os9   I$SetStt
         leax  >TRMFILE,pcr  "RMS.TRM"
         lda   #READ.
         os9   I$Open
         bcc   L008F
         leax  >TRMFILE,pcr  "RMS.TRM"
         lda   #PEXEC.+READ.
         os9   I$Open
         lbcs  L09D0   error

* Parse the rms.trm file
L008F    sta   <u0092
         tfr   dp,a
         ldb   #$3A
         tfr   d,x
         stx   <u0093
         lda   #$58
         sta   <u0095
L009D    bsr   L00DD   Read one byte
         cmpa  #'*
         bne   L00AB

* Read comment until EOL
L00A3    bsr   L00DD   read byte into A
         cmpa  #$0D
         bne   L00A3
         bra   L009D

L00AB    cmpa  #$0D    Is it a CR?
         beq   L009D
         cmpa  #$20    Space starts a comment to EOL
         beq   L00A3
         cmpa  #'A
         bcs   L00B9
         suba  #$07
L00B9    lsla
         lsla
         lsla
         lsla
         sta   <u0096
         bsr   L00DD   read byte into A
         cmpa  #'0
         lbcs  L09D0   error
         cmpa  #'A
         bcs   L00CD
         suba  #$07
L00CD    anda  #$0F
         adda  <u0096
         ldx   <u0093
         sta   ,x+
         stx   <u0093
         dec   <u0095
         bne   L009D
         bra   L00F4

* Read one byte into A
L00DD    ldy   #$0001
         ldx   <u0002   keyboard buffer
         lda   <u0092
         os9   I$Read
         lbcs  L09D0   error
         ldx   <u0002   keyboard buffer
         lda   ,x
         lbsr  L1338  make upper case
         rts

L00F4    lda   <u0092
         os9   I$Close
         ldx   <u0000
         stx   <u0092
         lbsr  L01E9
         stx   <u0094
         lda   #'.
         ldb   #'R
         std   ,x
         lda   #'M
         ldb   #'S
         std   $02,x
         clr   $04,x
         leax  $05,x
         stx   <u0000
         ldx   <u0092
         lda   #$43
         os9   I$Open
         lbcs  L0951
         sta   <FD.RMS  path to .RMS file
         tfr   dp,a
         ldb   #$2F   set address of buffer
         tfr   d,x
         ldy   #$0005
         lda   <FD.RMS  path to .RMS file
         os9   I$Read
         lbcs  L095D
         lda   <u002F
         cmpa  #$55   Magic number?
         lbne  L0963
         ldd   <u0032  Size of record
         cmpd  #$0003  under 3 bytes?
         lble  L0963
         cmpd  #$0400  over $400 bytes
         lbhi  L0963
         lda   #$FF
         ldb   <u0030
         bmi   L015C
         lda   #$7F
         bitb  #$40
         bne   L015C
         lda   #$3F
L015C    sta   <u00B3
         ldd   <u0000
         std   <u000D
         addd  #$03E8
         std   <u000F
         addd  #$03E8
         std   <u0011
         addd  <u0032
         std   <u0013
         tst   <u008C
         beq   L0176
         addd  <u0032
L0176    std   <u0015
         addd  <u0032
         std   <u0017
         tst   <u008C
         beq   L0182
         addd  <u0032
L0182    std   <u0019
         addd  <u0032
         std   <u0000
         cmpd  <u0002   keyboard buffer
         lbcc  L099A
         ldx   <u0094
         lda   #'.
         ldb   #'D
         std   ,x
         lda   #'I
         ldb   #'C
         std   $02,x
         clr   $04,x
         ldx   <u0092
         lda   #$41
         os9   I$Open
         lbcs  L0957
         sta   <FD.DIC  path to DIC file
         clr   <u00B7
         clr   <u0008   path to NDX file
         ldx   <u0000
         lbsr  L01E9
         bne   L01D2
         lda   #'.
         ldb   #'N
         std   0,x
         lda   #'D
         ldb   #'X
         std   2,x
         clr   4,x
         ldx   <u0000
         lda   #$01
         os9   I$Open
         lbcs  L096F
         sta   <u0008   path to NDX file
L01D2    ldx   <u000D
         lda   #$01
         sta   <u0038
         bsr   L0228
         ldx   <u000D
         lda   ,x
         lbeq  L0969
         ldx   <u000F
         bsr   L0228
         lbra  L09D6
L01E9    ldy   <u0004  Start of parameter area
L01EC    lda   ,y
         cmpa  #$0D
         bne   L01F5
         lda   #$01
         rts
L01F5    cmpa  #$20
         beq   L01FD
         cmpa  #',
         bne   L0201
L01FD    leay  $01,y
         bra   L01EC
L0201    ldb   #$50
L0203    lda   ,y
         cmpa  #$0D
         beq   L021A
         cmpa  #',
         beq   L0218
         cmpa  #$20
         bls   L0218
         leay  $01,y
         sta   ,x+
         decb
         bne   L0203
L0218    leay  $01,y
L021A    sty   <u0004  Start of parameter area
         lda   #$00
         rts

TRMFILE  fcs   "RMS.TRM"
         fcb   $0D

L0228    stx   <u001F
         clr   ,x
         stx   <u001D
L022E    lbsr  L056C
         lbne  L04D8
         cmpa  #$20
         beq   L022E
         cmpa  #$0D
         bne   L0241
         inc   <u0038
         bra   L022E
L0241    cmpa  #$22
         lbne  L0975
         clr   <u0092
         ldd   <u0000
         std   <u0093
         std   <u000B
         ldx   <u001D
         cmpx  <u000F
         beq   L0257
         std   <u0009
L0257    lbsr  L056C
         lbne  L0975
         cmpa  #$22
         beq   L0271
         inc   <u0092
         ldx   <u0093
         sta   ,x+
         stx   <u0093
         cmpx  <u0002   keyboard buffer
         bcs   L0257
         lbra  L099A
L0271    ldx   <u0093
         clr   ,x+
         stx   <u0000
         clr   <u0092
L0279    lda   <u0092
         cmpa  #$31
         lbgt  L097B
L0281    lbsr  L056C
         lbne  L04D8
         cmpa  #$20
         beq   L0281
         cmpa  #';
         beq   L0281
         cmpa  #$0D
         bne   L0298
         inc   <u0038
         bra   L0281
L0298    cmpa  #'$
         lbeq  L04D8
         ldx   <u001D
         stx   <u0093
         clr   <u0095
         clr   $01,x
         clr   $02,x
         clr   $03,x
         clr   $04,x
         clr   $05,x
         clr   $06,x
         clr   $07,x
         clr   $0F,x
L02B4    ldx   <u0093
         lbsr  L1338  make upper case
         sta   ,x+
         stx   <u0093
         inc   <u0095
         lda   <u0095
         cmpa  #$08
         beq   L02DC
         lbsr  L056C
L02C8    lbne  L0981
         cmpa  #$20
         beq   L02EF
         cmpa  #',
         beq   L02EF
         cmpa  #$0D
         bne   L02B4
         inc   <u0038
         bra   L02EF
L02DC    lbsr  L056C
         bne   L02C8
         cmpa  #$20
         beq   L02EF
         cmpa  #',
         beq   L02EF
         cmpa  #$0D
         bne   L02DC
         inc   <u0038
L02EF    clr   <u0093
L02F1    lbsr  L056C
         bne   L02C8
         cmpa  #$20
         beq   L02F1
         cmpa  #';
         beq   L02F1
         cmpa  #$0D
         bne   L0306
         inc   <u0038
         bra   L02F1
L0306    cmpa  #'0
         blt   L0334
         cmpa  #'9
         bgt   L0334
         anda  #$0F
         sta   <u0094
         lda   <u0093
         cmpa  #$19
         bgt   L0334
         ldb   #$0A
         mul
         addb  <u0094
         stb   <u0093
         lbsr  L056C
         bne   L0334
         cmpa  #',
         beq   L0337
         cmpa  #$20
         beq   L0337
         cmpa  #$0D
         bne   L0306
         inc   <u0038
         bra   L0337
L0334    lbra  L0988
L0337    lda   <u0093
         beq   L0334
         ldx   <u001D
         sta   $08,x
L033F    lbsr  L056C
         bne   L0367
         lbsr  L1338  make upper case
         cmpa  #',
         beq   L033F
         cmpa  #$20
         beq   L033F
         cmpa  #$0D
         bne   L0357
         inc   <u0038
         bra   L033F
L0357    cmpa  #'D
         beq   L036A
         cmpa  #'M
         beq   L0376
         cmpa  #'A
         beq   L0385
         cmpa  #'N
         beq   L0385
L0367    lbra  L098E
L036A    ldx   <u001D
         ldb   $08,x
         cmpb  #$08
         lbne  L09A0
         bra   L0385
L0376    ldx   <u001D
         ldb   $08,x
         cmpb  #$03
         bgt   L0385
         leax  >L0891,pcr
         lbra  L08FC
L0385    ldx   <u001D
         sta   $09,x
         clr   $0A,x
         lbsr  L056C
         bne   L0367
         cmpa  #'*
         bne   L039A
         lda   #$FF
         ldx   <u001D
         sta   $0A,x
L039A    lbsr  L056C
         lbne  L0994
         cmpa  #$0D
         bne   L03A9
         inc   <u0038
         bra   L039A
L03A9    cmpa  #$20
         beq   L039A
         cmpa  #',
         beq   L039A
         cmpa  #'"
         lbne  L0994
         ldx   <u001D
         ldd   <u0000
         std   $0B,x
         clr   $0D,x
L03BF    lbsr  L056C
         lbne  L0994
         cmpa  #$0D
         bne   L03CE
         inc   <u0038
         bra   L03BF
L03CE    cmpa  #'"
         beq   L03E5
         ldx   <u0000
         cmpx  <u0002   keyboard buffer
         bcs   L03DB
L03D8    lbra  L099A
L03DB    sta   ,x+
         stx   <u0000
         ldx   <u001D
         inc   $0D,x
         bra   L03BF
L03E5    ldx   <u0000
         cmpx  <u0002   keyboard buffer
         bcc   L03D8
         clr   ,x+
         stx   <u0000
L03EF    lbsr  L056C
         beq   L03FB
L03F4    leax  >L0738,pcr
         lbra  L08FC
L03FB    cmpa  #$0D
         bne   L0403
         inc   <u0038
         bra   L03EF
L0403    cmpa  #$20
         beq   L03EF
         cmpa  #',
         beq   L03EF
         cmpa  #';
         lbeq  L04CC
         cmpa  #'[
         beq   L0424
         cmpa  #'(
         beq   L0462
         cmpa  #'<
         beq   L046C
         leax  >L0713,pcr invalid validator type
         lbra  L08FC
L0424    lda   #']
         sta   <u0093
         ldx   <u001D
         lda   #$02
L042C    sta   $0F,x
         ldd   <u0000
         std   <$10,x
L0433    lbsr  L056C
         beq   L043B
L0438    lbra  L09A6
L043B    cmpa  #$0D
         bne   L0443
         inc   <u0038
         bra   L0433
L0443    cmpa  <u0093
         beq   L0456
         ldx   <u0000
         cmpx  <u0002   keyboard buffer
         bcs   L0450
L044D    lbra  L099A
L0450    sta   ,x+
         stx   <u0000
         bra   L0433
L0456    ldx   <u0000
         cmpx  <u0002   keyboard buffer
         bcc   L044D
         clr   ,x+
         stx   <u0000
         bra   L04B3
L0462    lda   #$29
         sta   <u0093
         ldx   <u001D
         lda   #$01
         bra   L042C
L046C    ldx   <u001D
         lda   #$04
         sta   $0F,x
         clr   <$10,x
L0475    lbsr  L056C
         lbne  L09A6
         cmpa  #$0D
         bne   L0485
         inc   <u0038
         lbra  L0475
L0485    cmpa  #'>
         beq   L04A8
         cmpa  #'0
         lblt  L0438
         cmpa  #'9
         lbgt  L0438
         anda  #$0F
         sta   <u0093
         ldx   <u001D
         lda   <$10,x
         ldb   #$0A
         mul
         addb  <u0093
         stb   <$10,x
         bra   L0475
L04A8    ldx   <u001D
         lda   <$10,x
         cmpa  $08,x
         lbhi  L09AC
L04B3    lbsr  L056C
         lbne  L03F4
         cmpa  #$0D
         bne   L04C2
         inc   <u0038
         bra   L04B3
L04C2    cmpa  #$20
         beq   L04B3
         cmpa  #';
         lbne  L03F4
L04CC    ldx   <u001D
         leax  <$14,x
         stx   <u001D
         inc   <u0092
         lbra  L0279
L04D8    ldx   <u001D
         clr   ,x
         ldx   <u001F
         ldy   #$0000
L04E2    tst   ,x
         beq   L04F9
         lda   $08,x
         bita  #$80
         beq   L04F2
         anda  #$7F
         leay  >$0080,y
L04F2    leay  a,y
         leax  <$14,x
         bra   L04E2
L04F9    leay  $02,y
         cmpy  <u0032
         lbhi  L09BE
         ldx   <u001F
         clr   <u0092
         lda   #$03
         sta   <u0093
L050A    lda   ,x
         beq   L055A
         lda   $08,x
         adda  $0D,x
         adda  <u006E
         adda  <u006E
         sta   <u0095
         lda   <u0092
         beq   L052A
         lda   <u003B   Screen width
         suba  <u0092
         bls   L0526
         suba  <u0095
         bcc   L052A
L0526    inc   <u0093
         clr   <u0092
L052A    lda   <u0093
         sta   $0D,x
         lda   <u0092
         sta   $0E,x
         lda   <u0095
         adda  <u0092
L0536    cmpa  <u003B   Screen width
         bcs   L0540
         suba  <u003B   Screen width
         inc   <u0093
         bra   L0536
L0540    cmpa  #$00
         beq   L0552
         tst   <u006E
         bne   L0552
         adda  #$01
         cmpa  <u003B   Screen width
         bcs   L0552
         suba  <u003B   Screen width
         inc   <u0093
L0552    sta   <u0092
         leax  <$14,x
         lbra  L050A

L055A    lda   <u0093
         cmpa  <u003A   Screen rows
         bgt   L0568
         bne   L056B
         lda   <u0092
         cmpa  <u003B   Screen width
         blt   L056B
L0568    lbra  L09C4   Go to error "dictionary too long for screen"
L056B    rts

* Read a byte into reg. A
L056C    pshs  x
         tst   <u00B4
         bne   L0586
         ldy   #$0001
         ldx   <u0019  input buffer
         lda   <FD.DIC  path to DIC file
         os9   I$Read
         bcs   L0586
         ldx   <u0019
         lda   ,x
         clrb
         puls  pc,x

L0586    lda   #$01
         sta   <u00B4
         puls  pc,x

L058C    fcc   "INVALID FILE NAME@"
L059E    fcc   "CAN'T OPEN .RMS FILE@"
L05B3    fcc   "CAN'T OPEN .DIC FILE@"
L05C8    fcc   "RMS FILE IO ERROR@"
L05DA    fcc   "INVALID RMS FILE PREFIX@"
L05F2    fcc   "NO PRIMARY DICTIONARY@"
L0608    fcc   "CAN'T OPEN INDEX FILE@"
L061E    fcc   "INVALID TITLE IN DICTIONARY@"
L063A    fcc   "TOO MANY FIELDS IN DICTIONARY@"
L0658    fcc   "INVALID FIELD NAME IN DICTIONARY@"
L0679    fcc   "INVALID FIELD LENGTH IN DICTIONARY@"
L069C    fcc   "INVALID TYPE CODE IN DICTIONARY@"
L06BC    fcc   "INVALID PROMPT IN DICTIONARY@"
L06D9    fcc   "INSUFFICIENT MEMORY@"
L06ED    fcc   "DATE FIELD NOT LENGTH 8 IN DICTIONARY@"
L0713    fcc   "INVALID VALIDATOR TYPE IN DICTIONARY@"
L0738    fcc   "MISSING ; IN DICTIONARY@"
L0750    fcc   "INVALID VALIDATOR IN DICTIONARY@"
L0770    fcc   "VALIDATOR LENGTH OVER FIELD LENGTH, IN DICTIONARY@"
L07A2    fcc   "INVALID VALIDATOR LOOK UP FILE IN DICTIONARY@"
L07CF    fcc   "CAN'T OPEN VALIDATOR FILE IN DICTIONARY@"
L07F7    fcc   "TOTAL FIELD LENGTHS OVER RECORD LENGTH@"
L081E    fcc   "DICTIONARY TOO LONG FOR SCREEN@"
L083D    fcc   "KEY FIELD DIFFERENT IN PRIMARY AND SECONDARY DICT@"
L086F    fcc   "SECONDARY DICT HAS ONLY ONE FIELD@"
L0891    fcc   "MONEY FIELD LESS THAN LENGTH 4 IN DICTIONARY@"
L08BE    fcc   "CAN'T ACCESS RMS.TRM FILE@"
L08D8    fcc   "CAN'T CREATE SEQUENTIAL OUTPUT FILE@"

L08FC    lda   #$0A
         bsr   OUTCH
L0900    lda   ,x+
         cmpa  #'@
         beq   L090A
L0906    bsr   OUTCH
         bra   L0900
L090A    lda   <u0038
         beq   L093D
         leax  >L091A,pcr   line
L0912    lda   ,x+
         beq   L0921
         bsr   OUTCH
         bra   L0912

L091A    fcc   " LINE "
         fcb   0

* Output decimal number
L0921    lda   <u0038
         clrb
L0924    cmpa  #10
         blt   L092D
         suba  #10
         incb
         bra   L0924
L092D    std   <u0092
         lda   <u0093
L0931    beq   L0937
         ora   #$30
         bsr   OUTCH
L0937    lda   <u0092
L0939    ora   #$30
         bsr   OUTCH
L093D    lda   #$0A
         bsr   OUTCH
         lda   #$0D
         bsr   OUTCH
         lbra  L0BE7

OUTCH    lbra  XOUTCH

         leax  >L058C,pcr  - invalid file name
         bra   L08FC

L0951    leax  >L059E,pcr  - can't open .RMS file
         bra   ERRMSG
L0957    leax  >L05B3,pcr  - can't open .DIC file
         bra   ERRMSG
L095D    leax  >L05C8,pcr
         bra   ERRMSG
L0963    leax  >L05DA,pcr
         bra   ERRMSG
L0969    leax  >L05F2,pcr
         bra   ERRMSG
L096F    leax  >L0608,pcr
         bra   ERRMSG
L0975    leax  >L061E,pcr
         bra   ERRMSG
L097B    leax  >L063A,pcr
         bra   ERRMSG
L0981    leax  >L0658,pcr

ERRMSG   lbra  L08FC

L0988    leax  >L0679,pcr
         bra   ERRMSG
L098E    leax  >L069C,pcr
         bra   ERRMSG
L0994    leax  >L06BC,pcr
         bra   ERRMSG
L099A    leax  >L06D9,pcr
         bra   ERRMSG
L09A0    leax  >L06ED,pcr
         bra   ERRMSG
L09A6    leax  >L0750,pcr
         bra   ERRMSG
L09AC    leax  >L0770,pcr
         bra   ERRMSG
         leax  >L07A2,pcr
         bra   ERRMSG
         leax  >L07CF,pcr
         bra   ERRMSG
L09BE    leax  >L07F7,pcr
         bra   ERRMSG
L09C4    leax  >L081E,pcr   dictionary too long for screen
         bra   ERRMSG
L09CA    leax  >L083D,pcr
         bra   ERRMSG
L09D0    leax  >L08BE,pcr  can't access rms.trm file
         bra   ERRMSG
L09D6    ldx   <u000D
         ldy   <u000F
         lda   ,y
         beq   L09EA
         lda   #$0A
L09E1    ldb   ,x+
         cmpb  ,y+
         bne   L09CA
         deca
         bne   L09E1
L09EA    ldx   <u0011
         leax  $01,x
         stx   <u0092
         ldx   <u000D
         bsr   L09F6
         bra   L0A0C
L09F6    lda   ,x
         beq   L0A0B
         ldd   <u0092
         std   <$12,x
         clra
         ldb   $08,x
         addd  <u0092
         std   <u0092
         leax  <$14,x
         bra   L09F6
L0A0B    rts

L0A0C    ldx   <u0015
         leax  $01,x
         stx   <u0092
         ldx   <u000F
         bsr   L09F6
         lda   <FD.DIC  path to DIC file
         os9   I$Close
         ldy   <u000F
         lda   ,y
         beq   L0A2E
         lda   <$14,y
         bne   L0A2E
         leax  >L086F,pcr   secondary dict has only one field
         lbra  L08FC

L0A2E    ldd   #$2020
         ldx   <u0011
L0A33    std   ,x++
         cmpx  <u0019
         bne   L0A33
         tfr   dp,a
         ldb   #$5F  Init sequence
         tfr   d,x
L0A3F    lda   ,x+
         cmpa  #$FF Stop at FF
         beq   L0A4A
         lbsr  XOUTCH
         bra   L0A3F
L0A4A    clra
         lbra  L0B42

* Keyboard entry parsing
L0A4E    clr   <u0029
         lbsr  L19EC   read from keyboard
         cmpa  <LEAD.IN  Match first char in lead-in
         beq   L0AB8 ..yes
         cmpa  <u0072   CR entered?
         lbeq  L0BF8
         cmpa  <u0074   backspace entered?
         lbeq  L0C74
         cmpa  <u0078  tab backward?
         lbeq  L0CA6
         cmpa  <u0076  tab forward?
         lbeq  L0BF8
         cmpa  <u007A  Quit?
         lbeq  L0BE4 .. yes
         cmpa  <u008C
         lbeq  L0DDF
         cmpa  <u007C  Clear screen?
         lbeq  L0B42  yes
         cmpa  <u0080
         lbeq  L0E86
         cmpa  <u0082
         lbeq  L0F28
         cmpa  <u0086
         lbeq  L0F93
         cmpa  <u0084  FEED key
         lbeq  L10A7
         cmpa  <u0088  Home key
         lbeq  L0C62
         cmpa  <u008A  Scan/scroll key
         lbeq  L11BD
         cmpa  <u007E  Find?
         lbeq  L0E0D  ..yes
         cmpa  #$20   is it space?
         lbcc  L0CB9
L0AB1    lda   <u0052  Ring bell
         lbsr  XOUTCH
         bra   L0A4E  get next char
* Parse lead-in/lead-out
L0AB8    tst   <LEAD.IN+1  lead-in char+1
         beq   L0ACE
         lbsr  L19EC   read from keyboard
         cmpa  <LEAD.IN+1
         bne   L0AB1
         tst   <LEAD.IN+2  lead-in char+2
         beq   L0ACE
         lbsr  L19EC   read from keyboard
         cmpa  <LEAD.IN+2
         bne   L0AB1
L0ACE    lbsr  L19EC   read from keyboard
         pshs  a
         tst   <LEAD.OUT  lead-out
         beq   L0AE9
         lbsr  L19EC   read from keyboard
         cmpa  <LEAD.OUT
         bne   L0AB1
         tst   <LEAD.OUT+1  lead-out+1
         beq   L0AE9
         lbsr  L19EC   read from keyboard
         cmpa  <LEAD.OUT+1  lead-out+1
         bne   L0AB1   ring bell
L0AE9    puls  a
         cmpa  <u0073  CR key+1
         lbeq  L0BF8
         cmpa  <u0075  BS key+1
         lbeq  L0C74
         cmpa  <u0079  tab back+1
         lbeq  L0CA6
         cmpa  <u0077  tab forward+1
         lbeq  L0BF8
         cmpa  <u007B
         lbeq  L0BE4
         cmpa  <u008D
         lbeq  L0DDF
         cmpa  <u007D
         lbeq  L0B42
         cmpa  <u0081
         lbeq  L0E86
         cmpa  <u0083
         lbeq  L0F28
         cmpa  <u0087
         lbeq  L0F93
         cmpa  <u0085
         lbeq  L10A7
         cmpa  <u0089
         lbeq  L0C62
         cmpa  <u008B
         lbeq  L11BD
         cmpa  <u007F
         lbeq  L0E0D
         lbra  L0AB1   ring bell

* Clear form
L0B42    tst   <u00A1
         beq   L0B53
         leax  >L15EE,pcr to clear without save type Y
         lbsr  L12E2
         cmpa  #$59
         lbne  L0A4E
L0B53    clr   <u00A1
         clr   <u0028
         lda   #$01
         sta   <u0023
         ldx   <u0011
         ldy   <u0032
         leay  -$01,y
         lda   #$20
L0B64    leax  $01,x
         leay  -$01,y
         beq   L0B6E
         sta   ,x
         bra   L0B64

L0B6E    lda   #$0D
         sta   ,x
         bsr   L0B76
         bra   L0B8C
L0B76    lbsr  L0BC9   Clear screen
         lda   <u004A
         bsr   L0BC2
         bsr   L0BBA
         ldx   <u0009
L0B81    lda   ,x+
         beq   L0B89
         bsr   L0BC2
         bra   L0B81
L0B89    bsr   L0BBE
         rts

L0B8C    ldx   <u000D
         stx   <u001D
L0B90    ldx   <u001D
         lda   ,x
         beq   L0BAE
         lbsr  L0C1A
         ldx   <u001D
         lda   $08,x
         sta   <u0092
L0B9F    lda   <u003C
         bsr   L0BC2
         dec   <u0092
         bne   L0B9F
         leax  <$14,x
         stx   <u001D
         bra   L0B90
L0BAE    ldx   <u000D
         stx   <u0024
         stx   <u001D
         lbsr  L0C0A
         lbra  L0A4E

L0BBA    ldb   #$53   Dimmed address
         bra   L0BCF
L0BBE    ldb   #$59   Brite address
         bra   L0BCF

L0BC2    lbra  XOUTCH

L0BC5    ldb   #$4C   Sequence for move right
         bra   L0BCF

L0BC9    ldb   #$3E   Sequence for clear
         bra   L0BCF

L0BCD    ldb   #$44   Sequence for home
* Output up to 6 bytes
L0BCF    pshs  x,b
         tfr   dp,a
         tfr   d,x
         ldb   #$06
L0BD7    lda   ,x+
         beq   L0BE1
         lbsr  XOUTCH
         decb
         bne   L0BD7
L0BE1    puls  x,b
         rts

* Quit
L0BE4    lbsr  L0BC9
L0BE7    lda   <FD.DIC  path to DIC file
         lbsr  WRIBUF
         ldx   <u00B5
         ldd   #$0000
         os9   I$SetStt
         clrb
         os9   F$Exit

L0BF8    ldx   <u0024
         leax  <$14,x
         stx   <u0024
         lda   ,x
         lbeq  L0C62
         bsr   L0C0A
         lbra  L0A4E

L0C0A    ldx   <u0024
         cmpx  <u000F
         bne   L0C15
         leax  <$14,x
         stx   <u0024
L0C15    ldd   <$12,x
         std   <u0021
L0C1A    lda   <u003D
         cmpa  #$A1
         bne   L0C35
         lda   #$1C
         bsr   L0C32
         lda   #$0B
         bsr   L0C32
         lda   $0D,x
         bsr   L0C32
         lda   $0E,x
         bsr   L0C32
         bra   L0C51

L0C32    lbra  XOUTCH

L0C35    lbsr  L0BCD
         lda   $0D,x
         sta   <u0092
L0C3C    lda   <u004A
         bsr   L0C32
         dec   <u0092
         bne   L0C3C
         lda   $0E,x
         beq   L0C51
         sta   <u0092
L0C4A    lbsr  L0BC5  Move right
         dec   <u0092
         bne   L0C4A
L0C51    lbsr  L0BBA
         ldx   $0B,x
L0C56    lda   ,x+
         beq   L0C5E
         bsr   L0C32
         bra   L0C56
L0C5E    lbsr  L0BBE
         rts

* Go to home
L0C62    ldx   <u000D
         lda   <u0023
         cmpa  #$01
         beq   L0C6C
         ldx   <u000F
L0C6C    stx   <u0024
         lbsr  L0C0A
         lbra  L0A4E
L0C74    ldx   <u0024
         ldx   <$12,x
         cmpx  <u0021
         beq   L0C99
         ldx   <u0021
         lda   #$20
         sta   ,x
         leax  -$01,x
         stx   <u0021
         lda   <u003C
         lbsr  XOUTCH
         lda   <u004B
         lbsr  XOUTCH
L0C91    lda   <u004B
         lbsr  XOUTCH
         lbra  L0A4E
L0C99    lda   #$20
         ldx   <u0021
         sta   ,x
         lda   <u003C
         lbsr  XOUTCH
         bra   L0C91
L0CA6    ldx   <u0024
         cmpx  <u000D
         lbeq  L0AB1
         leax  <-$14,x
         stx   <u0024
         lbsr  L0C0A
         lbra  L0A4E
L0CB9    sta   <u0092
         ldx   <u0024
         lda   $09,x
         cmpa  #$44
         lbeq  L0D65
         cmpa  #$4E
         beq   L0CFE
         cmpa  #$4D
         beq   L0D0F
L0CCD    ldx   <u0021
         ldb   <u0092
         subb  ,x
         lda   <u0092
         sta   ,x+
         lbsr  XOUTCH
         stx   <u0021
         ldx   <u0024
         cmpx  <u000D
         bne   L0CE8
         cmpb  #$00
         beq   L0CE8
         clr   <u0028
L0CE8    lda   $08,x
         ldx   <$12,x
         sta   <u00A1
L0CEF    leax  $01,x
         deca
         beq   L0CFB
         cmpx  <u0021
         bne   L0CEF
         lbra  L0A4E
L0CFB    lbra  L0BF8
L0CFE    lda   <u0092
         cmpa  #$20
         beq   L0CCD
         cmpa  #$30
         blt   L0D0C
         cmpa  #$39
         ble   L0CCD
L0D0C    lbra  L0AB1
L0D0F    lda   <u0092
         cmpa  #$20
         beq   L0D41
         cmpa  #$2E
         beq   L0D44
         cmpa  #$30
         blt   L0D0C
         cmpa  #$39
         bgt   L0D0C
         ldx   <u0024
         ldx   <$12,x
         cmpx  <u0021
         beq   L0D41
         leax  $01,x
         cmpx  <u0021
         beq   L0D41
         leax  $01,x
         beq   L0D41
         ldx   <u0021
         leax  -$03,x
         lda   ,x
         cmpa  #$2E
         bne   L0D41
L0D3E    lbra  L0AB1
L0D41    lbra  L0CCD
L0D44    ldx   <u0021
         lda   ,x
         cmpa  #$2E
         beq   L0D41
         ldx   <u0024
         ldb   $08,x
         ldx   <$12,x
L0D53    cmpx  <u0021
         beq   L0D41
         lda   ,x
         cmpa  #$2E
         beq   L0D3E
         leax  $01,x
         decb
         bne   L0D53
         lbra  L0D3E
L0D65    lda   <u0092
         cmpa  #$20
         bne   L0D6F
         lda   #$2F
         sta   <u0092
L0D6F    cmpa  #$2F
         beq   L0D9F
         cmpa  #$30
         blt   L0D3E
         cmpa  #$39
         bgt   L0D3E
         ldx   <u0024
         ldx   <$12,x
         leax  $02,x
         cmpx  <u0021
         beq   L0D8C
         leax  $03,x
         cmpx  <u0021
         bne   L0D9C
L0D8C    lda   #$2F
         ldx   <u0021
         sta   ,x+
         stx   <u0021
         lbsr  XOUTCH
         bra   L0D9C
         lbra  L0AB1
L0D9C    lbra  L0CCD
L0D9F    ldx   <u0024
         ldx   <$12,x
         leax  $01,x
         cmpx  <u0021
         bne   L0DCA
L0DAA    lda   <u004B
         lbsr  XOUTCH
         lda   #$30
         lbsr  XOUTCH
         ldx   <u0021
         leax  -$01,x
         lda   ,x
         sta   $01,x
         lbsr  XOUTCH
         lda   #$30
         sta   ,x
         leax  $02,x
         stx   <u0021
L0DC7    lbra  L0CCD
L0DCA    leax  $01,x
         cmpx  <u0021
         beq   L0DC7
         leax  $02,x
         cmpx  <u0021
         beq   L0DAA
         leax  $01,x
         cmpx  <u0021
         beq   L0DC7
         lbra  L0AB1
L0DDF    ldx   <u0024
         cmpx  <u000D
         bne   L0DE7
         clr   <u0028
L0DE7    lbsr  L0C0A
         ldx   <u0024
         ldb   $08,x
         stb   <u0092
         ldd   <$12,x
         tfr   d,x
         addd  <u0032
         tfr   d,y
L0DF9    lda   ,y+
         sta   ,x+
         pshs  y
         lbsr  XOUTCH
         puls  y
         dec   <u0092
         bne   L0DF9
         inc   <u00A1
         lbra  L0BF8

* Find record
L0E0D    clr   <u0028
         lda   <u0023
         cmpa  #$01
         beq   L0E1C
         lbsr  L0B76
         lda   #$01
         sta   <u0023
L0E1C    lbsr  L129F
         clr   <u00A1
L0E21    lbsr  L138B
         lbsr  L135A
         beq   L0E43
         ldy   <u0019
         lda   ,y
         cmpa  #$55
         bne   L0E3C
L0E32    leax  >L13E7,pcr  NOTFOUND
         lbsr  L12E2
         lbra  L0C62
L0E3C    lbsr  L1343
         beq   L0E21
         bra   L0E32
L0E43    lda   #$01
         sta   <u0028
         sta   <u0023
         ldx   <u0032
         stx   <u0092
         ldx   <u0019
         ldy   <u0011
L0E52    lda   ,x+
         sta   ,y+
         ldd   <u0092
         subd  #$0001
         std   <u0092
         bne   L0E52
         ldx   <u000D
         stx   <u0024
L0E63    ldx   <u0024
         lda   ,x
         lbeq  L0C62
         lbsr  L0C1A
         ldx   <u0024
         ldb   $08,x
         ldx   <$12,x
L0E75    lda   ,x+
         lbsr  XOUTCH
         decb
         bne   L0E75
         ldx   <u0024
         leax  <$14,x
         stx   <u0024
         bra   L0E63
L0E86    tst   <u00B7
         lda   <u0028
         bne   L0E96
         leax  >L1404,pcr Must display before deleting
         lbsr  L12E2
         lbra  L0A4E
L0E96    lda   <u0023
         cmpa  #$01
         bne   L0EA9
         leax  >L144A,pcr   Push D to delete
         ldy   <u000F
         lda   ,y
         beq   L0EA9
         bra   L0EAD
L0EA9    leax  >L142A,pcr
L0EAD    lbsr  L12E2
         cmpa  #$44
         lbne  L0A4E
         clr   <u0028
         clr   <u00A1
         lbsr  L0F75
         lbne  L0F6B
         ldx   <u0011
         lda   <u0023
         cmpa  #$01
         beq   L0ECB
         ldx   <u0015
L0ECB    stx   <u001B
         lda   #$44
         sta   ,x
         lbsr  L138B
         lbsr  L1365
         bne   L0EDC
         lbsr  L139A
L0EDC    lda   <u0023
         cmpa  #$01
         beq   L0EE8
         lbsr  L0F83
         lbra  L10D3
L0EE8    ldy   <u000F
         lda   ,y
         bne   L0EF7
         clr   <u0028
         lbsr  L0F83
         lbra  L0B42
L0EF7    lbsr  L1343
         bne   L0F20
         lbsr  L138B
         ldy   <u0019
         lda   ,y
         cmpa  #$55
         beq   L0F20
         cmpa  #$32
         bne   L0EF7
         lbsr  L1365
         bne   L0EF7
         lda   #$44
         ldx   <u0019
         sta   ,x
         stx   <u001B
         lbsr  L139A
         clr   <u0029
         bra   L0EF7
L0F20    clr   <u0028
         lbsr  L0F83
         lbra  L0B42
L0F28    tst   <u00B7
         lda   <u0028
         bne   L0F37
         leax  >L146B,pcr
         lbsr  L12E2
         bra   L0F68
L0F37    lbsr  L160F
         bne   L0F68
         ldx   <u0011
         lda   <u0023
         cmpa  #$01
         beq   L0F46
         ldx   <u0015
L0F46    stx   <u001B
         bsr   L0F75
         lbne  L0F6B
         clr   <u00A1
         lbsr  L138B
         lbsr  L1365
         bne   L0F5B
         lbsr  L139A
L0F5B    bsr   L0F83
         ldx   <u001B
         lbsr  L107D
         lbsr  L1095
         lbra  L0C62
L0F68    lbra  L0A4E
L0F6B    leax  >L15AB,pcr
         lbsr  L12E2
         lbra  L0A4E
L0F75    tst   >L0F82,pcr
         beq   L0F7C
         rts
L0F7C    inc   >L0F82,pcr
         clra
         rts

L0F82    fcb   $00

L0F83    lda   <FD.RMS  path to .RMS file
         ldx   <u00AD
         ldu   <u00AF
         leax  $02,x
         os9   I$Seek
         clr   >L0F82,pcr
         rts
L0F93    tst   <u00B7
         lda   <u0023
         cmpa  #$01
         bne   L100D
         lbsr  L160F
         bne   L0F68
         tst   <u0028
         bne   L0FB8
         ldx   #$0000
         stx   <u002C
         lbsr  L129F
         bsr   L0F75
         bne   L0F6B
L0FB0    lbsr  L138B
         lbsr  L135A
         bne   L0FC4
L0FB8    bsr   L0F83
         leax  >L1491,pcr
         lbsr  L12E2
         lbra  L0A4E
L0FC4    ldy   <u0019
         lda   ,y
         cmpa  #$55
         beq   L0FEA
         cmpa  #$44
         bne   L0FD9
         ldx   <u002C
         bne   L0FD9
         ldx   <u002E
         stx   <u002C
L0FD9    lbsr  L1343
         beq   L0FB0
L0FDE    bsr   L0F83
         leax  >L14B7,pcr
         lbsr  L12E2
         lbra  L0A4E
L0FEA    ldx   <u002C
         beq   L0FF0
         stx   <u002E
L0FF0    ldx   <u0011
         lda   #$31
         sta   ,x
         stx   <u001B
         inc   <u0028
         lbsr  L139A
         lbsr  L0F83
         ldx   <u0011
         lbsr  L107D
         lbsr  L1095
         clr   <u00A1
         lbra  L0C62
L100D    lda   <u0028
         bne   L1015
         ldx   <u002E
         beq   L0FB8
L1015    lbsr  L0F83
         lbsr  L160F
         lbne  L0A4E
         lbsr  L0F75
         lbne  L0F6B
         clr   <u002C
         clr   <u002D
L102A    lbsr  L138B
         ldy   <u0019
         lda   ,y
         cmpa  #$31
         beq   L104A
         cmpa  #$44
         beq   L1051
         cmpa  #$55
         beq   L105B
         lbsr  L1365
         bne   L104A
         ldx   #$0000
         stx   <u002C
         clr   <u0029
L104A    lbsr  L1343
         bne   L0FDE
         bra   L102A
L1051    ldx   <u002C
         bne   L104A
         ldx   <u002E
         stx   <u002C
         bra   L104A
L105B    ldx   <u002C
         beq   L1061
         stx   <u002E
L1061    ldx   <u0015
         lda   #$32
         sta   ,x
         stx   <u001B
         lbsr  L139A
         lbsr  L0F83
         inc   <u0028
         ldx   <u0015
         bsr   L107D
         lbsr  L1095
         clr   <u00A1
         lbra  L0C62
L107D    tst   <u008C
         beq   L1094
         ldd   <u0032
         leay  d,x
         std   <u0092
L1087    lda   ,x+
         sta   ,y+
         ldd   <u0092
         subd  #$0001
         std   <u0092
         bne   L1087
L1094    rts

L1095    bsr   L10A2
         bsr   L1099
L1099    ldx   <u0090
L109B    lbsr  L0BCD
         leax  -$01,x
         bne   L109B
L10A2    lda   <u0052 Ring bell
         lbra  XOUTCH

* Feed key pressed
L10A7    tst   <u00B7
         clr   <u002C
         clr   <u002D
         clr   <u00A1
         lda   <u0023
         cmpa  #$01
         bne   L10CD
         lda   <u0028
         beq   L10C3
         ldy   <u000F
         lda   ,y
         bne   L10D3
         lbra  L0AB1
L10C3    leax  >L14FF,pcr   Must display a primary record first
         lbsr  L12E2
         lbra  L0A4E
L10CD    lda   <u0028
         lbeq  L117D
L10D3    lbsr  L1343
         lbne  L1171
         lbsr  L138B
         ldy   <u0019
         lda   ,y
         cmpa  #$55
         lbeq  L1177
         cmpa  #$44
         bne   L10F4
         ldx   <u002C
         bne   L10F4
         ldx   <u002E
         stx   <u002C
L10F4    cmpa  #$32
         bne   L10D3
         lbsr  L1365
         bne   L10D3
         ldd   <u0032
         std   <u0092
         ldx   <u0019
         ldy   <u0015
L1106    ldb   ,x+
         stb   ,y+
         ldd   <u0092
         subd  #$0001
         std   <u0092
         bne   L1106
         lda   #$02
         sta   <u0023
         lda   #$01
         sta   <u0028
L111B    ldx   <u000F
         stx   <u0024
         lbsr  L0BC9   Clear screen
         lda   <u004A
         bsr   L116E
         lbsr  L0BBA
         ldx   <u000B
L112B    lda   ,x+
         beq   L1133
         bsr   L116E
         bra   L112B
L1133    lbsr  L0BBE
         ldx   <u0024
         lda   ,x
         bne   L113F
         lbra  L0C62
L113F    lbsr  L0C1A
         ldx   <u0024
         lda   $08,x
         ldx   <$12,x
         sta   <u0092
L114B    lda   ,x
         stx   <u0093
         ldb   <u0028
         bne   L115B
         ldx   <u0024
         cmpx  <u000F
         beq   L115B
         lda   <u003C
L115B    bsr   L116E
         ldx   <u0093
         leax  $01,x
         dec   <u0092
         bne   L114B
         ldx   <u0024
         leax  <$14,x
         stx   <u0024
         bra   L1133
L116E    lbra  XOUTCH
L1171    clr   <u002E
         clr   <u002F
         bra   L117D
L1177    ldx   <u002C
         beq   L117D
         stx   <u002E
L117D    lda   #$02
         sta   <u0023
         clr   <u0028
         ldx   <u0015
         ldy   <u0032
         leay  -$01,y
         lda   #$20
L118C    leax  $01,x
         leay  -$01,y
         beq   L1196
         sta   ,x
         bra   L118C

L1196    lda   #$0D
         sta   ,x
         ldx   <u0011
         leax  $01,x
         stx   <u0092
         ldx   <u0015
         leax  $01,x
         stx   <u0094
         ldy   <u000D
         lda   $08,y
L11AB    ldx   <u0092
         ldb   ,x+
         stx   <u0092
         ldx   <u0094
         stb   ,x+
         stx   <u0094
         deca
         bne   L11AB
         lbra  L111B

* Scan: browse through file
L11BD    tst   <u00B7
         lbne  L0AB1
         clr   <u00A1
         lda   <u0023
         cmpa  #$01
         beq   L11D5
         leax  >L1540,pcr   error: must be on primary form
         lbsr  L12E2
         lbra  L0A4E
L11D5    lda   <u0008   path to NDX file
         bne   L1218
         ldx   <u002A
         stx   <u002E
         clr   <u0028
L11DF    ldx   <u002E
         leax  $01,x
         cmpx  <u0030
         bne   L11F9
         leax  >L1586,pcr
         lbsr  L12E2
         lbsr  L1343
         ldx   #$0000
         stx   <u002A
         lbra  L0B42
L11F9    lbsr  L1343
         beq   L1205
         ldx   <u002E
         stx   <u002A
         lbra  L0B42
L1205    ldx   <u002E
         stx   <u002A
         lbsr  L138B
         ldy   <u0019
         lda   ,y
         cmpa  #$31
         bne   L11DF
         lbra  L0E43
L1218    clr   <u0028
         ldx   <u000D
         lda   $08,x
         sta   <u0092
         ldx   <$12,x
         stx   <u0093
L1225    lda   <u0008   path to NDX file
         ldx   <u0019
         ldy   #$0001
         os9   I$Read
         bcc   L1255
         cmpb  #E$EOF
         beq   L123C
         leax  >L15D2,pcr
         bra   L124F
L123C    pshs  u,x
         ldu   #$0000
         ldx   #$0000
         lda   <u0008   path to NDX file
         os9   I$Seek
         puls  u,x
         leax  >L1523,pcr
L124F    lbsr  L12E2
         lbra  L0B42
L1255    ldx   <u0019   input buffer
         lda   ,x
         cmpa  #$0D
         beq   L127E
         ldx   <u0093
         sta   ,x+
         stx   <u0093
         dec   <u0092
         bne   L1225
L1267    lda   <u0008   path to NDX file
         ldy   #$0001
         ldx   <u0019   input buffer
         os9   I$Read
         bcs   L1288
         ldx   <u0019   input buffer
         lda   ,x
         cmpa  #$0D
         bne   L1267
         bra   L1288
L127E    lda   #$20
         ldx   <u0093
L1282    sta   ,x+
         dec   <u0092
         bne   L1282
L1288    ldx   <u000D
         lbsr  L0C1A
         ldx   <u000D
         ldb   $08,x
         ldx   <$12,x
L1294    lda   ,x+
         lbsr  XOUTCH
         decb
         bne   L1294
         lbra  L0E0D
L129F    ldx   <u000D
         ldb   $08,x
         ldx   #$0000
         stx   <u002E
         ldx   <u0011
         leax  $01,x
         bsr   L12C7
         lda   <u002E
         anda  <u00B3
         sta   <u002E
         ldd   <u002E
         beq   L12C1
L12B8    std   <u002E
         subd  <u0030
         bhi   L12B8
         beq   L12C1
         rts
L12C1    ldx   #$0001
         stx   <u002E
         rts
L12C7    lda   ,x+
         bsr   L1338  make upper case
         suba  #$20
         adda  <u002E
         sta   <u002E
         decb
         beq   L12E1
         lda   ,x+
         bsr   L1338  make upper case
         suba  #$20
         adda  <u002F
         sta   <u002F
         decb
         bne   L12C7
L12E1    rts

* Display error message
*
L12E2    lbsr  L0BCD
         lda   <u0052 Ring bell
         bsr   L1335
         lda   #$02
         sta   <u00AC
L12ED    lda   ,x+
         cmpa  #'@
         beq   L12F9
         bsr   L1335
         inc   <u00AC
         bra   L12ED

L12F9    leax  >HITSPACE,pcr
L12FD    lda   ,x+
         cmpa  #'@
         beq   L1309
         bsr   L1335
         inc   <u00AC
         bra   L12FD
L1309    ldx   <u0024
         lbsr  L0C15
         lbsr  L19EC   read from keyboard
         bsr   L1338  make upper case
         sta   <u0097
         lbsr  L0BCD
L1318    lda   #$20
         bsr   L1335
         dec   <u00AC
         bne   L1318
         ldx   <u0024
         lbsr  L0C15
         lda   <u0097
         rts

HITSPACE    fcc   " - HIT SPACE@"

L1335    lbra  XOUTCH

* Make uppper case
L1338    cmpa  #'a
         bcs   L1342
         cmpa  #'z
         bhi   L1342
         suba  #$20
L1342    rts

L1343    inc   <u0029
         beq   L1357
         ldx   <u002E
         leax  $01,x
         cmpx  <u0030
         bne   L1352
         ldx   #$0001
L1352    stx   <u002E
         lda   #$00
         rts
L1357    lda   #$01
         rts
L135A    lda   <u0023
         ora   #$30
         ldy   <u0019
         cmpa  ,y
         bne   L138A
L1365    ldx   <u0019
         leax  $01,x
         ldy   <u000D
         lda   $08,y
         ldy   <u0011
         leay  $01,y
L1373    ldb   ,x+
         exg   a,b
         lbsr  L1338  make upper case
         pshs  a
         lda   ,y+
         lbsr  L1338  make upper case
         exg   a,b
L1383    cmpb  ,s+
         bne   L138A
         deca
         bne   L1373
L138A    rts


* Read record
L138B    bsr   L13B3
         lda   <FD.RMS  path to .RMS file
         ldx   <u0019   input buffer
         ldy   <u0032
         os9   I$Read
         bcs   L13A9
         rts

* Write record
L139A    bsr   L13B3
         lda   <FD.RMS  path to .RMS file
         ldx   <u001B
         ldy   <u0032
         os9   I$Write
         bcs   L13A9
         rts
L13A9    leax  >L1565,pcr
         lbsr  L12E2
         lbra  L0BE7

L13B3    lda   <u002E
         ldb   <u0032
         mul
         std   <u00AD
         lda   <u002F
         ldb   <u0033
         mul
         std   <u00AF
         lda   <u002E
         ldb   <u0033
         mul
         addd  <u00AE
         std   <u00AE
         bcc   L13CE
         inc   <u00AD
L13CE    lda   <u002F
         ldb   <u0032
         mul
         addd  <u00AE
         std   <u00AE
         bcc   L13DB
         inc   <u00AD
L13DB    lda   <FD.RMS  path to .RMS file
         ldx   <u00AD
         ldu   <u00AF
         os9   I$Seek
         bcs   L13A9
         rts

L13E7    fcc   "THAT RECORD CAN NOT BE FOUND@"
L1404    fcc   "MUST DISPLAY A RECORD BEFORE DELETING@"
L142A    fcc   "PUSH D TO DELETE THIS RECORD OR@"
L144A    fcc   "PUSH D TO DELETE RECORD GROUP OR@"
L146B    fcc   "MUST DISPLAY A RECORD BEFORE UPDATING@"
L1491    fcc   "THAT KEY FIELD ALREADY EXISTS IN FILE@"
L14B7    fcc   "FILE TOO FULL TO INSERT THIS RECORD@"
L14DB    fcc   "YOU CAN INSERT ONLY AT END OF GROUP@"
L14FF    fcc   "MUST DISPLAY A PRIMARY RECORD FIRST@"
L1523    fcc   "END OF INDEX FILE; TO REWIND@"
L1540    fcc   "MUST BE ON PRIMARY FORM TO SCROLL UP@"
L1565    fcc   "FATAL ERROR - MAIN FILE IO ERROR@"
L1586    fcc   "ENTIRE FILE SCANNED, WILL START OVER@"
L15AB    fcc   "TEMPORARILY LOCKED OUT BY ANOTHER USER@"
L15D2    fcc   "ERROR IN READING INDEX FILE@"
L15EE    fcc   "TO CLEAR WITHOUT SAVE TYPE Y, OR@"

L160F    ldx   <u000D
         lda   <u0023
         cmpa  #$01
         beq   L1619
         ldx   <u000F
L1619    stx   <u0024
         stx   <u0026
L161D    ldx   <u0024
         lda   ,x
         bne   L162A
L1623    ldx   <u0026
         stx   <u0024
         lda   #$00
         rts
L162A    lda   $0A,x
L162C    beq   L1641
L162E    ldb   $08,x
L1630    ldx   <$12,x
         lda   #$20
L1635    cmpa  ,x
         bne   L1641
         leax  $01,x
         decb
         bne   L1635
         lbra  L178D
L1641    ldx   <u0024
         lda   $09,x
         cmpa  #$44
         bne   L1682
         ldx   <$12,x
         lda   $02,x
         cmpa  #$2F
         beq   L165C
L1652    leax  >L18D7,pcr
L1656    lbsr  L12E2
L1659    lda   #$01
         rts
L165C    cmpa  $05,x
         bne   L1652
         lda   $03,x
         cmpa  #$30
         beq   L1670
         cmpa  #$31
         bne   L1652
         lda   $04,x
         cmpa  #$32
         bgt   L1652
L1670    lda   ,x
         cmpa  #$34
         blt   L1679
         lbra  L1652
L1679    lda   $07,x
         cmpa  #$20
         beq   L1652
         lbra  L1785
L1682    cmpa  #$4D
         lbne  L1734
         lda   $08,x
         ldx   <$12,x
         sta   <u0092
         stx   <u0093
         clrb
L1692    orb   ,x
         leax  $01,x
         deca
         bne   L1692
         cmpb  #$20
         lbeq  L1765
         clrb
         stx   <u0095
         ldx   <u0093
L16A4    lda   ,x
         cmpa  #$2E
         beq   L16DC
         orb   ,x
         cmpb  #$20
         beq   L16B4
         cmpa  #$20
         beq   L16C1
L16B4    leax  $01,x
         cmpx  <u0095
         bne   L16A4
L16BA    leax  >L18EB,pcr
         lbra  L1656
L16C1    lda   #$2E
         sta   ,x
         leax  $01,x
         cmpx  <u0095
         beq   L16BA
         lda   #$30
         sta   ,x
         leax  $01,x
         cmpx  <u0095
         beq   L16BA
         sta   ,x
         leax  $01,x
         lbra  L1716
L16DC    leax  $01,x
         cmpx  <u0095
         beq   L16BA
         lda   ,x
         cmpa  #$2E
         beq   L16EC
         cmpa  #$20
         bne   L16F0
L16EC    lda   #$30
         sta   ,x
L16F0    leax  $01,x
         cmpx  <u0095
         beq   L16BA
         lda   ,x
         cmpa  #$2E
         beq   L1700
         cmpa  #$20
         bne   L1704
L1700    lda   #$30
         sta   ,x
L1704    leax  $01,x
         cmpx  <u0095
         beq   L1731
         lda   #$20
         stx   <u0097
L170E    sta   ,x+
         cmpx  <u0095
         bne   L170E
         ldx   <u0097
L1716    cmpx  <u0095
         beq   L1731
         stx   <u0097
L171C    leax  -$01,x
         lda   ,x
         sta   $01,x
         cmpx  <u0093
         bne   L171C
         lda   #$20
         sta   ,x
         ldx   <u0097
         leax  $01,x
         lbra  L1716
L1731    lbra  L176C
L1734    cmpa  #$4E
         bne   L1785
         lda   $08,x
         ldx   <$12,x
         stx   <u0093
         clrb
L1740    orb   ,x
         leax  $01,x
         deca
         bne   L1740
         cmpb  #$20
         beq   L1765
         clrb
         stx   <u0095
         ldx   <u0093
L1750    lda   ,x
         orb   ,x
         cmpb  #$20
         beq   L175C
         cmpa  #$20
         beq   L1716
L175C    leax  $01,x
         cmpx  <u0095
         bne   L1750
         lbra  L1785
L1765    leax  >L19DD,pcr
         lbra  L1656
L176C    ldx   <u0024
         lbsr  L0C15
         ldx   <u0024
         lda   $08,x
         ldx   <$12,x
         sta   <u0092
L177A    lda   ,x
         lbsr  XOUTCH
         leax  $01,x
         dec   <u0092
         bne   L177A
L1785    ldx   <u0024
         lda   $0F,x
         cmpa  #$00
         bne   L1797
L178D    ldx   <u0024
         leax  <$14,x
         stx   <u0024
         lbra  L161D
L1797    cmpa  #$01
         lbeq  L181F
         cmpa  #$02
         lbeq  L17D5
         cmpa  #$04
         bne   L178D
         ldx   <u0024
         lda   $08,x
         sta   <u0092
         sta   <u0094
         lda   <$10,x
         sta   <u0093
         ldx   <$12,x
         lda   #$20
L17B9    cmpa  ,x
         bne   L17BF
         dec   <u0092
L17BF    leax  $01,x
         dec   <u0094
         bne   L17B9
         lda   <u0092
         cmpa  <u0093
         bge   L17D2
         leax  >L1908,pcr
         lbra  L1656
L17D2    lbra  L178D
L17D5    ldx   <u0024
         lda   <$10,x
         sta   <u0092
         lda   <$11,x
         sta   <u0093
         ldx   <$12,x
         stx   <u0094
L17E6    ldx   <u0094
         stx   <u0096
L17EA    ldx   <u0092
         lda   ,x
         leax  $01,x
         stx   <u0092
         cmpa  #$2C
         beq   L17D2
         cmpa  #$00
         beq   L17D2
         ldx   <u0096
         cmpa  ,x
         bne   L1807
         leax  $01,x
         stx   <u0096
         lbra  L17EA
L1807    ldx   <u0092
L1809    lda   ,x
         beq   L1818
         leax  $01,x
         cmpa  #$2C
         bne   L1809
         stx   <u0092
         lbra  L17E6
L1818    leax  >L192E,pcr
         lbra  L1656
L181F    ldx   <u0024
         lda   $08,x
         sta   <u0092
         lda   <$10,x
         sta   <u0093
         lda   <$11,x
         sta   <u0094
         lda   $09,x
         ldx   <$12,x
         stx   <u0095
         cmpa  #$44
         beq   L188F
         ldb   <u0092
         ldx   <u0095
         stx   <u0097
L1840    ldx   <u0097
         lda   ,x
         leax  $01,x
         stx   <u0097
         ldx   <u0093
         cmpa  ,x
         blt   L1859
         bne   L1860
         leax  $01,x
         stx   <u0093
         decb
         bne   L1840
         bra   L1860
L1859    leax  >L1953,pcr
         lbra  L1656
L1860    ldx   <u0093
L1862    lda   ,x+
         cmpa  #$2C
         bne   L1862
         stx   <u0093
         ldb   <u0092
L186C    ldx   <u0095
         lda   ,x
         leax  $01,x
         stx   <u0095
         ldx   <u0093
         cmpa  ,x
         bgt   L1888
         lbne  L178D
         leax  $01,x
         stx   <u0093
         decb
         bne   L186C
         lbra  L178D
L1888    leax  >L1964,pcr
         lbra  L1656
L188F    ldx   <u0095
         ldy   <u0093
         ldd   $06,x
         cmpd  $06,y
         blt   L18C9
         bne   L18AD
         ldd   $03,x
         cmpd  $03,y
         blt   L18C9
         bne   L18AD
         ldd   ,x
         cmpd  ,y
         blt   L18C9
L18AD    ldd   $06,x
         cmpd  $0F,y
         bgt   L18D0
         bne   L18C6
         ldd   $03,x
         cmpd  $0C,y
         bgt   L18D0
         bne   L18C6
         ldd   ,x
         cmpd  $09,y
         bgt   L18D0
L18C6    lbra  L178D
L18C9    leax  >L1976,pcr
         lbra  L1656
L18D0    leax  >L1988,pcr
         lbra  L1656

L18D7    fcc   "IMPROPER DATE FIELD@"
L18EB    fcc   "NO ROOM FOR 2 DECIMAL PLACES@"
L1908    fcc   "FIELD IS SHORTER THAN MINIMUM ALLOWED@"
L192E    fcc   "NOT IN THE LIST OF ACCEPTABLE VALUES@"
L1953    fcc   "VALUE IS TOO LOW@"
L1964    fcc   "VALUE IS TOO HIGH@"
L1976    fcc   "DATE IS TOO EARLY@"
L1988    fcc   "DATE IS TOO LATE@"
L1999    fcc   "IO ERROR IN THE VALIDATOR FILE@"
L19B8    fcc   "NOT IN THE FILE OF ACCEPTABLE VALUES@"
L19DD    fcc   "MISSING NUMBER@"

* Write out and read from keyboard
L19EC    pshs  x,b
         bsr   WRIBUF
         ldx   <u0002   keyboard buffer
         ldy   #$0001
         lda   #$01
         os9   I$Read
         ldx   <u0002   keyboard buffer
         lda   ,x
         anda  #$7F
         puls  pc,x,b

* Add character in A to buffer
XOUTCH   pshs  x
         ldx   <u009F
         cmpx  <u00BC
         bcs   L1A0F
         bsr   WRIBUF
L1A0D    ldx   <u009F
L1A0F    sta   ,x+
         stx   <u009F
         puls  pc,x

* Write buffer
WRIBUF   pshs  x,b,a
         ldd   <u009F
         subd  <u00BA
         beq   L1A28
         tfr   d,y
         ldx   <u00BA
         stx   <u009F
         lda   #$01
         os9   I$Write
L1A28    puls  pc,x,b,a

         ldx   <u0002
         sta   ,x
         ldy   #$0001
         lda   #$01
L1A34    os9   I$Write
         puls  pc,x,b

         emod
eom      equ   *
