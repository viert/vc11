RUNTIME_OBJS = runtime/control.o runtime/proc.o runtime/clock.o
IO_OBJS = io/console.o
DUMMY_OBJS = dummy/dummy.o

OBJS = $(RUNTIME_OBJS) $(IO_OBJS) $(DUMMY_OBJS)

all: vc11.rom

vc11.rom: crt0.asm $(OBJS)
	zcc -crt0 crt0 $(OBJS) -o vc11.rom

$(RUNTIME_OBJS):
	make -C runtime

$(IO_OBJS):
	make -C io

$(DUMMY_OBJS):
	make -C dummy

clean:
	$(RM) vc11.rom zcc_opt.def zcc_proj.lst
	find . -name '*.o' -delete
