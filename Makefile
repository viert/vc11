RM = del
OBJS = kernel/kernel.o

all: vc11.rom

kernel: kernel/kernel.o
	$(MAKE) -C kernel kernel.o

vc11.rom: crt0.asm
	zcc -crt0 crt0 -o vc11.rom $(OBJS)

clean:
	$(RM) vc11.rom zcc_opt.def zcc_proj.lst