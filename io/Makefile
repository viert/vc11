OBJS = console.o

all: $(OBJS)

console.o: console.asm
	zcc -c $<

clean:
	$(RM) *.o zcc_opt.def 
