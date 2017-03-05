OBJS = putc.o

all: $(OBJS)

putc.o: putc.asm
	zcc -c putc.asm

clean:
	$(RM) *.o zcc_opt.def 
