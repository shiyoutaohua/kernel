RM = rm -rf
NASM = nasm

all : print.o

print.o : print.asm
	$(NASM) -f elf64 -o print.o print.asm

.PHONY : clean

clean :
	@$(RM) *.o
