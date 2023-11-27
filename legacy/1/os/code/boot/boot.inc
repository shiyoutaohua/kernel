; ----------- Loader -----------
LOADER_BASE_ADDR    equ 0xD00   ; loader加载位置(内存)
LOADER_START_SECTOR equ 0x2     ; loader所在扇区(磁盘)
LOADER_SECTOR_COUNT equ 4       ; loader占据扇区数(磁盘)

; ---------- 段描述符 ----------
DESC_CODE_HIGH4B  equ 00000000_1_1_0_0_1111_1_00_1_1010_00000000b
DESC_DATA_HIGH4B  equ 00000000_1_1_0_0_1111_1_00_1_0010_00000000b
DESC_VIDEO_HIGH4B equ 00000000_1_1_0_0_0000_1_00_1_0010_00001011b

; ---------- 段选择子 ----------
RPL0   equ    00b
RPL1   equ    01b
RPL2   equ    10b
RPL3   equ    11b
TI_GDT equ   000b
TI_LDT equ   100b

; ------------ 页表 ------------
PG_DIR_TAB_ADDR equ 0x100000
PG_USER_WRITE_PRESENT equ 111b

; ----------- Kernel -----------
KERNEL_BASE_ADDR    equ 0xc0e00000         ; Kernel加载位置(虚拟内存地址)
KERNEL_ENTRY_POINT  equ 0xc0800000         ; 内核执行入口(虚拟内存地址)
KERNEL_STACK_ADDR   equ KERNEL_ENTRY_POINT ; Kernel栈地址
KERNEL_START_SECTOR equ 0x9                ; Kernel所在扇区(磁盘)
KERNEL_SECTOR_COUNT equ 200                ; Kernel占据扇区数(磁盘)
