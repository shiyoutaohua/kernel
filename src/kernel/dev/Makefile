CC = cc -std=c11 -fno-builtin -fno-stack-protector
RM = rm -rf

device : timer.c.o

timer.c.o : timer.c
	$(CC) -c -o timer.c.o timer.c

.PHONY : clean

clean :
	@$(RM) *.o
