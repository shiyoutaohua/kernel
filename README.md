# kernel
A simple x64 operating system kernel.

# cookbook
```sh
$ mkdir ~/os && mv kernel ~/os && cd ~/os
$ bximage                                                     # make a hd image. PS. see kernel/src/push.sh
$ chmod 755 ~/os/src/push.sh && chmod 755 ~/os/bochs/debug.sh
$ ~/os/src/push.sh                                            # copy bootloader.bin and kernel.bin
$ ~/os/bochs/debug.sh                                         # run for debug
```