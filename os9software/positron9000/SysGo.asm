 nam SysGo
 ttl SysGo - system bootstrap startup module

 use defsfile

***********************************************************
*
*     Program SysGo
*
*   Sets execution directory, executes startup file,
*   and loops, forking a shell and waiting for it
*
TEST set 0
tylg     set   Prgrm+Objct
atrv     set   ReEnt+rev
rev      set   $01
         mod   SGoEnd,SGoNam,tylg,atrv,start,200

SGoNam     equ   *
         fcs   /SysGo/
         fcb   $01
DirStr    fcb   $43 C
         fcb   $6D m
         fcb   $64 d
         fcb   $F3 s
CmdStr    fcb   $53 S
         fcb   $68 h
         fcb   $65 e
         fcb   $6C l
         fcb   $6C l
         fcb   $0D
Setime fcc "Setime"
         fcb   $0D

Welcome    fcb   $0A
         fcb   $0A
         fcc "Positron Computers Limited"
         fcb   $0A
         fcb   $0A
         fcc "********  Welcome  *******"
         fcb   $0A
         fcb   $0A
         fcb   $0D

ShlFun fcc "Startup"
         fcb   $0D
start    equ   *
         leax  >SGoIncpt,pcr
         os9   F$Icpt
         leax  >DirStr,pcr
         lda   #$04
         os9   I$ChgDir
 os9 F$ID get process ID
 ldb #128 get medium priority
 os9 F$SPrior set priority
         leax  >Setime,pcr
         ldd   #$0100
         ldy   #$0000
         os9   F$Fork
         bcs   L0092
         os9   F$Wait
L0092    leax  >Welcome,pcr
         ldy   #$003B
         lda   #$01
         os9   I$WritLn
         leax  >CmdStr,pcr
         ldd   #$0100
         ldy   #$0008
         leau  >ShlFun,pcr
         os9   F$Fork
         bcs   L00B6
         os9   F$Wait
L00B6    leax  >CmdStr,pcr
         ldd   #$0100
         ldy   #$0000
         os9   F$Fork
         os9   F$Wait
         bra   L00B6

SGoIncpt rti do-nothing intercept

         emod
SGoEnd      equ   *
