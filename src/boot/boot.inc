; loader加载位置(内存)
LOADER_LOAD_BASE    equ 0xd00
; loader起始扇区(磁盘)
LOADER_START_SECTOR equ 2
; loader占据扇区数(磁盘)
LOADER_SECTOR_CNT   equ 4

; 段描述符
K_SEG_CODE64 equ 0x0020980000000000
K_SEG_DATA64 equ 0x0000920000000000
U_SEG_CODE64 equ 0x0020f80000000000
U_SEG_DATA64 equ 0x0000f20000000000

; 内核空间起始地址
KERNEL_SPACE_START  equ 0xffff800000000000
; Kernel加载位置(虚拟内存地址)
KERNEL_LOAD_BASE    equ KERNEL_SPACE_START + 0xf00000
; 内核执行基址(虚拟内存地址)
KERNEL_EXEC_BASE    equ KERNEL_SPACE_START + 0xb00000
; Kernel栈地址
KERNEL_STACK_BASE   equ KERNEL_SPACE_START + 0x800000
; Kernel所在扇区(磁盘)
KERNEL_START_SECTOR equ 8
; Kernel占据扇区数(磁盘)
KERNEL_SECTOR_CNT   equ 200
