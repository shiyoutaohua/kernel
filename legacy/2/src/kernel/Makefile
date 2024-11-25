KERNEL_T = kernel.bin
KERNEL_EXEC_BASE = 0xffff800000b00000
LIBDIR = lib

CC = cc -std=c11 -fno-builtin
LD = ld
RM = rm -rf
MAKE = make

all : subsystem $(KERNEL_T)

subsystem :
	$(MAKE) -C $(LIBDIR)

$(KERNEL_T) : main.o lib/print.o
	$(LD) -Ttext $(KERNEL_EXEC_BASE) -e main -o $(KERNEL_T) main.o lib/print.o

main.o : main.c
	$(CC) -c -o main.o main.c

.PHONY : clean

clean :
	$(MAKE) -C $(LIBDIR) clean
	@$(RM) *.bin *.o
