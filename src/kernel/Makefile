KERNEL_T = kernel.bin
KERNEL_EXEC_BASE = 0xffff800000b00000
LIBDIR = lib
DEVDIR = dev

CC = cc -std=c11 -fno-builtin -fno-stack-protector
LD = ld
MAKE = make
RM = rm -rf

vmkernel : subsystem $(KERNEL_T)

subsystem :
	$(MAKE) -C $(DEVDIR)
	$(MAKE) -C $(LIBDIR)

$(KERNEL_T) : kernel.c.o lib/print.s.o dev/timer.c.o
	$(LD) -Ttext $(KERNEL_EXEC_BASE) -e main -o $(KERNEL_T) kernel.c.o lib/atomic.c.o lib/print.s.o lib/intr.s.o lib/intr.c.o \
		dev/timer.c.o lib/string.c.o lib/setup.c.o lib/bitmap.c.o lib/mm.c.o

kernel.c.o : kernel.c
	$(CC) -c -o kernel.c.o kernel.c

.PHONY : clean

clean :
	$(MAKE) -C $(DEVDIR) clean
	$(MAKE) -C $(LIBDIR) clean
	@$(RM) *.bin *.o
