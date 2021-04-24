***************************************
* SYSCALL - a powerful subroutine for use with Basic09
* A special thanks to Robert Doggett for writing this routine.
*
* Basic09 calling suquence:
* TYPE Registers=CC,A,B,DP:BYTE; X,Y,U:INTEGER
* DIM regs:Registers
*
* There is no DIM statement for code, which must be a BYTE or INTEGER value,
* and a non-DIM'd variable in Basic09 is either a type REAL or, with a $ as the
* last character of the name, a 32-character STRING.
* DIM code:BYTE
*
* RUN SysCall(code,registers)
*
* SysCall will allow you to execute ANY OS-9 System call from
* your Basic09 programs. BE WARNED!!! SysCall can be VERY
* dangerous, since it permits you to do things you may not want
* done during program execution (like format disks, write
* thousands of bytea all at once, and so on). However, it can
* also be very useful, IF you know what you are doing.
*
* NOTE: This version of SysCall will cause a Basic09 runtime
* error to occur if your system call returns an error. This can
* be easily overcome, as noted below. If you do this, you
* must check "regs.CC" to see if a system error has occurred.
*
* Here is an example of one possible use you may have for SysCall
*
* PROCEDURE filesize
* TYPE Registers=CC,A,B,DP:BYTE; X,Y,U:INTEGER
* DIM regs:Registers
* DIM path,callcode:BYTE \(* or INTEGER *)
* OPEN #path,"test":READ
* regs.A:=path
* regs.B:=2 \(* I$GetStt code *)
* RUN SysCall(callcode,regs)
* CLOSE #path
* PRINT USING "filesize = 0',2(h4)",regs.X; regs.U

          use  defsfile
          opt  l

TYPE      set  SBRTN+OBJCT
REVS      set  REENT+1
          mod  SyCalEnd,SyCalNam,TYPE,REVS,SyCalEnt,0
SyCalNam  fcs  "SysCall"
          fcb  2             edition number

E$Paras   equ  56 Basic09's  parameter error code
M.OS9     equ  $103F         OS-9 system call machine code
M.RTS     equ  $39           rts machine code

          org  0             stacked variable
Return    rmb  2             Return address
PCount    rmb  2             number of params passed
Function  rmb  4             OS-9 function code
Regs      rmb  4             Register image

SyCalEnt  ldd  PCount,s      Get parameter count
          cmpd #2            exactly 2 parameters?
          bne  ParamErr      abort if not
          ldd  Regs+2,s      check size of register image
          cmpd #10           exactly 10 bytes?
          bne  ParamErr      abort if not
          ldd  [Function,S]  get os-9 function code
          ldx  Function+2,S  get size of function param
          leax -1,X          INTEGER?
          bne  ParamErr      abort if not
          tfr  B,A

* Now you build your OS9 call and return from subroutine on
* stack (A)=OS9 function call

SysCall   ldb  #M.RTS        get "rts" machine code
          pshs D
          ldd  #M.OS9        get OS-9 machine code
          pshs D
          ldu  Regs+4,S      get register image ptr
          ldd  R$D,U         initialize regs for system call
          ldx  R$X,U
          ldy  R$Y,U
          ldu  R$U,U
          jsr  0,S           execute system call
          pshs CC,Usave CC,U
          ldu  Regs+7,S
          leau R$U,U
          pshu A,B,DP,X,Y    return unpdatd regs to caller
          puls A,X get CC,U
          sta  ,-U
          stx  R$U,U
          leas 4,S           discard OS-9 call subroutine

* If you want to eliminate the possibility of a runtime error
* remove the comment designator (*) from the next line

* clrb
          rts
ParamErr  comb               return carry set
          ldb  #E$ParmEr      Parameter error
          rts

          emod
SyCalEnd equ   *
