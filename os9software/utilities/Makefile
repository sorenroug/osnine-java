# Note: output from the assembler is created in the execution directory

RUN=java -jar ../../tools/os9j/target/os9j-1.0-SNAPSHOT-jar-with-dependencies.jar
ASMHOME=../assembler

.SUFFIXES: .asm

.asm:
	$(RUN) -h $(CURDIR)/$(ASMHOME) -m 20000 asm $< o=a.out
	mv $(CURDIR)/$(ASMHOME)/CMDS/a.out $@
	chmod 755 $@
	
