OBJS = proc.o control.o clock.o

all: $(OBJS)

clock.o: clock.asm
	zcc -c $<

proc.o: proc.asm
	zcc -c $<

control.o: control.asm
	zcc -c $<

clean:
	$(RM) *.o zcc_opt.def zcc_proj.lst
