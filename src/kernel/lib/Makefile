NASM = nasm
CC = cc -std=c11 -fno-builtin -fno-stack-protector
RM = rm -rf

lib : atomic.c.o print.s.o intr.s.o intr.c.o string.c.o setup.c.o bitmap.c.o mm.c.o

atomic.c.o : atomic.c
	$(CC) -c -o atomic.c.o atomic.c

print.s.o : print.s
	$(NASM) -f elf64 -o print.s.o print.s

intr.s.o : intr.s
	$(NASM) -f elf64 -o intr.s.o intr.s

intr.c.o : intr.c
	$(CC) -c -o intr.c.o intr.c

string.c.o : string.c
	$(CC) -c -o string.c.o string.c

setup.c.o : setup.c
	$(CC) -c -o setup.c.o setup.c

bitmap.c.o : bitmap.c
	$(CC) -c -o bitmap.c.o bitmap.c

mm.c.o : mm.c
	$(CC) -c -o mm.c.o mm.c

.PHONY : clean

clean :
	@$(RM) *.o
