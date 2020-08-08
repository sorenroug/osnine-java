 nam Boot

 ttl General bootstrap module

****************************************
*
* Called by OS-9 on reset if IOMAN can't
* be found in ROM.
* Links to the device descriptor whose
* name is embedded in the program, and
* calls the boot entry of its device driver,
* with the Y register pointing at the
* device descriptor.
*
****************************************

****************************************
*
* Written by Paul Dayan 20th August 1982
*
* (c) Vivaway Ltd 1982
*
****************************************

 use defsfile

 TTL General bootstrap module

Type set SYSTM+OBJCT
Revs set REENT+1

 mod Btend,Btnam,Type,Revs,Btent,0

 fcb   $FF capabilities

Btnam fcs 'Boot'

Edition fcb 1

****************************************
*
Devnam fcs 'bootdev' name of device to boot from
*
****************************************

Btent pshs u,y
 lda #DEVIC+OBJCT
 leax Devnam,pcr
 os9 F$Link
 bcs Bterr2 abort if can't find it
 pshs u save module address
 ldd $B,u get offset to driver name
 leax d,u point at driver name
 lda #DRIVR+OBJCT link to device driver
 os9 F$Link
 leax $12,y entry point for boot routine
 ldy 0,s get device descriptor pointer in Y
 bcs Bterr1 abort if can't find driver
 pshs u save address of driver module
 jsr ,x call boot routine
 puls u unlink device driver
 pshs x,b,a,cc save results
 os9 F$UnLink
 puls x,b,a,cc retrieve results

Bterr1 puls u unlink device descriptor
 pshs x,b,a,cc save results
 os9 F$UnLink
 puls x,b,a,cc retrieve results

Bterr2 puls  pc,u,y

 emod
Btend equ *
