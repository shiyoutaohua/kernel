#!/bin/bash

disk=~/os/bochs/hd40.img
mbr=~/os/src/boot/mbr.bin
loader=~/os/src/boot/loader.bin
kernel=~/os/src/kernel/kernel.bin

TRASH=/dev/null

# recompile
make clean > ${TRASH} && make > ${TRASH}
# clean disk
dd if=/dev/zero of=$disk bs=512 count=2048 conv=notrunc &> ${TRASH}
# push mbr
dd if=$mbr of=$disk bs=512 count=1 conv=notrunc &> ${TRASH}
# push loader
dd if=$loader of=$disk bs=512 count=4 seek=2 conv=notrunc &> ${TRASH}
# push kernel
dd if=$kernel of=$disk bs=512 count=200 seek=8 conv=notrunc &> ${TRASH}
