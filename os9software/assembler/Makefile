# Note: output from the assembler is created in the execution directory

RUN=java -jar ../tools/os9j/target/os9j-1.0-SNAPSHOT-jar-with-dependencies.jar


.SUFFIXES: .asm

.asm:
	$(RUN) -m 20000 asm $< o=a.out
	mv $(HOME)/OS9/CMDS/a.out $@
	chmod 755 $@
	

go51: drvr51 go51load
	cat go51load drvr51 >go51
	chmod 755 $@
	cmp go51 $(HOME)/OS9/CMDS/go51

