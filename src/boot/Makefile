MBR_T = mbr.bin
LOADER_T = loader.bin

NASM = nasm
RM = rm -rf

boot : $(MBR_T) $(LOADER_T)

$(MBR_T) : mbr.s boot.inc
	$(NASM) -o $(MBR_T) mbr.s

$(LOADER_T) : loader.s boot.inc
	$(NASM) -o $(LOADER_T) loader.s

.PHONY : clean

clean :
	@$(RM) *.bin
