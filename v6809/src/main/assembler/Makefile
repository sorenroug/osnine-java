# Note: output from the assembler is created in the execution directory

.SUFFIXES: .asm

CMDSDIR=$(HOME)/OS9/CMDS
.asm:
	os9j -m 20000 asm $< o=a.out
	mv $(CMDSDIR)/a.out $@
	
init: initnodisk.asm
	os9j -m 20000 asm initnodisk.asm o=a.out
	mv $(CMDSDIR)/a.out init


acia:
	os9j -m 10000 asm acia51.asm o=a.out
	mv $(CMDSDIR)/a.out $@
