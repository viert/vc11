RM = del
OBJS = proc.o control.o dummy.o

all: kernel.o

kernel.o: $(OBJS)
	zcc -c $(OBJS) -o kernel.o

proc.o: proc.asm
	zcc -c $<

dummy.o: dummy.c dummy.h
	zcc -c $<

control.o: control.asm
	zcc -c $<

clean:
	$(RM) *.o zcc_opt.def zcc_proj.lst