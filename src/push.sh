#!/bin/bash

disk=~/os/bochs/hd64.img
mbr=~/os/src/boot/mbr.bin
loader=~/os/src/boot/loader.bin
kernel=~/os/src/kernel/kernel.bin

trash=/dev/null

# rebuild
make clean > ${trash} && make > ${trash}
# clean disk
dd if=/dev/zero of=$disk bs=1M count=32 conv=notrunc &> ${trash}
# push mbr
dd if=$mbr of=$disk bs=512 count=1 conv=notrunc &> ${trash}
# push loader
dd if=$loader of=$disk bs=512 count=4 seek=2 conv=notrunc &> ${trash}
# push kernel
dd if=$kernel of=$disk bs=512 count=32768 seek=8 conv=notrunc &> ${trash}
