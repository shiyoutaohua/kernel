MBR_T = mbr.bin
LOADER_T = loader.bin

RM = rm -rf
NASM = nasm

all : $(MBR_T) $(LOADER_T)

$(MBR_T) : mbr.asm
	$(NASM) -o $(MBR_T) mbr.asm

$(LOADER_T) : loader.asm
	$(NASM) -o $(LOADER_T) loader.asm

.PHONY : clean

clean :
	@$(RM) *.bin
