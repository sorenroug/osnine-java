# Note: output from the assembler is created in the execution directory

OBJS=OS9p1_ed12  OS9p2_ed13 Boot

all: $(OBJS)

RUN=java -jar ../../../../tools/os9j/target/os9j-1.0-SNAPSHOT-jar-with-dependencies.jar

.SUFFIXES: .asm

.asm:
	$(RUN) -h $(CURDIR)/.. -m 20000 asm $< o=a.out
	mv $(CURDIR)/../CMDS/a.out $@
	@chmod 755 $@
	@md5sum $@
	@grep $@ sums

OS9p1_ed12: defsfile OS9p1_ed12.asm
OS9p2_ed13: defsfile OS9p2_ed13.asm

clean:
	rm -f $(OBJS)

verify:
	@for f in $(OBJS); do md5sum $$f ; grep $$f sums ; done
