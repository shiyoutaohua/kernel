; loader加载位置(内存)
LOADER_BASE_ADDR    equ 0xd00
; loader所在扇区(磁盘)
LOADER_BEGIN_SECTOR equ 2
; loader占据扇区数(磁盘)
LOADER_SECTOR_COUNT equ 4

; 段描述符
DESC_CODE32 equ 0x00cf98000000ffff
DESC_DATA32 equ 0x00cf92000000ffff
DESC_CODE64 equ 0x0020980000000000
DESC_DATA64 equ 0x0000920000000000

; 内核空间起始地址
KERNEL_SPACE_START  equ 0xffff800000000000
; Kernel加载位置(虚拟内存地址)
KERNEL_LOAD_ADDR    equ KERNEL_SPACE_START + 0xf00000
; 内核执行基址(虚拟内存地址)
KERNEL_EXEC_BASE    equ KERNEL_SPACE_START + 0xb00000
; Kernel栈地址
KERNEL_STACK_ADDR   equ KERNEL_SPACE_START + 0x800000
; Kernel所在扇区(磁盘)
KERNEL_START_SECTOR equ 8
; Kernel占据扇区数(磁盘)
KERNEL_SECTOR_COUNT equ 200