BOOTDIR = boot
KERNELDIR = kernel

MAKE = make

subsystem :
	$(MAKE) -C $(BOOTDIR)
	$(MAKE) -C $(KERNELDIR)

.PHONY : clean

clean :
	$(MAKE) -C $(BOOTDIR) clean
	$(MAKE) -C $(KERNELDIR) clean
