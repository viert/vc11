OBJS = dummy.o

all: $(OBJS)

dummy.o: dummy.c dummy.h
	zcc -c $<

clean:
	$(RM) *.o zcc_opt.def zcc_proj.lst
