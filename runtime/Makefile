OBJS = proc.o control.o

all: $(OBJS)

proc.o: proc.asm
	zcc -c $<

control.o: control.asm
	zcc -c $<

clean:
	$(RM) *.o zcc_opt.def zcc_proj.lst
