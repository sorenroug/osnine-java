
M0F00    lbra  M0F79
M0F03    lbra  M0F0D
         fdb   ENDHELP-M0F00   * 1E67
         fdb   ENDHELP-M0F00+$5F00    * 1E67 + 5F00
M0F0A    lbra  M1046

M0F0D    ldu   <MEMPTR
         ldy   >M0575,u   Location of program
         leau  >M0F5C,pcr
         jsr   >L1AA4,y
         jsr   >L08EF,y
         cmpa  #'Y
         beq   M0F28
         jmp   >L1A89,y

* Delete helps
M0F28    ldu   <$001E
         ldx   <PARAMS
         leax  1,x
         stx   <$001E
         pshs  u,x
         com   <u001D   Flag for helps discarded
         ldd   <PARAMS
         subd  <$0017
         lsra
         rorb
         addd  <$0017
         jsr   >L4EB5,y
         tfr   u,d
         subd  <$00C5
         std   <$006C
         ldd   <$001E
         subd  <$006C
         std   <$00C5
         ldd   <$006C
         clr   <$007D
         lsra  
         rorb  
         ror   <$007D
         std   <$006C
         puls  u,x
         jmp   >L3AE1,y

M0F5C    fcc   "Delete helps: Are you sure? "
         fcb   $00

* Handling of help texts
M0F79    pshs  y
         ldy   <MEMPTR
         ldy   >M0575,y location of program
         ldb   ,x
         cmpb  #$88
         bne   M0F91
         tst   <$00E1
         beq   M0F91
         ldb   #$9A
         clr   <$00E1
M0F91    stb   <$0025
         ldu   <$00B1
         lda   <$00B3
         ldb   <$0075
         pshs  u,b,a
M0F9B    lbsr  M1042
         lda   #$0A
         jsr   >L0925,y
         leax  >HELPTBL-$80,pcr
         ldb   <$0025
         abx
         ldd   ,x
         leau  >HELPS,pcr
         leau  d,u
M0FB3    lda   ,u+
         beq   M0FEA    Branch if end of page
         cmpa  #$11     Stop for next screen?
         bne   M0FDE   ..no
         jsr   >L3ADE,y
         jsr   >L0901,y
         ldb   -1,x
         incb
         lda   b,x
         pshs  a
         clr   b,x
         jsr   >L08EF,y
         puls  a
         cmpa  #$1B   User typed escape to exit?
         beq   M101D ..yes
         pshs  u
         bsr   M1042
         puls  u
         bra   M0FE6

M0FDE    jsr   >L0925,y   print character
         cmpa  #$0D
         bne   M0FB3  end loop
M0FE6    lda   #$0A
         bra   M0FDE

M0FEA    jsr   >L3ADE,y
         jsr   >L0901,y  go to line 1 and wait for input
         lda   <$0025
         cmpa  #$80    Is this the first page?
         bne   M101D   ..no
         ldb   -1,x
         incb
         lda   b,x
         cmpa  #'@    help with functions
         bne   M1005
         ldb   #$9C
         bra   M100B
M1005    cmpa  #'>    help with errors
         bne   M1013
         ldb   #$9E
M100B    stb   <$0025
         jsr   >L08EF,y
         bra   M0F9B
M1013    anda  #$5F
         cmpa  #'G    general help
         bne   M101D
         ldb   #$84
         bra   M100B

M101D    bsr   M1042
         clr   <$00AC
         jsr   >L1ABC,y
         ldy   <MEMPTR
         ldy   >M0575,y  location of program
         ldx   #$0200
         jsr   >$08B9,y
         jsr   >L3ADE,y
         puls  u,b,a
         sta   <$00B3
         stu   <$00B1
         stb   <$0075
         puls  pc,y

M1042    jmp   >L091C,y

M1046    ldu   <MEMPTR
         ldy   >M0575,u location of program
         ldd   #$2C20
         jsr   >L1A8C,y
         ldb   <$0025
         leax  >ERRTBL,pcr Table of pointers to helptexts
         subb  #$C8
         cmpb  #$35
         bls   M1062
         ldb   #$36
M1062    lslb
         abx
         ldd   ,x
         leau  >ERRMSGS,pcr  Error messages start
         leau  d,u
         jsr   >$3FAE,y
         rts

