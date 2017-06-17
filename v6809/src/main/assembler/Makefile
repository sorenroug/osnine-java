# Note: output from the assembler is created in the execution directory

all: vdisk d0 init boot_rom sysgo t1linux bootdyn

.SUFFIXES: .asm

CMDSDIR=$(HOME)/OS9/CMDS
.asm:
	os9j -m 20000 asm $< o=a.out
	mv $(CMDSDIR)/a.out $@
	test -s $@ || rm $@
