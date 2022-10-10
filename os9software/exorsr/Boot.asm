         nam   Boot
         ttl   os9 system module

         use   defsfile

         mod   eom,name,Systm+Objct,ReEnt+3,start,size
DriveCnt equ 4

 org DRVBEG
 rmb Drvmem*DriveCnt

X.CURDRV    rmb   1  Current drive #
X.CURLSN    rmb   2
X.SIZE    rmb   2
X.BUFADR  rmb   2  $6C
u006E rmb 16
X.STAT    rmb   1
X.DRVTBL    rmb   2 $7F
X.DELAY    rmb   2 $81
CTLREXEC    rmb   4 $83
u0087    rmb   2
CTLRADDR    rmb   2
size     equ   .

name     equ   *
         fcs   /Boot/
         fcb   $02

CTLRNAME    fcs "EXORctlr"

REBOOT    jmp   [>$FFFE]

start    equ   *
         pshs  u,y,x,b,a
         ldd   #$0100
         os9   F$SRQM Get memory address in reg. U
         bcs   REBOOT
         clra
         clrb
         sta   X.CURDRV,u
         std   X.CURLSN,u
         pshs  u,y
         lda   #Drivr
         leax  <CTLRNAME,pcr
         os9   F$Link
         tfr   u,x
         puls  u,y
         bcs   REBOOT
         stx   >CTLRADDR,u
         ldd   M$Exec,x
         leax  d,x
         stx   >CTLREXEC,u
         leax  6,x  Address of third address in jump table
         stx   >u0087,u
         ldy   #DPORT
         sty   V.PORT,u
         leax  DRVBEG,u
         stx   <X.DRVTBL,u
         ldd   #$FFFF
         std   V.TRAK,x
         ldd   #$0010 16 tracks/sect?
         stb   DD.TKS,x
         std   DD.SPT,x
         lda   #$01   Double-sided, single density
         sta   DD.FMT,x
         ldd   #$00EA
         std   >X.DELAY,u
         jsr   [>CTLREXEC,u]
         ldb   #$04
         stb   <X.STAT,u
         jsr   [>u0087,u]
         ldb   #$08
         stb   <X.STAT,u
         jsr   [>u0087,u]
         bcs   ERRRTRN
         pshs  u
         ldd   #$0100
         os9   F$SRQM
         tfr   u,y
         puls  u
         bcs   ERRRTRN
         ldd   #$0001 Set one sector
         ldx   #$0000 Set LSN 0
         pshs  y
         bsr   L00FB
         jsr   [>u0087,u]
         puls  y
         bcs   ERRRTRN
         ldd   #$0100
         pshs  u,y
         tfr   y,u
         os9   F$SRTM
         puls  u,y
         bsr   L011F
         ldd   DD.BSZ,y
         std   ,s
         beq   BADMEDIA
         pshs  u,y
         os9   F$SRQM Request memory (D = size)
         tfr   u,x
         puls  u,y
         bcs   ERRRTRN Unable to allocate memory
         stx   $02,s
         exg   x,y
         ldd   DD.BSZ,x
         tstb
         beq   L00DB
         inca  Round up boot size
L00DB    clrb
         exg   a,b
         ldx   DD.BT+1,x Get boot sector
         bsr   L00FB
         jsr   [>u0087,u]
         bcs   ERRRTRN
         bsr   TRMINATE
         clrb
         puls  pc,u,y,x,b,a

BADMEDIA ldb   #E$BTyp Bad media type

ERRRTRN    pshs  b
         bsr   TRMINATE
         comb
         puls  b
         leas  2,s
         puls  pc,u,y,x

L00FB    sty   <X.BUFADR,u Buffer address
         std   <X.SIZE,u Size to read
         stx   <X.CURLSN,u Sector to start read at
         clrb
         stb   <X.STAT,u
         ldy   V.PORT,u
         rts

TRMINATE pshs  u
         ldu   >CTLRADDR,u
         os9   F$UnLk
         puls  u
         ldd   #256
         os9   F$SRTM Return memory
         rts

* Copy 20 bytes (DD.SIZ in OS9 1.1 ?)
L011F    ldx   <X.DRVTBL,u
         ldb   #20
L0124    lda   b,y
         sta   b,x
         decb
         bpl   L0124
         rts

         emod
eom      equ   *
